#!/usr/bin/env python3
"""Check matrix indexing, ordered groups, scalar stages, and accepted bounds.

Uses only the independent oracle in this review directory; no repository test
generators, expectations, or oracle functions are imported.
"""
import json
from pathlib import Path
import random
import subprocess
from fractions import Fraction as Q
from collections import Counter
from check_independent import PROFILES, F16, BF16, TF19, F32, decode, round_expected, block_expected

HERE = Path(__file__).resolve().parent
EXE = HERE.parents[1] / "tensor-core/.lake/build/bin/tc_gemm"
RNG = random.Random(7092026)
CLI_MODE = {"rn": "rne", "rz": "rtz", "rd": "rdn", "ru": "rup"}


def model_fields(name):
    if name in ("v100", "ampere", "hopper"):
        return {"operation": "raw", "model": name}, 16
    precision = "bf16" if "bf16" in name else "tf32"
    model = "ampere" if name.startswith("ampere") else "hopper_mma" if name.endswith("_mma") else "hopper"
    return {"operation": "native", "model": model, "precision": precision}, 16 if precision == "bf16" else 8


def chain(name, inner, pairs, initial):
    if decode(F32, initial) is None:
        return None, []
    padded = pairs + [(0, 0)] * ((-len(pairs)) % inner)
    group = PROFILES[name][1]
    result, instructions = initial, []
    for start in range(0, len(padded), inner):
        outputs = []
        for offset in range(start, start + inner, group):
            value = block_expected(name, result, padded[offset:offset + group])
            if not value.isdigit():
                return None, []
            result = int(value)
            outputs.append(result)
        instructions.append(outputs)
    return result, instructions


def pool(fmt):
    p, e, bias = fmt
    sign, one = 1 << (p + e), bias << p
    values = [0, 1, (1 << p) - 1, one, one + 1, one - 1, (bias - 12) << p]
    return values + [w | sign for w in values]


def qtext(x):
    return f"{x.numerator}/{x.denominator}"


def main():
    requests, models, inner_sizes = [], [], []
    for name, (fmt, _, _, _) in PROFILES.items():
        base, inner = model_fields(name)
        for m, n, k in [(1, 1, 0), (1, 1, 1), (1, 1, 7), (1, 1, 8), (1, 1, 9),
                        (1, 1, 15), (1, 1, 16), (1, 1, 17), (2, 3, 33), (17, 1, 1)]:
            requests.append({**base, "m": m, "n": n, "k": k,
                             "a": [RNG.choice(pool(fmt)) for _ in range(m * k)],
                             "b": [RNG.choice(pool(fmt)) for _ in range(k * n)],
                             "c": [RNG.choice(pool(F32)) for _ in range(m * n)]})
            models.append(name)
            inner_sizes.append(inner)
        for mode in CLI_MODE:
            for k in (1, 17):
                requests.append({**base, "operation": "scaled" if base["operation"] == "raw" else "native_scaled",
                                 "input_format": "fp32", "output_format": "fp32",
                                 "input_mode": CLI_MODE[mode], "multiply_mode": CLI_MODE[mode],
                                 "add_mode": CLI_MODE[mode], "output_mode": CLI_MODE[mode],
                                 "alpha": 0x3FC00001, "beta": 0xBF800001,
                                 "m": 1, "n": 1, "k": k,
                                 "a": [RNG.choice(pool(F32)) for _ in range(k)],
                                 "b": [RNG.choice(pool(F32)) for _ in range(k)], "c": [0xBF800001]})
                models.append(name)
                inner_sizes.append(inner)
    data = "".join(json.dumps(r) + "\n" for r in requests)
    (HERE / "matrix-requests.jsonl").write_text(data)
    proc = subprocess.run([str(EXE), "-"], input=data, text=True, capture_output=True, check=True)
    (HERE / "matrix-results.jsonl").write_text(proc.stdout)
    outputs = [json.loads(line) for line in proc.stdout.splitlines()]
    assert len(outputs) == len(requests)
    checked_cells, nonzero_errors, checked_stages = 0, 0, 0
    for request, name, inner, out in zip(requests, models, inner_sizes, outputs):
        m, n, k = (request[x] for x in ("m", "n", "k"))
        fmt = PROFILES[name][0]
        a, b = request["a"], request["b"]
        scaled = request["operation"].endswith("scaled")
        if scaled:
            mode = {v: k for k, v in CLI_MODE.items()}[request["input_mode"]]
            a = [int(round_expected(fmt, mode, decode(F32, x))) for x in a]
            b = [int(round_expected(fmt, mode, decode(F32, x))) for x in b]
        for i in range(m):
            for j in range(n):
                pairs = [(a[i * k + l], b[l * n + j]) for l in range(k)]
                c = request["c"][i * n + j]
                result, instructions = chain(name, inner, pairs, 0 if scaled else c)
                cell = out["rows"][i][j]
                assert result is not None and cell is not None and "bits" in cell, (request, out)
                ideal = sum((decode(fmt, x) * decode(fmt, y) for x, y in pairs), Q(0))
                if scaled:
                    alpha, beta, cv = decode(F32, request["alpha"]), decode(F32, request["beta"]), decode(F32, c)
                    ad = int(round_expected(F32, mode, alpha * decode(F32, result)))
                    bc = int(round_expected(F32, mode, beta * cv))
                    summed = int(round_expected(F32, mode, decode(F32, ad) + decode(F32, bc)))
                    final = int(round_expected(F32, mode, decode(F32, summed)))
                    assert cell["product_bits"] == result and cell["stages"] == [ad, bc, summed], (request, cell)
                    result = final
                    ideal = alpha * ideal + beta * cv
                    original = sum((decode(F32, request["a"][i * k + l]) * decode(F32, request["b"][l * n + j])
                                    for l in range(k)), Q(0))
                    assert out["source_ideal"][i][j] == qtext(alpha * original + beta * cv), (request, out)
                    checked_stages += 4
                else:
                    ideal += decode(F32, c)
                assert cell["bits"] == result and cell["instructions"] == instructions, (request, cell, result, instructions)
                assert out["ideal"][i][j] == qtext(ideal), (request, out, ideal)
                assert cell["value"] == qtext(decode(F32, result)), (request, cell)
                error = abs(ideal - decode(F32, result))
                nonzero_errors += error != 0
                if "error_budget" in cell:
                    assert error <= Q(cell["error_budget"]), (request, cell, error)
                checked_cells += 1

    # A successful analysis must imply successful execution and source-relative
    # accuracy, even when conversion and scalar rounding both lose information.
    analysis = [{**r, "operation": {"raw": "analyze", "native": "analyze_native",
                 "scaled": "analyze_scaled", "native_scaled": "analyze_native_scaled"}[r["operation"]],
                 "absolute_tolerance": "1/10000"} for r in requests]
    p = subprocess.run([str(EXE), "-"], input="".join(json.dumps(r) + "\n" for r in analysis),
                       text=True, capture_output=True, check=True)
    (HERE / "matrix-analysis-results.jsonl").write_text(p.stdout)
    results = [json.loads(line) for line in p.stdout.splitlines()]
    assert len(results) == len(requests)
    accepted = 0
    for r, execution, assessment in zip(requests, outputs, results):
        if not assessment["accepted"]:
            continue
        accepted += 1
        ideal = execution.get("source_ideal", execution["ideal"])
        for i in range(r["m"]):
            for j in range(r["n"]):
                assert abs(Q(ideal[i][j]) - Q(execution["rows"][i][j]["value"])) <= Q(1, 10000)
    report = {"seed": 7092026, "requests": len(requests), "operations": dict(Counter(r["operation"] for r in requests)),
              "profiles": len(PROFILES), "checked_cells": checked_cells, "nonzero_error_cells": nonzero_errors,
              "checked_scalar_stages": checked_stages, "analysis_requests": len(results),
              "accepted_analysis_requests": accepted, "failures": 0}
    (HERE / "matrix-checks.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
