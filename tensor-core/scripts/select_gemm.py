#!/usr/bin/env python3
"""Select the first certified GEMM candidate and export its Lean decision proof."""

import argparse
from fractions import Fraction
import json
from pathlib import Path
import subprocess
import sys

from analyze import PROJECT, theory_hash
from analysis_certificate import certificate_text


def select(path, tolerance, emit):
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
        raise ValueError("Theory source changed during the selection build")
    content = sys.stdin.read() if path == "-" else Path(path).read_text()
    requests = []
    for number, line in enumerate(content.splitlines(), 1):
        if not line.strip():
            continue
        q = json.loads(line)
        if type(q) is not dict or q.get("operation", "select") != "select":
            raise ValueError(f"Line {number}: expected a selection request")
        q.update(operation="select", absolute_tolerance=f"{tol.numerator}/{tol.denominator}")
        workload = q.get("workload")
        if type(workload) is not dict:
            raise ValueError(f"Line {number}: expected a workload object")
        if workload.get("operation") == "family":
            for key in ("a_bound", "b_bound", "c_bound"):
                if type(workload.get(key)) is not str:
                    raise ValueError(f"Line {number}: {key} must be an exact decimal or rational string")
                value = Fraction(workload[key])
                if value < 0:
                    raise ValueError(f"Line {number}: {key} must be nonnegative")
                workload[key] = f"{value.numerator}/{value.denominator}"
        requests.append(q)
    proc = subprocess.run([str(PROJECT / ".lake/build/bin/tc_gemm"), "-"], cwd=PROJECT,
                          input="".join(json.dumps(q) + "\n" for q in requests),
                          text=True, capture_output=True)
    print(proc.stdout, end="")
    if proc.stderr:
        print(proc.stderr, end="", file=sys.stderr)
    if proc.returncode:
        return proc.returncode
    if before != theory_hash():
        raise ValueError("Theory source changed during selection; no certificate emitted")
    if emit:
        results = [json.loads(line) for line in proc.stdout.splitlines()]
        if len(results) != len(requests) or not results or not all(r["accepted"] for r in results):
            print("tc: certificate not emitted because some requests have no certified candidate", file=sys.stderr)
            return 1
        cases = [dict(kind="selection", workload=q["workload"], candidates=q["candidates"],
                      tolerance=q["absolute_tolerance"], selected_index=r["selected_index"])
                 for q, r in zip(requests, results)]
        content = certificate_text(dict(theory_sha256=before, cases=cases))
        with emit.open("x") as stream:
            stream.write(content)
        print(f"Certificate written: {emit}. Run ./tc verify to check it in Lean.", file=sys.stderr)
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input")
    parser.add_argument("--abs-tol", required=True)
    parser.add_argument("--emit", type=Path)
    args = parser.parse_args()
    return select(args.input, args.abs_tol, args.emit)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, TypeError, ZeroDivisionError) as error:
        print(f"tc: {error}", file=sys.stderr)
        sys.exit(2)
