#!/usr/bin/env python3
"""Independent checks of constructed canonical schedules and uncorrected budgets."""
from fractions import Fraction as Q
import json
import random
from check_features import ROOT, decode, reference, run_rows, val32

RNG = random.Random(20260906)


def expected_dot(K, extra, floor, words):
    pairs, c = list(zip(words[:-1:2], words[1:-1:2])), words[-1]
    initial = decode(c, 23, 8, 127)
    decoded = [(decode(a, 10, 5, 15), decode(b, 10, 5, 15)) for a, b in pairs]
    if initial is None:
        return dict(error='nonfiniteInput')
    # The ideal is decoded from the unpadded original list before executing any group.
    ideal = (None if any(a is None or b is None for a, b in decoded) else
             initial[0] + sum((a[0] * b[0] for a, b in decoded), Q(0)))
    outputs, budget = [], Q(0)
    for start in range(0, len(pairs), K):
        group = pairs[start:start+K]
        group += [(0, 0)] * (K-len(group))
        operands = [h for pair in group for h in pair] + [c]
        if any(decode(h, 10, 5, 15) is None for h in operands[:-1]):
            return dict(error='nonfiniteInput')
        local = reference(operands, K, extra, floor)
        if local is None:
            return dict(error='accumulatorOutOfRange')
        c = local['bits']
        exponent = (c >> 23) & 0xff
        output_quantum = Q(2) ** (-149 if exponent == 0 else exponent-127-23)
        budget += (K+1) * local['quantum'] + output_quantum
        outputs.append(c)
    assert ideal is not None
    return dict(bits=c, value=val32(c), ideal=ideal, errorBudget=budget,
                absoluteError=abs(ideal-val32(c)), outputs=outputs, groups=len(outputs),
                tailPadding=(-len(pairs)) % K)


def main():
    cases = []
    for K in [1, 3, 4, 8, 16, 37]:
        for extra in [0, 1, 2, 9]:
            floor = -133 if extra == 2 else None
            for n in sorted({0, 1, K-1, K, K+1, 2*K+1}):
                cases.append((K, extra, floor, [0x3c00, 0x3c00]*n + [0]))
                words = [RNG.randrange(0x7c00) | (RNG.randrange(2) << 15) for _ in range(2*n)]
                c = RNG.choice([0, 1, 0x80000001, 0x3f800000, 0x7f7fffff, 0xff7fffff])
                cases.append((K, extra, floor, words+[c]))
    # Two supplied orders with the same ideal sum and different encoded results.
    negative = [0xbc00, 0x3c00] + [0, 0]*3
    tiny = [0xc00, 0xc00] + [0, 0]*3
    cases += [(4, 0, None, negative+tiny+[0x3f800000]),
              (4, 0, None, tiny+negative+[0x3f800000])]
    # Nonfinite original operands/initial c and a high-padding range rejection.
    cases += [(4, 0, None, [0x7c00, 0x3c00, 0]),
              (4, 0, None, [0x7f800000]),
              (1, 156, None, [0x3c00, 0x3c00, 0x7f7fffff]),
              # The first group's range failure precedes a later nonfinite operand.
              (1, 156, None, [0x3c00, 0x3c00, 0x7c00, 0x3c00, 0x7f7fffff])]
    rows = ['dot ' + ' '.join(map(str, [K, e, 'none' if f is None else f, *words]))
            for K, e, f, words in cases]
    actual = run_rows(rows, 'canonical-dot-products.txt')
    rejected, partial, nonzero_error = 0, 0, 0
    for case, result in zip(cases, actual):
        expected = expected_dot(*case)
        if 'error' in expected:
            assert 'error' in result, (case, result)
            assert result['error'].endswith('.'+expected['error']), (case, result, expected)
            rejected += 1
            continue
        assert 'error' not in result, (case, result)
        for key in ['bits', 'groups', 'tailPadding', 'outputs']:
            assert result[key] == expected[key], (case, key, result, expected)
        for key in ['value', 'ideal', 'absoluteError', 'errorBudget']:
            assert Q(result[key]) == expected[key], (case, key, result, expected)
        assert expected['absoluteError'] <= expected['errorBudget']
        if expected['groups']:
            assert expected['absoluteError'] < expected['errorBudget']
        partial += expected['tailPadding'] > 0
        nonzero_error += expected['absoluteError'] > 0
    report = dict(cases=len(cases), rejected=rejected, mismatches=0,
                  configurations=len({c[:3] for c in cases}), partial_tail_cases=partial,
                  nonzero_error_cases=nonzero_error, every_encoded_boundary_compared=True,
                  ideal_from_unpadded_original_bits=True, error_budget_comparison=True,
                  ordered_error_causes_compared=True,
                  new_gpu_measurements=False)
    (ROOT / 'data/regressions/dot-product-report.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
