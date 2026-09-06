#!/usr/bin/env python3
"""Replay raw targeted GPU measurements against separate model expectations.

python3 scripts/replay_hardware.py --self-test
python3 scripts/replay_hardware.py data/hardware/run-A100/measurements.json
Self-tests use synthetic records only in memory. They cannot close GPU validation.
"""
from pathlib import Path
import argparse
import copy
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
ARCH = {'V100': 70, 'A100': 80, 'H100': 90}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def compare(document, inputs, expectations):
    require(document.get('schema') == 1 and document.get('evidence') == 'device_measurement',
            'Only device_measurement records may be replayed as hardware evidence')
    profile = document.get('profile')
    require(profile in ARCH, 'Unknown profile')
    for field in ['timestamp_utc', 'instruction', 'mapping', 'launch', 'metadata', 'compiler', 'command',
                  'inputs_sha256', 'source_sha256', 'executable_sha256', 'sass_sha256',
                  'raw_input_sha256', 'raw_output_sha256', 'vectors', 'records']:
        require(bool(document.get(field)), f'Missing provenance: {field}')
    require(document['inputs_sha256'] == expectations['inputs_sha256'], 'Wrong corpus hash')
    metadata = document['metadata']
    require(metadata.get('major', -1)*10 + metadata.get('minor', -1) == ARCH[profile], 'Wrong device architecture')
    for field in ['device', 'driver', 'runtime']:
        require(bool(metadata.get(field)), f'Missing device metadata: {field}')
    vectors = [v for v in inputs['vectors'] if v['profile'] == profile]
    require(document['vectors'] == vectors, 'Raw inputs differ from the target corpus')
    require(document['launch'] == {'blocks': 1, 'threads': 32}, 'Unexpected launch')
    records = document['records']
    require([r.get('id') for r in records] == [v['id'] for v in vectors],
            'Missing, reordered, unknown, or duplicate result ids')
    expected = {e['id']: e['bits'] for e in expectations['expected']}
    require(len(expected) == len(expectations['expected']) == len(inputs['vectors']), 'Expectation set mismatch')
    mismatches = []
    for record in records:
        bits = record.get('outputs')
        require(isinstance(bits, list) and len(bits) == 256, 'Expected all 256 output words')
        require(all(isinstance(w, str) and re.fullmatch('[0-9a-f]{8}', w) for w in bits), 'Invalid FP32 word')
        if bits[0] != expected[record['id']]:
            mismatches.append(dict(id=record['id'], expected=expected[record['id']], measured=bits[0]))
    return mismatches


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_artifacts(path, doc):
    folder = path.parent
    for name, field in [('wmma_fp16', 'executable_sha256'), ('sass.txt', 'sass_sha256'),
                        ('raw-input.txt', 'raw_input_sha256'), ('raw-output.jsonl', 'raw_output_sha256')]:
        require(sha(folder / name) == doc[field], f'Artifact hash mismatch: {name}')
    require(sha(ROOT / 'hardware/wmma_fp16.cu') == doc['source_sha256'], 'Harness source differs')
    raw = [json.loads(s) for s in (folder / 'raw-output.jsonl').read_text().splitlines()]
    require(raw[0] == doc['metadata'] and raw[1:] == doc['records'], 'Manifest differs from raw output')
    rows = '\n'.join(v['id'] + ' ' + ' '.join(w for p in zip(v['a'], v['b']) for w in p)
                     + ' ' + v['c'] for v in doc['vectors']) + '\n'
    require((folder / 'raw-input.txt').read_text() == rows, 'Manifest differs from raw input')


def self_test(inputs, expectations):
    # The synthetic fixture is never persisted; production replay additionally requires
    # the original binary, SASS and raw input/output artifacts and their hashes.
    vectors = [v for v in inputs['vectors'] if v['profile'] == 'A100']
    expected = {e['id']: e['bits'] for e in expectations['expected']}
    doc = dict(schema=1, evidence='device_measurement', profile='A100', timestamp_utc='synthetic',
               instruction='synthetic', mapping='synthetic', launch=dict(blocks=1, threads=32),
               metadata=dict(major=8, minor=0, device='synthetic', driver=1, runtime=1),
               compiler='synthetic', command=['synthetic'], inputs_sha256=expectations['inputs_sha256'],
               source_sha256='synthetic', executable_sha256='synthetic', sass_sha256='synthetic',
               raw_input_sha256='synthetic', raw_output_sha256='synthetic', vectors=vectors,
               records=[dict(id=v['id'], outputs=[expected[v['id']]] + ['00000000']*255) for v in vectors])
    require(compare(doc, inputs, expectations) == [], 'Synthetic match failed')
    bad = copy.deepcopy(doc)
    bad['records'][0]['outputs'][0] = 'ffffffff'
    require(len(compare(bad, inputs, expectations)) == 1, 'Mismatch was not detected')
    mutations = [
        lambda d: d.update(evidence='model_expectation_unmeasured'),
        lambda d: d['records'].pop(),
        lambda d: d['records'].append(d['records'][0]),
        lambda d: d['records'][0].update(id='unknown'),
        lambda d: d['records'][0].update(outputs=['00000000']),
        lambda d: d['records'][0]['outputs'].__setitem__(0, '100000000'),
        lambda d: d['metadata'].update(major=9),
        lambda d: d.pop('compiler'),
        lambda d: d.update(inputs_sha256='wrong'),
        lambda d: d['vectors'][0].update(c='00000001'),
    ]
    for mutate in mutations:
        bad = copy.deepcopy(doc)
        mutate(bad)
        try:
            compare(bad, inputs, expectations)
        except ValueError:
            pass
        else:
            raise AssertionError('Malformed synthetic record was accepted')
    report = dict(evidence='synthetic_replay_tests_only', checks=2+len(mutations),
                  prepared_vectors=len(inputs['vectors']), measured_vectors=0,
                  status='passed; GPU compilation and measurements remain open')
    (ROOT / 'data/hardware/replay-self-test.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('measurement', nargs='?', type=Path)
    parser.add_argument('--self-test', action='store_true')
    args = parser.parse_args()
    source = ROOT / 'data/hardware/inputs.json'
    inputs = json.loads(source.read_text())
    expectations = json.loads((ROOT / 'data/hardware/expected.json').read_text())
    require(sha(source) == expectations['inputs_sha256'], 'Input corpus has changed; regenerate expectations')
    if args.self_test:
        self_test(inputs, expectations)
    if args.measurement:
        doc = json.loads(args.measurement.read_text())
        mismatches = compare(doc, inputs, expectations)
        verify_artifacts(args.measurement, doc)
        print(json.dumps(dict(evidence='device_measurement', profile=doc['profile'],
                              compared=len(doc['records']), mismatches=mismatches), indent=2))
        if mismatches:
            raise SystemExit(1)
    elif not args.self_test:
        parser.error('Provide measurements.json or --self-test; model expectations are not measurements')


if __name__ == '__main__':
    main()
