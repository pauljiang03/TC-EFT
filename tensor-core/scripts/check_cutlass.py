#!/usr/bin/env python3
"""Check the pinned source projection and its independent complete-matrix fixture.

Offline by default. --hardware-json FILE additionally compares a captured run of
kernels/cutlass/wmma_sm70.cu; an absent CUDA result is never called a hardware pass.
"""
from pathlib import Path
from fractions import Fraction
import argparse
import hashlib
import json
import shutil
import struct
import subprocess

ROOT = Path(__file__).resolve().parents[1]
PIN = ROOT / 'kernels/cutlass/pin.json'
REVISION = 'f7b19de32c5d1f3cedfc735c2849f12b537522ee'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def verify_sources(pin, read):
    assert pin['revision'] == REVISION
    for path, expected in pin['source_sha256'].items():
        assert digest(read(path)) == expected, path
    for item in pin['source_map']:
        source = read(item['path']).decode()
        for anchor in item['anchors']:
            assert anchor in source, (item['path'], anchor)


def expected_fixture(wrong_layout=False, omit_last_k=False):
    values = [Fraction(0), Fraction(1), Fraction(-1), Fraction(1, 2), Fraction(-1, 2)]
    a = [values[(i + l) % 5] for i in range(65) for l in range(32)]
    b = [values[(l + 3 * j) % 5] for j in range(67) for l in range(32)]
    bits = []
    for i in range(65):
        for j in range(67):
            exact = sum((a[i * 32 + l] * b[l * 67 + j if wrong_layout else j * 32 + l]
                         for l in range(16 if omit_last_k else 32)), Fraction())
            # These small quarter-integer sums and every prefix are exactly FP32.
            value = float(exact)
            assert Fraction(value) == exact
            word = struct.unpack('<I', struct.pack('<f', value))[0]
            assert Fraction(struct.unpack('<f', struct.pack('<I', word))[0]) == exact
            bits.append(word)
    return dict(m=65, n=67, k=32, bits=bits)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--hardware-json', type=Path)
    parser.add_argument('--cutlass-root', type=Path, help='Compile and run on V100 using this clean pinned full checkout')
    args = parser.parse_args()
    pin = json.loads(PIN.read_text())
    read = lambda path: (ROOT / 'kernels/cutlass/upstream' / path).read_bytes()
    verify_sources(pin, read)
    # Detect even a one-byte upstream mutation, independently of marker strings.
    mutated = next(iter(pin['source_sha256']))
    try:
        verify_sources(pin, lambda path: read(path) + (b'\n' if path == mutated else b''))
    except AssertionError:
        pass
    else:
        raise AssertionError('Changed upstream bytes accepted')
    cpp = (ROOT / 'kernels/cutlass/wmma_sm70.cu').read_text()
    lean = (ROOT / 'TensorCore/Kernels/CutlassWmma.lean').read_text()
    assert REVISION in cpp and REVISION in lean
    config = pin['configuration']
    tm, tn, tk = config['threadblock']
    assert tm * tk >= config['threads'] * 8 and tn * tk >= config['threads'] * 8
    assert config['warp'] == [32, 32, 16] and config['wmma_fragments_per_warp'] == 4
    for token in ['GemmShape<64, 64, 16>', 'GemmShape<32, 32, 16>', 'GemmShape<16, 16, 16>',
                  'ScaleType::Nothing', 'OpClassWmmaTensorOp', 'arch::Sm70',
                  '1, 1, 1, false, cutlass::arch::OpMultiplyAdd', 'k % 16 != 0']:
        assert token in cpp, token
    subprocess.run(['lake', 'build', 'TensorCore.Regression.CutlassWmma'], cwd=ROOT,
                   capture_output=True, text=True, check=True)
    run = subprocess.run(['lake', 'env', 'lean', '--run', 'examples/CutlassWmma.lean'],
                         cwd=ROOT, capture_output=True, text=True, check=True)
    result = json.loads(run.stdout)
    expected = expected_fixture()
    assert result == expected, 'Lean fixture differs from independent exact-rational matrix'
    assert expected_fixture(wrong_layout=True) != expected, 'Fixture misses a B-layout mutation'
    assert expected_fixture(omit_last_k=True) != expected, 'Fixture misses a missing K iteration'
    work = ROOT / 'tmp/cutlass'
    work.mkdir(parents=True, exist_ok=True)
    compiler = None
    cuda_executed = False
    if args.cutlass_root:
        checkout = args.cutlass_root.resolve()
        head = subprocess.check_output(['git', '-C', str(checkout), 'rev-parse', 'HEAD'], text=True).strip()
        assert head == REVISION, 'Full checkout must use the pinned revision'
        dirty = subprocess.check_output(['git', '-C', str(checkout), 'status', '--porcelain',
                                         '--untracked-files=all', '--', 'include'], text=True)
        assert not dirty, 'Pinned include tree has local changes'
        nvcc = shutil.which('nvcc')
        assert nvcc, 'nvcc is required for --cutlass-root (offline source checks need no CUDA)'
        compiler = subprocess.check_output([nvcc, '--version'], text=True)
        command = [nvcc, '-std=c++17', '-arch=sm_70', '-I' + str(checkout / 'include'),
                   str(ROOT / 'kernels/cutlass/wmma_sm70.cu'), '-o', str(work / 'wmma-sm70')]
        compiled = subprocess.run(command, text=True, capture_output=True)
        (work / 'nvcc.log').write_text(compiled.stdout + compiled.stderr)
        assert compiled.returncode == 0, compiled.stdout + compiled.stderr
        executed = subprocess.run([str(work / 'wmma-sm70')], text=True, capture_output=True)
        (work / 'device.log').write_text(executed.stderr)
        assert executed.returncode == 0, executed.stderr
        args.hardware_json = work / 'hardware.json'
        args.hardware_json.write_text(executed.stdout)
        cuda_executed = True
    hardware = None
    if args.hardware_json:
        data = json.loads(args.hardware_json.read_text())
        assert data == expected, 'Pinned CUDA fixture differs from Lean/reference'
        hardware = dict(status='matched_fixture', file=str(args.hardware_json),
                        sha256=digest(args.hardware_json.read_bytes()))
    (work / 'lean.json').write_text(json.dumps(result) + '\n')
    inputs = [PIN, ROOT / 'kernels/cutlass/wmma_sm70.cu',
              ROOT / 'TensorCore/Kernels/CutlassWmma.lean',
              ROOT / 'TensorCore/Regression/CutlassWmma.lean', ROOT / 'examples/CutlassWmma.lean', Path(__file__)]
    report = dict(status='passed', revision=REVISION, upstream_files=len(pin['source_sha256']),
                  theorem='TensorCore.CutlassWmma.project_eq_gemm',
                  scope='Reviewed source arithmetic projection; K divisible by 16; identity epilogue',
                  fixture=dict(m=65, n=67, k=32, compared_words=4355),
                  independent_fraction_oracle=True, mutation_controls=3,
                  partial_k_numerical_counterexample_kernel_checked=True,
                  cuda_compiled=compiler is not None, cuda_executed=cuda_executed, compiler_version=compiler,
                  nvcc_available=shutil.which('nvcc') is not None, hardware_fixture=hardware,
                  source_sha256={str(p.relative_to(ROOT)): digest(p.read_bytes()) for p in inputs},
                  limitations=pin['trust_boundary'])
    (ROOT / 'data/regressions/cutlass-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
