#!/usr/bin/env python3
"""Build and audit a fresh source copy, with no preexisting .lake directory."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile


def source_manifest(directory):
    """Inputs to validation, excluding caches and reports that the gates regenerate."""
    result = {}
    for path in sorted(directory.rglob('*')):
        rel = path.relative_to(directory)
        if any(part in {'.lake', 'tmp', '__pycache__', '.DS_Store'} for part in rel.parts):
            continue
        if rel.parts[:2] in {('data', 'regressions'), ('data', 'hardware')} or str(rel) == 'docs/axioms.txt':
            continue
        if path.is_file():
            result[str(rel)] = hashlib.sha256(path.read_bytes()).hexdigest()
    return result


def repository_manifest(directory):
    result = {'tensor-core/' + name: digest
              for name, digest in source_manifest(directory / 'tensor-core').items()}
    for name in ['tc', 'README.md', '.gitignore']:
        result[name] = hashlib.sha256((directory / name).read_bytes()).hexdigest()
    return result


root = Path(__file__).resolve().parents[1]
before = source_manifest(root)
repository_before = repository_manifest(root.parent)
target = Path(tempfile.mkdtemp(prefix='tensor-core-clean-')) / 'tensor-core'
shutil.copytree(root.parent, target.parent, dirs_exist_ok=True,
                ignore=shutil.ignore_patterns('.git', '.lake', 'tmp', '__pycache__', '.DS_Store'))
assert not (target / '.lake').exists()
if (repository_before != repository_manifest(root.parent) or
        repository_before != repository_manifest(target.parent)):
    raise SystemExit(f'Source changed while copying; no validation claimed. Snapshot retained: {target}')
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
             ['python3', 'scripts/check_eft.py'],
             ['python3', 'scripts/check_device_half.py']]
commands += [['python3', 'scripts/check_paper_spec.py']]
commands += [['python3', 'scripts/check_device_fp8.py']]
commands += [['python3', 'scripts/check_gemm.py']]
commands += [['python3', 'scripts/check_gemm_extensions.py']]
commands += [['python3', 'scripts/check_axioms_regression.py']]
commands += [['python3', 'scripts/check_reviewer.py'], ['python3', 'scripts/check_cutlass.py']]
commands += [['python3', 'scripts/check_tool.py']]
commands += [['python3', 'scripts/check_analysis.py'], ['python3', 'scripts/check_pipeline_analysis.py']]
# Enumerate the copied examples so concurrent workspace edits do not change this run.
commands += [['lake', 'env', 'lean', str(p.relative_to(target))]
             for p in sorted((target / 'examples').glob('*.lean'))
             if p.name not in {'CanonicalInvocation.lean', 'LongDotProduct.lean'}]
logs = []
for index, command in enumerate(commands, 1):
    print(f'[{index}/{len(commands)}] {" ".join(command)}', file=sys.stderr, flush=True)
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
              eft_paper_checks=json.loads((target / 'data/regressions/eft-paper-report.json').read_text()),
              bounded_eft_checks=json.loads((target / 'data/regressions/bounded-eft-report.json').read_text()),
              paper_spec_checks=json.loads((target / 'data/regressions/paper-spec-report.json').read_text()),
              fp8_evidence=json.loads((target / 'data/regressions/device-fp8-report.json').read_text()),
              gemm_checks=json.loads((target / 'data/regressions/gemm-report.json').read_text()),
              gemm_extension_checks=json.loads((target / 'data/regressions/gemm-extensions-report.json').read_text()),
              reviewer_checks=json.loads((target / 'data/regressions/reviewer-report.json').read_text()),
              tool_checks=json.loads((target / 'data/regressions/tool-report.json').read_text()),
              analysis_checks=json.loads((target / 'data/regressions/analysis-report.json').read_text()),
              pipeline_analysis_checks=json.loads((target / 'data/regressions/pipeline-analysis-report.json').read_text()),
              cutlass_checks=json.loads((target / 'data/regressions/cutlass-report.json').read_text()),
              independent_validation_passed=True, v100_device_replay_passed=True,
              axiom_audit_regression_passed=True,
              all_standalone_examples=True,
              lean_warnings=len(re.findall(r'^warning:', logs[0], re.M)),
              linker_warnings=len(re.findall(r'^(?:ld|ld64\.lld|ld\.lld): warning:', logs[0], re.M)))
(root / 'tmp').mkdir(exist_ok=True)
(root / 'tmp/clean-build.log').write_text('\n'.join(logs))
report.update(source_sha256=before, repository_source_sha256=repository_before,
              snapshot_stable=repository_before == repository_manifest(target.parent),
              workspace_matches_snapshot=repository_before == repository_manifest(root.parent))
if not report['snapshot_stable'] or not report['workspace_matches_snapshot']:
    report['publication_skipped'] = True
    (root / 'tmp/clean-build-unpublished.json').write_text(json.dumps(report, indent=2) + '\n')
    raise SystemExit(f'Source changed during validation; reports not published. Validated copy retained: {target}')
# Publish reports from the same fresh source run.
generated = ['docs/axioms.txt', 'data/hardware/inputs.json', 'data/hardware/expected.json',
             'data/hardware/replay-self-test.json']
generated += ['data/regressions/' + name for name in [
    'program-report.json', 'feature-report.json', 'dot-product-report.json',
    'device-formats-report.json', 'device-report.json', 'validation-report.json',
    'certificate-report.json', 'application-report.json', 'device-half-report.json', 'eft-checks.json',
    'eft-coverage.json', 'eft-coverage-cases.json', 'eft-paper-report.json',
    'eft-paper-cases.json', 'eft-paper-original.json', 'eft-paper-second-pass.json', 'paper-spec-report.json',
    'device-fp8-report.json', 'gemm-report.json', 'gemm-extensions-report.json', 'bounded-eft-report.json',
    'reviewer-report.json', 'cutlass-report.json', 'tool-report.json', 'analysis-report.json', 'pipeline-analysis-report.json']]
for name in generated:
    shutil.copyfile(target / name, root / name)
(root / 'data/regressions/clean-build.json').write_text(json.dumps(report, indent=2) + '\n')
shutil.rmtree(target.parent, ignore_errors=True)
print(json.dumps(report, indent=2))
