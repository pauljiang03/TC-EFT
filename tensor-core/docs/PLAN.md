# Plan

Latest update: 6 September 2026. This is the master handoff to **Fable**, following the
code review of `d74ae0b` and the user's instruction to document the remaining issues and
prevent superficial fixes. The ordered work below replaces the earlier boundary-first plan.
This update changes documentation; the implementation work remains open unless explicitly
marked complete.

## Fable handoff: do not take the "lazy route"

The user explicitly requires substantive fixes. Do not make a proof pass by changing the
claim so that it no longer addresses the intended problem, or mark an implementation gap
closed after a wording change. In particular:

- Do not hide an exact-ideal calculation behind an algebraically equivalent expression and
  claim that the calculation has been eliminated. Exact arithmetic remains appropriate in
  specifications, oracles, and proofs; a claimed finite-precision implementation needs its
  own operations, bounds, and refinement theorem.
- Do not put the desired output equality, successful execution, or desired error bound into
  the hypotheses of the theorem intended to establish it. Derive the needed conditions from
  stated input assumptions or invariants. Existing conditional transfer lemmas may remain,
  but they do not discharge those assumptions for an application.
- Do not resolve a failing case by returning failure on all interesting inputs, deleting the
  case, silently shrinking the domain, or replacing the intended algorithm with exact
  rational correction. A sufficient predicate is legitimate; demonstrate a useful family
  that satisfies it and report the remaining rejections honestly.
- Do not present evaluated examples as general proofs, an unchanged-state cycle as a
  changing-state loop invariant, or another command wrapper as a new analysis method.
- Preserve the independent original-input ideal and the existing adversarial regressions.
  Hardware conformance must remain an explicit premise supported by separately reported
  device evidence; a recovery identity cannot establish it.
- Short proofs using `rfl`, `simp`, `omega`, `grind`, or an existing theorem are welcome.
  Proof length and theorem count are not measures of substance. The question is what the
  statement establishes about independently defined behavior.

For each completed item, record the changed executable behavior, theorem and hypotheses,
why the hypotheses hold for the target input family, relevant validation, and remaining
limits. A build or audit passing is necessary, but does not establish that the right problem
was solved. Keep unresolved items open when only a contract or description was corrected.

### Verified baseline — 5 September review, already complete

- `1d69f73` and `d74ae0b` were verified on GitHub's `main`; the reviewed working tree was
  clean. Do not redo the instruction-length fix, accepted-domain `Conforms` fix, IV.3–IV.4,
  III.5, or the existing static-budget theorems as if they were missing.
- A fresh temporary source copy built successfully: **126 jobs**, **673 audited theorem
  roots / 406 written in source**, standard Lean axioms only. All oracle, device replay,
  dot-product, frontend, and canonical/long-dot-product example checks passed.
- There were **zero Lean warnings**, but **two linker warnings** about a missing
  `/usr/local/lib` directory. Do not report zero build warnings without this distinction.
- The eight-group static regression's bound is **9.94 times** its trace budget. This is one
  example, not evidence of typical tightness or scalability.
- No incorrect proved arithmetic result was found in the claimed finite FP16-to-FP32
  domain. The remaining findings concern API consistency, restricted contracts, practical
  implementation, coverage, and claims; they are not evidence of a kernel bypass.

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
- Input-derived error budgets: `staticBudget` bounds one block from a scale bound on its
  operands, `runBlocks_static` carries it through a schedule by a forward analysis of the
  ideal partial sums, and `staticCheck_sound` turns a decidable certificate on the operands
  into acceptance of the whole run and the error bound without executing the model.
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
  pairs, frontend tests, and an axiom audit generated from the environment: 673 theorem
  constants (406 written in source), all on the standard three axioms.

## Assessment

Substantive results:

1. `round32_nearestEven_correct`, the general nearest-value and ties-to-even proof for the
   FP32 converter, with the round trip and uniqueness results built on it.
2. Fidelity of the executable model, checked against the paper, the MATLAB source, two
   oracles, and 35,000 device rows across three GPU generations.
3. The conditional scalar consolidation proof. Exact naive summation is a representability
   induction on actual rounded FP32 additions. Component extraction and predicate evaluation
   still use exact arithmetic; a finite-precision extractor has not been implemented.
4. Non-monotonicity as parametric theorems with realizable operands, not witnesses.
5. The parameterized contract, the machine refinement of the complete result, and the
   composition results for long dot products and instruction paths, with hardware
   conformance kept as a premise rather than smuggled into a definition.
6. The static certificate: acceptance and an error bound for a schedule decided on the
   operands and the ideal partial sums, with soundness proved against the executable model.

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

## Master next steps, in order

### F1 — Resolve public API inconsistencies and finish claim alignment

Status: **open**. The README family qualification and trust report's exact-component wording
are corrected in this handoff update; those documentation changes do not fix the code gaps.
The following behaviors were reproduced with kernel-checked evaluations at the baseline:

- **Zero product count:** `evalBlock` under `fp16Fp32Profile 0 0 none`, with no pairs and
  `c = 0x3f800000`, succeeds and returns that value. `fp16Fp32Invocation 0 0 none` rejects
  the same call as `invalidSpec`; `tc_features canonical` uses this latter evaluator.
  Choose and enforce a consistent public policy, or explicitly expose separate domains.
  Preserve intentional general theorems; do not silently remove their `K = 0` cases.
  Relevant files: [Canonical.lean](../TensorCore/Semantics/Canonical.lean),
  [Invocation.lean](../TensorCore/Semantics/Invocation.lean), [FeatureMain.lean](../FeatureMain.lean).
- **Empty schedules:** `runCanonicalDot 4 0 none (by decide) [] 0x7fc00000` returns `.ok []`,
  while a list containing one zero pair rejects the same NaN accumulator. The CLI rejects
  both. An empty low-level schedule can legitimately be a no-op; define and enforce the
  finite-input policy at the intended public entry point, and document any deliberate
  low-level difference. Relevant files: [Partition.lean](../TensorCore/Programs/Partition.lean),
  [Composition.lean](../TensorCore/Programs/Composition.lean), [FeatureMain.lean](../FeatureMain.lean).
- **Unchecked scalar helper:** on `Regression.subnormalAccumulator`, `scalarCorrected`
  returns `some 0x3f800000`, the exact reference returns `some 0x3f800001`, and `tceft`
  correctly returns `none`. Protect the public interface by making the helper internal,
  naming it explicitly unchecked, or requiring its predicate. Preserve the regression
  showing why the guard matters. Relevant file: [EFT.lean](../TensorCore/Programs/EFT.lean).
- **Rounding domain:** `round32 .towardZero (maxFinite32 + 1) = none`, while `round32Core`
  returns `some 0x7f7fffff`. This is a documented domain restriction, not a false theorem.
  Either consistently expose the restricted converter as such or implement and prove an
  extended conversion contract. Merely deleting the range guard is not an acceptable fix.

Acceptance: public entry points have explicit, consistent domains and boundary regressions;
the unchecked helper is unmistakable; README, specification, theorem map, and DSL describe
the same guarantees. Distinguish the partial scalar EFT from the draft algorithm with an
exact fallback, and state the equal-product assumptions of III.4–III.5 wherever their
thresholds are summarized. Record which limitations remain intentionally outside scope.

### F2 — Connect static certificates to the program language

Status: **open**. Implement `tc_certify` using [StaticCertificate.lean](../TensorCore/Programs/StaticCertificate.lean).
The generated theorem must establish **successful execution and an error bound for the
uncorrected output** of the supplied program. Keep this distinct from `Program.Correct`,
which describes execution plus exact-reference correction.

Current `Program.VC` actually executes `pr.run` and checks the exact recovered sum. Its
soundness theorem is valid, but automatic concrete checking is not symbolic analysis.
Do not implement `tc_certify` by evaluating that VC and relabeling its result as static.

Acceptance: an inspectable AST-to-schedule bridge, sound generated theorem, useful diagnostics,
and examples with meaningful acceptance/rejection checks. Verify that the certificate path
does not execute `evalBlock`, `runBlocks`, or the exact residual ledger. This frontend item
alone does not close F3 or constitute the verified application in F4.

### F3 — Prove bounds for changing-state loops and input families

Status: **open**. `partialSumsCheck` currently computes every group's exact ideal contribution
and every ideal partial sum on concrete inputs. Avoiding the hardware model is useful, but
does not avoid exact input-dependent computation. The underlying `runBlocks_static` theorem
is substantive and should be reused.

`Program.repeat_vc_of_cycle` assumes that the body returns the same encoded accumulator and
has zero residual ledger. This is a valid cycle lemma, not an invariant for an ordinary
accumulating loop. Extend the analysis with input bounds and invariants that relate ideal
partial sums, actual rounded accumulator state, and accumulated error.

Acceptance: at least one theorem for a parameterized, useful input family and symbolic loop
count, with a body that changes the accumulator and permits rounding error. Prove invariant
initialization and preservation from input assumptions. Do not enumerate all iterations,
precompute all exact prefixes, assume the desired final bound, or constrain the example to
an unchanged-state/zero-loss cycle. Measure concrete certificate cost and tightness where
applicable. A rejected sufficient certificate means "not certified," not "incorrect run."

### F4 — Deliver one verified application

Status: **open**. Select the application before designing F2–F3 so it determines useful
contracts. Start with a realistic dot product or transformation with an input-derived
accuracy requirement. Add tile-level `mma`, matrix indexing, and a per-cell schedule mapping
theorem if the chosen application needs them; do not make matrix scaffolding an end in itself.

Acceptance: an end-to-end theorem against an independently defined mathematical result,
with discharged input conditions and a useful numerical guarantee. Evaluate multiple sizes
and input regimes, bound tightness, certification time, and rejected cases. Explain what the
proof enables beyond executing an exact oracle or replaying selected examples.

### F5 — Obtain targeted hardware evidence (prepare in parallel)

Status: **open; measurements require GPU access**. Existing vectors populate only the first
group, so they do not test the order of multiple nonzero groups. Prepare a harness based on
the v0.5 archive, including `ampere_instruction_order_matters`, populated later groups,
cancellation, signed zeros, and subnormal operands/accumulators. Cover each claimed path
where the grouping question applies.

Acceptance: actual GPU runs with device, instruction, compiler/settings, and raw input/output
bits recorded and replayable. Clearly separate expected model results from measurements.
Harness preparation can finish without a GPU; device validation cannot. Tests strengthen
evidence but do not turn `Conforms` into a proved hardware fact.

### F6 — Implement and refine finite-precision EFT extraction

Status: **open; required for a practical correction-algorithm claim**. In
[EFT.lean](../TensorCore/Programs/EFT.lean), the range check uses
`retainedSum + sumQ lowParts`; `retained_add_low` proves that this equals `exactDot`.
Changing the expression did not remove exact reconstruction. Coarse parts, low parts,
overlap, and the predicate are still calculated with exact arithmetic.

Implement the extraction, overlap calculation, guard, and final correction using explicitly
bounded machine operations, with proofs of representability, range, and refinement against
the existing exact specification. Exact `Rat` values may remain on the specification side.
The implementation must not obtain residuals from an exact trace or recompute the ideal to
decide whether it succeeds. If a different cost model is proposed, state and evaluate it
explicitly instead of calling it a finite-precision implementation.

Returning `none` when the predicate fails is a legitimate partial-procedure contract and
already has passing examples. It does not itself implement extraction or establish useful
coverage. Preserve this honest failure behavior and the subnormal counterexample; do not
silently reintroduce exact fallback. Prove success for a useful input family and measure
rejection frequency, operation cost, and accuracy against appropriate alternatives.

`block_residual_identity` holds for any supplied output `d`. It and
`corrected_eq_round_exactDot` are algebraic infrastructure; neither can certify the accuracy
of a device model or the efficiency of a correction implementation. Reusing them is proper;
claiming them as the missing algorithm is not.

For a focused formalization paper this implementation may remain an explicitly open
extension. Do not mark it fixed or make practical-performance claims on that basis.

### F7 — Extend boundary operators only when justified by the application

Status: **deferred behind F2–F4**. The Hopper FP8-via-HMMA path combines interleaved groups
and adds c late with RNE (Accurate Models Fig. 5c). Resolve the output-precision question in
[FEATURE_COVERAGE.md](FEATURE_COVERAGE.md) before making a device claim. Then model encoded
conversion, unnormalized combination, and scalar addition boundaries with loss lemmas and
a ledger over explicit boundary data. Add the grouping and mapping proofs required by the
application. Executable descriptors or additional algebraic ledgers alone do not close
format-specific rounding or hardware obligations.

### F8 — Produce the reproducible submission artifact

Status: **open**. Pin the final revision and align README, theorem map, assumptions, DSL,
validation, and paper claims. Compare explicitly with prior tensor-core formalizations as
well as the source numerical papers. Separate mathematical novelty, mechanization, and
empirical evidence; do not use theorem counts or regression counts as substitutes.

Acceptance: fresh build/audit and appropriate oracle, device replay, program, and example
checks; reproducible logs and source pins; accurate warning counts; and a clear account of
which application and extraction claims are actually delivered. New scalar/loop code needs
the relevant adversarial cases, not merely a rerun of old block-oracle tests. Do not disable
checks, remove regressions, or suppress warnings to manufacture a clean report.

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
