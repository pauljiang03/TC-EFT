# Current plan — general single-invocation formalization first

Updated 5 September 2026 after reviewing the repository, Accurate Models v4,
the revised TC-EFT paper, and the user's latest scope decisions. This document
supersedes the future-work ordering in [PLAN_REVIEW.md](PLAN_REVIEW.md),
[PTX_BOUNDARY.md](PTX_BOUNDARY.md), and the original Astra handoff.

**Priority:** finish the general parameterized semantics and proofs for one
tensor-core arithmetic invocation: a single dot product formed from
unnormalized products and a block accumulation, with its specified alignment
and output behavior. Then use that contract for downstream
reasoning. EFT is one separate mathematical application of the invocation
model; it does not define the scope of the whole project.

**Current stop point:** prepare the repository for a new context. This
increment ends after documentation and handoff preparation. The next session
should use [CONTEXT_HANDOFF.md](CONTEXT_HANDOFF.md) and start with step 1 below
when asked to resume.

## Review findings

The project already has a useful exact arithmetic core, V100 finite FP16/FP32
evaluation, general finite-range FP32 RNE proofs, error bounds, reference
residuals, and a restricted DSL. Existing generic block theorems range over
`Profile`, but that record only varies input format, product count, alignment
fraction, and floor. c/output are FP32, alignment is signed truncation, c is
included in the common alignment, and output is a single RTZ conversion.
This is not yet a general model of all the feature families in Accurate Models.

The previous plan put further instruction mapping, scalar EFT, or program
extensions ahead of completing this primitive. The revised order makes the
invocation abstraction and its feature coverage the first completion gate.
Retain the existing schedule/DSL proofs; pause expansion of that layer.

## Define the unit and the scope

The user explicitly defines **one invocation as one dot product with
unnormalized products and a block accumulation**. Its ideal value is
`S = value(c) + sum_i(value(a_i) * value(b_i))`; its computed output follows
the feature set's raw-product, alignment, accumulation, and output stages.
The existing `evalBlock` has this unit: four products plus c in one globally
aligned normalization group for V100. The paper calls the product count
`N_FMA`. `examples/SingleInvocation.lean` demonstrates this unit.

Keep that boundary fixed. A single invocation is not being redefined as a
complete WMMA/PTX instruction or a matrix tile. Multiple normalization groups,
their ordering, and their mapping to a larger instruction are later composition
work. No instruction-level wrapper or fragment mapping is required to complete
the single-dot-product arithmetic model.

Within this unit, specify the stages needed by each feature family, including
c placement and any ordered output conversions. Those local arithmetic stages
belong in the first gate. Sequencing completed invocations, physical
lane/register layout, and compiler lowering remain downstream work.

“All parametric feature sets” means theorems quantified over all well-formed
combinations of the supported numerical features, not separate copied proofs
for each GPU. Define that supported universe explicitly. Add distinct semantic
variants where a numeric parameter cannot express a behavior. Unsupported or
uncharacterized behavior must remain visible; a free field or a GPU name is
not a specification or a hardware-conformance proof.

## First completion gate — the parameterized invocation

### 1. Build a feature coverage matrix and contract

Inventory Accurate Models v4 §§2, 4.1–4.2, architecture figures and Tables 2–4 against
the pinned v0.5 code. Record each feature's meaning, source, applicable paths,
current definition, missing proof, and accepted domain. Reconcile discrepancies
before implementing a new variant. This is the **next concrete task**.

| Feature axis | Required semantics / proof obligation |
| --- | --- |
| Operand format and storage | Parameterized encoded widths, finite/special classifications, exponent bias, significand precision, and numerical values; separate a TF32 value format from its register representation or input conversion. FP8 E4M3 cannot simply inherit the current IEEE-style special-exponent decoder. |
| Operand preparation | Explicit zeros/subnormals and any conversion or flush policy. Conversion loss belongs to that stage, not silently to exact multiplication. |
| Product representation | Signed significand multiplication, scale/fraction-width sums, raw versus normalized metadata, and any actual product rounding stage. Preserve unnormalized products for the characterized paths. |
| Block size and c | Products in this one block, common-alignment membership, c format and insertion stage. Cover late-c paths separately from c-in-the-group. Ordering multiple blocks is outside this invocation. |
| Alignment | Fractional precision, integer capacity, extra bits, exponent selection/floor, sign-correct truncation or other specified rounding. Include all-zero and tiny-product/subnormal-c branches. |
| Accumulation | Reference signed integer sum and its quantum; required carry capacity, signed width, and no-wrap refinement under explicit bounds. No assumed intermediate normalization. |
| Output stages | Parameterized output/intermediate formats, normalization, rounding modes, ordered conversions, zero/underflow/overflow/special policies, and returned bits. Preserve distinct multi-stage rounding behavior. |
| Validity and evidence | Well-formed parameters, supported input domain, failure cases, source pins, and separate architecture-conformance evidence. |

Cover the structurally different source families: V100/Ampere/Hopper-style
FP16/BF16/TF32 groups, FP16 output sequences, FP8 variants including late c
and different alignment precision, and the separately characterized FP64 FMA
path. Use source-backed staged subdeliveries, but keep missing families marked
incomplete in this first gate; do not silently narrow the target to changing
V100's K and F. Turing and other uncharacterized paths remain unsupported
until a numerical specification is obtained.

### 2. Generalize encoded arithmetic and the evaluator

Design the smallest typed feature/pipeline schema that expresses the matrix.
Specify well-formedness and compatibility conditions. Keep input precision,
alignment precision, accumulator capacity, output precision, and correction
precision distinct. Avoid flags whose operational meaning is undefined.

Generalize the necessary decoding, representability, encoding, and rounding
interfaces beyond hard-coded FP32. Preserve current V100 behavior through a
proved specialization or equivalence theorem. Define every accepted pipeline
stage executably, including its domain checks. Retain the finite reference's
explicit rejection policy while broader exception behavior is being specified;
do not call that rejection a proof of GPU overflow or NaN behavior.

### 3. Prove the complete single-invocation contract

Prove reusable contracts over well-formed feature descriptions, specialized
where a policy needs additional premises:

- Decoder/value and encoder/value bridges, representability, and relevant
  round trips/fixed points, including zero and subnormal branches.
- Raw-product value preservation while retaining scale metadata; alignment
  coefficient/value equivalence and per-stage rounding loss.
- Exact common-grid accumulation, conservative signed-width bounds, and
  equality of a specified machine-width implementation to the reference under
  those bounds. Do not interpret paper width labels as signed register sizes.
- Output-stage correctness for each implemented mode and conversion sequence,
  including representability, range conditions, ties, carries, and underflow.
- An executable encoded-input/output theorem tied to an independently decoded
  ideal operation. Separate output behavior, stage decomposition, and error
  bounds; exact recovery alone would also hold for an incorrect output model.
- Generic error contracts under their actual policy hypotheses. Keep
  counterexamples to false monotonicity or padding claims; prove additional
  properties only at their justified scope.

Compose the local arithmetic stage contracts without assuming a hidden value
survives an encoded conversion. Prove the stated parameterized block semantics
and identify missing hardware-conformance premises; do not claim discovery of
the order of multiple blocks inside a hardware instruction.

### 4. Instantiate, validate, and close the coverage gate

Instantiate materially different feature combinations using the same proofs.
Recheck V100 first, then exercise changed precision/floor/format/output/c-stage
behavior. Keep numerical-model validation, independent exact-oracle checks,
and published/new device comparisons separate. Use the source's instruction
path identifiers when recording a concrete profile; a name alone is insufficient.

**Exit criterion:** the feature matrix has executable semantics and audited
theorem coverage for every claimed supported family; each profile has explicit
domains and evidence; V100 remains compatible; representative feature
interactions and boundaries have independent checks. Each unsupported family
or unresolved hardware mapping is listed. Completion of the generic declared
model is distinct from universal conformance to physical GPUs.

Do not move the main effort to downstream programs while obligations needed
to complete this declared invocation feature universe remain unaddressed.

## Separate application — invocation-local EFT

EFT should consume the invocation contract rather than dictate it. The current
stage residual identity, exact rational correction, and FP32 final-rounding
theorem are already available for the present model. The revised paper's
actual scalar FP algorithm is **not yet formalized**.

After the invocation interfaces are established, formalize the relevant paper
results for feature sets satisfying their hypotheses:

1. IV.1–IV.5: exact coarse components on `qE = max(qA, qD)`,
   `h_i = trunc_qE(T_i)`, `epsilon_i = T_i - h_i`,
   `H = sum(h_i)`, and `epsilon_o = D - H`, including c. Connect the overlap
   identity to the existing stage residuals. An invocation with extra lossy
   stages needs those losses accounted for; the one-group theorem cannot be
   transplanted unchanged.
2. IV.7–IV.9: actual encoded scalar add/subtract, numerical fixed points, and
   exact naive summation when `T_i = z_i * 2^ell`,
   `2^ell >= qmin`, `sum(abs(z_i)) < 2^P`, and
   `sum(abs(z_i)) * 2^ell <= maxFinite`. Prove every prefix representable;
   final-sum range alone is insufficient.
3. IV.10–IV.11/Algorithm 1: exact overlap subtraction under representation
   hypotheses, actual repeated FP32 residual additions, and one final FP32
   RNE addition. Prove the branch predicate sufficient and keep exact-dyadic
   fallback separate. Cover the all-zero case and the independent ideal sum.

Use R2 for nonzero coarse overlap with zero total residual and R3 for a
nonzero correction. Include cancellation/subnormal and rejected-predicate
cases. An FP64 rounded addition followed by FP32 conversion can double-round;
it needs a separate proof. The cheap overlap extractor and proposed
four-invocation adder scheme also need separate specifications/proofs.

This is one local application. Downstream theorems may instead use uncorrected
output/error contracts, equivalence, or other invocation properties. No global
EFT requirement is imposed on the rest of the project.

## Later gates — planned downstream implementation

These are intended implementation deliverables, deferred until the first gate
is complete. The existing schedule/DSL work is a starting point. Begin with a
long dot product in a supplied order, then extend to richer state and matrices.

Today `runBlocks` follows a supplied serial list, feeding each model output's
FP32 bits to the next group. It proves
`c0 + sum(P_j) = d_m + sum(e_j)` with every `e_j` retained exactly in `Rat`.
It does not infer GPU ordering or prove that reordered groups have identical
outputs. MATLAB's increasing-k grouping is a reference-software rule, not a
proved instruction mapping. The published 5,000 vectors test individual groups.

### D1. Specify schedules and boundaries

Define a typed schedule of completed invocations, each with its feature set,
operand bindings, accumulator, and encoded result. Preserve original operand
factorization: equal exact products can have different raw scales. Specify
which outputs feed later operands, including every conversion and scalar
operation. Support serial schedules first, then dependency graphs/mixed profiles.

For a long dot product, declare an ordered partition of original product
indices and prove intended multiplicities and encoded boundaries. This order
is a program/model specification until connected to hardware evidence.

**Exit:** executable schedule semantics, an independent original-input ideal,
and proved operand/boundary mapping. Include differing-order outputs; ideal
commutativity does not imply identical uncorrected encoded results.

### D2. Compose the local contracts

Apply each invocation's contract to the state produced by its predecessor.
For fixed-input sums, generalize the exact-loss ledger and derive uncorrected
final error bounds from local bounds. Retain every intermediate range/domain
condition. For adaptive operands, define a mathematical state and prove its
simulation/error invariant; an additive fixed-input ledger is insufficient.

**Exit:** reusable sequence rules for exact semantics, accumulated error, and
equivalence under justified conditions. Prove a multi-invocation result without
requiring EFT. Corrected execution is an additional contract when its stored
residual representation is proved.

### D3. Add scalar state, loops, and automation

Model required scalar add/subtract/conversion operations using the generic
rounding contracts. Include indexing and data-dependent operand generation.
Extend the current same-state/zero-ledger cycle proof to changing-state
invariants, with induction and per-step range/support conditions.

Extend `Program` semantics and verification conditions before DSL syntax.
Generate Lean proofs using those rules, retaining diagnostics, literal/shape
checks, failure rollback, and auditing. Automated analysis discharges
conditions; it cannot replace an unproved arithmetic contract.

**Exit:** a symbolic-length long-dot-product theorem and a changing-state loop
with scalar rounding accounted for, plus a checked DSL example. Identify which
conditions are automatic and which require supplied invariant proofs.

### D4. Connect an instruction path and matrix mapping

Pin one architecture, API/opcode, shape/layout, formats, qualifiers,
compiler/CUDA/PTX versions, and emitted PTX/SASS artifact. Map logical matrix
entries to lane/register fragments, loads/stores, and invocation operands.
Specify multiple-block grouping/order, c insertion, and every conversion in
the larger instruction/program. Prove layout and multiplicity separately from
numerical conformance.

The proposed Lean interfaces are an instruction-path descriptor, typed
lane/register state, operand/result mapping functions, an explicit allowed
invocation schedule, and an instruction transition relation. Prove a
refinement theorem connecting that relation to execution of the mapped
arithmetic schedule, then reuse D2/D3 for the application result. These are
planned interfaces, not existing declarations. Keep any hardware-conformance
premise limited to the unresolved instruction behavior; do not assume the
whole application's desired correctness as part of the mapping.

Compare source/model and emitted code, then use targeted evidence to resolve
unknown numerical boundaries and ordering. Single-group vectors do not settle
this. If evidence admits several schedules, represent that uncertainty: a
universal result must hold for all admitted schedules; a theorem for one chosen
schedule stays conditional on that choice. Do not invent deterministic ordering.

**Exit:** a scoped arithmetic-to-instruction refinement statement, proved
mapping obligations, and an explicit list of architecture/compiler premises
and empirical evidence. See [PTX_BOUNDARY.md](PTX_BOUNDARY.md) for inspected
sources and the detailed checklist.

### D5. Verify applications and transformations

Use the mapping for a small matrix/tile example with a theorem about its
independent ideal result or error. For reordering, fusion, or precision
changes, prove bitwise equivalence or a stated error relation under explicit
hypotheses; retain counterexamples to invalid transformations. Validate across
normalization and encoded boundaries as well as within individual invocations.

**Exit:** one mapped application and one justified transformation (or a checked
counterexample rejecting it), separating model proof, compiler/layout mapping,
and device evidence. Reuse contracts for additional instruction paths while
discharging their path-specific obligations.

If a later task needs an executable corrected multi-invocation result, choose
an actual residual representation and prove its update invariant, including
every scalar/conversion loss and intermediate range/support condition. The
paper's VIII explicitly leaves efficient ledger representation/consolidation
as future work. Correctly rounding each invocation alone does not imply
globally correct rounding. This is a possible downstream task, not the
organizing objective of the general invocation model.

For that optional task, use state `(encoded_output, correction_state)` and
prove `value(encoded_output) + value(correction_state) = exact_sum_so_far`.
Choose a bounded exact scalar, a specified expansion, or an integer-dyadic
representation, with explicit failure/fallback. Specify whether raw or
corrected output feeds the next call. Include multi-block cancellation and a
case where naive FP32 ledger addition loses information before claiming
executable global correction.

## Preserve while continuing

Keep the pinned papers/release and declared trust boundary; preserve raw
product metadata, sign-correct truncation, encoded boundaries, and independent
oracle comparisons. Keep Lean 4.33.1 and the dependency-free reference unless
a concrete proof obligation justifies a new dependency. Audit new theorem
roots and update coverage/status at each completed subdelivery.

The original R4 expectation was corrected: `1 - 3*2^-25` selects the even
neighbor `0x3f7ffffe = 1 - 2^-23`. Do not restore the old expected value.

This revision supplies a plan and handoff only. It does not implement new
feature families, scalar EFT, machine-width arithmetic, or hardware mapping.
