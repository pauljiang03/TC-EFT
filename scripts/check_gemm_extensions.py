#!/usr/bin/env python3
"""Independent Fraction checks for GEMM certificates, scaling, and conversions."""
from fractions import Fraction as Q
from pathlib import Path
import hashlib
import json
import subprocess
import time

from check_features import decode
from check_gemm import cases as raw_cases, oracle as raw_oracle, PROFILES

ROOT = Path(__file__).resolve().parents[1]
FORMATS = {'fp16': (10, 5, 15), 'fp32': (23, 8, 127),
           'bf16': (7, 8, 127), 'fp64': (52, 11, 1023)}
MODES = ['rne', 'rtz', 'rdn', 'rup']


def value(bits, fmt):
    d = decode(bits, *FORMATS[fmt])
    return None if d is None else d[0]


def rounded(x, fmt, mode):
    """Search ordered encodings; explicitly select directed/nearest-even neighbor."""
    f, e, _ = FORMATS[fmt]
    maximum = (((1 << e) - 1) << f) - 1
    if abs(x) > value(maximum, fmt):
        return None
    lo, hi = 0, maximum
    while lo < hi:
        mid = (lo + hi + 1) // 2
        if value(mid, fmt) <= abs(x):
            lo = mid
        else:
            hi = mid - 1
    if value(lo, fmt) != abs(x):
        if mode == 'rne':
            down, up = abs(x) - value(lo, fmt), value(lo + 1, fmt) - abs(x)
            lo += up < down or (up == down and lo % 2 == 1)
        elif mode == 'rdn':
            lo += x < 0
        elif mode == 'rup':
            lo += x > 0
    return lo | ((1 << (f + e)) if x < 0 else 0)


def converted(case, key):
    result = []
    for bits in case[key]:
        v = value(bits, case['input_format'])
        w = None if v is None else rounded(v, 'fp16', case['input_mode'])
        if w is None:
            return None
        result.append(w)
    return result


def scaled_expected(case, a, b, i, j):
    raw = {**case, 'a': a, 'b': b, 'c': [0] * (case['m'] * case['n'])}
    product, exact = raw_oracle(raw, i, j)
    alpha, beta = value(case['alpha'], 'fp32'), value(case['beta'], 'fp32')
    c = value(case['c'][i * case['n'] + j], 'fp32')
    ideal = None if None in (alpha, beta, c, exact) else alpha * exact + beta * c
    if 'error' in product or None in (alpha, beta, c):
        return None, ideal
    p = value(product['bits'], 'fp32')
    ad = rounded(alpha * p, 'fp32', case['multiply_mode'])
    bc = rounded(beta * c, 'fp32', case['multiply_mode'])
    if ad is None or bc is None:
        return None, ideal
    s = rounded(value(ad, 'fp32') + value(bc, 'fp32'), 'fp32', case['add_mode'])
    if s is None:
        return None, ideal
    out = rounded(value(s, 'fp32'), case['output_format'], case['output_mode'])
    if out is None:
        return None, ideal
    return dict(bits=out, stages=[ad, bc, s], product_bits=product['bits'],
                instructions=product['instructions']), ideal


def source_expected(case, a, b, i, j, tight=False):
    """Original-format ideal and independent operand-perturbation expansion."""
    exact, input_bound = Q(0), Q(0)
    for l in range(case['k']):
        ai, bi = i * case['k'] + l, l * case['n'] + j
        x, y = value(case['a'][ai], case['input_format']), value(case['b'][bi], case['input_format'])
        dx, dy = abs(x - value(a[ai], 'fp16')), abs(y - value(b[bi], 'fp16'))
        exact += x * y
        input_bound += (min(abs(x) * dy + abs(value(b[bi], 'fp16')) * dx,
                            abs(value(a[ai], 'fp16')) * dy + abs(y) * dx) if tight else
                        abs(x) * dy + abs(y) * dx + dx * dy)
    alpha, beta = value(case['alpha'], 'fp32'), value(case['beta'], 'fp32')
    c = value(case['c'][i * case['n'] + j], 'fp32')
    ideal = None if None in (alpha, beta, c) else alpha * exact + beta * c
    return ideal, input_bound


def certificate_expected(case):
    count, extra, floor = PROFILES[case['model']]
    E, P, L, C = [case[x] for x in ['accumulator_scale', 'product_scale', 'carry_bits', 'initial_bound']]
    blocks = ((case['k'] + 15) // 16) * (16 // count)
    local = (count + 1) * Q(2) ** (E - 23 - extra) + Q(2) ** (max(E + 1 + L, -126) - 23)
    bound = blocks * local
    accepted = True
    for i in range(case['m']):
        for j in range(case['n']):
            valid = (-126 <= E and P <= E and (floor is None or floor <= E)
                     and count + 1 <= 2 ** L and E + 2 + L <= 127)
            c = value(case['c'][i * case['n'] + j], 'fp32')
            valid &= c is not None and abs(c) <= C
            valid &= C + blocks * (count * (4 * Q(2) ** P) + local) < Q(2) ** (E + 1)
            for l in range(case['k']):
                a = decode(case['a'][i * case['k'] + l], 10, 5, 15)
                b = decode(case['b'][l * case['n'] + j], 10, 5, 15)
                valid &= a is not None and b is not None
                if a is not None and b is not None and a[0] * b[0]:
                    valid &= a[1] + b[1] <= P
            accepted &= valid
    return accepted, bound


def scaled_certificate_expected(case, a, b, tight=False):
    raw = {**case, 'a': a, 'b': b, 'c': [0] * (case['m'] * case['n'])}
    accepted, raw_bound = certificate_expected(raw)
    count, _, _ = PROFILES[case['model']]
    blocks = ((case['k'] + 15) // 16) * (16 // count)
    product_bound = blocks * count * 4 * Q(2) ** case['product_scale']
    scales = [case[key] for key in ['alpha_scale', 'beta_scale', 'sum_scale', 'output_scale']]
    formats = ['fp32'] * 3 + [case['output_format']]
    caps = [Q(2) ** s for s in scales]
    errors = [Q(2) ** (s - FORMATS[f][0]) for s, f in zip(scales, formats)]
    valid = True
    for scale, fmt in zip(scales, formats):
        frac, exp, bias = FORMATS[fmt]
        maximum = (((1 << exp) - 1) << frac) - 1
        valid &= 1 - bias <= scale and Q(2) ** scale <= value(maximum, fmt)
    alpha, beta = value(case['alpha'], 'fp32'), value(case['beta'], 'fp32')
    modes = [case['multiply_mode']] * 2 + [case['add_mode'], case['output_mode']]
    bound_errors = [e / 2 if tight and mode == 'rne' else e for e, mode in zip(errors, modes)]
    bound = abs(alpha or Q(0)) * raw_bound + sum(bound_errors, Q(0))
    for word in case['c']:
        c = value(word, 'fp32')
        finite = None not in (alpha, beta, c)
        accepted &= valid and finite
        if finite:
            accepted &= abs(alpha) * (product_bound + raw_bound) <= caps[0]
            accepted &= abs(beta) * abs(c) <= caps[1]
            accepted &= caps[0] + errors[0] + caps[1] + errors[1] <= caps[2]
            accepted &= caps[2] + errors[2] <= caps[3]
    return accepted, bound


def cases():
    result = []
    for base in raw_cases():
        for mode in MODES:
            for out in ['fp32', 'fp16']:
                result.append({**base, 'operation': 'scaled', 'alpha': 0x40000000,
                    'beta': 0xbf000000, 'input_format': 'fp16', 'output_format': out,
                    'input_mode': mode, 'multiply_mode': mode, 'add_mode': mode, 'output_mode': mode})
        result.append({**base, 'operation': 'certify', 'accumulator_scale': 40,
                       'product_scale': 30, 'carry_bits': 5, 'initial_bound': 1})
    for model in PROFILES:
        base = dict(model=model, operation='scaled', m=1, n=1, k=0, a=[], b=[],
                    c=[0x3f800001], alpha=0, beta=0x3f800001, input_format='fp16',
                    output_format='fp32', input_mode='rne', multiply_mode='rne',
                    add_mode='rne', output_mode='rne')
        for mode in MODES:
            result.append({**base, 'c': [0x3f808000], 'beta': 0x3f800000,
                           'output_format': 'bf16', 'output_mode': mode})
            for beta in [0x3f800001, 0xbf800001]:
                result.append({**base, 'multiply_mode': mode, 'beta': beta})
            for fmt, word in [('fp32', 0x3f801000), ('bf16', 0x3f81), ('fp64', 0x3ff0020000000000)]:
                result.append({**base, 'k': 1, 'a': [word],
                               'b': [rounded(Q(1), fmt, 'rne')], 'alpha': 0x3f800000, 'beta': 0,
                               'input_format': fmt, 'input_mode': mode, 'output_format': 'fp64'})
            for output_mode in MODES:
                result.append({**base, 'c': [0x3f801000], 'beta': 0x3f800000,
                               'add_mode': mode, 'output_format': 'fp16', 'output_mode': output_mode})
            # Adversarial add: an exactly representable TC product halfway between FP32 neighbors of 1.
            result.append({**base, 'k': 1, 'a': [0x0c00], 'b': [0x0c00],
                           'alpha': 0x3f800000, 'beta': 0x3f800000, 'c': [0x3f800000], 'add_mode': mode})
        for change in [dict(beta=0x7f800000), dict(beta=0x40000000, c=[0x7f7fffff]),
                       dict(alpha=0x7fc00000), dict(c=[0x7fc00000]),
                       dict(beta=0, c=[0x7fc00000]),
                       dict(k=1, input_format='fp32', a=[0x7f7fffff], b=[0]),
                       dict(k=1, input_format='fp32', a=[0x7fc00000], b=[0]),
                       dict(alpha=0x80000000, beta=0x3f800000, c=[0x80000000]),
                       dict(beta=0x3f800000, c=[0x47800000], output_format='fp16')]:
            result.append({**base, **change})
        cert = dict(model=model, operation='certify', m=2, n=3, k=17,
                    a=[0x2bff] * 34, b=[0xabff] * 51, c=[0x3f800000] * 6,
                    accumulator_scale=1, product_scale=-10, carry_bits=5, initial_bound=1)
        result.append(cert)
        for change in [dict(product_scale=-11), dict(carry_bits=0), dict(accumulator_scale=-127),
                       dict(accumulator_scale=124), dict(initial_bound=4), dict(initial_bound=-1),
                       dict(c=[0x7f800000] * 6), dict(a=[0x7c00] * 34)]:
            result.append({**cert, **change})
        for k in [0, 1, 15, 16, 256, 1024]:
            result.append({**cert, 'k': k, 'a': [0x2bff] * (2 * k), 'b': [0xabff] * (3 * k)})
        full = {**cert, 'operation': 'certify_scaled', 'alpha': 0x40000000, 'beta': 0xbf000000,
                'input_format': 'fp16', 'input_mode': 'rne', 'output_format': 'fp32',
                'multiply_mode': 'rne', 'add_mode': 'rne', 'output_mode': 'rne',
                'alpha_scale': 0, 'beta_scale': 0, 'sum_scale': 2, 'output_scale': 3}
        full_cases = []
        for mode in MODES:
            for fmt in FORMATS:
                f = {**full, 'multiply_mode': mode, 'add_mode': mode,
                     'output_mode': mode, 'output_format': fmt}
                full_cases.append(f)
                full_cases.append({**f, 'input_format': 'fp32', 'input_mode': mode,
                                   'a': [0x3d001001] * 34, 'b': [0xbd001001] * 51})
        for change in [dict(alpha_scale=-10), dict(beta_scale=-2), dict(sum_scale=1),
                       dict(output_scale=2), dict(alpha_scale=128), dict(beta_scale=-127),
                       dict(output_format='fp16', output_scale=16),
                       dict(output_format='fp16', output_scale=-15),
                       dict(alpha=0x7f800000), dict(beta=0x7fc00000), dict(c=[0x7fc00000] * 6),
                       dict(a=[0x7c00] * 34), dict(carry_bits=0), dict(product_scale=-11)]:
            full_cases.append({**full, **change})
        full_cases.append({**full, 'm': 17, 'n': 19, 'k': 33, 'a': [0x2bff] * (17 * 33),
                           'b': [0xabff] * (33 * 19), 'c': [0x3f800000] * (17 * 19)})
        full_cases.append({**full, 'm': 0, 'a': [], 'c': []})
        full_cases.append({**full, 'k': 0, 'a': [], 'b': []})
        for f in full_cases:
            result.extend([f, {**f, 'operation': 'scaled'}])
        # Both operands lose bits; retain signs, source subnormals, and partial K tiles.
        values = [Q(2049, 131072), -Q(4099, 262144), Q(1, 1 << 26),
                  -Q(1, 1 << 26), Q(0), Q(1, 64)]
        for fmt in FORMATS:
            for im in MODES:
                f = {**full, 'input_format': fmt, 'input_mode': im, 'alpha': 0xc0000000,
                     'a': [rounded(values[i % len(values)], fmt, 'rne') for i in range(34)],
                     'b': [rounded(values[(i + 1) % len(values)], fmt, 'rne') for i in range(51)]}
                result.extend([f, {**f, 'operation': 'scaled'}])
        for im in MODES:
            tiny = {**full, 'm': 1, 'n': 1, 'k': 1, 'input_format': 'fp32', 'input_mode': im,
                    'a': [0x32800000], 'b': [0x32800000], 'c': [0], 'beta': 0}
            result.extend([tiny, {**tiny, 'operation': 'scaled'}, {**tiny, 'alpha': 0}])
            for bad in [0x47800000, 0xc7800000, 0x7f800000, 0x7fc00000]:
                result.append({**tiny, 'a': [bad], 'alpha': 0})
        for change in [dict(m=0, a=[], c=[], alpha=0x7fc00000),
                       dict(n=0, b=[], c=[], alpha=0x7fc00000),
                       dict(k=0, a=[], b=[]), dict(alpha=0)]:
            f = {**full, **change}
            result.extend([f, {**f, 'operation': 'scaled'}])
    return result


def compare(case, actual):
    if case['operation'] == 'certify_scaled':
        a, b = converted(case, 'a'), converted(case, 'b')
        if a is None or b is None:
            assert actual == {'input_conversion_rejected': True, 'accepted': False}
            return 0, 0, 0, 1
        accepted, bound = scaled_certificate_expected(case, a, b)
        assert actual['accepted'] == accepted, ('scaled certificate', case, actual)
        assert Q(actual['entry_bound']) == bound
        assert Q(actual['matrix_bound']) == case['m'] * case['n'] * bound
        _, tight_bound = scaled_certificate_expected(case, a, b, tight=True)
        assert Q(actual['tight_entry_bound']) == tight_bound <= bound
        assert Q(actual['tight_matrix_bound']) == case['m'] * case['n'] * tight_bound
        tight_total = Q(0)
        if accepted:
            total = Q(0)
            source_total, source_bound_total = Q(0), Q(0)
            for i in range(case['m']):
                for j in range(case['n']):
                    expected, ideal = scaled_expected(case, a, b, i, j)
                    assert expected is not None
                    error = abs(ideal - value(expected['bits'], case['output_format']))
                    assert error <= bound, (case, error, bound)
                    total += error
                    source_ideal, input_bound = source_expected(case, a, b, i, j)
                    source_bound = bound + abs(value(case['alpha'], 'fp32')) * input_bound
                    assert Q(actual['source_entry_bounds'][i][j]) == source_bound
                    source_error = abs(source_ideal - value(expected['bits'], case['output_format']))
                    assert source_error <= source_bound, (case, source_error, source_bound)
                    _, tight_input = source_expected(case, a, b, i, j, tight=True)
                    assert tight_input <= input_bound
                    tight_source = tight_bound + abs(value(case['alpha'], 'fp32')) * tight_input
                    assert Q(actual['tight_source_entry_bounds'][i][j]) == tight_source
                    assert source_error <= tight_source <= source_bound
                    tight_total += tight_source
                    source_total += source_error
                    source_bound_total += source_bound
            assert total <= Q(actual['matrix_bound'])
            assert Q(actual['source_matrix_bound']) == source_bound_total
            assert Q(actual['tight_source_matrix_bound']) == tight_total
            assert len(actual['tight_source_entry_bounds']) == case['m']
            assert all(len(row) == case['n'] for row in actual['tight_source_entry_bounds'])
            assert source_total <= source_bound_total
            assert len(actual['source_entry_bounds']) == case['m']
            assert all(len(row) == case['n'] for row in actual['source_entry_bounds'])
        else:
            assert actual['source_entry_bounds'] is None and actual['source_matrix_bound'] is None
            assert actual['tight_source_entry_bounds'] is None and actual['tight_source_matrix_bound'] is None
        return 0, 0, int(accepted), 0
    if case['operation'] == 'certify':
        accepted, bound = certificate_expected(case)
        assert actual['accepted'] == accepted, ('certificate', case)
        assert Q(actual['entry_bound']) == bound
        assert Q(actual['matrix_bound']) == case['m'] * case['n'] * bound
        if accepted:
            total = Q(0)
            for i in range(case['m']):
                for j in range(case['n']):
                    expected, ideal = raw_oracle(case, i, j)
                    assert 'error' not in expected
                    error = abs(ideal - value(expected['bits'], 'fp32'))
                    assert error <= bound
                    total += error
            assert total <= Q(actual['matrix_bound'])
        return 0, 0, int(accepted), 0
    a, b = converted(case, 'a'), converted(case, 'b')
    if a is None or b is None:
        assert actual == {'input_conversion_rejected': True}
        return 0, 0, 0, 1
    m, n, k = case['m'], case['n'], case['k']
    assert actual['converted_a'] == [a[i*k:(i+1)*k] for i in range(m)]
    assert actual['converted_b'] == [b[i*n:(i+1)*n] for i in range(k)]
    assert len(actual['rows']) == len(actual['ideal']) == m
    boundaries, rejected = 0, 0
    for i, (row, ideals) in enumerate(zip(actual['rows'], actual['ideal'])):
        assert len(row) == len(ideals) == n
        for j, (cell, z) in enumerate(zip(row, ideals)):
            expected, ideal = scaled_expected(case, a, b, i, j)
            source_ideal, input_bound = source_expected(case, a, b, i, j)
            actual_source = actual['source_ideal'][i][j]
            assert (None if actual_source is None else Q(actual_source)) == source_ideal
            assert Q(actual['input_product_bound'][i][j]) == input_bound
            assert (None if z is None else Q(z)) == ideal
            if expected is None:
                assert cell is None, case
                rejected += 1
            else:
                assert cell is not None
                for key, v in expected.items():
                    assert cell[key] == v, (case, i, j, key, cell, expected)
                v = value(expected['bits'], case['output_format'])
                assert Q(cell['value']) == v
                assert abs(ideal - v) <= Q(cell['error_budget'])
                boundaries += 4 + sum(map(len, expected['instructions']))
    return boundaries, rejected, 0, 0


DEPENDENCIES = '''import Lean
import TensorCore.Gemm.TightInputBounds
open Lean Elab Command
partial def visit (env : Environment) (n : Name) : StateM NameSet Unit := do
  if (← get).contains n then return
  modify (·.insert n)
  match env.find? n with
  | some (.defnInfo info) => info.value.getUsedConstants.forM (visit env)
  | some (.opaqueInfo info) => info.value.getUsedConstants.forM (visit env)
  | _ => pure ()
def audit (root : Name) : CommandElabM Unit := do
  let deps := ((visit (← getEnv) root).run {}).2
  let forbidden := [``TensorCore.gemm, ``TensorCore.simulateGemmCell,
    ``TensorCore.runGemmInstructions, ``TensorCore.evalBlock, ``TensorCore.runBlocks,
    ``TensorCore.scaledGemm, ``TensorCore.gemmEpilogue, ``TensorCore.convertedGemm,
    ``TensorCore.idealProducts, ``TensorCore.idealContributions, ``TensorCore.partialSumsCheck,
    ``TensorCore.sourceGemmProducts, ``TensorCore.sourceGemmCellIdeal, ``TensorCore.sourceGemmIdeal]
  unless (forbidden.filter deps.contains).isEmpty do throwError "Forbidden executable dependency"
  logInfo "input-only certificate dependency audit passed"
'''


def main():
    start = time.perf_counter()
    work = ROOT / 'tmp/gemm-extensions'
    work.mkdir(parents=True, exist_ok=True)
    build = subprocess.run(['lake', 'build', 'TensorCore.Regression.FoundationCompletion'],
                           cwd=ROOT, text=True, capture_output=True)
    (work / 'build.log').write_text(build.stdout + build.stderr)
    assert build.returncode == 0, build.stdout + build.stderr
    generated = cases()
    source = '\n'.join(json.dumps(x, separators=(',', ':')) for x in generated) + '\n'
    inputs = work / 'inputs.jsonl'
    inputs.write_text(source)
    command = ['lake', 'env', 'lean', '--run', 'examples/GemmExtensions.lean', str(inputs)]
    run = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, check=True)
    (work / 'outputs.jsonl').write_text(run.stdout)
    outputs = [json.loads(line) for line in run.stdout.splitlines()]
    assert len(outputs) == len(generated)
    totals = [0, 0, 0, 0]
    for case, actual in zip(generated, outputs):
        totals = [a + b for a, b in zip(totals, compare(case, actual))]
    controls = []
    for key in ['bits', 'stages', 'instructions']:
        wrong = json.loads(json.dumps(outputs[0]))
        cell = wrong['rows'][0][0]
        if key == 'bits': cell[key] ^= 1
        elif key == 'stages': cell[key][0] ^= 1
        else: cell[key][0][0] ^= 1
        try: compare(generated[0], wrong)
        except AssertionError: controls.append('wrong_' + key)
        else: raise AssertionError('corruption accepted: ' + key)
    ci = next(i for i, c in enumerate(generated) if c['operation'] == 'certify')
    wrong = {**outputs[ci], 'accepted': not outputs[ci]['accepted']}
    try: compare(generated[ci], wrong)
    except AssertionError: controls.append('wrong_certificate')
    else: raise AssertionError('wrong certificate accepted')
    si = next(i for i, c in enumerate(generated) if c['operation'] == 'scaled'
              and 'input_product_bound' in outputs[i] and c['m'] and c['n']
              and Q(outputs[i]['input_product_bound'][0][0]) > 0
              and outputs[i]['source_ideal'][0][0] != outputs[i]['ideal'][0][0])
    for name in ['source_ideal_uses_converted', 'omitted_input_loss']:
        wrong = json.loads(json.dumps(outputs[si]))
        if name == 'source_ideal_uses_converted': wrong['source_ideal'] = wrong['ideal']
        else: wrong['input_product_bound'][0][0] = '0'
        try: compare(generated[si], wrong)
        except AssertionError: controls.append(name)
        else: raise AssertionError('source mutation accepted: ' + name)
    ti = next(i for i, c in enumerate(generated) if c['operation'] == 'scaled'
              and c['input_format'] == 'fp32' and c['input_mode'] == 'rup'
              and c['a'] == c['b'] == [0x32800000])
    wrong = json.loads(json.dumps(outputs[ti]))
    wrong['input_product_bound'][0][0] = str(Q(6, 1 << 52))
    try: compare(generated[ti], wrong)
    except AssertionError: controls.append('omitted_cross_term')
    else: raise AssertionError('cross-term omission accepted')
    ci = next(i for i, c in enumerate(generated) if c['operation'] == 'certify_scaled'
              and outputs[i].get('accepted') and c['m'] and c['n']
              and abs(value(c['alpha'], 'fp32')) == 2
              and Q(outputs[i]['source_entry_bounds'][0][0]) > Q(outputs[i]['entry_bound']))
    for name in ['omitted_alpha_amplification', 'wrong_source_matrix_bound']:
        wrong = json.loads(json.dumps(outputs[ci]))
        if name == 'omitted_alpha_amplification':
            old = Q(wrong['entry_bound'])
            wrong['source_entry_bounds'][0][0] = str(old + (Q(wrong['source_entry_bounds'][0][0]) - old) / 2)
        else: wrong['source_matrix_bound'] = '0'
        try: compare(generated[ci], wrong)
        except AssertionError: controls.append(name)
        else: raise AssertionError('source certificate mutation accepted: ' + name)
    for name in ['wrong_tight_scalar_budget', 'old_budget_reported_as_tight', 'wrong_tight_matrix_bound']:
        wrong = json.loads(json.dumps(outputs[ci]))
        if name == 'wrong_tight_scalar_budget':
            wrong['tight_entry_bound'] = str(Q(wrong['tight_entry_bound']) / 2)
        elif name == 'old_budget_reported_as_tight':
            wrong['tight_source_entry_bounds'][0][0] = wrong['source_entry_bounds'][0][0]
        else:
            wrong['tight_source_matrix_bound'] = '0'
        try: compare(generated[ci], wrong)
        except AssertionError: controls.append(name)
        else: raise AssertionError('tight certificate mutation accepted: ' + name)
    for name, change in [('shape', {'a': []}), ('scalar_width', {'alpha': 1 << 32}),
                         ('mode', {'multiply_mode': 'unknown'}), ('format', {'input_format': 'unknown'})]:
        bad = work / 'invalid.jsonl'
        bad.write_text(json.dumps({**generated[0], **change}) + '\n')
        p = subprocess.run(command[:-1] + [str(bad)], cwd=ROOT, text=True, capture_output=True)
        assert p.returncode != 0, name
        controls.append('invalid_' + name)
    for name, extra, success in [
        ('dependencies', '''run_cmd do
  audit ``TensorCore.gemmCheck
  audit ``TensorCore.scaledGemmCheck
  audit ``TensorCore.convertedGemmCheck
  audit ``TensorCore.gemmInputProductError
  audit ``TensorCore.convertedGemmSourceError
  audit ``TensorCore.convertedGemmSourceCertificate
  audit ``TensorCore.convertedGemmTightSourceCertificate
  audit ``TensorCore.gemmInputProductTightError
  audit ``TensorCore.scaledGemmTightError
''', True),
        ('contaminated', '''def contaminated : Bool :=
  match TensorCore.runBlocks TensorCore.v100F16F32 0 [] with
  | .ok _ => true | .error _ => false
run_cmd audit ``contaminated
''', False),
        ('source_ideal_contaminated', '''def hidden := TensorCore.sourceGemmProducts
def contaminated := hidden
run_cmd audit ``contaminated
''', False)]:
        f = work / (name + '.lean')
        f.write_text(DEPENDENCIES + extra)
        p = subprocess.run(['lake', 'env', 'lean', str(f)], cwd=ROOT, text=True, capture_output=True)
        assert (p.returncode == 0) == success, p.stdout + p.stderr
        assert ('input-only certificate dependency audit passed' if success
                else 'Forbidden executable dependency') in p.stdout + p.stderr
    report = dict(status='passed', cases=len(generated),
                  tighter_rne_half_spacing=True, tighter_input_two_expansions=True,
                  tighter_source_entry_and_matrix_bounds=True, unchanged_acceptance=True,
                  scaled_cases=sum(c['operation'] == 'scaled' for c in generated),
                  certificate_cases=sum(c['operation'] in ['certify', 'certify_scaled'] for c in generated),
                  scaled_certificate_cases=sum(c['operation'] == 'certify_scaled' for c in generated),
                  source_certified_matrices=sum(c['operation'] == 'certify_scaled' and o.get('accepted', False)
                                                for c, o in zip(generated, outputs)),
                  source_bound_checked_cells=sum(c['m'] * c['n'] for c, o in zip(generated, outputs)
                                                 if c['operation'] == 'certify_scaled' and o.get('accepted')),
                  nonzero_input_loss_cells=sum(Q(e) > 0 for o in outputs
                                               for row in o.get('input_product_bound', []) for e in row),
                  encoded_boundaries=totals[0], rejected_scaled_cells=totals[1],
                  certificates_accepted=totals[2], rejected_input_conversions=totals[3],
                  rounding_modes=MODES, input_formats=list(FORMATS), output_formats=list(FORMATS),
                  negative_controls=controls, certificate_dependency_audit=True,
                  certificate_dependency_negative_control=True,
                  input_sha256=hashlib.sha256(source.encode()).hexdigest(),
                  output_sha256=hashlib.sha256(run.stdout.encode()).hexdigest(),
                  source_sha256={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                                 for p in [*sorted((ROOT / 'TensorCore').rglob('*.lean')),
                                           ROOT / 'TensorCore.lean', ROOT / 'examples/GemmExtensions.lean',
                                           ROOT / 'scripts/check_gemm.py', ROOT / 'scripts/check_features.py',
                                           Path(__file__)]},
                  elapsed_seconds=round(time.perf_counter() - start, 3),
                  limitations=['Independent implementation of the same numerical specification; no new GPU data.',
                               'Scalar exact zeros canonicalize to +0; finite reference domain.',
                               'Source-relative certificates include both operand-conversion deviations and their cross term, scaled by abs(alpha).',
                               'Input-only certificates cover raw and complete separately rounded scaled GEMM.'])
    (ROOT / 'data/regressions/gemm-extensions-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
