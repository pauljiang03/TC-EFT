# Tensor Core Arithmetic

Lean 4 theories and executable reference models for selected tensor-core arithmetic,
with proved binary rounding, accumulation refinements, GEMM error certificates,
and an IEEE binary scalar layer. Uses Lean 4.33.1 and its standard library.

The [current evaluation](EVALUATION.md) records validation, scope, and unresolved
concerns. Human specification review and physical GPU conformance remain open.
The [implementation plan](IMPLEMENTATION_PLAN.md) records the IEEE equivalence
proofs and migration to Lean's built-in operations.

The native IEEE migration preserves the scalar API's result bits and exception
flags by kernel-checked equivalence proofs. The EFT executable also uses native
FP32 addition for scalar consolidation, with a proof preserving its complete
result, branch selection, and errors. The original references and tensor-core/GEMM
models are retained. The [compatibility guide](tensor-core/docs/lean-ieee-compatibility.md)
explains the preserved results, retained reference paths, and evidence of correctness.

## The two core functions: tensor core and EFT

Start with these two functions and their main theorems. The Lean blocks below
are copied directly from the source, including the proof bodies. Their imports,
namespace context, and helper definitions are in the linked files. The
[full theorem catalog](#main-theorem-code) collects the wider library results.

### Tensor-core function: `evalBlock`

**Input:** a profile `p`, `p.products` encoded operand pairs `(A_i, B_i)`, and
an encoded FP32 accumulator `C`. **Output:** a trace containing the uncorrected
FP32 tensor-core result, or an explicit error. This function models one
normalization group; instruction and GEMM layers compose multiple groups.

Its arithmetic is:

```text
S = value(C) + sum_i(value(A_i) * value(B_i))    -- original exact dot product
terms = [C, A_1*B_1, ..., A_K*B_K]              -- K = p.products
eta = maximum nonzero raw scale, then the profile's floor
q = 2^(eta - p.alignFraction)                   -- shared alignment grid
M = q * sum_j truncTowardZero(value(terms_j) / q)
D_tc = roundFP32TowardZero(M)
```

Raw multiplication preserves the exact product value. Alignment truncates each
term separately before summation. For all-zero terms the grid choice is
irrelevant. Acceptance requires the right number of products, finite decoded
operands, and an aligned accumulator `M` within the finite FP32 range; see
[`evalBlock_success_iff`](tensor-core/TensorCore/Theory/AcceptedDomain.lean#L34).

The actual entry point and its final rounding stage, in namespace `TensorCore`:

[TensorCore.evalBlock](tensor-core/TensorCore/Semantics/Block.lean#L108):

Checks the product count, decodes finite operands, and evaluates one tensor-core
normalization group. Invalid inputs return an explicit error.

```lean
def evalBlock {p : Profile} (x : BlockInput p) : Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPrepared b
```

[TensorCore.evalPrepared](tensor-core/TensorCore/Semantics/Block.lean#L100):

Rounds the aligned accumulator toward zero to FP32 and packages a finite output trace.
An accumulator outside the accepted range is rejected.

```lean
def evalPrepared (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero b.accumulator with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩
```

**Main arithmetic theorem — `profile_contract`.** For an accepted trace, this
proves the original-input ideal, the toward-zero result, a bound on total error
(alignment plus output conversion), and equality with a fixed-width accumulator.
`hF` fixes the alignment precision; `hc` supplies enough carry bits for the
`K + 1` terms. The required accumulator width is `F + 3 + carryBits`.

[TensorCore.profile_contract](tensor-core/TensorCore/Theory/CanonicalFormats.lean#L11):

For an accepted block and sufficient carry bits, proves the output rounding rule, total
error bound, and equality with the stated fixed-width accumulator.

```lean
theorem profile_contract (p : Profile) (F carryBits : Nat) (hF : p.alignFraction = F)
    (hc : p.products + 1 ≤ 2 ^ carryBits) (x : BlockInput p) (t : BlockTrace)
    (h : evalBlock x = .ok t) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.accumulator = some t.output.bits ∧
    absQ (t.block.exactDot - t.output.value) <
      ((p.products + 1 : Nat) : Rat) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) ∧
    t.block.machineAccumulator (F + 3 + carryBits) = t.block.accumulator := by
  have hp := evalBlock_prepared h
  have hlen := (prepare_terms_bounded hp).1
  have hshape : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  have herr := evalBlock_error_bound h
  have hw := evalBlock_machineAccumulator h F carryBits hF hc
  refine ⟨by simp [exactDot, hp], evalPrepared_output (evalBlock_evalPrepared h), ?_, ?_⟩
  · simpa [hlen, hshape] using herr
  · have he : F + 2 + carryBits + 1 = F + 3 + carryBits := by omega
    simpa [he] using hw
```

**Translation theorem — `supported_eq_paper`.** On all eight supported paths,
`evalBlock` agrees bit-for-bit with the separately defined `PaperSpec` model for
every encoded input. Rejection also agrees, with errors observed as `none`.
The statement is in namespace `TensorCore.PaperSpec`. Reviewing the definitions
of `parameters` and `bits` is the human check that this specification expresses
the intended paper model; the theorem establishes equality of the two Lean models.

[TensorCore.PaperSpec.supported_eq_paper](tensor-core/TensorCore/PaperSpec/Supported.lean#L25):

Proves that all eight supported paths match the separately defined paper model on output
bits and rejection. Failures on both sides are compared as `none`.

```lean
theorem supported_eq_paper (path : Path) (x : BlockInput (implementationProfile path)) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      bits (parameters path) (supportedInput path x) := by
  cases path <;> exact implementation_eq_paper x
```

### EFT function: `algorithm1WithLean`

**Input:** a supported path, the original encoded operands and `C`, and an encoded
FP32 output `D` to correct. **Output:** `.scalar bits`, `.boundedExact bits`,
`.allZero`, `.outOfRange`, or an explicit error. `./tc eft` executes this
function. `D` can be the tensor-core result above; the correctness theorem covers
any finite supplied `D`.

The extraction and correction flow is:

```text
Split each original term: t_j = h_j + e_j
H = sum_j h_j
O = value(D) - H                               -- overlap
S = value(D) - O + sum_j e_j                    -- recovered exact dot product

If the scalar guards and intermediate checks pass:
    E = left-to-right FP32 nearest-even sum of the e_j, starting at +0
    H_fp = FP32 nearest-even addition of D and -O
    result = FP32 nearest-even addition of H_fp and E
Otherwise:
    result = directly round the recovered 576-bit exact value to FP32 nearest-even
```

The scalar checks establish exact residual consolidation and exact recovery of
`H`; the final addition can round. These additions use Lean's native `Float32`
through the proved finite adapter. The bounded fallback handles cases refused by
the scalar path. Preparation, all-zero handling, and finite-range rejection are
explicit in the actual code, in namespace `TensorCore.EFMachine`:

[TensorCore.EFMachine.algorithm1WithLean](tensor-core/TensorCore/Programs/NativeEFT.lean#L101):

Runs bounded EFT extraction, tries native FP32 scalar correction, and uses exact
consolidation when the scalar path refuses. Zero and out-of-range results have explicit
branches.

```lean
def algorithm1WithLean (path : Path) (x : BlockInput path.profile) (D : F32) : Except Error Result := do
  let p ← prepare path x D
  if p.terms.all (fun t => t.word.magnitude == 0) then return .allZero
  let some c := extract p | throw .arithmeticOverflow
  match c.scalarWithLean with
  | some b => return .scalar b
  | none =>
    match c.recovered.round32 with
    | some b => return .boundedExact b
    | none => return .outOfRange
```

**Main correctness theorem — `algorithm1WithLean_correct`.** `hlen` requires the
profile's product count, `hx` identifies the exact original-input dot product
`s` after finite decoding, and `hD` requires finite `D`. The conclusion equates
the result's optional bits to a single nearest-even rounding of `s`. It does not
assume successful extraction or a residual identity; those are proved internally.
When `s` is out of range, the optional bits are `none`.

[TensorCore.EFMachine.algorithm1WithLean_correct](tensor-core/TensorCore/Programs/NativeEFT.lean#L118):

For shape-correct finite inputs and any finite supplied `D`, proves that EFT returns the
directly rounded exact dot product. Its optional output bits also preserve range
rejection.

```lean
theorem algorithm1WithLean_correct {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : Rat} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    ∃ r, algorithm1WithLean path x D = .ok r ∧ r.bits = TensorCore.round32 .nearestEven s := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_correct hlen hx hD
```

**Correct rounding with an actual output — `algorithm1WithLean_success`.** Adding
the hypothesis `absQ s ≤ maxFinite32` guarantees returned bits `b` satisfying
`NearestEven32 s b`. That predicate, in namespace `TensorCore`, explicitly compares
against every finite representable value and requires an even low bit in a tie:

[TensorCore.NearestEven32](tensor-core/TensorCore/Theory/CorrectRounding.lean#L162):

Defines FP32 nearest-even correctness by comparison with every finite representable
value. An equally close distinct value requires the returned encoding to have an even
low bit.

```lean
def NearestEven32 (x : Rat) (b : F32) : Prop :=
  ∃ d : Rat, value32 b = some d ∧
    (∀ y : Rat, FiniteValue32 y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : Rat, FiniteValue32 y → y ≠ d →
      absQ (x - y) = absQ (x - d) → b.toNat % 2 = 0)
```

[TensorCore.EFMachine.algorithm1WithLean_success](tensor-core/TensorCore/Programs/NativeEFT.lean#L125):

When the exact dot product is in the finite FP32 range, proves that native EFT returns
actual bits satisfying nearest-even rounding.

```lean
theorem algorithm1WithLean_success {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : Rat} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d)
    (hrange : absQ s ≤ maxFinite32) :
    ∃ r b, algorithm1WithLean path x D = .ok r ∧ r.bits = some b ∧ NearestEven32 s b := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_success hlen hx hD hrange
```

**Exact success domain — `algorithm1WithLean_range_iff`.** With the same finite,
shape-correct inputs, obtaining output bits is equivalent to the original ideal
being within the finite FP32 range:

[TensorCore.EFMachine.algorithm1WithLean_range_iff](tensor-core/TensorCore/Programs/NativeEFT.lean#L133):

For shape-correct finite inputs and finite `D`, proves that native EFT returns output
bits exactly when the original exact dot product is in range.

```lean
theorem algorithm1WithLean_range_iff {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : Rat} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    (∃ r b, algorithm1WithLean path x D = .ok r ∧ r.bits = some b) ↔ absQ s ≤ maxFinite32 := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_range_iff hlen hx hD
```

**Native Lean preservation — `algorithm1WithLean_eq`.** For every input, including
invalid inputs, replacing scalar additions with the Lean-native adapter preserves
the complete original EFT result: bits, branch choice, and errors.

[TensorCore.EFMachine.algorithm1WithLean_eq](tensor-core/TensorCore/Programs/NativeEFT.lean#L113):

Proves that native EFT preserves the entire original bounded EFT result for every input,
including output bits, branch choice, and errors.

```lean
theorem algorithm1WithLean_eq (path : Path) (x : BlockInput path.profile) (D : F32) :
    algorithm1WithLean path x D = algorithm1 path x D := by
  simp only [algorithm1WithLean, algorithm1, Components.scalarWithLean_eq]
  rfl
```

Together these establish the modeled tensor-core arithmetic and the EFT's
correctly rounded recovery. Physical GPU correspondence remains a separate
obligation. Further scalar execution details are [below](#eft-scalar-accumulation).

## Quick start

```sh
./tc doctor --json
./tc build
./tc review
./tc ieee tensor-core/data/examples/ieee.jsonl
./tc audit
./tc check
```

Install the pinned toolchain through elan if `doctor` reports it unavailable.
Commands build their native target before executing. Diagnostics go to stderr;
results go to stdout. CUDA is not required for the Lean build or the numerical checks.

| Command | Purpose |
| --- | --- |
| `./tc ieee FILE` | IEEE scalar conversions and arithmetic, with exception flags |
| `./tc gemm FILE` | Execute one GEMM request per JSONL line |
| `./tc analyze FILE --abs-tol T` | Infer concrete or family accuracy bounds |
| `./tc select FILE --abs-tol T` | Choose a certified configuration by preference or supplied cost |
| `./tc verify FILE.lean` | Replay an exported accuracy/selection certificate in Lean |
| `./tc schema [gemm\|select\|ieee]` | Print an input schema |
| `./tc trace HEX...` | Trace four V100 products plus an accumulator |
| `./tc eft FILE` | Run bounded block correction with native FP32 scalar consolidation |
| `./tc review` | Check ten editable GEMM examples against fixed answers |
| `./tc audit` | Audit theorem dependencies and reject proof shortcuts |
| `./tc check` | Run every validation gate in a fresh source copy |

Use `-` instead of a JSONL filename for standard input. Words are unsigned decimal
bit encodings, not decimal floating-point values. FP64 words need an integer-preserving
JSON parser. Run `./tc COMMAND --help` for arguments.

## Scope

There are two explicit arithmetic contracts:

| Layer | Implemented contract |
| --- | --- |
| Tensor-core/GEMM | Selected finite FP16/BF16/TF32 inputs, FP32 outputs, explicit alignment and instruction schedules, and conservative source-relative error certificates |
| IEEE scalar | FP16/FP32/FP64 conversions, addition, subtraction, multiplication, and fused multiply-add; every encoding, four rounding directions, signed zeros, infinities, quiet/signaling NaNs, and default exception flags |

The tensor-core pipeline retains its original finite semantics: nonfinite operands
and exact conversions beyond maximum finite magnitude are rejected; exact arithmetic
zero becomes +0; negative nonzero underflow preserves its sign. Empty raw reductions
preserve finite C bits. The IEEE scalar API is separately named and does not silently
change tensor-core alignment, intermediate conversions, GEMM results, or certificates.

The selected tensor-core families are V100/Ampere/Hopper FP16, Ampere/Hopper BF16,
and Ampere/Hopper TF32 WMMA/MMA paths. FP8 and FP16-output candidates remain partial.
The hardware profile constants are model inputs, and hardware correspondence is an
explicit external obligation. Globally correctly rounded GEMM is not claimed.

## IEEE scalar interface

```json
{"operation":"fma","format":"fp64","mode":"rdn","a":4607182418800017408,"b":4607182418800017408,"c":13830554455654793216}
```

This is `1 * 1 + (-1)` rounded downward. It returns negative zero,
`bits: 9223372036854775808`, with all flags false.

| Field | Values |
| --- | --- |
| `operation` | `convert`, `add`, `sub`, `mul`, `fma` |
| `format` | `fp16`, `fp32`, `fp64`; the input format and arithmetic destination |
| `target` | Destination format; required for `convert` |
| `mode` | `rne` nearest/even, `rtz` toward zero, `rdn` toward negative infinity, `rup` toward positive infinity |
| `tininess` | `before` or `after`; defaults to `after` |
| `a`, `b`, `c` | Encoded operands: `a` for conversion; `a,b` for binary operations; all three for FMA |

Each result contains `bits` and Boolean flags `invalid`, `divide_by_zero`,
`overflow`, `underflow`, and `inexact`. Flags report the current operation.
The Lean API's `Result.accumulate` combines them with prior sticky flags. Choose
one tininess policy consistently for a computation. Division is outside this
milestone, so these operations never raise the divide-by-zero flag.

NaN propagation chooses the first signaling NaN, otherwise the first quiet NaN,
in operand order. The selected sign and payload are retained, signaling NaNs are
quieted, and payload bits are aligned at their high end during format conversion.
Invalid operations without a NaN input produce a positive quiet NaN with zero
payload. FMA signals invalid for `0 * infinity` even with a quiet-NaN addend.
This is an explicit permitted policy, not a promise to match every processor's
NaN selection. See the [schema](tensor-core/data/schemas/ieee.schema.json),
[operations](tensor-core/TensorCore/IEEE/Operations.lean), and
[complete case contracts](tensor-core/TensorCore/IEEE/Specification.lean).

The exact IEEE reference is retained. The CLI uses proved wrappers around Lean's
native FP32/FP64 nearest-even addition, subtraction, and multiplication when both
operands are nonzero and finite and the absolute exact result is at most the
destination's maximum finite value. Cancellation to zero and underflow are covered.
Other cases, FP16, FMA, and conversions keep the reference path. The
[wrapper theorems](tensor-core/TensorCore/IEEE/NativeOperations.lean) preserve
every result bit and flag for every input and context, including the fallbacks;
exact arithmetic still computes domain checks and exception conditions. See the
[compatibility and trust details](tensor-core/docs/lean-ieee-compatibility.md).

Division, square root, comparisons, integer and text conversions, decimal
formats, additional operations, traps, and alternate exception handling are not
included. This milestone is not full IEEE 754 coverage.

## EFT scalar accumulation

`./tc eft FILE` calls
[`algorithm1WithLean`](tensor-core/TensorCore/Programs/NativeEFT.lean). Its scalar
branch adds residuals left to right using Lean's native `Float32` addition under
nearest-even rounding. The overlap subtraction and final scalar addition use the
same proved primitive. Every addition has its own FP32 rounding boundary:

```text
s = +0
for residual in residuals:
    s = round_FP32_nearestEven(s + residual)
```

The existing EFT guard ensures representable residuals and sufficient headroom
for exact scalar consolidation. The adapter retains finite-input and exact-range
rejection and normalizes `-0 + -0` to `+0`, matching EFT's numerical zero policy.
It checks range using bounded words and obtains result bits from native addition;
it does not recompute a reference-rounded answer at each step.

`naiveSum32WithLeanFrom_eq` proves the whole encoded fold equals the original
bounded fold for every list and starting accumulator. `algorithm1WithLean_eq`
preserves all result bits, branch tags, and errors for every input. The transferred
`algorithm1WithLean_correct` theorem covers all eight supported profiles with
shape-correct finite operands and any finite supplied output D. An in-range exact
ideal yields its correctly rounded FP32 result. The
[kernel witness](tensor-core/TensorCore/Regression/NativeEFT.lean) for the four
`0x3e00 * 0x3d00` products, `C = 0x3f7fffff`, and `D = 0x4107ffff` returns
`.scalar 0x41080000` (8.5).

Extraction, guards, and the 576-bit exact fallback remain custom. The original
EFT definitions remain independent references, and the generic FP64 consolidation
model is retained. The [native accumulation report](tensor-core/data/regressions/lean-eft-report.json)
checks individual folds; the [bounded EFT report](tensor-core/data/regressions/bounded-eft-report.json)
also compares complete original/native results so a branch fallback cannot hide
a scalar difference. These are proofs about the models plus compiled-execution
checks; physical GPU conformance remains separate.

## GEMM and accuracy certificates

```sh
./tc gemm tensor-core/data/examples/gemm.jsonl
./tc gemm tensor-core/data/examples/gemm.native.jsonl
./tc gemm tensor-core/data/examples/gemm.native-scaled.jsonl
./tc analyze tensor-core/data/examples/gemm.entry-family.jsonl --abs-tol 0.001
./tc select tensor-core/data/examples/gemm.cost-selection.jsonl --abs-tol 0.001 --emit tmp/cost.lean
./tc verify tmp/cost.lean
```

The native examples return five raw values of one and five scaled values of five.
The supplied-cost example selects index 2, Hopper TF32 MMA, with supplied cost one.
Certificate export is not kernel replay: run `verify` to check the exported proof.
Certificates pin their theory sources; re-export them after a source revision.

| Operation | Arithmetic |
| --- | --- |
| `raw` | FP16 `AB+C`, FP32 C and output |
| `scaled` | Source conversion to FP16, tensor product from +0, separately rounded FP32 alpha/beta products and addition, then output conversion |
| `native` | Native BF16 or packed 19-bit TF32 `AB+C`, FP32 C and output |
| `native_scaled` | Source conversion to native precision, followed by the complete FP32 scalar epilogue |
| `analyze`, `analyze_scaled`, `analyze_native`, `analyze_native_scaled` | Input-derived absolute error certificates for those pipelines |
| `analyze_family`, `analyze_entry_family` | Quantified raw FP16/FP32 guarantees over uniform or per-entry magnitude caps |

Here `native` names the tensor-core input precision (BF16 or TF32). These GEMM
paths retain their finite arithmetic model. The Lean `Float`/`Float32` migration
applies to the separately named IEEE wrappers and the EFT scalar execution path.

The [GEMM schema](tensor-core/data/schemas/gemm.schema.json) specifies required
fields. Matrices are flat row-major arrays with dimensions `m,n,k`; concrete
inputs must have exactly `m*k`, `k*n`, and `m*n` words. All dimensions, including
empty reductions and padding/cropping, are represented in the formal contracts.

A certificate bounds error relative to the original decoded source values,
including input conversion and scalar stages. Acceptance entails successful
execution and a defined ideal. Refusal means the analyzer did not certify the
request; it does not prove the numerical result inaccurate. Matrix bounds use
the sum of absolute entries, not an induced matrix norm. Selection minimizes
supplied costs among certified candidates; those costs are not measured GPU speeds.

The [editable cases](tensor-core/data/examples/gemm.jsonl) and their
[expected fields](tensor-core/data/examples/gemm.expected.json) demonstrate
source loss, conservative refusal, nonfinite rejection, directed conversion,
and subnormal boundaries. The [selection schema](tensor-core/data/schemas/selection.schema.json)
covers preference and cost decisions. Further runnable contracts are in
[tensor-core/examples](tensor-core/examples).

## Main claims to review

C01–C16 retain the original finite tensor-core scope. C17–C19 describe the IEEE
layer, C20 describes its migration to Lean operations, and C21 covers native EFT
scalar execution. These are claims about
the explicit definitions and hypotheses; a successful build is not a human
assessment of specification adequacy.

The table is an index. [Expand the main theorem code below](#main-theorem-code)
to read the Lean hypotheses, conclusions, and full proofs for every claim group.

| Claim | Proved scope and assumptions | Public declarations |
| --- | --- | --- |
| C01. Finite rounding | Every well-formed IEEE-style binary format, all four modes, rational inputs within maximum finite magnitude. Out-of-range inputs are rejected even when a directed finite result could exist. | [`TensorCore.roundBinary_correct`](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean), [`TensorCore.roundBinary_isSome_iff`](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean) |
| C02. Encoding and signed zero | Bijection between finite encoded words and a representable rational value paired with a sign bit. Nonzero signs agree with the value; zero has two representations. Arithmetic exact zero remains +0. | [`TensorCore.signedFiniteBinaryBijection`](tensor-core/TensorCore/Theory/Binary/SignedBijection.lean), [`TensorCore.roundBinary_zero`](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean) |
| C03. FP64 fused arithmetic | One exact product plus accumulator, one final rounding in each direction; finite decoded inputs and an in-range exact fused result give success. No intermediate product range restriction. | [`TensorCore.binary64Fma_correct`](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean), [`TensorCore.binary64Fma_success`](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean) |
| C04. Tensor-core arithmetic | The selected FP16/BF16/TF32 profiles model raw subnormal scales, alignment, floors, signed truncation, and final conversion. Fixed-width refinement has explicit width/carry assumptions. | [`TensorCore.profile_contract`](tensor-core/TensorCore/Theory/CanonicalFormats.lean), [`TensorCore.PaperSpec.supported_eq_paper`](tensor-core/TensorCore/PaperSpec/Supported.lean) |
| C05. Error, recovery, and order | Local error includes final conversion; exact residual recovery composes across encoded accumulators. Nonmonotonicity is proved for the specified realizable input family. Accepted traces and the stated range/profile premises remain explicit. | [`TensorCore.evalBlock_error_bound`](tensor-core/TensorCore/Theory/ErrorBounds.lean), [`TensorCore.runBlocks_residual_ledger`](tensor-core/TensorCore/Programs/Composition.lean), [`TensorCore.nonmonotone_range_encoded`](tensor-core/TensorCore/Theory/MonotonicityRange.lean) |
| C06. Bounded EFT | All eight paths, shape-correct finite inputs and any finite supplied output D. A fixed 576-bit workspace computes the correctly rounded FP32 ideal when that ideal is in range; refinement preserves result bits. | [`TensorCore.EFMachine.algorithm1_success`](tensor-core/TensorCore/Theory/EFMachine/Correctness.lean), [`TensorCore.EFMachine.algorithm1_range_iff`](tensor-core/TensorCore/Theory/EFMachine/Correctness.lean), [`TensorCore.EFMachine.algorithm1_agrees`](tensor-core/TensorCore/Theory/EFMachine/Refinement.lean) |
| C07. Eq.20 and extraction | Every permitted coarse extraction grid; Eq.20 supplies the coefficient budget for exact scalar summation. Minimum grid, finite magnitude, and guarded component representability remain hypotheses. | [`TensorCore.ExtractionGrid.eq20_exact_sum`](tensor-core/TensorCore/Programs/ExtractionGrid.lean), [`TensorCore.ExtractionGrid.eq20_scalarPredicate`](tensor-core/TensorCore/Programs/ExtractionGrid.lean), [`TensorCore.ExtractionGrid.recovery`](tensor-core/TensorCore/Programs/ExtractionGrid.lean) |
| C08. Program composition | Typed invocations expose exact loss/recovery; ordered programs and bounded repetitions have sufficient scale and headroom contracts. Adaptive branching is outside this API. | [`TensorCore.evalInvocation_recovery`](tensor-core/TensorCore/Theory/Invocation.lean), [`TensorCore.Program.repeat_accurate_of_scales`](tensor-core/TensorCore/Theory/ProgramBounds/Loops.lean) |
| C09. Raw FP16 GEMM | Arbitrary dimensions, three logical WMMA schedules, padding/cropping, every encoded group boundary, and rejection agree with the separately defined matrix specification. | [`TensorCore.PaperSpec.gemm_eq_paper`](tensor-core/TensorCore/PaperSpec/GemmEquivalence.lean), [`TensorCore.PaperSpec.gemm_rejected_iff_paper`](tensor-core/TensorCore/PaperSpec/GemmEquivalence.lean) |
| C10. Native BF16/TF32 GEMM | Raw `AB+C` and complete source-converted `alpha*AB+beta*C`, five schedules, FP32 C/output. All four conversion/scalar modes; independent equivalence includes every stage and rejection. Accepted input-only checks imply successful execution and error against original source values. | [`TensorCore.PaperSpec.nativeGemm_eq_paper`](tensor-core/TensorCore/PaperSpec/NativeGemmEquivalence.lean), [`TensorCore.nativeAnalysisCheck_sound`](tensor-core/TensorCore/Programs/NativeGemm.lean), [`TensorCore.PaperSpec.nativeConvertedGemm_eq_independent`](tensor-core/TensorCore/PaperSpec/NativeScaledGemmEquivalence.lean), [`TensorCore.nativeConvertedAnalysisCheck_paper`](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean), [`TensorCore.analyzeNativeConvertedGemm_matrix_error`](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean) |
| C11. Complete scaled FP16 GEMM | Source conversion to FP16, tensor-core product, separately rounded FP32 alpha/beta products and addition, then output conversion. Independent equivalence includes every stage and rejection without assuming execution success. | [`TensorCore.PaperSpec.convertedGemm_eq_independent`](tensor-core/TensorCore/PaperSpec/ScaledGemmEquivalence.lean), [`TensorCore.PaperSpec.scaledGemm_eq_independent`](tensor-core/TensorCore/PaperSpec/ScaledGemmEquivalence.lean) |
| C12. Input-derived error certificates | Acceptance proves successful execution and error relative to original decoded inputs, including conversion perturbations and scalar stages. Per-entry bounds sum to a matrix absolute-entry-sum bound. Inference is conservative. | [`TensorCore.gemmAnalysisCheck_sound`](tensor-core/TensorCore/Programs/GemmAnalysis.lean), [`TensorCore.convertedAnalysisCheck_paper`](tensor-core/TensorCore/Programs/ConvertedGemmAnalysis.lean), [`TensorCore.analyzeConvertedGemm_matrix_error`](tensor-core/TensorCore/Programs/ConvertedGemmAnalysis.lean) |
| C13. Tighter bounds | Tighter scalar/input budgets are proved no larger than the earlier budgets. Finite multiplication by ±1 and addition with a zero-magnitude operand receive zero rounding error in every mode. | [`TensorCore.scaledGemmTightError_le`](tensor-core/TensorCore/Programs/GemmTightBounds.lean), [`TensorCore.gemmInputPairTightError_le`](tensor-core/TensorCore/Programs/GemmTightInputBounds.lean), [`TensorCore.checkFiniteMultiply_sound`](tensor-core/TensorCore/Programs/ExactScalarAnalysis.lean), [`TensorCore.checkFiniteAdd_sound`](tensor-core/TensorCore/Programs/ExactScalarAnalysis.lean) |
| C14. Quantified families | One accepted witness covers every finite FP16 A/B and FP32 C matrix satisfying uniform or per-entry magnitude caps. Per-entry analysis uses row/column maxima; zero caps permit both zero encodings. | [`TensorCore.familyCheck_sound`](tensor-core/TensorCore/Programs/GemmFamily.lean), [`TensorCore.entryFamilyCheck_sound`](tensor-core/TensorCore/Programs/EntryFamily.lean), [`TensorCore.entryFamilyCheck_matrix_error`](tensor-core/TensorCore/Programs/EntryFamily.lean) |
| C15. Certified decisions | Selection proves accuracy and either earliest certified preference or minimum supplied rational cost among certified candidates. Refusal means no candidate was certified. Native precision is fixed per workload. | [`TensorCore.selectGemm_sound`](tensor-core/TensorCore/Programs/GemmSelection.lean), [`TensorCore.selectGemm_none`](tensor-core/TensorCore/Programs/GemmSelection.lean), [`TensorCore.selectGemmCost_sound`](tensor-core/TensorCore/Programs/CostSelection.lean) |
| C16. Pinned CUTLASS connection | The reviewed arithmetic projection agrees with FP16 GEMM and inherits its accuracy checker. The selected K is divisible by 16; C++ execution, memory, compilation, and GPU correspondence are separate obligations. | [`TensorCore.CutlassWmma.project_eq_gemm`](tensor-core/TensorCore/Kernels/CutlassWmma.lean), [`TensorCore.CutlassWmma.project_check_sound`](tensor-core/TensorCore/Kernels/CutlassWmma.lean) |
| C17. IEEE scalar results | Every FP16/FP32/FP64 encoding, conversions/add/subtract/multiply/FMA, four modes, both tininess policies, exact zero signs, infinity and NaN cases, and default flags. One exact product plus addend is rounded only once. | [`TensorCore.IEEE.convert_correct`](tensor-core/TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.add_correct`](tensor-core/TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.sub_correct`](tensor-core/TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.mul_correct`](tensor-core/TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.fma_correct`](tensor-core/TensorCore/IEEE/Specification.lean) |
| C18. IEEE precision and flags | Unbounded-exponent precision rounding satisfies independently specified integer optimality, is unique, and determines overflow. Nearest and directed magnitude results compare against all bounded-significand dyadic competitors. | [`TensorCore.IEEE.precisionMagnitude_correct`](tensor-core/TensorCore/IEEE/Precision.lean), [`TensorCore.IEEE.precisionRound_unique`](tensor-core/TensorCore/IEEE/Precision.lean), [`TensorCore.IEEE.round_correct`](tensor-core/TensorCore/IEEE/Rounding.lean), [`TensorCore.IEEE.round_overflow_iff`](tensor-core/TensorCore/IEEE/Rounding.lean) |
| C19. IEEE compatibility | Same-format finite conversion preserves every encoding and raises no flags; quiet NaN payloads survive widening/narrowing. Nonzero in-range rounding agrees with the existing finite converter. | [`TensorCore.IEEE.convert_self_finite`](tensor-core/TensorCore/IEEE/Compatibility.lean), [`TensorCore.IEEE.convert_quietNaN_roundtrip`](tensor-core/TensorCore/IEEE/Compatibility.lean), [`TensorCore.IEEE.round_agrees_finite`](tensor-core/TensorCore/IEEE/Rounding.lean) |
| C20. Lean native migration | FP32/FP64 nearest-even add/sub/mul agree with Lean's logical operations for nonzero finite operands with an in-range exact result. Wrappers preserve the original bits and every flag for all formats, inputs, rounding modes, and tininess policies by retaining reference fallbacks. | [`TensorCore.IEEE.addWithLean_eq`](tensor-core/TensorCore/IEEE/NativeOperations.lean), [`TensorCore.IEEE.subWithLean_eq`](tensor-core/TensorCore/IEEE/NativeOperations.lean), [`TensorCore.IEEE.mulWithLean_eq`](tensor-core/TensorCore/IEEE/NativeOperations.lean) |
| C21. Native EFT scalar execution | Native FP32 scalar additions preserve the complete bounded Algorithm 1 result for every input, including branch tags and errors. All eight supported finite, shape-correct paths retain correct rounding and the exact range/success contract. | [`TensorCore.EFMachine.naiveSum32WithLeanFrom_eq`](tensor-core/TensorCore/Programs/NativeEFT.lean), [`TensorCore.EFMachine.algorithm1WithLean_eq`](tensor-core/TensorCore/Programs/NativeEFT.lean), [`TensorCore.EFMachine.algorithm1WithLean_correct`](tensor-core/TensorCore/Programs/NativeEFT.lean), [`TensorCore.EFMachine.algorithm1WithLean_range_iff`](tensor-core/TensorCore/Programs/NativeEFT.lean) |

<!-- BEGIN MAIN THEOREM CODE -->

### Main theorem code

Expand a claim below to read the **actual Lean declarations and complete proof
bodies** copied from the current source. This catalog contains 96 main theorem
declarations across C01–C21, plus 30 accompanying definitions/structures
that expose key contracts. It includes every declaration linked in the claim
table, the encoding inverse laws, the scalar EFT contracts, bounded-dot guarantees,
the six FP32/FP64 native arithmetic bridges, and the complete native EFT proof chain.
Supporting lemmas remain in the linked files; the
[axiom audit](tensor-core/docs/axioms.txt) lists the broader audited theorem set.

For a `theorem`, the arguments and hypotheses precede its result-type `:`. The
proposition between that `:` and `:=` is the guarantee; the expression after
`:=` is the proof. For statements
such as `AddSpec ...` or `Program.Accurate ...`, inspect the accompanying `def`:
that is where the intended mathematical contract is expressed. A `def` supplies a
definition; a `theorem` proves a proposition about those definitions. The signed
bijection is a `def` containing its proved inverse laws, which are also shown.

These are verbatim source excerpts in their original namespace context. Imports,
section variables, local options, and helper lemmas remain in the linked source;
the blocks are not standalone Lean modules. Follow a declaration link and use
Go to Definition in VS Code to inspect any remaining predicate or operation.
For a first EFT review, read **C01 → C04 → C07 → C06 → C21**; for the IEEE
translation, read **C17 → C18 → C19 → C20**. Kernel checking establishes these
written statements; reviewing the definitions and hypotheses establishes whether
they express the intended mathematics.

<details>
<summary>C01. Finite rounding — Lean declarations</summary>

**[TensorCore.NearestEven](tensor-core/TensorCore/Theory/Binary/CorrectRounding.lean#L270)** (def; namespace `TensorCore`).

Defines nearest-even correctness for a general binary format using all finite
representable competitors and an even low encoding bit for ties.

```lean
def NearestEven (f : Format) (x : Rat) (bits : BitVec f.width) : Prop :=
  ∃ d : Rat, binaryValue f bits = some d ∧
    (∀ y : Rat, f.FiniteValue y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : Rat, f.FiniteValue y → y ≠ d → absQ (x - y) = absQ (x - d) → bits.toNat % 2 = 0)
```

**[TensorCore.TowardZero](tensor-core/TensorCore/Theory/Binary/CorrectRounding.lean#L348)** (def; namespace `TensorCore`).

Defines toward-zero rounding as the representable value between zero and the input with
greatest magnitude.

```lean
def TowardZero (f : Format) (x : Rat) (bits : BitVec f.width) : Prop :=
  ∃ d : Rat, binaryValue f bits = some d ∧ Between0 x d ∧
    ∀ y : Rat, f.FiniteValue y → Between0 x y → absQ y ≤ absQ d
```

**[TensorCore.TowardNegative](tensor-core/TensorCore/Theory/Binary/DirectedRounding.lean#L10)** (def; namespace `TensorCore`).

Defines downward rounding as the greatest finite representable value that does not
exceed the input.

```lean
def TowardNegative (f : Format) (x : Rat) (bits : BitVec f.width) : Prop :=
  ∃ d : Rat, binaryValue f bits = some d ∧ d ≤ x ∧
    ∀ y : Rat, f.FiniteValue y → y ≤ x → y ≤ d
```

**[TensorCore.TowardPositive](tensor-core/TensorCore/Theory/Binary/DirectedRounding.lean#L15)** (def; namespace `TensorCore`).

Defines upward rounding as the least finite representable value that is not below the
input.

```lean
def TowardPositive (f : Format) (x : Rat) (bits : BitVec f.width) : Prop :=
  ∃ d : Rat, binaryValue f bits = some d ∧ x ≤ d ∧
    ∀ y : Rat, f.FiniteValue y → x ≤ y → d ≤ y
```

**[TensorCore.BinaryRoundSpec](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L9)** (def; namespace `TensorCore`).

Selects the mathematical rounding predicate corresponding to the requested direction.

```lean
def BinaryRoundSpec (f : Format) (mode : BinaryRoundingMode) (x : Rat)
    (bits : BitVec f.width) : Prop :=
  match mode with
  | .nearestEven => NearestEven f x bits
  | .towardZero => TowardZero f x bits
  | .towardNegative => TowardNegative f x bits
  | .towardPositive => TowardPositive f x bits
```

**[TensorCore.roundBinary_correct](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L17)** (theorem; namespace `TensorCore`).

For a well-formed format and a rational input within its finite range, proves that
conversion succeeds and satisfies the requested rounding predicate.

```lean
theorem roundBinary_correct (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (x : Rat) (hr : absQ x ≤ f.maxFinite) :
    ∃ bits, roundBinary f mode x = some bits ∧ BinaryRoundSpec f mode x bits := by
  cases mode
  · exact roundBinary_towardZero_correct f hf x hr
  · exact roundBinary_nearestEven_correct f hf x hr
  · exact roundBinary_towardNegative_correct f hf x hr
  · exact roundBinary_towardPositive_correct f hf x hr
```

**[TensorCore.roundBinary_isSome_iff](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L37)** (theorem; namespace `TensorCore`).

Proves that finite conversion succeeds exactly when the format is well formed and the
exact input magnitude is within its maximum finite value.

```lean
theorem roundBinary_isSome_iff (f : Format) (mode : BinaryRoundingMode) (x : Rat) :
    (roundBinary f mode x).isSome = true ↔ f.WellFormed ∧ absQ x ≤ f.maxFinite := by
  constructor
  · intro h
    cases hb : roundBinary f mode x with
    | none => simp [hb] at h
    | some b => exact roundBinary_range hb
  · rintro ⟨hf, hr⟩
    obtain ⟨b, hb, _⟩ := roundBinary_correct f hf mode x hr
    simp [hb]
```

</details>

<details>
<summary>C02. Encoding and signed zero — Lean declarations</summary>

**[TensorCore.SignedFiniteValue](tensor-core/TensorCore/Theory/Binary/SignedBijection.lean#L52)** (structure; namespace `TensorCore`).

Represents a finite representable rational together with its sign bit. Nonzero signs
follow the value, while zero permits either sign.

```lean
structure SignedFiniteValue (f : Format) where
  value : Rat
  negative : Bool
  finite : f.FiniteValue value
  sign_nonzero : value ≠ 0 → negative = decide (value < 0)
```

**[TensorCore.decode_encodeSignedBinary](tensor-core/TensorCore/Theory/Binary/SignedBijection.lean#L122)** (theorem; namespace `TensorCore`).

Proves that encoding and then decoding a signed finite value recovers the original value
and sign, assuming a well-formed format.

```lean
theorem decode_encodeSignedBinary (f : Format) (hf : f.WellFormed) (v : SignedFiniteValue f) :
    decodeSignedBinary f hf (encodeSignedBinary f hf v) = v := by
  have hv := Option.some.inj ((decodeBinaryRep_value f hf (encodeSignedBinary f hf v)).symm.trans
    (encodeSignedBinary_value f hf v))
  have hs := encodeSignedBinary_sign f hf v
  cases v
  simp only [decodeSignedBinary]
  congr
```

**[TensorCore.encode_decodeSignedBinary](tensor-core/TensorCore/Theory/Binary/SignedBijection.lean#L131)** (theorem; namespace `TensorCore`).

Proves that decoding and then encoding a finite word recovers the original bits,
including the sign of zero.

```lean
theorem encode_decodeSignedBinary (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    encodeSignedBinary f hf (decodeSignedBinary f hf b) = b := by
  apply binaryValue_sign_injective f hf _ _ (decodeSignedBinary f hf b).value
  · exact encodeSignedBinary_value f hf _
  · exact decodeBinaryRep_value f hf b
  · exact encodeSignedBinary_sign f hf _
```

**[TensorCore.signedFiniteBinaryBijection](tensor-core/TensorCore/Theory/Binary/SignedBijection.lean#L140)** (def; namespace `TensorCore`).

Packages signed finite values and finite encoded words into a bijection, using the two
proved inverse laws.

```lean
def signedFiniteBinaryBijection (f : Format) (hf : f.WellFormed) :
    BinaryBijection (SignedFiniteValue f) (FiniteBinaryWord f) :=
  ⟨encodeSignedBinary f hf, decodeSignedBinary f hf,
    decode_encodeSignedBinary f hf, encode_decodeSignedBinary f hf⟩
```

**[TensorCore.roundBinary_zero](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L48)** (theorem; namespace `TensorCore`).

Proves that the finite arithmetic converter maps exact rational zero to positive zero in
every rounding direction.

```lean
theorem roundBinary_zero (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode) :
    roundBinary f mode 0 = some 0 := by
  have hr : 0 ≤ f.maxFinite := Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
  rw [if_neg (by simpa [absQ] using Rat.not_lt.mpr hr)]
```

**[TensorCore.roundBinary_sign](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L56)** (theorem; namespace `TensorCore`).

Proves that a successful finite conversion uses the exact input's strict negativity as
its sign, including negative values that underflow to zero.

```lean
theorem roundBinary_sign (f : Format) (mode : BinaryRoundingMode) (x : Rat)
    (bits : BitVec f.width) (h : roundBinary f mode x = some bits) :
    binarySign f bits = decide (x < 0) := by
  obtain ⟨hf, hr⟩ := roundBinary_range h
  by_cases hx : x = 0
  · subst x
    rw [roundBinary_zero f hf mode] at h
    cases Option.some.inj h
    simp [binarySign]
  · have hm := absQ_pos_of_ne_zero x hx
    obtain ⟨he1, he2, _, _⟩ := binaryConvExp_bounds f hf (absQ x) hm hr
    obtain ⟨hk0, hk1, hsub, htop⟩ := binaryConvCoeff_bounds f hf mode (decide (x < 0)) (absQ x) hm hr
    have hs := binaryCarry_spec f hf _ _ he1 he2 hk0 hk1 hsub htop
    let e := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
      (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).1
    let k := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
      (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).2
    have hk : 0 ≤ k := hs.2.2.1
    let r : BinaryRep f := ⟨decide (x < 0), e, k.toNat, hs.1, hs.2.1,
      by have := hs.2.2.2.1; change k < _ at this; omega,
      by have := hs.2.2.2.2.1; change _ ≤ k ∨ e = _ at this; omega⟩
    have heq : encodeBinary f (decide (x < 0)) e k = bits := by
      unfold roundBinary at h
      rw [if_neg (fun hn => hn hf), if_neg (Rat.not_lt.mpr hr), if_neg hx] at h
      change (if e > f.emax then none else some (encodeBinary f (decide (x < 0)) e k)) = some bits at h
      rw [if_neg (Int.not_lt.mpr hs.2.1)] at h
      exact Option.some.inj h
    have hsign := (encodeBinary_fields f hf r).1
    simpa only [r, BinaryRep.encode, Int.toNat_of_nonneg hk, heq] using hsign
```

</details>

<details>
<summary>C03. FP64 fused arithmetic — Lean declarations</summary>

**[TensorCore.binary64Fma_correct](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L88)** (theorem; namespace `TensorCore`).

For an accepted FP64 fused invocation, proves rounding of the original exact product
plus addend in the requested direction, with the output sign specified.

```lean
theorem binary64Fma_correct {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) :
    invocationIdeal x = some t.intermediate.value ∧
    BinaryRoundSpec fp64 mode t.intermediate.value t.output.bits ∧
    binarySign fp64 t.output.bits = decide (t.intermediate.value < 0) := by
  have hout := evalInvocation_output h
  obtain ⟨b, hb, hc⟩ := roundBinary_correct fp64 (by decide) mode t.intermediate.value hout.2
  have heq := Option.some.inj (hb.symm.trans hout.1)
  rw [heq] at hc
  exact ⟨binary64Fma_exact_input h, hc, roundBinary_sign fp64 mode _ _ hout.1⟩
```

**[TensorCore.binary64Fma_success](tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L102)** (theorem; namespace `TensorCore`).

Proves that finite, one-product FP64 fused inputs succeed when the exact fused result is
in range. The intermediate product need not be in range.

```lean
theorem binary64Fma_success (mode : BinaryRoundingMode) (x : InvocationInput (binary64Fma mode))
    (b : PreparedInvocation (binary64Fma mode)) (hp : prepareInvocation x = some b)
    (hn : x.products.length = 1) (hr : absQ b.exactDot ≤ fp64.maxFinite) :
    ∃ t, evalInvocation x = .ok t := by
  unfold binary64Fma at *
  obtain ⟨bits, hb, hc⟩ := roundBinary_correct fp64 (by decide) mode b.exactDot hr
  obtain ⟨d, hd⟩ := hc.finite
  have hconv : (ConversionStage.mk fp64 mode).convert b.exactDot =
      some ⟨bits, d, hd⟩ := by
    simp only [ConversionStage.convert, hb]
    exact finiteBinary_some hd
  have hv : (binary64Fma mode).Valid := by cases mode <;> decide +kernel
  unfold evalInvocation
  rw [if_neg (fun h => h hv), if_neg (by simp [hn]), hp]
  simp only [evalInvocationPrepared, accumulateInvocation, runConversions]
  rw [hconv]
  exact ⟨_, rfl⟩
```

</details>

<details>
<summary>C04. Tensor-core arithmetic — Lean declarations</summary>

**[TensorCore.profile_contract](tensor-core/TensorCore/Theory/CanonicalFormats.lean#L11)** (theorem; namespace `TensorCore`).

For an accepted block and sufficient carry bits, proves the output rounding rule, total
error bound, and equality with the stated fixed-width accumulator.

```lean
theorem profile_contract (p : Profile) (F carryBits : Nat) (hF : p.alignFraction = F)
    (hc : p.products + 1 ≤ 2 ^ carryBits) (x : BlockInput p) (t : BlockTrace)
    (h : evalBlock x = .ok t) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.accumulator = some t.output.bits ∧
    absQ (t.block.exactDot - t.output.value) <
      ((p.products + 1 : Nat) : Rat) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) ∧
    t.block.machineAccumulator (F + 3 + carryBits) = t.block.accumulator := by
  have hp := evalBlock_prepared h
  have hlen := (prepare_terms_bounded hp).1
  have hshape : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  have herr := evalBlock_error_bound h
  have hw := evalBlock_machineAccumulator h F carryBits hF hc
  refine ⟨by simp [exactDot, hp], evalPrepared_output (evalBlock_evalPrepared h), ?_, ?_⟩
  · simpa [hlen, hshape] using herr
  · have he : F + 2 + carryBits + 1 = F + 3 + carryBits := by omega
    simpa [he] using hw
```

**[TensorCore.PaperSpec.supported_eq_paper](tensor-core/TensorCore/PaperSpec/Supported.lean#L25)** (theorem; namespace `TensorCore.PaperSpec`).

Proves that all eight supported paths match the separately defined paper model on output
bits and rejection. Failures on both sides are compared as `none`.

```lean
theorem supported_eq_paper (path : Path) (x : BlockInput (implementationProfile path)) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      bits (parameters path) (supportedInput path x) := by
  cases path <;> exact implementation_eq_paper x
```

</details>

<details>
<summary>C05. Error, recovery, and order — Lean declarations</summary>

**[TensorCore.evalBlock_error_bound](tensor-core/TensorCore/Theory/ErrorBounds.lean#L144)** (theorem; namespace `TensorCore`).

Bounds the absolute error of an accepted tensor-core block by the sum of alignment and
final-conversion budgets.

```lean
theorem evalBlock_error_bound {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    absQ (t.block.exactDot - t.output.value) <
      (t.block.terms.length : Rat) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) :=
  evalPrepared_error_bound (evalBlock_evalPrepared h)
```

**[TensorCore.runBlocks_residual_ledger](tensor-core/TensorCore/Programs/Composition.lean#L94)** (theorem; namespace `TensorCore`).

For a successful ordered block run, proves that the initial value plus all exact product
contributions equals the final output plus accumulated residuals.

```lean
theorem runBlocks_residual_ledger (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p initial.bits ps = .ok ts) :
    initial.value + sumQ (ts.map fun t => t.block.exactProducts) =
      (lastOutput initial ts).value + sumQ (ts.map BlockTrace.residual) :=
  encoded_trace_ledger initial ts (runBlocks_chain p initial ps ts h)
```

**[TensorCore.nonmonotone_range_encoded](tensor-core/TensorCore/Theory/MonotonicityRange.lean#L278)** (theorem; namespace `TensorCore`).

Characterizes when the encoded family with an accumulator just below one produces an
output above one, and gives output formulas and bounds. Profile and range conditions
remain explicit hypotheses.

```lean
theorem nonmonotone_range_encoded (K p j : Nat) (floor : Option Int)
    (hfl : ∀ f ∈ floor, f ≤ -1)
    (a b : (fp16Fp32Profile K p floor).Word) (da db : Decoded)
    (ha : (fp16Fp32Profile K p floor).decode a = some da)
    (hb : (fp16Fp32Profile K p floor).decode b = some db)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hK : K < 2 ^ (24 + p)) (hj1 : 1 ≤ j) (hj2 : j ≤ 2 ^ 23) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (a, b), BitVec.ofNat 32 (0x3f800000 - j)⟩ :
        BlockInput (fp16Fp32Profile K p floor)) = .ok t ∧
      (1 < t.output.value ↔ j ≤ min (2 ^ 23) (K / 2 ^ p - 2)) ∧
      (j * 2 ^ p ≤ K →
        t.output.value = 1 + (((K - j * 2 ^ p) / 2 ^ (p + 1) : Nat) : Rat) * pow2 (-23)) ∧
      t.output.value ≤ 1 + (((K - 2 ^ p) / 2 ^ (p + 1) : Nat) : Rat) * pow2 (-23) := by
  have hF : (fp16Fp32Profile K p floor).alignFraction = 23 + p := by
    show ((23 + p : Nat) : Int) = 23 + (p : Int)
    omega
  obtain ⟨t, h1, hiff, hform, hbound⟩ :=
    nonmonotone_range (fp16Fp32Profile K p floor) p K j da db hF hfl hval hscale hK hj1 hj2
  have hc := decode32_below j hj1 hj2
  have hps := prepareProducts_replicate _ a b da db K ha hb
  have hlen : ¬ ((List.replicate K (a, b)).length != (fp16Fp32Profile K p floor).products) = true := by
    simp [fp16Fp32Profile]
  refine ⟨t, ?_, ?_, hform, hbound⟩
  · unfold evalBlock
    rw [if_neg hlen]
    simp only [prepare, hc, hps]
    exact h1
  · rw [hiff, ← nonmonotone_range_iff p K j hj1]
    exact ⟨fun h => ⟨hj2, h⟩, fun h => h.2⟩
```

**[TensorCore.evalBlock_corrected_correct](tensor-core/TensorCore/Programs/Correction.lean#L13)** (theorem; namespace `TensorCore`).

For an accepted block with an in-range original ideal, proves that reference residual
correction returns the nearest-even FP32 rounding of that ideal.

```lean
theorem evalBlock_corrected_correct {p : Profile} {x : BlockInput p} {t : BlockTrace}
    {z : Rat} (h : evalBlock x = .ok t) (hz : exactDot x = some z)
    (hr : absQ z ≤ maxFinite32) :
    ∃ b, t.corrected = some b ∧ NearestEven32 z b := by
  simp only [exactDot, evalBlock_prepared h, Option.map_some] at hz
  have he := Option.some.inj hz
  rw [← he] at hr ⊢
  exact corrected_correct t hr
```

**[TensorCore.runBlocks_corrected_correct](tensor-core/TensorCore/Programs/Correction.lean#L41)** (theorem; namespace `TensorCore`).

For a successful block schedule with an in-range total ideal, proves that reference
schedule correction returns its nearest-even FP32 rounding.

```lean
theorem runBlocks_corrected_correct (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p initial.bits ps = .ok ts)
    (hr : absQ (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) ≤ maxFinite32) :
    ∃ b, correctedSchedule initial ts = some b ∧
      NearestEven32 (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) b :=
  correctedSchedule_correct initial ts (runBlocks_chain p initial ps ts h) hr
```

</details>

<details>
<summary>C06. Bounded EFT — Lean declarations</summary>

**[TensorCore.NearestEven32](tensor-core/TensorCore/Theory/CorrectRounding.lean#L162)** (def; namespace `TensorCore`).

Defines FP32 nearest-even correctness by comparison with every finite representable
value. An equally close distinct value requires the returned encoding to have an even
low bit.

```lean
def NearestEven32 (x : Rat) (b : F32) : Prop :=
  ∃ d : Rat, value32 b = some d ∧
    (∀ y : Rat, FiniteValue32 y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : Rat, FiniteValue32 y → y ≠ d →
      absQ (x - y) = absQ (x - d) → b.toNat % 2 = 0)
```

**[TensorCore.EFMachine.algorithm1_correct](tensor-core/TensorCore/Theory/EFMachine/Correctness.lean#L82)** (theorem; namespace `TensorCore.EFMachine`).

For shape-correct finite inputs and finite `D`, proves that the original bounded EFT
returns the directly rounded exact dot product, including range rejection.

```lean
theorem algorithm1_correct {path : Path} {x : BlockInput path.profile} {D : F32} {s d : Rat}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    ∃ r, algorithm1 path x D = .ok r ∧ r.bits = TensorCore.round32 .nearestEven s := by
  obtain ⟨p, hp⟩ := prepare_exists hlen hx hD
  have hi := (prepare_spec hp).2.1
  have hv : p.ideal = s := Option.some.inj (hi.symm.trans hx)
  obtain ⟨r, hr, hb⟩ := algorithm1_prepared hp
  exact ⟨r, hr, by simpa [hv] using hb⟩
```

**[TensorCore.EFMachine.algorithm1_success](tensor-core/TensorCore/Theory/EFMachine/Correctness.lean#L94)** (theorem; namespace `TensorCore.EFMachine`).

Adds an in-range ideal hypothesis to guarantee actual output bits and nearest-even
correctness for the original bounded EFT.

```lean
theorem algorithm1_success {path : Path} {x : BlockInput path.profile} {D : F32} {s d : Rat}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d)
    (hrange : absQ s ≤ maxFinite32) :
    ∃ r b, algorithm1 path x D = .ok r ∧ r.bits = some b ∧ NearestEven32 s b := by
  obtain ⟨r, hr, hb⟩ := algorithm1_correct hlen hx hD
  obtain ⟨b, hround, hn⟩ := round32_nearestEven_correct s hrange
  exact ⟨r, b, hr, hb.trans hround, hn⟩
```

**[TensorCore.EFMachine.algorithm1_range_iff](tensor-core/TensorCore/Theory/EFMachine/Correctness.lean#L104)** (theorem; namespace `TensorCore.EFMachine`).

Proves that the original bounded EFT returns output bits exactly when the ideal is in
range, after shape and finite-input requirements are met.

```lean
theorem algorithm1_range_iff {path : Path} {x : BlockInput path.profile} {D : F32} {s d : Rat}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    (∃ r b, algorithm1 path x D = .ok r ∧ r.bits = some b) ↔ absQ s ≤ maxFinite32 := by
  constructor
  · rintro ⟨r, b, hr, hb⟩
    obtain ⟨r', hr', hb'⟩ := algorithm1_correct hlen hx hD
    have he : r' = r := Except.ok.inj (hr'.symm.trans hr)
    subst r'
    exact TensorCore.round32_range (hb'.symm.trans hb)
  · intro h
    obtain ⟨r, b, hr, hb, _⟩ := algorithm1_success hlen hx hD h
    exact ⟨r, b, hr, hb⟩
```

**[TensorCore.EFMachine.algorithm1_agrees](tensor-core/TensorCore/Theory/EFMachine/Refinement.lean#L9)** (theorem; namespace `TensorCore.EFMachine`).

When encoded EFT preparation succeeds, proves that bounded Algorithm 1 agrees with the
reference trace's optional result bits. This comparison does not equate branch tags.

```lean
theorem algorithm1_agrees {path : Path} {x : BlockInput path.profile} {D : F32} {t : BlockTrace}
    (ht : prepareEncodedEFT x D = .ok t) :
    (algorithm1 path x D).map Result.bits = .ok t.algorithm1.bits := by
  obtain ⟨hlen, hx, hD⟩ := prepareEncodedEFT_spec ht
  have hs : TensorCore.exactDot x = some t.block.exactDot := by simp [TensorCore.exactDot, hx]
  have hd : TensorCore.value32 D = some t.output.value := by
    unfold finite32 at hD
    split at hD
    · contradiction
    · rename_i d hd
      have hv := congrArg Finite32.value (Option.some.inj hD)
      simpa [TensorCore.value32, hd, Finite32.value] using congrArg some hv
  obtain ⟨r, hr, hb⟩ := algorithm1_correct hlen hs hd
  rw [hr, Except.map, hb, algorithm1_bits_eq_round]
```

</details>

<details>
<summary>C07. Eq.20 and extraction — Lean declarations</summary>

**[TensorCore.ExtractionGrid](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L10)** (structure; namespace `TensorCore`).

Chooses an extraction exponent together with a proof that its grid is at least as coarse
as the block's alignment grid.

```lean
structure ExtractionGrid (t : BlockTrace) where
  exponent : Int
  coarser : t.block.quantumExponent ≤ exponent
```

**[TensorCore.ExtractionGrid.scalarPredicate](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L126)** (def; namespace `TensorCore.ExtractionGrid`).

Defines the scalar-path guard: residual grid and coefficient budgets, finite range,
representable intermediate components, and an in-range final ideal.

```lean
def scalarPredicate (g : ExtractionGrid t) (f : Format) (ℓ : Int) : Bool :=
  decide f.WellFormed && decide (f.emin - f.fractionBits ≤ ℓ) &&
  (g.lowParts == (g.coefficients ℓ).map fun (z : Int) => (z : Rat) * pow2 ℓ) &&
  decide (magnitudeSum (g.coefficients ℓ) < 2 ^ (f.fractionBits + 1)) &&
  decide ((magnitudeSum (g.coefficients ℓ) : Rat) * pow2 ℓ ≤ f.maxFinite) &&
  representableBinary f t.output.value && representableBinary f g.overlap &&
  representableBinary f g.retainedSum &&
  decide (absQ (g.retainedSum + sumQ g.lowParts) ≤ maxFinite32)
```

**[TensorCore.ExtractionGrid.eq20_exact_sum](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L116)** (theorem; namespace `TensorCore.ExtractionGrid`).

Under the common-grid, Equation 20 coefficient-budget, and range hypotheses, proves that
stepwise scalar summation of the low parts is exact.

```lean
theorem eq20_exact_sum (g : ExtractionGrid t) (f : Format) (hf : f.WellFormed)
    (ℓ : Int) (hmin : f.emin - f.fractionBits ≤ ℓ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : Int, x.value = (z : Rat) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum (g.coefficients ℓ) : Rat) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f g.lowParts = some (sumQ g.lowParts) := by
  rw [g.lowParts_on_grid ℓ hℓ hinput,
    naiveSumBinary_exact f hf ℓ hmin _ (g.eq20_coefficients ℓ _ hℓ hinput hbudget) hrange,
    sum_coefficients]
```

**[TensorCore.ExtractionGrid.eq20_scalarPredicate](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L179)** (theorem; namespace `TensorCore.ExtractionGrid`).

Proves that Equation 20 and the stated grid, range, and component-representability
conditions make the scalar guard accept.

```lean
theorem eq20_scalarPredicate (g : ExtractionGrid t) (f : Format) (hf : f.WellFormed)
    (ℓ : Int) (hmin : f.emin - f.fractionBits ≤ ℓ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : Int, x.value = (z : Rat) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum (g.coefficients ℓ) : Rat) * pow2 ℓ ≤ f.maxFinite)
    (hD : representableBinary f t.output.value = true)
    (hO : representableBinary f g.overlap = true)
    (hH : representableBinary f g.retainedSum = true)
    (hfinal : absQ t.block.exactDot ≤ maxFinite32) :
    g.scalarPredicate f ℓ = true := by
  have hgrid := g.lowParts_on_grid ℓ hℓ hinput
  have hcoeff := g.eq20_coefficients ℓ _ hℓ hinput hbudget
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨hf, hmin⟩, hgrid⟩, hcoeff⟩, hrange⟩, hD⟩, hO⟩, hH⟩,
    by simpa [g.retained_add_low] using hfinal⟩
```

**[TensorCore.ExtractionGrid.recovery](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L49)** (theorem; namespace `TensorCore.ExtractionGrid`).

Proves the exact identity: original dot product equals supplied output minus overlap
plus the sum of extracted low parts.

```lean
theorem recovery (g : ExtractionGrid t) :
    t.block.exactDot = t.output.value - g.overlap + sumQ g.lowParts := by
  have := g.retained_add_low
  unfold overlap
  grind
```

**[TensorCore.ExtractionGrid.eq20_coefficients](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L104)** (theorem; namespace `TensorCore.ExtractionGrid`).

Derives the residual coefficient-magnitude budget from Equation 20's term-count and
grid-spacing inequality.

```lean
theorem eq20_coefficients (g : ExtractionGrid t) (ℓ : Int) (P : Nat) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : Int, x.value = (z : Rat) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ P) :
    magnitudeSum (g.coefficients ℓ) < 2 ^ P := by
  have hg := g.lowParts_on_grid ℓ hℓ hinput
  apply extraction_coefficient_bound _ g.exponent ℓ P hℓ
  · intro z hz
    apply g.lowPart_bound
    rw [hg]
    exact List.mem_map.mpr ⟨z, hz, rfl⟩
  · simpa [coefficients, lowParts] using hbudget
```

**[TensorCore.ExtractionGrid.scalarCorrected_correct](tensor-core/TensorCore/Programs/ExtractionGrid.lean#L157)** (theorem; namespace `TensorCore.ExtractionGrid`).

If the explicit extraction-grid scalar guard accepts, proves that correction succeeds
with the nearest-even FP32 result for the exact dot product.

```lean
theorem scalarCorrected_correct (g : ExtractionGrid t) (f : Format) (ℓ : Int)
    (h : g.scalarPredicate f ℓ = true) :
    ∃ bits, g.scalarCorrected f ℓ = some bits ∧ NearestEven32 t.block.exactDot bits := by
  rw [g.scalarCorrected_eq f ℓ h]
  apply round32_nearestEven_correct
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq] at h
  simpa [retained_add_low] using h.2
```

**[TensorCore.scalarCorrectedIn_correct](tensor-core/TensorCore/Programs/ScalarEFT.lean#L80)** (theorem; namespace `TensorCore`).

If the scalar guard for the chosen consolidation format accepts, proves that generic
scalar correction returns the nearest-even FP32 ideal.

```lean
theorem scalarCorrectedIn_correct (t : BlockTrace) (f : Format) (h : t.scalarPredicateIn f = true) :
    ∃ b, t.scalarCorrectedIn f = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [scalarCorrectedIn_eq t f h]
  apply round32_nearestEven_correct
  unfold BlockTrace.scalarPredicateIn at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  rw [← retained_add_low]
  exact h.2
```

**[TensorCore.tceft_correct](tensor-core/TensorCore/Programs/EFT.lean#L310)** (theorem; namespace `TensorCore`).

Proves that every accepted reference `tceft` output satisfies nearest-even FP32 rounding
of the block's exact dot product.

```lean
theorem tceft_correct (t : BlockTrace) (b : F32) (h : t.tceft = some b) :
    NearestEven32 t.block.exactDot b := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected at h
  split at h
  · rename_i hp
    obtain ⟨b', hb', hn⟩ := scalarCorrected_correct t hp
    simp only [BlockTrace.scalarCorrected, if_pos hp] at hb'
    rw [hb'] at h
    cases Option.some.inj h
    exact hn
  · contradiction
```

**[TensorCore.tceft_isSome_iff](tensor-core/TensorCore/Programs/EFT.lean#L323)** (theorem; namespace `TensorCore`).

Proves that reference `tceft` produces output bits exactly when its scalar guard
accepts.

```lean
theorem tceft_isSome_iff (t : BlockTrace) : (t.tceft).isSome = true ↔ t.scalarPredicate = true := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected
  constructor
  · intro h
    split at h
    · assumption
    · simp at h
  · intro hp
    rw [if_pos hp]
    obtain ⟨b, hb, _⟩ := scalarCorrected_correct t hp
    simp only [BlockTrace.scalarCorrected, if_pos hp] at hb
    rw [hb]
    rfl
```

</details>

<details>
<summary>C08. Program composition — Lean declarations</summary>

**[TensorCore.Program.Correct](tensor-core/TensorCore/Programs/Program.lean#L125)** (def; namespace `TensorCore`).

Defines program correctness as successful execution, exact residual recovery, and a
final corrected output satisfying nearest-even rounding of the original ideal.

```lean
def Program.Correct {p : Profile} (pr : Program p) (c : F32) : Prop :=
  ∃ (initial : Finite32) (ts : List BlockTrace) (z : Rat) (b : F32),
    initial.bits = c ∧ pr.run c = .ok ts ∧ pr.ideal c = some z ∧
    recoveredSchedule initial ts = z ∧ correctedSchedule initial ts = some b ∧
    NearestEven32 z b
```

**[TensorCore.Program.Accurate](tensor-core/TensorCore/Programs/CertifiedProgram.lean#L6)** (def; namespace `TensorCore`).

Defines uncorrected program accuracy as successful execution with a defined original
ideal and final absolute error at most the requested tolerance.

```lean
def Program.Accurate {p : Profile} (pr : Program p) (c : F32) (tolerance : Rat) : Prop :=
  ∃ (initial : Finite32) (ts : List BlockTrace) (ideal : Rat),
    initial.bits = c ∧ pr.run c = .ok ts ∧ pr.ideal c = some ideal ∧
    absQ (ideal - (lastOutput initial ts).value) ≤ tolerance
```

**[TensorCore.evalInvocation_recovery](tensor-core/TensorCore/Theory/Invocation.lean#L89)** (theorem; namespace `TensorCore`).

For an accepted typed invocation, proves that its original-input ideal equals the output
value plus the invocation's total residual.

```lean
theorem evalInvocation_recovery {p : InvocationSpec} {x : InvocationInput p} {t : InvocationTrace p}
    (h : evalInvocation x = .ok t) :
    invocationIdeal x = some (t.output.value + t.residual) := by
  obtain ⟨_, _, hp, ha, hr, _⟩ := evalInvocation_spec h
  have hl := accumulateInvocation_recovery t.prepared t.accumulation ha
  have hc := runConversions_recovery p.intermediate t.accumulation.value t.intermediate hr
  simp only [invocationIdeal, hp, Option.map_some]
  congr 1
  unfold InvocationTrace.residual
  grind
```

**[TensorCore.Program.repeat_accurate_of_scales](tensor-core/TensorCore/Theory/ProgramBounds/Loops.lean#L39)** (theorem; namespace `TensorCore`).

Proves successful, tolerance-bounded execution of a repeated program under the stated
scale, carry, range, headroom, and accumulated-error conditions.

```lean
theorem Program.repeat_accurate_of_scales {p : Profile} (body : Program p) (n : Nat)
    (E P : Int) (L : Nat) (hE : -126 ≤ E) (hPE : P ≤ E)
    (hfl : ∀ f ∈ p.alignFloor, f ≤ E) (hL : p.products + 1 ≤ 2 ^ L)
    (hrange : E + 2 + L ≤ 127) (hscale : ∀ g ∈ body.inputs, GroupScaleBounded p g P)
    (initial : Finite32) (C tolerance : Rat) (hC : absQ initial.value ≤ C)
    (hroom : C + ((n * body.inputs.length : Nat) : Rat) *
      ((p.products : Rat) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1))
    (htol : ((n * body.inputs.length : Nat) : Rat) *
      staticBudget (p.products + 1) p.alignFraction E L ≤ tolerance) :
    (Program.repeat n body).Accurate initial.bits tolerance := by
  apply Program.accurate_of_scales _ E P L hE hPE hfl hL hrange
  · intro g hg
    rw [Program.inputs_repeat] at hg
    exact hscale g (mem_of_mem_repeatList body.inputs n g hg)
  · exact hC
  · simpa only [Program.inputs_repeat, repeatList_length] using hroom
  · simpa only [Program.staticErrorBudget, Program.inputs_repeat, repeatList_length] using htol
```

**[TensorCore.Program.recovery](tensor-core/TensorCore/Programs/Program.lean#L100)** (theorem; namespace `TensorCore`).

For a successful program run, proves that the recovered schedule value equals the
original program ideal.

```lean
theorem Program.recovery {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (h : pr.run initial.bits = .ok ts) :
    pr.ideal initial.bits = some (recoveredSchedule initial ts) := by
  have hc := runBlocks_idealContributions p initial.bits pr.inputs ts h
  have hl := runBlocks_residual_ledger p initial pr.inputs ts h
  simp only [Program.ideal, value32, initial.valid, Option.map_some, hc]
  change some (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) = _
  rw [hl]; rfl
```

**[TensorCore.Program.vc_sound](tensor-core/TensorCore/Programs/Program.lean#L139)** (theorem; namespace `TensorCore`).

Proves that the program's verification condition implies its full correctness predicate,
including successful execution and correctly rounded recovery.

```lean
theorem Program.vc_sound {p : Profile} (pr : Program p) (c : F32) (h : pr.VC c) :
    pr.Correct c := by
  unfold Program.VC at h
  cases hi : finite32 c with
  | none => simp [hi] at h
  | some initial =>
    cases he : pr.run c with
    | error e => simp [hi, he] at h
    | ok ts =>
      simp only [hi, he] at h
      have hb := finite32_bits hi
      have hr := pr.recovery initial ts (by simpa [hb] using he)
      rw [hb] at hr
      obtain ⟨b, hc, hn⟩ := round32_nearestEven_correct (recoveredSchedule initial ts) h
      exact ⟨initial, ts, recoveredSchedule initial ts, b, hb, he, hr, rfl, hc, hn⟩
```

**[TensorCore.Program.staticCertificate_sound](tensor-core/TensorCore/Programs/CertifiedProgram.lean#L31)** (theorem; namespace `TensorCore`).

Proves that an accepted static input certificate guarantees successful execution and the
requested error tolerance for the uncorrected program output.

```lean
theorem Program.staticCertificate_sound {p : Profile} (pr : Program p) (E : Int) (L : Nat)
    (c : F32) (tolerance : Rat) (h : pr.staticCertificate E L c tolerance = true) :
    pr.Accurate c tolerance := by
  simp only [Program.staticCertificate, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨initial, hbits, ts, products, hrun, hi, herr⟩ := staticCheck_sound p E L c pr.inputs h.1
  have ht : absQ (initial.value + products - (lastOutput initial ts).value) ≤ tolerance :=
    Rat.le_trans herr h.2
  have hr : pr.run initial.bits = .ok ts := by simpa [Program.run, hbits] using hrun
  have result := pr.accurate_of_run initial ts products tolerance hr hi ht
  simpa [hbits] using result
```

**[TensorCore.boundedDot_accurate_of_bits](tensor-core/TensorCore/Applications/BoundedDot.lean#L154)** (theorem; namespace `TensorCore`).

For at most 256 operand pairs satisfying the stated FP16 bit bounds and an initial
magnitude at most one, proves absolute error at most `1 / 2048`.

```lean
theorem boundedDot_accurate_of_bits (xs : List (F16 × F16)) (initial : Finite32)
    (hlen : xs.length ≤ 256)
    (hs : ∀ pair ∈ xs, pair.1.toNat % 32768 < 11264 ∧ pair.2.toNat % 32768 < 11264)
    (hc : absQ initial.value ≤ 1) : (boundedDot xs).Accurate initial.bits (1 / 2048) :=
  boundedDot_accurate xs initial hlen
    (fun pair hp => ⟨small16_of_bits _ (hs pair hp).1, small16_of_bits _ (hs pair hp).2⟩) hc
```

**[TensorCore.boundedDotCheck_sound](tensor-core/TensorCore/Applications/BoundedDot.lean#L168)** (theorem; namespace `TensorCore`).

Proves that acceptance by the bounded-dot input checker implies successful execution
with absolute error at most `1 / 2048`.

```lean
theorem boundedDotCheck_sound (xs : List (F16 × F16)) (c : F32)
    (h : boundedDotCheck xs c = true) : (boundedDot xs).Accurate c (1 / 2048) := by
  simp only [boundedDotCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨hlen, hs⟩, hc⟩ := h
  cases hv : value32 c with
  | none => simp [hv] at hc
  | some v =>
    obtain ⟨initial, _, hb, hi⟩ := finite32_of_value32 c v hv
    have hs' : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true := by
      intro pair hp
      simpa only [Bool.and_eq_true] using List.all_eq_true.mp hs pair hp
    have hcv : absQ initial.value ≤ 1 := by simpa [hv, hi] using hc
    simpa [hb] using boundedDot_accurate xs initial hlen hs' hcv
```

</details>

<details>
<summary>C09. Raw FP16 GEMM — Lean declarations</summary>

**[TensorCore.PaperSpec.gemm_eq_paper](tensor-core/TensorCore/PaperSpec/GemmEquivalence.lean#L121)** (theorem; namespace `TensorCore.PaperSpec`).

Proves cellwise agreement between raw FP16 GEMM execution and the independent WMMA
schedule specification, including observations of intermediate stages and failures.

```lean
theorem gemm_eq_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemm model A B C).map (fun row => row.map fun cell =>
      cell.toOption.map gemmCellObservation) = wmmaGemm (wmmaModel model) A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [Vector.getElem_map, wmmaGemm, Vector.getElem_ofFn]
  rw [gemm_entry model A B C ⟨i, hi⟩ ⟨j, hj⟩]
  exact simulateGemmCell_eq_paper model (gemmPairs A B ⟨i, hi⟩ ⟨j, hj⟩) C[i][j]
```

**[TensorCore.PaperSpec.gemm_rejected_iff_paper](tensor-core/TensorCore/PaperSpec/GemmEquivalence.lean#L158)** (theorem; namespace `TensorCore.PaperSpec`).

Proves that the implementation and independent raw FP16 GEMM specification reject
exactly the same output cells.

```lean
theorem gemm_rejected_iff_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) :
    (wmmaGemm (wmmaModel model) A B C)[i.val][j.val] = none ↔
      ∃ e, (gemm model A B C)[i.val][j.val] = .error e := by
  rw [← gemm_eq_paper]
  simp only [Vector.getElem_map]
  cases he : (gemm model A B C)[i.val][j.val] <;> simp [Except.toOption]
```

**[TensorCore.PaperSpec.gemmBits_eq_paper](tensor-core/TensorCore/PaperSpec/GemmEquivalence.lean#L134)** (theorem; namespace `TensorCore.PaperSpec`).

Proves equality of the raw FP16 GEMM output-bit matrices, with each failed cell
represented as `none`.

```lean
theorem gemmBits_eq_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemmBits model A B C).map (fun row => row.map Except.toOption) =
      wmmaGemmBits (wmmaModel model) A B C := by
  rw [wmmaGemmBits, ← gemm_eq_paper]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [gemmBits, Vector.getElem_map]
  cases he : (gemm model A B C)[i][j] with
  | error e => rfl
  | ok cell => simp [Except.toOption, Except.map, gemmCellObservation_output]
```

</details>

<details>
<summary>C10. Native BF16/TF32 GEMM — Lean declarations</summary>

**[TensorCore.NativeConvertedGemmAccurate](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean#L58)** (def; namespace `TensorCore`).

Defines successful source-converted BF16/TF32 GEMM with every output entry within
tolerance of the original source-value ideal.

```lean
def NativeConvertedGemmAccurate (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : Rat) : Prop :=
  ∃ D, nativeConvertedGemm source mode model cfg alpha beta A B C = some D ∧
    ∀ i : Fin m, ∀ j : Fin n, ∃ t z, D[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ tol
```

**[TensorCore.PaperSpec.nativeGemm_eq_paper](tensor-core/TensorCore/PaperSpec/NativeGemmEquivalence.lean#L42)** (theorem; namespace `TensorCore.PaperSpec`).

Proves that raw BF16/TF32 GEMM cell observations and rejection agree with the
independent specification for the selected native-precision schedule.

```lean
theorem nativeGemm_eq_paper (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) :
    (nativeGemm model A B C).map (fun row => row.map fun cell =>
      cell.map fun t => t.blocks.map fun b => b.output.bits) =
      nativeMatrix (parametersOf model.profile) p.inner A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [nativeGemm, DenseMatrix.ofFn, nativeMatrix, Vector.getElem_map, Vector.getElem_ofFn]
  exact nativeGemmCell_eq_paper model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩) C[i][j]
```

**[TensorCore.nativeAnalysisCheck_sound](tensor-core/TensorCore/Programs/NativeGemm.lean#L199)** (theorem; namespace `TensorCore`).

Proves that an accepted native-precision GEMM analysis certificate guarantees successful
cells and the requested error tolerance.

```lean
theorem nativeAnalysisCheck_sound (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n)
    (ws : DenseMatrix (List GroupWitness) m n) (tol : Rat)
    (h : nativeAnalysisCheck model A B C ws tol = true) : NativeGemmAccurate model A B C tol := by
  simp only [nativeAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro i j
  have hc := h.2 i j
  cases hb : checkNativeCell model (nativePairs A B i j) C[i.val][j.val] ws[i.val][j.val] with
  | none => simp [hb] at hc
  | some b =>
    simp only [hb, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
    obtain ⟨cell, products, hr, hp, hv, _, he⟩ := checkNativeCell_sound model _ _ _ b hb
    exact ⟨cell, cell.initial.value + products, by simpa [nativeGemm, DenseMatrix.ofFn] using hr,
      by simp [nativeGemmIdeal, DenseMatrix.ofFn, hv, hp], Rat.le_trans he hc⟩
```

**[TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](tensor-core/TensorCore/PaperSpec/NativeScaledGemmEquivalence.lean#L65)** (theorem; namespace `TensorCore.PaperSpec`).

Proves complete equivalence of source-converted BF16/TF32 GEMM with its independent
specification, including source conversion, scalar stages, output conversion, and
failures.

```lean
theorem nativeConvertedGemm_eq_independent (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (nativeConvertedGemm source mode model cfg alpha beta A B C).map
      (fun D => D.map fun row => row.map fun cell => cell.map scaledCellObservation) =
      nativeConvertedMatrix (layoutOf source) (scalarModeOf mode) (parametersOf model.profile)
        p.inner (epilogueOf cfg) alpha beta A B C := by
  simp only [nativeConvertedGemm, nativeConvertedMatrix, parametersOf, NativeGemmModel.profile, convertMatrixToLayout_eq]
  cases ha : convertMatrixTo source p.format mode A <;> cases hb : convertMatrixTo source p.format mode B <;>
    simp [bind, pure, nativeScaledGemm_eq_independent] <;> rfl
```

**[TensorCore.nativeConvertedAnalysisCheck_paper](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean#L162)** (theorem; namespace `TensorCore`).

Transfers an accepted source-converted BF16/TF32 analysis certificate to successful
independent-specification outputs with the requested source-relative error bound.

```lean
theorem nativeConvertedAnalysisCheck_paper (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : Rat)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ∃ D, PaperSpec.nativeConvertedMatrix (PaperSpec.layoutOf source) (PaperSpec.scalarModeOf mode)
        (PaperSpec.parametersOf model.profile) precision.inner (PaperSpec.epilogueOf cfg) alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t d z, D[i.val][j.val] = some t ∧
        binaryValue cfg.output.format t.output = some d ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨out, hr, entries⟩ := nativeConvertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  refine ⟨out.map (fun row => row.map fun t => t.map PaperSpec.scaledCellObservation), ?_, ?_⟩
  · rw [← PaperSpec.nativeConvertedGemm_eq_independent, hr]
    rfl
  · intro i j
    obtain ⟨t, z, ht, hz, he⟩ := entries i j
    refine ⟨PaperSpec.scaledCellObservation t, t.output.value, z, ?_, ?_, hz, he⟩
    · simp [ht]
    · simp [PaperSpec.scaledCellObservation, binaryValue, t.output.valid, FiniteBinary.value]
```

**[TensorCore.analyzeNativeConvertedGemm_matrix_error](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean#L182)** (theorem; namespace `TensorCore`).

When every analysis cell succeeds and `D` and `Z` identify the computed and ideal
matrices, bounds the sum of absolute entry errors by the summed inferred budgets.

```lean
theorem analyzeNativeConvertedGemm_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeNativeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (hcells : ∀ i : Fin m, ∀ j : Fin n, ∃ cell, cells[i.val][j.val] = some cell)
    (D Z : DenseMatrix Rat m n)
    (hd : ∀ out, nativeConvertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (pipelineEntryBounds cells) := by
  cases ha : convertMatrixTo source precision.format mode A with
  | none => simp [analyzeNativeConvertedGemm, ha] at h
  | some a =>
    cases hb : convertMatrixTo source precision.format mode B with
    | none => simp [analyzeNativeConvertedGemm, ha, hb] at h
    | some b =>
      have hr : nativeConvertedGemm source mode model cfg alpha beta A B C =
          some (nativeScaledGemm model cfg alpha beta a b C) := by simp [nativeConvertedGemm, ha, hb]
      apply matrixAbsSum_le_entry_bounds
      intro i j
      obtain ⟨cell, hcell⟩ := hcells i j
      have hchecked := analyzeNativeConvertedGemm_checked source mode model cfg alpha beta A B C cells h
        a b ha hb i j cell hcell
      obtain ⟨t, z, ht, hi, _, he⟩ := checkNativeConvertedCell_sound source mode model cfg alpha beta
        A B C a b ha hb i j cell.witness cell.bound hchecked
      rw [hz i j] at hi
      cases Option.some.inj hi
      simpa [DenseMatrix.ofFn, pipelineEntryBounds, hcell, hd _ hr i j t ht] using he
```

**[TensorCore.PaperSpec.nativeScaledGemm_eq_independent](tensor-core/TensorCore/PaperSpec/NativeScaledGemmEquivalence.lean#L31)** (theorem; namespace `TensorCore.PaperSpec`).

Proves complete equivalence of the BF16/TF32 scaled pipeline and its independent
specification, including the separately rounded scalar epilogue and rejection.

```lean
theorem nativeScaledGemm_eq_independent (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) :
    (nativeScaledGemm model cfg alpha beta A B C).map (fun row => row.map fun cell =>
      cell.map scaledCellObservation) =
      nativeScaledMatrix (parametersOf model.profile) p.inner (epilogueOf cfg) alpha beta A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [nativeScaledGemm, nativeScaledMatrix, DenseMatrix.ofFn, Vector.getElem_map, Vector.getElem_ofFn]
  change ((nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).bind
    (gemmEpilogue cfg alpha beta C[i][j])).map scaledCellObservation =
    ((nativeProductMatrixCell (parametersOf model.profile) p.inner (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
  calc
    _ = ((nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).map gemmCellObservation).bind
        (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]) := by
      cases nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩) with
      | none => rfl
      | some product => exact (scalarEpilogue_eq cfg alpha beta C[i][j] product).symm
    _ = _ := congrArg (fun product : Option MatrixCell => product.bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
      (nativeProductCell_eq_independent model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩))
```

</details>

<details>
<summary>C11. Complete scaled FP16 GEMM — Lean declarations</summary>

**[TensorCore.PaperSpec.convertedGemm_eq_independent](tensor-core/TensorCore/PaperSpec/ScaledGemmEquivalence.lean#L131)** (theorem; namespace `TensorCore.PaperSpec`).

Proves equivalence of the full source-converted FP16 pipeline and its independent
specification, including every conversion, scalar stage, and failure.

```lean
theorem convertedGemm_eq_independent (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemm source inputMode model cfg alpha beta A B C).map
      (fun D => D.map fun row => row.map fun cell => cell.map scaledCellObservation) =
      convertedMatrix (layoutOf source) (scalarModeOf inputMode) (wmmaModel model)
        (epilogueOf cfg) alpha beta A B C := by
  simp only [convertedGemm, convertedMatrix, convertMatrix_eq]
  cases ha : convertGemmInput source inputMode A <;> cases hb : convertGemmInput source inputMode B <;>
    simp [bind, pure, scaledGemm_eq_independent] <;> rfl
```

**[TensorCore.PaperSpec.scaledGemm_eq_independent](tensor-core/TensorCore/PaperSpec/ScaledGemmEquivalence.lean#L69)** (theorem; namespace `TensorCore.PaperSpec`).

Proves equivalence of the scaled FP16 GEMM pipeline and its independent specification,
including the tensor product, scalar epilogue, output conversion, and failure cases.

```lean
theorem scaledGemm_eq_independent (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    (scaledGemm model cfg alpha beta A B C).map (fun row => row.map fun cell =>
      cell.map scaledCellObservation) = scaledMatrix (wmmaModel model) (epilogueOf cfg) alpha beta A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [Vector.getElem_map]
  have hm := congrArg (fun D => D[i][j]) (gemm_eq_paper model A B (DenseMatrix.ofFn fun _ _ => 0))
  simp only [Vector.getElem_map] at hm
  simp only [scaledGemm, scaledMatrix, DenseMatrix.ofFn, Vector.getElem_ofFn]
  change ((gemm model A B (DenseMatrix.ofFn fun _ _ => 0))[i][j].toOption.bind
    (gemmEpilogue cfg alpha beta C[i][j])).map scaledCellObservation =
    ((wmmaGemm (wmmaModel model) A B (DenseMatrix.ofFn fun _ _ => 0))[i][j].bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
  rw [← hm]
  cases hp : (gemm model A B (DenseMatrix.ofFn fun _ _ => 0))[i][j] with
  | error e => rfl
  | ok product => exact (scalarEpilogue_eq cfg alpha beta C[i][j] product).symm
```

</details>

<details>
<summary>C12. Input-derived error certificates — Lean declarations</summary>

**[TensorCore.GemmAccurate](tensor-core/TensorCore/Programs/GemmAnalysis.lean#L77)** (def; namespace `TensorCore`).

Defines raw GEMM accuracy by requiring successful execution and a defined ideal at every
output entry, with each absolute error within tolerance.

```lean
def GemmAccurate (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tolerance : Rat) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ cell z,
    (gemm model A B C)[i.val][j.val] = .ok cell ∧
    (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tolerance
```

**[TensorCore.ConvertedGemmAccurate](tensor-core/TensorCore/Programs/ConvertedGemmAnalysis.lean#L44)** (def; namespace `TensorCore`).

Defines successful source-converted FP16 GEMM with each output entry within tolerance of
the ideal computed from the original source values.

```lean
def ConvertedGemmAccurate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : Rat) : Prop :=
  ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
    ∀ i : Fin m, ∀ j : Fin n, ∃ t z, D[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ tol
```

**[TensorCore.gemmAnalysisCheck_sound](tensor-core/TensorCore/Programs/GemmAnalysis.lean#L83)** (theorem; namespace `TensorCore`).

Proves that an accepted raw FP16 GEMM analysis certificate guarantees the entrywise
accuracy predicate, including successful execution.

```lean
theorem gemmAnalysisCheck_sound (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : Rat)
    (h : gemmAnalysisCheck model A B C witness tolerance = true) :
    GemmAccurate model A B C tolerance := by
  simp only [gemmAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro i j
  have hc := h.2 i j
  cases hb : checkGemmCell model (gemmPairs A B i j) C[i.val][j.val] witness[i.val][j.val] with
  | none => simp [hb] at hc
  | some b =>
    simp only [hb, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
    obtain ⟨cell, products, hr, hp, hv, _, he⟩ := checkGemmCell_sound model _ _ _ b hb
    refine ⟨cell, cell.initial.value + products, ?_, ?_, Rat.le_trans he hc⟩
    · rwa [gemm_entry]
    · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]
```

**[TensorCore.convertedAnalysisCheck_paper](tensor-core/TensorCore/Programs/ConvertedGemmAnalysis.lean#L150)** (theorem; namespace `TensorCore`).

Transfers an accepted source-converted FP16 analysis certificate to successful
independent-specification outputs and the requested source-relative error bound.

```lean
theorem convertedAnalysisCheck_paper (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : Rat)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ∃ D, PaperSpec.convertedMatrix (PaperSpec.layoutOf source) (PaperSpec.scalarModeOf mode)
        (PaperSpec.wmmaModel model) (PaperSpec.epilogueOf cfg) alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t d z, D[i.val][j.val] = some t ∧
        binaryValue cfg.output.format t.output = some d ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨out, hr, entries⟩ := convertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  refine ⟨out.map (fun row => row.map fun t => t.map PaperSpec.scaledCellObservation), ?_, ?_⟩
  · rw [← PaperSpec.convertedGemm_eq_independent, hr]
    rfl
  · intro i j
    obtain ⟨t, z, ht, hz, he⟩ := entries i j
    refine ⟨PaperSpec.scaledCellObservation t, t.output.value, z, ?_, ?_, hz, he⟩
    · simp [ht]
    · simp [PaperSpec.scaledCellObservation, binaryValue, t.output.valid, FiniteBinary.value]
```

**[TensorCore.analyzeConvertedGemm_matrix_error](tensor-core/TensorCore/Programs/ConvertedGemmAnalysis.lean#L173)** (theorem; namespace `TensorCore`).

With successful analysis at every cell and matrices identifying actual and ideal values,
bounds the total absolute entry error by the inferred entry budgets.

```lean
theorem analyzeConvertedGemm_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (hcells : ∀ i : Fin m, ∀ j : Fin n, ∃ cell, cells[i.val][j.val] = some cell)
    (D Z : DenseMatrix Rat m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (pipelineEntryBounds cells) := by
  cases ha : convertGemmInput source mode A with
  | none => simp [analyzeConvertedGemm, ha] at h
  | some a =>
    cases hb : convertGemmInput source mode B with
    | none => simp [analyzeConvertedGemm, ha, hb] at h
    | some b =>
      have hr : convertedGemm source mode model cfg alpha beta A B C =
          some (scaledGemm model cfg alpha beta a b C) := by simp [convertedGemm, ha, hb]
      apply matrixAbsSum_le_entry_bounds
      intro i j
      obtain ⟨cell, hcell⟩ := hcells i j
      have hchecked := analyzeConvertedGemm_checked source mode model cfg alpha beta A B C cells h
        a b ha hb i j cell hcell
      obtain ⟨t, z, ht, hi, _, he⟩ := checkConvertedCell_sound source mode model cfg alpha beta
        A B C a b ha hb i j cell.witness cell.bound hchecked
      rw [hz i j] at hi
      cases Option.some.inj hi
      simpa [DenseMatrix.ofFn, pipelineEntryBounds, hcell, hd _ hr i j t ht] using he
```

</details>

<details>
<summary>C13. Tighter bounds — Lean declarations</summary>

**[TensorCore.scaledGemmTightError_le](tensor-core/TensorCore/Programs/GemmTightBounds.lean#L147)** (theorem; namespace `TensorCore`).

Proves that the tighter scaled FP16 GEMM error budget is no larger than the earlier
budget for the same configuration.

```lean
theorem scaledGemmTightError_le (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha : F32) (k : Nat) :
    scaledGemmTightError model cfg b alpha k ≤ scaledGemmStaticError model cfg b alpha k := by
  have := scaledGemmTightScalarBudget_le cfg b
  unfold scaledGemmTightError scaledGemmStaticError
  grind
```

**[TensorCore.gemmInputPairTightError_le](tensor-core/TensorCore/Programs/GemmTightInputBounds.lean#L58)** (theorem; namespace `TensorCore`).

Proves that the tighter input-conversion error budget for one product is no larger than
the earlier budget.

```lean
theorem gemmInputPairTightError_le (a b : GemmInputDatum) :
    gemmInputPairTightError a b ≤ gemmInputPairError a b := by
  have hb := absQ_add_le b.value (b.converted - b.value)
  have hid : b.value + (b.converted - b.value) = b.converted := by grind
  rw [hid, absQ_sub_comm] at hb
  have hm := Rat.mul_le_mul_of_nonneg_right hb (absQ_nonneg (a.value - a.converted))
  unfold gemmInputPairTightError gemmInputPairError GemmInputDatum.error
  rw [Rat.min_def]
  split <;> grind
```

**[TensorCore.checkFiniteMultiply_sound](tensor-core/TensorCore/Programs/ExactScalarAnalysis.lean#L8)** (theorem; namespace `TensorCore`).

For any finite FP32 operand within the supplied magnitude cap, an accepted
multiplication check guarantees a rounded result within its reported magnitude and error
bounds.

```lean
theorem checkFiniteMultiply_sound (mode : BinaryRoundingMode) (a M : Rat) (E : Int)
    (b : ScalarBound) (h : checkFiniteMultiply mode a M E = some b)
    (x : Rat) (hf : fp32.FiniteValue x) (hx : absQ x ≤ M) :
    ∃ d, (ConversionStage.mk fp32 mode).convert (a * x) = some d ∧
      absQ d.value ≤ b.magnitude ∧ absQ (a * x - d.value) ≤ b.error := by
  unfold checkFiniteMultiply at h
  split at h
  next ha =>
    cases Option.some.inj h
    have hfinite : fp32.FiniteValue (a * x) := by
      rcases ha with rfl | rfl
      · simpa using hf
      · simpa [Rat.neg_mul] using fp32.finiteValue_neg hf
    obtain ⟨d, hd, hv⟩ := conversion_exact_value ⟨fp32, mode⟩ (by change fp32.WellFormed; decide) (a * x) hfinite
    refine ⟨d, hd, ?_, by simp [hv, Rat.sub_self, absQ]⟩
    rw [hv]
    rcases ha with rfl | rfl <;> simpa [Rat.neg_mul, absQ_neg] using hx
  next _ =>
    exact checkScalar_sound _ _ _ b h (a * x) (by
      rw [gemmAbs_mul]
      exact Rat.mul_le_mul_of_nonneg_left hx (absQ_nonneg a))
```

**[TensorCore.checkFiniteAdd_sound](tensor-core/TensorCore/Programs/ExactScalarAnalysis.lean#L33)** (theorem; namespace `TensorCore`).

For finite FP32 operands within the supplied caps, an accepted addition check guarantees
a rounded result within its reported magnitude and error bounds.

```lean
theorem checkFiniteAdd_sound (mode : BinaryRoundingMode) (A B : Rat) (E : Int)
    (b : ScalarBound) (h : checkFiniteAdd mode A B E = some b)
    (x y : FiniteBinary fp32) (hx : absQ x.value ≤ A) (hy : absQ y.value ≤ B) :
    ∃ d, (ConversionStage.mk fp32 mode).convert (x.value + y.value) = some d ∧
      absQ d.value ≤ b.magnitude ∧ absQ (x.value + y.value - d.value) ≤ b.error := by
  have hm : absQ (x.value + y.value) ≤ A + B := by
    have := absQ_add_le x.value y.value
    grind
  unfold checkFiniteAdd at h
  split at h
  next hz =>
    cases Option.some.inj h
    have hf : fp32.FiniteValue (x.value + y.value) := by
      rcases hz with hz | hz
      · have hx0 : x.value = 0 := by have := (absQ_le_iff _ _).mp hx; grind
        rw [hx0, Rat.zero_add]
        exact classifyNat_finiteValue fp32 (by decide) y.bits.toNat y.decoded y.valid
      · have hy0 : y.value = 0 := by have := (absQ_le_iff _ _).mp hy; grind
        rw [hy0, Rat.add_zero]
        exact classifyNat_finiteValue fp32 (by decide) x.bits.toNat x.decoded x.valid
    obtain ⟨d, hd, hv⟩ := conversion_exact_value ⟨fp32, mode⟩ (by change fp32.WellFormed; decide) _ hf
    exact ⟨d, hd, by simpa [hv] using hm, by simp [hv, Rat.sub_self, absQ]⟩
  next _ => exact checkScalar_sound _ _ _ b h _ hm
```

</details>

<details>
<summary>C14. Quantified families — Lean declarations</summary>

**[TensorCore.GemmFamilyAccurate](tensor-core/TensorCore/Programs/GemmFamily.lean#L132)** (def; namespace `TensorCore`).

Defines accuracy for every matrix triple satisfying the family's uniform finite-value
magnitude caps.

```lean
def GemmFamilyAccurate (model : WmmaGemmModel) (f : GemmFamily) (m n k : Nat) (tol : Rat) : Prop :=
  ∀ (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n),
    f.Contains A B C → GemmAccurate model A B C tol
```

**[TensorCore.EntryFamilyAccurate](tensor-core/TensorCore/Programs/EntryFamily.lean#L50)** (def; namespace `TensorCore`).

Defines accuracy for every matrix triple satisfying the family's individual entry caps.

```lean
def EntryFamilyAccurate (model : WmmaGemmModel) (f : EntryFamily m n k) (tol : Rat) : Prop :=
  ∀ A B C, f.Contains A B C → GemmAccurate model A B C tol
```

**[TensorCore.familyCheck_sound](tensor-core/TensorCore/Programs/GemmFamily.lean#L136)** (theorem; namespace `TensorCore`).

Proves that one accepted uniform-family certificate guarantees the requested GEMM
accuracy for every member of that family.

```lean
theorem familyCheck_sound (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (m n k : Nat) (tol : Rat) (h : familyCheck model k f cfg tol = true) :
    GemmFamilyAccurate model f m n k tol := by
  simp only [familyCheck, Bool.and_eq_true, Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at h
  intro A B C hmem i j
  by_cases hk : k = 0
  · subst k
    obtain ⟨dc, hdc, _⟩ := hmem.2.2 i j
    change decode32 C[i.val][j.val] = some dc at hdc
    have hcv : value32 C[i.val][j.val] = some dc.value := by simp only [value32, hdc, Option.map_some]
    obtain ⟨initial, hf, _, hv⟩ := finite32_of_value32 C[i.val][j.val] dc.value hcv
    have hp : gemmPairs A B i j = [] := by simp [gemmPairs]
    refine ⟨⟨initial, []⟩, initial.value, ?_, ?_, ?_⟩
    · rw [gemm_entry, hp]
      simp [simulateGemmCell, hf, gemmInstructions, canonicalPartition, partitionExact,
        OrderedPartition.inputs, padFp16Pairs, groupCount, tailPadding, runGemmInstructions]
    · simp only [gemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, hp, hcv, bind, pure, Option.bind_some]
      change some (dc.value + 0) = some initial.value
      rw [hv, Rat.add_zero]
    · change absQ (initial.value - initial.value) ≤ tol
      simpa [Rat.sub_self, absQ] using h.1.1.2.2.2
  · have hc := h.1.2.resolve_left hk
    obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound model cfg A B C
      (familyConditions_gemmCheck model f cfg A B C hc hmem) i j
    refine ⟨cell, z, hr, hi, Rat.le_trans he ?_⟩
    simpa [familyError, hk] using h.2
```

**[TensorCore.entryFamilyCheck_sound](tensor-core/TensorCore/Programs/EntryFamily.lean#L84)** (theorem; namespace `TensorCore`).

Proves that an accepted set of per-cell family witnesses guarantees accuracy for every
matrix triple satisfying the entry caps.

```lean
theorem entryFamilyCheck_sound (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : Rat)
    (h : entryFamilyCheck model f ws tol = true) : EntryFamilyAccurate model f tol := by
  simp only [entryFamilyCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro A B C hm i j
  exact entryFamily_cell_sound model f A B C hm i j ws[i.val][j.val] tol (h.2 i j)
```

**[TensorCore.entryFamilyCheck_matrix_error](tensor-core/TensorCore/Programs/EntryFamily.lean#L91)** (theorem; namespace `TensorCore`).

For an accepted entry-family certificate and any member matrices, bounds total absolute
entry error by the sum of the family error budgets.

```lean
theorem entryFamilyCheck_matrix_error (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : Rat)
    (h : entryFamilyCheck model f ws tol = true)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (hm : f.Contains A B C) (D Z : DenseMatrix Rat m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (ws.map fun row => row.map (familyError model k)) := by
  simp only [entryFamilyCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  apply matrixAbsSum_le_entry_bounds
  intro i j
  have hc := familyCheck_at_bound model k (f.cell i j) ws[i.val][j.val] tol (h.2 i j)
  obtain ⟨cell, z, hr, hi, he⟩ := entryFamily_cell_sound model f A B C hm i j ws[i.val][j.val] _ hc
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he
```

</details>

<details>
<summary>C15. Certified decisions — Lean declarations</summary>

**[TensorCore.GemmProblem.Accurate](tensor-core/TensorCore/Programs/GemmSelection.lean#L41)** (def; namespace `TensorCore`).

Selects the accuracy contract appropriate to a workload: raw, converted, quantified
family, or native-precision GEMM.

```lean
def GemmProblem.Accurate (p : GemmProblem m n k) (c : GemmCandidate) (tol : Rat) : Prop :=
  match p with
  | .raw A B C => GemmAccurate c.model A B C tol
  | .scaled source alpha beta A B C =>
    ConvertedGemmAccurate source c.inputMode c.model c.epilogue alpha beta A B C tol
  | .family f => GemmFamilyAccurate c.model f m n k tol
  | .entryFamily f => EntryFamilyAccurate c.model f tol
  | .native precision A B C => ∃ model, c.nativeModel precision = some model ∧ NativeGemmAccurate model A B C tol
  | .nativeScaled precision source outputMode alpha beta A B C => ∃ model,
    c.nativeModel precision = some model ∧
    NativeConvertedGemmAccurate source c.inputMode model (c.nativeEpilogue outputMode) alpha beta A B C tol
```

**[TensorCore.selectGemm_sound](tensor-core/TensorCore/Programs/GemmSelection.lean#L131)** (theorem; namespace `TensorCore`).

Proves that a selected candidate satisfies the requested accuracy and that every earlier
candidate failed certification.

```lean
theorem selectGemm_sound (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : Rat)
    (i : Nat) (h : selectGemm p candidates tol = some i) :
    ∃ hi : i < candidates.length, p.Accurate candidates[i] tol ∧
      ∀ j (hj : j < i), candidateCertified p tol candidates[j] = false := by
  obtain ⟨hi, hc, hp⟩ := List.findIdx?_eq_some_iff_getElem.mp h
  exact ⟨hi, candidateCertified_sound p tol candidates[i] hc, fun j hj => by simpa using hp j hj⟩
```

**[TensorCore.selectGemm_none](tensor-core/TensorCore/Programs/GemmSelection.lean#L145)** (theorem; namespace `TensorCore`).

Proves that selection returns no candidate exactly when every candidate fails
certification. It does not conclude that those candidates are inaccurate.

```lean
theorem selectGemm_none (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : Rat) :
    selectGemm p candidates tol = none ↔ ∀ c ∈ candidates, candidateCertified p tol c = false := by
  exact List.findIdx?_eq_none_iff
```

**[TensorCore.selectGemmCost_sound](tensor-core/TensorCore/Programs/CostSelection.lean#L31)** (theorem; namespace `TensorCore`).

Proves that the chosen candidate belongs to the supplied list, is accurate, and has
minimum supplied cost among certified candidates.

```lean
theorem selectGemmCost_sound (p : GemmProblem m n k) (candidates : List CostedCandidate)
    (tol : Rat) (chosen : CostedCandidate) (h : selectGemmCost p candidates tol = some chosen) :
    chosen ∈ candidates ∧ p.Accurate chosen.configuration tol ∧
      ∀ c ∈ candidates, candidateCertified p tol c.configuration = true → chosen.cost ≤ c.cost := by
  obtain ⟨hm, hc, hmin⟩ := selectMinimumCost_sound _ _ candidates chosen h
  exact ⟨hm, candidateCertified_sound p tol chosen.configuration hc, hmin⟩
```

</details>

<details>
<summary>C16. Pinned CUTLASS connection — Lean declarations</summary>

**[TensorCore.CutlassWmma.project_eq_gemm](tensor-core/TensorCore/Kernels/CutlassWmma.lean#L118)** (theorem; namespace `TensorCore.CutlassWmma`).

Proves that the pinned CUTLASS arithmetic projection agrees with V100 GEMM using zero
`C` and a reduction dimension of `16 * tiles`.

```lean
theorem project_eq_gemm (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) :
    project A B = (gemm .v100 A B (DenseMatrix.ofFn fun _ _ => 0)).map
      (fun row => row.map fun cell => cell.toOption.map PaperSpec.gemmCellObservation) := by
  rw [PaperSpec.gemm_eq_paper]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [project, PaperSpec.wmmaGemm, DenseMatrix.ofFn, Vector.getElem_ofFn]
  rw [instructions_eq_paper A B ⟨i, hi⟩ ⟨j, hj⟩]
  rfl
```

**[TensorCore.CutlassWmma.project_check_sound](tensor-core/TensorCore/Kernels/CutlassWmma.lean#L133)** (theorem; namespace `TensorCore.CutlassWmma`).

Transfers an accepted V100 GEMM check to the CUTLASS arithmetic projection, proving a
defined ideal, successful cell result, and the stated error bound.

```lean
theorem project_check_sound (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) (cfg : GemmBoundConfig)
    (h : gemmCheck .v100 cfg A B (DenseMatrix.ofFn fun _ _ => 0) = true)
    (i : Fin m) (j : Fin n) :
    ∃ cell z, (project A B)[i.val][j.val] = some (PaperSpec.gemmCellObservation cell) ∧
      (gemmIdeal A B (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError .v100 cfg (16 * tiles) := by
  obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound .v100 cfg A B _ h i j
  refine ⟨cell, z, ?_, hi, he⟩
  rw [project_eq_gemm]
  simp only [Vector.getElem_map, hr]
  rfl
```

</details>

<details>
<summary>C17. IEEE scalar results — Lean declarations</summary>

**[TensorCore.IEEE.InfinitySpec](tensor-core/TensorCore/IEEE/Specification.lean#L9)** (def; namespace `TensorCore.IEEE`).

Defines an infinity result with the requested sign and all exception flags clear.

```lean
def InfinitySpec (f : BinaryFormat) (s : Bool) (r : Result f) : Prop :=
  decode f r.bits = .infinity s ∧ r.flags = {}
```

**[TensorCore.IEEE.InvalidSpec](tensor-core/TensorCore/IEEE/Specification.lean#L12)** (def; namespace `TensorCore.IEEE`).

Defines an invalid-operation result as a quiet NaN with only the invalid flag set.

```lean
def InvalidSpec (f : BinaryFormat) (r : Result f) : Prop :=
  (∃ s p, decode f r.bits = .nan s false p) ∧ r.flags = { invalid := true }
```

**[TensorCore.IEEE.NaNSpec](tensor-core/TensorCore/IEEE/Specification.lean#L15)** (def; namespace `TensorCore.IEEE`).

Defines the selected NaN sign and payload, quieting behavior, and invalid flag from
signaling inputs or an additional invalid condition.

```lean
def NaNSpec (f : BinaryFormat) (xs : List Datum) (extra : Bool) (r : Result f) : Prop :=
  let n := (chooseNaN xs).getD ⟨false, false, 0⟩
  decode f r.bits = .nan n.negative false (n.payload % quietBit f) ∧
  r.flags = { invalid := extra || xs.any Datum.isSignaling }
```

**[TensorCore.IEEE.ConvertSpec](tensor-core/TensorCore/IEEE/Specification.lean#L69)** (def; namespace `TensorCore.IEEE`).

Defines conversion for finite values, infinities, and NaNs, including rounding, sign,
payload conversion, and signaling-NaN flags.

```lean
def ConvertSpec (source target : BinaryFormat) (cfg : Context) (a : Datum) (r : Result target) : Prop :=
  match a with
  | .finite s x => RoundSpec target cfg s x r
  | .infinity s => InfinitySpec target s r
  | .nan s sig p =>
      decode target r.bits = .nan s false (convertPayload source target p % quietBit target) ∧
      r.flags = { invalid := sig }
```

**[TensorCore.IEEE.AddSpec](tensor-core/TensorCore/IEEE/Specification.lean#L30)** (def; namespace `TensorCore.IEEE`).

Defines addition's full case contract: rounded exact finite sums, infinity handling, NaN
propagation, and invalid opposite infinities.

```lean
def AddSpec (f : BinaryFormat) (cfg : Context) (a b : Datum) (r : Result f) : Prop :=
  if a.isNaN || b.isNaN then NaNSpec f [a, b] false r else
  match a, b with
  | .finite sa x, .finite sb y => RoundSpec f cfg (sumZeroSign cfg.mode sa sb) (x + y) r
  | .infinity sa, .infinity sb =>
      if sa = sb then InfinitySpec f sa r else InvalidSpec f r
  | .infinity s, _ | _, .infinity s => InfinitySpec f s r
  | _, _ => False
```

**[TensorCore.IEEE.MulSpec](tensor-core/TensorCore/IEEE/Specification.lean#L39)** (def; namespace `TensorCore.IEEE`).

Defines multiplication's full case contract, including exact finite products, result
signs, NaN propagation, and invalid zero-times-infinity cases.

```lean
def MulSpec (f : BinaryFormat) (cfg : Context) (a b : Datum) (r : Result f) : Prop :=
  if a.isNaN || b.isNaN then NaNSpec f [a, b] false r else
  match a, b with
  | .finite sa x, .finite sb y => RoundSpec f cfg (xor sa sb) (x * y) r
  | .infinity sa, .infinity sb => InfinitySpec f (xor sa sb) r
  | .infinity sa, .finite sb y =>
      if y = 0 then InvalidSpec f r else InfinitySpec f (xor sa sb) r
  | .finite sa x, .infinity sb =>
      if x = 0 then InvalidSpec f r else InfinitySpec f (xor sa sb) r
  | _, _ => False
```

**[TensorCore.IEEE.FmaSpec](tensor-core/TensorCore/IEEE/Specification.lean#L50)** (def; namespace `TensorCore.IEEE`).

Defines fused multiply-add with one rounding of the exact finite product plus addend,
together with its complete infinity, NaN, and invalid-operation cases.

```lean
def FmaSpec (f : BinaryFormat) (cfg : Context) (a b c : Datum) (r : Result f) : Prop :=
  if a.isNaN || b.isNaN || c.isNaN then NaNSpec f [a, b, c] (invalidProduct a b) r else
  match a, b, c with
  | .finite sa x, .finite sb y, .finite sc z =>
      RoundSpec f cfg (sumZeroSign cfg.mode (xor sa sb) sc) (x * y + z) r
  | .finite _ _, .finite _ _, .infinity sc => InfinitySpec f sc r
  | .infinity sa, .finite sb y, c =>
      if y = 0 then InvalidSpec f r else
      if c.isInfinite && xor sa sb != c.negative then InvalidSpec f r
      else InfinitySpec f (xor sa sb) r
  | .finite sa x, .infinity sb, c =>
      if x = 0 then InvalidSpec f r else
      if c.isInfinite && xor sa sb != c.negative then InvalidSpec f r
      else InfinitySpec f (xor sa sb) r
  | .infinity sa, .infinity sb, c =>
      if c.isInfinite && xor sa sb != c.negative then InvalidSpec f r
      else InfinitySpec f (xor sa sb) r
  | _, _, _ => False
```

**[TensorCore.IEEE.convert_correct](tensor-core/TensorCore/IEEE/Specification.lean#L125)** (theorem; namespace `TensorCore.IEEE`).

Proves that conversion satisfies its complete case contract for every encoded input,
source and target format, and rounding context.

```lean
theorem convert_correct (source target : BinaryFormat) (cfg : Context) (a : Word source) :
    ConvertSpec source target cfg (decode source a) (convert source target cfg a) :=
  convertDatum_correct _ _ _ _
```

**[TensorCore.IEEE.add_correct](tensor-core/TensorCore/IEEE/Specification.lean#L111)** (theorem; namespace `TensorCore.IEEE`).

Proves that every encoded addition satisfies `AddSpec`, including numerical results and
exception flags.

```lean
theorem add_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b) (add f cfg a b) := addDatum_correct _ _ _ _
```

**[TensorCore.IEEE.sub_correct](tensor-core/TensorCore/IEEE/Specification.lean#L114)** (theorem; namespace `TensorCore.IEEE`).

Proves subtraction satisfies the addition contract with the second decoded operand
negated, for every encoding and context.

```lean
theorem sub_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b).negate (sub f cfg a b) := addDatum_correct _ _ _ _
```

**[TensorCore.IEEE.mul_correct](tensor-core/TensorCore/IEEE/Specification.lean#L117)** (theorem; namespace `TensorCore.IEEE`).

Proves that every encoded multiplication satisfies `MulSpec`, including nonfinite cases
and exception flags.

```lean
theorem mul_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    MulSpec f cfg (decode f a) (decode f b) (mul f cfg a b) := mulDatum_correct _ _ _ _
```

**[TensorCore.IEEE.fma_correct](tensor-core/TensorCore/IEEE/Specification.lean#L121)** (theorem; namespace `TensorCore.IEEE`).

Proves that every encoded fused multiply-add satisfies `FmaSpec`, including single
rounding and all special-value cases.

```lean
theorem fma_correct (f : BinaryFormat) (cfg : Context) (a b c : Word f) :
    FmaSpec f cfg (decode f a) (decode f b) (decode f c) (fma f cfg a b c) :=
  fmaDatum_correct _ _ _ _ _
```

</details>

<details>
<summary>C18. IEEE precision and flags — Lean declarations</summary>

**[TensorCore.IEEE.IntegerRound](tensor-core/TensorCore/IEEE/Precision.lean#L10)** (def; namespace `TensorCore.IEEE`).

Defines integer rounding by optimality in the requested direction, using the original
sign to interpret directed magnitude rounding and even tie breaking for nearest mode.

```lean
def IntegerRound (mode : BinaryRoundingMode) (negative : Bool) (t : Rat) (k : Int) : Prop :=
  match mode with
  | .nearestEven =>
      (∀ j : Int, absQ (t - k) ≤ absQ (t - j)) ∧
      (∀ j : Int, j ≠ k → absQ (t - j) = absQ (t - k) → k % 2 = 0)
  | .towardZero => (k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k
  | .towardNegative => if negative then
      t ≤ (k : Rat) ∧ ∀ j : Int, t ≤ (j : Rat) → k ≤ j
    else (k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k
  | .towardPositive => if negative then
      (k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k
    else t ≤ (k : Rat) ∧ ∀ j : Int, t ≤ (j : Rat) → k ≤ j
```

**[TensorCore.IEEE.PrecisionRound](tensor-core/TensorCore/IEEE/Precision.lean#L78)** (def; namespace `TensorCore.IEEE`).

Defines rounding to the format's significand precision with an unrestricted exponent,
using binade inequalities and the integer-rounding predicate.

```lean
def PrecisionRound (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m u : Rat) : Prop :=
  (m = 0 ∧ u = 0) ∨
  ∃ e : Int, ∃ k : Int, pow2 e ≤ m ∧ m < pow2 (e + 1) ∧
    IntegerRound mode negative (m / pow2 (e - f.fractionBits)) k ∧
    u = (k : Rat) * pow2 (e - f.fractionBits)
```

**[TensorCore.IEEE.RoundSpec](tensor-core/TensorCore/IEEE/Rounding.lean#L57)** (def; namespace `TensorCore.IEEE`).

Defines the complete rational-to-IEEE rounding contract, including finite optimality,
exact-zero sign, overflow results, inexactness, and the chosen tininess policy.

```lean
def RoundSpec (f : BinaryFormat) (cfg : Context) (zeroSign : Bool) (x : Rat)
    (r : Result f) : Prop :=
  if x = 0 then r.bits = zero f zeroSign ∧ r.flags = {} else
  ∃ u : Rat, PrecisionRound f.layout cfg.mode (decide (x < 0)) (absQ x) u ∧
    if absQ x ≤ f.layout.maxFinite then
      BinaryRoundSpec f.layout cfg.mode x r.bits ∧
      sign f r.bits = decide (x < 0) ∧
      r.flags.invalid = false ∧ r.flags.divideByZero = false ∧ r.flags.overflow = false ∧
      (r.flags.inexact = true ↔ binaryValue f.layout r.bits ≠ some x) ∧
      (r.flags.underflow = true ↔ tiny f cfg (absQ x) u = true ∧ r.flags.inexact = true)
    else
      (r.flags.overflow = true ↔ f.layout.maxFinite < u) ∧
      r.flags.invalid = false ∧ r.flags.divideByZero = false ∧ r.flags.underflow = false ∧
      r.flags.inexact = true ∧
      r.bits = if f.layout.maxFinite < u ∧ overflowToInfinity cfg.mode (decide (x < 0)) = true
        then infinity f (decide (x < 0)) else maxFiniteWord f (decide (x < 0))
```

**[TensorCore.IEEE.precisionMagnitude_correct](tensor-core/TensorCore/IEEE/Precision.lean#L85)** (theorem; namespace `TensorCore.IEEE`).

For every nonnegative magnitude, proves that the computed precision-only result
satisfies the independent precision-rounding predicate.

```lean
theorem precisionMagnitude_correct (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) (hm : 0 ≤ m) :
    PrecisionRound f mode negative m (precisionMagnitude f mode negative m) := by
  by_cases hz : m = 0
  · exact Or.inl ⟨hz, by simp [precisionMagnitude, hz]⟩
  · have hs := magnitudeExponent_spec m (show 0 < m by grind)
    exact Or.inr ⟨magnitudeExponent m, _, hs.1, hs.2, coefficient_correct _ _ _,
      by simp [precisionMagnitude, hz]⟩
```

**[TensorCore.IEEE.precisionRound_unique](tensor-core/TensorCore/IEEE/Precision.lean#L95)** (theorem; namespace `TensorCore.IEEE`).

Proves that any value satisfying the precision-rounding predicate equals the computed
precision-only result.

```lean
theorem precisionRound_unique (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m u : Rat) (h : PrecisionRound f mode negative m u) :
    u = precisionMagnitude f mode negative m := by
  rcases h with ⟨hm, hu⟩ | ⟨e, k, hl, hh, hk, hu⟩
  · simp [precisionMagnitude, hm, hu]
  · have hm : 0 < m := by have := pow2_pos e; grind
    have he := magnitudeExponent_eq_of_bounds m e hl hh
    have hc := integerRound_unique mode negative _ k hk
    simp [precisionMagnitude, Rat.ne_of_gt hm, he, ← hc, hu]
```

**[TensorCore.IEEE.round_correct](tensor-core/TensorCore/IEEE/Rounding.lean#L76)** (theorem; namespace `TensorCore.IEEE`).

Proves the full rounding contract for every rational input, including zero, finite
results, overflow, gradual underflow, and flags.

```lean
theorem round_correct (f : BinaryFormat) (cfg : Context) (zeroSign : Bool) (x : Rat) :
    RoundSpec f cfg zeroSign x (round f cfg zeroSign x) := by
  by_cases hz : x = 0
  · simp [RoundSpec, round, hz]
  · simp only [RoundSpec, round, hz, ↓reduceIte]
    refine ⟨precisionMagnitude f.layout cfg.mode (decide (x < 0)) (absQ x),
      precisionMagnitude_correct _ _ _ _ (absQ_nonneg x), ?_⟩
    split
    · rename_i hr
      dsimp only
      have hs := roundBinary_sign f.layout cfg.mode x (finiteBits f cfg.mode x hr)
        (finiteBits_eq f cfg.mode x hr)
      exact ⟨finiteBits_correct f cfg.mode x hr, hs, rfl, rfl, rfl,
        by simp, by simp⟩
    · dsimp only
      simp
```

**[TensorCore.IEEE.round_overflow_iff](tensor-core/TensorCore/IEEE/Rounding.lean#L118)** (theorem; namespace `TensorCore.IEEE`).

Proves that the overflow flag is set exactly when precision rounding with unrestricted
exponent exceeds the maximum finite magnitude.

```lean
theorem round_overflow_iff (f : BinaryFormat) (cfg : Context) (s : Bool) (x : Rat) :
    (round f cfg s x).flags.overflow = true ↔
      f.layout.maxFinite < precisionMagnitude f.layout cfg.mode (decide (x < 0)) (absQ x) := by
  by_cases hz : x = 0
  · have hp := maxFinite_positive f
    simp [round, hz, precisionMagnitude, absQ, Rat.not_lt.mpr (Rat.le_of_lt hp)]
  · by_cases hr : absQ x ≤ f.layout.maxFinite
    · have hu := precisionMagnitude_le_max f.layout f.valid cfg.mode (decide (x < 0))
        (absQ x) (absQ_nonneg x) hr
      simp [round, hz, hr, Rat.not_lt.mpr hu]
    · simp [round, hz, hr]
```

**[TensorCore.IEEE.precision_nearest_all](tensor-core/TensorCore/IEEE/Precision.lean#L162)** (theorem; namespace `TensorCore.IEEE`).

For a positive magnitude, proves that nearest-even precision rounding is at least as
close as every dyadic competitor satisfying the significand-width bound.

```lean
theorem precision_nearest_all (f : Format) (m : Rat) (hm : 0 < m)
    (j e : Int) (hj : j.natAbs < 2 ^ (f.fractionBits + 1)) :
    absQ (m - precisionMagnitude f .nearestEven false m) ≤
      absQ (m - (j : Rat) * pow2 (e - f.fractionBits)) := by
  let b := magnitudeExponent m
  have hs := magnitudeExponent_spec m hm
  by_cases he : b ≤ e
  · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
    rw [hz, precisionMagnitude, if_neg (Rat.ne_of_gt hm)]
    exact rne_grid_nearest_q m _ (pow2_pos _) z
  · have hsmall := f.finite_below_binade j e b hj (by omega)
    have hsmall' := (absQ_le_iff _ _).mp hsmall
    have hq := pow2_pos (b - f.fractionBits - 1)
    have hn := rne_grid_nearest_q m (pow2 (b - f.fractionBits)) (pow2_pos _)
      ((2 ^ f.fractionBits : Nat) : Int)
    rw [Rat.intCast_natCast, ← f.binade_grid] at hn
    change absQ (m - (rneInt (m / pow2 (b - f.fractionBits)) : Rat) *
      pow2 (b - f.fractionBits)) ≤ absQ (m - pow2 b) at hn
    rw [precisionMagnitude, if_neg (Rat.ne_of_gt hm)]
    change absQ (m - (rneInt (m / pow2 (b - f.fractionBits)) : Rat) *
      pow2 (b - f.fractionBits)) ≤ _
    have h1 : 0 ≤ m - pow2 b := by grind
    have h2 : 0 ≤ m - (j : Rat) * pow2 (e - f.fractionBits) := by grind
    rw [absQ_of_nonneg h1] at hn
    rw [absQ_of_nonneg h2]
    grind
```

**[TensorCore.IEEE.precision_floor_all](tensor-core/TensorCore/IEEE/Precision.lean#L191)** (theorem; namespace `TensorCore.IEEE`).

For a positive magnitude, proves that downward magnitude rounding is the greatest
allowed-precision dyadic value at or below the input.

```lean
theorem precision_floor_all (f : Format) (m : Rat) (hm : 0 < m) :
    precisionMagnitude f .towardZero false m ≤ m ∧
    ∀ j e : Int, j.natAbs < 2 ^ (f.fractionBits + 1) →
      (j : Rat) * pow2 (e - f.fractionBits) ≤ m →
      (j : Rat) * pow2 (e - f.fractionBits) ≤ precisionMagnitude f .towardZero false m := by
  let b := magnitudeExponent m
  let q := pow2 (b - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (m / q)) (Rat.le_of_lt hq)
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
    simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
  · intro j e hj hjm
    by_cases he : b ≤ e
    · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
      rw [hz] at hjm ⊢
      have hc : z ≤ (m / q).floor := Rat.le_floor_iff.mpr
        (le_div_of_mul_le _ _ _ hq hjm)
      have h := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
      simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
    · have hsmall := f.finite_below_binade j e b hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have hl := precisionMagnitude_lower f .towardZero false m hm
      have hp := pow2_pos (b - f.fractionBits - 1)
      grind
```

**[TensorCore.IEEE.precision_ceil_all](tensor-core/TensorCore/IEEE/Precision.lean#L218)** (theorem; namespace `TensorCore.IEEE`).

For a positive magnitude, proves that upward magnitude rounding is the least
allowed-precision dyadic value at or above the input.

```lean
theorem precision_ceil_all (f : Format) (m : Rat) (hm : 0 < m) :
    m ≤ precisionMagnitude f .towardPositive false m ∧
    ∀ j e : Int, j.natAbs < 2 ^ (f.fractionBits + 1) →
      m ≤ (j : Rat) * pow2 (e - f.fractionBits) →
      precisionMagnitude f .towardPositive false m ≤ (j : Rat) * pow2 (e - f.fractionBits) := by
  let b := magnitudeExponent m
  let q := pow2 (b - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right (Rat.le_ceil (x := m / q)) (Rat.le_of_lt hq)
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
    simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
  · intro j e hj hmj
    by_cases he : b ≤ e
    · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
      rw [hz] at hmj ⊢
      have hdiv : m / q ≤ (z : Rat) := by
        apply Rat.le_of_mul_le_mul_right (c := q) _ hq
        rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)]
        exact hmj
      have hc : (m / q).ceil ≤ z := Rat.ceil_le_iff.mpr hdiv
      have h := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
      simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
    · have hsmall := f.finite_below_binade j e b hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have hl := (magnitudeExponent_spec m hm).1
      have hp := pow2_pos (b - f.fractionBits - 1)
      grind
```

</details>

<details>
<summary>C19. IEEE compatibility — Lean declarations</summary>

**[TensorCore.IEEE.convert_self_finite](tensor-core/TensorCore/IEEE/Compatibility.lean#L7)** (theorem; namespace `TensorCore.IEEE`).

Proves that converting a finite encoding to its own format preserves every bit,
including signed zero, and clears all operation flags.

```lean
theorem convert_self_finite (f : BinaryFormat) (cfg : Context) (a : Word f)
    (s : Bool) (x : Rat) (hd : decode f a = .finite s x) :
    convert f f cfg a = ⟨a, {}⟩ := by
  obtain ⟨hv, hs⟩ := (decode_finite_iff f a s x).mp hd
  by_cases hx : x = 0
  · have ha : ∃ d, (classify f.layout a).finite = some d := by
      unfold binaryValue at hv
      cases hc : (classify f.layout a).finite with
      | none => simp [hc] at hv
      | some d => exact ⟨d, rfl⟩
    let za := encodeBinaryRep f.layout f.valid (BinaryRep.zero f.layout f.valid s)
    have he := binaryValue_sign_injective f.layout f.valid za ⟨a, ha⟩ 0
      (zero_value f s) (by simpa [hx] using hv) (by
        change sign f (zero f s) = sign f a
        rw [zero_sign]; exact hs.symm)
    have heq : zero f s = a := congrArg Subtype.val he
    simp [convert, convertDatum, hd, round, hx, heq]
  · have hrb := binaryValue_roundBinary f.layout f.valid cfg.mode a x hv hx
    have hr := (roundBinary_range hrb).2
    have he : finiteBits f cfg.mode x hr = a :=
      Option.some.inj ((finiteBits_eq f cfg.mode x hr).symm.trans hrb)
    simp [convert, convertDatum, hd, round, hx, hr, he, hv]
```

**[TensorCore.IEEE.convert_quietNaN_roundtrip](tensor-core/TensorCore/IEEE/Compatibility.lean#L42)** (theorem; namespace `TensorCore.IEEE`).

For a valid quiet-NaN payload, proves that widening to a format with at least as many
fraction bits and converting back preserves its encoding without flags.

```lean
theorem convert_quietNaN_roundtrip (source target : BinaryFormat) (cfg : Context)
    (s : Bool) (p : Nat) (hp : p < quietBit source)
    (hw : source.layout.fractionBits ≤ target.layout.fractionBits) :
    convert target source cfg (convert source target cfg (nan source s p)).bits =
      ⟨nan source s p, {}⟩ := by
  have hpt := convertPayload_bounded source target p hp
  simp [convert, convertDatum, decode_nan, Nat.mod_eq_of_lt hp, Nat.mod_eq_of_lt hpt,
    convertPayload_roundtrip source target p hw]
```

**[TensorCore.IEEE.round_agrees_finite](tensor-core/TensorCore/IEEE/Rounding.lean#L95)** (theorem; namespace `TensorCore.IEEE`).

For a nonzero exact input within the finite range, proves that IEEE rounding bits agree
with the original finite converter.

```lean
theorem round_agrees_finite (f : BinaryFormat) (cfg : Context) (s : Bool) (x : Rat)
    (hx : x ≠ 0) (hr : absQ x ≤ f.layout.maxFinite) :
    roundBinary f.layout cfg.mode x = some (round f cfg s x).bits := by
  simpa [round, hx, hr] using finiteBits_eq f cfg.mode x hr
```

</details>

<details>
<summary>C20. Lean native migration — Lean declarations</summary>

**[TensorCore.IEEE.LeanBridge.NonzeroFinite32](tensor-core/TensorCore/IEEE/LeanBridge.lean#L81)** (def; namespace `TensorCore.IEEE.LeanBridge`).

Defines the FP32 native arithmetic domain: a finite exponent field and a nonzero decoded
significand.

```lean
def NonzeroFinite32 (a : F32) : Prop := a.toNat / 8388608 % 256 < 255 ∧ 0 < mantissa32 a
```

**[TensorCore.IEEE.LeanBridge.NonzeroFinite64](tensor-core/TensorCore/IEEE/LeanBridge64.lean#L77)** (def; namespace `TensorCore.IEEE.LeanBridge`).

Defines the FP64 native arithmetic domain: a finite exponent field and a nonzero decoded
significand.

```lean
def NonzeroFinite64 (a : F64) : Prop := a.toNat / 4503599627370496 % 2048 < 2047 ∧ 0 < mantissa64 a
```

**[TensorCore.IEEE.addWithLean_eq](tensor-core/TensorCore/IEEE/NativeOperations.lean#L168)** (theorem; namespace `TensorCore.IEEE`).

Proves that the native addition wrapper preserves every reference result bit and flag
for all formats, encodings, and contexts, including reference fallbacks.

```lean
theorem addWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    addWithLean f cfg a b = add f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [addWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeAddResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [addWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeAddResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
```

**[TensorCore.IEEE.subWithLean_eq](tensor-core/TensorCore/IEEE/NativeOperations.lean#L254)** (theorem; namespace `TensorCore.IEEE`).

Proves that the native subtraction wrapper preserves every reference result bit and flag
for all formats, encodings, and contexts, including reference fallbacks.

```lean
theorem subWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    subWithLean f cfg a b = sub f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [subWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeSubResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [subWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeSubResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
```

**[TensorCore.IEEE.mulWithLean_eq](tensor-core/TensorCore/IEEE/NativeOperations.lean#L338)** (theorem; namespace `TensorCore.IEEE`).

Proves that the native multiplication wrapper preserves every reference result bit and
flag for all formats, encodings, and contexts, including reference fallbacks.

```lean
theorem mulWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    mulWithLean f cfg a b = mul f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [mulWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeMulResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [mulWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeMulResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
```

**[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](tensor-core/TensorCore/IEEE/LeanBridge.lean#L380)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For nonzero finite FP32 operands with an in-range exact result, proves that Lean-native
nearest-even addition produces the reference bits. This bridge compares bits; wrapper
theorems also preserve flags.

```lean
theorem nativeAdd32_reference (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    nativeAdd32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1) =
      (TensorCore.IEEE.add .binary32 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.add Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)) = _
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.add]
  have hv := aligned_add_value (nativeSign (sign32 a)) (nativeSign (sign32 b))
    (mantissa32 a) (mantissa32 b) (exponent32 a) (exponent32 b)
  have hround := packNormalize32_reference
    ((nativeSign (sign32 a)).apply
      (decreaseExponent (mantissa32 a) (exponent32 a) (min (exponent32 a) (exponent32 b))).1 +
     (nativeSign (sign32 b)).apply
      (decreaseExponent (mantissa32 b) (exponent32 b) (min (exponent32 a) (exponent32 b))).1)
    (min (exponent32 a) (exponent32 b)) tinyMode (by simpa only [hv, finiteValue32] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue32 a + finiteValue32 b)).bits =
    (addDatum .binary32 ⟨.nearestEven, tinyMode⟩ (decode .binary32 a) (decode .binary32 b)).bits
  rw [decode32_nonzero a ha, decode32_nonzero b hb]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue32 a + finiteValue32 b)).bits =
      (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign32 a) (sign32 b))
        (finiteValue32 a + finiteValue32 b)).bits
  cases sa : sign32 a <;> cases sb : sign32 b
  all_goals try rfl
  have hpa : 0 < (mantissa32 a : Rat) * pow2 (exponent32 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa32 b : Rat) * pow2 (exponent32 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue32 a + finiteValue32 b ≠ 0 := by
    simp only [finiteValue32, sa, sb, nativeSign, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**[TensorCore.IEEE.LeanBridge.nativeSub32_reference](tensor-core/TensorCore/IEEE/LeanBridge.lean#L443)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For nonzero finite FP32 operands with an in-range exact result, proves that Lean-native
nearest-even subtraction produces the reference bits. This bridge compares bits; wrapper
theorems also preserve flags.

```lean
theorem nativeSub32_reference (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue32 a - finiteValue32 b) ≤ fp32.maxFinite) :
    nativeSub32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1) =
      (TensorCore.IEEE.sub .binary32 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.sub Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)) = _
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.sub]
  have hv := aligned_sub_value (nativeSign (sign32 a)) (nativeSign (sign32 b))
    (mantissa32 a) (mantissa32 b) (exponent32 a) (exponent32 b)
  have hround := packNormalize32_reference
    ((nativeSign (sign32 a)).apply
      (decreaseExponent (mantissa32 a) (exponent32 a) (min (exponent32 a) (exponent32 b))).1 -
     (nativeSign (sign32 b)).apply
      (decreaseExponent (mantissa32 b) (exponent32 b) (min (exponent32 a) (exponent32 b))).1)
    (min (exponent32 a) (exponent32 b)) tinyMode (by simpa only [hv, finiteValue32] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue32 a - finiteValue32 b)).bits =
    (addDatum .binary32 ⟨.nearestEven, tinyMode⟩ (decode .binary32 a) (decode .binary32 b).negate).bits
  rw [decode32_nonzero a ha, decode32_nonzero b hb]
  simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
  rw [← Rat.sub_eq_add_neg]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue32 a - finiteValue32 b)).bits =
      (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign32 a) (!(sign32 b)))
        (finiteValue32 a - finiteValue32 b)).bits
  cases sa : sign32 a <;> cases sb : sign32 b
  all_goals try rfl
  have hpa : 0 < (mantissa32 a : Rat) * pow2 (exponent32 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa32 b : Rat) * pow2 (exponent32 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue32 a - finiteValue32 b ≠ 0 := by
    simp only [finiteValue32, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**[TensorCore.IEEE.LeanBridge.nativeMul32_reference](tensor-core/TensorCore/IEEE/LeanBridge.lean#L535)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For nonzero finite FP32 operands with an in-range exact result, proves that Lean-native
nearest-even multiplication produces the reference bits. This bridge compares bits;
wrapper theorems also preserve flags.

```lean
theorem nativeMul32_reference (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue32 a * finiteValue32 b) ≤ fp32.maxFinite) :
    nativeMul32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1) =
      (TensorCore.IEEE.mul .binary32 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  have hm := Nat.mul_pos ha.2 hb.2
  have hp : 0 < ((mantissa32 a * mantissa32 b : Nat) : Rat) * pow2 (exponent32 a + exponent32 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos _)
  have hrange : ((mantissa32 a * mantissa32 b : Nat) : Rat) *
      pow2 (exponent32 a + exponent32 b) ≤ fp32.maxFinite := by
    rw [finiteValue32_mul] at hr
    split at hr <;> simpa only [absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
  change pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.mul Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)) = _
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.mul]
  rw [nativeSign_mul, roundWithAccuracy_eq_round32 _ _ _ (product32_no_leftshift a b ha hb),
    packRound32_reference _ _ _ hm tinyMode hrange, ← finiteValue32_mul]
  change (round .binary32 ⟨.nearestEven, tinyMode⟩ (xor (sign32 a) (sign32 b))
    (finiteValue32 a * finiteValue32 b)).bits =
      (mulDatum .binary32 ⟨.nearestEven, tinyMode⟩ (decode .binary32 a) (decode .binary32 b)).bits
  rw [decode32_nonzero a ha, decode32_nonzero b hb]
  rfl
```

**[TensorCore.IEEE.LeanBridge.nativeAdd64_reference](tensor-core/TensorCore/IEEE/LeanBridge64.lean#L351)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For nonzero finite FP64 operands with an in-range exact result, proves that Lean-native
nearest-even addition produces the reference bits. This bridge compares bits; wrapper
theorems also preserve flags.

```lean
theorem nativeAdd64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a + finiteValue64 b) ≤ fp64.maxFinite) :
    nativeAdd64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.add .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.add Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.add]
  have hv := aligned_add_value (nativeSign (sign64 a)) (nativeSign (sign64 b))
    (mantissa64 a) (mantissa64 b) (exponent64 a) (exponent64 b)
  have hround := packNormalize64_reference
    ((nativeSign (sign64 a)).apply
      (decreaseExponent (mantissa64 a) (exponent64 a) (min (exponent64 a) (exponent64 b))).1 +
     (nativeSign (sign64 b)).apply
      (decreaseExponent (mantissa64 b) (exponent64 b) (min (exponent64 a) (exponent64 b))).1)
    (min (exponent64 a) (exponent64 b)) tinyMode (by simpa only [hv, finiteValue64] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue64 a + finiteValue64 b)).bits =
    (addDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b)).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue64 a + finiteValue64 b)).bits =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign64 a) (sign64 b))
        (finiteValue64 a + finiteValue64 b)).bits
  cases sa : sign64 a <;> cases sb : sign64 b
  all_goals try rfl
  have hpa : 0 < (mantissa64 a : Rat) * pow2 (exponent64 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa64 b : Rat) * pow2 (exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue64 a + finiteValue64 b ≠ 0 := by
    simp only [finiteValue64, sa, sb, nativeSign, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**[TensorCore.IEEE.LeanBridge.nativeSub64_reference](tensor-core/TensorCore/IEEE/LeanBridge64.lean#L393)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For nonzero finite FP64 operands with an in-range exact result, proves that Lean-native
nearest-even subtraction produces the reference bits. This bridge compares bits; wrapper
theorems also preserve flags.

```lean
theorem nativeSub64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a - finiteValue64 b) ≤ fp64.maxFinite) :
    nativeSub64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.sub .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.sub Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.sub]
  have hv := aligned_sub_value (nativeSign (sign64 a)) (nativeSign (sign64 b))
    (mantissa64 a) (mantissa64 b) (exponent64 a) (exponent64 b)
  have hround := packNormalize64_reference
    ((nativeSign (sign64 a)).apply
      (decreaseExponent (mantissa64 a) (exponent64 a) (min (exponent64 a) (exponent64 b))).1 -
     (nativeSign (sign64 b)).apply
      (decreaseExponent (mantissa64 b) (exponent64 b) (min (exponent64 a) (exponent64 b))).1)
    (min (exponent64 a) (exponent64 b)) tinyMode (by simpa only [hv, finiteValue64] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue64 a - finiteValue64 b)).bits =
    (addDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b).negate).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
  rw [← Rat.sub_eq_add_neg]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue64 a - finiteValue64 b)).bits =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign64 a) (!(sign64 b)))
        (finiteValue64 a - finiteValue64 b)).bits
  cases sa : sign64 a <;> cases sb : sign64 b
  all_goals try rfl
  have hpa : 0 < (mantissa64 a : Rat) * pow2 (exponent64 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa64 b : Rat) * pow2 (exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue64 a - finiteValue64 b ≠ 0 := by
    simp only [finiteValue64, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**[TensorCore.IEEE.LeanBridge.nativeMul64_reference](tensor-core/TensorCore/IEEE/LeanBridge64.lean#L482)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For nonzero finite FP64 operands with an in-range exact result, proves that Lean-native
nearest-even multiplication produces the reference bits. This bridge compares bits;
wrapper theorems also preserve flags.

```lean
theorem nativeMul64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a * finiteValue64 b) ≤ fp64.maxFinite) :
    nativeMul64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.mul .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  have hm := Nat.mul_pos ha.2 hb.2
  have hp : 0 < ((mantissa64 a * mantissa64 b : Nat) : Rat) * pow2 (exponent64 a + exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos _)
  have hrange : ((mantissa64 a * mantissa64 b : Nat) : Rat) *
      pow2 (exponent64 a + exponent64 b) ≤ fp64.maxFinite := by
    rw [finiteValue64_mul] at hr
    split at hr <;> simpa only [absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.mul Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.mul]
  rw [nativeSign_mul, roundWithAccuracy_eq_round64 _ _ _ (product64_no_leftshift a b ha hb),
    packRound64_reference _ _ _ hm tinyMode hrange, ← finiteValue64_mul]
  change (round .binary64 ⟨.nearestEven, tinyMode⟩ (xor (sign64 a) (sign64 b))
    (finiteValue64 a * finiteValue64 b)).bits =
      (mulDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b)).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  rfl
```

**[TensorCore.IEEE.addWithLean_correct](tensor-core/TensorCore/IEEE/NativeOperations.lean#L187)** (theorem; namespace `TensorCore.IEEE`).

Transfers the complete addition specification to the native wrapper for every encoding
and context.

```lean
theorem addWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b) (addWithLean f cfg a b) := by
  rw [addWithLean_eq]
  exact add_correct f cfg a b
```

**[TensorCore.IEEE.subWithLean_correct](tensor-core/TensorCore/IEEE/NativeOperations.lean#L273)** (theorem; namespace `TensorCore.IEEE`).

Transfers the complete subtraction specification to the native wrapper for every
encoding and context.

```lean
theorem subWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b).negate (subWithLean f cfg a b) := by
  rw [subWithLean_eq]
  exact sub_correct f cfg a b
```

**[TensorCore.IEEE.mulWithLean_correct](tensor-core/TensorCore/IEEE/NativeOperations.lean#L357)** (theorem; namespace `TensorCore.IEEE`).

Transfers the complete multiplication specification to the native wrapper for every
encoding and context.

```lean
theorem mulWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    MulSpec f cfg (decode f a) (decode f b) (mulWithLean f cfg a b) := by
  rw [mulWithLean_eq]
  exact mul_correct f cfg a b
```

</details>

<details>
<summary>C21. Native EFT scalar execution — Lean declarations</summary>

**[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](tensor-core/TensorCore/IEEE/LeanFiniteAddition.lean#L145)** (theorem; namespace `TensorCore.IEEE.LeanBridge`).

For finite FP32 operands with an in-range exact sum, proves that the native adapter
agrees with finite nearest-even rounding, including EFT's positive exact-zero
convention.

```lean
theorem nativeFiniteAdd32_round (a b : F32)
    (ha : a.toNat / 8388608 % 256 < 255) (hb : b.toNat / 8388608 % 256 < 255)
    (x y : Rat) (hx : TensorCore.value32 a = some x) (hy : TensorCore.value32 b = some y)
    (hr : absQ (x + y) ≤ fp32.maxFinite) :
    TensorCore.round32 .nearestEven (x + y) = some (nativeFiniteAdd32 a b ha hb) := by
  rcases zero_or_nonzero32 a ha with rfl | rfl | ha'
  all_goals rcases zero_or_nonzero32 b hb with rfl | rfl | hb'
  case inl.inl | inl.inr.inl | inr.inl.inl | inr.inl.inr.inl =>
    simp only [show TensorCore.value32 (0 : F32) = some 0 by decide +kernel,
      show TensorCore.value32 (0x80000000 : F32) = some 0 by decide +kernel, Option.some.injEq] at hx hy
    subst x
    subst y
    decide +kernel +revert
  case inl.inr.inr | inr.inl.inr.inr =>
    have hy' := Option.some.inj (hy.symm.trans (value32_nonzero _ hb'))
    have hx' : x = 0 := Option.some.inj (hx.symm.trans (by decide +kernel))
    rw [hx', hy', Rat.zero_add]
    unfold nativeFiniteAdd32
    rw [if_neg (fun h => nonzero32_ne_negative_zero _ hb' h.2),
      nativeAdd32_zero_left _ hb' _ (by first | exact Or.inl rfl | exact Or.inr rfl)]
    exact round32_finiteValue32 _ hb'
  case inr.inr.inl | inr.inr.inr.inl =>
    have hx' := Option.some.inj (hx.symm.trans (value32_nonzero _ ha'))
    have hy' : y = 0 := Option.some.inj (hy.symm.trans (by decide +kernel))
    rw [hx', hy', Rat.add_zero]
    unfold nativeFiniteAdd32
    rw [if_neg (fun h => nonzero32_ne_negative_zero _ ha' h.1),
      nativeAdd32_zero_right _ ha' _ (by first | exact Or.inl rfl | exact Or.inr rfl)]
    exact round32_finiteValue32 _ ha'
  case inr.inr.inr.inr =>
    have hx' := Option.some.inj (hx.symm.trans (value32_nonzero _ ha'))
    have hy' := Option.some.inj (hy.symm.trans (value32_nonzero _ hb'))
    rw [hx', hy'] at hr ⊢
    unfold nativeFiniteAdd32
    rw [if_neg (fun h => nonzero32_ne_negative_zero _ ha' h.1)]
    exact nativeAdd32_round a b ha' hb' hr
```

**[TensorCore.EFMachine.add32WithLean_eq](tensor-core/TensorCore/Programs/NativeEFT.lean#L41)** (theorem; namespace `TensorCore.EFMachine`).

Proves that the native EFT addition adapter preserves the original bounded adder for all
encodings, including rejected inputs and range failures.

```lean
theorem add32WithLean_eq (a b : F32) : add32WithLean a b = add32 a b := by
  cases hx : decode32Word a with
  | none =>
    simp only [add32WithLean, add32, hx]
    split <;> (try rfl)
    split <;> rfl
  | some x =>
    have hxa : TensorCore.value32 a = some x.value := by rw [← decode32Word_value, hx]; rfl
    have ha := value32_finite_exponent hxa
    cases hy : decode32Word b with
    | none => simp [add32WithLean, add32, ha, hx, hy]
    | some y =>
      have hyb : TensorCore.value32 b = some y.value := by rw [← decode32Word_value, hy]; rfl
      have hb := value32_finite_exponent hyb
      simp only [add32WithLean, add32, ha, hb, ↓reduceDIte, hx, hy, Bind.bind, Option.bind]
      cases hs : x.add y with
      | none => rfl
      | some s =>
        simp only
        by_cases hr : s.magnitude ≤ maxMagnitude32
        · rw [if_pos hr, Word.round32_eq, Word.add_value hs]
          exact (nativeFiniteAdd32_round a b ha hb x.value y.value hxa hyb (by
            have h := s.range_iff.mpr hr
            rwa [Word.add_value hs] at h)).symm
        · have hgt : s.magnitude > maxMagnitude32 := by
            change ¬ s.magnitude.toNat ≤ maxMagnitude32.toNat at hr
            exact Nat.lt_of_not_ge hr
          simp [hr, Word.round32, hgt]
```

**[TensorCore.EFMachine.naiveSum32WithLeanFrom_eq](tensor-core/TensorCore/Programs/NativeEFT.lean#L74)** (theorem; namespace `TensorCore.EFMachine`).

Proves that the complete left-to-right native FP32 fold equals the original bounded fold
for every list and starting encoding.

```lean
theorem naiveSum32WithLeanFrom_eq (acc : F32) (xs : List F32) :
    naiveSum32WithLeanFrom acc xs = xs.foldlM add32 acc := by
  simp only [naiveSum32WithLeanFrom, show add32WithLean = add32 from by funext a b; exact add32WithLean_eq a b]
```

**[TensorCore.EFMachine.algorithm1WithLean_eq](tensor-core/TensorCore/Programs/NativeEFT.lean#L113)** (theorem; namespace `TensorCore.EFMachine`).

Proves that native EFT preserves the entire original bounded EFT result for every input,
including output bits, branch choice, and errors.

```lean
theorem algorithm1WithLean_eq (path : Path) (x : BlockInput path.profile) (D : F32) :
    algorithm1WithLean path x D = algorithm1 path x D := by
  simp only [algorithm1WithLean, algorithm1, Components.scalarWithLean_eq]
  rfl
```

**[TensorCore.EFMachine.algorithm1WithLean_correct](tensor-core/TensorCore/Programs/NativeEFT.lean#L118)** (theorem; namespace `TensorCore.EFMachine`).

For shape-correct finite inputs and any finite supplied `D`, proves that EFT returns the
directly rounded exact dot product. Its optional output bits also preserve range
rejection.

```lean
theorem algorithm1WithLean_correct {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : Rat} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    ∃ r, algorithm1WithLean path x D = .ok r ∧ r.bits = TensorCore.round32 .nearestEven s := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_correct hlen hx hD
```

**[TensorCore.EFMachine.algorithm1WithLean_range_iff](tensor-core/TensorCore/Programs/NativeEFT.lean#L133)** (theorem; namespace `TensorCore.EFMachine`).

For shape-correct finite inputs and finite `D`, proves that native EFT returns output
bits exactly when the original exact dot product is in range.

```lean
theorem algorithm1WithLean_range_iff {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : Rat} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    (∃ r b, algorithm1WithLean path x D = .ok r ∧ r.bits = some b) ↔ absQ s ≤ maxFinite32 := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_range_iff hlen hx hD
```

**[TensorCore.EFMachine.scalarSumWithLean_eq](tensor-core/TensorCore/Programs/NativeEFT.lean#L82)** (theorem; namespace `TensorCore.EFMachine`).

Proves that exact residual encoding followed by native accumulation preserves the
original bounded scalar sum, including failure cases.

```lean
theorem scalarSumWithLean_eq (xs : List Word) : scalarSumWithLean xs = scalarSum xs := by
  simp only [scalarSumWithLean, scalarSum, naiveSum32WithLeanFrom_eq]
```

**[TensorCore.EFMachine.Components.scalarWithLean_eq](tensor-core/TensorCore/Programs/NativeEFT.lean#L96)** (theorem; namespace `TensorCore.EFMachine`).

Proves that the native scalar branch preserves the original scalar branch's optional
output, including every guard and intermediate check.

```lean
theorem Components.scalarWithLean_eq (c : Components) : c.scalarWithLean = c.scalar := by
  simp only [Components.scalarWithLean, Components.scalar, scalarSumWithLean_eq, add32WithLean_eq]
```

**[TensorCore.EFMachine.algorithm1WithLean_success](tensor-core/TensorCore/Programs/NativeEFT.lean#L125)** (theorem; namespace `TensorCore.EFMachine`).

When the exact dot product is in the finite FP32 range, proves that native EFT returns
actual bits satisfying nearest-even rounding.

```lean
theorem algorithm1WithLean_success {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : Rat} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d)
    (hrange : absQ s ≤ maxFinite32) :
    ∃ r b, algorithm1WithLean path x D = .ok r ∧ r.bits = some b ∧ NearestEven32 s b := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_success hlen hx hD hrange
```

</details>

<!-- END MAIN THEOREM CODE -->

### Substance and nonvacuity

The rounding relations compare against all representable competitors. Fixed-width
refinement proves coefficient/carry capacity, and error bounds include alignment
and final conversion losses. Residual recovery by itself is an elementary identity
and does not establish the accuracy of an arbitrary supplied output.

Accuracy predicates require existing results and defined ideals. Nonempty
[review witnesses](tensor-core/TensorCore/Regression/ReviewClaims.lean) distinguish
models with positive errors and establish distinct family members; empty matrix
dimensions retain the usual vacuous entrywise guarantees. The
[IEEE witnesses](tensor-core/TensorCore/IEEE/Regression.lean) cover negative zero,
overflow thresholds, normal results carrying underflow, NaN policies, and fused
cancellation after an out-of-range intermediate product.
The [native-wrapper witnesses](tensor-core/TensorCore/IEEE/NativeRegression.lean)
cover ties, cancellation, subnormal boundaries, signed underflow, and retained
NaN/overflow paths. The equivalence bridges compare two separate definitions;
the original reference is retained, and the general proofs cover every input
satisfying their hypotheses.

This agreement, together with independent numerical comparisons, is strong
evidence for the scalar implementation. Specification review must still establish
that the written contracts capture the intended IEEE rules. The scalar proofs
do not establish NVIDIA tensor-core conformance; the tensor-core and EFT theorems
continue to depend on their stated profile, shape, and range assumptions.

### Review sign-off

Human sign-off remains pending. The [evaluation](EVALUATION.md) distinguishes the
independent review of the original finite theory from this implementation's own
proofs, tests, and critical assessment. No paper novelty or physical-device theorem
is implied. The kernel checks Lean declarations; the parser, compiler, native
executable, and hardware remain separate validation boundaries.

## Validation and reproduction

```sh
./tc build
./tc audit
./tc check
python3 tensor-core/scripts/check_ieee_softfloat.py --fetch
```

The clean suite builds from a fresh source copy and checks tensor-core, EFT,
GEMM, certificate, rejection, and hardware-archive regressions, the independent
IEEE oracle, the Lean logical/native comparison, and native EFT accumulation.
Its [report](tensor-core/data/regressions/clean-build.json) includes commands,
source hashes, warning counts, and snapshot stability. The
[IEEE report](tensor-core/data/regressions/ieee-report.json) and
[SoftFloat report](tensor-core/data/regressions/ieee-softfloat-report.json), together
with the [Lean comparison](tensor-core/data/regressions/lean-ieee-report.json),
record case counts, failures, fingerprints, and policy differences.

The theorem audit permits only `propext`, `Classical.choice`, and `Quot.sound`.
The IEEE/SoftFloat comparison covers 341,472 cases; the Lean logical/native
comparison covers 28,032. Native EFT accumulation adds 7,988 comparisons,
including 1,000 exact-grid residual sequences, and the bounded EFT gate compares
3,953 complete original/native results, including error cases. The public wrappers must
preserve exact bits and flags. Comparisons to external NaN policies explicitly
allow their documented payload/sign differences; non-NaN numeric bits and all
reported flags are checked exactly. See the [evaluation](EVALUATION.md) for the
individual evidence and validation-snapshot provenance.

To run the native comparisons from the repository root:

```sh
python3 tensor-core/scripts/check_lean_ieee.py
python3 tensor-core/scripts/check_lean_eft.py
python3 tensor-core/scripts/check_bounded_eft.py
```

The optional SoftFloat command fetches an unmodified pinned reference into `tmp/`,
compiles it with a C compiler and make, then compares results and flags. It is
not a dependency of the Lean theory or of the offline clean suite. The independent
Python oracle searches ordered encodings and imports no implementation oracle.
No CUDA compilation or new GPU execution is performed by these commands.

The [earlier independent checks](reviews/2026-09-07/README.md) are historical
artifacts pinned to the pre-IEEE theory. Their source manifest intentionally
rejects later theory revisions; use the documented baseline checkout to replay
that historical review. The current evaluation and current validation reports
cover the IEEE extension, native migration, and native EFT execution; rerunning historical probes does
not extend the independent review's scope to those additions.

## Assessment and TODO

The principal remaining obligations are:

- Physical GPU and compiled-kernel correspondence, including memory and lane behavior.
- Human specification review, including the IEEE contracts and NaN/tininess policies.
- Complete FP8 and FP16-output tensor-core paths. FP16 final-stage order and the
  L40S/Ada FP8 normalized precision remain unresolved; candidate agreement on
  archived outputs does not determine every intermediate stage.
- General IEEE scalar operations beyond the five implemented operations, and
  wider IEEE 754 environment/format coverage.
- Revalidate the native bridges on toolchain upgrades. Expanding their domains
  or migrating retained operations requires additional preservation proofs.
- Representative application evaluation, measured configuration costs, tighter
  conversion/cancellation bounds, and more economical concrete certificate replay.
- Scaled/native quantified families, cross-precision selection for one source
  workload, adaptive programs, and globally corrected GEMM.

The pinned CUTLASS connection is a manual arithmetic projection for positive K
multiples of 16. Compiling the fixture, GPU comparisons, partial-K behavior,
other epilogues, and split-K require additional work.

## Sources and layout

| Source | Pin or specification |
| --- | --- |
| Lean | `leanprover/lean4:v4.33.1`, standard library only |
| IEEE scalar rules | IEEE 754-2019 §§3.4, 4.3, 5.4.1–5.4.2, 6.1–6.3, 7.1–7.6; [standard record](https://standards.ieee.org/ieee/754/6210/) |
| Independent scalar reference | [Berkeley SoftFloat 3e](https://www.jhauser.us/arithmetic/SoftFloat-3/doc/SoftFloat.html), `f74b1e48110ac3a27dd49b787d164e55e42d81d1`, ARM-VFPv2 specialization |
| Accurate Models | [arXiv:2512.07004v4](https://arxiv.org/abs/2512.07004v4) |
| MATLAB Tensor Core | v0.5, `bbcf00a273868172494eaacaa8d6128ab0fb8704`; [manifest](tensor-core/vendor/SOURCES.json) |
| CUTLASS | v3.5.1, `f7b19de32c5d1f3cedfc735c2849f12b537522ee`; [fixture pin](tensor-core/kernels/cutlass/pin.json) |
| TC-EFT | [Validation provenance](tensor-core/vendor/tc-eft-validation/SOURCES.json); manuscript correspondence is separate from the current arithmetic evaluation |

`tensor-core/TensorCore/Foundations`, `Semantics`, and `Theory` contain the numerical
models and their proofs. `IEEE` contains the exact scalar reference, specifications,
native bridges, and result-preserving wrappers; `Programs` contains
composition and GEMM; `PaperSpec` provides separate model definitions and
equivalence proofs; `Regression` and `examples` contain kernel-checked witnesses.
The CLI lives in `Cli`, numerical validation in `scripts`, and machine-readable
evidence in `data/regressions`.
