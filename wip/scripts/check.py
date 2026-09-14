#!/usr/bin/env python3
"""Reproduce archived candidate evidence without adding it to the active suite."""
from pathlib import Path
import hashlib
import json
import subprocess

ROOT = Path(__file__).resolve().parents[2]


def main():
    for folder in ['vendor', 'wip/vendor']:
        pins = json.loads((ROOT / folder / 'SOURCES.json').read_text())
        for name, expected in pins['sha256'].items():
            path = ROOT / folder / 'matlab-tensor-core-v0.5' / name
            assert hashlib.sha256(path.read_bytes()).hexdigest() == expected, str(path)
    commands = [
        ['lake', 'build', 'TensorCoreWip', 'tc_wip_features'],
        ['lake', 'env', 'lean', 'wip/examples/FP8.lean'],
        ['python3', 'wip/scripts/check_device_half.py'],
        ['python3', 'wip/scripts/check_device_fp8.py'],
    ]
    for command in commands:
        print(' '.join(command), flush=True)
        subprocess.run(command, cwd=ROOT, check=True)
    print('Archived evidence reproduced. FP16-output stage order and FP8 precision remain unresolved.')


if __name__ == '__main__':
    main()
