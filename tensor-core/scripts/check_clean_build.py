#!/usr/bin/env python3
"""Build and audit a fresh source copy, with no preexisting .lake directory."""
from pathlib import Path
import json
import re
import shutil
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
target = Path(tempfile.mkdtemp(prefix='tensor-core-clean-')) / 'tensor-core'
shutil.copytree(root, target, ignore=shutil.ignore_patterns('.lake', 'tmp', '__pycache__'))
assert not (target / '.lake').exists()
commands = [['lake', 'build'], ['python3', 'scripts/check_axioms.py'],
            ['python3', 'scripts/check_programs.py'], ['python3', 'scripts/check_features.py'],
            ['python3', 'scripts/check_dot_products.py'],
            ['python3', 'scripts/check_device_formats.py'],
            ['lake', 'env', 'lean', 'examples/CanonicalInvocation.lean'],
            ['lake', 'env', 'lean', 'examples/LongDotProduct.lean']]
commands += [['python3', 'scripts/check_certificates.py'],
             ['python3', 'scripts/check_application.py'],
             ['python3', 'scripts/validate.py'],
             ['python3', 'scripts/check_device.py'],
             ['python3', 'scripts/check_eft.py']]
commands += [['lake', 'env', 'lean', str(p.relative_to(root))]
             for p in sorted((root / 'examples').glob('*.lean'))
             if p.name not in {'CanonicalInvocation.lean', 'LongDotProduct.lean'}]
logs = []
for command in commands:
    proc = subprocess.run(command, cwd=target, text=True, capture_output=True)
    logs.append(proc.stdout + proc.stderr)
    if proc.returncode:
        print(logs[-1])
        raise SystemExit(proc.returncode)
targets = re.findall(r'\[(\d+)/(\d+)\]', logs[0])
report = {'preexisting_build_cache': False, 'commands': commands,
          'targets_built': int(targets[-1][1]) if targets else None,
          'audit': logs[1].strip().splitlines()[-1] if logs[1].strip() else None,
          'program_checks': json.loads(logs[2]), 'feature_checks': json.loads(logs[3]),
          'dot_product_checks': json.loads(logs[4]), 'format_evidence': json.loads(logs[5]),
          'canonical_example': True, 'long_dot_product_example': True, 'success': True}
report.update(certificate_checks=json.loads(logs[8]), application_checks=json.loads(logs[9]),
              eft_checks=json.loads((target / 'data/regressions/eft-checks.json').read_text()),
              independent_validation_passed=True, v100_device_replay_passed=True,
              all_standalone_examples=True,
              lean_warnings=len(re.findall(r'^warning:', logs[0], re.M)),
              linker_warnings=len(re.findall(r'^(?:ld|ld64\.lld|ld\.lld): warning:', logs[0], re.M)))
(root / 'tmp').mkdir(exist_ok=True)
(root / 'tmp/clean-build.log').write_text('\n'.join(logs))
# Publish reports from the same fresh source run; handoff manifests remain historical.
generated = ['docs/axioms.txt', 'data/hardware/inputs.json', 'data/hardware/expected.json',
             'data/hardware/replay-self-test.json']
generated += ['data/regressions/' + name for name in [
    'program-report.json', 'feature-report.json', 'dot-product-report.json',
    'device-formats-report.json', 'device-report.json', 'validation-report.json',
    'certificate-report.json', 'application-report.json', 'eft-checks.json',
    'eft-coverage.json', 'eft-coverage-cases.json']]
for name in generated:
    shutil.copyfile(target / name, root / name)
(root / 'data/regressions/clean-build.json').write_text(json.dumps(report, indent=2) + '\n')
shutil.rmtree(target.parent, ignore_errors=True)
print(json.dumps(report, indent=2))
