#!/usr/bin/env python3
"""IEEE validation using ordered-encoding search and optional pinned SoftFloat.

No implementation/test oracle is imported. The Python numerical oracle selects
from ordered encodings; it does not use the Lean coefficient/carry algorithm.
SoftFloat comparisons require identical numeric bits and every flag. NaN sign
and payload selection may differ between documented policies; our payload policy
is checked separately by the Python oracle, including signaling behavior.
"""
import argparse
from collections import Counter
from fractions import Fraction as Q
from functools import lru_cache
import hashlib
import json
from pathlib import Path
import random
import subprocess
import struct
import time

ROOT = Path(__file__).resolve().parents[1]
FORMATS = {16: (10, 5, 15), 32: (23, 8, 127), 64: (52, 11, 1023)}
MODES = ('rne', 'rtz', 'rdn', 'rup')
FLAG_NAMES = ('inexact', 'underflow', 'overflow', 'divide_by_zero', 'invalid')
SEED = 75420260907


def power(e):
    return Q(1 << e) if e >= 0 else Q(1, 1 << -e)


@lru_cache(maxsize=300000)
def positive_value(fmt, word):
    p, e, bias = fmt
    exponent, fraction = divmod(word, 1 << p)
    return Q(fraction if exponent == 0 else (1 << p) + fraction) * power((1 if exponent == 0 else exponent) - bias - p)


def decode(width, word):
    p, e, _ = FORMATS[width]
    negative = bool(word >> (width - 1))
    mag = word & ((1 << (width - 1)) - 1)
    exp, frac = divmod(mag, 1 << p)
    if exp == (1 << e) - 1:
        if frac == 0:
            return ('inf', negative, None, False, 0)
        return ('nan', negative, None, not bool(frac & (1 << (p - 1))), frac % (1 << (p - 1)))
    value = positive_value(FORMATS[width], mag)
    return ('finite', negative, -value if negative else value, False, 0)


def select_magnitude(fmt, magnitude, mode, negative):
    p, e, bias = fmt
    infinity = ((1 << e) - 1) << p
    low, high = 0, infinity
    while low < high:
        middle = (low + high) // 2
        if positive_value(fmt, middle) < magnitude:
            low = middle + 1
        else:
            high = middle
    upper = low
    if upper < infinity and positive_value(fmt, upper) == magnitude:
        return upper
    lower = max(0, upper - 1)
    if mode == 'rtz' or mode == 'rdn' and not negative or mode == 'rup' and negative:
        return lower
    if mode != 'rne':
        return upper
    # The next unbounded normal value defines the nearest overflow midpoint.
    upper_value = power(((1 << e) - 2) - bias + 1) if upper == infinity else positive_value(fmt, upper)
    dl = magnitude - positive_value(fmt, lower)
    du = upper_value - magnitude
    return lower if dl < du or dl == du and lower % 2 == 0 else upper


def precision_value(fmt, magnitude, mode, negative):
    p, _, _ = fmt
    if not magnitude:
        return Q(0)
    exponent = magnitude.numerator.bit_length() - magnitude.denominator.bit_length()
    if magnitude < power(exponent):
        exponent -= 1
    # A four-exponent-field local format contains the entire input binade,
    # its predecessor, and its successor, without subnormal or overflow loss.
    local = (p, 2, 1 - exponent)
    return positive_value(local, select_magnitude(local, magnitude, mode, negative))


def rounded(width, value, zero_sign, mode, tiny):
    if not value:
        return (int(zero_sign) << (width - 1)), 0
    fmt = FORMATS[width]
    p, e, bias = fmt
    negative = value < 0
    magnitude = abs(value)
    selected = select_magnitude(fmt, magnitude, mode, negative)
    infinity = ((1 << e) - 1) << p
    precise = precision_value(fmt, magnitude, mode, negative)
    overflow = precise > positive_value(fmt, infinity - 1)
    inexact = selected == infinity or positive_value(fmt, selected) != magnitude
    underflow = (magnitude if tiny == 'before' else precise) < power(1 - bias) and inexact
    return (int(negative) << (width - 1)) | selected, int(inexact) | (int(underflow) << 1) | (int(overflow) << 2)


def nan_bits(width, negative=False, payload=0):
    p, e, _ = FORMATS[width]
    return (int(negative) << (width - 1)) | (((1 << e) - 1) << p) | (1 << (p - 1)) | (payload % (1 << (p - 1)))


def expected(r):
    width = int(r['format'][2:])
    target = int(r.get('target', r['format'])[2:])
    op, mode, tiny = r['operation'], r['mode'], r['tininess']
    args = [decode(width, r[k]) for k in ('a', 'b', 'c') if k in r]
    if op == 'convert':
        kind, sign, value, signaling, payload = args[0]
        if kind == 'nan':
            delta = FORMATS[target][0] - FORMATS[width][0]
            payload = payload << delta if delta >= 0 else payload >> -delta
            return nan_bits(target, sign, payload), 16 if signaling else 0
        if kind == 'inf':
            p, e, _ = FORMATS[target]
            return (int(sign) << (target - 1)) | (((1 << e) - 1) << p), 0
        return rounded(target, value, sign, mode, tiny)
    a, b = args[:2]
    bad_product = ((a[0] == 'inf' and b[0] == 'finite' and b[2] == 0) or
                   (b[0] == 'inf' and a[0] == 'finite' and a[2] == 0))
    nans = [x for x in args if x[0] == 'nan']
    if nans:
        chosen = next((x for x in nans if x[3]), nans[0])
        invalid = any(x[3] for x in nans) or op == 'fma' and bad_product
        return nan_bits(width, chosen[1], chosen[4]), 16 if invalid else 0
    if op == 'sub':
        b = (b[0], not b[1], -b[2] if b[2] is not None else None, False, 0)
    if op in ('add', 'sub'):
        terms = (a, b)
    else:
        if bad_product:
            return nan_bits(width), 16
        product_sign = a[1] != b[1]
        product = ('inf', product_sign, None, False, 0) if 'inf' in (a[0], b[0]) else ('finite', product_sign, a[2] * b[2], False, 0)
        if op == 'mul':
            terms = (product,)
        else:
            terms = (product, args[2])
    infinities = [x for x in terms if x[0] == 'inf']
    if infinities:
        if len({x[1] for x in infinities}) > 1:
            return nan_bits(width), 16
        p, e, _ = FORMATS[width]
        return (int(infinities[0][1]) << (width - 1)) | (((1 << e) - 1) << p), 0
    value = sum((x[2] for x in terms), Q(0))
    signs = {x[1] for x in terms}
    zero_sign = terms[0][1] if len(signs) == 1 else mode == 'rdn'
    return rounded(width, value, zero_sign, mode, tiny)


def edge_words(width):
    p, e, bias = FORMATS[width]
    inf, one = ((1 << e) - 1) << p, bias << p
    values = [0, 1, 2, (1 << p) - 1, 1 << p, (1 << p) + 1,
              one - 2, one - 1, one, one + 1, one + 2,
              inf - 2, inf - 1, inf, inf + 1, inf + (1 << (p - 1)), inf + (1 << (p - 1)) + 7]
    return values + [x | (1 << (width - 1)) for x in values]


def requests(exhaustive):
    rng = random.Random(SEED)
    for width in FORMATS:
        edge = edge_words(width)
        for mode in MODES:
            for tiny in ('before', 'after'):
                base = {'format': f'fp{width}', 'mode': mode, 'tininess': tiny}
                for op in ('add', 'sub', 'mul', 'fma'):
                    for a in edge:
                        for b in edge:
                            r = {**base, 'operation': op, 'a': a, 'b': b}
                            if op == 'fma':
                                r['c'] = rng.choice(edge)
                            yield 'edges', r
                    for _ in range(180):
                        r = {**base, 'operation': op, 'a': rng.getrandbits(width), 'b': rng.getrandbits(width)}
                        if op == 'fma':
                            r['c'] = rng.getrandbits(width)
                        yield 'random', r
                for target in FORMATS:
                    for a in edge + [rng.getrandbits(width) for _ in range(120)]:
                        yield 'conversion', {**base, 'operation': 'convert', 'target': f'fp{target}', 'a': a}
                # Exact cancellation after a product beyond the finite range.
                p, e, bias = FORMATS[width]
                maximum = (((1 << e) - 1) << p) - 1
                for a, b, c in [(maximum, (bias + 1) << p, maximum | (1 << (width - 1))),
                                ((bias << p) + 1, (bias << p) - 2, (bias << p) | (1 << (width - 1)))]:
                    yield 'fused_boundary', {**base, 'operation': 'fma', 'a': a, 'b': b, 'c': c}
    for source, target in ((32, 16), (64, 16), (64, 32)):
        p, e, bias = FORMATS[target]
        maximum = positive_value(FORMATS[target], (((1 << e) - 1) << p) - 1)
        normal = power(1 - bias)
        small_ulp = power(1 - bias - p)
        large_ulp = power(((1 << e) - 2) - bias - p)
        values = [maximum + large_ulp * Q(n, 8) for n in range(-8, 25)]
        values += [normal + small_ulp * Q(n, 16) for n in range(-32, 17)]
        values += [small_ulp * Q(n, 16) for n in range(1, 33)]
        for x in values:
            for sign in (-1, 1):
                code = '>f' if source == 32 else '>d'
                a = int.from_bytes(struct.pack(code, float(sign * x)), 'big')
                for mode in MODES:
                    for tiny in ('before', 'after'):
                        yield 'rounding_threshold', {'operation': 'convert', 'format': f'fp{source}',
                            'target': f'fp{target}', 'mode': mode, 'tininess': tiny, 'a': a}
    if exhaustive:
        for word in range(65536):
            for target in (16, 32, 64):
                yield 'all_fp16_words', {'operation': 'convert', 'format': 'fp16', 'target': f'fp{target}',
                                         'mode': 'rne', 'tininess': 'after', 'a': word}


def flags_number(flags):
    assert set(flags) == set(FLAG_NAMES), flags
    assert all(type(value) is bool for value in flags.values()), flags
    return sum(int(flags[name]) << i for i, name in enumerate(FLAG_NAMES))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--softfloat', type=Path, help='Built SoftFloat reference runner')
    parser.add_argument('--quick', action='store_true', help='Omit exhaustive FP16 conversion enumeration')
    args = parser.parse_args()
    started = time.monotonic()
    subprocess.run(['lake', 'build', 'tc_ieee'], cwd=ROOT, check=True, stdout=subprocess.DEVNULL)
    cases = list(requests(not args.quick))
    data = ''.join(json.dumps(r, separators=(',', ':')) + '\n' for _, r in cases)
    result = subprocess.run([str(ROOT / '.lake/build/bin/tc_ieee'), '-'], input=data, text=True, capture_output=True, check=True)
    actual = [json.loads(line) for line in result.stdout.splitlines()]
    assert len(actual) == len(cases), (len(actual), len(cases))
    soft = None
    if args.softfloat:
        sf_input = ''.join(f"{r['operation']} {r['format'][2:]} {r.get('target', r['format'])[2:]} {MODES.index(r['mode'])} {int(r['tininess'] == 'after')} {r['a']} {r.get('b', 0)} {r.get('c', 0)}\n" for _, r in cases)
        sf_run = subprocess.run([str(args.softfloat.resolve())], input=sf_input, text=True, capture_output=True, check=True)
        soft = [tuple(map(int, line.split())) for line in sf_run.stdout.splitlines()]
        assert len(soft) == len(cases)
    failures, payload_differences = [], 0
    flags_seen = Counter()
    for index, ((group, r), got) in enumerate(zip(cases, actual)):
        want = expected(r)
        observed = got['bits'], flags_number(got['flags'])
        flags_seen[observed[1]] += 1
        if want != observed:
            failures.append({'index': index, 'source': 'ordered_encoding_oracle', 'request': r, 'expected': want, 'actual': observed})
        if soft is not None and soft[index] != observed:
            width = int(r.get('target', r['format'])[2:])
            sd, gd = decode(width, soft[index][0]), decode(width, observed[0])
            permitted_nan_policy = sd[0] == gd[0] == 'nan' and not sd[3] and not gd[3] and soft[index][1] == observed[1] and r['operation'] != 'convert'
            if permitted_nan_policy:
                payload_differences += 1
            else:
                failures.append({'index': index, 'source': 'softfloat', 'request': r, 'expected': soft[index], 'actual': observed})
    invalid_requests = [
        {'operation': 'add', 'format': 'fp16', 'mode': 'rne', 'a': 65536, 'b': 0},
        {'operation': 'add', 'format': 'fp16', 'mode': 'unknown', 'a': 0, 'b': 0},
        {'operation': 'convert', 'format': 'fp16', 'target': 'bf16', 'mode': 'rne', 'a': 0},
        {'operation': 'fma', 'format': 'fp32', 'mode': 'rne', 'a': 0, 'b': 0},
        {'operation': 'mul', 'format': 'fp32', 'mode': 'rne', 'tininess': 'unknown', 'a': 0, 'b': 0},
        {'operation': 'add', 'format': 'fp64', 'mode': 'rne', 'a': -1, 'b': 0},
    ]
    for bad in invalid_requests:
        rejected = subprocess.run([str(ROOT / '.lake/build/bin/tc_ieee'), '-'],
                                  input=json.dumps(bad) + '\n', text=True, capture_output=True)
        assert rejected.returncode == 2 and not rejected.stdout, (bad, rejected)
        assert json.loads(rejected.stderr)['error'] == 'invalid_request'
    malformed = subprocess.run([str(ROOT / '.lake/build/bin/tc_ieee'), '-'],
                               input='{invalid json}\n', text=True, capture_output=True)
    assert malformed.returncode == 2 and not malformed.stdout
    sources = [*sorted((ROOT / 'TensorCore/IEEE').glob('*.lean')),
               ROOT / 'TensorCore/Cli/IEEE.lean', ROOT / 'IEEEMain.lean',
               Path(__file__).resolve(), ROOT / 'tests/ieee/softfloat_oracle.c']
    report = {'status': 'passed' if not failures else 'failed', 'seed': SEED, 'cases': len(cases),
              'groups': dict(Counter(g for g, _ in cases)), 'flag_combinations': dict(flags_seen),
              'ordered_encoding_oracle': True, 'softfloat_compared': soft is not None,
              'softfloat_nan_policy_differences': payload_differences, 'failures': len(failures),
              'first_failures': failures[:15], 'request_sha256': hashlib.sha256(data.encode()).hexdigest(),
              'invalid_request_controls': len(invalid_requests) + 1,
              'source_sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
              'elapsed_seconds': round(time.monotonic() - started, 3)}
    path = ROOT / 'data/regressions' / ('ieee-softfloat-report.json' if soft is not None else 'ieee-report.json')
    path.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    return bool(failures)


if __name__ == '__main__':
    if not __debug__:
        raise SystemExit('Run without Python -O; checks use assertions.')
    raise SystemExit(main())
