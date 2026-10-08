#!/usr/bin/env python3
"""Verify pinned Lean code and copy current sources into the compatibility project."""
from pathlib import Path
import hashlib, json, re

PORT = Path(__file__).resolve().parents[1]
REPO = PORT.parent
PIN = "990afac10b94a84f3de24743206756dd7acc3276"
REFERENCE = PORT / "reference-manifest.json"
REFERENCE_SHA256 = "0788366fb0dd3a6d1886d6abcb15005a82e4aa6c78bd234ee8ee9d2e91560548"
OUT = PORT / "reference-compat"

def lean_tokens(source):
    """Preserve code tokens and string literals; ignore whitespace and nested comments."""
    tokens = []
    i = 0
    while i < len(source):
        if source[i].isspace():
            i += 1
        elif source.startswith('--', i):
            end = source.find('\n', i)
            i = len(source) if end < 0 else end
        elif source.startswith('/-', i):
            depth = 1
            i += 2
            while depth and i < len(source):
                if source.startswith('/-', i):
                    depth += 1
                    i += 2
                elif source.startswith('-/', i):
                    depth -= 1
                    i += 2
                else:
                    i += 1
            if depth:
                raise ValueError('Unclosed Lean comment')
        elif source[i] == '"':
            start = i
            i += 1
            while i < len(source):
                if source[i] == '\\':
                    i += 2
                elif source[i] == '"':
                    i += 1
                    break
                else:
                    i += 1
            tokens.append(source[start:i])
        elif source[i].isalnum() or source[i] == '_':
            start = i
            i += 1
            while i < len(source) and (source[i].isalnum() or source[i] in "_'"):
                i += 1
            tokens.append(source[start:i])
        else:
            tokens.append(source[i])
            i += 1
    return tokens

def imports(data):
    return [module for line in re.findall(r'^import ([^\n]+)', data, re.M)
            for module in line.split() if module.startswith('TensorCore.')]

# Descriptive declaration names adopted after the pinned revision. Token comparison maps
# each current identifier back to its pinned spelling, so a passing check also shows the
# parent sources differ from the pin only by these renames.
RENAMED_TOKENS = {
    'IndependentSpec': 'PaperSpec',
    'evalBlock_eq_spec': 'implementation_eq_paper',
    'supported_eq_spec': 'supported_eq_paper',
    'tf32_eq_spec': 'tf32_eq_paper',
    'invocation_eq_spec': 'invocation_eq_paper',
    'machine_eq_spec': 'machine_eq_paper',
    'runBlocks_eq_spec': 'runBlocks_eq_paper',
    'schedule_last_eq_spec': 'schedule_last_eq_paper',
    'inputBudget_coefficient_bound': 'eq20_coefficients',
    'inputBudget_lowParts_sum_exact': 'eq20_exact_sum',
    'inputBudget_scalarPredicate': 'eq20_scalarPredicate',
}
RENAMED_SUBSTRINGS = [('scalarTcEft', 'tceft'), ('TcEft', 'Algorithm1'), ('tcEft', 'algorithm1')]


def legacy_token(token):
    if token.startswith('"'):
        return token
    if token in RENAMED_TOKENS:
        return RENAMED_TOKENS[token]
    for current, original in RENAMED_SUBSTRINGS:
        token = token.replace(current, original)
    return token


def legacy_module(module):
    """Resolve a parent module to its pinned reference-manifest key."""
    exact = {
        'TensorCore.EFT.TcEft': 'TensorCore.EFT.Algorithm1',
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


def body_hash(lines):
    body = b''.join(line for line in lines if not line.startswith(b'import ')).decode()
    tokens = json.dumps([legacy_token(t) for t in lean_tokens(body)], ensure_ascii=False, separators=(',', ':')).encode()
    return hashlib.sha256(tokens).hexdigest()


def main():
    reference_data = REFERENCE.read_bytes()
    if hashlib.sha256(reference_data).hexdigest() != REFERENCE_SHA256:
        raise RuntimeError('Pinned reference manifest checksum mismatch')
    reference = json.loads(reference_data)
    if reference['format'] != 1 or reference['revision'] != PIN:
        raise RuntimeError('Unexpected pinned reference manifest version or revision')
    pending = [module for p in (PORT/'TCFloat/Equivalence').glob('*.lean')
               for module in imports(p.read_text())]
    verified = {}
    pruned_imports = {}
    origins = {}
    sources = {}
    while pending:
        module = pending.pop()
        name = module.replace('.', '/') + '.lean'
        if name in verified:
            continue
        origin = legacy_module(module).replace('.', '/') + '.lean'
        origins[name] = origin
        if origin not in reference['files']:
            raise RuntimeError(f'Unpinned original dependency: {name}')
        pinned = reference['files'][origin]
        data = (REPO / name).read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        if digest != pinned['source_sha256']:
            current_lines = [legacy_import(line) for line in data.splitlines(keepends=True)]
            if body_hash(current_lines) != pinned['body_tokens_sha256']:
                raise RuntimeError(f"Original arithmetic/proof source differs from pinned revision: {name}")
            old = pinned['imports']
            new = [line.decode() for line in current_lines if line.startswith(b'import ')]
            remaining = iter(old)
            if not all(any(line == candidate for candidate in remaining) for line in new):
                raise RuntimeError(f"Original imports are not a subset of pinned imports: {name}")
            pruned_imports[name] = [line.strip() for line in old if line not in new]
        verified[name] = digest
        sources[name] = data
        pending.extend(imports(data.decode()))

    for name, data in sources.items():
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
        'reference_manifest_sha256':REFERENCE_SHA256,
        'comparison':'exact non-import code tokens and string literals; comments and whitespace ignored',
        'notation_shim':'three declarations renamed and scoped; same expansions',
        'removed_unused_imports':dict(sorted(pruned_imports.items())),
        'source_origin':dict(sorted(origins.items())),
        'source_sha256':dict(sorted(verified.items()))},indent=2)+'\n')
    print(f"Verified {len(verified)} parent dependencies against the reference manifest; compatibility sources prepared with scoped Nat/Int/Rat notation")

if __name__ == "__main__":
    main()
