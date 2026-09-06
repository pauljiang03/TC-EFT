#!/usr/bin/env python3
"""Exercise real DSL elaboration, proof generation, inspection, and rejection."""
from pathlib import Path
import json
import re
import subprocess

root = Path(__file__).resolve().parents[1]
scratch = root / 'tmp/program-tests'
scratch.mkdir(parents=True, exist_ok=True)
header = '''import TensorCore.Meta.Syntax
open TensorCore
set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
'''


def run(path):
    proc = subprocess.run(['lake', 'env', 'lean', str(path)], cwd=root,
                          text=True, capture_output=True, timeout=60)
    return proc.returncode, proc.stdout + proc.stderr


code, output = run(root / 'examples/Verify.lean')
assert code == 0, output
for expected in ['correctedDot_correct', 'threeAdds_correct', 'Program.seq',
                 'first four products', 'cancel 8.5', 'profile :=', 'line := 10',
                 'outputBits := [1091043327, 3045064704]',
                 'correctedBits := some 3011510272']:
    assert expected in output, (expected, output)
for deps in re.findall(r'depends on axioms: \[(.*?)\]', output):
    assert set(deps.split(', ')) <= {'propext', 'Classical.choice', 'Quot.sound'}, deps
(scratch / 'example.log').write_text(output)

one = '[(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)]'
bad = '[(0x7c00, 0), (0, 0), (0, 0), (0, 0)]'
cases = {
    'wrong_group_size': ('def p : Program v100F16F32 := tc%{ block "shape" [(0, 0)]; }',
                         ['error:', 'false']),
    'oversized_operand': ('def p : Program v100F16F32 := tc%{ block "width" [(0x10000, 0), (0, 0), (0, 0), (0, 0)]; }',
                          ['error:', 'false']),
    'oversized_initial': ('def p : Program v100F16F32 := .skip\ntc_verify impossible : p from (0x100000000)\n#check impossible',
                          ['Verification incomplete', 'Unknown identifier `impossible`']),
    'nonfinite_call': (f'def p : Program v100F16F32 := tc%{{ block "bad operand" {bad}; }}\ntc_inspect p from 0\ntc_verify impossible : p from 0\n#check impossible',
                       ['nonfiniteInput', 'bad operand', 'Verification incomplete', 'Unknown identifier `impossible`']),
    'final_range': (f'def p : Program v100F16F32 := tc%{{ block "final range" {one}; }}\ntc_inspect p from 0x7f7fffff\ntc_verify impossible : p from 0x7f7fffff\n#check impossible',
                    ['finalSumOutOfRange', 'Verification incomplete', 'Unknown identifier `impossible`']),
    'nonfinite_initial': ('def p : Program v100F16F32 := .skip\ntc_inspect p from 0x7f800000\ntc_verify impossible : p from 0x7f800000\n#check impossible',
                          ['initialNonfinite', 'Verification incomplete', 'Unknown identifier `impossible`']),
    'unsupported_operation': ('def p : Program v100F16F32 := tc%{ scalar_add32 1; }',
                              ['error:', 'unexpected']),
    'wrong_operand_format': ('def words : BlockOperands (⟨fp32, 4, 23, none⟩ : Profile) := BlockOperands.ofNats [(0, 0), (0, 0), (0, 0), (0, 0)] (by decide) (by decide)\ndef p : Program v100F16F32 := tc%{ call "wrong format" words; }',
                             ['error:', 'Type mismatch']),
    'unresolved_symbolic_vc': (f'def p (n : Nat) : Program v100F16F32 := tc%{{ repeat (n) {{ block "add" {one}; }} }}\nvariable (n : Nat)\ntc_verify impossible : (p n) from 0\n#check impossible',
                               ['Verification incomplete', 'Unknown identifier `impossible`']),
    'invalid_supplied_proof': (f'def p : Program v100F16F32 := tc%{{ block "bad" {bad}; }}\ntc_verify impossible : p from 0 using (by trivial)\n#check impossible',
                               ['Verification incomplete', 'Unknown identifier `impossible`']),
}
for name, (source, expected) in cases.items():
    path = scratch / f'{name}.lean'
    path.write_text(header + source + '\n')
    code, output = run(path)
    (scratch / f'{name}.log').write_text(output)
    assert code != 0, f'{name} was incorrectly accepted'
    for marker in expected:
        assert marker.lower() in output.lower(), (name, marker, output)

# An unrelated earlier error must not roll back a valid verification later in the file.
path = scratch / 'prior_error.lean'
path.write_text(header + f'example : (1 : Nat) = 2 := by decide\n'
                f'def p : Program v100F16F32 := tc%{{ block "ok" {one}; }}\n'
                f'tc_verify still_registered : p from 0\n#check still_registered\n')
code, output = run(path)
(scratch / 'prior_error.log').write_text(output)
assert code != 0 and 'still_registered : ' in output and 'Verification incomplete' not in output, output

# Pinned instruction paths print their parameters; an unsourced name is refused.
path = scratch / 'instruction_paths.lean'
path.write_text('import TensorCore.Meta.Instruction\ntc_instruction "v100-wmma-k16"\n'
                'tc_instruction "ampere-wmma-k16"\ntc_instruction "hopper-wmma-k16"\n')
code, output = run(path)
(scratch / 'instruction_paths.log').write_text(output)
assert code == 0, output
for expected in ['HMMA.844', 'N_FMA = 4', 'groups per instruction = 4',
                 'HMMA.1688', 'N_FMA = 8', 'groups per instruction = 2',
                 'HMMA.16816', 'N_FMA = 16', 'groups per instruction = 1']:
    assert expected in output, (expected, output)
path = scratch / 'unsourced_instruction.lean'
path.write_text('import TensorCore.Meta.Instruction\ntc_instruction "turing-wmma-k16"\n')
code, output = run(path)
(scratch / 'unsourced_instruction.log').write_text(output)
assert code != 0 and 'unsourced instruction path' in output, output

report = {'example_compiles': True, 'rejection_cases': list(cases),
          'rejections': len(cases), 'prior_error_does_not_roll_back': True,
          'instruction_paths_described': 3, 'unsourced_instruction_refused': True, 'success': True,
          'method': 'Lean elaboration and kernel proof generation; failures checked in separate compilations'}
(root / 'data/regressions/program-report.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
