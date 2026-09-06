#!/usr/bin/env python3
"""Generate and kernel-check shared finite-rounding fixtures in two Lean versions.

Python proposes witnesses; both Lean projects independently prove them. No Python
arithmetic result, compiled reflection, or external project's axiom is trusted.
See the root README for scope, limitations, and reproduction instructions.
"""
import argparse
from collections import Counter
from fractions import Fraction as Q
import hashlib
import io
import json
from pathlib import Path
import random
import re
import subprocess
import tarfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PINS = json.loads((HERE / "pins.json").read_text())
FORMATS = {"fp16": (10, 5, 15), "bf16": (7, 8, 127), "tf19": (10, 8, 127),
           "fp32": (23, 8, 127), "fp64": (52, 11, 1023), "e5m2": (2, 5, 15)}
MODES = ("nearestEven", "towardZero", "towardNegative", "towardPositive")
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def extract_sources(tar, destination):
    """Extract only ordinary source files; also works on macOS's Python 3.9."""
    for member in tar.getmembers():
        path = destination / member.name
        if not path.resolve().is_relative_to(destination.resolve()):
            raise RuntimeError(f"Unsafe archive path: {member.name}")
        if member.isdir():
            path.mkdir(parents=True, exist_ok=True)
        elif member.isfile():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(tar.extractfile(member).read())
        else:
            raise RuntimeError(f"Unsupported archive entry: {member.name}")


def run(args, cwd, log=None, fail=False):
    print("Running:", " ".join(map(str, args)), flush=True)
    result = subprocess.run(args, cwd=cwd, text=True, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT)
    if log:
        log.write_text(result.stdout)
    if (result.returncode == 0) == fail:
        raise RuntimeError(f"Unexpected exit {result.returncode}: {args}\n{result.stdout[-5000:]}")
    return result.stdout


def pow2(e):
    return Q(2 ** e) if e >= 0 else Q(1, 2 ** -e)


def log2(x):
    k = x.numerator.bit_length() - x.denominator.bit_length()
    return k - (x < pow2(k))


def inputs(f):
    fb, eb, bias = f
    q = pow2(1 - bias - fb)
    normal = pow2(1 - bias)
    ulp = pow2(-fb)
    topq = pow2(2 ** eb - 2 - bias - fb)
    maximum = (2 ** (fb + 1) - 1) * topq
    positive = [
        ("tiny", q / 4), ("zero_tie", q / 2), ("above_zero_tie", 3 * q / 4),
        ("min_subnormal", q), ("odd_subnormal_tie", 3 * q / 2),
        ("even_subnormal_tie", 5 * q / 2), ("max_subnormal", normal - q),
        ("normal_transition_tie", normal - q / 2), ("min_normal", normal),
        ("min_normal_tie", normal + q / 2), ("below_one", 1 - ulp / 4),
        ("one", Q(1)), ("below_halfway", 1 + ulp / 4),
        ("even_tie", 1 + ulp / 2), ("above_halfway", 1 + 3 * ulp / 4),
        ("odd_tie", 1 + 3 * ulp / 2), ("carry_tie", 2 - ulp / 2),
        ("near_max", maximum - topq / 2), ("max_finite", maximum),
        ("nondyadic", Q(1, 3)),
    ]
    rng = random.Random(20260906 + fb)
    for i in range(4):
        positive.append((f"seeded_{i}", Q(rng.randrange(1, 1000), rng.randrange(3, 1000))
                         * pow2(rng.randrange(-8, 8))))
    values = [("zero", Q(0))]
    for label, x in positive:
        assert 0 < x <= maximum
        values.extend([(label, x), ("negative_" + label, -x)])
    return values


def witness(f, mode, x):
    """Untrusted candidate bits and FLoPS coefficient/exponent for an exact input."""
    fb, eb, bias = f
    e = max(log2(abs(x)) - fb, 1 - bias - fb) if x else 1 - bias - fb
    scaled = abs(x) / pow2(e)
    k, remainder = divmod(scaled.numerator, scaled.denominator)
    if mode == "nearestEven":
        k += 2 * remainder > scaled.denominator or (
            2 * remainder == scaled.denominator and k % 2 == 1)
    elif mode == "towardNegative" and x < 0 or mode == "towardPositive" and x > 0:
        k += remainder != 0
    if k == 2 ** (fb + 1):
        k //= 2
        e += 1
    bits = (int(x < 0) << (fb + eb)) + (
        k if k < 2 ** fb else (e + fb + bias) * 2 ** fb + k - 2 ** fb)
    return bits, -k if x < 0 else k, e


def literal(x, typ):
    return f"(({x.numerator} : {typ}) / {x.denominator})"


def tc_theorem(c, name=None, bad=False):
    name = name or c["id"]
    b, m, e = c["bits"] + int(bad), c["coefficient"], c["exponent"]
    x = literal(Q(c["numerator"], c["denominator"]), "Rat")
    return f"""theorem {name} :
    roundBinary {c['format']} .{c['mode']} {x} = some (BitVec.ofNat _ {b}) ∧
    binaryValue {c['format']} (BitVec.ofNat _ {b}) =
      some (({m} : Rat) * pow2 ({e})) := by decide +kernel
#print axioms {name}
"""


def flops_theorem(c, name=None, bad=False):
    name = name or c["id"]
    fb, eb, bias = FORMATS[c["format"]]
    fmt = f"fmt_{c['format']}"
    xq = Q(c["numerator"], c["denominator"])
    x = literal(xq, "ℝ")
    m, e = c["coefficient"] + int(bad), c["exponent"]
    out = f"(⟨{m}, {e}⟩ : float 2)"
    if c["mode"] == "nearestEven":
        op = f"@rne_abs {fmt} {x}"
        contract = f"@nearest_even 2 {fmt} {x} {out}"
        correct = f"@rne_abs_correct {fmt} {x}"
    elif c["mode"] == "towardZero":
        op = f"@round_to_zero_all {fmt} {x}"
        contract = f"(if 0 ≤ {x} then @rounddown 2 {fmt} {x} {out} else @roundup 2 {fmt} {x} {out})"
        correct = f"@roundzero_roundzero {fmt} {x}"
    else:
        up = c["mode"] == "towardPositive"
        rnd = "⌈.⌉" if up else "⌊.⌋"
        direction = "roundup" if up else "rounddown"
        op = f"@round_fp {fmt} (Function.const ℤ ({rnd})) {x}"
        contract = f"@{direction} 2 {fmt} {x} {out}"
        correct = f"@{direction}_real_{direction} {fmt} {x}"
    proof = ""
    if xq:
        k = log2(abs(xq))
        grid = max(k - fb, 1 - bias - fb)
        proof = f"""    have hlog : Int.log 2 |{x}| = ({k} : ℤ) := by
      apply Eq.symm
      apply log_eq_of_bound <;> norm_num
    have hexp : @fexp_real' {fmt} {x} = ({grid} : ℤ) := by
      simp only [fexp_real', hlog]
      norm_num [{fmt}]
    simp only [rne_abs, round_to_zero_all, round_fp, round_fp_ne0, scaled_mantissa, hexp]
"""
    return f"""theorem {name} : {op} = {out} ∧ {contract} := by
  have h : {op} = {out} := by
{proof}    norm_num [rne_abs, round_to_zero_all, round_fp, {fmt}, round_choice_abs,
      to_even', Int.fract, vnum, round, Int.even_iff, Int.odd_iff, Function.const]
  exact ⟨h, h ▸ ({correct})⟩
#print axioms {name}
"""


def audit(output, count):
    records = re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", output)
    if len(records) != count or "sorryAx" in output:
        raise RuntimeError("Missing theorem audits or placeholder in Lean output")
    axioms = {a.strip() for _, ax in records for a in ax.split(",") if a.strip()}
    if not axioms <= ALLOWED_AXIOMS:
        raise RuntimeError(f"Unexpected axioms: {axioms - ALLOWED_AXIOMS}")
    return sorted(axioms)


def prepare(work):
    archive = work / "flops.tar.gz"
    rev = PINS["flops_commit"]
    if not archive.exists():
        run(["curl", "--fail", "--silent", "--show-error", "--location",
             f"https://codeload.github.com/rutgers-apl/FLoPS/tar.gz/{rev}",
             "--output", str(archive)], ROOT)
    data = archive.read_bytes()
    if sha(data) != PINS["flops_archive_sha256"]:
        raise RuntimeError("FLoPS archive does not match the pin")
    vendor = work / f"FLoPS-{rev}"
    with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as tar:
        if not vendor.exists():
            # The hash above authenticates this exact, previously inspected archive.
            extract_sources(tar, work)
        for member in tar.getmembers():
            if member.isfile() and (work / member.name).read_bytes() != tar.extractfile(member).read():
                raise RuntimeError(f"Modified FLoPS source: {member.name}")
    tc = work / ("tc-" + PINS["tc_commit"])
    tc.mkdir(exist_ok=True)
    source = subprocess.check_output(["git", "archive", PINS["tc_commit"], "tensor-core"], cwd=ROOT)
    with tarfile.open(fileobj=io.BytesIO(source)) as tar:
        extract_sources(tar, tc)
    tc /= "tensor-core"
    for project, key in ((tc, "tc_lean"), (vendor, "flops_lean")):
        if (project / "lean-toolchain").read_text().strip() != PINS[key]:
            raise RuntimeError("Toolchain pin mismatch")
    if not (vendor / ".lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Data/Real/Basic.olean").exists():
        run(["lake", "exe", "cache", "get"], vendor, work / "dependencies.log")
    run(["lake", "build", "TensorCore.Foundations.BinaryRounding"], tc, work / "tc-build.log")
    run(["lake", "build", "Flops.Core.RoundOp"], vendor, work / "flops-build.log")
    return tc, vendor


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--formats", nargs="+", choices=FORMATS, default=list(FORMATS))
    parser.add_argument("--work-dir", type=Path, default=ROOT / "tmp/flops-crosscheck")
    args = parser.parse_args()
    work = args.work_dir.resolve()
    work.mkdir(parents=True, exist_ok=True)
    report_path = work / "report.json"
    report_path.unlink(missing_ok=True)  # A failed rerun must not retain a passing report.
    tc, vendor = prepare(work)
    cases = []
    for fmt in args.formats:
        for label, x in inputs(FORMATS[fmt]):
            for mode in MODES:
                bits, m, e = witness(FORMATS[fmt], mode, x)
                cases.append(dict(id=f"check_{len(cases):04d}", format=fmt, mode=mode,
                                  label=label, numerator=x.numerator, denominator=x.denominator,
                                  bits=bits, coefficient=m, exponent=e))
    fixture_text = json.dumps(cases, indent=2) + "\n"
    (work / "fixtures.json").write_text(fixture_text)
    tc_header = "import TensorCore.Foundations.BinaryRounding\nopen TensorCore\nset_option maxRecDepth 8192\nset_option maxHeartbeats 4000000\n"
    flops_header = "import Flops.Core.RoundOp\nimport Mathlib.Tactic.NormNum\nset_option maxRecDepth 8192\nset_option maxHeartbeats 4000000\nset_option exponentiation.threshold 2048\nset_option linter.unusedSimpArgs false\n"
    for fmt in args.formats:
        fb, _, bias = FORMATS[fmt]
        flops_header += f"def fmt_{fmt} : Format := ⟨{fb+1}, {bias+fb-1}, {bias}, by decide⟩\n"
    audits, hashes = {}, {}
    for label, project, header, theorem in (
            ("tc", tc, tc_header, tc_theorem),
            ("flops", vendor, flops_header, flops_theorem)):
        text = header + "\n".join(theorem(c) for c in cases)
        path = project / "Crosscheck.lean"
        path.write_text(text)
        output = run(["lake", "env", "lean", path.name], project, work / f"{label}-proofs.log")
        audits[label] = audit(output, len(cases))
        hashes[label] = sha(text.encode())
        # A wrong result for an ordinary, nonzero input must fail on both sides.
        control = next(c for c in cases if c["label"] == "one" and c["mode"] == "nearestEven")
        negative = project / "NegativeControl.lean"
        negative.write_text(header + theorem(control, "wrong_result", bad=True))
        failure = run(["lake", "env", "lean", negative.name], project,
                      work / f"{label}-negative-control.log", fail=True)
        if "error:" not in failure or "wrong_result" not in failure:
            raise RuntimeError("Negative control did not fail in its proof")
    report = dict(status="passed", pins=PINS, cases=len(cases),
                  cases_by_format=dict(Counter(c["format"] for c in cases)),
                  cases_by_mode=dict(Counter(c["mode"] for c in cases)),
                  theorem_roots_audited=2 * len(cases), axioms=audits,
                  negative_controls_rejected=2, fixtures_sha256=sha(fixture_text.encode()),
                  generated_lean_sha256=hashes,
                  scope="Concrete finite conversion/decoded-value agreement with FLoPS Core rounding contracts",
                  limitations=["Not a universal equivalence theorem", "No tensor-core accumulation validation",
                               "No signed-zero equivalence (FLoPS Core has a single mathematical zero)",
                               "No overflow, NaN, infinity, or P3109 bit-encoding comparison",
                               "No separate scalar-operation or error-bound cross-check"])
    report_path.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2), flush=True)


if __name__ == "__main__":
    main()
