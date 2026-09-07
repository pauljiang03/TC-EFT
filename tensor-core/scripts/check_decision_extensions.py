#!/usr/bin/env python3
"""Evaluate native GEMM, per-entry families, and supplied-cost certificates."""

from fractions import Fraction as Q
import hashlib
import json
from pathlib import Path
import random
import tempfile
import time

from analysis_certificate import HEADER, certificate_text
from check_analysis import run, TOOL, BINARY
from check_features import decode, val32, round32_search
from check_gemm import oracle
from check_gemm_extensions import DEPENDENCIES

ROOT = Path(__file__).resolve().parents[1]
SEED = 20260909
PATHS = [('bf16', 'ampere', 8, 24, -132, 16, 16), ('bf16', 'hopper', 16, 25, -133, 16, 16),
         ('tf32', 'ampere', 4, 24, -132, 8, 16), ('tf32', 'hopper', 4, 25, -133, 8, 16),
         ('tf32', 'hopper_mma', 8, 25, -133, 8, 8)]


def evaluate(requests):
    output = run([BINARY, '-'], text=''.join(json.dumps(q) + '\n' for q in requests))
    results = [json.loads(line) for line in output.stdout.splitlines()]
    assert len(results) == len(requests)
    return results


def native_oracle(q, i, j):
    _, _, count, fraction, floor, inner, _ = next(p for p in PATHS if p[:2] == (q['precision'], q['model']))
    frac = 7 if q['precision'] == 'bf16' else 10
    k, n = q['k'], q['n']
    c = q['c'][i * n + j]
    pairs = [(q['a'][i * k + l], q['b'][l * n + j]) for l in range(k)]
    dc = decode(c, 23, 8, 127)
    decoded = [(decode(a, frac, 8, 127), decode(b, frac, 8, 127)) for a, b in pairs]
    if dc is None or any(a is None or b is None for a, b in decoded):
        return None, None
    ideal = dc[0] + sum((a[0] * b[0] for a, b in decoded), Q(0))
    instructions = []
    for start in range(0, k, inner):
        tile = decoded[start:start + inner] + [((Q(0), -126), (Q(0), -126))] * (inner - len(decoded[start:start + inner]))
        blocks = []
        for offset in range(0, inner, count):
            terms = [decode(c, 23, 8, 127)] + [(a[0] * b[0], a[1] + b[1]) for a, b in tile[offset:offset + count]]
            scales = [s for value, s in terms if value]
            scale = max(max(scales), floor) if scales else 0
            quantum = Q(2) ** (scale - fraction)
            accumulated = sum((int(value / quantum) * quantum for value, _ in terms), Q(0))
            c = round32_search(accumulated)
            if c is None:
                return None, ideal
            blocks.append(c)
        instructions.append(blocks)
    return dict(bits=c, instructions=instructions), ideal


def native_cases():
    rng = random.Random(SEED)
    requests = []
    for precision, model, _, _, _, inner, _ in PATHS:
        f = 7 if precision == 'bf16' else 10
        one, sign, inf = 127 << f, 1 << (f + 8), 255 << f
        pool = [0, sign, 1, sign + 1, (1 << f) - 1, one, one + 1, one + sign, 115 << f]
        for m, n, k in [(1, 1, 0), (1, 1, 1), (2, 3, inner - 1), (2, 2, inner),
                        (3, 2, inner + 1), (2, 3, 2 * inner + 1), (17, 19, 1), (0, 3, 1), (2, 0, 1)]:
            requests.append(dict(operation='native', precision=precision, model=model, m=m, n=n, k=k,
                                 a=[rng.choice(pool) for _ in range(m * k)], b=[rng.choice(pool) for _ in range(k * n)],
                                 c=[rng.choice([0, 0x80000000, 1, 0x80000001, 0x3f800000, 0xbf800000]) for _ in range(m * n)]))
        for a, b, c in [(inf, 0, 0), (inf - 1, inf - 1, 0), (one, one, 0x7f7fffff),
                         (sign + 1, one, 0), (one, one, 0x7f800000), (0, sign, 0x80000000)]:
            requests.append(dict(operation='native', precision=precision, model=model, m=1, n=1, k=1, a=[a], b=[b], c=[c]))
        for c in [0x80000000, 0x7f7fffff, 0xff7fffff, 0x7fc00000]:
            requests.append(dict(operation='native', precision=precision, model=model, m=1, n=1, k=0, a=[], b=[], c=[c]))
    return requests


def main():
    start = time.perf_counter()
    run(['lake', 'build', 'TensorCore.Regression.DecisionExtensions', 'tc_gemm'])
    requests = native_cases()
    outputs = evaluate(requests)
    analyses = evaluate([{**q, 'operation': 'analyze_native', 'absolute_tolerance': '1/1000'} for q in requests])
    checked = certified = rejected = boundaries = 0
    for q, result, analysis in zip(requests, outputs, analyses):
        path = next(p for p in PATHS if p[:2] == (q['precision'], q['model']))
        inner, cols = path[-2:]
        assert result['tile_instructions'] == ((q['m'] + 15) // 16) * ((q['n'] + cols - 1) // cols) * ((q['k'] + inner - 1) // inner)
        assert len(result['rows']) == len(result['ideal']) == len(analysis['rows']) == q['m']
        bounds = []
        for i in range(q['m']):
            assert len(result['rows'][i]) == len(analysis['rows'][i]) == q['n']
            for j in range(q['n']):
                expected, ideal = native_oracle(q, i, j)
                got, bound = result['rows'][i][j], analysis['rows'][i][j]
                assert (Q(result['ideal'][i][j]) if result['ideal'][i][j] is not None else None) == ideal
                if expected is None:
                    assert got is None and bound is None
                    rejected += 1
                    continue
                assert all(got[key] == expected[key] for key in ['bits', 'instructions'])
                assert Q(got['value']) == val32(expected['bits'])
                boundaries += sum(map(len, got['instructions']))
                checked += 1
                if bound is not None:
                    error = Q(bound['error_bound'])
                    assert abs(ideal - val32(expected['bits'])) <= error
                    assert abs(val32(expected['bits'])) <= Q(bound['magnitude_bound'])
                    bounds.append(error)
                    certified += 1
        complete = len(bounds) == q['m'] * q['n']
        assert analysis['bounds_valid'] == complete
        assert analysis['accepted'] == (complete and max(bounds, default=0) <= Q(1, 1000))
        if complete:
            assert Q(analysis['matrix_bound']) == sum(bounds, Q(0))

    family = dict(operation='analyze_entry_family', model='hopper', m=2, n=2, k=1,
                  a_bounds=['1/1', '1/4096'], b_bounds=['1/1', '1/4096'], c_bounds=['1/1', '0/1', '0/1', '0/1'],
                  absolute_tolerance='1/1000')
    fr = evaluate([family])[0]
    uniform = evaluate([dict(operation='analyze_family', model='hopper', m=2, n=2, k=1,
                            a_bound='1/1', b_bound='1/1', c_bound='1/1', absolute_tolerance='1/1000')])[0]
    assert fr['accepted'] and Q(fr['matrix_bound']) < Q(uniform['matrix_bound'])
    rng = random.Random(SEED + 1)
    sampled = 0
    for _ in range(32):
        raw = dict(model='hopper', m=2, n=2, k=1)
        for key in ['a', 'b', 'c']:
            width = 23 if key == 'c' else 10
            exponent, bias = (8, 127) if key == 'c' else (5, 15)
            pool = [0, 1, bias << width, (bias - 12) << width]
            pool += [v | (1 << (width + exponent)) for v in pool]
            raw[key] = [rng.choice([w for w in pool if abs(decode(w, width, exponent, bias)[0]) <= Q(cap)]) for cap in family[key + '_bounds']]
        for i in range(2):
            for j in range(2):
                out, ideal = oracle(raw, i, j)
                assert abs(ideal - val32(out['bits'])) <= Q(fr['entry_bounds'][i][j])
                sampled += 1

    workloads = []
    for q in requests:
        if q['m'] <= 3 and q['n'] <= 3:
            workload = {key: value for key, value in q.items() if key != 'model'}
            models = ['ampere', 'hopper'] + (['hopper_mma'] if q['precision'] == 'tf32' else [])
            workloads.append(dict(operation='select', workload=workload, candidates=[dict(model=model) for model in models],
                                  policy='minimum_cost', costs=['3/1', '2/1', '1/1'][:len(models)], absolute_tolerance='1/1000'))
    workloads.append(dict(operation='select', workload={**{key: value for key, value in family.items() if key not in {'model', 'absolute_tolerance'}}, 'operation': 'entry_family'},
                          candidates=[dict(model=m) for m in ['v100', 'ampere', 'hopper']], policy='minimum_cost',
                          costs=['1/1', '3/1', '2/1'], absolute_tolerance='1/1000'))
    decisions = evaluate(workloads)
    for q, result in zip(workloads, decisions):
        acceptable = [i for i, c in enumerate(result['candidates']) if c['analysis']['accepted']]
        selected = min(acceptable, key=lambda i: (Q(q['costs'][i]), i)) if acceptable else None
        assert result['selected_index'] == selected
        assert result['selected_cost'] == (q['costs'][selected] if selected is not None else None)
    controls = []
    with tempfile.TemporaryDirectory(prefix='tc decision extensions ') as directory:
        folder = Path(directory)
        audit = DEPENDENCIES.replace('import TensorCore.Programs.GemmTightInputBounds',
                                     'import TensorCore.Programs.CostSelection\nimport TensorCore.PaperSpec.NativeGemmEquivalence')
        audit = audit.replace('``TensorCore.gemm,', '``TensorCore.nativeGemm, ``TensorCore.nativeGemmCell, '
                              '``TensorCore.nativeGemmIdeal, ``TensorCore.PaperSpec.nativeMatrix, ``TensorCore.gemm,')
        dependency_file = folder / 'Dependencies.lean'
        roots = ['analyzeNativeCell', 'checkNativeCell', 'inferEntryFamily', 'entryFamilyCheck', 'selectGemmCost']
        dependency_file.write_text(audit + ''.join(f'run_cmd audit ``TensorCore.{root}\n' for root in roots))
        run(['lake', 'env', 'lean', dependency_file])
        dependency_file.write_text(audit + 'def hidden := @TensorCore.nativeGemm\ndef contaminated := @hidden\nrun_cmd audit ``contaminated\n')
        assert 'Forbidden executable dependency' in run(['lake', 'env', 'lean', dependency_file], code=1).stdout
        controls.append('transitive-input-only-audit')
        q = next(q for q, r in zip(workloads, decisions) if r['accepted'] and q['workload']['k'] == 1)
        for name, change in [('negative-cost', {'costs': ['-1/1', '2/1']}), ('cost-shape', {'costs': []}),
                             ('unknown-policy', {'policy': 'fastest'}), ('irrelevant-costs', {'policy': 'preference'})]:
            run([BINARY, '-'], text=json.dumps({**q, **change}) + '\n', code=2)
            controls.append(name)
        for native in [dict(requests[0], precision='fp16'), dict(requests[0], model='v100'),
                       dict(requests[0], k=1, a=[1 << 16], b=[0]),
                       dict(requests[0], model='hopper_mma')]:
            run([BINARY, '-'], text=json.dumps(native) + '\n', code=2)
        controls.append('invalid-native-domain')
        exports = [json.loads((ROOT / 'data/examples/gemm.cost-selection.jsonl').read_text()), workloads[-1]]
        source = folder / 'selection.jsonl'
        source.write_text(''.join(json.dumps(q) + '\n' for q in exports))
        certificate = folder / 'Selection.lean'
        run([TOOL, 'select', source, '--abs-tol', '1/1000', '--emit', certificate])
        assert json.loads(run([TOOL, 'verify', certificate]).stdout)['cases'] == len(exports)
        manifest = json.loads(certificate.read_text().splitlines()[0][len(HEADER):])
        for name in ['chosen-cost', 'selected-index', 'tolerance', 'family-cap']:
            changed = json.loads(json.dumps(manifest))
            case = changed['cases'][0]
            if name == 'chosen-cost':
                case['costs'][2] = '99/1'
            elif name == 'selected-index':
                case['selected_index'] = 0
            elif name == 'tolerance':
                case['tolerance'] = '0/1'
            else:
                changed['cases'][1]['workload']['a_bounds'][0] = '65504/1'
            bad = folder / 'Bad.lean'
            bad.write_text(certificate_text(changed))
            run([TOOL, 'verify', bad], code=1)
            controls.append(name + '-kernel-rejection')
        for name in ['gemm.native.jsonl', 'gemm.entry-family.jsonl']:
            certificate = folder / (name + '.lean')
            run([TOOL, 'analyze', ROOT / 'data/examples' / name, '--abs-tol', '1/1000', '--emit', certificate])
            assert json.loads(run([TOOL, 'verify', certificate]).stdout)['status'] == 'kernel_checked'
        controls.append('native-and-family-analysis-export')
    report = dict(status='passed', seed=SEED, native_requests=len(requests), successful_cells=checked,
                  analyzed_cells=certified, rejected_cells=rejected, encoded_boundaries=boundaries,
                  sampled_family_cells=sampled, cost_decisions=len(workloads), negative_controls=controls,
                  entry_family_matrix_bound=fr['matrix_bound'], uniform_matrix_bound=uniform['matrix_bound'],
                  elapsed_seconds=round(time.perf_counter() - start, 3),
                  limitations=['Native integration covers encoded raw AB+C with FP32 output.',
                               'Per-entry caps are reduced to row and column maxima for each output bound.',
                               'Minimum cost refers to supplied costs among certified candidates; no GPU timing model.'])
    source_files = ['TensorCore/Programs/NativeGemm.lean', 'TensorCore/Programs/EntryFamily.lean',
                    'TensorCore/Programs/CostSelection.lean', 'TensorCore/Programs/ExactScalarAnalysis.lean',
                    'TensorCore/PaperSpec/NativeMatrix.lean', 'TensorCore/PaperSpec/NativeGemmEquivalence.lean',
                    'TensorCore/Cli/ExtendedAnalysis.lean', 'TensorCore/Regression/DecisionExtensions.lean',
                    'scripts/check_decision_extensions.py']
    report['source_sha256'] = {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in source_files}
    (ROOT / 'data/regressions/decision-extensions-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
