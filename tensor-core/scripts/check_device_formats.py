#!/usr/bin/env python3
"""Replay the published A100 and H100 BF16 and TF32 vectors through the InvocationSpec descriptors.

This is evidence for the deferred formats only. The descriptors (a100-bf16, a100-tf32,
hopper-bf16, hopper-tf32-wmma) are executable specifications with exact loss accounting; no
rounding-correctness proof exists for them, and nothing here changes that. Each row is one
normalization group with K = N_FMA products (8 or 16 for BF16, 4 for TF32), an FP32 c, and an
FP32 d, exactly as Validate_TC_models.m reshapes the files. BF16 operands are FP32 words with a
zero low half; TF32 operands are FP32 words with thirteen zero low bits, which is what the
tf32Register encoding requires. This is a model/device comparison performed by a test.
"""
from pathlib import Path
import json
import subprocess
import sys

from check_device import read_hex_rows, read_bin

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'vendor/matlab-tensor-core-v0.5/model_validation'
CASES = [('A100', 'bf16', 'a100-bf16', 8), ('A100', 'tf32', 'a100-tf32', 4),
         ('H100', 'bf16', 'hopper-bf16', 16), ('H100', 'tf32', 'hopper-tf32-wmma', 4)]


def operand(word, fmt):
    if fmt == 'bf16':
        assert word & 0xffff == 0, f'not a BF16 value: {word:08x}'
        return word >> 16, ((word >> 23) & 0xff) == 0
    assert word & 0x1fff == 0, f'not a TF32 value: {word:08x}'
    return word, ((word >> 23) & 0xff) == 0


def main():
    tmp = ROOT / 'tmp/validation'
    tmp.mkdir(parents=True, exist_ok=True)
    report, failures = {}, []
    for gpu, fmt, profile, k in CASES:
        folder = BASE / gpu / fmt
        a_rows = read_hex_rows(folder / f'a_{gpu}_{fmt}.txt')
        b_rows = read_hex_rows(folder / f'b_{gpu}_{fmt}.txt')
        c_words = read_bin(folder / f'c_{gpu}_fp32.txt')
        d_words = read_bin(folder / f'd_{gpu}_fp32.txt')
        n = len(d_words)
        assert len(a_rows) == len(b_rows) == len(c_words) == n and n > 0
        assert all(len(r) == k for r in a_rows + b_rows), f'{gpu} {fmt} rows must hold K={k}'
        rows, special = [], 0
        for a, b, c in zip(a_rows, b_rows, c_words):
            words = []
            for h in [x for pair in zip(a, b) for x in pair]:
                w, tiny = operand(h, fmt)
                words.append(w)
                special += tiny
            special += ((c >> 23) & 0xff) == 0
            rows.append(f'block {profile} ' + ' '.join(map(str, words + [c])))
        path = tmp / f'device-{gpu.lower()}-{fmt}.txt'
        path.write_text('\n'.join(rows) + '\n')
        proc = subprocess.run([str(ROOT / '.lake/build/bin/tc_features'), '--file', str(path)],
                              check=True, text=True, capture_output=True)
        traces = [json.loads(line) for line in proc.stdout.splitlines()]
        assert len(traces) == n
        errors = sum('error' in t for t in traces)
        mismatches = [(i, t.get('bits'), d) for i, (t, d) in enumerate(zip(traces, d_words))
                      if t.get('bits') != d]
        report[f'{gpu}-{fmt}'] = dict(descriptor=profile, products=k, vectors=n,
                                     model_errors=errors, bit_mismatches=len(mismatches) - errors,
                                     zero_or_subnormal_operands_or_c=special)
        failures += [(gpu, fmt, *m) for m in mismatches]
    report['status'] = ('Descriptor evidence for deferred formats; the alignment floors are not '
                        'exercised by these rows and no rounding proof is claimed')
    report['method'] = 'One descriptor evaluation per row, bitwise output comparison; no new GPU measurements'
    (ROOT / 'data/regressions/device-formats-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    for gpu, fmt, i, got, want in failures[:10]:
        print(f'{gpu} {fmt} row {i}: model {got} device {want:08x}', file=sys.stderr)
    if failures:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
