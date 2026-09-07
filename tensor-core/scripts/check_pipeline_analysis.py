#!/usr/bin/env python3
"""Check scaled and quantified-family analysis with independent rational oracles."""

from fractions import Fraction as Q
import hashlib
import json
from pathlib import Path
import random
import tempfile
import time

from analysis_certificate import HEADER, certificate_text
from check_analysis import run, TOOL, BINARY
from check_gemm import oracle, PROFILES
from check_gemm_extensions import converted, scaled_expected, source_expected, rounded, value, FORMATS, MODES, DEPENDENCIES


ROOT = Path(__file__).resolve().parents[1]
SEED = 20260908
BUDGETS = ["alignment_bound", "rounding_bound", "alpha_rounding_bound", "beta_rounding_bound",
           "add_rounding_bound", "output_rounding_bound", "input_conversion_bound"]


def scaled_cases():
    base = dict(operation="analyze_scaled", model="v100", m=1, n=1, k=1,
                a=[0xbf801000], b=[0x3f801000], c=[0], input_format="fp32", output_format="fp32",
                input_mode="rne", multiply_mode="rne", add_mode="rne", output_mode="rne",
                alpha=0x3f800000, beta=0, absolute_tolerance="1/100")
    requests = []
    for model in PROFILES:
        for fmt in FORMATS:
            for mode in MODES:
                requests.append({**base, "name": "source-formats-modes", "model": model, "input_format": fmt,
                                 "input_mode": mode, "multiply_mode": mode, "add_mode": mode, "output_mode": mode,
                                 "a": [rounded(-Q(2049, 2048), fmt, "rne")],
                                 "b": [rounded(Q(2049, 2048), fmt, "rne")]})
    for target in FORMATS:
        for mode in MODES:
            requests.append({**base, "name": "output-formats-modes", "output_format": target, "output_mode": mode})
    special = [
        ("signed-zero", dict(a=[0x80000000], b=[0], c=[0x80000000], beta=0x80000000, absolute_tolerance="0/1")),
        ("negative-subnormal", dict(a=[0x80000001], b=[1], input_mode="rdn")),
        ("exact-products", dict(a=[0xbf800000], b=[0x40000000])),
        ("finite-boundary", dict(k=0, a=[], b=[], c=[0x7f7fffff], beta=0x3f800000)),
        ("negative-boundary", dict(k=0, a=[], b=[], c=[0xff7fffff], beta=0x3f800000)),
        ("alpha-overflow", dict(a=[0x40000000], b=[0x3f800000], alpha=0x7f7fffff)),
        ("beta-overflow", dict(k=0, a=[], b=[], c=[0x7f7fffff], beta=0x40000000)),
        ("sum-overflow", dict(a=[0x3f800000], b=[0x3f800000], alpha=0x7f7fffff, c=[0x7f7fffff], beta=0x3f800000)),
        ("output-overflow", dict(a=[0x477fe000], b=[0x40000000], output_format="fp16")),
        ("zero-alpha-nonfinite-source", dict(alpha=0, a=[0x7fc00000])),
        ("zero-alpha-nonfinite-alpha", dict(alpha=0x7f800000, a=[0])),
        ("zero-beta-nonfinite-c", dict(beta=0, c=[0x7fc00000])),
        ("conversion-range-rejection", dict(a=[0x47800000], input_mode="rtz")),
        ("empty-rows", dict(m=0, a=[], c=[])),
        ("empty-cols", dict(n=0, b=[], c=[])),
        ("empty-cols-conversion-rejection", dict(n=0, a=[0x7fc00000], b=[], c=[])),
        ("empty-k", dict(m=2, n=2, k=0, a=[], b=[], c=[0, 0x80000000, 1, 0x80000001], beta=0)),
    ]
    for model in PROFILES:
        requests += [{**base, **fields, "name": name, "model": model} for name, fields in special]
    rng = random.Random(SEED)
    pool = [Q(0), Q(1, 2 ** 24), -Q(1, 2 ** 24), Q(1, 2 ** 12), Q(1), Q(-1), Q(2049, 2048), -Q(2049, 2048)]
    for model in PROFILES:
        for index in range(16):
            m, n, k = rng.choice([1, 2, 3]), rng.choice([1, 2, 3]), rng.choice([1, 4, 8, 16, 17, 31])
            fmt = rng.choice(list(FORMATS))
            requests.append({**base, "name": f"rectangular-{index}", "model": model, "m": m, "n": n, "k": k,
                             "input_format": fmt, "input_mode": rng.choice(MODES), "multiply_mode": rng.choice(MODES),
                             "add_mode": rng.choice(MODES), "output_mode": rng.choice(MODES),
                             "a": [rounded(rng.choice(pool), fmt, "rne") for _ in range(m * k)],
                             "b": [rounded(rng.choice(pool), fmt, "rne") for _ in range(k * n)],
                             "c": [rng.choice([0, 0x80000001, 0x3f800000, 0xbf800000]) for _ in range(m * n)],
                             "alpha": rng.choice([0, 0xbf800000, 0x3f000000, 0x40000000]),
                             "beta": rng.choice([0, 0x3f800000, 0xbf000000])})
    return requests


def family_cases():
    families = [("unit", 17, "1/1", "1/1", "1/1"),
                ("small", 31, "1/4096", "1/4096", "1/1"),
                ("subnormal", 1, "1/16777216", "1/16777216", "0/1"),
                ("zero", 16, "0/1", "0/1", "0/1"),
                ("finite-boundary", 1, "65504/1", "65504/1", str(value(0x7f7fffff, "fp32")) + "/1"),
                ("empty-k", 0, "0/1", "0/1", str(value(0x7f7fffff, "fp32")) + "/1")]
    return [dict(operation="analyze_family", name=name, model=model, m=2, n=3, k=k,
                 a_bound=a, b_bound=b, c_bound=c, absolute_tolerance="1/100")
            for model in PROFILES for name, k, a, b, c in families]


def evaluate(requests):
    proc = run([BINARY, "-"], text="".join(json.dumps(q) + "\n" for q in requests))
    results = [json.loads(line) for line in proc.stdout.splitlines()]
    assert len(results) == len(requests)
    return results


def main():
    start = time.perf_counter()
    run(["lake", "build", "TensorCore.Regression.PipelineAnalysis", "TensorCore.Regression.GemmFamily", "tc_gemm"])
    requests = scaled_cases()
    results = evaluate(requests)
    checked, unavailable, rejected_inputs = 0, 0, 0
    for q, result in zip(requests, results):
        a, b = converted(q, "a"), converted(q, "b")
        if a is None or b is None:
            assert result["input_conversion_rejected"] and not result["accepted"] and result["rows"] is None
            rejected_inputs += 1
            continue
        assert not result["input_conversion_rejected"]
        bounds = []
        for i, row in enumerate(result["rows"]):
            assert len(row) == q["n"]
            for j, cell in enumerate(row):
                expected, _ = scaled_expected(q, a, b, i, j)
                if cell is None:
                    unavailable += 1
                    continue
                assert expected is not None, q
                ideal, input_bound = source_expected(q, a, b, i, j, tight=True)
                actual = value(expected["bits"], q["output_format"])
                bound = Q(cell["error_bound"])
                assert abs(ideal - actual) <= bound, (q, ideal, actual, cell)
                assert abs(actual) <= Q(cell["magnitude_bound"])
                assert all(Q(cell[field]) >= 0 for field in BUDGETS)
                assert bound == sum((Q(cell[field]) for field in BUDGETS), Q(0))
                assert Q(cell["input_conversion_bound"]) == abs(value(q["alpha"], "fp32")) * input_bound
                if q["output_format"] == "fp32":
                    assert Q(cell["output_rounding_bound"]) == 0
                bounds.append(bound)
                checked += 1
        complete = len(bounds) == q["m"] * q["n"]
        assert result["bounds_valid"] == complete
        assert result["accepted"] == (complete and max(bounds, default=Q(0)) <= Q(q["absolute_tolerance"]))
        if complete:
            assert Q(result["matrix_bound"]) == sum(bounds, Q(0))
            assert Q(result["max_entry_bound"]) == max(bounds, default=Q(0))
        else:
            assert result["matrix_bound"] is None
        if q["name"] in {"alpha-overflow", "beta-overflow", "sum-overflow", "output-overflow", "zero-alpha-nonfinite-alpha", "zero-beta-nonfinite-c"}:
            assert not complete
        if q["name"] == "signed-zero":
            assert result["accepted"] and bounds == [0]

    families = family_cases()
    family_results = evaluate(families)
    rng = random.Random(SEED + 1)
    samples = 0
    for q, result in zip(families, family_results):
        if q["name"] == "finite-boundary":
            assert not result["bounds_valid"]
            continue
        assert result["bounds_valid"] and result["accepted"], (q, result)
        budget = Q(result["entry_bound"])
        assert Q(result["matrix_bound"]) == q["m"] * q["n"] * budget
        for _ in range(12):
            raw = {key: q[key] for key in ("model", "m", "n", "k")}
            for key, count, fmt in [("a", q["m"] * q["k"], "fp16"), ("b", q["k"] * q["n"], "fp16"), ("c", q["m"] * q["n"], "fp32")]:
                pool = ([0, 0x8000, 1, 0x8001, 0x0c00, 0x8c00, 0x3c00, 0xbc00] if fmt == "fp16" else
                        [0, 0x80000000, 1, 0x80000001, 0x3f800000, 0xbf800000, 0x7f7fffff, 0xff7fffff])
                pool = [word for word in pool if abs(value(word, fmt)) <= Q(q[key + "_bound"])]
                raw[key] = [rng.choice(pool) for _ in range(count)]
            for i in range(q["m"]):
                for j in range(q["n"]):
                    expected, ideal = oracle(raw, i, j)
                    assert "error" not in expected
                    assert abs(ideal - value(expected["bits"], "fp32")) <= budget
                    samples += 1

    controls = []
    with tempfile.TemporaryDirectory(prefix="tc pipeline analysis ") as directory:
        folder = Path(directory)
        audit = DEPENDENCIES.replace("import TensorCore.Programs.GemmTightInputBounds",
                                     "import TensorCore.Programs.ConvertedGemmAnalysis\nimport TensorCore.Programs.GemmFamily")
        audit = audit.replace("``TensorCore.gemm,", "``TensorCore.evalPrepared, ``TensorCore.PreparedBlock.accumulator, "
                              "``TensorCore.PreparedBlock.exactDot, ``TensorCore.PaperSpec.convertedMatrix, "
                              "``TensorCore.PaperSpec.scalarEpilogue, ``TensorCore.gemm,")
        dependency_file = folder / "Dependencies.lean"
        roots = ["analyzeConvertedGemm", "convertedAnalysisCheck", "inferFamily", "familyCheck", "checkEpilogue", "checkScalar"]
        dependency_file.write_text(audit + "".join(f"run_cmd audit ``TensorCore.{root}\n" for root in roots))
        run(["lake", "env", "lean", dependency_file])
        for root in ["TensorCore.gemmEpilogue", "TensorCore.sourceGemmProducts", "TensorCore.PaperSpec.convertedMatrix"]:
            dependency_file.write_text(audit + f"noncomputable def hidden := @{root}\nnoncomputable def contaminated := @hidden\nrun_cmd audit ``contaminated\n")
            assert "Forbidden executable dependency" in run(["lake", "env", "lean", dependency_file], code=1).stdout
        controls.append("transitive_input_only_audit")
        exported_requests = [q for q, r in zip(requests, results)
                             if q["name"] == "source-formats-modes" and q["input_format"] == "fp64" and q["input_mode"] in {"rne", "rdn"} and r["accepted"]]
        exported_requests += [q for q in families if q["name"] == "unit"]
        exported_requests += [q for q in requests if q["name"] == "signed-zero"]
        exported_requests.append(json.loads((ROOT / "data/examples/gemm.analysis.jsonl").read_text().splitlines()[0]))
        workload = folder / "scaled and families.jsonl"
        workload.write_text("".join(json.dumps(q) + "\n" for q in exported_requests))
        certificate = folder / "Certificate.lean"
        run([TOOL, "analyze", workload, "--abs-tol", "1/100", "--emit", certificate])
        replay = json.loads(run([TOOL, "verify", certificate]).stdout)
        assert replay["cases"] == len(exported_requests) and replay["status"] == "kernel_checked"
        manifest = json.loads(certificate.read_text().splitlines()[0][len(HEADER):])
        bad = folder / "Bad.lean"
        for name in ["alpha-scale", "sum-scale", "missing-group", "source-value", "family-cap", "family-carry", "tolerance"]:
            changed = json.loads(json.dumps(manifest))
            if name == "family-cap":
                changed["cases"][6]["a_bound"] = "65504/1"
            elif name == "family-carry":
                changed["cases"][6]["witness"]["carry_bits"] = 0
            elif name == "source-value":
                changed["cases"][0]["a"][0] = 0x7ff0000000000000
            elif name == "tolerance":
                changed["cases"][0]["tolerance"] = "0/1"
            elif name == "missing-group":
                changed["cases"][0]["witness"][0][0]["groups"].pop()
            else:
                changed["cases"][0]["witness"][0][0][name.replace("-", "_")] = -126
            bad.write_text(certificate_text(changed))
            run([TOOL, "verify", bad], code=1)
            controls.append(name + "_rejected_by_kernel")
        failed = folder / "NoCertificate.lean"
        run([TOOL, "analyze", workload, "--abs-tol", "0", "--emit", failed], code=1)
        assert not failed.exists()
        controls.append("mixed_inconclusive_export_refused")
        for invalid in ["-1", "1/0", "nan", 1.25]:
            q = {**families[0], "a_bound": invalid}
            run([TOOL, "analyze", "-", "--abs-tol", "1"], text=json.dumps(q) + "\n", code=2)
        controls.append("invalid_family_ranges_rejected")
        for path in ["gemm.scaled-analysis.jsonl", "gemm.family.jsonl"]:
            output = run([TOOL, "analyze", ROOT / "data/examples" / path, "--abs-tol", "0.01"])
            assert all(json.loads(line)["accepted"] for line in output.stdout.splitlines())
    sources = [ROOT / name for name in ["TensorCore/Programs/ScalarAnalysis.lean",
               "TensorCore/Programs/ScaledGemmAnalysis.lean", "TensorCore/Programs/ConvertedGemmAnalysis.lean",
               "TensorCore/Programs/GemmFamily.lean", "TensorCore/Theory/Binary/MagnitudeScale.lean",
               "TensorCore/Cli/PipelineAnalysis.lean", "TensorCore/Regression/PipelineAnalysis.lean",
               "TensorCore/Regression/GemmFamily.lean", "scripts/analyze.py", "scripts/analysis_certificate.py",
               "scripts/check_pipeline_analysis.py"]]
    report = dict(status="passed", seed=SEED, scaled_requests=len(requests), checked_output_cells=checked,
                  unavailable_cells=unavailable, input_conversion_rejections=rejected_inputs,
                  family_requests=len(families), sampled_family_output_cells=samples,
                  certificate_cases=len(exported_requests), kernel_replay=True,
                  input_only_dependency_audit=True, negative_controls=controls,
                  elapsed_seconds=round(time.perf_counter() - start, 3),
                  source_sha256={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
                  limitations=["Family samples test the implementation; the Lean theorem quantifies over all family members.",
                               "Input families currently cover uniform finite raw FP16/FP32 magnitude bounds.",
                               "Scaled analysis can be conservative under cancellation or exact nonzero scalar stages."])
    (ROOT / "data/regressions/pipeline-analysis-report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
