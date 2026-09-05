# Roadmap

Status as of 5 September 2026.

## Done

- V100 FP16 → FP32 executable model with exact traces. R1–R4, rounding boundaries, zero and
  subnormal branches, rejection cases, a non-monotonicity witness, and a two-block
  cancellation example are kernel-checked.
- Raw-product, alignment, accumulation, and output bridges; the stage residual identity; the
  two-stage error bound `abs(S − D) < n·qA + qD`.
- Nearest-even FP32 conversion proved correct for every rational in the finite range;
  corrected block and schedule results.
- Exact residual ledger over any finite chain of invocations through encoded FP32
  boundaries; sequential composition; a symbolic-count cycle invariant.
- Typed program AST, `tc%{ }` syntax, `tc_verify`, `tc_inspect`, with soundness
  (`Program.vc_sound`) and diagnostic-agreement theorems.
- Independent Python oracle, published V100 device vectors, frontend rejection tests, and a
  standard-axiom audit of 83 theorem roots.

## Next: the canonical FP16 → FP32 invocation, parameterized

The unit stays one dot product with unnormalized products and one block accumulation, with
FP32 c in the common alignment and one FP32 truncation at the output. The parameters are the
product count `K` and the extra alignment bits beyond the 23 baseline fraction bits, plus an
optional exponent floor. This covers V100 (`K = 4`, 0 extra bits), Ampere and Ada (`K = 8`,
1 extra bit), and Hopper and Blackwell (`K = 16`, 2 extra bits) FP16 paths.

1. Contract. Decoded-input correspondence, raw metadata, maximum and all-zero handling, the
   actual FP32 output, the two-stage error bound, signed accumulator capacity, and safe
   prefixes, all quantified over `K` and the extra bits. V100 bits and rejection behavior are
   recovered by a proved equivalence with `evalBlock`.
2. Instances and evidence. Instantiate the three families and validate them with an
   independent exact oracle, non-hardware `K`/extra-bit values, boundary and cancellation
   cases, and the existing V100 vectors. Record that no device comparison exists for the
   other architectures.
3. Properties. Floor irrelevance for the FP16 paths, all-zero behavior, and the
   representability interfaces consumers need. Do not claim that more bits always improve the
   output or that regrouping preserves it; keep counterexamples.
4. Close the gate when contract and evidence are complete at their stated scope.

Modules for this gate exist in a development tree but are not yet imported by the library
root or covered by the audit, so they are not in this repository.

Deferred: BF16, TF32, FP8, FP16 output, FP64 FMA, input conversion and flush policies, and
late-c paths. The source inventory in [FEATURE_COVERAGE.md](FEATURE_COVERAGE.md) and the
full interface in [INVOCATION_CONTRACT.md](INVOCATION_CONTRACT.md) remain the reference for
that later work; the reconciliation register there must be settled before any of those paths
is assigned to hardware.

## Separate application: invocation-local EFT

Formalize TC-EFT §IV on top of the invocation contract: coarse components on
`qE = max(qA, qD)`, the overlap identity `ε_o = D − H`, the exact-summation predicate
(IV.8–IV.9), overlap-subtraction representability (IV.10), one final rounding (IV.11), and
Algorithm 1's scalar branch with the exact-dyadic fallback. The scalar branch must be proved
on actual FP32 additions, one `round32 .nearestEven` per step. FP64 consolidation followed by
FP32 conversion can double-round and needs its own proof. Use R2 (nonzero overlap, zero total
residual) and R3 (nonzero correction) as the first checks.

## Later: composition and programs

See [COMPOSITION.md](COMPOSITION.md) for the source findings and the modeling proposal.

- Schedules with explicit boundary operators (encoded conversion, unnormalized combination,
  scalar addition) and a generic ledger theorem over them.
- Uncorrected error accumulation from local bounds; equivalence conditions for reordered
  schedules; counterexamples where ordering changes bits.
- Scalar state, conversions, data-dependent operands, and changing-state loop invariants in
  `Program`, with verification conditions before new syntax.
- One pinned instruction path: opcode, shape, layouts, fragment mapping, group partition and
  order, and every conversion, with a refinement theorem to the mapped schedule and an
  explicit conformance premise instead of an axiom.
- One mapped application (a tile or long dot product) and one justified transformation.

## Known issues

1. `tc_verify` rolls back whenever the file already contains any earlier error, because it
   inspects the whole message log. One unrelated error therefore hides every later
   verification. Compare message counts before and after elaboration instead.
2. `round32` rejects magnitudes in `(maxFinite32, 2^128)` under round-toward-zero, where IEEE
   truncation and the MATLAB model both return `maxFinite32`. Either keep the guard as a
   documented restriction or prove the truncation case.
3. `check_axioms.py` scans only `TensorCore/` for placeholders and audits a hand-maintained
   list in `Audit.lean`. Extend the scan to `examples/`, `Main.lean`, and `Audit.lean`, and
   generate the root list from the environment.
4. The FP16-output device vectors (`d_V100_fp16.txt`) are vendored but unused. Implementing
   the FP16 output stage should compare against them and settle the stage-order question.
5. The device comparison covers no zero or subnormal operands or c. Those branches follow
   the MATLAB source and need targeted vectors.
