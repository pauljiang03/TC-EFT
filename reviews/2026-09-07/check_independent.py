#!/usr/bin/env python3
"""Independent exact-value probes; no imports from repository validation code.

Rounding is selected from the ordered set of encoded finite values (binary
search or exhaustive tiny-format enumeration), without copying the converter's
logarithm, coefficient, carry, or encoder algorithms. Block alignment uses
integer shifts. These check the declared model, not physical GPU conformance.
"""
from bisect import bisect_left
from collections import Counter
from fractions import Fraction as Q
from functools import lru_cache
import json
from pathlib import Path
import random
import subprocess
import sys

HERE = Path(__file__).resolve().parent
RNG = random.Random(20260907)
MODES = ("rn", "rz", "rd", "ru")
F16, BF16, TF19, F32, F64 = (10, 5, 15), (7, 8, 127), (10, 8, 127), (23, 8, 127), (52, 11, 1023)
PROFILES = {
    "v100": (F16, 4, 23, None), "ampere": (F16, 8, 24, -132),
    "hopper": (F16, 16, 25, -133), "ampere_bf16": (BF16, 8, 24, -132),
    "hopper_bf16": (BF16, 16, 25, -133), "ampere_tf32": (TF19, 4, 24, -132),
    "hopper_tf32_wmma": (TF19, 4, 25, -133), "hopper_tf32_mma": (TF19, 8, 25, -133),
}


def power(e):
    return Q(1 << e) if e >= 0 else Q(1, 1 << -e)


def fields(fmt, word):
    p, e, bias = fmt
    exponent = (word >> p) & ((1 << e) - 1)
    if exponent == (1 << e) - 1:
        return None
    mantissa = word & ((1 << p) - 1)
    if exponent:
        mantissa |= 1 << p
    if word >> (p + e):
        mantissa = -mantissa
    return mantissa, (exponent or 1) - bias, p


@lru_cache(maxsize=50000)
def decode(fmt, word):
    f = fields(fmt, word)
    return None if f is None else Q(f[0]) * power(f[1] - f[2])


def maxword(fmt):
    p, e, _ = fmt
    return ((1 << e) - 1) * (1 << p) - 1


@lru_cache(maxsize=None)
def tiny_values(fmt):
    return [decode(fmt, b) for b in range(maxword(fmt) + 1)]


def round_expected(fmt, mode, x):
    p, e, _ = fmt
    if p < 1 or e < 2:
        return "none"
    a, top = abs(x), maxword(fmt)
    if a > decode(fmt, top):
        return "none"
    if p + e <= 8:
        upper = bisect_left(tiny_values(fmt), a)
    else:
        lo, hi = 0, top
        while lo < hi:
            mid = (lo + hi) // 2
            if decode(fmt, mid) < a:
                lo = mid + 1
            else:
                hi = mid
        upper = lo
    if decode(fmt, upper) == a:
        chosen = upper
    else:
        lower = upper - 1
        if mode == "rn":
            dl, du = a - decode(fmt, lower), decode(fmt, upper) - a
            chosen = lower if dl < du or (dl == du and lower % 2 == 0) else upper
        elif mode == "rz":
            chosen = lower
        elif mode == "rd":
            chosen = upper if x < 0 else lower
        else:
            chosen = lower if x < 0 else upper
    return str(chosen | ((1 << (p + e)) if x < 0 else 0))


def block_expected(name, c, operands):
    fmt, k, precision, floor = PROFILES[name]
    if len(operands) != k:
        return "shape"
    fc = fields(F32, c)
    fs = [(fields(fmt, a), fields(fmt, b)) for a, b in operands]
    if fc is None or any(a is None or b is None for a, b in fs):
        return "nonfinite"
    terms = [fc] + [(a[0] * b[0], a[1] + b[1], a[2] + b[2]) for a, b in fs]
    active = [scale for m, scale, _ in terms if m]
    eta = max(active) if active else 0
    if active and floor is not None:
        eta = max(eta, floor)
    grid = eta - precision
    total = 0
    for m, scale, frac in terms:
        shift = scale - frac - grid
        magnitude = abs(m) << shift if shift >= 0 else abs(m) >> -shift
        total += magnitude if m >= 0 else -magnitude
    result = round_expected(F32, "rz", Q(total) * power(grid))
    return "range" if result == "none" else result


def main():
    requests, expected, groups = [], [], []

    def add(group, request, answer):
        groups.append(group)
        requests.append(request)
        expected.append(answer)

    def check_round(group, fmt, x):
        p, e, bias = fmt
        for mode in MODES:
            add(group, f"round {p} {e} {bias} {mode} {x.numerator} {x.denominator}",
                round_expected(fmt, mode, x))

    # Every encoding and every adjacent midpoint/third/quarter of 36 small formats.
    tiny_formats = [(p, e, b) for p in range(1, 5) for e in range(2, 5)
                    for b in (-3, 0, (1 << (e - 1)) - 1)]
    for fmt in tiny_formats:
        p, e, bias = fmt
        for word in range(1 << (1 + p + e)):
            v = decode(fmt, word)
            add("tiny_decode", f"decode {p} {e} {bias} {word}",
                "none" if v is None else f"{v.numerator}/{v.denominator}")
        values = tiny_values(fmt)
        points = set(values)
        for lo, hi in zip(values, values[1:]):
            for fraction in (Q(1, 4), Q(1, 3), Q(1, 2), Q(2, 3), Q(3, 4)):
                points.add(lo + (hi - lo) * fraction)
        points.update((values[-1] + values[1] / 4, values[-1] * 2))
        for x in sorted(points | {-x for x in points}):
            check_round("tiny_round", fmt, x)

    # Exhaustive classification/values for both 16-bit formats, plus wide samples.
    for fmt in (F16, BF16, TF19, F32, F64):
        p, e, bias = fmt
        width = p + e + 1
        words = set(range(1 << width)) if width == 16 else {
            RNG.getrandbits(width) for _ in range(5000)}
        for exponent in (0, 1, 2, (1 << e) // 2, (1 << e) - 2, (1 << e) - 1):
            for mantissa in (0, 1, 2, (1 << p) // 2, (1 << p) - 2, (1 << p) - 1):
                for sign in (0, 1):
                    words.add((sign << (p + e)) | (exponent << p) | mantissa)
        for word in sorted(words):
            v = decode(fmt, word)
            add("standard_decode", f"decode {p} {e} {bias} {word}",
                "none" if v is None else f"{v.numerator}/{v.denominator}")
        adjacent = {RNG.randrange(maxword(fmt)) for _ in range(100)}
        for exponent in (0, 1, 2, (1 << e) // 2, (1 << e) - 2):
            adjacent.update((exponent << p) + m for m in (0, 1, (1 << p) - 2))
        for word in sorted(adjacent):
            lo, hi = decode(fmt, word), decode(fmt, word + 1)
            for r in (Q(0), Q(1, 3), Q(1, 2), Q(2, 3), Q(1)):
                x = lo + (hi - lo) * r
                check_round("standard_round", fmt, x)
                check_round("standard_round", fmt, -x)
        for x in (decode(fmt, maxword(fmt)), decode(fmt, maxword(fmt)) + decode(fmt, 1),
                  decode(fmt, 1) / 1000):
            check_round("standard_round", fmt, x)
            check_round("standard_round", fmt, -x)
    for fmt in ((0, 3, 3), (3, 0, 0), (3, 1, 0)):
        for x in (Q(0), Q(1), Q(-1)):
            check_round("invalid_format", fmt, x)

    for name, (fmt, k, _, _) in PROFILES.items():
        p, e, bias = fmt
        sign = 1 << (p + e)
        one = bias << p
        edge = [0, sign, 1, sign | 1, (1 << p) - 1, 1 << p,
                one, one - 1, one + 1, sign | one, maxword(fmt), sign | maxword(fmt)]
        accumulators = [0, 0x80000000, 1, 0x80000001, 0x007FFFFF, 0x00800000,
                        0x3F800000, 0xBF800000, 0x7F7FFFFF, 0xFF7FFFFF]
        cases = [(c, [(0, 0)] * k) for c in accumulators]
        for _ in range(220):
            cases.append((RNG.choice(accumulators),
                          [(RNG.choice(edge), RNG.choice(edge)) for _ in range(k)]))
        for _ in range(180):
            cases.append((RNG.getrandbits(32),
                          [(RNG.getrandbits(1 + p + e), RNG.getrandbits(1 + p + e)) for _ in range(k)]))
        cases.extend([(0, [(0, 0)] * (k - 1)), (0, [(0, 0)] * (k + 1)),
                      (0x7FC00000, [(0, 0)] * k),
                      (0, [(((1 << e) - 1) << p, one)] + [(0, 0)] * (k - 1))])
        for c, pairs in cases:
            data = " ".join(str(word) for ab in pairs for word in ab)
            add("blocks_" + name, f"block {name} {c} {data}", block_expected(name, c, pairs))

    (HERE / "probe-requests.txt").write_text("\n".join(requests) + "\n")
    proc = subprocess.run([str(HERE / "probe")], input="\n".join(requests) + "\n",
                          text=True, capture_output=True, check=True)
    (HERE / "probe-results.txt").write_text(proc.stdout)
    actual = proc.stdout.splitlines()
    assert len(actual) == len(expected), (len(actual), len(expected), proc.stderr)
    failures = [{"index": i, "group": groups[i], "request": requests[i],
                 "expected": want, "actual": got}
                for i, (want, got) in enumerate(zip(expected, actual)) if want != got]
    report = {"seed": 20260907, "cases": len(requests), "groups": dict(Counter(groups)),
              "tiny_formats": len(tiny_formats), "failures": len(failures),
              "first_failures": failures[:20],
              "block_outcomes": dict(Counter(answer for group, answer in zip(groups, expected)
                                             if group.startswith("blocks_") and not answer.isdigit()))}
    (HERE / "independent-results.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    return bool(failures)


if __name__ == "__main__":
    sys.exit(main())
