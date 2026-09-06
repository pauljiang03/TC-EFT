# Plan

Latest update: 6 September 2026. This is the master handoff to **Fable**, incorporating the
reviews of `d74ae0b` and `95d5f62` and the user's instruction to document the remaining issues
and prevent superficial fixes. The latest review independently reconfirmed the open findings
and added scalar-predicate coverage measurements. Agent A has now implemented and validated
the public-domain, certification, changing-state loop, and bounded-dot application work.
The historical reviews below remain as evidence; current F-item statuses distinguish the
delivered A track, B's completed milestones, and the combined integration. The working
order is now the papers-as-specification list below.

## Specification authority and completion scope

User decision, 6 September 2026: **take Accurate Models v4 as the ground-truth
specification**. The required work is faithful translation of its semantics into
Lean, explicit reconciliation with the pinned v0.5 reference where necessary,
and kernel-checked proofs and software validation of the claimed results.
TC-EFT remains the source of the correction and related arithmetic contracts.

**New GPU measurements are optional external validation, not a completion gate.**
They would test the paper's correspondence with physical devices, a separate
objective. GPU access, CUDA compilation, and fresh device runs are not required
to complete this formalization or F8. Existing published-vector replay and the
prepared harness remain useful evidence and regression infrastructure.

This scope decision supersedes earlier F5 measurement requirements in the review
history, split, and handoffs. It does not mark unperformed experiments as passed,
assert device conformance, or discharge the separate F6 implementation obligations.
`Conforms` remains explicit only when a theorem makes a claim about an actual device.

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

### Follow-up review — 6 September, `95d5f62`

The arithmetic core is substantive and credible within its stated domain, and the current
README mostly describes that domain accurately. The application layers remain incomplete:
neither a bounded machine implementation of EFT extraction nor an end-to-end verified GPU
application is delivered. This assessment does not identify a false proved arithmetic result.

Reconfirmed, not newly discovered or fixed:

- A fresh temporary source copy, without the existing `.lake` cache, built all **126 jobs**.
  The axiom audit again checked **673 theorem roots / 406 written in source**, using only
  standard Lean axioms. Both oracle suites, dot-product checks, all seven device/format
  replays (**35,000 published rows**), frontend checks, and the standalone examples passed.
  These are fresh software checks, not new hardware measurements. The warning counts above
  belong to the earlier build and should not be copied into a new build report.
- New kernel-checked probes reproduced all four F1 boundary cases: the zero-product
  evaluator disagreement, empty-schedule NaN acceptance, the incorrect unchecked scalar
  result, and the public/core rounding-domain difference. F1 is still open.
- F2–F3 still have the concrete execution and exact-prefix limitations described below.
  `Conforms` remains a hardware premise, and machine refinement covers accumulator addition
  only. F5–F6 are still open. The documentation-only change at `95d5f62` did not implement
  the earlier plan.

New evidence: the review ran the actual Lean `evalBlock` and `scalarPredicate` on the
published FP16 corpus and two additional input distributions:

| Input cohort | V100 `(K=4, extra=0)` accepted | Ampere `(K=8, extra=1)` accepted | Hopper `(K=16, extra=2)` accepted |
| --- | ---: | ---: | ---: |
| Published FP16 rows | 5,000 / 5,000 | 5,000 / 5,000 | 5,000 / 5,000 |
| Additional magnitudes in `[0.5, 2)` | 1,000 / 1,000 | 1,000 / 1,000 | 1,000 / 1,000 |
| Uniform finite magnitude bit patterns, independent signs | 73 / 1,000 | 13 / 1,000 | 0 / 1,000 |

All **21,000** inputs were accepted by the block model; the table counts scalar-predicate
acceptance. On the published rows, passing correction changed the model output in **1,885**,
**1,919**, and **2,093** cases respectively, so the passing corpus includes nontrivial
corrections. On the broad finite-bit cohort, every predicate rejection failed the
absolute low-coefficient-sum bound `< 2^24`; the other predicate checks passed.

Sampling details for reproduction: use Python `random.Random(20260906)`, first the uniform
finite-bit cohort, then the near-one cohort, without resetting the generator. Within each
cohort, visit `(K, extra) = (4, 0), (8, 1), (16, 2)` in that order and generate 1,000 blocks
per profile. Generate `2*K` interleaved operand words followed by one accumulator word.
For each word, sample its magnitude first and its sign second with `randrange(2)`, shifted
by 15 or 31 bits. Uniform magnitudes use `randrange(0x7c00)` for FP16 and
`randrange(0x7f800000)` for FP32. Near-one magnitudes use `randrange(0x3800, 0x4000)` and
`randrange(0x3f000000, 0x40000000)` respectively. The published cohort uses the existing
exact FP32-word-to-FP16 conversion in `check_device.py`. Evaluate all three profiles with
`floor = none`; the source floors are proved inactive for this family.

These are **acceptance rates of a sufficient predicate**, not hardware error rates,
estimates of real-workload prevalence, or general proofs of success or failure. In
particular, zero accepted Hopper samples does not prove that all broad-range Hopper inputs
fail. The results support useful coverage on the two narrower cohorts while exposing severe
conservatism on the broad cohort. They do not justify either universal usefulness or a
claim that the scalar procedure is vacuous. This was a one-off review probe, not an existing
checked-in validation script; F6 must make coverage checks a reproducible acceptance gate.

### Agent A implementation — 6 September

- **A1 delivered:** aligned invocation compatibility now includes zero products; fused calls
  still require one. The public dot wrapper rejects nonfinite initial c even on empty
  input; finite empty behavior and low-level no-op semantics remain. The guarded machine
  wrapper agrees for all inputs, and low-level equivalence remains available for finite c.
  The public rounding range guard is preserved and explicitly documented.
- **F2 delivered:** `Program.Accurate` expresses successful execution and raw error against
  the independent ideal. `tc_certify` applies `Program.staticCertificate_sound` and checks
  the requested tolerance. Concrete certificates still compute exact ideal prefixes.
- **F3 delivered for the fixed-input fragment:** `runBlocks_of_scale_bound` bounds prefixes
  by decoded operand scales and count, then preserves rounded-state range and accumulated
  error using `runBlocks_static`. `Program.repeat_accurate_of_scales` quantifies over the
  iteration count; neither successful execution nor an unchanged state is assumed.
- **F4 delivered for a bounded ordered dot:** `boundedDot_accurate_of_bits` covers up to 256
  signed FP16 pairs with magnitude bits below `0x2c00` and finite initial FP32 magnitude
  at most 1. Its ordered AST matches the public partitioned run and preserves the unpadded
  ideal. It derives absolute raw error at most `2^-11`; `boundedDotCheck_sound` checks only
  membership in this input family. See [DSL.md](DSL.md) for the headroom derivation.
- **Validation:** fresh source build, 142 jobs, 746 theorem roots / 454 written in source,
  zero Lean warnings and two `ld64.lld` warnings for a missing `/usr/local/lib`. All oracle, device replay, frontend, certification,
  application, and six standalone example checks pass. The dependency walk excludes model
  execution and ledgers from concrete certification, and exact-prefix functions from family
  membership checking; its negative control detects a deliberately contaminated definition.
- **Remaining:** A has not implemented bounded EFT extraction. New GPU measurements
  were not obtained and are now classified as optional external validation.
  A's source-copy validation is historical track evidence. B's delivered milestones
  and the combined validation are recorded separately below and in `/merge.md`.

New criticisms to retain:

- The application bound is conservative. On 256 near-boundary positive products it is 7
  times the trace budget and 1,344 times actual error; exact cancellation makes a ratio to
  error undefined. A tiny nonzero subnormal contribution can make the ratio much larger.
  Do not present this as a sharp bound or a universal FP32-accuracy guarantee.
- Among 87 selected size/regime cases, family membership accepts 52, while concrete prefix
  checking accepts 69. Thirty-three inputs outside the family still meet the numerical
  tolerance when executed. These are conservative rejections, not incorrect model runs.
- The symbolic proof handles arbitrary signed bounded operand lists and symbolic counts,
  but operands remain independent of rounded state. Automatic invariant inference,
  adaptive loops, CUDA execution, matrix memory-layout correctness, and hardware conformance
  are not delivered by this application theorem.
- Timing reports cover complete compiled CLI batches, including parsing and diagnostics;
  the model comparison also constructs traces and an exact ideal. The measured advantage
  of family checking is not an isolated arithmetic speedup or a GPU performance result.

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
  The machine evaluator refines modular accumulator additions; decoding, multiplication,
  alignment, and output conversion still use the exact reference machinery.
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
  and it runs on exactly `k` operands. Zero groups pass finite accumulators other than
  `−0` through when the floor is at most −126, so, subject to those conditions,
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
  pairs, frontend tests, and an axiom audit generated from the combined environment:
  772 theorem constants (471 written in source), all on the standard three axioms.

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
other formal models are not made. Compare both with the source papers' statements and with
prior tensor-core formalizations, including Valpey et al.,
[An SMT Formalization of Mixed-Precision Matrix Multiplication](https://arxiv.org/abs/2502.15999)
(NFM 2025). The comparison below identifies model fidelity, theorem scope, trust boundary,
and verified applications; using Lean or counting declarations alone does not establish
research novelty. Each theorem records the domain on which it reproduces a source result.

### Comparison with the source papers and prior SMT work

Accurate Models v4 and MATLAB v0.5 supply the numerical choices and published vectors;
TC-EFT supplies the residual, scalar-consolidation, and non-monotonicity results. This
implementation mechanizes their specified arithmetic; it does not originate those
algorithms or rediscover the hardware profiles. The A contribution is an input-derived
acceptance/accuracy theorem and its application to ordered programs with bounded inputs,
checked against the same executable semantics.

Valpey et al. use an SMT model, including a custom bit-vector accumulator, to generate
hardware-discriminating inputs and analyze error-correcting mixed-precision algorithms.
Their study covers Volta, Turing, and Ampere and already includes application analysis;
therefore executable tensor-core formalization and analyzing corrected algorithms are not
new simply because this repo does them in Lean. See their [§§4–6](https://arxiv.org/html/2502.15999v1).

Here, the kernel checks general rational rounding proofs, parameterized group contracts,
scalar consolidation, and symbolic schedule accuracy. The bounded-dot theorem quantifies
across an input family and derives successful execution and tolerance, rather than only
producing comparative witnesses. Its guarantee is about the chosen reference schedule;
GPU fidelity remains empirical. No equivalence between this reference and the SMT model
has been proved, and this repo does not reproduce their solver-based discovery workflow.
These are concrete differences in proof scope and tooling, not a claim of overall
superiority, firstness, or a new numerical error-analysis technique.

## Priorities under the papers-as-specification scope

Decided 6 September 2026 after the integration of `56fb8b8`. The goal is to formalize
what the two papers state and know. The list below is the working order; the F items
that follow are kept as the record of the reviews, and their acceptance criteria still
apply to whichever of them is taken up.

Coverage of the two papers as of `56fb8b8`, from their numbered results:

| Source | Result | Status |
| --- | --- | --- |
| TC-EFT | Definitions II.1–II.2 (encoding, correct rounding) | Decoder and `round32_nearestEven_correct`; map by name |
| TC-EFT | Theorem III.1, `ϵD < n·qA + qD` | `block_error_bound`; map by name |
| TC-EFT | Definitions III.2–III.3, Equation 6 (monotonicity, flowback `ω`, `ΔA`) | Not formalized |
| TC-EFT | Theorems III.4–III.5, Table III | Proved |
| TC-EFT | Lemma IV.1, IV.3–IV.4, Theorem IV.5, Definition IV.6, Lemma IV.7, Theorems IV.8–IV.9, Lemma IV.10, Corollary IV.11 | Proved |
| TC-EFT | Lemma IV.2 (overlap window width `τ`) | Implicit in `accumulator_eq_retained`; not a named theorem |
| TC-EFT | Algorithm 1 (exact reference recovery with the scalar consolidation branch), Table V ledger | Exact reference `corrected` and guarded scalar `tceft` exist separately; not one named procedure |
| Accurate Models | Block FMA model, FP16 → FP32 paths of Table 3 (V100, Ampere/Ada, Hopper/Blackwell) | Proved family, published vectors |
| Accurate Models | BF16 and TF32 paths of Table 3 | Descriptors match vectors; no rounding proof |
| Accurate Models | FP16 output, native and emulated FP8, late c, FP64 DMMA | Register items 1–5; not implemented or not proved |
| Accurate Models | Algorithms 1–2, Tables 5–6 | Model-discovery method and mismatch rates; empirical, not formalization targets |

Order of work:

1. **TC-EFT completeness.** Name Theorem III.1 and Definitions II.1–II.2 in the theorem
   map. Formalize Definition III.2 as a monotonicity predicate on the accumulator input,
   Definition III.3 with the identity `A'acc = Aacc + ω − ΔA`, the encoded-output
   condition of Equation 6, the necessity of `ω > ΔA` (from monotonicity of FP32
   truncation in its real argument, a new lemma), and its sufficiency when both
   accumulators are representable. State Lemma IV.2 as a named theorem. Present Algorithm 1
   as one named procedure with both branches as the paper defines them, the exact
   reference branch labeled as such, and record the Table V operation ledger. Whether the
   exact branch belongs in the public procedure is the user's call; it is the paper's
   definition, not a fallback added by this project.
2. **Accurate Models breadth.** Prove rounding correctness of `roundBinary` parametrically
   in the format, so the BF16, TF32, and FP16-output rows of Table 3 become proved families
   on the vectors that already match. Resolve register items 1–4 from the paper and the
   v0.5 source, not from hardware, recording the chosen reading; then implement the FP8
   paths and the late-c boundary (the former F7) and the FP64 DMMA rounding proof. Map the
   TF32 mma.sync K = 8 row.
3. **F6, bounded extraction.** The paper's Algorithm 1 is an exact-dyadic reference with an
   operation ledger; a bounded machine extractor is beyond its claims. Keep the proved
   primitives and the coverage gate; continue only after items 1–2.
4. **F4 tightening.** The application is beyond the papers; tighten its budget only when
   the paper coverage above is complete.
5. **F5, hardware.** Lowest priority and optional, as stated above.

## Master next steps, in order

### F1 — Resolve public API inconsistencies and finish claim alignment

Status: **complete under the documented finite-range policy**. Aligned `K = 0`, finite-input
public dot policy, machine-equivalence repair, and rounding-domain regression are
retained. `scalarCorrected` now guards the unchanged sufficient predicate, just
like `tceft`; `scalarCorrectedUnchecked` is explicitly diagnostic. Both wrong-answer
counterexamples are preserved and rejected by the guarded API. Shared documentation
states the same domains. The following records the original baseline failures,
reconfirmed at `95d5f62`; their old API behavior is historical. The finite-range
rounding restriction remains intentional. This API repair does not complete F6.

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

Status: **complete for concrete certificates**. `tc_certify` now applies
`Program.staticCertificate_sound`; eight negative elaboration cases, rollback, supplied
proofs, diagnostics, and executable dependency checks pass. This uses
[StaticCertificate.lean](../TensorCore/Programs/StaticCertificate.lean).
The generated theorem must establish **successful execution and an error bound for the
uncorrected output** of the supplied program. Keep this distinct from `Program.Correct`,
which describes execution plus exact-reference correction.

Current `Program.VC` actually executes `pr.run` and checks the exact recovered sum. Its
soundness theorem is valid, but automatic concrete checking is not symbolic analysis.
Do not implement `tc_certify` by evaluating that VC and relabeling its result as static.
`Program.Correct` also does not assert that the raw output meets an application tolerance.
Diagnostics and examples must identify whether they establish exact-reference correction,
an uncorrected error bound, or that the bound meets a requested tolerance.

Acceptance: an inspectable AST-to-schedule bridge, sound generated theorem, useful diagnostics,
and examples with meaningful acceptance/rejection checks. Verify that the certificate path
does not execute `evalBlock`, `runBlocks`, or the exact residual ledger. This frontend item
alone does not close F3 or constitute the verified application in F4.

### F3 — Prove bounds for changing-state loops and input families

Status: **complete for bounded fixed-input families and symbolic repetition**.
`runBlocks_of_scale_bound` and `Program.repeat_accurate_of_scales` derive changing-state
acceptance/error from operand scales and total count. The application discharges their
range and tolerance conditions; regressions demonstrate changing state and nonzero loss.
The older concrete `partialSumsCheck` still computes every group's exact ideal contribution
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

Status: **complete for the bounded ordered-dot schedule described above**. The
input-derived theorem, AST/public-run/original-ideal bridges, 87-case oracle comparison,
rejection analysis, and certification timing are delivered. It is a normalized row-column
contribution, with absolute tolerance `2^-11`; no CUDA kernel or relative-error claim follows. Add tile-level `mma`, matrix indexing, and a per-cell schedule mapping
theorem if the chosen application needs them; do not make matrix scaffolding an end in itself.

Acceptance: an end-to-end theorem against an independently defined mathematical result,
with discharged input conditions and a useful numerical guarantee. Evaluate multiple sizes
and input regimes, bound tightness, certification time, and rejected cases. Explain what the
proof enables beyond executing an exact oracle or replaying selected examples.
For an accuracy requirement `tolerance`, derive the numerical budget from the input
conditions and prove that it is at most `tolerance`; success of `tc_verify` alone does not
discharge that requirement. This application, rather than additional theorem declarations,
is the next substantive milestone for the program-verification claim.

### F5 — Optional external hardware validation

Status: **optional; outside formalization completion requirements**. The dedicated harness,
99 targeted vectors, independent model expectations, capture/replay tools, source
provenance, and 12 synthetic replay checks are delivered. CUDA compilation and
actual device runs have not occurred; see [VALIDATION.md](VALIDATION.md). No GPU
access or new measurement is required while Accurate Models is the specification
authority. Existing published vectors populate only the first group; the prepared
corpus would extend empirical coverage to later groups, ordering, cancellation,
signed zeros, and subnormals if external hardware validation is later pursued.

NVIDIA's [PTX WMMA specification](https://docs.nvidia.com/cuda/parallel-thread-execution/#warp-level-matrix-instructions-wmma-mma)
leaves accumulation order, rounding, and subnormal handling unspecified for FP16 and
BF16/TF32. The formalization takes those numerical choices from Accurate Models
and the pinned reference, rather than attempting to derive them from PTX.
The current 35,000-row replay cannot establish untested group ordering or boundary behavior,
and the signed-word accumulator refinement is not a refinement of the complete hardware
pipeline. Keep these limits visible in any end-to-end claim.

If this optional experiment is pursued, its evidence requires actual GPU runs with
device, instruction, compiler/settings, and raw input/output
bits recorded and replayable. Clearly separate expected model results from measurements.
Unmeasured cases remain labeled unmeasured; they do not block F1–F4, F6, or F8.
Tests strengthen external evidence but do not turn `Conforms` into a proved hardware fact.

### F6 — Implement and refine finite-precision EFT extraction

Status: **open; required for a practical correction-algorithm claim**. In
[EFT.lean](../TensorCore/Programs/EFT.lean), the range check uses
`retainedSum + sumQ lowParts`; `retained_add_low` proves that this equals `exactDot`.
Changing the expression did not remove exact reconstruction. Coarse parts, low parts,
overlap, and the predicate are still calculated with exact arithmetic.

B delivered a bounded primitive milestone: 11-bit significand multiplication and
24-bit splitting with 8-bit gaps, proved free of wrap and refined to independent
signed truncation/residual definitions. The reproducible 21,966-case coverage gate
preserves the baseline and adds bounded/tail/application samples. Actual nonzero-low
support gives diagnostic broad budget passes 86/24/1 versus 73/13/0; no broader
predicate is implemented or claimed sound. Encoded extraction, bounded overlap,
guard and consolidation, end-to-end refinement, a useful success family, and full
phase costs remain open. See `data/regressions/eft-handoff.json` for the milestone
contract and `eft-coverage.json` for current empirical results.

Implement the extraction, overlap calculation, guard, and final correction using explicitly
bounded machine operations, with proofs of representability, range, and refinement against
the existing exact specification. Exact `Rat` values may remain on the specification side.
The implementation must not obtain residuals from an exact trace or recompute the ideal to
decide whether it succeeds. If a different cost model is proposed, state and evaluate it
explicitly instead of calling it a finite-precision implementation.

Returning `none` when the predicate fails is a legitimate partial-procedure contract and
has measured passing coverage in the follow-up review above. It does not itself implement
extraction or establish a general acceptance guarantee. Preserve this honest failure
behavior and the subnormal counterexample; do not silently reintroduce exact fallback.
The paper's Algorithm 1 includes an exact fallback, while `tceft` implements the guarded
scalar branch only. A separate exact-reference procedure must not be presented as that
branch's finite-precision implementation.

Coverage acceptance criteria added by the follow-up review:

- Turn the three review cohorts into a reproducible check with recorded inputs or generator,
  seed, model failures, predicate acceptance, rejection reasons, and corrected-output
  comparisons. Existing block-oracle and device-output tests do not measure scalar coverage.
- Preserve both the all-passing published/near-one evidence and the broad finite-bit
  rejections. Add input regimes representative of the F4 application and prove success for
  a parameterized useful family; selected passing examples cannot replace that proof.
- Investigate whether choosing `supportExponent` from every raw term is unnecessarily
  restrictive compared with the binary support of the actual nonzero low components.
  Any broader predicate needs a soundness proof and adversarial checks. Do not merely relax
  the coefficient bound, remove rejected samples, or call a rejected sufficient check an
  incorrect arithmetic run.
- Report extraction, guard, and consolidation costs separately, including all exact or
  bounded integer work, and compare accuracy and operation cost with appropriate alternatives.
  Acceptance percentages alone establish neither performance nor typical workload coverage.

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

Status: **combined source artifact validated; final submission revision remains open**.
Both final handoffs and the integrated source hashes are recorded. The fresh combined
gate passed all 19 commands, including the certificate/application/EFT checks and
eight standalone examples: 148 build jobs, 772 theorem roots / 471 written,
zero Lean warnings, and two linker-path warnings. All generated reports come from
the same fresh run. `data/regressions/merge-report.json` pins the tested sources;
`/merge.md` records completion evidence and remaining limitations. This integration
is in the working tree; a final submission Git revision has not been created.
Align README, theorem map, assumptions, DSL,
validation, and paper claims. Compare explicitly with prior tensor-core formalizations as
well as the source numerical papers. Separate mathematical novelty, mechanization, and
empirical evidence; do not use theorem counts or regression counts as substitutes.

Acceptance: fresh build/audit and appropriate oracle, device replay, program, and example
checks; reproducible logs and source pins; accurate warning counts; and a clear account of
which application and extraction claims are actually delivered. New scalar/loop code needs
the relevant adversarial cases, not merely a rerun of old block-oracle tests. Do not disable
checks, remove regressions, or suppress warnings to manufacture a clean report.

Device replay here uses the existing published data and runs without a GPU. New
hardware measurements and CUDA compilation belong to optional F5 and are not
submission requirements for this formalization of the source model.

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
