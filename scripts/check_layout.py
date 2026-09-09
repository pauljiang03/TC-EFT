#!/usr/bin/env python3
"""Check module ownership and the boundaries of the foundational imports."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]


def main():
    modules = {'.'.join(p.relative_to(ROOT).with_suffix('').parts): p
               for p in (ROOT / 'TensorCore').rglob('*.lean')}
    modules['TensorCore'] = ROOT / 'TensorCore.lean'
    imports = {name: re.findall(r'^import (TensorCore(?:\.[\w]+)*)$', path.read_text(), re.M)
               for name, path in modules.items()}
    for name, deps in imports.items():
        for dep in deps:
            assert dep in modules, (name, 'missing import', dep)
        parts = name.split('.')
        if 'Regression' in parts or 'Tests' in parts:
            continue
        if name.startswith('TensorCore.Core.'):
            assert all(dep.startswith('TensorCore.Core.') for dep in deps), (name, deps)
        if name.startswith('TensorCore.TC.'):
            assert not any(dep.startswith(('TensorCore.EFT', 'TensorCore.Gemm')) for dep in deps), (name, deps)
        if name.startswith('TensorCore.EFT.'):
            assert not any(dep.startswith('TensorCore.Gemm') for dep in deps), (name, deps)

    def closure(name, seen=None):
        seen = set() if seen is None else seen
        if name in seen:
            return seen
        seen.add(name)
        for dep in imports[name]:
            closure(dep, seen)
        return seen

    public = closure('TensorCore')
    assert not any('.Gemm' in name or '.Regression' in name or '.Tests' in name for name in public)
    complete = closure('TensorCore.All')
    assert set(modules) <= complete, ('modules omitted from full audit', sorted(set(modules) - complete))
    assert not (ROOT / 'tensor-core').exists(), 'Nested Lake project remains'
    assert (ROOT / 'lakefile.toml').is_file() and (ROOT / 'lean-toolchain').is_file()
    print(json.dumps({'status': 'passed', 'modules': len(modules),
                      'core_has_no_application_dependencies': True,
                      'tc_has_no_eft_or_gemm_dependencies': True,
                      'eft_has_no_gemm_dependencies': True,
                      'full_import_covers_every_module': True}, indent=2))


if __name__ == '__main__':
    main()
