#!/usr/bin/env python3
"""Build the actual pinned paper dependencies in an isolated compatibility directory.

Arithmetic and proofs are copied verbatim after comparison to Git. Only the three
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

def main():
    pending = [module for p in (PORT/'TCFloat/Equivalence').glob('*.lean')
               for module in imports(p.read_text())]
    verified = {}
    while pending:
        module = pending.pop()
        name = module.replace('.', '/') + '.lean'
        if name in verified:
            continue
        data = subprocess.check_output(["git", "show", f"{PIN}:{name}"], cwd=REPO)
        if (REPO / name).read_bytes() != data:
            raise RuntimeError(f"Original source differs from pinned revision: {name}")
        verified[name] = hashlib.sha256(data).hexdigest()
        pending.extend(imports(data.decode()))
        if name == "TensorCore/Core/Notation.lean":
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
        'source_sha256':dict(sorted(verified.items()))},indent=2)+'\n')
    print(f"Verified {len(verified)} pinned paper dependencies; only three notation declarations scoped")

if __name__ == "__main__":
    main()
