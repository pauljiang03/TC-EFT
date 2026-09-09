#!/usr/bin/env python3
"""Build the pinned independent SoftFloat reference and run IEEE comparisons.

Use --fetch to download the reference if it is not already cached. The reference
is test-only, lives under tmp/, and is never linked into the Lean implementation.
"""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
PIN = 'f74b1e48110ac3a27dd49b787d164e55e42d81d1'
URL = 'https://github.com/ucb-bar/berkeley-softfloat-3.git'
REFERENCE = ROOT / 'tmp/berkeley-softfloat-3'
OUTPUT = ROOT / 'tmp/ieee'


def run(command, cwd=ROOT, **kwargs):
    return subprocess.run(command, cwd=cwd, check=True, **kwargs)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fetch', action='store_true')
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    if not REFERENCE.exists():
        if not args.fetch:
            raise SystemExit('Reference absent. Re-run with --fetch to download pinned SoftFloat 3e.')
        run(['git', 'clone', URL, str(REFERENCE)])
        run(['git', 'checkout', '--detach', PIN], cwd=REFERENCE)
    revision = run(['git', 'rev-parse', 'HEAD'], cwd=REFERENCE, text=True, capture_output=True).stdout.strip()
    if revision != PIN:
        raise SystemExit(f'Reference has revision {revision}; expected {PIN}. Use a separate clean cache.')
    dirty = run(['git', 'status', '--porcelain', '--untracked-files=no'], cwd=REFERENCE, text=True, capture_output=True).stdout
    if dirty.strip():
        raise SystemExit('Reference tracked sources have local changes; no comparison claimed.')
    compiler = shutil.which('cc')
    if compiler is None:
        raise SystemExit('A C compiler is required for the independent reference.')
    build = REFERENCE / 'build/Linux-x86_64-GCC'
    with (OUTPUT / 'softfloat-build.log').open('w') as log:
        run(['make', 'clean'], cwd=build, stdout=log, stderr=subprocess.STDOUT)
        run(['make', '-j4', 'SPECIALIZE_TYPE=ARM-VFPv2'], cwd=build, stdout=log, stderr=subprocess.STDOUT)
    binary = OUTPUT / 'softfloat_oracle'
    run([compiler, '-O2', '-DSOFTFLOAT_FAST_INT64', '-I', str(REFERENCE / 'source/include'),
         str(ROOT / 'tests/ieee/softfloat_oracle.c'), str(build / 'softfloat.a'), '-o', str(binary)])
    run([sys.executable, 'scripts/check_ieee.py', '--softfloat', str(binary)])
    report = ROOT / 'data/regressions/ieee-softfloat-report.json'
    data = json.loads(report.read_text())
    data['reference'] = {'repository': URL, 'commit': PIN, 'release': '3e',
                         'specialization': 'ARM-VFPv2', 'tracked_source_changes': False,
                         'same_format_conversion': 'Runner checks identity and signaling-NaN quieting; no SoftFloat same-format API exists.'}
    report.write_text(json.dumps(data, indent=2) + '\n')


if __name__ == '__main__':
    main()
