"""Render a fixed GEMM workload, ordered candidates, and a checked decision."""

from analysis_certificate import FORMATS, MODES, natural, rational, matrix, vector


def render_candidate(candidate, kind):
    fields = {"model"} | ({"input_mode", "multiply_mode", "add_mode"} if kind == "scaled" else set())
    if type(candidate) is not dict or set(candidate) != fields:
        raise ValueError("Invalid selection candidate")
    model = candidate["model"]
    if model not in ({"ampere", "hopper", "hopper_mma"} if kind == "native" else {"v100", "ampere", "hopper"}):
        raise ValueError("Invalid selection model")
    modes = [candidate.get(key, "rne") for key in ("input_mode", "multiply_mode", "add_mode")]
    if any(mode not in MODES for mode in modes):
        raise ValueError("Invalid selection rounding mode")
    mma = model == "hopper_mma"
    return "⟨." + ("hopper" if mma else model) + ", " + ", ".join("." + MODES[mode] for mode in modes) + (", true⟩" if mma else ", false⟩")


def caps_matrix(values, rows, cols):
    if type(values) is not list or len(values) != rows * cols:
        raise ValueError("Entry cap shape mismatch")
    values = [rational(value) for value in values]
    return vector([vector(values[i * cols:(i + 1) * cols]) for i in range(rows)])


def render_selection(case, index):
    cost_policy = case.get("policy") == "minimum_cost"
    if set(case) != {"kind", "workload", "candidates", "tolerance", "selected_index"} | ({"policy", "costs"} if cost_policy else set()):
        raise ValueError("Invalid selection certificate")
    q = case["workload"]
    if type(q) is not dict:
        raise ValueError("Invalid selection workload")
    kind = q.get("operation")
    fields = {"operation", "m", "n", "k"}
    fields |= {"a_bound", "b_bound", "c_bound"} if kind == "family" else {"a", "b", "c"}
    if kind == "scaled":
        fields |= {"input_format", "output_format", "alpha", "beta"}
    if kind == "entry_family":
        fields -= {"a", "b", "c"}
        fields |= {"a_bounds", "b_bounds", "c_bounds"}
    if kind == "native":
        fields.add("precision")
    if kind not in {"raw", "scaled", "family", "entry_family", "native"} or set(q) != fields:
        raise ValueError("Invalid selection workload fields")
    m, n, k = [natural(q[key], key) for key in ("m", "n", "k")]
    configs = case["candidates"]
    if type(configs) is not list or not configs:
        raise ValueError("Selection requires at least one candidate")
    candidates = [render_candidate(c, kind) for c in configs]
    selected = natural(case["selected_index"], "selected index", len(configs))
    lines = [f"def tolerance{index} : Rat := {rational(case['tolerance'])}"]
    if kind == "family":
        bounds = ", ".join(rational(q[key]) for key in ("a_bound", "b_bound", "c_bound"))
        problem = ".family ⟨" + bounds + "⟩"
    elif kind == "entry_family":
        caps = [caps_matrix(q[key], rows, cols) for key, rows, cols in
                (("a_bounds", m, k), ("b_bounds", k, n), ("c_bounds", m, n))]
        problem = ".entryFamily ⟨" + ", ".join(caps) + "⟩"
    else:
        source = q.get("input_format", "fp16")
        if source not in FORMATS or (kind == "scaled" and q["output_format"] != "fp32"):
            raise ValueError("Invalid selection format; output must be FP32")
        width = FORMATS[source]
        if kind == "native":
            precision = q["precision"]
            if precision not in {"bf16", "tf32"} or (precision == "bf16" and any(c["model"] == "hopper_mma" for c in configs)):
                raise ValueError("Invalid native precision and schedule")
            source, width = ("bf16", 16) if precision == "bf16" else ("tf19", 19)
        lines += [f"def a{index} : DenseMatrix (BitVec {source}.width) {m} {k} := {matrix(q['a'], m, k, width)}",
                  f"def b{index} : DenseMatrix (BitVec {source}.width) {k} {n} := {matrix(q['b'], k, n, width)}",
                  f"def c{index} : DenseMatrix F32 {m} {n} := {matrix(q['c'], m, n, 32)}"]
        args = f"a{index} b{index} c{index}"
        if kind == "scaled":
            alpha, beta = [natural(q[key], key, 2 ** 32) for key in ("alpha", "beta")]
            problem = f".scaled {source} {alpha} {beta} {args}"
        elif kind == "native":
            problem = f".native .{precision} {args}"
        else:
            problem = f".raw {args}"
    lines += [f"def problem{index} : GemmProblem {m} {n} {k} := {problem}",
              f"def candidates{index} : List GemmCandidate := [" + ", ".join(candidates) + "]",
              f"def selected{index} : GemmCandidate := {candidates[selected]}", ""]
    if cost_policy:
        costs = case["costs"]
        if type(costs) is not list or len(costs) != len(configs):
            raise ValueError("One cost is required per candidate")
        costs = [rational(cost) for cost in costs]
        entries = [f"⟨{c}, {cost}, {i}⟩" for i, (c, cost) in enumerate(zip(candidates, costs))]
        lines += [f"def costed{index} : List CostedCandidate := [" + ", ".join(entries) + "]",
                  f"def chosen{index} : CostedCandidate := {entries[selected]}", "",
                  f"theorem decision{index} : selectGemmCost problem{index} costed{index} tolerance{index} = some chosen{index} := by decide +kernel", "",
                  f"theorem selection{index} : chosen{index} ∈ costed{index} ∧",
                  f"    problem{index}.Accurate chosen{index}.configuration tolerance{index} ∧",
                  f"    ∀ c ∈ costed{index}, candidateCertified problem{index} tolerance{index} c.configuration = true → chosen{index}.cost ≤ c.cost :=",
                  f"  selectGemmCost_sound problem{index} costed{index} tolerance{index} chosen{index} decision{index}", "",
                  f"theorem accuracy{index} : problem{index}.Accurate selected{index} tolerance{index} := selection{index}.2.1", ""]
    else:
        lines += [f"theorem decision{index} : selectGemm problem{index} candidates{index} tolerance{index} = some {selected} := by decide +kernel", "",
                  f"theorem selection{index} : ∃ hi : {selected} < candidates{index}.length,",
                  f"    problem{index}.Accurate candidates{index}[{selected}] tolerance{index} ∧",
                  f"    ∀ j (hj : j < {selected}), candidateCertified problem{index} tolerance{index} candidates{index}[j] = false :=",
                  f"  selectGemm_sound problem{index} candidates{index} tolerance{index} {selected} decision{index}", "",
                  f"theorem accuracy{index} : problem{index}.Accurate selected{index} tolerance{index} :=",
                  f"  selectGemm_accuracy problem{index} candidates{index} tolerance{index} {selected} selected{index}",
                  f"    decision{index} (by decide +kernel)", ""]
    return lines
