# Domains and trust report

## Proof checking

`python3 scripts/check_axioms.py` invokes Lean on `Audit.lean`, inspects 39
theorem roots, and fails if any root uses an axiom outside:

```text
propext
Classical.choice
Quot.sound
```

The current audit passes. See the verbatim [axiom output](axioms.txt). Some roots
use a subset of these standard Lean axioms. There is no project axiom, `sorry`,
disabled kernel check, compiled reflection axiom, native-decide proof, external
solver, or hardware axiom closing a theorem. Concrete regressions use
`decide +kernel`; generic proofs use induction, ordinary lemmas, `omega`, and
`grind`. Lean's kernel checks the resulting terms. Normal executable runs and
Python tests are tests, not additional logical assumptions or proofs.

## Mathematical domains

- `rawProduct_value` covers arbitrary signed integer significands and integer
  scales. Format correctness is a decoder specification, not its hypothesis.
- Alignment uses a positive quantum `2^e`. Its signed residual bound is proved
  for every rational term and integer e.
- Accumulation is over arbitrary-precision `Int`; no-wrap is true of that
  reference representation. It is not a theorem about a fixed-width register.
- `block_residual_identity` is algebraic recovery for any supplied rational d.
  It needs no device or model-output assumption.
- `evalV100_residual_identity` connects that identity to a successful encoded
  input evaluation. Success enforces four products, finite inputs and a
  finite-range accumulator. `Finite32.valid` connects output bits to their
  decoded values; special encodings are never silently treated as real zero.
- `runV100_residual_ledger` covers all successful finite lists of invocations.
  Contributions are the exact operand products of the returned block traces;
  `evalV100_prepared` links every trace to its input preparation. The next c
  is decoded from actual returned bits. Every local residual is retained exactly.
  This is a fixed-input dot-product schedule theorem, not arbitrary adaptive
  operand generation, GEMM scheduling, or GPU kernel correctness.
- `corrected_eq_round_exactDot` substitutes the proved recovered value into
  an executable conversion function. It does not prove that conversion selects
  the nearest value over every finite input. Concrete cases are checked.
- Output conversion and final RNE reject magnitudes above `maxFinite32`.
  General error and rounding theorems must retain these range conditions.

## Hardware and open obligations

The V100 profile is an explicit interpretation of Accurate Models v4 and v0.5
source. Their empirical model/device correspondence is outside these Lean
proofs. No GPU was used by this project. The 5,000 V100 FP16/FP32 vectors
published with v0.5 match the evaluator bitwise (`scripts/check_device.py`);
that is test evidence for the normal-operand path of one profile, not a
theorem, and it does not cover zero or subnormal operands or c. The paper's
historical 100-case V100 experiment is not new evidence for this
implementation. Its reconstructed cancellation witness is labeled accordingly
in the regression data.

Still unproved: universal decoder/encoder round trips, mathematical correctness
of FP32 conversion, output residual/error bounds, a machine-width accumulator
refinement, a scalar representability/consolidation theorem, a residual expansion
interface, and optimized overlap extraction. These obligations are listed in
the status and theorem map; there are no fake theorem stubs for them.
