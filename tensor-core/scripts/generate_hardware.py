#!/usr/bin/env python3
"""Generate targeted, UNMEASURED WMMA inputs and separate Lean model expectations.

After `lake build`: python3 scripts/generate_hardware.py
On each target GPU: python3 hardware/run.py --profile V100 --out data/hardware/run-V100
Replay: python3 scripts/replay_hardware.py data/hardware/run-V100/measurements.json
No expectation is ever written as a device measurement.
"""
from pathlib import Path
import hashlib
import json
import subprocess
from check_features import reference

ROOT = Path(__file__).resolve().parents[1]
PROFILES = {'V100': (4, 0, None), 'A100': (8, 1, -132), 'H100': (16, 2, -133)}


def vectors():
    for profile, (k, _, _) in PROFILES.items():
        def row(name, pairs, c=0):
            assert len(pairs) == 16
            return dict(id=f'{profile}/{name}', profile=profile,
                        a=[f'{a:04x}' for a, _ in pairs],
                        b=[f'{b:04x}' for _, b in pairs], c=f'{c:08x}')
        yield row('all_groups_populated', [(0x3c00, 0x3c00)] * 16)
        for position in range(16):
            pairs = [(0, 0)] * 16
            pairs[position] = (0x3c00, 0x3c00)
            yield row(f'position_{position:02}', pairs)
        for group in range(16 // k):
            pairs = [(0, 0)] * 16
            pairs[group*k:(group+1)*k] = [(0x3c00, 0x3c00)] * k
            yield row(f'group_{group}', pairs)
        # All ordered group pairs; the two orderings have the same exact ideal.
        for first in range(16 // k):
            for later in range(first + 1, 16 // k):
                for reverse in [False, True]:
                    pairs = [(0, 0)] * 16
                    a, b = (later*k, first*k) if reverse else (first*k, later*k)
                    pairs[a], pairs[b] = (0xbc00, 0x3c00), (1, 0x3c00)
                    yield row(f'order_{first}_{later}_{int(reverse)}', pairs, 0x3f800000)
        yield row('signed_zero', [(0x8000, 0x3c00)]*16, 0x80000000)
        yield row('mixed_signed_zero', [(0x8000, 0x3c00), (0, 0xbc00)]*8, 0x80000000)
        yield row('subnormal_accumulator', [(0, 0)]*16, 1)
        yield row('negative_subnormal_accumulator', [(0, 0)]*16, 0x80000001)
        yield row('subnormal_products', [(1, 1)]*16)
        yield row('subnormal_negative_products', [(0x8001, 1)]*16)
        yield row('normal_boundary', [(0x03ff, 0x3c00), (0x0400, 0xbc00)]*8)
        yield row('cancellation', [(0x3c00, 0x3c00), (0xbc00, 0x3c00)]*8, 1)
        pairs = [(0, 0)]*16
        pairs[0], pairs[1] = (0x3c00, 0x3c00), (1, 0x3c00)
        yield row('eft_subnormal_counterexample', pairs, 1)


def main():
    inputs = list(vectors())
    assert len({v['id'] for v in inputs}) == len(inputs)
    lines = []
    for v in inputs:
        words = [int(w, 16) for pair in zip(v['a'], v['b']) for w in pair] + [int(v['c'], 16)]
        lines.append(v['profile'] + ' ' + ' '.join(map(str, words)))
    tmp = ROOT / 'tmp/eft'
    tmp.mkdir(parents=True, exist_ok=True)
    path = tmp / 'hardware-model.txt'
    path.write_text('\n'.join(lines) + '\n')
    proc = subprocess.run(['lake', 'env', 'lean', '--run', 'examples/EFTHardware.lean', str(path)],
                          cwd=ROOT, check=True, text=True, capture_output=True)
    outputs = [json.loads(x) for x in proc.stdout.splitlines()]
    assert len(outputs) == len(inputs)
    expected = []
    for v, bits in zip(inputs, outputs):
        assert bits is not None
        k, extra, floor = PROFILES[v['profile']]
        c = int(v['c'], 16)
        for start in range(0, 16, k):
            words = [int(w, 16) for pair in zip(v['a'][start:start+k], v['b'][start:start+k]) for w in pair] + [c]
            result = reference(words, k, extra, floor)
            assert result is not None
            c = result['bits']
        assert bits == c, (v, bits, c)
        expected.append(dict(id=v['id'], bits=f'{bits:08x}', status='model_expectation_unmeasured'))
    lookup = {x['id']: x['bits'] for x in expected}
    assert lookup['A100/order_0_1_0'] == '33800000'
    assert lookup['A100/order_0_1_1'] == '00000000'
    for first in range(4):
        for later in range(first+1, 4):
            assert lookup[f'V100/order_{first}_{later}_0'] == '33800000'
            assert lookup[f'V100/order_{first}_{later}_1'] == '00000000'
    data = ROOT / 'data/hardware'
    data.mkdir(parents=True, exist_ok=True)
    text = json.dumps(dict(schema=1, vectors=inputs), indent=2) + '\n'
    (data / 'inputs.json').write_text(text)
    (data / 'expected.json').write_text(json.dumps(dict(schema=1,
        evidence='UNMEASURED: Lean model plus independent Python schedule oracle',
        inputs_sha256=hashlib.sha256(text.encode()).hexdigest(), expected=expected), indent=2) + '\n')
    print(f'{len(inputs)} unmeasured vectors; Lean and independent schedule oracle agree; all V100/Ampere ordering witnesses distinguishable.')


if __name__ == '__main__':
    main()
