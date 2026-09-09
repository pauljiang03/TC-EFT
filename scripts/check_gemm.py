#!/usr/bin/env python3
"""Check WMMA GEMM indexing, tiling, every encoded boundary, and matrix error bounds.

The Python matrix loops independently select operands and drive the existing exact
single-block oracle. These are executable comparisons, separate from Lean proofs.
"""
from fractions import Fraction as Q
from pathlib import Path
import hashlib
import json
import random
import subprocess
import sys
import time

from check_features import decode, reference, val32

ROOT = Path(__file__).resolve().parents[1]
PROFILES = {'v100': (4, 0, None), 'ampere': (8, 1, -132), 'hopper': (16, 2, -133)}
SEED = 20260906


def cases():
    rng = random.Random(SEED)
    values = [0, 0x8000, 1, 0x8001, 0x0c00, 0x8c00, 0x3800, 0xb800,
              0x3c00, 0xbc00, 0x3e00, 0xbe00, 0x4000, 0xc000, 0x7bff, 0xfbff]
    base = []

    def add(name, m, n, k, a, b, c):
        base.append(dict(name=name, m=m, n=n, k=k, a=a, b=b, c=c))

    add('rectangular', 2, 3, 5,
        [0x3c00, 0x4000, 0x4200, 0x4400, 0x4500, 0xbc00, 0xc000, 0xc200, 0xc400, 0xc500],
        [w for x in [0x3c00, 0x4000, 0x4200, 0x4400, 0x4500] for w in [0x3c00, x, 0xbc00]],
        [0x3f800000, 0x40000000, 0x40400000, 0x40800000, 0x40a00000, 0x40c00000])
    add('tiny-two-instructions', 1, 1, 17, [0x0c00] * 17, [0x0c00] * 17, [0x3f800000])
    for name, m, n, k in [('multiple-output-tiles', 17, 19, 33), ('partial-k', 3, 2, 31),
                           ('exact-k', 2, 2, 32)]:
        add(name, m, n, k, [rng.choice(values) for _ in range(m * k)],
            [rng.choice(values) for _ in range(k * n)],
            [rng.choice([0, 0x80000000, 1, 0x80000001, 0x3f800000, 0xbf800000])
             for _ in range(m * n)])
    add('empty-k-signed-zero', 2, 3, 0, [], [], [0x80000000, 0, 0x3f800000, 1, 0x80000001, 0xbf800000])
    add('empty-rows', 0, 3, 5, [], [0x3c00] * 15, [])
    add('empty-columns', 2, 0, 5, [0x3c00] * 10, [], [])
    add('nonfinite-operand', 2, 2, 1, [0x7c00, 0x3c00], [0x3c00, 0], [0] * 4)
    add('nonfinite-c-empty-k', 1, 2, 0, [], [], [0x7fc00000, 0x7f800000])
    return [{**case, 'model': model} for model in PROFILES for case in base]


def oracle(case, i, j):
    m, n, k = case['m'], case['n'], case['k']
    assert i < m and j < n
    count, extra, floor = PROFILES[case['model']]
    c = case['c'][i * n + j]
    pairs = [(case['a'][i * k + l], case['b'][l * n + j]) for l in range(k)]
    dc = decode(c, 23, 8, 127)
    decoded = [(decode(a, 10, 5, 15), decode(b, 10, 5, 15)) for a, b in pairs]
    if dc is None or any(a is None or b is None for a, b in decoded):
        return {'error': 'TensorCore.ModelError.nonfiniteInput'}, None
    ideal = dc[0] + sum((a[0] * b[0] for a, b in decoded), Q(0))
    instructions = []
    for start in range(0, k, 16):
        tile = pairs[start:start + 16]
        tile += [(0, 0)] * (16 - len(tile))
        blocks = []
        for offset in range(0, 16, count):
            words = [w for pair in tile[offset:offset + count] for w in pair] + [c]
            block = reference(words, count, extra, floor)
            if block is None:
                return {'error': 'TensorCore.ModelError.accumulatorOutOfRange'}, ideal
            c = block['bits']
            blocks.append(c)
        instructions.append(blocks)
    return dict(bits=c, instructions=instructions), ideal


def compare(case, output):
    m, n, k = case['m'], case['n'], case['k']
    assert len(output['rows']) == len(output['ideal']) == m
    assert output['tile_instructions'] == ((m + 15) // 16) * ((n + 15) // 16) * ((k + 15) // 16)
    boundaries, rejected = 0, 0
    for i, (row, ideals) in enumerate(zip(output['rows'], output['ideal'])):
        assert len(row) == len(ideals) == n
        for j, cell in enumerate(row):
            expected, ideal = oracle(case, i, j)
            assert (None if ideals[j] is None else Q(ideals[j])) == ideal, (case['name'], i, j, 'ideal')
            if 'error' in expected:
                assert cell == expected, (case['name'], i, j, cell, expected)
                rejected += 1
                continue
            for key in ['bits', 'instructions']:
                assert cell[key] == expected[key], (case['name'], case['model'], i, j, key)
            assert cell['initial'] == case['c'][i * n + j]
            assert Q(cell['value']) == val32(expected['bits'])
            assert abs(ideal - Q(cell['value'])) <= Q(cell['error_budget']), (case['name'], i, j, 'bound')
            boundaries += sum(map(len, cell['instructions']))
    return boundaries, rejected


def main():
    start = time.perf_counter()
    work = ROOT / 'tmp/gemm'
    work.mkdir(parents=True, exist_ok=True)
    generated = cases()
    source = '\n'.join(json.dumps(case, separators=(',', ':')) for case in generated) + '\n'
    input_file = work / 'inputs.jsonl'
    input_file.write_text(source)
    command = ['lake', 'env', 'lean', '--run', 'examples/Gemm.lean', str(input_file)]
    result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=True)
    (work / 'outputs.jsonl').write_text(result.stdout)
    outputs = [json.loads(line) for line in result.stdout.splitlines()]
    assert len(outputs) == len(generated)
    boundaries, rejected = 0, 0
    for case, output in zip(generated, outputs):
        b, r = compare(case, output)
        boundaries += b
        rejected += r

    # Check comparison sensitivity to both final output and an internal instruction boundary.
    controls = []
    for kind in ['output', 'boundary']:
        wrong = json.loads(json.dumps(outputs[0]))
        if kind == 'output':
            wrong['rows'][0][0]['bits'] ^= 1
        else:
            wrong['rows'][0][0]['instructions'][0][0] ^= 1
        try:
            compare(generated[0], wrong)
        except AssertionError:
            controls.append('wrong_' + kind + '_rejected')
        else:
            raise AssertionError('Negative control passed: ' + kind)
    for name, change in [('shape', {'a': []}), ('word-width', {'c': [1 << 32] * 6}),
                         ('unknown-model', {'model': 'unknown'})]:
        bad = work / 'invalid.jsonl'
        bad.write_text(json.dumps({**generated[0], **change}) + '\n')
        proc = subprocess.run(command[:-1] + [str(bad)], cwd=ROOT, text=True, capture_output=True)
        assert proc.returncode != 0, ('Invalid input accepted', name)
        controls.append(name + '_rejected')

    report = dict(status='passed', seed=SEED, matrices=len(generated),
                  output_cells=sum(c['m'] * c['n'] for c in generated),
                  rejected_cells=rejected, encoded_block_boundaries=boundaries,
                  profiles=list(PROFILES), operation='FP16 A*B + FP32 C, alpha=beta=1',
                  instruction='PTX wmma.mma.sync.aligned.row.col.m16n16k16.f32.f32',
                  schedule='16x16 output tiles; increasing k=16 tiles; zero-padded boundaries',
                  checks=['original-input ideal', 'row/column indexing', 'all output bits',
                          'every encoded block boundary', 'per-cell error bound', 'empty dimensions',
                          'signed zero', 'nonfinite rejection'], negative_controls=controls,
                  input_sha256=hashlib.sha256(source.encode()).hexdigest(),
                  output_sha256=hashlib.sha256(result.stdout.encode()).hexdigest(),
                  elapsed_seconds=round(time.perf_counter() - start, 3),
                  limitations=['Executable comparisons, not additional universal proofs.',
                               'Matrix-level instruction semantics; no CUDA memory/lane refinement.',
                               'No GPU execution, scalar alpha/beta epilogue, or global correction.'])
    (ROOT / 'data/regressions/gemm-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
