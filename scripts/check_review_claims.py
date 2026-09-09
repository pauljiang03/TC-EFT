#!/usr/bin/env python3
"""Check the current README claim links and explicit Lean review witnesses."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = ROOT
REPORT = ROOT / 'data/regressions/review-claims-report.json'


def main():
    readme = REPOSITORY / 'docs/reference.md'
    text = readme.read_text()
    assert '\u2014' not in text, 'README contains an em dash'
    section = text.split('## Main claims to review\n', 1)[1].split('\n## ', 1)[0]
    rows = re.findall(r'^\| (C\d+)\. (.+)$', section, re.M)
    assert rows and [key for key, _ in rows] == [f'C{i:02}' for i in range(1, len(rows) + 1)]
    claims = {}
    sources = {readme, Path(__file__).resolve(), ROOT / 'TensorCore/Gemm/Regression/ReviewClaims.lean'}
    for key, row in rows:
        declarations = re.findall(r'\[`(TensorCore\.[\w.]+)`\]\((../TensorCore/[^)]+\.lean)\)', row)
        assert declarations, (key, 'missing public declarations')
        claims[key] = dict(declarations=declarations)
        for name, relative in declarations:
            source = readme.parent / relative
            suffix = re.escape(name.rsplit('.', 1)[1])
            assert re.search(r'\b(?:theorem|def|abbrev)\s+(?:\w+\.)*' + suffix + r'\b', source.read_text()), (name, relative)
            sources.add(source.resolve())
    local_links = set()
    for target in re.findall(r'\]\(([^\s)]+)\)', text):
        if target.startswith(('#', 'https://', 'http://', 'mailto:')):
            continue
        path = readme.parent / target.split('#', 1)[0]
        assert path.exists() or path == REPORT, ('missing README link', target)
        local_links.add(target)
    witnesses = ['TensorCore.Regression.ReviewClaims.' + name for name in [
        'tiny_ideal', 'tiny_outputs', 'positive_error_separates_models',
        'cheaper_model_is_inaccurate', 'chosen_accuracy_and_minimum',
        'native_positive_error', 'native_error_value', 'native_accuracy',
        'family_member', 'second_family_member', 'family_members_distinct', 'family_members_accurate']]
    witnesses += ['TensorCore.Regression.NativeScaled.' + name for name in [
        'exact_scaled', 'native_range_exceeds_fp16', 'directed_input_conversion',
        'subnormal_zero_boundaries', 'raw_scaled_order_differs', 'intermediate_overflow_rejected',
        'empty_and_rejected_inputs', 'source_loss_changes_selection', 'selected_accuracy']]
    sources.add(ROOT / 'TensorCore/Gemm/Regression/NativeScaledGemm.lean')
    declarations = list(dict.fromkeys(name for claim in claims.values() for name, _ in claim['declarations']))
    subprocess.run(['lake', 'build', 'TensorCore'], cwd=ROOT, check=True, capture_output=True, text=True)
    with tempfile.TemporaryDirectory(prefix='tc-review-claims-') as directory:
        proof = Path(directory) / 'Review.lean'
        proof.write_text('import TensorCore.All\n\n' + '\n'.join('#check ' + name for name in declarations + witnesses) + '\n')
        checked = subprocess.run(['lake', 'env', 'lean', str(proof)], cwd=ROOT,
                                 check=True, capture_output=True, text=True)
    assert not re.search(r'\b(?:warning|error):', checked.stdout + checked.stderr)
    report = dict(status='passed', claims=claims, declaration_count=len(declarations),
                  kernel_checked_witnesses=witnesses, local_readme_links_checked=len(local_links),
                  human_sign_off=False, novelty_assessed=False, external_paper_review_repeated=False,
                  source_sha256={str(p.relative_to(REPOSITORY)): hashlib.sha256(p.read_bytes()).hexdigest()
                                 for p in sorted(sources)})
    REPORT.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
