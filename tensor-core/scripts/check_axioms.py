#!/usr/bin/env python3
"""Check declared theorem roots against a strict standard-axiom allowlist."""
from pathlib import Path
import re
import subprocess

root = Path(__file__).resolve().parents[1]
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
proc = subprocess.run(['lake', 'env', 'lean', 'Audit.lean'], cwd=root,
                      check=True, text=True, capture_output=True)
lines = [line for line in proc.stdout.splitlines() if line]
expected = (root / 'Audit.lean').read_text().count('#print axioms ')
assert len(lines) == expected, proc.stdout + proc.stderr
for line in lines:
    if 'does not depend on any axioms' in line:
        continue
    match = re.fullmatch(r"'[^']+' depends on axioms: \[(.*)\]", line)
    assert match, line
    names = set(match.group(1).split(', ')) if match.group(1) else set()
    assert names <= allowed, (line, names - allowed)
for source in (root / 'TensorCore').rglob('*.lean'):
    text = source.read_text()
    assert not re.search(r'\b(sorry|admit|axiom|native_decide|ofReduceBool|skipKernelTC)\b', text), source
(root / 'docs/axioms.txt').write_text(proc.stdout)
print(f'{expected} theorem roots audited; only standard Lean axioms; no placeholders or compiled reflection.')
