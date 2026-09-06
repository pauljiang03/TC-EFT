#!/usr/bin/env python3
"""Replay the published V100 FP16-output vectors through the two FP16-output candidate
specifications and report which one reproduces the device outputs.

The files are model_validation/V100/fp16 of MATLAB Tensor Core v0.5: a and b are FP16 values
in FP32 words, c is FP32, and d_V100_fp16.txt holds FP16 device outputs in FP32 words. The
CUDA harness converts c to FP16 with round-to-nearest before the instruction
(Validate_TC_models.m, lines 12-13), so this script converts c the same way with its own
exact converter. The MATLAB reference rounds the normalized sum once, to the output width,
in nearest-even mode (frmode = 'rne' for FP16 output, Generic_BFMA_TC.m lines 267-269); the
paper's figures show an FP32 truncation before the FP16 rounding. The two candidates encode
those two readings; the device rows decide between them.
"""
from fractions import Fraction
from pathlib import Path
import json
import subprocess
import sys

from check_device import read_hex_rows, read_bin, fp32_word_to_fp16, value

ROOT = Path(__file__).resolve().parents[1]
VECTORS = ROOT / 'vendor/matlab-tensor-core-v0.5/model_validation/V100/fp16'


def round_half_even(x):
    """Nearest integer to a nonnegative Fraction, ties to even."""
    q, r = divmod(x.numerator, x.denominator)
    twice = 2 * r
    if twice > x.denominator or (twice == x.denominator and q % 2 == 1):
        return q + 1
    return q


def fp32_to_fp16_rne(bits):
    """Independent nearest-even FP32 to FP16 conversion on exact rationals."""
    sign, e, m = bits >> 31, (bits >> 23) & 0xff, bits & 0x7fffff
    if e == 0xff:
        raise ValueError('nonfinite c')
    v = abs(value(bits, 23, 8, 127))
    if v == 0:
        return sign << 15
    exp = v.numerator.bit_length() - v.denominator.bit_length()
    if v < Fraction(2) ** exp:
        exp -= 1
    if exp < -14:
        k = round_half_even(v / Fraction(2) ** -24)
        assert k <= 1024
        if k == 1024:
            return (sign << 15) | (1 << 10)
        return (sign << 15) | k
    k = round_half_even(v / Fraction(2) ** (exp - 10))
    if k == 2048:
        exp += 1
        k = 1024
    assert exp <= 15, 'overflow to infinity is outside the finite domain'
    return (sign << 15) | ((exp + 15) << 10) | (k - 1024)


def main():
    tmp = ROOT / 'tmp/validation'
    tmp.mkdir(parents=True, exist_ok=True)
    a_rows = read_hex_rows(VECTORS / 'a_V100_fp16.txt')
    b_rows = read_hex_rows(VECTORS / 'b_V100_fp16.txt')
    c_words = read_bin(VECTORS / 'c_V100_fp32.txt')
    d_words = read_bin(VECTORS / 'd_V100_fp16.txt')
    n = len(d_words)
    assert len(a_rows) == len(b_rows) == len(c_words) == n and n > 0
    d_half = [fp32_word_to_fp16(d) for d in d_words]
    c_half = [fp32_to_fp16_rne(c) for c in c_words]
    report = dict(vectors=n, c_converted_to_fp16_by='independent nearest-even converter',
                  d_fp16_words_exact=True)
    results = {}
    for candidate in ['half-direct-candidate', 'half-staged-candidate']:
        rows = []
        for a, b, c16 in zip(a_rows, b_rows, c_half):
            words = []
            for x, y in zip(a, b):
                words += [fp32_word_to_fp16(x), fp32_word_to_fp16(y)]
            rows.append(f'block {candidate} ' + ' '.join(map(str, words + [c16])))
        path = tmp / f'device-v100-half-{candidate}.txt'
        path.write_text('\n'.join(rows) + '\n')
        proc = subprocess.run([str(ROOT / '.lake/build/bin/tc_features'), '--file', str(path)],
                              check=True, text=True, capture_output=True)
        traces = [json.loads(line) for line in proc.stdout.splitlines()]
        assert len(traces) == n
        errors = sum('error' in t for t in traces)
        mismatches = [(i, t.get('bits'), d) for i, (t, d) in enumerate(zip(traces, d_half))
                      if t.get('bits') != d]
        results[candidate] = dict(model_errors=errors, bit_mismatches=len(mismatches) - errors,
                                  first_mismatches=[(i, f'{g:04x}' if isinstance(g, int) else g,
                                                     f'{d:04x}') for i, g, d in mismatches[:5]])
        results[candidate]['bits'] = [t.get('bits') for t in traces]
    report['candidates'] = results
    report['rows_where_candidates_differ'] = sum(
        1 for x, y in zip(results['half-direct-candidate']['bits'],
                          results['half-staged-candidate']['bits']) if x != y)
    for r in results.values():
        del r['bits']
    direct, staged = results['half-direct-candidate'], results['half-staged-candidate']
    both = all(r['bit_mismatches'] == 0 and r['model_errors'] == 0 for r in results.values())
    if both and report['rows_where_candidates_differ'] == 0:
        report['resolution'] = ('Both candidates reproduce every published row and agree on all of '
                                'them; the rows contain no double-rounding case, so they do not '
                                'decide the stage order. The reference source rounds once, directly '
                                'to FP16 (frmode = rne); Regression.half_output_stage_order gives an '
                                'input on which the candidates differ.')
    elif direct['bit_mismatches'] == 0 and direct['model_errors'] == 0:
        report['resolution'] = 'Only the direct candidate reproduces every row'
    elif staged['bit_mismatches'] == 0 and staged['model_errors'] == 0:
        report['resolution'] = 'Only the staged candidate reproduces every row'
    else:
        report['resolution'] = 'Neither candidate reproduces every row'
    report['method'] = ('Two descriptor evaluations per row with FP16 c from an independent '
                        'converter; bitwise comparison with the FP16 device outputs; no new GPU '
                        'measurements')
    (ROOT / 'data/regressions/device-half-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    ok = direct['bit_mismatches'] == 0 or staged['bit_mismatches'] == 0
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
