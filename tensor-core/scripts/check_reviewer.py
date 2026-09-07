#!/usr/bin/env python3
"""Reproduce the README's small, editable GEMM walkthrough against fixed answers."""
from pathlib import Path
import hashlib
import json
import subprocess

from check_gemm_extensions import compare

ROOT = Path(__file__).resolve().parents[1]


def at_path(value, path):
    for part in path.split('.'):
        value = value[int(part)] if isinstance(value, list) else value[part]
    return value


def main():
    cases_file = ROOT / 'data/examples/gemm.jsonl'
    answers_file = ROOT / 'data/examples/gemm.expected.json'
    cases = [json.loads(line) for line in cases_file.read_text().splitlines()]
    answers = json.loads(answers_file.read_text())
    subprocess.run(['lake', 'build', 'tc_gemm'], cwd=ROOT,
                   text=True, capture_output=True, check=True)
    run = subprocess.run([str(ROOT / '.lake/build/bin/tc_gemm'), str(cases_file)],
                         cwd=ROOT, text=True, capture_output=True, check=True)
    outputs = [json.loads(line) for line in run.stdout.splitlines()]
    assert len(cases) == len(answers) == len(outputs)
    for case, answer, output in zip(cases, answers, outputs):
        assert case['name'] == answer['name']
        for path, expected in answer['checks'].items():
            actual = at_path(output, path)
            assert actual == expected, (case['name'], path, actual, expected)
        compare(case, output)
        print('PASS ' + case['name'])
    work = ROOT / 'tmp/reviewer'
    work.mkdir(parents=True, exist_ok=True)
    (work / 'gemm.outputs.jsonl').write_text(run.stdout)
    sources = [cases_file, answers_file, Path(__file__).resolve(),
               ROOT / 'GemmMain.lean', ROOT / 'TensorCore/Cli/Gemm.lean']
    report = dict(status='passed', cases=len(cases), fixed_expected_values=True,
                  independent_fraction_oracle=True,
                  source_sha256={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                                 for p in sources})
    (ROOT / 'data/regressions/reviewer-report.json').write_text(json.dumps(report, indent=2) + '\n')


if __name__ == '__main__':
    main()
