#!/usr/bin/env python3
"""Evaluate GEMM decisions, independent numerical bounds, and kernel certificates."""

from collections import Counter
from fractions import Fraction as Q
import hashlib
import json
from pathlib import Path
import platform
import tempfile
import time

from analyze import theory_hash
from analysis_certificate import certificate_text
from check_analysis import run, TOOL, BINARY, cases as raw_cases
from check_gemm import oracle, PROFILES
from check_gemm_extensions import converted, scaled_expected, source_expected, value, DEPENDENCIES
from check_pipeline_analysis import scaled_cases, family_cases


ROOT = Path(__file__).resolve().parents[1]


def evaluate(requests):
    start = time.perf_counter()
    proc = run([BINARY, "-"], text="".join(json.dumps(q) + "\n" for q in requests))
    results = [json.loads(line) for line in proc.stdout.splitlines()]
    assert len(results) == len(requests)
    return results, time.perf_counter() - start


def analysis_request(q, candidate):
    w = q["workload"]
    kind = w["operation"]
    result = {**w, **candidate, "operation": {"raw": "analyze", "scaled": "analyze_scaled", "family": "analyze_family"}[kind],
              "absolute_tolerance": q["absolute_tolerance"]}
    if kind == "scaled":
        result["output_mode"] = "rne"
    return result


def workloads():
    result = []
    fields = {"operation", "m", "n", "k", "a", "b", "c"}
    for kind, cases in [("raw", raw_cases()), ("scaled", scaled_cases()), ("family", family_cases())]:
        for q in cases:
            if q["model"] != "v100" or (kind == "scaled" and q["output_format"] != "fp32"):
                continue
            keys = fields
            if kind == "scaled":
                keys = fields | {"input_format", "output_format", "alpha", "beta"}
            if kind == "family":
                keys = {"operation", "m", "n", "k", "a_bound", "b_bound", "c_bound"}
            w = {key: q[key] for key in keys}
            w["operation"] = kind
            candidates = [{"model": model} for model in PROFILES]
            if kind == "scaled":
                candidates = [dict(model=model, input_mode=mode, multiply_mode=q["multiply_mode"], add_mode=q["add_mode"])
                              for model in PROFILES for mode in ["rup", "rne", "rdn", "rtz"]]
            for tol in (["0/1", "1/1000000", "1/100"] if kind != "scaled" else ["1/1000000", "1/100"]):
                result.append(dict(operation="select", name=q["name"], workload=w, candidates=candidates,
                                   absolute_tolerance=tol))
    return result


def actual_error(q, analysis):
    kind = q["operation"]
    if kind == "analyze_family":
        return None, 0
    a, b = (converted(q, "a"), converted(q, "b")) if kind == "analyze_scaled" else (q["a"], q["b"])
    if a is None or b is None:
        assert not analysis["accepted"]
        return None, 0
    errors, checked, success = [], 0, True
    for i in range(q["m"]):
        for j in range(q["n"]):
            if kind == "analyze":
                out, ideal = oracle(q, i, j)
                out = None if "error" in out else out
            else:
                out, _ = scaled_expected(q, a, b, i, j)
                ideal = source_expected(q, a, b, i, j, tight=True)[0] if out is not None else None
            cell = analysis["rows"][i][j]
            if out is None:
                assert cell is None
                success = False
            else:
                error = abs(ideal - value(out["bits"], "fp32"))
                errors.append(error)
                if cell is not None:
                    assert error <= Q(cell["error_bound"])
                    checked += 1
    return (max(errors, default=Q(0)) if success else None), checked


def main():
    start = time.perf_counter()
    run(["lake", "build", "TensorCore.Gemm.Regression.GemmSelection", "tc_gemm"])
    requests = workloads()
    results, seconds = evaluate(requests)
    standalone = [analysis_request(q, c) for q in requests for c in q["candidates"]]
    analyses, baseline_seconds = evaluate(standalone)
    counts = {kind: Counter() for kind in ["raw", "scaled", "family"]}
    cursor, checked = 0, 0
    for q, result in zip(requests, results):
        stats = counts[q["workload"]["operation"]]
        stats["requests"] += 1
        reports = result["candidates"]
        expected = analyses[cursor:cursor + len(reports)]
        native_requests = standalone[cursor:cursor + len(reports)]
        cursor += len(reports)
        assert len(reports) == len(q["candidates"])
        first = next((i for i, r in enumerate(expected) if r["accepted"]), None)
        assert result["selected_index"] == first
        assert result["accepted"] == (first is not None)
        assert result["policy"] == "first_certified_in_preference_order"
        assert result["selected_candidate"] == (None if first is None else q["candidates"][first])
        stats["selected" if first is not None else "inconclusive"] += 1
        stats["later_candidate_selected"] += int(first is not None and first > 0)
        for index, (reported, r, native) in enumerate(zip(reports, expected, native_requests)):
            assert reported == dict(index=index, configuration=q["candidates"][index], analysis=r)
            error, cells = actual_error(native, r)
            checked += cells
            stats["candidate_analyses"] += 1
            stats["certified_candidates"] += int(r["accepted"])
            if error is not None:
                meets = error <= Q(q["absolute_tolerance"])
                assert not r["accepted"] or meets
                stats["oracle_successful_candidates"] += 1
                stats["oracle_within_tolerance"] += int(meets)
                stats["within_tolerance_but_uncertified"] += int(meets and not r["accepted"])
        if first is None:
            assert result["selected_request"] is None and result["reason"] == "no_candidate_certified"
        else:
            emitted = result["selected_request"]
            assert emitted["model"] == q["candidates"][first]["model"]
            expected_request = {**native_requests[first], "operation": q["workload"]["operation"]}
            if expected_request["operation"] == "family":
                expected_request["operation"] = "analyze_family"
            else:
                del expected_request["absolute_tolerance"]
            assert emitted == expected_request

    examples = [json.loads(line) for line in (ROOT / "data/examples/gemm.selection.jsonl").read_text().splitlines()]
    examples = [{**q, "absolute_tolerance": "1/1000000"} for q in examples]
    demo, _ = evaluate(examples)
    assert [r["selected_index"] for r in demo] == [1, 0, 1]
    executed, _ = evaluate([r["selected_request"] for r in demo])
    assert executed[0]["rows"][0][0]["bits"] == 0x3f800008
    assert executed[1]["accepted"]
    assert executed[2]["rows"][0][0]["bits"] == 0x3f800000

    controls = []
    with tempfile.TemporaryDirectory(prefix="tc selection ") as directory:
        folder = Path(directory)
        q = examples[0]
        variants = [{**q, "candidates": list(reversed(q["candidates"]))},
                    {**q, "candidates": [q["candidates"][1]] * 2},
                    {**q, "absolute_tolerance": "1/2000000"},
                    {**q, "absolute_tolerance": "0/1"}]
        choices, _ = evaluate(variants)
        assert [r["selected_index"] for r in choices] == [0, 0, 2, None]
        controls += ["preference_order", "duplicate_tie", "tighter_tolerance", "no_candidate"]
        invalid = [{**q, "candidates": []}, {**q, "candidates": [{"model": "unknown"}]},
                   {**q, "name": 3}, {**q, "candidates": [q["candidates"][1], {"model": "unknown"}]},
                   {**q, "candidates": [{"model": "v100", "input_mode": "rne"}]},
                   {**q, "cost": 1}, {**q, "workload": {**q["workload"], "m": -1}},
                   {**q, "workload": {**q["workload"], "a": []}},
                   {**examples[2], "workload": {**examples[2]["workload"], "output_format": "fp16"}},
                   {**examples[2], "candidates": [{"model": "hopper", "input_mode": "rne"}]}]
        for bad in invalid:
            run([BINARY, "-"], text=json.dumps(bad) + "\n", code=2)
        controls.append("invalid_configuration_and_workload_rejected")
        exported = examples + variants[:3]
        fp64 = next(q for q in requests if q["workload"].get("input_format") == "fp64"
                    and q["absolute_tolerance"] == "1/100" and q["name"] == "source-formats-modes")
        exported.append(fp64)
        path = folder / "Selections.lean"
        manifest = {"theory_sha256": theory_hash(), "cases": []}
        replay_results, _ = evaluate(exported)
        for q, r in zip(exported, replay_results):
            assert r["accepted"]
            manifest["cases"].append(dict(kind="selection", workload=q["workload"], candidates=q["candidates"],
                                          tolerance=q["absolute_tolerance"], selected_index=r["selected_index"]))
        generation_start = time.perf_counter()
        path.write_text(certificate_text(manifest))
        certificate_bytes = path.stat().st_size
        generation_seconds = time.perf_counter() - generation_start
        replay_start = time.perf_counter()
        replay = json.loads(run([TOOL, "verify", path]).stdout)
        replay_seconds = time.perf_counter() - replay_start
        assert replay["cases"] == len(exported) and replay["status"] == "kernel_checked"
        for name in ["selected-index", "preference-order", "tolerance", "source-word", "rounding-mode", "family-range"]:
            changed = json.loads(json.dumps(manifest))
            if name == "selected-index":
                changed["cases"][0]["selected_index"] = 0
            elif name == "preference-order":
                changed["cases"][0]["candidates"].reverse()
            elif name == "tolerance":
                changed["cases"][0]["tolerance"] = "0/1"
            elif name == "source-word":
                changed["cases"][2]["workload"]["a"][0] = 0x7fc00000
            elif name == "rounding-mode":
                changed["cases"][2]["candidates"][0]["input_mode"] = "rne"
            else:
                changed["cases"][1]["workload"]["c_bound"] = str(2 ** 128) + "/1"
            bad = folder / "Changed.lean"
            bad.write_text(certificate_text(changed))
            run([TOOL, "verify", bad], code=1)
            controls.append(name + "_rejected_by_kernel")
        emitted = folder / "CLI.lean"
        input_file = folder / "workload with spaces.jsonl"
        input_file.write_text("".join(json.dumps(q) + "\n" for q in examples))
        run([TOOL, "select", input_file, "--abs-tol", "1e-6", "--emit", emitted])
        run([TOOL, "verify", emitted])
        run([TOOL, "select", input_file, "--abs-tol", "1e-6", "--emit", emitted], code=2)
        refusal = folder / "Refused.lean"
        run([TOOL, "select", input_file, "--abs-tol", "0", "--emit", refusal], code=1)
        assert not refusal.exists()
        assert json.loads(run([TOOL, "schema", "select"]).stdout) == json.loads((ROOT / "data/schemas/selection.schema.json").read_text())
        run([TOOL, "select", "-", "--abs-tol", "-1"], text=json.dumps(q), code=2)
        stdin = run([TOOL, "select", "-", "--abs-tol", "1e-6"], text=input_file.read_text())
        assert [json.loads(line)["selected_index"] for line in stdin.stdout.splitlines()] == [1, 0, 1]
        for cap in ["-1", "1/0", "nan", 0.5]:
            invalid_family = {**examples[1], "workload": {**examples[1]["workload"], "a_bound": cap}}
            run([TOOL, "select", "-", "--abs-tol", "1"], text=json.dumps(invalid_family), code=2)
        altered = folder / "Appended.lean"
        altered.write_text(path.read_text() + '\n#eval IO.println "unexpected"\n')
        run([TOOL, "verify", altered], code=2)
        controls += ["stdin_file_agreement", "invalid_family_caps", "appended_commands_rejected"]
        controls += ["cli_export_and_replay", "existing_export_preserved", "inconclusive_export_refused", "schema"]
        audit = DEPENDENCIES.replace("import TensorCore.Gemm.TightInputBounds", "import TensorCore.Gemm.Cli.GemmSelection")
        audit = audit.replace("``TensorCore.gemm,", "``TensorCore.evalPrepared, ``TensorCore.PreparedBlock.accumulator, "
                              "``TensorCore.PreparedBlock.exactDot, ``TensorCore.PaperSpec.convertedMatrix, ``TensorCore.gemm,")
        dependency_file = folder / "Dependencies.lean"
        roots = ["selectGemm", "candidateCertified", "GemmProblem.infer", "GemmProblem.check", "Cli.Selection.evaluate"]
        dependency_file.write_text(audit + "".join(f"run_cmd audit ``TensorCore.{root}\n" for root in roots))
        run(["lake", "env", "lean", dependency_file])
        dependency_file.write_text(audit + "noncomputable def hidden := @TensorCore.gemm\nnoncomputable def contaminated := @hidden\nrun_cmd audit ``contaminated\n")
        assert "Forbidden executable dependency" in run(["lake", "env", "lean", dependency_file], code=1).stdout
        controls.append("transitive_input_only_audit")

    scaling = []
    for size in [1, 4, 16]:
        q = dict(operation="select", workload=dict(operation="raw", m=size, n=size, k=64,
                 a=[0x0c00] * (size * 64), b=[0x0c00] * (64 * size), c=[0x3f800000] * (size * size)),
                 candidates=[dict(model=m) for m in PROFILES], absolute_tolerance="1/100000")
        rows, duration = evaluate([q])
        assert rows[0]["accepted"]
        scaling.append(dict(m=size, n=size, k=64, candidates=3, selected_index=rows[0]["selected_index"],
                            native_process_seconds=round(duration, 4)))
    sources = [ROOT / name for name in ["TensorCore/Gemm/Selection.lean", "TensorCore/Gemm/Cli/GemmSelection.lean",
               "TensorCore/Gemm/Cli/GemmInput.lean", "TensorCore/Gemm/Regression/GemmSelection.lean", "scripts/select_gemm.py",
               "scripts/selection_certificate.py", "scripts/check_selection.py", "data/examples/gemm.selection.jsonl",
               "data/schemas/selection.schema.json"]]
    report = dict(status="passed", requests=len(requests), candidate_analyses=len(standalone), checked_output_cells=checked,
                  workload_sha256=hashlib.sha256(json.dumps(requests, sort_keys=True, separators=(",", ":")).encode()).hexdigest(),
                  environment=dict(system=platform.system(), release=platform.release(), machine=platform.machine(),
                                   python=platform.python_version(), toolchain=(ROOT / "lean-toolchain").read_text().strip()),
                  by_workload={kind: dict(count) for kind, count in counts.items()},
                  native_selection_batch_seconds=round(seconds, 3), native_analysis_batch_seconds=round(baseline_seconds, 3),
                  certificate_cases=len(exported), certificate_bytes=certificate_bytes,
                  certificate_render_seconds=round(generation_seconds, 4), kernel_replay_seconds=round(replay_seconds, 3),
                  kernel_replay=True, input_only_dependency_audit=True, negative_controls=controls, scaling=scaling,
                  elapsed_seconds=round(time.perf_counter() - start, 3),
                  source_sha256={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
                  limitations=["Deterministic synthetic and boundary workloads, not a representative application benchmark.",
                               "Counts depend on the supplied candidate lists and tolerances; they are not population estimates.",
                               "Oracle accuracy is checked on concrete encoded inputs; family guarantees use quantified Lean proofs.",
                               "Selection prioritizes the input order among certified candidates; it does not prove actual-error or GPU-speed optimality.",
                               "CPU timings include process startup; selection reports all candidates and reevaluates the selected prefix."])
    (ROOT / "data/regressions/selection-report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
