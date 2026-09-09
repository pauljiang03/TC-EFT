#!/usr/bin/env python3
"""Run GEMM analysis and replay canonical Lean certificates."""

import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

from analysis_certificate import HEADER, SCALED_FIELDS, certificate_text


PROJECT = Path(__file__).resolve().parents[1]


def theory_hash():
    digest = hashlib.sha256()
    paths = [PROJECT / "lean-toolchain", *sorted((PROJECT / "TensorCore").rglob("*.lean"))]
    for path in paths:
        digest.update(str(path.relative_to(PROJECT)).encode() + b"\0" + path.read_bytes() + b"\0")
    return digest.hexdigest()


def verify(path):
    content = path.read_text()
    first = content.splitlines()[0] if content else ""
    if not first.startswith(HEADER):
        raise ValueError("Expected a certificate produced by tc analyze or tc select --emit")
    manifest = json.loads(first[len(HEADER):])
    if certificate_text(manifest) != content:
        raise ValueError("Certificate is not in the canonical data-and-proof format")
    if manifest["theory_sha256"] != theory_hash():
        raise ValueError("Certificate theory hash differs from this checkout")
    build = subprocess.run(["lake", "build", "TensorCore.Gemm.CostSelection"], cwd=PROJECT,
                           stdout=sys.stderr)
    if build.returncode:
        return build.returncode
    if manifest["theory_sha256"] != theory_hash():
        raise ValueError("Theory source changed during the verification build")
    with tempfile.TemporaryDirectory(prefix="tc-certificate-") as directory:
        checked = Path(directory) / "Certificate.lean"
        checked.write_text(content)
        proc = subprocess.run(["lake", "env", "lean", str(checked)], cwd=PROJECT,
                              text=True, capture_output=True)
    if proc.stdout or proc.stderr:
        print(proc.stdout + proc.stderr, file=sys.stderr, end="")
    if proc.returncode:
        return proc.returncode
    if manifest["theory_sha256"] != theory_hash():
        raise ValueError("Theory source changed during verification")
    print(json.dumps({"status": "kernel_checked", "cases": len(manifest["cases"]),
                      "theory_sha256": manifest["theory_sha256"]}))
    return 0


def normalize_rational(value):
    if type(value) is not str:
        raise ValueError("Expected an exact decimal or rational string")
    q = Fraction(value)
    if q < 0:
        raise ValueError("Expected a nonnegative rational")
    return f"{q.numerator}/{q.denominator}"


def normalize_entry_caps(request):
    if request.get("operation") in {"entry_family", "analyze_entry_family"}:
        for key in ("a_bounds", "b_bounds", "c_bounds"):
            if type(request.get(key)) is not list:
                raise ValueError("Expected entry cap arrays")
            request[key] = [normalize_rational(value) for value in request[key]]


def analyze(path, tolerance, emit):
    tol = Fraction(tolerance)
    if tol < 0:
        raise ValueError("Tolerance must be nonnegative")
    if emit and emit.exists():
        raise ValueError(f"Certificate already exists: {emit}")
    before = theory_hash()
    build = subprocess.run(["lake", "build", "tc_gemm"], cwd=PROJECT, stdout=sys.stderr)
    if build.returncode:
        return build.returncode
    if before != theory_hash():
        raise ValueError("Theory source changed during the analysis build")
    content = sys.stdin.read() if path == "-" else Path(path).read_text()
    requests = []
    for number, line in enumerate(content.splitlines(), 1):
        if not line.strip():
            continue
        request = json.loads(line)
        operations = {"raw": "analyze", "analyze": "analyze", "scaled": "analyze_scaled",
                      "analyze_scaled": "analyze_scaled", "family": "analyze_family", "analyze_family": "analyze_family", "native": "analyze_native", "analyze_native": "analyze_native",
                      "native_scaled": "analyze_native_scaled", "analyze_native_scaled": "analyze_native_scaled",
                      "entry_family": "analyze_entry_family", "analyze_entry_family": "analyze_entry_family"}
        if not isinstance(request, dict) or request.get("operation", "raw") not in operations:
            raise ValueError(f"Line {number}: expected raw, scaled, native, native_scaled, family, or entry_family analysis")
        request = {**request, "operation": operations[request.get("operation", "raw")],
                   "absolute_tolerance": f"{tol.numerator}/{tol.denominator}"}
        if request["operation"] == "analyze_family":
            for key in ("a_bound", "b_bound", "c_bound"):
                if type(request.get(key)) is not str:
                    raise ValueError(f"Line {number}: {key} must be an exact decimal or rational string")
                value = Fraction(request[key])
                if value < 0:
                    raise ValueError(f"Line {number}: {key} must be nonnegative")
                request[key] = f"{value.numerator}/{value.denominator}"
        normalize_entry_caps(request)
        requests.append(request)
    proc = subprocess.run([str(PROJECT / ".lake/build/bin/tc_gemm"), "-"], cwd=PROJECT,
                          input="".join(json.dumps(q) + "\n" for q in requests),
                          text=True, capture_output=True)
    print(proc.stdout, end="")
    if proc.stderr:
        print(proc.stderr, end="", file=sys.stderr)
    if proc.returncode:
        return proc.returncode
    if before != theory_hash():
        raise ValueError("Theory source changed during analysis; no certificate emitted")
    if emit:
        results = [json.loads(line) for line in proc.stdout.splitlines()]
        if len(results) != len(requests) or not results or not all(r["accepted"] for r in results):
            print("tc: certificate not emitted because some requests were not certified", file=sys.stderr)
            return 1
        cases = []
        for request, result in zip(requests, results):
            if request["operation"] == "analyze_native_scaled":
                fields = {"precision", "m", "n", "k", "a", "b", "c", "input_format", "output_format", "output_mode", "alpha", "beta"}
                workload = {key: request[key] for key in fields}
                workload["operation"] = "native_scaled"
                candidate = {key: request[key] for key in ("model", "input_mode", "multiply_mode", "add_mode")}
                cases.append(dict(kind="selection", workload=workload, candidates=[candidate],
                                  tolerance=request["absolute_tolerance"], selected_index=0))
                continue
            if request["operation"] in {"analyze_native", "analyze_entry_family"}:
                native = request["operation"] == "analyze_native"
                fields = {"m", "n", "k"} | ({"precision", "a", "b", "c"} if native else {"a_bounds", "b_bounds", "c_bounds"})
                workload = {key: request[key] for key in fields}
                workload["operation"] = "native" if native else "entry_family"
                cases.append(dict(kind="selection", workload=workload, candidates=[{"model": request["model"]}],
                                  tolerance=request["absolute_tolerance"], selected_index=0))
                continue
            fields = {"model", "m", "n", "k"}
            if request["operation"] == "analyze_family":
                fields |= {"a_bound", "b_bound", "c_bound"}
                case = {key: request[key] for key in fields}
                case.update(kind="family", witness=result["witness"])
            else:
                fields |= {"a", "b", "c"}
                if request["operation"] == "analyze_scaled":
                    fields |= SCALED_FIELDS
                case = {key: request[key] for key in fields}
                if request["operation"] == "analyze_scaled":
                    case["kind"] = "scaled"
                case["witness"] = [[cell["witness"] for cell in row] for row in result["rows"]]
            case["tolerance"] = request["absolute_tolerance"]
            cases.append(case)
        manifest = {"theory_sha256": before, "cases": cases}
        text = certificate_text(manifest)
        with emit.open("x") as stream:
            stream.write(text)
        print(f"Certificate written: {emit}. Run ./tc verify to check it in Lean.", file=sys.stderr)
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input")
    parser.add_argument("--verify", action="store_true")
    parser.add_argument("--abs-tol")
    parser.add_argument("--emit", type=Path)
    args = parser.parse_args()
    if args.verify:
        return verify(Path(args.input))
    if args.abs_tol is None:
        parser.error("--abs-tol is required")
    return analyze(args.input, args.abs_tol, args.emit)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, ZeroDivisionError) as error:
        print(f"tc: {error}", file=sys.stderr)
        sys.exit(2)
