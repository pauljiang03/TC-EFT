#!/usr/bin/env python3
"""Compile and measure targeted WMMA vectors on a CUDA machine.

Example: python3 hardware/run.py --profile A100 --out data/hardware/run-A100
Then: python3 scripts/replay_hardware.py data/hardware/run-A100/measurements.json
Use a CUDA toolkit that supports the target (including sm_70 for V100).
The directory must be new. PTX/SASS and compiler output are preserved even if a
later operation fails; measurements.json is created only after a complete run.
"""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import os
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ARCH = {'V100': 70, 'A100': 80, 'H100': 90}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--profile', choices=ARCH, required=True)
    parser.add_argument('--out', type=Path, required=True)
    args = parser.parse_args()
    nvcc, cuobjdump = shutil.which('nvcc'), shutil.which('cuobjdump')
    if not nvcc or not cuobjdump:
        parser.error('CUDA nvcc and cuobjdump are required; no measurement has been made.')
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    source = ROOT / 'hardware/wmma_fp16.cu'
    inputs = ROOT / 'data/hardware/inputs.json'
    vectors = [v for v in json.loads(inputs.read_text())['vectors'] if v['profile'] == args.profile]
    compiler = subprocess.check_output([nvcc, '--version'], text=True)
    (out / 'nvcc-version.txt').write_text(compiler)
    executable = out / 'wmma_fp16'
    command = [nvcc, '-std=c++17', '-O2', f'-arch=sm_{ARCH[args.profile]}',
               '--ftz=false', '--fmad=true', '--keep', '--keep-dir', str(out),
               str(source), '-o', str(executable)]
    build = subprocess.run(command, cwd=out, text=True, capture_output=True)
    (out / 'build.log').write_text(build.stdout + build.stderr)
    build.check_returncode()
    sass = subprocess.check_output([cuobjdump, '--dump-sass', str(executable)], text=True)
    (out / 'sass.txt').write_text(sass)
    if 'HMMA' not in sass.upper():
        raise RuntimeError('No HMMA instruction in disassembly; refusing to label this a tensor-core run.')
    # Device output is obtained only from the executable; expected.json is never read.
    text = '\n'.join(v['id'] + ' ' + ' '.join(w for p in zip(v['a'], v['b']) for w in p)
                     + ' ' + v['c'] for v in vectors) + '\n'
    (out / 'raw-input.txt').write_text(text)
    run = subprocess.run([str(executable)], input=text, text=True, capture_output=True)
    (out / 'raw-output.jsonl').write_text(run.stdout)
    (out / 'run-stderr.txt').write_text(run.stderr)
    run.check_returncode()
    rows = [json.loads(s) for s in run.stdout.splitlines()]
    metadata, records = rows[0], rows[1:]
    if metadata['major']*10 + metadata['minor'] != ARCH[args.profile]:
        raise RuntimeError('Actual compute capability does not match the selected profile.')
    if [r['id'] for r in records] != [v['id'] for v in vectors]:
        raise RuntimeError('Missing, reordered, or duplicated device output.')
    assert all(len(r['outputs']) == 256 for r in records)
    manifest = dict(schema=1, evidence='device_measurement', profile=args.profile,
                    timestamp_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                    instruction='nvcuda::wmma::mma_sync, FP16 inputs/FP32 accumulator, m16n16k16; see saved PTX and SASS',
                    mapping='A row 0, B column 0, C(0,0); 256 output words column-major',
                    launch=dict(blocks=1, threads=32), metadata=metadata,
                    cuda_visible_devices=os.environ.get('CUDA_VISIBLE_DEVICES'),
                    compiler=compiler, command=command,
                    inputs_sha256=sha(inputs), source_sha256=sha(source),
                    executable_sha256=sha(executable), sass_sha256=sha(out/'sass.txt'),
                    raw_input_sha256=sha(out/'raw-input.txt'), raw_output_sha256=sha(out/'raw-output.jsonl'),
                    vectors=vectors, records=records)
    (out / 'measurements.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(f'{len(records)} device results recorded in {out}; run replay_hardware.py next.')


if __name__ == '__main__':
    main()
