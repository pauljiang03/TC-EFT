#!/usr/bin/env python3
"""Check the bounded-dot application against original-input Fraction arithmetic; measure costs."""
from collections import Counter
from fractions import Fraction as Q
import json
import random
import statistics
import subprocess
import time
from check_features import ROOT, decode, run_rows
from check_dot_products import expected_dot

RNG = random.Random(20260906)
SIZES = [0, 1, 3, 4, 5, 16, 31, 64, 127, 256, 257, 512]
TOLERANCE = Q(1, 2048)
B = Q(21, 4194304)
cases = []
for n in SIZES:
    for regime in ['positive_edge', 'alternating', 'random_small', 'subnormal',
                   'zero', 'large_c', 'large_operands']:
        if regime == 'random_small':
            pairs = [(RNG.randrange(0x2c00) | (RNG.randrange(2) << 15),
                      RNG.randrange(0x2c00) | (RNG.randrange(2) << 15)) for _ in range(n)]
        elif regime == 'alternating':
            pairs = [(0x2bff | ((i % 2) << 15), 0x2bff) for i in range(n)]
        elif regime == 'subnormal':
            pairs = [(1 | ((i % 2) << 15), 0x3ff) for i in range(n)]
        elif regime == 'zero':
            pairs = [(0x8000, 0) for _ in range(n)]
        elif regime == 'large_operands':
            pairs = [(0x3c00, 0x3c00) for _ in range(n)]
        else:
            pairs = [(0x2bff, 0x2bff) for _ in range(n)]
        c = 0x40000000 if regime == 'large_c' else 0x3f800000
        cases.append((regime, pairs, c))
cases += [('nonfinite_c', [], 0x7fc00000), ('nonfinite_operand', [(0x7e00, 0)], 0),
          ('negative_c', [(0xabff, 0x2bff)] * 5, 0xbf800000)]


def words(pairs, c):
    return ' '.join(map(str, [v for pair in pairs for v in pair] + [c]))


family_rows = ['certificate family ' + words(ps, c) for _, ps, c in cases]
concrete_rows = ['certificate concrete ' + words(ps, c) for _, ps, c in cases]
model_rows = ['dot 4 0 none ' + words(ps, c) for _, ps, c in cases]
family = run_rows(family_rows, 'application-family.txt')
concrete = run_rows(concrete_rows, 'application-concrete.txt')
model = run_rows(model_rows, 'application-model.txt')
reasons = Counter()
details = []
accepted = concrete_accepted = nonzero = tails = outside_but_accurate = 0
for (regime, pairs, c), f, s, m in zip(cases, family, concrete, model):
    cv = decode(c, 23, 8, 127)
    length_ok = len(pairs) <= 256
    operand_ok = all((a & 0x7fff) < 0x2c00 and (b & 0x7fff) < 0x2c00 for a, b in pairs)
    initial_ok = cv is not None and abs(cv[0]) <= 1
    assert (f['lengthPass'], f['operandsPass'], f['initialPass']) == (length_ok, operand_ok, initial_ok)
    assert f['accepted'] == (length_ok and operand_ok and initial_ok)
    for label, ok in [('length', length_ok), ('operands', operand_ok), ('initial', initial_ok)]:
        reasons[label] += not ok
    n_groups = (len(pairs)+3)//4
    budget = n_groups * B
    assert Q(f['budget']) == Q(s['budget']) == budget
    assert Q(f['tolerance']) == Q(s['tolerance']) == TOLERANCE
    assert s['accepted'] == (s['inputConditionsPass'] and s['tolerancePass'])
    assert s['tolerancePass'] == (budget <= TOLERANCE)
    exact = expected_dot(4, 0, None, [v for pair in pairs for v in pair] + [c])
    row = dict(regime=regime, products=len(pairs), groups=n_groups,
               family_accepted=f['accepted'], concrete_accepted=s['accepted'],
               budget=str(budget), tolerance=str(TOLERANCE))
    if 'error' in exact:
        assert 'error' in m and not f['accepted'] and not s['accepted'], (row, m)
        row['model_error'] = m['error']
    else:
        for key in ['bits', 'groups', 'tailPadding', 'outputs']:
            assert m[key] == exact[key], (regime, len(pairs), key)
        for key in ['ideal', 'value', 'absoluteError', 'errorBudget']:
            assert Q(m[key]) == exact[key], (regime, len(pairs), key)
        error = exact['absoluteError']
        if f['accepted'] or s['accepted']:
            assert error <= budget <= TOLERANCE, row
        if f['accepted']:
            assert s['accepted'], row
            accepted += 1
            nonzero += error > 0
            tails += exact['tailPadding'] > 0
        concrete_accepted += s['accepted']
        outside_but_accurate += not f['accepted'] and error <= TOLERANCE
        row.update(actual_error=str(error), trace_budget=str(exact['errorBudget']),
                   budget_over_error=float(budget/error) if error else None,
                   budget_over_trace=float(budget/exact['errorBudget']) if exact['errorBudget'] else None)
    details.append(row)
assert nonzero and tails and outside_but_accurate

# End-to-end compiled CLI batches. Each timed process performs all parsing, checks or
# execution, and JSON formatting. This is not an isolated arithmetic or GPU benchmark.
timings = []
for n in [1, 16, 64, 256]:
    group = [(0x2bff, 0x2bff)] * n
    for kind, prefix in [('family', 'certificate family '), ('concrete', 'certificate concrete '),
                         ('model_with_trace_and_ideal', 'dot 4 0 none ')]:
        path = ROOT / f'tmp/validation/application-timing-{n}-{kind}.txt'
        batch = 100
        path.write_text((prefix + words(group, 0x3f800000) + '\n') * batch)
        samples = []
        for i in range(4):
            start = time.perf_counter()
            proc = subprocess.run([str(ROOT / '.lake/build/bin/tc_features'), '--file', str(path)],
                                  text=True, capture_output=True, check=True)
            elapsed = time.perf_counter() - start
            assert len(proc.stdout.splitlines()) == batch
            if i:
                samples.append(elapsed)
        timings.append(dict(products=n, path=kind, cases_per_process=batch, measured_processes=3,
                            median_wall_ms_per_case=1000*statistics.median(samples)/batch))

proc = subprocess.run(['lake', 'env', 'lean', 'examples/BoundedDot.lean'], cwd=ROOT,
                      text=True, capture_output=True)
assert proc.returncode == 0, proc.stdout + proc.stderr
report = dict(success=True, cases=len(cases), sizes=SIZES, mismatches=0,
              family_accepted=accepted, concrete_accepted=concrete_accepted,
              accepted_nonzero_error_cases=nonzero, accepted_partial_tail_cases=tails,
              family_rejection_reasons=dict(reasons),
              outside_family_but_within_tolerance=outside_but_accurate,
              symbolic_example_compiles=True, ideal_from_unpadded_original_bits=True,
              new_gpu_measurements=False, details=details, timings=timings,
              timing_scope='Compiled CLI batches, including process startup, parsing and JSON; 1 warmup and 3 measured processes of 100 cases. Model path also computes its exact ideal and trace report. No extraction or GPU timing claim.')
(ROOT / 'data/regressions/application-report.json').write_text(json.dumps(report, indent=2)+'\n')
print(json.dumps({k: v for k, v in report.items() if k != 'details'}, indent=2))
