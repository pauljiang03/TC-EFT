#!/usr/bin/env python3
"""Replay the published V100, A100, and H100 FP16 vectors through the parameterized evaluator.

Each row of the MATLAB Tensor Core v0.5 validation files holds one normalization group:
K = 4 (V100), 8 (A100), or 16 (H100) products with one FP32 c and one FP32 d. The CUDA
harness placed the K products in k positions 0..K-1 of a single WMMA instruction. Rows are
evaluated with fp16Fp32Profile K extraBits floor through the tc_features executable and
compared bit for bit. This is a model/device comparison performed by a test, not a theorem.
"""
from pathlib import Path
import json
import subprocess
import sys

from check_device import fp32_word_to_fp16, read_hex_rows, read_bin

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'vendor/matlab-tensor-core-v0.5/model_validation'
FAMILIES = [('V100', 4, 0, None), ('A100', 8, 1, -132), ('H100', 16, 2, -133)]


def main():
    tmp = ROOT / 'tmp/validation'
    tmp.mkdir(parents=True, exist_ok=True)
    report, failures = {}, []
    for gpu, k, extra, floor in FAMILIES:
        folder = BASE / gpu / 'fp16'
        a_rows = read_hex_rows(folder / f'a_{gpu}_fp16.txt')
        b_rows = read_hex_rows(folder / f'b_{gpu}_fp16.txt')
        c_words = read_bin(folder / f'c_{gpu}_fp32.txt')
        d_words = read_bin(folder / f'd_{gpu}_fp32.txt')
        n = len(d_words)
        assert len(a_rows) == len(b_rows) == len(c_words) == n and n > 0
        assert all(len(r) == k for r in a_rows + b_rows), f'{gpu} rows must hold K={k} products'
        special = 0
        rows = []
        for a, b, c in zip(a_rows, b_rows, c_words):
            words = [fp32_word_to_fp16(h) for pair in zip(a, b) for h in pair]
            special += sum((h >> 10) & 0x1f == 0 for h in words) + ((c >> 23) & 0xff == 0)
            rows.append(f'canonical {k} {extra} {"none" if floor is None else floor} '
                        + ' '.join(map(str, words + [c])))
        path = tmp / f'device-{gpu.lower()}-fp16.txt'
        path.write_text('\n'.join(rows) + '\n')
        proc = subprocess.run([str(ROOT / '.lake/build/bin/tc_features'), '--file', str(path)],
                              check=True, text=True, capture_output=True)
        traces = [json.loads(line) for line in proc.stdout.splitlines()]
        assert len(traces) == n
        errors = sum('error' in t for t in traces)
        mismatches = [(i, t.get('bits'), d) for i, (t, d) in enumerate(zip(traces, d_words))
                      if t.get('bits') != d]
        report[gpu] = dict(profile=f'fp16Fp32Profile {k} {extra} {floor}', vectors=n,
                           model_errors=errors, bit_mismatches=len(mismatches) - errors,
                           zero_or_subnormal_operands_or_c=special,
                           fp16_output_vectors_present_but_not_compared=True)
        failures += [(gpu, *m) for m in mismatches]
    report['method'] = ('Exact FP32-word to FP16 conversion, one evaluator call per row, '
                        'bitwise output comparison; no new GPU measurements')
    (ROOT / 'data/regressions/device-families-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    for gpu, i, got, want in failures[:10]:
        print(f'{gpu} row {i}: model {got} device {want:08x}', file=sys.stderr)
    if failures:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
