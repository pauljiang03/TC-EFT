# Style and foundations

The organization follows FloatLib's numerical/kernel separation and worked-guide style,
with subject directories, small public import modules, explicit mathematical hypotheses,
and properties beside the definitions they concern. Regression modules have a separate
source root under `tests/`.
This project keeps its standard-library arithmetic and existing public declaration names.

- Put reusable arithmetic, representations, encoding, rounding, and inverse laws in `Numerics`.
- Put tensor-core assumptions in explicit `Profile` or `InvocationSpec` fields and theorem premises.
- Put extraction and consolidation in `EFT`. Keep TC model properties and non-monotonicity in `TC`.
- Define representations before their operations. Keep a definition and its elementary properties together;
  split substantial correctness, bijection, and round-trip developments into named files.
- Use `ℕ`, `ℤ`, and `ℚ` for mathematical types, with `Nat`, `Int`, and `Rat` in qualified library names.
  The notation in `Numerics/Notation.lean` introduces syntax only. Use `BitVec` for encoded words.
- Use a short module introduction and declaration comments that explain a definition, its hypotheses,
  or its relationship to a numbered paper result. Explain proof steps when they add mathematical context.
- Use two-space indentation and descriptive theorem names. Preserve public namespaces during file moves.
  Import the module that owns a result, without obtaining basic lemmas through unrelated applications.
- Keep regression witnesses out of subject aggregate imports. `TensorCoreTests` and the default Lake build
  include all maintained regression modules; `scripts/check_layout.py` enforces their boundaries and audit coverage.

## Trusted foundation

The project introduces no additional arithmetic postulates. Its basic types and
operations come from Lean's standard library; correctness results are proved in Lean.
The axiom audit permits only `propext`, `Classical.choice`, and `Quot.sound` and checks
every compiled public theorem in the full development. Foundational definitions and
building blocks belong to `Numerics`; application assumptions are explicit arguments,
not global axioms. See [`axioms.txt`](axioms.txt) for the generated dependency audit.

The independent TC specification use separate mathematical definitions.
They share standard-library arithmetic and the notation syntax, but their compiled
mathematical dependencies cannot use implementation declarations. The specification
audit checks this boundary, including dependencies inside propositions and proofs.

## Generated proof guide

Run `python3 scripts/generate_proof_docs.py` after changing declarations. The tool
reads Lean's compiled types, proof bodies, and declaration ranges. It generates the
detailed proof guide and per-module proof pages, preserving exact source text. Run
`python3 scripts/generate_proof_docs.py --check` to detect stale output; this check is
part of the full regression suite.

The readable graph groups generated equations and proof helpers with their owning
source declaration. `proofs/dependencies.json` preserves the uncollapsed graph,
including standard-library dependencies and the transitive axiom set of every theorem.

Run `python3 scripts/check_docs.py` to check maintained local links and elaborate every
Lean code block in the README, guide, test walkthrough, and theorem index. Keep those
blocks standalone so a reader can copy one into a file and check it directly.
