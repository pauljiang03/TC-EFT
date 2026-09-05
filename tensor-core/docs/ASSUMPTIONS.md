# Domains and trust report

## Proof checking

`python3 scripts/check_axioms.py` invokes Lean on `Audit.lean`, inspects 83
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

The custom elaborator constructs ordinary `Program` terms. `tc_verify` applies
`Program.vc_sound` to a kernel-checked condition proof, or to an explicitly
supplied Lean proof of the same conditions. Generated regression theorems are
included in the audit. `tc_inspect` uses executable evaluation for diagnostics;
those computations are not used as unchecked proof certificates. Syntax/order
regressions check the intended elaboration separately from theorem validity.

## Mathematical domains

- `rawProduct_value` covers arbitrary signed integer significands and integer
  scales. Format correctness is a decoder specification, not its hypothesis.
- Alignment uses a positive quantum `2^e`. Its signed residual bound is proved
  for every rational term and integer e.
- Accumulation is over arbitrary-precision `Int`; no-wrap is true of that
  reference representation. It is not a theorem about a fixed-width register.
- `block_residual_identity` is algebraic recovery for any supplied rational d.
  It needs no device or model-output assumption.
- `evalBlock_residual_identity` connects that identity to a successful encoded
  input evaluation. Success enforces the profile's product count, finite inputs
  and a finite-range accumulator. `Finite32.valid` connects output bits to their
  decoded values; special encodings are never silently treated as real zero.
- `runBlocks_residual_ledger` covers all successful finite lists of invocations.
  Contributions are the exact operand products of the returned block traces;
  `evalBlock_prepared` links every trace to its input preparation. The next c
  is decoded from actual returned bits. Every local residual is retained exactly.
  This is a fixed-input dot-product schedule theorem, not arbitrary adaptive
  operand generation, GEMM scheduling, or GPU kernel correctness.
- `FiniteValue32` is an arithmetic coefficient/exponent specification independent
  of the converter. `value32_finite` proves it includes every finite decoded
  FP32 value. `encode32_value` proves the converter's bounded construction
  decodes to its intended value and preserves coefficient parity.
- `round32_nearestEven_correct` proves finite output existence, nearest-value
  selection, and even encoding parity on ties for every rational input in range.
  `NearestEven32` compares numerical values; it does not distinguish the two
  zero encodings. Signed-zero policy is explicit in the executable converter.
- `corrected_eq_round_exactDot` remains a substitution lemma.
  `evalBlock_corrected_correct` and `runBlocks_corrected_correct` now combine
  recovery with mathematical rounding correctness. Schedule contributions are
  exact products from prepared traces, not an independently verified GEMM map.
- `output_residual_bound` and `evalBlock_error_bound` prove strict output-loss
  and two-stage model-error bounds. The latter counts all terms, including c.
- Output conversion and final RNE reject magnitudes above `maxFinite32`.
  The rounding theorem assumes this bound for the final exact sum; successful
  intermediate block evaluation only establishes it for that block's retained
  accumulator. Neither premise implies the other in general.
- Generic profiles parameterize input format, group size, alignment fraction,
  and floor. Generic algebraic theorems do not establish the hardware meaning
  of arbitrary parameter choices. Only V100 FP16/FP32 is instantiated.
- `Program.recovery` connects the compiled invocation list to `Program.ideal`,
  which independently decodes the original program operand bits. The DSL's
  `Program.Correct` theorem states success, recovery, and nearest-even correction
  of this ideal. It still assumes the fixed-input program fragment; there is no
  implicit extension to adaptive operands or matrix layouts.
- `Program.vc_sound` proves the sufficient conditions imply the program contract.
  The current checker executes finite schedules; it is not a general symbolic
  range/VC engine. `Program.repeat_vc_of_cycle` supplies one symbolic induction
  rule with explicit state, zero-ledger, and range premises.
- Locations are diagnostic metadata. `runLocated_erases` proves removing them
  preserves success and failure semantics; `Program.report_accepts_iff` proves
  report success coincides with the checked conditions.

## Hardware and open obligations

One invocation means one dot product with unnormalized products and a block
accumulation. `runBlocks` composes such groups in the supplied list order;
neither it nor `Program.Correct` discovers the order inside an actual GPU
instruction. Its correction ledger uses exact rational addition. The revised
paper's scalar FP EFT algorithm and a finite-precision multi-group ledger are
not established by these schedule theorems. See [CURRENT_PLAN.md](CURRENT_PLAN.md)
for the general invocation-first scope and later implementation gates.

The V100 profile is an explicit interpretation of Accurate Models v4 and v0.5
source. Their empirical model/device correspondence is outside these Lean
proofs. No GPU was used by this project. The 5,000 V100 FP16/FP32 vectors
published with v0.5 match the evaluator bitwise (`scripts/check_device.py`);
that is test evidence for the normal-operand path of one profile, not a
theorem, and it does not cover zero or subnormal operands or c. The paper's
historical 100-case V100 experiment is not new evidence for this
implementation. Its reconstructed cancellation witness is labeled accordingly
in the regression data.

Still unproved: universal bit-for-bit decoder/encoder round trips, a machine-width
accumulator refinement, a scalar representability/consolidation theorem, a
residual expansion interface, and optimized overlap extraction. The current
encoding lemmas cover the construction used by the rounding proof, not a full
round-trip API. These obligations are listed in
the status and theorem map; there are no fake theorem stubs for them.
