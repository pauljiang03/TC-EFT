"""Render a fixed GEMM workload, ordered candidates, and a checked decision."""

from analysis_certificate import FORMATS, MODES, natural, rational, matrix


def render_candidate(candidate, kind):
    fields = {"model"} | ({"input_mode", "multiply_mode", "add_mode"} if kind == "scaled" else set())
    if type(candidate) is not dict or set(candidate) != fields:
        raise ValueError("Invalid selection candidate")
    model = candidate["model"]
    if model not in {"v100", "ampere", "hopper"}:
        raise ValueError("Invalid selection model")
    modes = [candidate.get(key, "rne") for key in ("input_mode", "multiply_mode", "add_mode")]
    if any(mode not in MODES for mode in modes):
        raise ValueError("Invalid selection rounding mode")
    return "⟨." + model + ", " + ", ".join("." + MODES[mode] for mode in modes) + "⟩"


def render_selection(case, index):
    if set(case) != {"kind", "workload", "candidates", "tolerance", "selected_index"}:
        raise ValueError("Invalid selection certificate")
    q = case["workload"]
    if type(q) is not dict:
        raise ValueError("Invalid selection workload")
    kind = q.get("operation")
    fields = {"operation", "m", "n", "k"}
    fields |= {"a_bound", "b_bound", "c_bound"} if kind == "family" else {"a", "b", "c"}
    if kind == "scaled":
        fields |= {"input_format", "output_format", "alpha", "beta"}
    if kind not in {"raw", "scaled", "family"} or set(q) != fields:
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
    else:
        source = q.get("input_format", "fp16")
        if source not in FORMATS or (kind == "scaled" and q["output_format"] != "fp32"):
            raise ValueError("Invalid selection format; output must be FP32")
        width = FORMATS[source]
        lines += [f"def a{index} : DenseMatrix (BitVec {source}.width) {m} {k} := {matrix(q['a'], m, k, width)}",
                  f"def b{index} : DenseMatrix (BitVec {source}.width) {k} {n} := {matrix(q['b'], k, n, width)}",
                  f"def c{index} : DenseMatrix F32 {m} {n} := {matrix(q['c'], m, n, 32)}"]
        args = f"a{index} b{index} c{index}"
        if kind == "scaled":
            alpha, beta = [natural(q[key], key, 2 ** 32) for key in ("alpha", "beta")]
            problem = f".scaled {source} {alpha} {beta} {args}"
        else:
            problem = f".raw {args}"
    lines += [f"def problem{index} : GemmProblem {m} {n} {k} := {problem}",
              f"def candidates{index} : List GemmCandidate := [" + ", ".join(candidates) + "]",
              f"def selected{index} : GemmCandidate := {candidates[selected]}", "",
              f"theorem decision{index} : selectGemm problem{index} candidates{index} tolerance{index} = some {selected} := by decide +kernel", "",
              f"theorem selection{index} : ∃ hi : {selected} < candidates{index}.length,",
              f"    problem{index}.Accurate candidates{index}[{selected}] tolerance{index} ∧",
              f"    ∀ j (hj : j < {selected}), candidateCertified problem{index} tolerance{index} candidates{index}[j] = false :=",
              f"  selectGemm_sound problem{index} candidates{index} tolerance{index} {selected} decision{index}", "",
              f"theorem accuracy{index} : problem{index}.Accurate selected{index} tolerance{index} :=",
              f"  selectGemm_accuracy problem{index} candidates{index} tolerance{index} {selected} selected{index}",
              f"    decision{index} (by decide +kernel)", ""]
    return lines
