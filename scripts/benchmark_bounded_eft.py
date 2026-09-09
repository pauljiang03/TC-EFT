#!/usr/bin/env python3
"""Paired native EFT timings against the same sources with standard linear scans.

Build both variants from one stable, cache-free snapshot. Only the two support
scan definitions differ. Parse inputs before timing and consume every result in
a branch-sensitive checksum. Compare complete diagnostics before timing. These
CPU measurements are not a theorem about runtime or evidence of GPU performance.
"""
from collections import Counter
from pathlib import Path
import argparse
import hashlib
import json
import platform
import random
import shutil
import statistics
import subprocess
import tempfile

from check_bounded_eft import PROFILES, row

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / 'tmp/bounded-eft-benchmark'
SCAN = 'TensorCore/EFT/Machine/BitScanDefs.lean'
LINEAR_SCAN = '''import TensorCore.Core.Encoding
namespace TensorCore.EFMachine
def leadingZeros (m : BitVec 576) : BitVec 576 := m.clz
def trailingZeros (m : BitVec 576) : BitVec 576 := m.ctz
end TensorCore.EFMachine
'''


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sources(root):
    files = [*sorted(root.glob('*.lean')), *sorted((root / 'TensorCore').rglob('*.lean')),
             *sorted((root / 'scripts').glob('*.py')), root / 'lakefile.toml',
             root / 'lean-toolchain', root / 'data/regressions/eft-paper-cases.json']
    return {str(p.relative_to(root)): digest(p) for p in files}


def run(command, cwd):
    p = subprocess.run(command, cwd=cwd, text=True, capture_output=True, check=True)
    return p.stdout


def corpus(root):
    paper = json.loads((root / 'data/regressions/eft-paper-cases.json').read_text())['blocks']
    rng = random.Random(20260907)

    def finite(frac, exp):
        while True:
            n = rng.getrandbits(1 + frac + exp)
            if (n >> frac & ((1 << exp) - 1)) != (1 << exp) - 1:
                return hex(n)

    broad = []
    for profile, (f, e, _, k, _, _) in PROFILES.items():
        for i in range(128):
            broad.append(dict(id=f'{profile}/arbitrary-D/{i}', profile=profile,
                              a=[finite(f, e) for _ in range(k)],
                              b=[finite(f, e) for _ in range(k)],
                              c=finite(23, 8), D=finite(23, 8)))
    return [row(c) for c in paper], [row(c) for c in broad]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--samples', type=int, default=5)
    parser.add_argument('--repeats', type=int, default=2)
    args = parser.parse_args()
    if args.samples < 3 or args.repeats < 1:
        parser.error('Use at least three samples and one repeat')
    WORK.mkdir(parents=True, exist_ok=True)
    before = sources(ROOT)
    with tempfile.TemporaryDirectory(prefix='tc-eft-benchmark-') as folder:
        base = Path(folder)
        optimized, baseline = base / 'optimized', base / 'baseline'
        shutil.copytree(ROOT, optimized, ignore=shutil.ignore_patterns('.lake', 'tmp', '__pycache__'))
        if before != sources(ROOT) or before != sources(optimized):
            raise RuntimeError('Sources changed while copying; rerun on a stable snapshot')
        shutil.copytree(optimized, baseline)
        (baseline / SCAN).write_text(LINEAR_SCAN)
        (WORK / 'baseline-BitScan.lean').write_text(LINEAR_SCAN)
        for name, root in [('optimized', optimized), ('baseline', baseline)]:
            log = run(['lake', 'build', 'tc_bounded_eft'], root)
            (WORK / (name + '-build.log')).write_text(log)
        binaries = {name: root / '.lake/build/bin/tc_bounded_eft'
                    for name, root in [('baseline', baseline), ('optimized', optimized)]}
        paper, broad = corpus(optimized)
        all_rows = paper + broad
        batch = WORK / 'all.txt'
        batch.write_text('\n'.join(all_rows) + '\n')
        outputs = {name: run([str(binary), str(batch)], base) for name, binary in binaries.items()}
        if outputs['baseline'] != outputs['optimized']:
            raise RuntimeError('Baseline and optimized diagnostics disagree')
        decoded = [json.loads(line) for line in outputs['optimized'].splitlines()]
        if len(decoded) != len(all_rows) or any('error' in d for d in decoded):
            raise RuntimeError('Unexpected rejection or missing output in finite corpus')
        branches = Counter(d['branch'] for d in decoded)
        groups = {'paper': paper, 'broad_finite': broad}
        for branch in ['scalar', 'boundedExact', 'outOfRange']:
            groups[branch] = [line for line, d in zip(all_rows, decoded) if d['branch'] == branch]
        results = {}
        for label, rows in groups.items():
            batch = WORK / (label + '.txt')
            batch.write_text('\n'.join(rows) + '\n')

            def measure(name, repeats):
                d = json.loads(run([str(binaries[name]), '--benchmark', str(repeats), str(batch)], base))
                if d['blocks'] != len(rows) or d['repeats'] != repeats:
                    raise RuntimeError('Incorrect benchmark execution count')
                return d

            # Warm both binaries, then alternate order to reduce order bias.
            for name in binaries:
                measure(name, 1)
            samples = []
            for i in range(args.samples):
                order = ['baseline', 'optimized'] if i % 2 == 0 else ['optimized', 'baseline']
                pair = {name: measure(name, args.repeats) for name in order}
                if pair['baseline']['checksum'] != pair['optimized']['checksum']:
                    raise RuntimeError('Result/branch checksum mismatch')
                samples.append(pair)
            medians = {name: statistics.median(p[name]['elapsed_ns'] for p in samples) for name in binaries}
            results[label] = dict(blocks=len(rows), input_sha256=digest(batch), samples=samples,
                                  median_ns=medians, speedup=medians['baseline'] / medians['optimized'])
            print(f"{label}: {results[label]['speedup']:.2f}x median speedup", flush=True)
        report = dict(status='passed', platform=platform.platform(), machine=platform.machine(),
                      lean=run(['lake', 'env', 'lean', '--version'], optimized).strip(),
                      baseline='Same source snapshot, replacing only BitScan.lean with standard BitVec.clz/ctz',
                      baseline_scan_source=LINEAR_SCAN, samples=args.samples, repeats=args.repeats,
                      timed_scope='In-process encoded EFT execution and checksum; parsing and JSON excluded',
                      caveat='Local CPU measurements; no timing theorem, storage-layout guarantee, or GPU claim',
                      differential_blocks=len(decoded), diagnostic_mismatches=0, branches=dict(branches),
                      diagnostic_output_sha256=hashlib.sha256(outputs['optimized'].encode()).hexdigest(),
                      binary_sha256={name: digest(binary) for name, binary in binaries.items()},
                      source_sha256=before, results=results,
                      sources_unchanged_at_finish=before == sources(ROOT))
        destination = ROOT / 'data/regressions/bounded-eft-benchmark.json'
        destination.write_text(json.dumps(report, indent=2) + '\n')
        print(f'Report: {destination}', flush=True)


if __name__ == '__main__':
    main()
