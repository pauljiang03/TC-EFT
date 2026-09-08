# Tensor Core Arithmetic

Lean 4 theories and executable reference models for selected tensor-core arithmetic,
with proved binary rounding, accumulation refinements, GEMM error certificates,
and an IEEE binary scalar layer. Uses Lean 4.33.1 and its standard library.

The [current evaluation](EVALUATION.md) records validation, scope, and unresolved
concerns. Human specification review and physical GPU conformance remain open.

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
| `./tc eft FILE` | Run bounded block correction |
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

The IEEE implementation is an exact-arithmetic reference, not an optimized
machine floating-point library. Division, square root, comparisons, integer and
text conversions, decimal formats, additional operations, traps, and alternate
exception handling are not included. This milestone is not full IEEE 754 coverage.

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

C01–C16 retain the original finite tensor-core scope. C17–C19 describe the new
IEEE layer. These are claims about the explicit definitions and hypotheses;
a successful build is not a human assessment of specification adequacy.

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

The clean suite builds from a fresh source copy and checks the existing tensor-core,
GEMM, certificate, rejection, and hardware-archive regressions plus the IEEE oracle.
Its [report](tensor-core/data/regressions/clean-build.json) includes commands,
source hashes, warning counts, and snapshot stability. The
[IEEE report](tensor-core/data/regressions/ieee-report.json) and
[SoftFloat report](tensor-core/data/regressions/ieee-softfloat-report.json) record
case counts, failures, fingerprints, and policy differences.

The optional SoftFloat command fetches an unmodified pinned reference into `tmp/`,
compiles it with a C compiler and make, then compares results and flags. It is
not a dependency of the Lean theory or of the offline clean suite. The independent
Python oracle searches ordered encodings and imports no implementation oracle.
No CUDA compilation or new GPU execution is performed by these commands.

The [earlier independent checks](reviews/2026-09-07/README.md) are historical
artifacts pinned to the pre-IEEE theory. Their source manifest intentionally
rejects later theory revisions; use the documented baseline checkout to replay
that historical review. The current evaluation and current validation reports
apply to the IEEE extension.

## Assessment and TODO

The principal remaining obligations are:

- Physical GPU and compiled-kernel correspondence, including memory and lane behavior.
- Human specification review, including the IEEE contracts and NaN/tininess policies.
- Complete FP8 and FP16-output tensor-core paths. FP16 final-stage order and the
  L40S/Ada FP8 normalized precision remain unresolved; candidate agreement on
  archived outputs does not determine every intermediate stage.
- General IEEE scalar operations beyond the five implemented operations, and
  wider IEEE 754 environment/format coverage.
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
models and their proofs. `IEEE` adds the scalar contracts; `Programs` contains
composition and GEMM; `PaperSpec` provides separate model definitions and
equivalence proofs; `Regression` and `examples` contain kernel-checked witnesses.
The CLI lives in `Cli`, numerical validation in `scripts`, and machine-readable
evidence in `data/regressions`.
