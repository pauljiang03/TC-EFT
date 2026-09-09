#!/usr/bin/env python3
"""Replay the extra review checks against the exact reviewed Lean sources."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PROJECT = ROOT / "tensor-core" if (ROOT / "tensor-core").is_dir() else ROOT
LOGS = HERE / "tmp"


def main():
    if not __debug__:
        raise SystemExit("Run without Python -O: oracle checks use assertions.")
    provenance = json.loads((HERE / "review-provenance.json").read_text())
    if (PROJECT / "lean-toolchain").read_text().strip() != provenance["toolchain"]:
        raise SystemExit("Lean toolchain differs from the reviewed toolchain.")
    sources = provenance["source_files"]
    if not sources:
        raise SystemExit("Empty source manifest.")
    changed = [name for name, digest in sources.items()
               if not (ROOT / name).is_file()
               or hashlib.sha256((ROOT / name).read_bytes()).hexdigest() != digest]
    actual = {str(path.relative_to(ROOT))
              for path in (PROJECT / "TensorCore").rglob("*.lean")}
    changed.extend(sorted(actual - set(sources)))
    if changed:
        raise SystemExit("Theory differs from reviewed source manifest: " + ", ".join(changed))
    LOGS.mkdir(exist_ok=True)
    results = []

    def run(name, command, cwd, expect_failure=False):
        print(f"Running {name}...", flush=True)
        result = subprocess.run(command, cwd=cwd, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        (LOGS / f"{name}.log").write_text(result.stdout)
        passed = result.returncode == 0
        if expect_failure:
            passed = result.returncode != 0 and "error: Tactic `decide` failed" in result.stdout
        results.append({"check": name, "exit_code": result.returncode,
                        "expected_failure": expect_failure, "passed": passed})
        (LOGS / "reproduction-results.json").write_text(json.dumps({
            "reviewed_commit": provenance["commit"], "source_hashes_match": True,
            "steps": results,
        }, indent=2) + "\n")
        if not passed:
            print(result.stdout, file=sys.stderr)
            raise SystemExit(f"{name} failed; see {LOGS / (name + '.log')}")
        print(f"PASS {name}", flush=True)

    for name in ("build_probe", "check_independent", "check_gemm_independent"):
        run(name, [sys.executable, str(HERE / f"{name}.py")], ROOT)
    relative = HERE.relative_to(ROOT)
    for name in ("TrustAudit", "ScopeWitnesses", "RefusalWitness"):
        run(name, ["lake", "env", "lean", "-t", "0",
                   str(ROOT / relative / f"{name}.lean")], PROJECT)
    run("certificate", ["./tc", "verify", str(relative / "AccuracyCertificate.lean")], ROOT)
    run("negative_certificate", ["lake", "env", "lean", "-t", "0",
                                 str(ROOT / relative / "TamperedCertificate.lean")],
        PROJECT, expect_failure=True)
    print(f"All independent review checks passed. Logs: {LOGS}")


if __name__ == "__main__":
    main()
