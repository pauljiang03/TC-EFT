# Reference manual

Command-line interfaces, contracts, and review evidence. Start with the [proof guide](../README.md) for the formalization.

## Quick start

```sh
./tc doctor --json
./tc build
./tc review
./tc ieee data/examples/ieee.jsonl
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
and Ampere/Hopper TF32 WMMA/MMA paths, all with FP32 output. FP8 and FP16-output
tensor-core candidates are archived in [`wip/`](../wip/README.md) outside the active library.
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
NaN selection. See the [schema](../data/schemas/ieee.schema.json),
[operations](../TensorCore/IEEE/Operations.lean), and
[complete case contracts](../TensorCore/IEEE/Specification.lean).

The exact IEEE reference is retained. The CLI uses proved wrappers around Lean's
native FP32/FP64 nearest-even addition, subtraction, and multiplication when both
operands are nonzero and finite and the absolute exact result is at most the
destination's maximum finite value. Cancellation to zero and underflow are covered.
Other cases, FP16, FMA, and conversions keep the reference path. The
[wrapper theorems](../TensorCore/IEEE/NativeOperations.lean) preserve
every result bit and flag for every input and context, including the fallbacks;
exact arithmetic still computes domain checks and exception conditions. See the
[compatibility and trust details](../docs/lean-ieee-compatibility.md).

Division, square root, comparisons, integer and text conversions, decimal
formats, additional operations, traps, and alternate exception handling are not
included. This milestone is not full IEEE 754 coverage.

## EFT scalar accumulation

`./tc eft FILE` calls
[`algorithm1WithLean`](../TensorCore/EFT/Native.lean). Its scalar
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
[kernel witness](../TensorCore/EFT/Regression/NativeEFT.lean) for the four
`0x3e00 * 0x3d00` products, `C = 0x3f7fffff`, and `D = 0x4107ffff` returns
`.scalar 0x41080000` (8.5).

Extraction, guards, and the 576-bit exact fallback remain custom. The original
EFT definitions remain independent references, and the generic FP64 consolidation
model is retained. The [native accumulation report](../data/regressions/lean-eft-report.json)
checks individual folds; the [bounded EFT report](../data/regressions/bounded-eft-report.json)
also compares complete original/native results so a branch fallback cannot hide
a scalar difference. These are proofs about the models plus compiled-execution
checks; physical GPU conformance remains separate.

## GEMM and accuracy certificates

```sh
./tc gemm data/examples/gemm.jsonl
./tc gemm data/examples/gemm.native.jsonl
./tc gemm data/examples/gemm.native-scaled.jsonl
./tc analyze data/examples/gemm.entry-family.jsonl --abs-tol 0.001
./tc select data/examples/gemm.cost-selection.jsonl --abs-tol 0.001 --emit tmp/cost.lean
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

The [GEMM schema](../data/schemas/gemm.schema.json) specifies required
fields. Matrices are flat row-major arrays with dimensions `m,n,k`; concrete
inputs must have exactly `m*k`, `k*n`, and `m*n` words. All dimensions, including
empty reductions and padding/cropping, are represented in the formal contracts.

A certificate bounds error relative to the original decoded source values,
including input conversion and scalar stages. Acceptance entails successful
execution and a defined ideal. Refusal means the analyzer did not certify the
request; it does not prove the numerical result inaccurate. Matrix bounds use
the sum of absolute entries, not an induced matrix norm. Selection minimizes
supplied costs among certified candidates; those costs are not measured GPU speeds.

The [editable cases](../data/examples/gemm.jsonl) and their
[expected fields](../data/examples/gemm.expected.json) demonstrate
source loss, conservative refusal, nonfinite rejection, directed conversion,
and subnormal boundaries. The [selection schema](../data/schemas/selection.schema.json)
covers preference and cost decisions. Further runnable contracts are in
[examples](../examples).

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
| C01. Finite rounding | Every well-formed IEEE-style binary format, all four modes, rational inputs within maximum finite magnitude. Out-of-range inputs are rejected even when a directed finite result could exist. | [`TensorCore.roundBinary_correct`](../TensorCore/Core/Binary/RoundingContract.lean), [`TensorCore.roundBinary_isSome_iff`](../TensorCore/Core/Binary/RoundingContract.lean) |
| C02. Encoding and signed zero | Bijection between finite encoded words and a representable rational value paired with a sign bit. Nonzero signs agree with the value; zero has two representations. Arithmetic exact zero remains +0. | [`TensorCore.signedFiniteBinaryBijection`](../TensorCore/Core/Binary/SignedBijection.lean), [`TensorCore.roundBinary_zero`](../TensorCore/Core/Binary/RoundingContract.lean) |
| C03. FP64 fused arithmetic | One exact product plus accumulator, one final rounding in each direction; finite decoded inputs and an in-range exact fused result give success. No intermediate product range restriction. | [`TensorCore.binary64Fma_correct`](../TensorCore/TC/FusedRounding.lean), [`TensorCore.binary64Fma_success`](../TensorCore/TC/FusedRounding.lean) |
| C04. Tensor-core arithmetic | The selected FP16/BF16/TF32 profiles model raw subnormal scales, alignment, floors, signed truncation, and final conversion. Fixed-width refinement has explicit width/carry assumptions. | [`TensorCore.profile_contract`](../TensorCore/TC/CanonicalFormats.lean), [`TensorCore.PaperSpec.supported_eq_paper`](../TensorCore/TC/Specification/Supported.lean) |
| C05. Error, recovery, and order | Local error includes final conversion; exact residual recovery composes across encoded accumulators. Nonmonotonicity is proved for the specified realizable input family. Accepted traces and the stated range/profile premises remain explicit. | [`TensorCore.evalBlock_error_bound`](../TensorCore/TC/ErrorBounds.lean), [`TensorCore.runBlocks_residual_ledger`](../TensorCore/TC/Program/Composition.lean), [`TensorCore.nonmonotone_range_encoded`](../TensorCore/TC/MonotonicityRange.lean) |
| C06. Bounded EFT | All eight paths, shape-correct finite inputs and any finite supplied output D. A fixed 576-bit workspace computes the correctly rounded FP32 ideal when that ideal is in range; refinement preserves result bits. | [`TensorCore.EFMachine.algorithm1_success`](../TensorCore/EFT/Machine/Correctness.lean), [`TensorCore.EFMachine.algorithm1_range_iff`](../TensorCore/EFT/Machine/Correctness.lean), [`TensorCore.EFMachine.algorithm1_agrees`](../TensorCore/EFT/Machine/Refinement.lean) |
| C07. Eq.20 and extraction | Every permitted coarse extraction grid; Eq.20 supplies the coefficient budget for exact scalar summation. Minimum grid, finite magnitude, and guarded component representability remain hypotheses. | [`TensorCore.ExtractionGrid.eq20_exact_sum`](../TensorCore/EFT/ExtractionGrid.lean), [`TensorCore.ExtractionGrid.eq20_scalarPredicate`](../TensorCore/EFT/ExtractionGrid.lean), [`TensorCore.ExtractionGrid.recovery`](../TensorCore/EFT/ExtractionGrid.lean) |
| C08. Program composition | Typed invocations expose exact loss/recovery; ordered programs and bounded repetitions have sufficient scale and headroom contracts. Adaptive branching is outside this API. | [`TensorCore.evalInvocation_recovery`](../TensorCore/TC/InvocationProperties.lean), [`TensorCore.Program.repeat_accurate_of_scales`](../TensorCore/TC/Program/Bounds/Loops.lean) |
| C09. Raw FP16 GEMM | Arbitrary dimensions, three logical WMMA schedules, padding/cropping, every encoded group boundary, and rejection agree with the separately defined matrix specification. | [`TensorCore.PaperSpec.gemm_eq_paper`](../TensorCore/Gemm/Specification/GemmEquivalence.lean), [`TensorCore.PaperSpec.gemm_rejected_iff_paper`](../TensorCore/Gemm/Specification/GemmEquivalence.lean) |
| C10. Native BF16/TF32 GEMM | Raw `AB+C` and complete source-converted `alpha*AB+beta*C`, five schedules, FP32 C/output. All four conversion/scalar modes; independent equivalence includes every stage and rejection. Accepted input-only checks imply successful execution and error against original source values. | [`TensorCore.PaperSpec.nativeGemm_eq_paper`](../TensorCore/Gemm/Specification/NativeGemmEquivalence.lean), [`TensorCore.nativeAnalysisCheck_sound`](../TensorCore/Gemm/NativeGemm.lean), [`TensorCore.PaperSpec.nativeConvertedGemm_eq_independent`](../TensorCore/Gemm/Specification/NativeScaledGemmEquivalence.lean), [`TensorCore.nativeConvertedAnalysisCheck_paper`](../TensorCore/Gemm/NativeConvertedAnalysis.lean), [`TensorCore.analyzeNativeConvertedGemm_matrix_error`](../TensorCore/Gemm/NativeConvertedAnalysis.lean) |
| C11. Complete scaled FP16 GEMM | Source conversion to FP16, tensor-core product, separately rounded FP32 alpha/beta products and addition, then output conversion. Independent equivalence includes every stage and rejection without assuming execution success. | [`TensorCore.PaperSpec.convertedGemm_eq_independent`](../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean), [`TensorCore.PaperSpec.scaledGemm_eq_independent`](../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean) |
| C12. Input-derived error certificates | Acceptance proves successful execution and error relative to original decoded inputs, including conversion perturbations and scalar stages. Per-entry bounds sum to a matrix absolute-entry-sum bound. Inference is conservative. | [`TensorCore.gemmAnalysisCheck_sound`](../TensorCore/Gemm/Analysis.lean), [`TensorCore.convertedAnalysisCheck_paper`](../TensorCore/Gemm/ConvertedGemmAnalysis.lean), [`TensorCore.analyzeConvertedGemm_matrix_error`](../TensorCore/Gemm/ConvertedGemmAnalysis.lean) |
| C13. Tighter bounds | Tighter scalar/input budgets are proved no larger than the earlier budgets. Finite multiplication by ±1 and addition with a zero-magnitude operand receive zero rounding error in every mode. | [`TensorCore.scaledGemmTightError_le`](../TensorCore/Gemm/TightBounds.lean), [`TensorCore.gemmInputPairTightError_le`](../TensorCore/Gemm/TightInputBounds.lean), [`TensorCore.checkFiniteMultiply_sound`](../TensorCore/Gemm/ExactScalarAnalysis.lean), [`TensorCore.checkFiniteAdd_sound`](../TensorCore/Gemm/ExactScalarAnalysis.lean) |
| C14. Quantified families | One accepted witness covers every finite FP16 A/B and FP32 C matrix satisfying uniform or per-entry magnitude caps. Per-entry analysis uses row/column maxima; zero caps permit both zero encodings. | [`TensorCore.familyCheck_sound`](../TensorCore/Gemm/Family.lean), [`TensorCore.entryFamilyCheck_sound`](../TensorCore/Gemm/EntryFamily.lean), [`TensorCore.entryFamilyCheck_matrix_error`](../TensorCore/Gemm/EntryFamily.lean) |
| C15. Certified decisions | Selection proves accuracy and either earliest certified preference or minimum supplied rational cost among certified candidates. Refusal means no candidate was certified. Native precision is fixed per workload. | [`TensorCore.selectGemm_sound`](../TensorCore/Gemm/Selection.lean), [`TensorCore.selectGemm_none`](../TensorCore/Gemm/Selection.lean), [`TensorCore.selectGemmCost_sound`](../TensorCore/Gemm/CostSelection.lean) |
| C16. Pinned CUTLASS connection | The reviewed arithmetic projection agrees with FP16 GEMM and inherits its accuracy checker. The selected K is divisible by 16; C++ execution, memory, compilation, and GPU correspondence are separate obligations. | [`TensorCore.CutlassWmma.project_eq_gemm`](../TensorCore/Gemm/Kernels/CutlassWmma.lean), [`TensorCore.CutlassWmma.project_check_sound`](../TensorCore/Gemm/Kernels/CutlassWmma.lean) |
| C17. IEEE scalar results | Every FP16/FP32/FP64 encoding, conversions/add/subtract/multiply/FMA, four modes, both tininess policies, exact zero signs, infinity and NaN cases, and default flags. One exact product plus addend is rounded only once. | [`TensorCore.IEEE.convert_correct`](../TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.add_correct`](../TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.sub_correct`](../TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.mul_correct`](../TensorCore/IEEE/Specification.lean), [`TensorCore.IEEE.fma_correct`](../TensorCore/IEEE/Specification.lean) |
| C18. IEEE precision and flags | Unbounded-exponent precision rounding satisfies independently specified integer optimality, is unique, and determines overflow. Nearest and directed magnitude results compare against all bounded-significand dyadic competitors. | [`TensorCore.IEEE.precisionMagnitude_correct`](../TensorCore/IEEE/Precision.lean), [`TensorCore.IEEE.precisionRound_unique`](../TensorCore/IEEE/Precision.lean), [`TensorCore.IEEE.round_correct`](../TensorCore/IEEE/Rounding.lean), [`TensorCore.IEEE.round_overflow_iff`](../TensorCore/IEEE/Rounding.lean) |
| C19. IEEE compatibility | Same-format finite conversion preserves every encoding and raises no flags; quiet NaN payloads survive widening/narrowing. Nonzero in-range rounding agrees with the existing finite converter. | [`TensorCore.IEEE.convert_self_finite`](../TensorCore/IEEE/Compatibility.lean), [`TensorCore.IEEE.convert_quietNaN_roundtrip`](../TensorCore/IEEE/Compatibility.lean), [`TensorCore.IEEE.round_agrees_finite`](../TensorCore/IEEE/Rounding.lean) |
| C20. Lean native migration | FP32/FP64 nearest-even add/sub/mul agree with Lean's logical operations for nonzero finite operands with an in-range exact result. Wrappers preserve the original bits and every flag for all formats, inputs, rounding modes, and tininess policies by retaining reference fallbacks. | [`TensorCore.IEEE.addWithLean_eq`](../TensorCore/IEEE/NativeOperations.lean), [`TensorCore.IEEE.subWithLean_eq`](../TensorCore/IEEE/NativeOperations.lean), [`TensorCore.IEEE.mulWithLean_eq`](../TensorCore/IEEE/NativeOperations.lean) |
| C21. Native EFT scalar execution | Native FP32 scalar additions preserve the complete bounded Algorithm 1 result for every input, including branch tags and errors. All eight supported finite, shape-correct paths retain correct rounding and the exact range/success contract. | [`TensorCore.EFMachine.naiveSum32WithLeanFrom_eq`](../TensorCore/EFT/Native.lean), [`TensorCore.EFMachine.algorithm1WithLean_eq`](../TensorCore/EFT/Native.lean), [`TensorCore.EFMachine.algorithm1WithLean_correct`](../TensorCore/EFT/Native.lean), [`TensorCore.EFMachine.algorithm1WithLean_range_iff`](../TensorCore/EFT/Native.lean) |

<!-- BEGIN MAIN THEOREM CODE -->

The [proof guide](../README.md#proof-guide) displays the main declarations and links to their complete dependency graphs.

### Substance and nonvacuity

The rounding relations compare against all representable competitors. Fixed-width
refinement proves coefficient/carry capacity, and error bounds include alignment
and final conversion losses. Residual recovery by itself is an elementary identity
and does not establish the accuracy of an arbitrary supplied output.

Accuracy predicates require existing results and defined ideals. Nonempty
[review witnesses](../TensorCore/Gemm/Regression/ReviewClaims.lean) distinguish
models with positive errors and establish distinct family members; empty matrix
dimensions retain the usual vacuous entrywise guarantees. The
[IEEE witnesses](../TensorCore/IEEE/Tests/Regression.lean) cover negative zero,
overflow thresholds, normal results carrying underflow, NaN policies, and fused
cancellation after an out-of-range intermediate product.
The [native-wrapper witnesses](../TensorCore/IEEE/Tests/NativeRegression.lean)
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

Human sign-off remains pending. The [evaluation](../docs/evaluation.md) distinguishes the
independent review of the original finite theory from this implementation's own
proofs, tests, and critical assessment. No paper novelty or physical-device theorem
is implied. The kernel checks Lean declarations; the parser, compiler, native
executable, and hardware remain separate validation boundaries.

## Validation and reproduction

```sh
./tc build
./tc audit
./tc check
python3 scripts/check_ieee_softfloat.py --fetch
```

The clean suite builds from a fresh source copy and checks tensor-core, EFT,
GEMM, certificate, rejection, and hardware-archive regressions, the independent
IEEE oracle, the Lean logical/native comparison, and native EFT accumulation.
Its [report](../data/regressions/clean-build.json) includes commands,
source hashes, warning counts, and snapshot stability. The
[IEEE report](../data/regressions/ieee-report.json) and
[SoftFloat report](../data/regressions/ieee-softfloat-report.json), together
with the [Lean comparison](../data/regressions/lean-ieee-report.json),
record case counts, failures, fingerprints, and policy differences.

The theorem audit permits only `propext`, `Classical.choice`, and `Quot.sound`.
The IEEE/SoftFloat comparison covers 341,472 cases; the Lean logical/native
comparison covers 28,032. Native EFT accumulation adds 7,988 comparisons,
including 1,000 exact-grid residual sequences, and the bounded EFT gate compares
3,953 complete original/native results, including error cases. The public wrappers must
preserve exact bits and flags. Comparisons to external NaN policies explicitly
allow their documented payload/sign differences; non-NaN numeric bits and all
reported flags are checked exactly. See the [evaluation](../docs/evaluation.md) for the
individual evidence and validation-snapshot provenance.

To run the native comparisons from the repository root:

```sh
python3 scripts/check_lean_ieee.py
python3 scripts/check_lean_eft.py
python3 scripts/check_bounded_eft.py
```

The optional SoftFloat command fetches an unmodified pinned reference into `tmp/`,
compiles it with a C compiler and make, then compares results and flags. It is
not a dependency of the Lean theory or of the offline clean suite. The independent
Python oracle searches ordered encodings and imports no implementation oracle.
No CUDA compilation or new GPU execution is performed by these commands.

The [earlier independent checks](../reviews/2026-09-07/README.md) are historical
artifacts pinned to the pre-IEEE theory. Their source manifest intentionally
rejects later theory revisions; use the documented baseline checkout to replay
that historical review. The current evaluation and current validation reports
cover the IEEE extension, native migration, and native EFT execution; rerunning historical probes does
not extend the independent review's scope to those additions.

## Assessment and TODO

The principal remaining obligations are:

- Physical GPU and compiled-kernel correspondence, including memory and lane behavior.
- Human specification review, including the IEEE contracts and NaN/tininess policies.
- The separate [WIP archive](../wip/README.md) retains FP16-output tensor-core
  candidates and all FP8 work. Resolving their stage-order and precision questions
  is required before restoring them to the active library.
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

See the [repository layout](../README.md#project-structure) and [import migration](migration.md).
