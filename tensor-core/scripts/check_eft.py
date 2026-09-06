#!/usr/bin/env python3
"""Agent B acceptance gate, including all new proof modules through Regression.EFT.

python3 scripts/check_eft.py
Builds, audits the imported environment, checks source trust restrictions, runs
scalar coverage and independently checks hardware expectation/replay preparation.
Does not compile CUDA or claim hardware measurements or complete EFT extraction.
"""
from pathlib import Path
import argparse
import json
import shutil
import tempfile
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--clean', action='store_true', help='Run in a fresh source copy with no build cache')
    args = parser.parse_args()
    if args.clean:
        target = Path(tempfile.mkdtemp(prefix='tc-eft-clean-')) / 'tensor-core'
        shutil.copytree(ROOT, target, ignore=shutil.ignore_patterns('.lake', 'tmp', '__pycache__'))
        assert not (target / '.lake').exists()
        subprocess.run([sys.executable, 'scripts/check_eft.py'], cwd=target, check=True)
        # Only B-owned reports return to the calling checkout; shared audit docs stay put.
        for name in ['eft-coverage.json', 'eft-coverage-cases.json', 'eft-checks.json']:
            shutil.copyfile(target/'data/regressions'/name, ROOT/'data/regressions'/name)
        report_path = ROOT/'data/regressions/eft-checks.json'
        report = json.loads(report_path.read_text())
        report['preexisting_build_cache'] = False
        report_path.write_text(json.dumps(report, indent=2)+'\n')
        print(f'Fresh source copy passed; logs retained at {target}/tmp/eft')
        return
    commands = [
        ['lake', 'build'],
        ['lake', 'env', 'lean', 'Audit.lean'],
        [sys.executable, 'scripts/check_eft_coverage.py'],
        [sys.executable, 'scripts/generate_hardware.py'],
        [sys.executable, 'scripts/replay_hardware.py', '--self-test'],
    ]
    tmp = ROOT / 'tmp/eft'
    tmp.mkdir(parents=True, exist_ok=True)
    results = []
    for i, command in enumerate(commands):
        print('Running: ' + ' '.join(command), flush=True)
        p = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
        (tmp / f'check-{i}.log').write_text(p.stdout + p.stderr)
        if p.returncode:
            print(p.stdout + p.stderr, file=sys.stderr)
            p.check_returncode()
        result = dict(command=command, exit_code=p.returncode)
        if i == 0:
            result['warnings'] = [s for s in (p.stdout+p.stderr).splitlines() if 'warning:' in s.lower()]
        if i == 1:
            summaries = [s for s in p.stdout.splitlines() if s.startswith('tc_audit:')]
            assert len(summaries) == 1, p.stdout
            result['audit'] = summaries[0]
            assert 'TensorCore.EFMachine.splitMagnitude_low_residual' in p.stdout
            assert 'TensorCore.Regression.EFMachine.split_boundaries' in p.stdout
            assert 'TensorCore.scalarChecks_all' in p.stdout
        results.append(result)
    sources = [*(ROOT/'TensorCore').rglob('*.lean'), *(ROOT/'examples').glob('*.lean'),
               ROOT/'Main.lean', ROOT/'FeatureMain.lean']
    for source in sources:
        assert not re.search(r'\b(sorry|admit|axiom|native_decide|ofReduceBool|skipKernelTC)\b', source.read_text()), source
    report = dict(status='passed', commands=results, scanned_lean_sources=len(sources),
                  bounded_scope='11-bit significand multiplication and 24-bit magnitude splitting, with exact truncation/residual refinement',
                  incomplete=['Encoded decoder and extraction pipeline', 'Bounded overlap and guard',
                              'Bounded consolidation and end-to-end correctness',
                              'Useful input-family success theorem', 'Full extraction/guard/consolidation phase costs',
                              'CUDA compilation and actual GPU measurements'])
    (ROOT/'data/regressions/eft-checks.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
