#!/usr/bin/env python3
"""Check inferred bounds against exact GEMM and replay exported proofs."""

from fractions import Fraction as Q
import hashlib
import json
from pathlib import Path
import random
import subprocess
import tempfile
import time

from analyze import HEADER, certificate_text
from check_gemm import oracle, PROFILES
from check_features import val32
from check_gemm_extensions import DEPENDENCIES


ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / "tc"
BINARY = ROOT / ".lake/build/bin/tc_gemm"
SEED = 20260907


def run(command, *, text=None, cwd=ROOT, code=0):
    p = subprocess.run([str(x) for x in command], input=text, cwd=cwd, text=True, capture_output=True)
    assert p.returncode == code, (command, p.returncode, p.stdout, p.stderr)
    return p


def cases():
    rng = random.Random(SEED)
    base = []

    def add(name, m, n, k, a, b, c):
        base.append(dict(name=name, m=m, n=n, k=k, a=a, b=b, c=c))

    add("tiny", 1, 1, 17, [0x0c00] * 17, [0x0c00] * 17, [0x3f800000])
    add("negative-tiny", 1, 1, 17, [0x8c00] * 17, [0x0c00] * 17, [0xbf800000])
    add("zero", 1, 1, 1, [0], [0x8000], [0x80000000])
    add("empty-k", 1, 2, 0, [], [], [0x80000000, 0x7f7fffff])
    add("negative-subnormal", 1, 1, 1, [0x8001], [1], [0])
    add("exact-integers", 1, 1, 1, [0xbc00], [0x4000], [0])
    add("finite-boundary", 1, 2, 1, [0], [0, 0], [0x7f7fffff, 0xff7fffff])
    add("overflow", 1, 1, 1, [0x3c00], [0x3c00], [0x7f7fffff])
    add("conservative-range", 1, 1, 1, [0xbc00], [0x3c00], [0x7f7fffff])
    add("nonfinite-product", 1, 1, 1, [0x7c00], [0], [0])
    add("nonfinite-c", 1, 1, 0, [], [], [0x7fc00000])
    add("empty-rows", 0, 2, 5, [], [0] * 10, [])
    add("empty-cols", 2, 0, 5, [0] * 10, [], [])
    add("changing-scales", 1, 1, 17, [1] * 16 + [0x7800], [0x3c00] * 17, [0])
    words = [0, 0x8000, 1, 0x8001, 0x0c00, 0x8c00, 0x3400, 0xb400,
             0x3c00, 0xbc00, 0x3555, 0xb555, 0x7bff, 0xfbff]
    for i in range(24):
        m, n, k = rng.choice([1, 2, 3]), rng.choice([1, 2, 3]), rng.choice([1, 4, 8, 16, 17, 31, 64])
        add(f"random-{i}", m, n, k, [rng.choice(words) for _ in range(m * k)],
            [rng.choice(words) for _ in range(k * n)],
            [rng.choice([0, 1, 0x80000001, 0x3f800000, 0xbf800000]) for _ in range(m * n)])
    return [{**c, "operation": "analyze", "model": model, "absolute_tolerance": "1/100000"}
            for model in PROFILES for c in base]


def main():
    start = time.perf_counter()
    report_path = ROOT / "data/regressions/analysis-report.json"
    report_path.write_text('{"status":"running"}\n')
    run(["lake", "build", "TensorCore.Gemm.Regression.GemmAnalysis", "tc_gemm"])
    requests = cases()
    text = "".join(json.dumps(q) + "\n" for q in requests)
    analysis_start = time.perf_counter()
    proc = run([BINARY, "-"], text=text)
    analysis_seconds = time.perf_counter() - analysis_start
    results = [json.loads(line) for line in proc.stdout.splitlines()]
    assert len(requests) == len(results)
    checked, unavailable, accepted = 0, 0, 0
    for request, result in zip(requests, results):
        errors = []
        for i, row in enumerate(result["rows"]):
            assert len(row) == request["n"]
            for j, cell in enumerate(row):
                expected, ideal = oracle(request, i, j)
                if cell is None:
                    unavailable += 1
                    continue
                assert "error" not in expected, (request["name"], expected)
                actual = val32(expected["bits"])
                bound = Q(cell["error_bound"])
                assert abs(ideal - actual) <= bound, (request["name"], ideal, actual, bound)
                assert abs(actual) <= Q(cell["magnitude_bound"])
                assert bound == Q(cell["alignment_bound"]) + Q(cell["rounding_bound"])
                errors.append(bound)
                checked += 1
        complete = len(errors) == request["m"] * request["n"]
        assert result["bounds_valid"] == complete
        if complete:
            assert Q(result["matrix_bound"]) == sum(errors, Q(0))
            assert Q(result["max_entry_bound"]) == max(errors, default=Q(0))
        else:
            assert result["matrix_bound"] is None and result["max_entry_bound"] is None
        assert result["accepted"] == (complete and max(errors, default=Q(0)) <= Q(1, 100000))
        assert result["status"] == ("certified" if result["accepted"] else "inconclusive")
        accepted += result["accepted"]
        if request["name"] == "conservative-range":
            assert "error" not in oracle(request, 0, 0)[0] and not complete
        if request["name"] == "changing-scales":
            assert len({w["scale"] for w in result["rows"][0][0]["witness"]}) > 1

    comparisons = []
    for model, carry in [("v100", 3), ("ampere", 4), ("hopper", 5)]:
        ix = next(i for i, q in enumerate(requests) if q["model"] == model and q["name"] == "tiny")
        old_request = {**requests[ix], "operation": "certify", "accumulator_scale": 0,
                       "product_scale": -24, "carry_bits": carry, "initial_bound": 1}
        old = json.loads(run([BINARY, "-"], text=json.dumps(old_request) + "\n").stdout)
        assert old["accepted"]
        new_bound = Q(results[ix]["max_entry_bound"])
        old_bound = Q(old["entry_bound"])
        assert new_bound < old_bound
        comparisons.append(dict(model=model, previous_bound=str(old_bound), inferred_bound=str(new_bound),
                                improvement_factor=float(old_bound / new_bound)))
        neg = next(r for q, r in zip(requests, results) if q["model"] == model and q["name"] == "negative-tiny")
        assert neg["rows"] == results[ix]["rows"]

    controls = []
    with tempfile.TemporaryDirectory(prefix="tc analysis review ") as directory:
        folder = Path(directory)
        audit = DEPENDENCIES.replace("import TensorCore.Gemm.TightInputBounds",
                                     "import TensorCore.Gemm.Analysis")
        audit = audit.replace("``TensorCore.gemm,", "``TensorCore.evalPrepared, ``TensorCore.PreparedBlock.accumulator, "
                              "``TensorCore.PreparedBlock.exactDot, ``TensorCore.PaperSpec.wmmaGemm, ``TensorCore.gemm,")
        dependency_file = folder / "Dependencies.lean"
        dependency_file.write_text(audit + '''run_cmd do
  audit ``TensorCore.analyzeGemm
  audit ``TensorCore.gemmAnalysisCheck
  audit ``TensorCore.inferGroups
  audit ``TensorCore.checkGroups
''')
        run(["lake", "env", "lean", dependency_file])
        for root in ["TensorCore.runBlocks", "TensorCore.idealProducts", "TensorCore.PaperSpec.wmmaGemm"]:
            dependency_file.write_text(audit + f"noncomputable def hidden := @{root}\nnoncomputable def contaminated := @hidden\nrun_cmd audit ``contaminated\n")
            result = run(["lake", "env", "lean", dependency_file], code=1)
            assert "Forbidden executable dependency" in result.stdout + result.stderr, result.stdout + result.stderr
        controls.append("transitive_execution_and_ideal_dependencies_rejected")
        fixture = ROOT / "data/examples/gemm.analysis.jsonl"
        local = folder / "workload with spaces.jsonl"
        local.write_text(fixture.read_text())
        certificate = folder / "Certificate.lean"
        exported = run([TOOL, "analyze", local.name, "--abs-tol", "1e-5", "--emit", certificate.name], cwd=folder)
        replay = json.loads(run([TOOL, "verify", certificate.name], cwd=folder).stdout)
        assert replay["status"] == "kernel_checked" and replay["cases"] == 3
        assert run([TOOL, "analyze", "-", "--abs-tol", "1/100000"], text=fixture.read_text()).stdout == exported.stdout
        original = certificate.read_text()
        run([TOOL, "analyze", local, "--abs-tol", "1e-5", "--emit", certificate], code=2)
        assert certificate.read_text() == original
        controls.append("existing_certificate_preserved")
        manifest = json.loads(original.splitlines()[0][len(HEADER):])
        bad = folder / "Bad.lean"
        bad.write_text(original + "#eval IO.println 7\n")
        assert "canonical" in run([TOOL, "verify", bad], code=2).stderr
        controls.append("extra_lean_commands_rejected")
        for name in ["tolerance", "group_scale", "group_count"]:
            changed = json.loads(json.dumps(manifest))
            if name == "tolerance":
                changed["cases"][0]["tolerance"] = "0/1"
            elif name == "group_scale":
                changed["cases"][0]["witness"][0][0][0]["scale"] = -126
            else:
                changed["cases"][0]["witness"][0][0].pop()
            bad.write_text(certificate_text(changed))
            run([TOOL, "verify", bad], code=1)
            controls.append(name + "_rejected_by_kernel")
        changed = json.loads(json.dumps(manifest))
        changed["theory_sha256"] = "0" * 64
        bad.write_text(certificate_text(changed))
        assert "theory hash" in run([TOOL, "verify", bad], code=2).stderr
        controls.append("different_theory_rejected")
        missing = folder / "NotCreated.lean"
        out = run([TOOL, "analyze", local, "--abs-tol", "0", "--emit", missing], code=1)
        assert not missing.exists() and all(not json.loads(line)["accepted"] for line in out.stdout.splitlines())
        controls.append("inconclusive_not_exported")
        for tol in ["-1", "1/0", "nan"]:
            run([TOOL, "analyze", local, "--abs-tol=" + tol], code=2)
        controls.append("invalid_tolerances_rejected")
        for tol in ["-1/1", "1/0", "1e-5"]:
            request = {**requests[0], "absolute_tolerance": tol}
            run([BINARY, "-"], text=json.dumps(request) + "\n", code=2)
        controls.append("native_rational_validation")
    sources = [ROOT / "TensorCore/TC/Program/Bounds/Local.lean",
               ROOT / "TensorCore/TC/Program/GroupAnalysis.lean", ROOT / "TensorCore/Gemm/Analysis.lean",
               ROOT / "TensorCore/Gemm/Regression/GemmAnalysis.lean", ROOT / "TensorCore/Gemm/Cli/Analysis.lean",
               ROOT / "scripts/analyze.py", ROOT / "scripts/analysis_certificate.py", Path(__file__).resolve()]
    report = dict(status="passed", seed=SEED, matrices=len(requests), checked_output_cells=checked,
                  unavailable_cells=unavailable, certified_requests=accepted, certificate_cases=3,
                  kernel_replay=True, negative_controls=controls, comparisons=comparisons,
                  input_only_dependency_audit=True,
                  native_analysis_seconds=round(analysis_seconds, 3),
                  elapsed_seconds=round(time.perf_counter() - start, 3),
                  source_sha256={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
                  limitations=["Concrete raw FP16-to-FP32 GEMM under three specified WMMA schedules.",
                               "Unsigned magnitude propagation can be conservative under cancellation.",
                               "Timing measures CPU analysis, not GPU kernel performance."])
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
