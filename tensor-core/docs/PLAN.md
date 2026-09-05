# Plan

Written after the 5 September 2026 review and updated the same day after the canonical
gate, the long-dot-product slice, the scalar EFT, and the non-monotonicity theorem landed.

## Where things stand

- V100 FP16 → FP32 executable model with exact traces. R1–R4, rounding boundaries, zero and
  subnormal branches, rejection cases, and cancellation examples are kernel-checked.
- Raw-product, alignment, accumulation, and output bridges; the stage residual identity; the
  two-stage error bound; nearest-even FP32 conversion proved correct for every rational in
  the finite range.
- The canonical FP16 → FP32 invocation parameterized by product count `K` and extra
  alignment bits: `fp16Fp32_contract`, the exact accepted domain, a modular signed-word
  evaluator equal to the reference in every result including rejections
  (`fp16Fp32_machine_eq`), floors at or below −126 proved inert, and padding thresholds
  (`extra ≥ 156` for the source floors, `extra ≥ 253` in general) that make alignment exact.
  V100, Ampere, and Hopper instances match the published FP16 vectors, 5,000 rows each.
- Long dot products in a supplied order: ordered partitions with proved ideal preservation
  and tail padding, a composed uncorrected error bound, and machine equivalence through
  every encoded boundary.
- The scalar EFT of TC-EFT §IV: Lemma IV.7, Theorem IV.8 (exact naive FP32 summation on a
  common grid under the 24-bit coefficient bound), the overlap form of recovery, the
  decidable predicate of IV.9–IV.10, and Algorithm 1 whose scalar branch is proved to return
  `RN(S)` (Corollary IV.11). R2, R3, and the paper's cancellation example are kernel-checked,
  along with a predicate-failure case that takes the exact-dyadic branch.
- TC-EFT Theorem III.4 as a theorem over `K` and `p`, with encoded-operand instances for the
  V100, Ampere, and Hopper families and the Table III witnesses.
- A generalized `InvocationSpec` evaluator with exact loss accounting for every
  specification. The BF16 and TF32 descriptors match the published A100 and H100 vectors,
  5,000 rows each, but have no rounding-correctness proofs and are not claimed.
- Two independent Python oracles, 35,000 replayed device rows across seven format/device
  pairs, frontend rejection tests, and a standard-axiom audit of 201 theorem roots.

## Assessment

Substantive results:

1. `round32_nearestEven_correct`, the general nearest-value and ties-to-even proof for the
   FP32 converter, including subnormals, carries, and the lower-binade argument.
2. Fidelity of the executable model, checked against the paper, the MATLAB source, two
   oracles, and 35,000 device rows across three GPU generations. Earlier formal models
   abstract an instruction as one accumulation in any order; this model is finer and is
   validated where those differ.
3. The scalar EFT. Exact naive summation is a representability induction on actual FP32
   additions, and the algorithm's correctness rests on it rather than on exact rationals.
4. Non-monotonicity as a parametric theorem with realizable operands, not a witness.
5. The parameterized contract, the machine refinement of the complete result, and the
   composition results for long dot products.

Bookkeeping, not results: the residual identity, definitional bridges, and regression
evaluations. Nothing here is a proof about hardware; every device claim is test evidence.

## Next steps, in order

1. **Instruction-level composition.** Boundary operators as data (encoded conversion,
   unnormalized combination, scalar addition), a generic ledger over them, instruction
   descriptors with a k-partition and a `Conforms` premise, and a `tc_instruction` command
   that elaborates a pinned path into a schedule. The A100 FP16 path (two groups per k = 16
   instruction, validated by the paper at scale) is the first target. See COMPOSITION.md.
2. **Input-derived error budgets.** Replace the trace-dependent budgets in
   `runBlocks_uncorrected_error` with budgets from operand bounds or loop invariants, then
   changing-state loops in `Program`.
3. **Theorem III.5** (the range of non-monotonic perturbation) on top of the III.4 setup,
   and the overlap lemmas IV.3–IV.4 relating the coarse components to the alignment
   residuals.
4. **Evidence for grouping.** The published vectors only fill k positions `0..K−1`, so they
   do not test group order. Vectors with nonzero products in later positions, on a real GPU,
   are needed; the harness in the v0.5 archive is the template.
5. **Matrix mapping and one application.** A tile-level `mma` operation elaborated to
   per-cell schedules, a mapping theorem, and one verified application or transformation.

Deferred by decision: BF16, TF32, FP8, FP16 output, FP64 FMA, input conversion and flush
policies, and late-c paths. The `InvocationSpec` scaffolding describes them and two of them
match device vectors, but no proof beyond exact loss accounting should be claimed until the
reconciliation register in FEATURE_COVERAGE.md is settled and the general converter is proved.

## Design rules

- Elaborators produce data and apply existing theorems. They never define a second
  arithmetic, and every generated statement is inspectable.
- A hardware claim is an explicit premise (`Conforms path`), never an axiom.
- Numbers in documentation come from the scripts' reports.
- The audit root list should be generated from the environment; the placeholder scan should
  cover every Lean file, not only `TensorCore/`.
- Documentation stays at README, SPECIFICATION, THEOREM_MAP, ASSUMPTIONS, VALIDATION, DSL,
  COMPOSITION, FEATURE_COVERAGE, INVOCATION_CONTRACT, and PLAN.

## Known issues

1. `tc_verify` rolls back whenever the file already contains any earlier error, because it
   inspects the whole message log. Compare message counts before and after elaboration.
2. `round32` rejects magnitudes in `(maxFinite32, 2^128)` under round-toward-zero, where IEEE
   truncation and the MATLAB model both return `maxFinite32`. Either keep the guard as a
   documented restriction or prove the truncation case.
3. `check_axioms.py` scans only `TensorCore/` for placeholders and audits a hand-maintained
   list in `Audit.lean`.
4. `roundBinary` exists for every format and directed mode but is proved only to agree with
   `round32` on FP32.
5. The device comparisons contain almost no zero or subnormal operands or c, and none that
   reach the BF16/TF32 alignment floors. Those branches follow the MATLAB source and need
   targeted vectors.
6. Theorem IV.8 is stated for grid exponents up to 104, which covers every FP32-relevant
   grid; the paper's general form with the explicit range condition is not needed there.
