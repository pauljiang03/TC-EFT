#!/usr/bin/env python3
"""Exercise accuracy theorem generation, failed declarations, and executable dependencies."""
from pathlib import Path
import json
import re
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]
SCRATCH = ROOT / 'tmp/certificate-tests'
SCRATCH.mkdir(parents=True, exist_ok=True)
HEADER = '''import TensorCore.Meta.Certify
open TensorCore
set_option maxRecDepth 16384
set_option maxHeartbeats 4000000
'''
BODY = '''def p : Program v100F16F32 := tc%{
  block "small" [(0x2bff, 0x2bff), (0, 0), (0, 0), (0, 0)];
}
'''


def run(path):
    start = time.perf_counter()
    proc = subprocess.run(['lake', 'env', 'lean', str(path)], cwd=ROOT,
                          text=True, capture_output=True, timeout=90)
    return proc.returncode, proc.stdout + proc.stderr, time.perf_counter() - start


def check_source(name, source):
    path = SCRATCH / f'{name}.lean'
    path.write_text(source)
    code, out, elapsed = run(path)
    (SCRATCH / f'{name}.log').write_text(out)
    return code, out, elapsed


code, output, example_seconds = run(ROOT / 'examples/Certify.lean')
assert code == 0, output
for marker in ['dot_accurate', '.Accurate', 'inputConditionsPass := true',
               'tolerancePass := true', 'tolerancePass := false']:
    assert marker in output, (marker, output)
for deps in re.findall(r'depends on axioms: \[(.*?)\]', output):
    assert set(deps.split(', ')) <= {'propext', 'Classical.choice', 'Quot.sound'}, deps

cases = {
    'tight_tolerance': 'from 0x3f800000 scale 1 carry 3 within (1 / 1000000000)',
    'negative_tolerance': 'from 0 scale 1 carry 3 within (-1)',
    'insufficient_carry': 'from 0 scale 1 carry 2 within 1',
    'initial_range': 'from 0x40800000 scale 1 carry 3 within 1',
    'nonfinite_initial': 'from 0x7fc00000 scale 1 carry 3 within 1',
    'oversized_initial': 'from (0x100000000) scale 1 carry 3 within 1',
    'invalid_supplied_proof': 'from 0 scale 1 carry 3 within 1 using (by trivial)',
}
for name, args in cases.items():
    code, out, _ = check_source(name, HEADER + BODY +
        f'tc_certify impossible : p {args}\n#check impossible\n')
    assert code != 0 and 'Not certified' in out and 'Unknown identifier `impossible`' in out, (name, out)

code, out, _ = check_source('nonfinite_operand', HEADER + BODY.replace('0x2bff', '0x7e00') +
    'tc_certify impossible : p from 0 scale 1 carry 3 within 1\n#check impossible\n')
assert code != 0 and 'Not certified' in out and 'Unknown identifier `impossible`' in out, out

code, out, _ = check_source('prior_error', HEADER +
    'example : (1 : Nat) = 2 := by decide\n' + BODY +
    'tc_certify still_registered : p from 0 scale 1 carry 3 within 1\n#check still_registered\n')
assert code != 0 and 'still_registered :' in out and 'Not certified' not in out, out
code, out, _ = check_source('supplied_proof', HEADER + BODY +
    'tc_certify supplied : p from 0 scale 1 carry 3 within 1 using (by decide +kernel)\n')
assert code == 0 and 'supplied :' in out, out

# Walk compiled definition bodies transitively. Proof bodies and constant types are
# excluded: soundness proofs necessarily mention execution, but checks must not execute it.
audit = '''import Lean
import TensorCore.Applications.BoundedDot
open Lean Elab Command
partial def visitDefinitions (env : Environment) (n : Name) : StateM NameSet Unit := do
  if (← get).contains n then return
  modify (·.insert n)
  match env.find? n with
  | some (.defnInfo info) => info.value.getUsedConstants.forM (visitDefinitions env)
  | some (.opaqueInfo info) => info.value.getUsedConstants.forM (visitDefinitions env)
  | _ => pure ()
def modelNames : List Name := [``TensorCore.evalBlock, ``TensorCore.runBlocks,
  ``TensorCore.Program.VC, ``TensorCore.recoveredSchedule, ``TensorCore.correctedSchedule]
def prefixNames : List Name := [``TensorCore.idealProducts, ``TensorCore.idealContributions,
  ``TensorCore.partialSumsCheck, ``TensorCore.staticCheck]
def checkDependencies (root : Name) (forbidden : List Name) : CommandElabM Unit := do
  let deps := ((visitDefinitions (← getEnv) root).run {}).2
  let bad := forbidden.filter deps.contains
  unless bad.isEmpty do throwError "Forbidden executable dependencies: {bad}"
  logInfo m!"checked executable dependencies: {root}"
'''
code, out, _ = check_source('dependencies', audit + '''run_cmd do
  checkDependencies ``TensorCore.Program.staticCertificate modelNames
  checkDependencies ``TensorCore.Program.certificateReport modelNames
  checkDependencies ``TensorCore.boundedDotCheck (modelNames ++ prefixNames)
''')
assert code == 0 and out.count('checked executable dependencies:') == 3, out
code, out, _ = check_source('dependency_negative_control', audit + '''def contaminated : Bool :=
  match TensorCore.runBlocks TensorCore.v100F16F32 0 [] with
  | .ok _ => true
  | .error _ => false
run_cmd checkDependencies ``contaminated modelNames
''')
assert code != 0 and 'Forbidden executable dependencies' in out, out

report = dict(success=True, rejection_cases=[*cases, 'nonfinite_operand'],
              rejections=len(cases)+1, prior_error_does_not_roll_back=True,
              supplied_proof_compiles=True, example_compiles=True,
              example_elaboration_wall_seconds=round(example_seconds, 6),
              executable_dependency_checks=3, dependency_negative_control=True,
              concrete_path='Exact ideal prefixes, no model execution or residual ledger',
              family_path='Input decoding and magnitude/count checks, no exact prefixes',
              timing_scope='Entire lake env lean examples/Certify.lean process, including imports and diagnostics')
(ROOT / 'data/regressions/certificate-report.json').write_text(json.dumps(report, indent=2)+'\n')
print(json.dumps(report, indent=2))
