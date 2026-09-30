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

The independent TC specification uses separate mathematical definitions.
They share standard-library arithmetic and the notation syntax, but their compiled
mathematical dependencies cannot use implementation declarations. The specification
audit checks this boundary, including dependencies inside propositions and proofs.

## Documentation

Keep the guide, executable-test walkthrough, and theorem index current. Link directly
to Lean declarations instead of copying complete proof bodies into Markdown.

Run `python3 scripts/check_docs.py` to check maintained local links and elaborate every
Lean code block in the README, guide, test walkthrough, and theorem index. Keep those
blocks standalone so a reader can copy one into a file and check it directly.
