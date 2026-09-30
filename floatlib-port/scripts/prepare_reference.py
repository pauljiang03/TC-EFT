#!/usr/bin/env python3
"""Build the actual pinned paper dependencies in an isolated compatibility directory.

Arithmetic and proofs are copied verbatim from the current parent sources after
comparison to Git. The parent may relocate modules and remove unused imports; all non-import bytes stay pinned. Only the three
Nat/Int/Rat notation declarations are renamed and scoped to TensorCore, avoiding
mathlib parser collisions without changing their expansions or arithmetic.
"""
from pathlib import Path
import hashlib, json, re, subprocess

PORT = Path(__file__).resolve().parents[1]
REPO = PORT.parent
PIN = "990afac10b94a84f3de24743206756dd7acc3276"
OUT = PORT / "reference-compat"

def imports(data):
    return [module for line in re.findall(r'^import ([^\n]+)', data, re.M)
            for module in line.split() if module.startswith('TensorCore.')]

def legacy_module(module):
    """Module relocations change imports, never mathematical declaration namespaces."""
    exact = {
        'TensorCore.Kernels.EFT.Defs': 'TensorCore.EFT.Bounded',
        'TensorCore.Kernels.EFT.Native': 'TensorCore.EFT.Native',
    }
    if module in exact:
        return exact[module]
    for current, original in [
        ('TensorCore.Numerics.', 'TensorCore.Core.'),
        ('TensorCore.Kernels.EFT.', 'TensorCore.EFT.Machine.'),
        ('TensorCore.Scalar.', 'TensorCore.IEEE.'),
    ]:
        if module.startswith(current):
            return original + module[len(current):]
    return module


def legacy_import(line):
    if not line.startswith(b'import '):
        return line
    words = line.decode().strip().split()
    return ('import ' + ' '.join(legacy_module(word) for word in words[1:]) + '\n').encode()


def main():
    pending = [module for p in (PORT/'TCFloat/Equivalence').glob('*.lean')
               for module in imports(p.read_text())]
    verified = {}
    pruned_imports = {}
    origins = {}
    while pending:
        module = pending.pop()
        name = module.replace('.', '/') + '.lean'
        if name in verified:
            continue
        origin = legacy_module(module).replace('.', '/') + '.lean'
        origins[name] = origin
        pinned = subprocess.check_output(["git", "show", f"{PIN}:{origin}"], cwd=REPO)
        data = (REPO / name).read_bytes()
        if data != pinned:
            # Cleanup can remove imports, never add replacements or change proof/model bodies.
            pinned_lines, current_lines = pinned.splitlines(keepends=True), [legacy_import(line) for line in data.splitlines(keepends=True)]
            body = lambda lines: b''.join(line for line in lines if not line.startswith(b'import '))
            if body(pinned_lines) != body(current_lines):
                raise RuntimeError(f"Original arithmetic/proof source differs from pinned revision: {name}")
            old = [line for line in pinned_lines if line.startswith(b'import ')]
            new = [line for line in current_lines if line.startswith(b'import ')]
            remaining = iter(old)
            if not all(any(line == candidate for candidate in remaining) for line in new):
                raise RuntimeError(f"Original imports are not a subset of pinned imports: {name}")
            pruned_imports[name] = [line.decode().strip() for line in old if line not in new]
        verified[name] = hashlib.sha256(data).hexdigest()
        pending.extend(imports(data.decode()))
        if name == "TensorCore/Numerics/Notation.lean":
            data = data.replace(b'notation "', b'namespace TensorCore\nnotation "', 1) + b"\nend TensorCore\n"
            for symbol, suffix in [("ℕ", "Nat"), ("ℤ", "Int"), ("ℚ", "Rat")]:
                data = data.replace(f'notation "{symbol}"'.encode(),
                    f'scoped notation (name := compat{suffix}) "{symbol}"'.encode())
        target = OUT / name
        target.parent.mkdir(parents=True, exist_ok=True)
        if not target.exists() or target.read_bytes() != data:
            target.write_bytes(data)
    for stale in (OUT/'TensorCore').rglob('*.lean'):
        if str(stale.relative_to(OUT)) not in verified:
            stale.unlink()
    (OUT/'manifest.json').write_text(json.dumps({'revision':PIN,
        'notation_shim':'three declarations renamed and scoped; same expansions',
        'removed_unused_imports':dict(sorted(pruned_imports.items())),
        'source_origin':dict(sorted(origins.items())),
        'source_sha256':dict(sorted(verified.items()))},indent=2)+'\n')
    print(f"Verified {len(verified)} paper dependencies against pinned bodies; module paths relocated; unused imports pruned; three notation declarations scoped")

if __name__ == "__main__":
    main()
