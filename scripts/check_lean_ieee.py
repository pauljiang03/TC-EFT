#!/usr/bin/env python3
"""Compare our IEEE reference, Lean's logical model, and compiled native floats.

Only binary32/binary64 add/sub/mul under nearest-even are compared. NaN result
payloads are compared under explicit canonicalization; reference bits and all
flags are also checked against the independent ordered-encoding oracle.
Passing samples is conformance evidence, not a universal equivalence proof.
"""
from collections import Counter
import hashlib
import json
from pathlib import Path
import random
import subprocess
import time

from check_ieee import decode, expected, flags_number, nan_bits, requests

ROOT = Path(__file__).resolve().parents[1]
SEED = 75420260908


def canonical(width, bits):
    return nan_bits(width) if decode(width, bits)[0] == 'nan' else bits


def cases():
    for group, request in requests(False):
        if (request['format'] in ('fp32', 'fp64') and request['mode'] == 'rne'
                and request['operation'] in ('add', 'sub', 'mul')):
            yield group, request
    rng = random.Random(SEED)
    for width in (32, 64):
        for op in ('add', 'sub', 'mul'):
            for _ in range(2000):
                yield 'additional_random', {
                    'format': f'fp{width}', 'mode': 'rne', 'tininess': 'after',
                    'operation': op, 'a': rng.getrandbits(width), 'b': rng.getrandbits(width)}


def main():
    started = time.monotonic()
    subprocess.run(['lake', 'build', 'tc_lean_ieee_check'], cwd=ROOT, check=True,
                   stdout=subprocess.DEVNULL)
    inputs = list(cases())
    data = ''.join(json.dumps(r, separators=(',', ':')) + '\n' for _, r in inputs)
    proc = subprocess.run([str(ROOT / '.lake/build/bin/tc_lean_ieee_check')],
                          input=data, text=True, capture_output=True, check=True)
    outputs = [json.loads(line) for line in proc.stdout.splitlines()]
    if len(outputs) != len(inputs):
        raise RuntimeError(f'Expected {len(inputs)} results, got {len(outputs)}')
    failures = []
    nan_policy_differences = Counter()
    for index, ((_, request), got) in enumerate(zip(inputs, outputs)):
        width = int(request['format'][2:])
        reference = got['reference']
        want_bits, want_flags = expected(request)
        if got['public'] != reference:
            failures.append({'index': index, 'source': 'migrated_public_api', 'request': request,
                             'expected': reference, 'actual': got['public']})
        if (reference['bits'], flags_number(reference['flags'])) != (want_bits, want_flags):
            failures.append({'index': index, 'source': 'reference_oracle', 'request': request,
                             'expected': [want_bits, want_flags], 'actual': reference})
        for source in ('logical_bits', 'native_bits'):
            bits = got[source]
            if canonical(width, bits) != canonical(width, want_bits):
                failures.append({'index': index, 'source': source, 'request': request,
                                 'expected_bits': want_bits, 'actual_bits': bits})
            elif bits != want_bits:
                nan_policy_differences[source] += 1
    sources = [Path(__file__).resolve(), ROOT / 'scripts/check_ieee.py',
               ROOT / 'Main/LeanIEEECheck.lean', ROOT / 'lean-toolchain',
               ROOT / 'TensorCore/Cli/IEEE.lean', ROOT / 'lakefile.toml',
               *sorted((ROOT / 'TensorCore/IEEE').glob('*.lean'))]
    report = {
        'status': 'failed' if failures else 'passed', 'seed': SEED,
        'scope': 'binary32/binary64 nearest-even add/sub/mul; NaNs canonicalized for Lean comparison',
        'samples_are_not_proofs': True,
        'proved_native_domain': 'nonzero finite operands, nearest-even, absolute exact result at most maxFinite',
        'public_preservation_theorems': ['TensorCore.IEEE.addWithLean_eq',
                                        'TensorCore.IEEE.subWithLean_eq',
                                        'TensorCore.IEEE.mulWithLean_eq'],
        'reference_flags_checked_against_independent_oracle': True,
        'native_exception_flags_compared': False,
        'cases': len(inputs), 'groups': dict(Counter(g for g, _ in inputs)),
        'nan_policy_differences': dict(nan_policy_differences),
        'failures': len(failures), 'first_failures': failures[:20],
        'request_sha256': hashlib.sha256(data.encode()).hexdigest(),
        'source_sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                          for p in sources},
        'elapsed_seconds': round(time.monotonic() - started, 3)}
    (ROOT / 'data/regressions/lean-ieee-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    return bool(failures)


if __name__ == '__main__':
    if not __debug__:
        raise SystemExit('Run without Python -O; the shared oracle uses assertions.')
    raise SystemExit(main())
