#!/usr/bin/env python3
"""Supplied-D independence, signed underflow, padding validation and negative controls."""
import json, sys, subprocess
from pathlib import Path
from fractions import Fraction as Q
PORT=Path(__file__).resolve().parents[1]
sys.dont_write_bytecode=True
sys.path.insert(0,str(PORT.parent/'vendor/tc-eft-validation'))
import exact_model as ref
import check_revision as oracle
from check_replay import run

def main():
    # Exact 1 + 2^-24 is a midpoint; the even result is 1. D is deliberately
    # unrelated to the TC model, including signed zero and both finite extremes.
    values=[0,0x80000000,1,0x80000001,0x3f000000,0x3f800000,0xbf800000,0x7f7fffff,0xff7fffff]
    rows=[f'block fp16 1 0 none 3072 3072 1065353216 {d}' for d in values]
    results=run(rows,'supplied-D')
    for d,r in zip(values,results):
        assert Q(r['ideal'])==1+Q(2)**-24
        assert r['correction']['bits']==0x3f800000,(d,r)
    # Source canonicalizes exact zero to +0; negative underflow keeps its sign.
    xs=[Q(0),-Q(2)**-151,Q(2)**-150,-Q(2)**-150,
        ref.MAX32, -ref.MAX32,ref.MAX32+1,-ref.MAX32-1]
    results=run([f'round {x.numerator} {x.denominator}' for x in xs],'round-edges')
    for x,r in zip(xs,results):
        for m in ['rne','rtz']:
            want=oracle.neighbor_round(x,m) if abs(x)<=ref.MAX32 else None
            assert r[m]==want,(x,m,r,want)
    # Supplied nonfinite D and nonfinite inputs are rejected before the zero shortcut.
    rows=['block fp16 0 0 none 0 2139095040',
          'block fp16 1 0 none 31744 0 0 0',
          'tf32 1 1 -132 1065353217 1065353216 0']
    out=run(rows,'domain-edges')
    assert out[0]['correction']['error'].endswith('nonfiniteOutput')
    assert out[1]['model']['error'].endswith('nonfiniteInput')
    assert out[2]['error'].endswith('nonfiniteInput')
    # The dependency audit must reject a function contaminated with model evaluation.
    audit=(PORT/'tests/Audit.lean').read_text()
    bad=PORT/'test-results/dependency-negative.lean'
    bad.write_text(audit+'\ndef contaminated := TCFloat.evalWords\nrun_cmd checkDependencies ``contaminated\n')
    proc=subprocess.run(['lake','env','lean',str(bad)],cwd=PORT,capture_output=True,text=True)
    assert proc.returncode and 'Forbidden executable dependencies' in proc.stdout+proc.stderr
    bad_source=PORT/'test-results/source-dependency-negative.lean'
    bad_source.write_text(audit+'\ndef contaminatedSource := TensorCore.round32\nrun_cmd checkSourceIndependence ``contaminatedSource\n')
    proc=subprocess.run(['lake','env','lean',str(bad_source)],cwd=PORT,capture_output=True,text=True)
    assert proc.returncode and 'Original implementation in executable dependencies' in proc.stdout+proc.stderr
    report={'supplied_D_cases':len(values),'rounding_cases':len(xs),'domain_cases':len(rows),
            'dependency_negative_control':'passed','source_independence_negative_control':'passed','mismatches':0}
    (PORT/'test-results/edges-report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
