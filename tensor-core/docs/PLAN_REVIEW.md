# Plan review, 5 September 2026

**Historical review.** The user's latest direction is to complete the general
parameterized single-invocation model first, then consider downstream uses.
EFT is a separate invocation-local application. The authoritative ordering and
completion criteria are now in [CURRENT_PLAN.md](CURRENT_PLAN.md); the review
below records the earlier decisions and must not override that plan.

Reviewed the full handoff, Accurate Models v4, and the supplied revised TC-EFT
paper. The handoff's immediate work package is sound. Keep the staged approach;
the larger roadmap is research scope, not a claim of an already verified EFT.

## Adjustments adopted

1. Pin MATLAB Tensor Core v0.5 to commit
   `bbcf00a273868172494eaacaa8d6128ab0fb8704`. The revised paper already cites
   this revision; the GitHub tag independently resolves to the same commit.
2. Resolve input subnormals now: `Generic_BFMA_TC.m` clamps operand scales to
   `emin_input`, then computes significands by rescaling the original values.
   Thus a subnormal uses the explicit fraction and minimum normal scale,
   consistent with revised TC-EFT II-B. Include this decoder in the finite
   V100 reference; do not guess normalized subnormal scales.
3. Pin installed Lean 4.33.1, initially without external packages. Its standard
   library includes exact `Rat`, `Dyadic`, a logical float model, `grind`, and
   integer arithmetic. Use integer significands/scales and exact rational
   valuations. Native scalar Float is not the raw tensor-core state.
4. Keep output overflow outside the initial evaluator's accepted domain,
   returning an explicit error. Finite inputs do not establish a finite-range
   accumulator. Classify all input bit patterns; reject NaN/infinity.
5. Treat kernel-checked concrete rounding cases and a general nearest-value
   rounding proof as separate deliverables. Never label regression checking
   as a parametric `finalRound_correct` theorem.
6. Prove exact local extraction and an arbitrary-length ledger with encoded
   boundaries first. A supplied finite output need not match the model for
   the recovery identity; hardware loss bounds require more hypotheses.
7. Keep the conservative signed-width formula in revised TC-EFT II-B as a
   later refinement target. Do not turn the paper's 28-bit magnitude/carry
   label into a 28-bit two's-complement accumulator.
8. Correct R4: `1 - 3*2^-25` is a midpoint between `0x3f7ffffe` and
   `0x3f7fffff`. Both distances are `2^-25`; the even encoding is
   `0x3f7ffffe = 1 - 2^-23`. The handoff originally selected the odd neighbor
   `1 - 2^-24`. Preserve the input and prove the corrected result; do not
   modify the rounding procedure to satisfy the false expectation.

## Assessment of the revised paper

III.1 counts alignment and output loss; R3 specifically defeats an alignment-only
bound. III.4–III.5 establish a realizable non-monotonicity family, not a universal
padding threshold. IV.1–IV.5 give exact stage/overlap identities. IV.8–IV.11
require support, range, and representability premises for scalar execution.
The reference algorithm reconstructs a retained sum, so its recovery identity
does not establish the earlier low-cost extractor or its GPU cost. V distinguishes
historical device measurements from the revised software model. VIII's ledger
requires retention of each local residual and explicitly encoded call boundaries.

## First gate

Build an executable V100 block, independent exact input sum, quotient/remainder
FP32 conversion, checked R1–R3 traces, returned-residual theorem, and induction
over finite invocation schedules. Audit theorem axioms. Defer custom syntax,
other architecture evaluators, optimized overlap extraction, hardware claims,
and general rounding/error-bound completion until their stated proofs exist.

## Follow-up gate completed

Fable added profile-indexed semantics, the published V100 device comparison,
and rounding proof foundations. The follow-up review repaired unfinished
encoding proofs and preserved the explicit range policy. General finite-range
nearest-even correctness, corrected block/schedule correctness, and the
two-stage error bound are now proved. The separate rounding milestone in
item 5 is therefore complete; the scalar representation and machine-width
obligations remain. See [the review](FABLE_REVIEW.md) and [status](STATUS.md).

## Program-language increment

With the initial gate and general rounding proofs in place, the next increment
implements handoff §15 steps C–F for a restricted fragment: typed block calls,
sequencing, bounded repetition, final reference correction, inspectable terms,
and proof-producing commands. Full scalar representability and fixed-width
refinement are not prerequisites for this fragment and remain explicit work.
The pinned `mvcgen`/`vcgen` implementations were assessed; this increment
applies existing program theorems directly without introducing a general
Hoare framework. See [the DSL guide](DSL.md) for that decision and scope.

## Downstream verification priority

The user identified that model-schedule proofs must not be conflated with
PTX instruction/program proofs. The single-invocation example has been checked,
but its unit is one V100 normalization group. Review of v4 §4.2/Table 4, the
release's GEMM/WMMA sources, and the official PTX documentation confirms the
need for a distinct instruction-path and lowering contract. That connection
now precedes additional profile expansion in the next work list. See
[the concrete revised milestone](PTX_BOUNDARY.md).
