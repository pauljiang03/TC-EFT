#!/usr/bin/env python3
"""Independent exact checks for canonical FP16 -> FP32 groups.

The rounding oracle searches ordered FP32 encodings for the two neighboring
values. It does not use the Lean converter's exponent/coefficient construction.
No hardware beyond the separately pinned V100 data is inferred by these tests.
"""
from fractions import Fraction as Q
from pathlib import Path
import json
import random
import subprocess

ROOT = Path(__file__).resolve().parents[1]
RNG = random.Random(20260905)


def decode(bits, frac, expbits, bias):
    e, m = (bits >> frac) & ((1 << expbits) - 1), bits & ((1 << frac) - 1)
    if e == (1 << expbits) - 1:
        return None
    if e == 0:
        scale, sig = 1 - bias, m
    else:
        scale, sig = e - bias, (1 << frac) + m
    if bits >> (frac + expbits):
        sig = -sig
    return Q(sig) * Q(2) ** (scale - frac), scale


def val32(bits):
    return decode(bits, 23, 8, 127)[0]


MAX32 = val32(0x7f7fffff)


def round32_search(x):
    """Find floor magnitude by binary searching all nonnegative finite encodings."""
    if abs(x) > MAX32:
        return None
    lo, hi = 0, 0x7f7fffff
    while lo < hi:
        mid = (lo + hi + 1) // 2
        if val32(mid) <= abs(x):
            lo = mid
        else:
            hi = mid - 1
    return lo | (0x80000000 if x < 0 else 0)


def reference(words, K, extra, floor):
    if len(words) != 2 * K + 1:
        return None
    ab = [decode(h, 10, 5, 15) for h in words[:-1]]
    c = decode(words[-1], 23, 8, 127)
    if c is None or any(v is None for v in ab):
        return None
    terms = [c]
    for a, b in zip(ab[::2], ab[1::2]):
        terms.append((a[0] * b[0], a[1] + b[1]))
    scales = [e for value, e in terms if value]
    eta = max(scales) if scales else None
    if eta is not None and floor is not None:
        eta = max(eta, floor)
    q = Q(2) ** ((eta if eta is not None else 0) - 23 - extra)
    # int(Fraction) truncates toward zero, including negative terms.
    acc = sum((int(v / q) * q for v, _ in terms), Q(0))
    ideal = sum((v for v, _ in terms), Q(0))
    bits = round32_search(acc)
    if bits is None:
        return None
    return dict(bits=bits, ideal=ideal, accumulated=acc, value=val32(bits), residual=ideal-val32(bits))


def run_rows(rows, filename):
    path = ROOT / 'tmp/validation' / filename
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text('\n'.join(rows) + '\n')
    proc = subprocess.run([str(ROOT / '.lake/build/bin/tc_features'), '--file', str(path)],
                          check=True, text=True, capture_output=True)
    data = [json.loads(line) for line in proc.stdout.splitlines()]
    assert len(data) == len(rows), (len(data), len(rows))
    return data


def main():
    cases = []
    # Include arbitrary, non-hardware block sizes and extra-bit counts.
    configs = [(4, 0, None), (8, 1, -132), (16, 2, -133)]
    configs += [(k, e, f) for k in [1, 3, 7, 17, 37, 64]
                for e in [0, 1, 2, 5, 9, 24] for f in [None, -132, 4]]
    boundary16 = [0, 0x8000, 1, 0x8001, 0x3ff, 0x83ff, 0x400, 0x8400,
                  0x3c00, 0xbc00, 0x3c01, 0x3bff, 0x7bff, 0xfbff]
    boundary32 = [0, 0x80000000, 1, 0x80000001, 0x7fffff, 0x807fffff,
                  0x800000, 0x80800000, 0x3f800000, 0xbf800000, 0x7f7fffff, 0xff7fffff]
    for k, extra, floor in configs:
        samples = [[0] * (2*k) + [0], [1] * (2*k) + [1],
                   [0x3c00] * (2*k) + [0],
                   [0x7bff, 0xfbff] * k + [0x7f7fffff]]
        for i in range(12):
            if i % 3 == 0:
                words = [RNG.choice(boundary16) for _ in range(2*k)]
            elif i % 3 == 1:
                words = [RNG.randrange(0x7c00) | (RNG.randrange(2) << 15) for _ in range(2*k)]
            else:
                # Similar-scale products with cancellation and alignment loss.
                words = [RNG.randrange(0x3400, 0x4400) | (RNG.randrange(2) << 15) for _ in range(2*k)]
            samples.append(words + [RNG.choice(boundary32)])
        for words in samples:
            cases.append((k, extra, floor, words))
    # Distinguish extra alignment bits and preserve raw factorization.
    for extra in [0, 1, 2, 9]:
        cases.append((4, extra, None, [0x3c00,0x3c00,0xc00,0xc00,0xc00,0xc00,0,0,0]))
    # Explicit model-domain and parser checks (wrong count and special values).
    for words in [[0]*7, [0x7c00,0]*4+[0], [0]*8+[0x7f800000]]:
        cases.append((4, 0, None, words))
    rows = ['canonical ' + ' '.join(map(str, [k, e, 'none' if f is None else f, *words]))
            for k, e, f, words in cases]
    got = run_rows(rows, 'canonical-features.txt')
    losses = dict(alignment=0, output=0, both=0)
    rejected = 0
    for args, result in zip(cases, got):
        expected = reference(args[3], *args[:3])
        if expected is None:
            assert 'error' in result, (args, result)
            rejected += 1
            continue
        assert 'error' not in result, (args, result)
        assert result['bits'] == expected['bits'], (args, result, expected)
        for key in ['ideal', 'accumulated', 'value', 'residual']:
            assert Q(result[key]) == expected[key], (args, key, result, expected)
        alignment = expected['ideal'] != expected['accumulated']
        output = expected['accumulated'] != expected['value']
        losses['alignment'] += alignment
        losses['output'] += output
        losses['both'] += alignment and output
    # Run the new invocation API against the already pinned V100 device vectors.
    from check_device import VECTORS, read_hex_rows, read_bin, fp32_word_to_fp16
    av = read_hex_rows(VECTORS / 'a_V100_fp16.txt')
    bv = read_hex_rows(VECTORS / 'b_V100_fp16.txt')
    cv = read_bin(VECTORS / 'c_V100_fp32.txt')
    dv = read_bin(VECTORS / 'd_V100_fp32.txt')
    device_rows = []
    for a, b, c in zip(av, bv, cv):
        words = [fp32_word_to_fp16(h) for pair in zip(a,b) for h in pair] + [c]
        device_rows.append('canonical 4 0 none ' + ' '.join(map(str, words)))
    device = run_rows(device_rows, 'canonical-v100-device.txt')
    assert len(device) == len(dv)
    mismatch = sum(t.get('bits') != d for t, d in zip(device, dv))
    assert mismatch == 0, mismatch
    report = dict(scope='Canonical FP16 products, FP32 c/output, unnormalized products, RTZ',
                  oracle='Exact Fraction arithmetic; FP32 output found by binary search over encodings',
                  configurations=len(configs), cases=len(cases), rejected=rejected, mismatches=0,
                  K=sorted({c[0] for c in configs}), extra_bits=sorted({c[1] for c in configs}),
                  exercised_losses=losses, published_v100_vectors=len(device),
                  published_v100_mismatches=mismatch, new_gpu_measurements=False,
                  other_formats='Deferred by user; not part of this acceptance gate')
    (ROOT / 'data/regressions/feature-report.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
