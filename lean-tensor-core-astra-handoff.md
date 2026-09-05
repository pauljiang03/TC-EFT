# Astra handoff: formalizing the corrected tensor-core model in Lean

> Continuation note, 5 September 2026: start with [START_HERE.md](START_HERE.md)
> and [the current plan](tensor-core/docs/CURRENT_PLAN.md). They record the
> current implementation and supersede this document's future-work ordering.
> One invocation means one dot product with unnormalized products and block
> accumulation; generalize that unit first, then implement downstream uses.
> The original R4 midpoint expectation below is corrected in the current tests/docs.

**Prepared:** 4 September 2026  
**Purpose:** a standalone implementation and metaprogramming plan for Astra in a Codex terminal session.  
**Current state:** model specification and proof targets prepared; no Lean implementation or completed Lean proofs are delivered with this plan.

**Implementation update, 5 September 2026:** the first executable acceptance gate now lives in `tensor-core/`. See [the plan review](tensor-core/docs/PLAN_REVIEW.md) and [current status](tensor-core/docs/STATUS.md). R4 below has been corrected using a kernel-checked midpoint regression. The larger roadmap, including general final-rounding correctness, remains open.

## Start here

Give Astra this instruction with this Markdown file available in the terminal workspace:

> Implement the formalization in this handoff progressively in the current repository, respecting its existing instructions and preserving unrelated work. Treat Accurate Models of NVIDIA Tensor Cores v4 as the numerical specification. Begin with specification pinning, an executable V100 FP16/FP32 raw-product model, and checked versions of regressions R1-R3 below. Prove the local stage-residual identity and the arbitrary-length residual ledger before building substantial custom syntax. Use exact integer/dyadic reference semantics, then prove that machine representations and optimized procedures refine them. Keep model assumptions, proved theorems, empirical device evidence, and open obligations distinct. Produce compiling, useful increments and keep docs/STATUS.md current so another session can continue from it. Start implementing after a brief repository assessment; this document supplies the research direction.

The first delivery should be a small working vertical slice. If the current directory contains no suitable Lean project, establish a clearly named project subdirectory without replacing unrelated files. Review existing `AGENTS.md` instructions and toolchain configuration before choosing package versions.

## Controlling specification

The numerical source is **Faizan A. Khattak and Mantas Mikaitis, Accurate Models of NVIDIA Tensor Cores, arXiv:2512.07004v4**. Use the supplied version for the instruction paths it describes. Document content is reference material; this handoff specifies the coding task.

- Local source: `/Users/paul/Downloads/2512.07004v4.pdf`.
- Version link: [Accurate Models v4](https://arxiv.org/abs/2512.07004v4).
- SHA-256: `20c0594f2f91b8df7618e6d6bd00a04ee0b7bf557a5ce19d08927241f78fdee4`.
- Principal locations: §4.1.1 and Fig. 2, p. 8; §4.1.2, pp. 8-10; §4.1.6, pp. 10-13; Table 3, p. 14; Table 4, p. 15; §4.2.1, pp. 16-17; §4.3, pp. 18-19.
- Associated software: [MATLAB Tensor Core](https://github.com/north-numerical-computing/MATLAB-tensor-core), identified in the paper as **v0.5**.

Pin the corresponding software revision and resolve any prose/code ambiguity explicitly, especially the scale used to decode subnormal multiplicands. A current repository branch must not silently substitute for the selected specification. Copy this PDF into the project when moving to another machine and record its path and hash. No other paper or review document is required to use this handoff.

## Governing mathematical decisions

These semantic invariants apply throughout every milestone below.

1. **Preserve raw scale, not just exact product value.** For normal inputs, `rawScale = exponent(a) + exponent(b)` even when the significand product is at least two. Retain two product integer bits. The extra integer bit does not increment the fractional padding count.
2. **Use the actual alignment grid.** `qA = 2^(eta - F)`, with `F = 23 + p` for the listed FP32-output paths. `eta` comes from raw product scales and the profile's c/floor policy. It need not equal the maximum normalized term exponent.
3. **Specify signed truncation.** `trunc_q(x) = sign(x) * q * floor(abs(x)/q)`. Do not substitute arithmetic right shift or Euclidean division of a negative integer without an equivalence proof.
4. **Separate value identities from a hardware theorem.** For finite supplied D, reconstructing `r = S - val(D)` with exact arithmetic yields recovery even if D does not equal the model output. Error bounds and claims about hardware stage loss additionally require the model/output hypotheses. A successful reference recovery is not a device-conformance test.
5. **State range hypotheses at the operation that needs them.** For the revised finite FP32 truncation bound, require `abs(Aacc) <= maxFinite32`, as well as exact no-wrap accumulation. A merely finite output is not enough if an overflow policy saturates. For the finite-range exact rounding algorithm, require `abs(S) <= maxFinite(target)`; implement and prove overflow branches before extending it.
6. **Define zero explicitly.** Ignore zero contributions as specified when selecting an alignment maximum, handle an all-zero block without `max(empty)`, and never use a leading-bit exponent of zero. Nonzero subnormal FP32 c contributes scale -126. Full subnormal multiplicand support waits for the reconciled decoder; the initial normal/zero domain is explicit.
7. **Keep precision and range parameters separate.** Input significand precision, hardware output precision, fractional alignment precision, correction precision, and software integer width have different roles. Reference accumulator width labels are not automatically signed BitVec widths.
8. **Target an exact residual representation first.** A dyadic correction is not automatically a single FP32/FP64 value or a classical floating-point expansion. Prove representability or expansion invariants before assigning those interfaces.
9. **Use a separate exact oracle.** Form S directly from original input bits, not by running the correction formula. Compare model/device, implementation/reference, and correction/oracle separately.
10. **Compose actual encoded boundaries.** Later invocations receive encoded results. Hidden padding bits do not persist by assumption. Local correct rounding does not imply global correct rounding.

## Corrected block semantics and initial profiles

For one normalization group with K products and n=K+1 terms, define the ideal value

```text
S = val(c) + sum(i=1..K, val(a_i) * val(b_i)).
```

For normal nonzero inputs, decode `a=(-1)^sa * mu_a * 2^ea` and similarly b, with each mu in [1,2). Form the raw product `(sa XOR sb, mu_a*mu_b, ea+eb)`. Preserve the raw scale when the product significand is in [2,4). Zero products have an explicit branch. Subnormal multiplicands use a specified decoder rather than a guessed leading-bit exponent.

Select eta from raw product scales and the profile's c policy and floor. Set `qA=2^(eta-F)`. Including c as term n, compute

```text
u_i  = sign(t_i) * qA * floor(abs(t_i)/qA)
Aacc = sum_i u_i                       # exact signed integer/dyadic accumulation
D    = Output_theta(Aacc)              # encoded output, prescribed stage sequence
r_i  = t_i - u_i
rOut = Aacc - val(D)
S    = val(D) + rOut + sum_i r_i.
```

The initial V100 output operation normalizes and truncates toward zero to FP32, with its fixed subnormal quantum 2^-149. The finite output-error theorem assumes `abs(Aacc)<=maxFinite32`. Its output quantum is `2^(exponent(D)-23)` for normal D and `2^-149` for subnormal or zero D. Under the model and no-wrap hypotheses,

```text
abs(r_i) < qA
abs(rOut) < qOut
abs(S-val(D)) < n*qA + qOut.
```

This conservative bound counts both stages. The exact residual identity itself holds for any finite supplied D when the extractor reconstructs the exact quantities; applying the hardware error bounds additionally requires D to equal the model output.

| FP32-output profile | Products K | Terms n | Alignment integer/fractional bits | Reference accumulation width label | Relevant floor |
|---|---:|---:|---|---:|---|
| V100 FP16 | 4 | 5 | 2 / 23 | 28 | No relevant product floor listed |
| A100 FP16/BF16 | 8 | 9 | 2 / 24 | 30 | -132 in the small BF16 regime |
| A100 TF32/tf19 | 4 | 5 | 2 / 24 | 29 | -132 |
| H100/H200 FP16/BF16 | 16 | 17 | 2 / 25 | 32 | -133 in the small BF16 regime |
| H100/H200 TF32/tf19, maximum block path | 8 | 9 | 2 / 25 | 31 | -133; some WMMA paths use K=4 |

These entries come from the specified paper, especially Table 3; they are not complete profiles by themselves. Reference width labels require sign/carry interpretation before they become software BitVec widths. A100/Hopper floors matter for the specified tiny-product regimes with c=0; nonzero subnormal FP32 c contributes scale -126. Each opcode needs its own normalization grouping. Turing has no profile established by this source.

For FP16-output paths, preserve the exact reference sequence of FP32 normalization/truncation and subsequent FP16 nearest-even rounding. Exceptional-value behavior and instruction variants require additional explicit semantics before their domains are claimed.

### Exact consolidation and final rounding contract

For correction components `x_i=z_i*2^ell` with integer z_i, let `B=sum_i abs(z_i)`. A sufficient predicate for exact scalar summation in a format of precision P is

```text
2^ell >= minimumQuantum(format)
B < 2^P
B * 2^ell <= maxFinite(format).
```

Every prefix in every ordering then lies on the grid, fits the precision, and stays finite. Prove representability and apply correctly rounded scalar addition inductively. This predicate includes every component actually consolidated, including c and output residuals. An efficient input-only predicate must be derived from actual residual support.

First implement exact dyadic final rounding by quotient/remainder, nearest-neighbor selection, and parity at a tie. For nonzero finite-range S, use the quantum `2^max(floor(log2(abs(S)))-P+1, emin-P+1)`, compare twice the remainder with the quantum, and choose the even coefficient on equality. Handle zero explicitly. Prove any scalar-addition or expansion-based implementation returns the same target bits under its declared hypotheses.

## First executable regressions

All expected outputs here are **model predictions**, not new GPU measurements. Use actual FP16 input encodings and FP32 c/output encodings. The model scope for these cases allows normal inputs and explicit zeros.

### R1. Equal product values, different factors

```text
profile: V100, FP16 inputs, FP32 c/output, K=4, F=23
a = [3e00, 1000, 1000, 0000]
b = [3e00, 0c00, 0c00, 0000]
c = 00000000
expected D = 40100001
eta = 0, qA = 2^-23

change only a[0] = 3c00 and b[0] = 4080
expected D = 40100000
eta = 1, qA = 2^-22
```

Here the first product is `(3/2)*(3/2) = 1*(9/4)`. The next two products are `2^-11 * 2^-12 = 2^-23`. The ideal product list is identical in the two cases. Preserve the inequality of the model outputs as a checked regression theorem.

### R2. Exact alignment with zero residual

```text
a = [3e00, 3c01, 3c01, 3c00]
b = [3e00, 3001, 3001, 3000]
c = 3e000000
raw product scales = [0, -3, -3, -3]
eta = 0, qA = 2^-23
S = 11536385 / 4194304
expected D = 40300801
expected RN_even,FP32(S) = 40300801
reference residual = 0
```

All five exact terms lie on qA and S is FP32-representable. Consequently every alignment residual and the output residual is zero. Prove that the reference correction leaves D unchanged.

### R3. Alignment and output loss in the same block

```text
a = [3e00, 3e00, 3e00, 3e00]   # each 3/2
b = [3d00, 3d00, 3d00, 3d00]   # each 5/4
c = 3f7fffff                  # 1 - 2^-24
eta = 0, qA = q = 2^-23
Aacc = 17/2 - q
S = 17/2 - q/2
expected D = 4107ffff         # 17/2 - 8q
expected RN_even,FP32(S) = 41080000
alignment residual sum = q/2
output residual = 7q
abs(S - val(D)) = 7.5q
```

### R4. Foundational regressions

- RNE binade asymmetry (corrected during implementation, 5 September 2026): for `S=1-3*2^-25`, the two nearest FP32 values are `1-2^-23` and `1-2^-24`, both at distance `2^-25`. Ties-to-even selects `1-2^-23` (`3f7ffffe`). The original expectation `1-2^-24` was incorrect. Verify nearest-neighbor selection using actual adjacent spacing. See `tensor-core/docs/PLAN_REVIEW.md` and the checked `TensorCore.Regression.r4_binade_asymmetry` theorem.
- Cancellation: `1 - (1-2^-24) = 2^-24` is exactly representable. Do not justify scalar exactness by claiming all potentially shifted-out input bits were zero.
- Signed truncation: for q=1, `trunc(1-1/2)=0`, while `1+trunc(-1/2)=1`.
- RNE ties: exercise even/odd significand parity, carry into a new binade, the normal/subnormal boundary, and rounding to zero. Track signed-zero bits only after the chosen policy is defined.

## First working delivery: explicit acceptance gate

Before investing in the custom DSL, deliver:

- [ ] A pinned Lean package that builds from a clean checkout.
- [ ] A short source/profile decision log, including known domain restrictions.
- [ ] An executable reference evaluator on encoded FP16/FP32 inputs.
- [ ] An independent exact ideal-sum evaluator and an exact target rounding routine.
- [ ] Checked R1, R2, and R3 results, including their exact residual traces.
- [ ] A local theorem relating returned residuals to S and D.
- [ ] An induction theorem for the exact ledger over arbitrary finite lists of invocations.
- [ ] An assumption report for these theorem roots and a current status document.

Do not report this gate complete with `sorry`, a new axiom standing in for recovery, or only printed test output. If a definition is not yet executable, explain which theorem/result that blocks and continue independent foundation work. The later milestones are the roadmap for extending this working core.

---

# Full milestone roadmap

## 1. Define the first deliverable narrowly enough to prove

The first completed result should be:

> For the reference V100 FP16-input / FP32-output model and an explicitly stated finite domain, an executable correction procedure returns an exact expansion of the dot product. A proved final rounding procedure returns its FP32 round-to-nearest, ties-to-even value. A composition theorem extends the residual invariant to any finite number of invocations.

This is model-relative: the supplied Accurate Models v4 paper is the chosen numerical specification. Hardware measurements provide evidence connecting that specification to a device; they are recorded separately.

### Initial scope

- One globally aligned four-product V100 block, with FP32 c and output.
- Normal nonzero FP16 multiplicands and explicit zero branches first, so regression R1 is executable. Subnormal multiplicands are an explicit next milestone. Cancellation and zero outputs are handled deliberately.
- Finite-output hypotheses for real-valued error/EFT statements.
- Exact integer/dyadic arithmetic for the reference implementation.
- A chosen sequence of invocations whose accumulator is the encoded previous output.
- A deliberately simple reference correction procedure before an optimized extractor.

### Later scope

- A100 and H100/H200, including BF16/TF32 exponent floors and c=0/nonzero-subnormal distinctions.
- Instruction-specific grouping, conversions, and normalization boundaries.
- FP16 outputs with the exact reference output-stage sequence.
- Blackwell, FP8 paths, and other modes once the common theory is stable.
- Program transformations, compensated algorithms, and architecture comparisons.
- CUDA/PTX/SASS implementation refinement and asynchronous/memory semantics as separately scoped work.

**Turing remains uninstantiated until its profile is established.** The chosen accurate-model reference does not characterize it. Do not borrow a configuration from Volta or Ampere by assumption.

## 2. Use one semantic source of truth

~~~text
Encoded operands and configuration
                  |
                  v
Raw multiplication -> alignment -> exact signed accumulation -> output encoding
                  |
                  v
Exact-value bridges, residual identities, numerical contracts
                  |
                  v
Program semantics: sequence, conversion, scalar operations, loops, schedules
                  |
                  v
Proof automation: specialization, symbolic execution, certificates, VC generation
~~~

The semantics are ordinary Lean definitions. Architecture declarations and program syntax elaborate into explicit configuration records and program terms. Metaprograms apply and assemble proofs about those definitions.

Avoid maintaining independent handwritten Lean, SMT, and simulator semantics. A later SMT exporter should come from the same intermediate representation, with a translation theorem or a checked correspondence. A solver result alone is not a Lean theorem.

## 3. Proposed module outline

The names below are proposed project modules, not claims that these libraries already exist.

~~~text
TensorCore/
  Foundations/
    Format.lean
    Encoding.lean
    Dyadic.lean
    Truncation.lean
    Rounding.lean
    ExactSum.lean
  Semantics/
    RawProduct.lean
    Alignment.lean
    Accumulator.lean
    Output.lean
    Block.lean
    Config.lean
  Profiles/
    V100F16F32.lean
    A100F16F32.lean
    A100BF16F32.lean
    A100TF32F32.lean
    H100F16F32.lean
    H100BF16F32.lean
    H100TF32F32.lean
  Theory/
    Representation.lean
    StageResiduals.lean
    ErrorBounds.lean
    Monotonicity.lean
    EFTReference.lean
    EFTOptimized.lean
    CorrectRounding.lean
  Programs/
    Syntax.lean
    Eval.lean
    Contracts.lean
    Composition.lean
    Loops.lean
    MatrixSchedules.lean
  Meta/
    ArchitectureElab.lean
    ProgramElab.lean
    RangeCertificates.lean
    SymbolicExecution.lean
    VerificationConditions.lean
    Verify.lean
  Regression/
    EqualProductFactorizations.lean
    ExactAlignment.lean
    TwoStageLoss.lean
    Cancellation.lean
    SubnormalFloors.lean
    InvocationBoundaries.lean
  CaseStudies/
    CorrectedDotProduct.lean
    TiledGEMM.lean
    ExistingCorrectionAlgorithms.lean
~~~

Dependencies flow from foundations to semantics to theory/programs. Meta imports those layers; the model and generic theorems do not depend on custom notation.

## 4. Milestone 0: freeze the specification and inventory the available libraries

### Tasks

- [ ] Record the supplied PDF version, file hash, and page/section references.
- [ ] Find and pin the paper-associated MATLAB Tensor Core v0.5 commit/tag, or document if the mapping cannot be established.
- [ ] Inspect its decoder, sign handling, zero treatment, alignment, grouping, and output stages.
- [ ] Resolve any prose/code ambiguity explicitly. A current repository main branch must not silently replace the supplied v4 paper.
- [ ] Create a behavior table with one row per instruction/format path.
- [ ] Separate physical/model assumptions from claims that will be proved inside Lean.
- [ ] Pin Lean, mathlib or other dependencies, and solver versions.
- [ ] Inventory the current Lean floating-point/dyadic facilities and relevant numerical lemmas. Assess what can be reused; do not assume either that Lean has no FP support or that native Float is a sufficient formal tensor-core model.
- [ ] Review Flocq's available theorems as a checklist for the arithmetic infrastructure needed in Lean, without creating a second full formalization.

### Architecture record requirements

Record at least:

- Input and output formats.
- Products per normalization group; do not confuse this with the API tile shape.
- Product representation and input-decoding policy.
- Fractional alignment precision and product integer capacity.
- Accumulator representation and required carry capacity.
- Exponent floor and c policy.
- Alignment truncation policy.
- Grouping, order, and c insertion point.
- Output-stage sequence and exception policies.
- Source version and supporting evidence.

Only include fields that have explicit semantics. Boolean fields with suggestive names but no defined behavior are not a specification.

### Exit criterion

A reviewed V100 profile and a trace specification explain both the reference factorization witness R1 and the exact-grid case R2. The project's model assumptions and known scope gaps are listed.

## 5. Milestone 1: build an executable V100 reference model

### Data design

Keep the following types distinct:

1. Encoded external floating-point values.
2. Decoded input components.
3. Raw products with exact scale and significand information.
4. Aligned signed integers at a common quantum.
5. Exact mathematical values and residuals.

For normal operands the raw product exponent is the sum of the input exponents. A significand product at least two remains unnormalized into alignment. A valuation can equate two representations without making them interchangeable as pipeline states.

Use arbitrary-precision integers in the first accumulator. A separate fixed-width implementation comes later with an equivalence theorem.

### Tasks

- [ ] Implement exact decode and encode operations for the initial formats.
- [ ] Define raw multiplication and prove its exact valuation.
- [ ] Select eta from raw products and c.
- [ ] Define q_A=2^(eta-F), magnitude truncation, sign application, and exact accumulation.
- [ ] Implement normalization and the specified FP32 output policy.
- [ ] Return an optional diagnostic trace: raw exponents, eta, aligned coefficients, discarded remainders, accumulator, output bits.
- [ ] Give zero products and zero c explicit branches.
- [ ] Add a total representation for special cases even if numerical theorems initially require finite values.

### Regressions

- [ ] Reference equal-product/different-factorization witness R1.
- [ ] R2: input half bits and FP32 c reproduce output 0x40300801 with zero residual.
- [ ] R3: both alignment and output residuals match the exact trace.
- [ ] Fixed-grid cases with exactly representable aligned sums and outputs.
- [ ] Cancellation and power-of-two boundaries.

### Exit criterion

The reference evaluator is executable and the concrete regressions are proved by checked evaluation or finite proofs. Small-format exhaustive comparisons can supplement the proofs but must not replace the actual FP16/FP32 witnesses.

## 6. Milestone 2: prove the representation and arithmetic bridges

### Principal theorem inventory

- [ ] Raw multiplication preserves exact product value.
- [ ] Alignment produces an integer coefficient on q_A.
- [ ] Each alignment residual is exactly the input value minus its aligned value.
- [ ] Each residual has the required sign and magnitude bound for the selected truncation rule.
- [ ] Integer accumulation equals the sum of aligned values.
- [ ] A fixed-width accumulator agrees with the integer accumulator under proved width/range conditions.
- [ ] Output encoding realizes the specified normalization/truncation/rounding policy.
- [ ] Signed zero, subnormal output, and overflow classification are handled by explicit cases.
- [ ] The scalar RNE specification implements tie-to-even and the correct behavior at binade boundaries.
- [ ] Scalar exactness follows from representability and the rounding specification.

### Important design constraints

- A magnitude width in a paper diagram is not automatically a two's-complement width.
- Prove arithmetic right shift versus magnitude truncation behavior rather than identifying them.
- Do not model a raw wide product as a scalar FP32 multiplication.
- Keep output precision separate from the precision used to accumulate corrections.
- Define zero and subnormal exponents through an explicit convention; do not call a leading-bit exponent on zero.
- Record overflow assumptions on operations and accumulations, not only on inputs.

### Exit criterion

The integer reference model and fixed-width model are related by a theorem on the declared domain. A single block has both executable semantics and an exact-value interpretation.

## 7. Milestone 3: establish a correct EFT before optimizing it

### Reference contract

For exact terms t_i, aligned values u_i, exact accumulator A, and encoded output D, define

\[
r_i=t_i-u_i,\qquad r_{\rm out}=A-v(D).
\]

Prove

\[
\sum_i t_i=v(D)+r_{\rm out}+\sum_i r_i.
\]

The first reference extractor may reconstruct the aligned sum exactly. That establishes correctness and gives an oracle for a cheaper method; it is not yet a performance result.

### Tasks

- [ ] Implement an extractor returning an exact expansion or integer-dyadic residual.
- [ ] Prove the extractor's returned value equals the residual in the contract.
- [ ] Prove finite error bounds from the two stages before attempting sharp bounds.
- [ ] Investigate a coarse-grid extractor using q_A and a justified q_E, with its refinement theorem stated before optimizing it.
- [ ] Prove its window, mask, carry, and signed-reconstruction lemmas.
- [ ] Find counterexamples when an intended lemma needs stronger hypotheses.
- [ ] Prove an optimized extractor refines the reference extractor.
- [ ] Prove the new exact-summation predicate using actual residual bit support and exponent range.
- [ ] Prove final rounding equals RN_even of the exact sum.
- [ ] Produce a precise operation ledger after the implementation is fixed.

### Dependency map

| Result | Required foundations |
|---|---|
| Raw model | Encodings, decoder valuation, raw scales, profile policies |
| Residual identity and bounds | Grid truncation, exact accumulation, output specification |
| Optimized extraction | Reference residual semantics, masks, signed arithmetic |
| Exact consolidation and RNE | Representability, scalar rounding, range and support bounds |
| Multi-invocation correctness | Local contracts, encoded boundaries, exact residual ledger |

### Exit criterion

The V100 EFT theorem is proved under explicit hypotheses. R2 returns 0x40300801 with zero residual. Finite output-error bounds require the stated accumulator range; direct finite-range rounding requires the stated range of the reconstructed exact sum. Efficient implementations receive precisely the scope established by their refinement proofs.

## 8. Milestone 4: compose invocations and prove loops

Treat one arithmetic invocation as

\[
d_{k+1}=\operatorname{TC}_\theta(a_k,b_k,d_k).
\]

Prove the local extractor computes r_k satisfying

\[
v(d_k)+\langle v(a_k),v(b_k)\rangle=v(d_{k+1})+r_k.
\]

Then prove by induction, for arbitrary finite N,

\[
v(d_0)+\sum_{k<N}\langle v(a_k),v(b_k)\rangle
=v(d_N)+\sum_{k<N}r_k.
\]

This is a theorem schema for every N, not an enumeration of a fixed number of calls.

### Program operations to model

- Tensor-core block invocation and instruction-level grouping.
- Scalar add/subtract and format conversions.
- Exact powers-of-two scaling, with representability/range conditions.
- Sequence, bounded iteration, and explicit accumulation order.
- Matrix indexing and fragment-to-logical-value mapping at the level needed by the case study.
- Correction expansions or residual accumulators.

### Tasks

- [ ] Define ordinary program semantics before a custom DSL.
- [ ] Prove sequential composition of numerical contracts.
- [ ] Prove the uncorrected accumulation residual ledger.
- [ ] Prove an invariant for the chosen exact expansion of accumulated residuals.
- [ ] Account for conversion and scalar-rounding residuals.
- [ ] For algorithms that modify d_k by applying corrections between calls, prove the invariant for that actual updated state.
- [ ] Prove final correct rounding for a long dot product.
- [ ] Lift one-cell reasoning to a specified matrix schedule.
- [ ] Prove when an instruction decomposes into blocks and when schedules can be exchanged.

### Boundary rules

- A completed invocation supplies its encoded output to the next one unless the instruction specification explicitly says otherwise.
- Internal carry/padding bits do not persist across an invocation boundary by assumption.
- Correctly rounding each block is insufficient for a globally correctly rounded dot product.
- If later multiplicands depend on previous rounded outputs, relate the actual and ideal program states; the simple fixed-input dot-product identity alone does not establish an arbitrary algorithm's correctness.
- Timing, synchronization, races, and compiler lowering require additional semantics before claiming correctness of an actual GPU kernel.

### Exit criterion

A theorem covers an arbitrary number of invocations and a concrete corrected dot-product program. One fixed tiled-GEMM schedule has a clear proof path from the single-cell contract.

## 9. Milestone 5: add Lean metaprogramming as a proof engine

Add automation after several representative proofs establish the right reusable lemmas.

### A. Architecture declarations

- [ ] A declaration elaborates to an explicit Config value and checked well-formedness evidence.
- [ ] Reports display the chosen opcode/profile, formats, grouping, widths, and policies.
- [ ] The command refuses unsupported field combinations instead of inventing semantics.
- [ ] Generated declarations are ordinary inspectable definitions.
- [ ] Generic theorems specialize to profiles using proved premises, rather than duplicating proofs.

### B. Program language

Use a small typed program AST with operations for tensor-core blocks, scalar arithmetic, casts, sequencing, and loops. Custom syntax elaborates to that AST.

Keep an independent, ordinary Lean evaluator for the AST. The AST makes it possible to inspect the exact invocation schedule that a theorem concerns.

### C. Symbolic execution and range analysis

- [ ] Symbolically execute the AST through already-proved block contracts.
- [ ] Track value ranges, scale exponents, support intervals, exact-grid membership, and residual expansions.
- [ ] Generate side conditions for shift bounds, accumulator width, overflow, exact summation, and final rounding.
- [ ] Use sound integer/rational bounds; do not import a standard relative-error axiom that is false for the tensor-core operation.
- [ ] Allow user-supplied invariants at loops.
- [ ] Use induction over symbolic loops rather than unrolling arbitrary N into SAT.

### D. Verification-condition generation

The verifier should generate propositions whose validity implies a program specification. Prove a soundness theorem for the VC generation/checking layer.

A proposed user-facing command might ask to verify a corrected dot-product program for a particular profile, using a chosen invariant. The name and syntax can be decided later. What matters is the output:

1. The exact program and architecture configuration.
2. The theorem statement and preconditions.
3. A completed proof, or explicit remaining obligations.
4. Counterexamples only when the search actually finds and checks one.

No tactic should turn an unresolved hardware assumption into a proved fact.

### E. Automation selection

| Obligation | Preferred technique |
|---|---|
| Fixed-width masks, bit extraction, bounded shift identities | BitVec lemmas and selected bv_decide calls |
| Integer ranges and carry bounds | Simplification and integer arithmetic automation |
| Exact dyadic residual identities | Algebra plus quotient/remainder lemmas |
| Rounded scalar operations | Reused or developed rounding specifications |
| Architecture specialization | Generic theorem application |
| Arbitrary invocation counts | Induction and loop invariants |
| Concrete failure witnesses | Exact evaluation plus checked counterexample theorem |
| Whole-program property | Sound VC generation plus local contracts |

Lean supports custom elaborators/tactics and bitvector automation; these are mechanisms to build on, not a pre-existing tensor-core verifier. See the [elaborator documentation](https://lean-lang.org/doc/reference/latest/Notations-and-Macros/Elaborators/) and [bitvector reference](https://lean-lang.org/doc/reference/latest/Basic-Types/Bitvectors/).

### Trust and reproducibility

- [ ] All semantic choices are explicit in definitions or named model assumptions.
- [ ] Completed theorem roots are checked for unexpected axioms and placeholders.
- [ ] External solver certificates are checked; do not trust an unvalidated UNSAT string.
- [ ] Document the actual trust boundary of the tactic stack. The documented bv_decide implementation uses compiled certificate checking and Lean.ofReduceBool, so its compiler dependency is not described as kernel-only.
- [ ] Pin versions and retain relevant certificates or reproducible proofs.
- [ ] Inspect generated statements as well as successful proof checking: a checked proof of a mis-elaborated specification would still be the wrong theorem.
- [ ] Benchmark realistic local goals before committing to an automation strategy.

The [bv_decide implementation documentation](https://lean-lang.org/doc/api/Lean/Elab/Tactic/BVDecide.html) describes certificate checking and its trust assumptions. Existing Lean program-verification facilities, including [mvcgen](https://lean-lang.org/doc/reference/latest/The--mvcgen--tactic/), should be assessed for reuse before implementing a separate Hoare/VC framework.

### Exit criterion

One new program in the supported fragment can be verified largely by composing existing contracts. The generated obligations and proof assumptions are visible, and unsupported cases remain explicit.

## 10. Milestone 6: broaden profiles and revisit sharp theory

### Architecture expansion

- [ ] Add A100 and H100/H200 profiles with explicit K and F.
- [ ] Add BF16/TF32 operand decoding, wide product exponents, and tiny products.
- [ ] Implement and prove alignment floors and c special cases.
- [ ] Add output underflow/overflow and zero-result branches.
- [ ] Distinguish TF32 instruction paths that use different block widths.
- [ ] Verify FP16 output conversion sequences separately.
- [ ] Add FP8 conversions/groupings only with dedicated profile semantics.
- [ ] Reuse generic proofs wherever their hypotheses are met.

### Numerical research

- [ ] Define the monotonicity relation before proving a threshold.
- [ ] Separate c perturbation, one-factor perturbation, and internal raw-state perturbation.
- [ ] Constrain counterexamples to realizable input-format operands.
- [ ] Prove necessary and sufficient conditions separately.
- [ ] Distinguish maximum input decrease from maximum output increase.
- [ ] Study padding changes as parameterized transformations, not assumed accuracy improvements.
- [ ] Prove sharper error bounds using the corrected stage semantics.
- [ ] Identify conditions under which different architectures or schedules return equal bits.

### Case studies

1. **Exact correction:** verified extraction, exact consolidation, correct rounding.
2. **Profile reuse:** instantiate a second instruction/format profile and reuse the generic contracts, proving its remaining premises.
3. **Long dot product / tiled GEMM:** show the practical value of the multi-invocation theorem.
4. **Optimization equivalence:** prove a chosen program rewrite preserves bits or satisfies a stated error relation.

### Exit criterion

At least two substantially different profiles reuse the same semantic/theorem infrastructure, and at least one program-level case study uses more than a single invocation.

## 11. Validation strategy

Maintain three separately named comparisons.

| Comparison | Purpose | What it establishes |
|---|---|---|
| Lean implementation vs Lean reference semantics | Validate optimized computation | A formal refinement/equivalence theorem |
| Chosen model vs device trace | Validate empirical correspondence | Evidence for the model-to-hardware assumption |
| Corrected result vs independent exact dot product | Validate EFT result | Tests plus the formal recovery/rounding theorem |

### Test corpus

- the reference paper's targeted examples and available paper-associated validation vectors.
- Exact-grid case R2 and two-stage loss case R3.
- Equal products obtained from different factors.
- Normalization crossings with retained/discarded low bits.
- Positive and negative terms, cancellation, and exact zero.
- Zero c versus a nonzero subnormal c.
- Values around the -132 and -133 alignment floors.
- Products outside FP32's finite/subnormal range with finite final sums.
- FP32 RNE ties and binade boundaries.
- Reordering within a block versus changing block boundaries.
- A correctly rounded local result that still loses information needed globally.

For a hardware trace, record input/output bits, device, instruction, shape, format, relevant compilation settings, and normalization grouping. For an oracle, sum products directly from the actual input encodings using exact dyadics or justified MPFR precision, then round once.

Concrete CUDA/PTX/SASS implementations require separately supplied source and compilation metadata before an implementation-refinement claim can be made.

## 12. Acceptance checklist

### Mathematical result

- [ ] Corrected raw-product semantics match the chosen specification.
- [ ] R1-R3 are established by checked examples and exact traces.
- [ ] Local executable extraction satisfies an exact residual identity.
- [ ] Consolidation and final RNE have explicit, proved preconditions.
- [ ] Arbitrary-length composition is proved.
- [ ] Unsupported generalizations and hardware assumptions are named.

### Tooling result

- [ ] Architecture descriptions elaborate to inspectable data.
- [ ] Program descriptions have ordinary Lean semantics.
- [ ] Automation applies proved rules and reports residual obligations.
- [ ] Fixed-width optimizations refine the reference.
- [ ] Dependency versions and theorem axioms are recorded.

### Research artifact result

- [ ] Every claimed result maps to a checked theorem or a precisely labeled empirical observation.
- [ ] Executable algorithms, profile tables, and theorem domains are documented.
- [ ] Accuracy/cost/monotonicity claims match the proved scope.
- [ ] Model-level theorems are distinguished from device validation.
- [ ] The artifact includes one compelling example of proof reuse across invocations.

## 13. Immediate next work package

The first work package is deliberately concrete:

1. Pin the source specification and establish the V100 profile.
2. Encode the three exact regression traces R1-R3.
3. Define raw multiplication, actual alignment, integer accumulation, and output truncation.
4. Prove their valuation bridges.
5. Implement a simple exact residual extractor.
6. Prove the local identity and arbitrary-length accumulation invariant.

Only after this package succeeds should the project invest heavily in a custom DSL or claim the optimized TC-EFT cost. It establishes both the corrected arithmetic foundation and the essential beyond-one-invocation result.

## References for implementation choices

- Supplied *Accurate Models of NVIDIA Tensor Cores*, arXiv:2512.07004v4, especially §§4.1-4.3 and Tables 3-4.
- [Lean elaborators and custom tactics](https://lean-lang.org/doc/reference/latest/Notations-and-Macros/Elaborators/).
- [Lean bitvectors](https://lean-lang.org/doc/reference/latest/Basic-Types/Bitvectors/).
- [Lean BVDecide implementation and trust boundary](https://lean-lang.org/doc/api/Lean/Elab/Tactic/BVDecide.html).
- [Lean mvcgen](https://lean-lang.org/doc/reference/latest/The--mvcgen--tactic/).
- [Flocq concepts and theorems](https://flocq.gitlabpages.inria.fr/theos.html), as an arithmetic-library planning reference.

## 14. Concrete semantic interfaces

These are design sketches, not claims of existing or compiling Lean APIs. Decide the exact types after the library inventory; preserve the distinctions.

| Object | Essential fields or meaning | Critical invariant |
|---|---|---|
| `Format` | Precision, exponent limits, encoding widths, classification | Encoding and numerical precision are distinct |
| `Encoded f` | A fixed-width external bit pattern | Decode classifies zero, subnormal, normal, infinity, NaN |
| `DecodedInput` | Sign, integer significand, raw scale, fractional-bit count | Its valuation equals the encoded input value |
| `RawProduct` | Sign, integer product significand, raw scale sum, fractional-bit count | Valuation is exact; raw scale is not normalized away |
| `AlignedTerm` | Signed integer coefficient and common quantum exponent | Valuation equals magnitude truncation on qA |
| `BlockTrace` | Raw products, eta, aligned coefficients, exact accumulator, output | Trace fields are derived from the evaluator, not independent guesses |
| `ResidualRep` | Exact dyadic or expansion with a valuation | Valuation equals the claimed correction |
| `Profile` | Executable decoder/alignment/output policies and shape | Every semantic field has an explicit interpretation |
| `Program` | Typed operations and explicit invocation schedule | Evaluator exposes conversions and encoded boundaries |

An integer representation can value a raw product as

```text
(-1)^sign * significandInteger * 2^(rawScale - fractionalBits).
```

For normal inputs, `rawScale` is the sum of input unbiased exponents and `fractionalBits` is the sum of their significand fractional widths. Canonicalizing the *dyadic value* is fine; canonicalizing away the separate *rawScale used for hardware alignment* loses information required by the hardware alignment semantics.

Start with exact integer/dyadic or rational valuations. A bridge to real-valued analysis can come later. Do not force every executable calculation through Lean `Real`, and do not use native machine `Float` evaluation as the mathematical specification. Keep the no-wrap reference accumulator as `Int` before refining to a fixed-width implementation.

### Named theorem targets

Use stable, descriptive theorem names, with statements equivalent to the following. The displayed text is mathematical pseudocode.

```text
rawProduct_value:
  val(rawMul(a,b)) = val(a) * val(b)

alignment_value:
  val(align(raw,qA)) = trunc_qA(val(raw))

alignment_residual:
  t = val(align(t,qA)) + residual(t,qA)
  and abs(residual(t,qA)) < qA

accumulator_refines_int:
  noWrap(profile, terms) -> fixedWidthSum(terms) agrees with integerSum(terms)

block_residual_identity:
  exactDot(a,b,c) = val(D) + val(extractReference(profile,a,b,c,D))

block_error_bound:
  modelOutput(D) and noWrap and abs(Aacc) <= maxFinite32
  -> abs(S-val(D)) < n*qA + qOut

extractOptimized_refines_reference:
  admissible(profile, inputs, D)
  -> val(extractOptimized(...)) = val(extractReference(...))

finalRound_correct:
  admissibleRound(D,E) -> finalRound(D,E) = RN_even_target(val(D)+val(E))

fold_residual_ledger:
  for every finite schedule with applicable local contracts,
  val(d0) + sum(exactProductsAtEachStep) = val(dN) + sum(localResiduals)
```

For all-zero inputs, return a total classified result and define its numerical value without evaluating a logarithm or a maximum of an empty list. Bit equality for signed zeros is a stronger target than value equality; give it its own policy and proof.

## 15. Metaprogramming implementation sequence

### Step A: prove examples using ordinary Lean terms

First write a profile definition, one reference block, one corrected block contract, and a two-block program without custom syntax. This reveals which facts genuinely recur. Avoid building a large language whose verification rules have not yet been established.

### Step B: generate transparent profile declarations

A profile declaration may generate a `Profile` value, named well-formedness propositions, and specializations of existing generic theorems. It must print or expose the selected fields. If a well-formedness premise cannot be proved, retain the obligation rather than emitting a theorem with an invented axiom. Do not offer an architecture name whose instruction semantics are unspecified.

### Step C: elaborate a small program language

Begin with typed tensor-core block calls, scalar arithmetic, conversions, sequencing, and bounded loops. Custom syntax should elaborate to an inspectable ordinary AST. Use explicit source locations for every call so diagnostics can identify which invocation needs a range, grid, or conversion condition.

Maintain a normal executable evaluator. Show the elaborated profile and program in regression tests: successful proof checking cannot detect that an elaborator constructed the wrong intended program if its generated statement is also wrong.

### Step D: symbolic contracts and obligations

Track only sound facts: signed ranges, integer coefficient bounds, grid membership, exponent/support intervals, format classifications, and residual valuations. At each operation apply a proved contract, then generate its side conditions. Distinguish a sufficient condition that automation cannot establish from a disproved program property.

For a loop, request or infer an invariant and prove its base and preservation cases. Do not encode an arbitrary symbolic invocation count by finite unrolling. If later operands depend on previous outputs, carry a relation to the ideal state rather than reusing the fixed-input dot-product theorem beyond its scope.

### Step E: proof production and reflection

There are two legitimate designs:

- A metaprogram assembles ordinary proof terms by applying established lemmas. Lean checks the produced proof; the metaprogram need not itself be proved correct to obtain that assurance about the resulting statement.
- A reflected checker evaluates certificates. Prove the checker's soundness theorem and connect its accepted certificates to the intended program specification.

Do not demand a formal proof of every elaborator implementation as a prerequisite, and do not treat unchecked solver output as a proof. For a VC generator, establish that satisfying the generated conditions implies the desired program contract. Assess Lean's existing `mvcgen` facilities against the required fragment before implementing a separate system.

### Step F: stable user-facing verification result

Every verification command should expose:

1. The exact profile and elaborated program.
2. The theorem statement, domain, and requested rounding target.
3. Completed obligations and remaining conditions with source locations.
4. The assumptions of completed theorem roots.
5. Checked counterexample inputs when available, or an explicit unknown/timeout status.

A timeout is not a counterexample. A failed sufficient range bound does not establish an actual overflow. A hardware-conformance assumption is not an arithmetic theorem.

## 16. Proof trust and practical automation

Use algebraic lemmas and integer reasoning for the main parametric theory; reserve bit blasting for bounded local facts such as masks, decoding, and shifts. Validate concrete examples by checked evaluation or finite proof. Benchmark a small set of representative goals before committing to a solver backend.

Keep these distinctions in the project's trust report:

- Ordinary proof terms checked by Lean.
- Compiled evaluation/reflection mechanisms and their actual dependencies.
- External SAT/SMT search, certificate production, and certificate checking.
- Empirical assumptions connecting a mathematical profile to hardware.

The current [BVDecide documentation](https://lean-lang.org/doc/api/Lean/Elab/Tactic/BVDecide.html) describes LRAT certificate checking and a compiler dependency for compiled reflection. Inspect the pinned implementation and resulting axioms; do not call this whole path “kernel-only.” Keep `debug.skipKernelTC` disabled. Retain certificates or reproducible proof scripts as appropriate. A fresh unchecked `axiom`, `sorryAx`, or disabled checking is not an acceptable way to close a required theorem.

The [Lean elaborator reference](https://lean-lang.org/doc/reference/latest/Notations-and-Macros/Elaborators/) documents command, term, and tactic extensions. This plan proposes a tensor-core layer built using those mechanisms; it does not claim one already exists.

## 17. Repository records and continuation protocol

Add these records as the project becomes concrete:

```text
docs/SPECIFICATION.md        Source versions, policy decisions, profile evidence
docs/STATUS.md               Completed proofs, current work, next executable task
docs/ASSUMPTIONS.md          Theorem domains, axioms/trust, hardware assumptions
docs/THEOREM_MAP.md          Numerical contract -> hypotheses -> Lean declaration
docs/VALIDATION.md           Model/device, implementation/reference, correction/oracle
data/regressions/            Input bits, expected outputs, exact values, provenance
lean-toolchain              Pinned Lean version
lake-manifest.json          Resolved dependency revisions
```

Map each numerical contract to its Lean declaration, profile, domain, and proof status. Keep the current work package focused on the executable semantics, local proofs, and composition theorem.

At each completed increment, update `STATUS.md` with the actual theorem declarations, tests/build command and result, known assumptions, and the next concrete obligation. Preserve counterexamples to rejected statements. If a statement is false, record the checked witness and revise the claim; do not add an unexplained precondition merely to make a solver succeed.

Completion of the entire research direction is broader than the first delivery. The useful end state is a reusable semantic and proof infrastructure: several validated profiles share generic arithmetic contracts, an optimized correction refines the reference where its hypotheses apply, and a new multi-invocation program can be verified by composing those contracts. Full GPU-kernel correctness, additional architectures, and an optimized universal EFT remain separately scoped until their semantics and proofs exist.
