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
(root / 'tmp').mkdir(exist_ok=True)
(root / 'tmp/clean-build.log').write_text('\n'.join(logs))
(root / 'data/regressions/clean-build.json').write_text(json.dumps(report, indent=2) + '\n')
shutil.rmtree(target.parent, ignore_errors=True)
print(json.dumps(report, indent=2))
