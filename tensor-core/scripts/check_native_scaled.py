#!/usr/bin/env python3
"""Check native scaled GEMM against exact oracles and replay its certificates."""
from copy import deepcopy
from fractions import Fraction as Q
import hashlib
import itertools
import json
from pathlib import Path
import random
import tempfile
import time

from analysis_certificate import HEADER, certificate_text
from check_analysis import run, TOOL, BINARY
from check_decision_extensions import PATHS, native_oracle, evaluate
from check_gemm_extensions import FORMATS, MODES, value, rounded, DEPENDENCIES

ROOT = Path(__file__).resolve().parents[1]
FORMATS['tf32'] = (10, 8, 127)
SEED = 20260910


def cases():
    rng = random.Random(SEED)
    result = []
    base = dict(operation='native_scaled', m=1, n=1, k=1, input_format='fp32', output_format='fp32',
                input_mode='rne', multiply_mode='rne', add_mode='rne', output_mode='rne',
                a=[0x3f800001], b=[0x3f800001], c=[0xbf800000], alpha=0x3fc00001, beta=0x3f800001)
    for precision, model, _, _, _, inner, _ in PATHS:
        q = dict(base, precision=precision, model=model)
        for im, mm, am in itertools.product(MODES, repeat=3):
            result.append(dict(q, input_mode=im, multiply_mode=mm, add_mode=am, output_mode=am))
        for source, (f, e, bias) in FORMATS.items():
            sign, one = 1 << (f + e), bias << f
            pool = [0, sign, 1, sign + 1, (1 << f) - 1, one, one + 1, sign + one, (bias - 12) << f]
            for m, n, k in [(2, 3, inner + 1), (1, 1, 0), (0, 2, 1), (2, 0, 1), (17, 9, 1)]:
                result.append(dict(q, input_format=source, m=m, n=n, k=k,
                    a=[rng.choice(pool) for _ in range(m*k)], b=[rng.choice(pool) for _ in range(k*n)],
                    c=[rng.choice([0, 0x80000000, 1, 0x80000001, 0x3f800000, 0xbf800000]) for _ in range(m*n)],
                    alpha=0xbf800000, beta=0x3f800000))
        maximum = 0x7f7f0000 if precision == 'bf16' else 0x7f7fe000
        for mode in MODES:
            for a, b, c, alpha, beta in [
                (maximum, 0x3f800000, 0, 0x3f800000, 0),
                (maximum + 1, 0, 0, 0, 0), (0x7fc00000, 0, 0, 0, 0),
                (0x80000001, 0x3f800000, 0, 0x3f800000, 0),
                (0x40000000, 0x3f800000, 0x7f7fffff, 0x7f7fffff, 0xbf800000),
                (0x3f800000, 0x3f800000, 0x7f800000, 0, 0),
                (0, 0, 0, 0x7fc00000, 0)]:
                result.append(dict(q, input_mode=mode, multiply_mode=mode, add_mode=mode,
                                   a=[a], b=[b], c=[c], alpha=alpha, beta=beta))
        result.append(dict(q, m=0, n=1, k=1, a=[], b=[0x7f800000], c=[]))
        result.append(dict(q, k=15, a=[0x39800000]*15, b=[0x39800000]*15,
                           c=[0x3f800000], alpha=0x3f800000, beta=0x3f800000))
    return result


def converted(q, key):
    words = []
    for w in q[key]:
        v = value(w, q['input_format'])
        out = None if v is None else rounded(v, q['precision'], q['input_mode'])
        if out is None:
            return None
        words.append(out)
    return words


def expected(q, a, b, i, j):
    m, n, k = [q[key] for key in ['m', 'n', 'k']]
    alpha, beta, c = [value(w, 'fp32') for w in [q['alpha'], q['beta'], q['c'][i*n+j]]]
    raw = dict(q, a=a, b=b, c=[0]*(m*n))
    product, pi = native_oracle(raw, i, j)
    original = [(value(q['a'][i*k+l], q['input_format']), value(q['b'][l*n+j], q['input_format'])) for l in range(k)]
    converted_pairs = [(value(a[i*k+l], q['precision']), value(b[l*n+j], q['precision'])) for l in range(k)]
    si = sum((x*y for x, y in original), Q(0))
    error = sum((min(abs(x)*abs(y-v)+abs(v)*abs(x-u), abs(u)*abs(y-v)+abs(y)*abs(x-u))
                 for (x,y),(u,v) in zip(original, converted_pairs)), Q(0))
    ideal = None if None in (alpha,beta,c) else alpha*pi+beta*c
    source = None if None in (alpha,beta,c) else alpha*si+beta*c
    if product is None or ideal is None:
        return None, ideal, source, error
    ad = rounded(alpha*value(product['bits'], 'fp32'), 'fp32', q['multiply_mode'])
    bc = rounded(beta*c, 'fp32', q['multiply_mode'])
    if ad is None or bc is None:
        return None, ideal, source, error
    sd = rounded(value(ad,'fp32')+value(bc,'fp32'), 'fp32', q['add_mode'])
    if sd is None:
        return None, ideal, source, error
    out = rounded(value(sd,'fp32'), 'fp32', q['output_mode'])
    return dict(bits=out, product_bits=product['bits'], stages=[ad,bc,sd], instructions=product['instructions']), ideal, source, error


def main():
    start = time.perf_counter()
    run(['lake','build','TensorCore.Regression.NativeScaledGemm','tc_gemm'])
    requests = cases()
    outputs = evaluate(requests)
    analyses = evaluate([dict(q,operation='analyze_native_scaled',absolute_tolerance='1/1000') for q in requests])
    success = rejected = input_rejections = analyzed = boundaries = positive_errors = stage_controls = 0
    for q, result, analysis in zip(requests, outputs, analyses):
        a,b = converted(q,'a'),converted(q,'b')
        if a is None or b is None:
            assert result == {'input_conversion_rejected':True}
            assert analysis['input_conversion_rejected'] and not analysis['accepted'] and analysis['rows'] is None
            input_rejections += 1
            continue
        m,n,k = [q[key] for key in ['m','n','k']]
        assert result['converted_a'] == [a[i*k:(i+1)*k] for i in range(m)]
        assert result['converted_b'] == [b[i*n:(i+1)*n] for i in range(k)]
        bounds=[]
        for i in range(m):
            for j in range(n):
                out,ideal,source,ie = expected(q,a,b,i,j)
                cell,bound = result['rows'][i][j],analysis['rows'][i][j]
                assert (Q(result['ideal'][i][j]) if result['ideal'][i][j] is not None else None)==ideal
                assert (Q(result['source_ideal'][i][j]) if result['source_ideal'][i][j] is not None else None)==source
                assert Q(result['input_product_bound'][i][j])==ie
                if out is None:
                    assert cell is None and bound is None
                    rejected+=1
                    continue
                assert all(cell[key]==v for key,v in out.items()), (q,cell,out)
                actual=value(out['bits'],'fp32')
                assert Q(cell['value'])==actual and abs(ideal-actual)<=Q(cell['error_budget'])
                success+=1
                boundaries+=4+sum(map(len,out['instructions']))
                positive_errors+=source!=actual
                if k==15:
                    raw,_=native_oracle(dict(q,a=a,b=b),i,j)
                    assert raw['bits']!=out['bits']
                    stage_controls+=1
                if bound is not None:
                    assert abs(source-actual)<=Q(bound['error_bound'])
                    assert abs(actual)<=Q(bound['magnitude_bound'])
                    assert Q(bound['input_conversion_bound'])==abs(value(q['alpha'],'fp32'))*ie
                    bounds.append(Q(bound['error_bound']))
                    analyzed+=1
        complete=len(bounds)==m*n
        assert analysis['bounds_valid']==complete
        assert analysis['accepted']==(complete and max(bounds,default=0)<=Q(1,1000))
        if complete: assert Q(analysis['matrix_bound'])==sum(bounds,Q(0))
    assert positive_errors and rejected and input_rejections and stage_controls==5
    controls=[]
    with tempfile.TemporaryDirectory(prefix='tc native scaled ') as directory:
        folder=Path(directory)
        audit=DEPENDENCIES.replace('import TensorCore.Programs.GemmTightInputBounds','import TensorCore.Programs.CostSelection')
        audit=audit.replace('``TensorCore.gemm,','``TensorCore.nativeGemmCell, ``TensorCore.nativeProductCell, '
                            '``TensorCore.nativeScaledGemm, ``TensorCore.nativeConvertedGemm, ``TensorCore.gemm,')
        dep=folder/'Dependencies.lean'
        roots=['inputProductErrorTo','analyzeNativeConvertedGemm','nativeConvertedAnalysisCheck','selectGemmCost']
        dep.write_text(audit+''.join(f'run_cmd audit ``TensorCore.{r}\n' for r in roots))
        run(['lake','env','lean',dep])
        dep.write_text(audit+'def hidden := @TensorCore.nativeConvertedGemm\ndef contaminated := @hidden\nrun_cmd audit ``contaminated\n')
        assert 'Forbidden executable dependency' in run(['lake','env','lean',dep],code=1).stdout
        controls.append('transitive-input-only-audit')
        exports=[q for q,r in zip(requests,analyses) if r['accepted'] and q['m']==1 and q['k']==1][:4]
        exports+=json.loads('['+','.join((ROOT/'data/examples/gemm.native-scaled.jsonl').read_text().splitlines())+']')
        packed=dict(exports[-1], input_format='tf32',a=[0x1fc00],b=[0x20400])
        exports.append(packed)
        source=folder/'Inputs.jsonl';source.write_text(''.join(json.dumps(q)+'\n' for q in exports))
        certificate=folder/'Analysis.lean'
        run([TOOL,'analyze',source,'--abs-tol','1/1000','--emit',certificate])
        assert json.loads(run([TOOL,'verify',certificate]).stdout)['cases']==len(exports)
        controls.append('all-native-paths-and-packed-source-replay')
        q=dict(exports[-2],input_format='fp32',a=[0x3f800001],b=[0x3f800000],c=[0],alpha=0x3f800000,beta=0)
        workload={key:v for key,v in q.items() if key not in {'model','input_mode','multiply_mode','add_mode'}}
        choices=[dict(model='ampere',input_mode='rup',multiply_mode='rne',add_mode='rne'),
                 dict(model='hopper',input_mode='rne',multiply_mode='rne',add_mode='rne'),
                 dict(model='hopper_mma',input_mode='rne',multiply_mode='rne',add_mode='rne')]
        selection=dict(operation='select',workload=workload,candidates=choices,policy='minimum_cost',costs=['0/1','1/1','2/1'])
        source.write_text(json.dumps(selection)+'\n');cert=folder/'Selection.lean'
        decision=json.loads(run([TOOL,'select',source,'--abs-tol','1/1000000','--emit',cert]).stdout)
        assert decision['selected_index']==1 and decision['selected_cost']=='1/1'
        selected=evaluate([decision['selected_request']])[0]
        assert selected['rows'][0][0]['bits']==0x3f800000
        run([TOOL,'verify',cert])
        manifest=json.loads(cert.read_text().splitlines()[0][len(HEADER):])
        for name in ['input-mode','tolerance','source-word','selected-index','cost']:
            changed=deepcopy(manifest);case=changed['cases'][0]
            if name=='input-mode':case['candidates'][1]['input_mode']='rup'
            elif name=='tolerance':case['tolerance']='0/1'
            elif name=='source-word':case['workload']['a']=[0x3f803000]
            elif name=='selected-index':case['selected_index']=0
            else:case['costs'][2]='0/1'
            bad=folder/'Bad.lean';bad.write_text(certificate_text(changed))
            run([TOOL,'verify',bad],code=1)
            controls.append(name+'-kernel-rejection')
        for change in [dict(precision='fp16'),dict(model='v100'),dict(precision='bf16',model='hopper_mma'),
                       dict(input_format='tf32',a=[1<<19]),dict(output_format='fp16'),dict(add_mode='fma')]:
            run([BINARY,'-'],text=json.dumps(dict(q,**change))+'\n',code=2)
        controls.append('invalid-format-model-width-mode')
    files=['Programs/MatrixConversion','Programs/NativeScaledGemm','Programs/NativeConvertedAnalysis',
           'Programs/GemmSelection','PaperSpec/NativeScaledMatrix','PaperSpec/NativeScaledGemmEquivalence',
           'Cli/NativePipeline','Cli/GemmSelection','Regression/NativeScaledGemm']
    paths=[ROOT/'TensorCore'/f'{name}.lean' for name in files]+[Path(__file__).resolve()]
    report=dict(status='passed',seed=SEED,requests=len(requests),successful_cells=success,analyzed_cells=analyzed,
                rejected_cells=rejected,input_conversion_rejections=input_rejections,encoded_boundaries=boundaries,
                positive_error_cells=positive_errors,raw_scaled_separations=stage_controls,negative_controls=controls,
                elapsed_seconds=round(time.perf_counter()-start,3),
                source_sha256={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths})
    (ROOT/'data/regressions/native-scaled-report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))


if __name__=='__main__':
    main()
