#!/usr/bin/env python3
"""Replay pinned L40S FP8 rows with explicit paper/source output-precision readings.

The paper reading remains the specification candidate; source13 is a separately
named finite-domain model of v0.5's normalized 13-fraction-bit output. A passing
check requires source13 to match the archive AND retains the known paper/archive
discrepancy. It does not claim reconciliation or new hardware measurements.
The source-location review is a human interpretation recorded with the tests;
passing numerical comparisons do not establish its correspondence to the paper.
"""
from fractions import Fraction as Q
from functools import lru_cache
from pathlib import Path
import hashlib
import json
import subprocess

from check_device import read_hex_rows, read_bin
from check_features import decode, round32_search, run_rows

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'vendor/matlab-tensor-core-v0.5'


@lru_cache(None)
def fp8_decode(word, fmt):
    """Independent FP8 field decoding, including E4M3's finite top exponent."""
    assert 0 <= word < 256
    frac, expbits, bias = (3, 4, 7) if fmt == 'e4m3' else (2, 5, 15)
    exponent = (word >> frac) & ((1 << expbits) - 1)
    fraction = word & ((1 << frac) - 1)
    if exponent == (1 << expbits) - 1:
        if fmt == 'e5m2' or fraction == (1 << frac) - 1:
            return None
    scale = 1 - bias if exponent == 0 else exponent - bias
    sig = fraction if exponent == 0 else (1 << frac) + fraction
    if word & 128:
        sig = -sig
    return Q(sig) * Q(2) ** (scale - frac), scale


@lru_cache(None)
def fp32_decode(word):
    return decode(word, 23, 8, 127)


round32 = lru_cache(None)(round32_search)


def exact_fp8_word(word, fmt, lookup):
    value = fp32_decode(word)
    assert value is not None, ('nonfinite archive operand', hex(word))
    if value[0] == 0:
        packed = (word >> 31) << 7
    else:
        assert value[0] in lookup, ('not exactly FP8', fmt, hex(word))
        packed = lookup[value[0]]
    assert fp8_decode(packed, fmt)[0] == value[0]
    return packed


def oracle_block(pairs, c, fmt, reading):
    """Exact signed magnitude truncation; final FP32 uses neighbor search."""
    dc = fp32_decode(c)
    ds = [(fp8_decode(a, fmt), fp8_decode(b, fmt)) for a, b in pairs]
    if dc is None or any(a is None or b is None for a, b in ds):
        return None
    terms = [dc] + [(a[0] * b[0], a[1] + b[1]) for a, b in ds]
    eta = max((scale for value, scale in terms if value), default=0)
    quantum = Q(2) ** (eta - 13)
    acc = sum((int(value / quantum) * quantum for value, _ in terms), Q(0))
    bits = round32(acc)
    if bits is None:
        return None
    if reading == 'source13':
        # Equivalent numerical truncation for the same exponent range. The
        # converter's finite-range guard is separate from truncation itself.
        if abs(acc) > fp32_decode(0x7f7ffc00)[0]:
            return None
        bits &= ~1023
    value = fp32_decode(bits)[0]
    ideal = sum((value for value, _ in terms), Q(0))
    return dict(bits=bits, value=value, accumulated=acc, residual=ideal - value)


def oracle_row(pairs, c, fmt, reading):
    assert len(pairs) == 32
    first = oracle_block(pairs[:16], c, fmt, reading)
    if first is None:
        return None
    second = oracle_block(pairs[16:], first['bits'], fmt, reading)
    if second is None:
        return None
    ideal = fp32_decode(c)[0] + sum(
        (fp8_decode(a, fmt)[0] * fp8_decode(b, fmt)[0] for a, b in pairs), Q(0))
    return dict(bits=second['bits'], value=second['value'], ideal=ideal,
                outputs=[first['bits'], second['bits']],
                accumulated=[first['accumulated'], second['accumulated']],
                residuals=[first['residual'], second['residual']])


def row_command(fmt, reading, pairs, c):
    return f'fp8-row {fmt} {reading} ' + ' '.join(
        map(str, [word for pair in pairs for word in pair] + [c]))


def check_trace(trace, expected, reading):
    if expected is None:
        assert 'error' in trace, trace
        return
    assert 'error' not in trace, trace
    for key in ['bits', 'outputs']:
        assert trace[key] == expected[key], (key, trace[key], expected[key])
    for key in ['value', 'ideal']:
        assert Q(trace[key]) == expected[key], (key, trace[key], expected[key])
    for key in ['accumulated', 'residuals']:
        assert list(map(Q, trace[key])) == expected[key], (key, trace[key], expected[key])
    assert Q(trace['ideal']) == Q(trace['value']) + sum(map(Q, trace['residuals']), Q(0))
    for group, events in enumerate(trace['intermediate']):
        assert len(events) == (1 if reading == 'source13' else 0)
        for event in events:
            assert event['fractionBits'] == 13 and event['mode'].endswith('towardZero')
            assert Q(event['input']) == expected['accumulated'][group]
            assert Q(event['value']) == fp32_decode(expected['outputs'][group])[0]
            assert Q(event['loss']) == Q(event['input']) - Q(event['value'])


def main():
    pins = json.loads((ROOT / 'vendor/SOURCES.json').read_text())
    files = ['models/AdaTC.m', 'models/tools/GEMM.m', 'models/tools/Generic_BFMA_TC.m',
             'model_validation/Validate_TC_models.m']
    files += [str(p.relative_to(BASE)) for p in sorted((BASE / 'model_validation/L40S').glob('E*/*.txt'))]
    assert len(files) == 12
    for name in files:
        assert hashlib.sha256((BASE / name).read_bytes()).hexdigest() == pins['sha256'][name], name
    report = dict(source='MATLAB Tensor Core v0.5, L40S/E4M3 and L40S/E5M2',
                  commit=pins['commit'], hashed_files=len(files),
                  paper='https://arxiv.org/html/2512.07004v4#S4.SS1.SSS4',
                  products_per_row=32, products_per_group=16, alignment_fraction_bits=13,
                  readings={'paper': 'FP32 toward-zero final conversion',
                            'source13': '13-fraction-bit toward-zero conversion, then FP32 encoding'},
                  status='UNRESOLVED paper/source final-precision discrepancy; source13 matches archive',
                  no_new_gpu_measurements=True, formats={})
    report['precision_review'] = dict(
        conclusion='The paper establishes alignment width, but does not establish the source13 normalized truncation.',
        unresolved_claim='After each 16-product group, must the normalized aligned sum be truncated to 13 fraction bits before FP32 encoding?',
        paper_locations={
            'section_2_pp5_6': 'neab counts alignment/guard bits relative to output precision',
            'section_4_1_4_p10': '13-fraction-bit alignment and early-c probes; both readings satisfy the reported endpoints',
            'section_4_1_5_p10': 'Ada RTX 1000 shares L40S numerical features; no additional precision rule',
            'figure_4_p11': '(2,13,0) alignment, 20-bit sum, FP32 Norm/Trunc; no explicit normalized 13-bit boundary',
            'table_3_p14_and_note': 'FP32 output, truncation, (2,13) alignment; Acc.20 includes carry bits, not a 13-bit normalized significand'},
        source_locations={
            'models/AdaTC.m:55-73,105-107': 'rz, in-group c, denormalized products, floor -132, fma=16, neab=-10',
            'models/tools/GEMM.m:80-96': 'FP32 NoManBitsOut=23, then add neab=-10 to obtain 13',
            'models/tools/Generic_BFMA_TC.m:478-489,570-589': 'align and sum, then normalize with neab=-10',
            'models/tools/Generic_BFMA_TC.m:266-293': 'rz skips ieeeround; normalized mantissa slice retains NoManBitsOut=13 fraction bits',
            'models/tools/GEMM.m:233-242': 'every group calls Generic_BFMA_TC and passes its output as c'},
        mechanism='Alignment uses 2^(eta-13); after a carry the source normalized grid is coarser. FP32 can retain the bit lost by source13.',
        evidence_limit='Archive endpoint agreement supports the source candidate on these rows, not a universal paper/source or physical-device conformance theorem.',
        paper_probe_caveat='Section 4.1.4 states p1=1 but its stopping expression is 1+p1+p2; tests use the explicit numerical endpoint 1+2^-12, without silently repairing that expression.',
        numerical_semantics_changed=False)
    checked_sources = ['TensorCore/Semantics/FP8.lean', 'TensorCore/Programs/FP8.lean',
                       'TensorCore/Theory/FP8.lean', 'TensorCore/Regression/FP8.lean',
                       'FeatureMain.lean', 'scripts/check_device_fp8.py']
    report['checked_source_sha256'] = {
        name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in checked_sources}
    for fmt in ['e4m3', 'e5m2']:
        name = fmt.upper()
        folder = BASE / 'model_validation/L40S' / name
        a_rows = read_hex_rows(folder / f'a_L40S_{name}.txt')
        b_rows = read_hex_rows(folder / f'b_L40S_{name}.txt')
        c_words = read_bin(folder / 'c_L40S_fp32.txt')
        d_words = read_bin(folder / 'd_L40S_fp32.txt')
        assert len(a_rows) == len(b_rows) == len(c_words) == len(d_words) == 5000
        assert all(len(row) == 32 for row in a_rows + b_rows)
        lookup = {fp8_decode(w, fmt)[0]: w for w in range(256) if fp8_decode(w, fmt) is not None}
        pairs = [[(exact_fp8_word(a, fmt, lookup), exact_fp8_word(b, fmt, lookup))
                  for a, b in zip(ar, br)] for ar, br in zip(a_rows, b_rows)]
        summary = dict(vectors=len(pairs), readings={}, first_row=dict(
            pairs=pairs[0], c=c_words[0], device=d_words[0]),
            zero_operands=sum(w & 127 == 0 for ps in pairs for pair in ps for w in pair),
            subnormal_operands=sum(0 < w & 127 < (8 if fmt == 'e4m3' else 4)
                                   for ps in pairs for pair in ps for w in pair))
        for reading in ['paper', 'source13']:
            inputs = [(ps, c) for ps, c in zip(pairs, c_words)]
            inputs += [(ps[16:] + ps[:16], c) for ps, c in zip(pairs, c_words)]
            traces = run_rows([row_command(fmt, reading, ps, c) for ps, c in inputs],
                              f'device-l40s-{fmt}-{reading}.txt')
            for trace, (ps, c) in zip(traces, inputs):
                check_trace(trace, oracle_row(ps, c, fmt, reading), reading)
            n = len(pairs)
            mismatches = [i for i, (t, d) in enumerate(zip(traces[:n], d_words)) if t['bits'] != d]
            order_changes = [i for i in range(n) if traces[i]['bits'] != traces[n+i]['bits']]
            merged_changes = sum(oracle_block(ps, c, fmt, reading)['bits'] != t['bits']
                                 for ps, c, t in zip(pairs, c_words, traces))
            assert order_changes and merged_changes, 'order/group-size negative controls must distinguish'
            if reading == 'source13':
                assert not mismatches, (fmt, mismatches[:10])
            else:
                assert len(mismatches) == {'e4m3': 1055, 'e5m2': 962}[fmt]
            summary['readings'][reading] = dict(
                compiled_oracle_comparisons=len(inputs), numerical_oracle_mismatches=0,
                archive_bit_mismatches=len(mismatches), first_mismatch_row_1based=(mismatches[0]+1 if mismatches else None),
                reversed_group_differences=len(order_changes), merged_group_differences=merged_changes,
                first_outputs=traces[0]['outputs'], first_reversed_outputs=traces[n]['outputs'])
            # The checker must reject corrupted bits, intermediate boundaries, and ledgers.
            for field in ['bits', 'outputs', 'residuals']:
                corrupted = json.loads(json.dumps(traces[0]))
                if field == 'bits':
                    corrupted[field] ^= 1
                elif field == 'outputs':
                    corrupted[field][0] ^= 1
                else:
                    corrupted[field][0] = str(Q(corrupted[field][0]) + 1)
                try:
                    check_trace(corrupted, oracle_row(pairs[0], c_words[0], fmt, reading), reading)
                except AssertionError:
                    pass
                else:
                    raise AssertionError(('corrupted trace accepted', fmt, reading, field))
        report['formats'][fmt] = summary

    # Exhaustively check both 8-bit decoding domains, independently of archive coverage.
    decode_inputs = [(fmt, w) for fmt in ['e4m3', 'e5m2'] for w in range(256)]
    decoded = run_rows([f'decode {fmt} {w}' for fmt, w in decode_inputs], 'fp8-decode-all.txt')
    for t, (fmt, w) in zip(decoded, decode_inputs):
        expected = fp8_decode(w, fmt)
        assert t['value'] is None if expected is None else Q(t['value']) == expected[0]
    boundary_inputs = []
    for fmt in ['e4m3', 'e5m2']:
        one, maximum, special = (0x38, 0x7e, 0x7f) if fmt == 'e4m3' else (0x3c, 0x7b, 0x7c)
        cases = [([(0, 0)]*32, c) for c in [0, 0x80000000, 1, 0x80000001, 0x7fffff, 0x7f7fffff]]
        cases += [([(a, b)]+[(0, 0)]*31, 0) for a, b in
                  [(1, one), (0x81, one), (maximum, maximum), (maximum, one), (special, one)]]
        cases += [([(one, one)]*32, c) for c in [0x7f800000, 0x7fc00000]]
        for reading in ['paper', 'source13']:
            boundary_inputs += [(fmt, reading, ps, c) for ps, c in cases]
    boundaries = run_rows([row_command(*args) for args in boundary_inputs], 'fp8-boundaries.txt')
    for trace, (fmt, reading, ps, c) in zip(boundaries, boundary_inputs):
        check_trace(trace, oracle_row(ps, c, fmt, reading), reading)

    # Hard-coded distinguishing results in addition to the independent oracle.
    # Companion kernel theorems in Regression/FP8 locate alignment/conversion loss.
    precision_inputs = []
    for fmt in ['e4m3', 'e5m2']:
        one, small, smaller = ((0x38, (0x08, 0x04), (0x08, 0x02)) if fmt == 'e4m3'
                               else (0x3c, (0x20, 0x24), (0x20, 0x20)))
        zeros = [(0, 0)] * 16
        carry = [(one, one), (one, one), small] + [(0, 0)] * 13
        cases = [
            ('carry_last', zeros + carry, 0, [0, 0x40000200], [0, 0x40000000]),
            ('negative_carry_last', zeros + [(a ^ 128, b) for a, b in carry], 0,
             [0, 0xc0000200], [0, 0xc0000000]),
            ('alignment_probe', zeros + [(one, one), small, small] + [(0, 0)] * 13, 0,
             [0, 0x3f800800], [0, 0x3f800800]),
            ('early_c_probe', zeros + [smaller, smaller] + [(0, 0)] * 14, 0x3f800000,
             [0x3f800000, 0x3f800000], [0x3f800000, 0x3f800000]),
            ('carry_first_absorbed', carry + zeros, 0,
             [0x40000200, 0x40000000], [0x40000000, 0x40000000]),
            ('cancellation', zeros + [(one, one), (one ^ 128, one), small] + [(0, 0)] * 13, 0,
             [0, 0x39000000], [0, 0x39000000])]
        for name, ps, c, paper, source in cases:
            for reading, expected in [('paper', paper), ('source13', source)]:
                precision_inputs.append((name, fmt, reading, ps, c, expected))
    precision_traces = run_rows([row_command(fmt, reading, ps, c)
        for _, fmt, reading, ps, c, _ in precision_inputs], 'fp8-precision-controls.txt')
    report['precision_controls'] = []
    for trace, (name, fmt, reading, ps, c, expected) in zip(precision_traces, precision_inputs):
        check_trace(trace, oracle_row(ps, c, fmt, reading), reading)
        assert trace['outputs'] == expected, (name, fmt, reading, trace)
        report['precision_controls'].append(dict(case=name, format=fmt, reading=reading,
            outputs=trace['outputs'], accumulated=trace['accumulated'], residuals=trace['residuals']))
    for n in [0, 16, 31, 33]:
        trace = run_rows([row_command('e4m3', 'source13', [(0, 0)]*n, 0)], f'fp8-shape-{n}.txt')[0]
        assert trace['error'].endswith('wrongProductCount')
    invalid = [row_command('e4m3', 'source13', [(256, 0)]+[(0, 0)]*31, 0),
               row_command('e5m2', 'paper', [(0, 0)]*32, 2**32),
               'fp8-row e4m3 source13 1 0', 'fp8-row e4m3 unknown 0']
    for command in invalid:
        p = subprocess.run([str(ROOT / '.lake/build/bin/tc_features'), *command.split()],
                           text=True, capture_output=True)
        assert p.returncode != 0 and 'Invalid feature command' in p.stderr
    report.update(exhaustive_decode_comparisons=len(decode_inputs),
                  boundary_comparisons=len(boundary_inputs), wrong_shape_checks=4,
                  precision_control_comparisons=len(precision_inputs),
                  parser_negative_controls=len(invalid), corrupt_trace_negative_controls=12,
                  archive_comparisons=20000, reversed_group_comparisons=20000,
                  paper_archive_mismatches=2017, source13_archive_mismatches=0,
                  numerical_oracle_mismatches=0)
    (ROOT / 'data/regressions/device-fp8-report.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
