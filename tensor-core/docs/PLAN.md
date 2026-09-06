# Plan

Written after the 5 September 2026 review and updated the same day as the canonical gate,
the long-dot-product slice, the scalar EFT, the non-monotonicity theorems, the
instruction-path layer, and the fixes from the second review landed.

## Where things stand

- V100 FP16 → FP32 executable model with exact traces. R1–R4, rounding boundaries, zero and
  subnormal branches, rejection cases, and cancellation examples are kernel-checked.
- Raw-product, alignment, accumulation, and output bridges; the stage residual identity; the
  two-stage error bound; nearest-even FP32 conversion proved correct for every rational in
  the finite range; the decoder/encoder round trip (`value32_round32`) and uniqueness of
  nonzero encodings.
- The canonical FP16 → FP32 invocation parameterized by product count `K` and extra
  alignment bits: `fp16Fp32_contract`, the exact accepted domain, a modular signed-word
  evaluator equal to the reference in every result including rejections
  (`fp16Fp32_machine_eq`), floors at or below −126 proved inert, and padding thresholds
  (`extra ≥ 156` for the source floors, `extra ≥ 253` in general) that make alignment exact.
  V100, Ampere, and Hopper instances match the published FP16 vectors, 5,000 rows each.
- Long dot products in a supplied order: ordered partitions with proved ideal preservation
  and tail padding, a composed uncorrected error bound, and machine equivalence through
  every encoded boundary.
- Instruction paths: an `InstructionPath` fixes `k`, `N_FMA`, extra bits, floor, and its
  source; its schedule is the contiguous increasing-k grouping of the reference software,
  and it runs on exactly `k` operands. Zero groups pass the accumulator through, so
  single-group inputs reproduce one group on the whole instruction
  (`single_group_output`), which is exactly what the published vectors test.
  `Conforms path device`, agreement on the model's accepted domain, is the explicit hardware
  premise, and `conforms_uncorrected_error` gives the composed error bound for any
  conforming device.
  `tc_instruction` prints a pinned path and refuses unsourced names. Three paths are pinned:
  V100 (4 × 4), Ampere/Ada (2 × 8), Hopper/Blackwell (1 × 16).
- The scalar EFT of TC-EFT §IV: Lemma IV.7, Theorem IV.8 (exact naive FP32 summation on a
  common grid under the 24-bit coefficient bound), the overlap lemmas IV.3–IV.4 and the
  overlap form of recovery, the decidable predicate of IV.9–IV.10 on the components, and the
  scalar EFT that returns a result only under the predicate and is then `RN(S)`
  (Corollary IV.11). R2, R3, the paper's cancellation example, and two predicate rejections
  are kernel-checked.
- TC-EFT Theorems III.4 and III.5 as theorems over `K`, `p`, and `j`, with encoded-operand
  instances for the V100, Ampere, and Hopper families, the Table III witnesses, and the
  witness ranges.
- A generalized `InvocationSpec` evaluator with exact loss accounting for every
  specification. The BF16 and TF32 descriptors match the published A100 and H100 vectors,
  5,000 rows each, but have no rounding-correctness proofs and are not claimed.
- Two independent Python oracles, 35,000 replayed device rows across seven format/device
  pairs, frontend tests, and an axiom audit generated from the environment: 636 theorem
  constants (372 written in source), all on the standard three axioms.

## Assessment

Substantive results:

1. `round32_nearestEven_correct`, the general nearest-value and ties-to-even proof for the
   FP32 converter, with the round trip and uniqueness results built on it.
2. Fidelity of the executable model, checked against the paper, the MATLAB source, two
   oracles, and 35,000 device rows across three GPU generations.
3. The scalar EFT. Exact naive summation is a representability induction on actual FP32
   additions, and the procedure's correctness rests on it rather than on exact rationals.
4. Non-monotonicity as parametric theorems with realizable operands, not witnesses.
5. The parameterized contract, the machine refinement of the complete result, and the
   composition results for long dot products and instruction paths, with hardware
   conformance kept as a premise rather than smuggled into a definition.

Bookkeeping, not results: the residual identity, definitional bridges, and regression
evaluations. Nothing here is a proof about hardware; every device claim is test evidence.

Prior work and what is new. The block-FMA description, the profile parameters, and the
device vectors come from Accurate Models v4 and MATLAB Tensor Core v0.5; the EFT, the
predicate, and the non-monotonicity constructions come from the TC-EFT submission. Formal
floating-point developments in Coq, Isabelle, HOL, and Lean prove properties of IEEE
operations and rounding. What this project adds is the mechanization: an executable
block-FMA model whose general theorems (rounding, recovery, error bounds, machine
refinement, EFT, non-monotonicity, composition) are checked by the kernel on the same
definitions that the oracles and device vectors test. Claims of being first or finer than
other formal models are not made; the comparison that matters is with the papers' own
statements, and each theorem records the domain on which it reproduces them.

## Next steps, in order

1. **Boundary operators beyond the encoded FP32 boundary.** The Hopper FP8-via-HMMA path
   combines two interleaved groups and adds c late with RNE (Accurate Models Fig. 5c). Model
   boundaries as data (encoded conversion, unnormalized combination, scalar addition) with a
   loss lemma each and a ledger generic over the boundary list, then an `interleavedPairs`
   grouping. Do not assign the FP8 path to hardware until its output-precision question in
   FEATURE_COVERAGE.md is settled.
2. **Input-derived error budgets.** Replace the trace-dependent budgets in
   `runBlocks_uncorrected_error` with budgets from operand bounds or loop invariants, then
   changing-state loops in `Program`.
3. **Evidence for grouping.** The published vectors only fill k positions `0..K−1`, so
   `Conforms` is untested for the second Ampere group. Vectors with nonzero products in
   later positions, on a real GPU, would test it; the harness in the v0.5 archive is the
   template. `ampere_instruction_order_matters` is a ready-made distinguishing input.
4. **Matrix mapping and one application.** A tile-level `mma` operation elaborated to
   per-cell instruction schedules, a mapping theorem, and one verified application or
   transformation.

Deferred by decision: BF16, TF32, FP8, FP16 output, FP64 FMA, input conversion and flush
policies, and late-c paths. The `InvocationSpec` scaffolding describes them and two of them
match device vectors, but no proof beyond exact loss accounting should be claimed until the
reconciliation register in FEATURE_COVERAGE.md is settled and the general converter is proved.

## Design rules

- Elaborators produce data and apply existing theorems. They never define a second
  arithmetic, and every generated statement is inspectable.
- A hardware claim is an explicit premise (`Conforms path device`), never assumed inside a
  definition or a proof.
- Numbers in documentation come from the scripts' reports.
- The audit enumerates theorems from the environment; the placeholder scan covers every Lean
  source, so avoid the scanned words even in comments.
- Documentation stays at README, SPECIFICATION, THEOREM_MAP, ASSUMPTIONS, VALIDATION, DSL,
  COMPOSITION, FEATURE_COVERAGE, INVOCATION_CONTRACT, and PLAN.

## Known issues

1. `round32` rejects magnitudes in `(maxFinite32, 2^128)` under round-toward-zero, where IEEE
   truncation and the MATLAB model both return `maxFinite32`. Either keep the guard as a
   documented restriction or prove the truncation case.
2. `roundBinary` exists for every format and directed mode but is proved only to agree with
   `round32` on FP32.
3. The device comparisons contain almost no zero or subnormal operands or c, and none that
   reach the BF16/TF32 alignment floors. Those branches follow the MATLAB source and need
   targeted vectors.
4. Theorem IV.8 is stated for grid exponents up to 104, which covers every FP32-relevant
   grid; the paper's general form with the explicit range condition is not needed there.
5. `single_group_output` excludes a first-group output of `−0`; a following zero group turns
   `−0` into `+0` in the model, and the device behavior for that case is unknown.
6. `scalarPredicate` is a sufficient condition. An input it rejects may still have a correct
   scalar branch; the procedure reports failure rather than deciding that case.
