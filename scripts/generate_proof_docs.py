#!/usr/bin/env python3
"""Generate the README proof guide from Lean's compiled dependency graph.

Run with --check to reject stale documentation without replacing it. Generated
auxiliary declarations are folded into their source declaration for browsing;
dependencies.json retains every compiled node and its direct edges.
"""
from collections import defaultdict
from pathlib import Path
import argparse
import hashlib
import html
import json
import os
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BEGIN = '<!-- BEGIN GENERATED PROOF GUIDE -->'
END = '<!-- END GENERATED PROOF GUIDE -->'
DECL = re.compile(r'\b(?:theorem|lemma|def|abbrev|structure|inductive|class|instance)\s+$')


def relative(path, document):
    return Path(os.path.relpath(path, document.parent)).as_posix()


def anchor(name):
    return 'decl-' + hashlib.sha256(name.encode()).hexdigest()[:16]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    for command in [['lake', 'build', 'TensorCore'],
                    ['lake', 'env', 'lean', 'scripts/lean/ProofGraph.lean']]:
        proc = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
        if proc.returncode:
            raise SystemExit(proc.stdout + proc.stderr)
    entries = json.loads((ROOT / 'tmp/proof-dependencies.json').read_text())
    raw = {entry['name']: entry for entry in entries}
    lines = {}
    nodes = {}
    for name, entry in raw.items():
        if 'selection' not in entry or 'range' not in entry:
            continue
        path = ROOT / (entry['module'].replace('.', '/') + '.lean')
        if not path.is_file():
            continue
        source = lines.setdefault(path, path.read_text().splitlines())
        row, col = entry['selection']['start']
        endrow, endcol = entry['selection']['end']
        if row != endrow or row > len(source):
            continue
        selected = source[row - 1][col:endcol]
        before = source[row - 1][:col]
        if not selected or not name.endswith('.' + selected) or not DECL.search(before):
            continue
        first, left = entry['range']['start']
        last, right = entry['range']['end']
        text = '\n'.join(source[first - 1:last])
        if first == last:
            text = source[first - 1][left:right]
        else:
            text = '\n'.join([source[first - 1][left:], *source[first:last - 1], source[last - 1][:right]])
        nodes[name] = {**entry, 'source': text.strip(), 'path': path, 'line': row,
                       'display': re.sub(r'^_private\..*?\.\d+\.', '', name)}

    # A source declaration owns its projections, recursors, equations, and proof helpers.
    def owner(name):
        current = name
        while current:
            if current in nodes:
                return current
            current = current.rpartition('.')[0]
        return None

    owners = {name: owner(name) for name in raw}
    by_range = {(entry['module'], tuple(entry['range']['start']), tuple(entry['range']['end'])): name
                for name, entry in nodes.items()}
    for name, entry in raw.items():
        if owners[name] is None and 'range' in entry:
            owners[name] = by_range.get((entry['module'], tuple(entry['range']['start']), tuple(entry['range']['end'])))

    def visible(dependency, seen):
        if dependency in seen:
            return set()
        seen.add(dependency)
        if dependency not in raw:
            return set()
        if owners[dependency]:
            return {owners[dependency]}
        result = set()
        for child in raw[dependency]['dependencies']:
            result.update(visible(child, seen))
        return result

    edges = {name: set() for name in nodes}
    external = {name: set() for name in nodes}
    for name, entry in raw.items():
        parent = owners[name]
        if parent is None:
            continue
        for dependency in entry['dependencies']:
            edges[parent].update(visible(dependency, set()))
            if dependency not in raw:
                external[parent].add(dependency)
    for name in nodes:
        edges[name].discard(name)
    reverse = defaultdict(set)
    for name, deps in edges.items():
        for dep in deps:
            reverse[dep].add(name)

    def page(name):
        return ROOT / 'docs/proofs' / (nodes[name]['module'].removeprefix('TensorCore.').replace('.', '/') + '.md')

    def link(name, document, label=None):
        return f'[{label or nodes[name]["display"]}]({relative(page(name), document)}#{anchor(name)})'

    def code(name):
        return '```lean\n' + nodes[name]['source'] + '\n```\n'

    def source_link(name, document):
        entry = nodes[name]
        return f'[Lean source]({relative(entry["path"], document)}#L{entry["line"]})'

    def dependency_list(name, document, theorem):
        deps = sorted(dep for dep in edges[name] if nodes[dep]['theorem'] == theorem)
        return ', '.join(link(dep, document) for dep in deps) or 'None in this repository.'

    output = {}
    modules = defaultdict(list)
    for name, entry in nodes.items():
        modules[entry['module']].append(name)
    index = ROOT / 'docs/proofs/README.md'
    total_proofs = sum(entry['theorem'] for entry in nodes.values())
    text = ['# Proof dependency index\n',
            'This index is generated from checked Lean declaration types and bodies. '
            'Each declaration expands to its exact source, supporting proofs, definitions, '
            'and declarations that use it. Follow those links to traverse the graph.\n',
            f'{len(nodes)} source declarations, including {total_proofs} theorems, in {len(modules)} modules. '
            f'The [complete graph](dependencies.json) retains all {len(raw)} compiled declarations, '
            'including generated equations, recursors, auxiliary proofs, and direct standard-library dependencies.\n',
            'The browsable graph groups compiler-generated helpers with their source declaration. '
            'Its edges include dependencies in types as well as bodies; an edge is not a claim that every '
            'assumption or field is used at runtime. Standard-library declarations are boundary nodes in the JSON.\n',
            '[Main results](../../README.md#proof-guide) · [Trust and style](../style.md)\n',
            '| Module | Theorems | Definitions |\n| --- | ---: | ---: |']
    for module, names in sorted(modules.items()):
        path = page(names[0])
        proofs = sum(nodes[name]['theorem'] for name in names)
        text.append(f'| [{module}]({relative(path, index)}) | {proofs} | {len(names) - proofs} |')
        doc = [f'# {module}\n', '[Index](' + relative(index, path) + ')\n',
               'Expand a declaration to read its Lean code, then follow the links to its dependencies.\n']
        for name in sorted(names, key=lambda name: (nodes[name]['line'], name)):
            entry = nodes[name]
            doc += [f'<a id="{anchor(name)}"></a>\n',
                    f'<details>\n<summary><code>{html.escape(entry["display"])}</code></summary>\n',
                    source_link(name, path) + '\n', code(name),
                    '**Supporting proofs:** ' + dependency_list(name, path, True) + '\n',
                    '**Definitions and types:** ' + dependency_list(name, path, False) + '\n']
            if entry['theorem']:
                doc.append('**Transitive Lean axioms:** ' + (', '.join('`' + a + '`' for a in entry.get('axioms', [])) or 'none') + '.\n')
            users = sorted(reverse[name])
            doc.append('<details>\n<summary>Used by</summary>\n\n' + (', '.join(link(user, path) for user in users) or 'No other source declaration in this graph.') + '\n\n</details>\n')
            doc.append('</details>\n')
        output[path] = '\n'.join(doc)
    output[index] = '\n'.join(text) + '\n'
    graph = {'format_version': 1, 'toolchain': (ROOT / 'lean-toolchain').read_text().strip(),
             'source_sha256': {str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
                               for path in sorted((ROOT / 'TensorCore').rglob('*.lean'))},
             'compiled_declarations': entries,
             'source_declarations': {name: {'module': entry['module'], 'line': entry['line'],
                                           'dependencies': sorted(edges[name])}
                                     for name, entry in sorted(nodes.items())}}
    output[ROOT / 'docs/proofs/dependencies.json'] = json.dumps(graph, ensure_ascii=False, separators=(',', ':')) + '\n'

    # Keep the existing scope statements as the checklist for all high-level claims.
    reference = ROOT / 'docs/reference.md'
    manual = reference.read_text()
    claims = []
    for line in manual.splitlines():
        if not re.match(r'^\| C\d+\.', line):
            continue
        _, title, scope, declarations, _ = line.split('|')
        names = re.findall(r'\[`(TensorCore\.[\w.]+)`\]', declarations)
        for name in names:
            assert name in nodes, ('undocumented public claim', name)
        claims.append((title.strip(), scope.strip(), names))
    # Refresh claim links using Lean's declaration locations, including moved definitions.
    def claim_link(match):
        name = match[1]
        if name not in nodes:
            return match[0]
        return f'[`{name}`]({relative(nodes[name]["path"], reference)})'
    manual = re.sub(r'\[`(TensorCore\.[\w.]+)`\]\([^)]+\)', claim_link, manual)
    output[reference] = manual

    readme = ROOT / 'README.md'
    guide = [BEGIN, '## Proof guide\n',
             'Expand a claim to read its Lean code. Within each declaration, expand the supporting proofs '
             'and follow their links to continue through the dependency graph. The code is copied from '
             'the checked source, including proof bodies.\n',
             f'The [complete proof index](docs/proofs/README.md) covers **{total_proofs} source theorems** and '
             f'**{len(nodes) - total_proofs} definitions**. The [machine-readable graph](docs/proofs/dependencies.json) '
             'also retains generated proofs and standard-library edges. Regenerate with '
             '`python3 scripts/generate_proof_docs.py`; `--check` verifies that this guide is current.\n',
             '```mermaid\nflowchart TD\n  TC[Tensor-core contracts] --> C[Core arithmetic and rounding]\n'
             '  EFT[TC-EFT correctness] --> TC\n  EFT --> C\n  E[Bounded EFT execution] --> EFT\n'
             '  E --> I[IEEE and Lean scalar refinement]\n  I --> C\n  G[GEMM certificates] --> TC\n'
             '  G --> C\n  TC --> S[Independent TC specification]\n'
             '  G --> M[Independent matrix specification]\n```\n',
             '### Entry points\n']

    def render(name, graph=False):
        entry = nodes[name]
        doc = [f'<details>\n<summary><code>{html.escape(entry["display"])}</code></summary>\n',
               source_link(name, readme) + ' · ' + link(name, readme, 'Full dependency node') + '\n', code(name)]
        proofs = sorted(dep for dep in edges[name] if nodes[dep]['theorem'])
        if graph and proofs:
            # This is a proof graph, not an import graph; node links open further proof nodes.
            mermaid = ['```mermaid', 'flowchart TD', f'  root["{entry["display"].removeprefix("TensorCore.")}"]']
            for i, dep in enumerate(proofs):
                mermaid += [f'  p{i}["{nodes[dep]["display"].removeprefix("TensorCore.")}"]', f'  root --> p{i}']
            doc.append('\n'.join(mermaid) + '\n```\n')
        doc.append('<details>\n<summary>Supporting proofs</summary>\n')
        for dep in proofs:
            doc += [f'<details>\n<summary><code>{html.escape(nodes[dep]["display"])}</code></summary>\n',
                    link(dep, readme, 'Expand this proof and its dependencies') + '\n']
            # Show the premise-bearing statement in the README; the node page contains
            # the entire supporting proof, keeping GitHub's README below its render limit.
            statement = nodes[dep]['source'].split(':=', 1)[0].rstrip()
            doc += ['```lean\n' + statement + '\n```\n', '</details>\n']
        if not proofs:
            doc.append('No supporting source theorem in this repository.\n')
        doc += ['</details>\n', '<details>\n<summary>Definitions and types</summary>\n',
                dependency_list(name, readme, False) + '\n', '</details>\n', '</details>\n']
        return '\n'.join(doc)

    for name in ['TensorCore.Format', 'TensorCore.BinaryRep', 'TensorCore.BinaryRep.value',
                 'TensorCore.finiteBinaryBijection', 'TensorCore.decode_encodeBinaryRep',
                 'TensorCore.encode_decodeBinaryRep', 'TensorCore.SignedFiniteValue',
                 'TensorCore.signedFiniteBinaryBijection', 'TensorCore.Profile', 'TensorCore.BlockInput', 'TensorCore.evalBlock',
                 'TensorCore.algorithm1Encoded', 'TensorCore.EFMachine.algorithm1WithLean']:
        guide.append(render(name))
    categories = [('Tensor-core model', ['C04', 'C05', 'C08', 'C03']),
                  ('TC-EFT', ['C06', 'C07', 'C21']),
                  ('Core arithmetic', ['C01', 'C02']),
                  ('GEMM', [f'C{i:02}' for i in range(9, 17)]),
                  ('IEEE scalar refinement', [f'C{i:02}' for i in range(17, 21)])]
    graphed = {'TensorCore.profile_contract', 'TensorCore.EFMachine.algorithm1WithLean_correct',
               'TensorCore.roundBinary_correct', 'TensorCore.gemmAnalysisCheck_sound'}
    for title, keys in categories:
        guide.append('### ' + title + '\n')
        for title, scope, names in claims:
            if title[:3] not in keys:
                continue
            guide += ['<details>\n<summary>' + html.escape(title) + '</summary>\n', scope + '\n']
            guide.extend(render(name, name in graphed) for name in names)
            guide.append('</details>\n')
    guide.append(END)
    readme_text = readme.read_text()
    assert BEGIN in readme_text and END in readme_text
    before, tail = readme_text.split(BEGIN, 1)
    _, after = tail.split(END, 1)
    output[readme] = before + '\n'.join(guide) + after
    assert len(output[readme].encode()) < 500_000, 'README exceeds the GitHub rendering budget'

    stale = []
    for path, content in output.items():
        if not path.exists() or path.read_text() != content:
            stale.append(str(path.relative_to(ROOT)))
            if not args.check:
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(content)
    if args.check and stale:
        raise SystemExit('Stale proof documentation: ' + ', '.join(stale))
    print(json.dumps({'status': 'passed', 'source_theorems': total_proofs,
                      'source_declarations': len(nodes), 'compiled_declarations': len(raw),
                      'modules': len(modules), 'high_level_claims': len(claims),
                      'readme_bytes': len(output[readme].encode()), 'checked': args.check}, indent=2))


if __name__ == '__main__':
    main()
