# Tensor Core Arithmetic

Executable tensor-core models, bounded error-free transformations, and certified
GEMM in Lean 4. Exact arithmetic, kernel-checked proofs, and independent numerical
oracles share one reproducible command-line workflow.

[Quick start](#quick-start) · [Scope](#scope) · [Review](#reviewer-walkthrough) · [Claims](#main-claims-to-review) ·
[JSON interface](#gemm-json-interface) · [Selection](#certified-configuration-selection) · [Validation](#validation-and-trust) ·
[Plan](#assessment-and-todo) · [Reference](#technical-reference)

## Quick start

Requires Python 3.9+ and the pinned `leanprover/lean4:v4.33.1` toolchain through
elan. The default build and validation use no CUDA, external Lean packages, or
Python packages. Run commands from the repository root.

```sh
./tc doctor
./tc build
./tc review
./tc gemm tensor-core/data/examples/gemm.raw.jsonl
```

The raw example computes `1*2+0`. Its output has `value: "2/1"` and
`bits: 1073741824`, the FP32 encoding `0x40000000`.

| Command | Purpose |
| --- | --- |
| `./tc doctor --json` | Inspect the environment as JSON |
| `./tc build` | Build proofs and native executables |
| `./tc gemm FILE` | Run or certify one GEMM request per JSONL line |
| `./tc gemm -` | Read GEMM requests from standard input |
| `./tc analyze FILE --abs-tol T` | Infer concrete or family bounds and check an absolute tolerance |
| `./tc select FILE --abs-tol T` | Select by preference or minimum supplied cost among certified configurations |
| `./tc verify FILE.lean` | Replay an exported analysis certificate through Lean's kernel |
| `./tc schema` | Print the GEMM input JSON Schema |
| `./tc schema select` | Print the configuration-selection JSON Schema |
| `./tc trace HEX...` | Trace four V100 products and an accumulator |
| `./tc eft FILE` | Correct encoded blocks using bounded EFT |
| `./tc review` | Reproduce ten editable cases with fixed answers |
| `./tc audit` | Audit theorem dependencies and proof shortcuts |
| `./tc check` | Run every gate in a fresh source copy |

Use `./tc COMMAND --help` for arguments. Execution commands build their native
target before running. Build diagnostics go to stderr; GEMM and EFT results go
to stdout as JSON Lines. Existing Lake commands and examples remain available.

## Scope

The primary scope is **finite-domain FP32-output arithmetic**. Accurate Models
v4 supplies the numerical specification; TC-EFT supplies the error, recovery,
and correction contracts. Pinned source discrepancies remain explicit.

| Input arithmetic | Block proofs and independent equivalence | Native GEMM with FP32 output |
| --- | --- | --- |
| FP16 | Complete for the selected V100, Ampere, and Hopper families | Complete under three explicit WMMA schedules |
| BF16 | Complete for the selected Ampere and Hopper families | Raw and scaled GEMM, source-relative analysis, and selection under two WMMA schedules |
| TF32 | Complete for Ampere and Hopper WMMA/MMA paths | Raw and scaled GEMM, source-relative analysis, and selection under three schedules |
| FP8 | Separate candidate models and partial coverage | Outside the primary scope |

FP16 GEMM supports arbitrary dimensions, ordered encoded accumulators, input
conversion, raw `AB+C`, separately rounded `alpha*AB+beta*C`, and source-relative
error certificates. Converting BF16 or FP32 source matrices to FP16 does not
provide native BF16 or TF32 multiplication. The separate `native` operation uses
encoded BF16 or packed TF32 directly. `native_scaled` converts the declared source
format to BF16 or TF32, then applies the complete FP32 scalar epilogue. Both paths
have independent-specification equivalence and source-relative error certificates.

**Domain.** Nonfinite operands and conversions beyond the destination's maximum
finite magnitude are rejected. Exact arithmetic zero produces +0; negative
nonzero underflow retains its sign. Empty raw reductions preserve finite C bits.
Full IEEE exceptions, physical GPU conformance, and globally correctly rounded
GEMM are outside these contracts.

## Reviewer walkthrough

1. Run `./tc review`. Expect ten `PASS` lines. Inspect the
   [requests](tensor-core/data/examples/gemm.jsonl) beside their
   [expected fields](tensor-core/data/examples/gemm.expected.json).
2. Save the complete results, then edit a copy of the requests:

   ```sh
   mkdir -p tmp
   cp tensor-core/data/examples/gemm.jsonl tmp/my-cases.jsonl
   ./tc gemm tmp/my-cases.jsonl > tmp/my-results.jsonl
   ```

3. Inspect the independent [matrix](tensor-core/TensorCore/PaperSpec/Matrix.lean)
   and [scalar](tensor-core/TensorCore/PaperSpec/Scalar.lean) definitions, then the
   [raw](tensor-core/TensorCore/PaperSpec/GemmEquivalence.lean) and
   [complete scaled](tensor-core/TensorCore/PaperSpec/ScaledGemmEquivalence.lean)
   equivalence statements. Use the [main claims](#main-claims-to-review) as your review checklist;
   the detailed [paper map](#paper-claim-review) records source correspondence.
4. Exercise native inputs, quantified families, and a replayable cost decision:

   ```sh
   ./tc gemm tensor-core/data/examples/gemm.native.jsonl
   ./tc gemm tensor-core/data/examples/gemm.native-scaled.jsonl
   ./tc analyze tensor-core/data/examples/gemm.entry-family.jsonl --abs-tol 0.001
   ./tc select tensor-core/data/examples/gemm.cost-selection.jsonl --abs-tol 0.001 --emit tmp/cost.lean
   ./tc verify tmp/cost.lean
   ```

   Expect five raw native results equal to one, five scaled native results equal
   to five, a certified family, and selected index
   `2` (Hopper TF32 MMA, supplied cost `1`). Inspect the certificate's fixed inputs,
   candidates, costs, tolerance, and `decision0`, `selection0`, and `accuracy0` theorems.
5. Run `./tc audit` and `./tc check`. Review the generated reports below.

| Case | What to inspect |
| --- | --- |
| `negative_halfway_rne/rtz/rdn/rup` | FP32 `-2049/2048` converts to FP16 `-1`, except downward rounding gives `-1025/1024` |
| `source_loss` | Converted-input ideal is one; original-source ideal is `4198401/4194304` |
| `source_certificate` | Certificate accepts; tighter bounds include the original input-conversion loss |
| `inconclusive_certificate` | Certificate refuses insufficient headroom; this does not establish execution failure |
| `nonfinite_input` | Input conversion rejects a NaN |
| `finite_out_of_range` | FP32 `65536` is rejected on conversion to FP16, including toward zero |
| `subnormal_upward` | Upward conversion retains the product of both input perturbations |

Small independent entry points:

```sh
./tc trace 3e00 3e00 0c00 0c00 0c00 0c00 0000 0000 00000000
./tc eft tensor-core/data/examples/eft.txt
```

The trace discards two tiny products and returns `0x40100000`. The EFT example
returns `bits: 1073741824` through the scalar branch. Proof examples for
[bounded EFT](tensor-core/examples/BoundedEFT.lean),
[GEMM specification](tensor-core/examples/GemmSpecification.lean), and
[Eq.20 and extraction](tensor-core/examples/FoundationCompletion.lean) are checked
by the full suite. Independent human review remains pending.

## Main claims to review

This is the current artifact claim checklist. Each row names the public statements
and the scope you should verify by reading their definitions and hypotheses.
The [paper map](#paper-claim-review) separately records correspondence to manuscript
sections. A successful build checks proofs of these statements; author review must
still establish that the statements express the intended claims.

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

### Substance and nonvacuity

The main results quantify over formats, input words, matrix dimensions, or family
members. Accuracy predicates require defined ideals and successful execution;
they do not simply assume the error bound. Independent-specification definitions
have a dependency audit separating them from implementation arithmetic.

The kernel-checked [review witnesses](tensor-core/TensorCore/Regression/ReviewClaims.lean)
give concrete checks on these obligations. For `C=1` and seventeen products
`2^-12 * 2^-12`, V100 loses `17/2^24`, while Ampere and Hopper lose `1/2^24`.
At tolerance `10^-6`, the cheapest V100 candidate is proved inaccurate; the
selected Hopper candidate has positive error within tolerance and minimum cost
among certified candidates. Nine analogous native products give positive error
on all five BF16/TF32 schedules. Two distinct nonzero members of the per-entry
family are proved to belong and inherit its accuracy theorem. Empty dimensions
still have the usual vacuous per-entry guarantees; these witnesses use nonempty
matrices. The [native scaled witnesses](tensor-core/TensorCore/Regression/NativeScaledGemm.lean)
also distinguish raw and scaled stage order, prove values beyond FP16 range, and
show that original-source conversion loss changes selection. CLI family caps are nonnegative; arbitrary negative Lean caps can
describe an empty family.

Existing [semantic controls](tensor-core/TensorCore/PaperSpec/NegativeControls.lean)
distinguish premature normalization, IEEE-style alignment, missing floors,
reversed groups, and zero sign. The
[source-loss regression](tensor-core/TensorCore/Regression/GemmInputConversion.lean)
shows why a bound on converted inputs alone does not establish a source-relative
claim. These are useful separating examples, not exhaustive proofs of specification
adequacy. The generic minimum-cost lemma and exact scalar cases are standard
mathematics; substantive artifact claims concern their proved connection to the
tensor-core model and quantified GEMM guarantees. Novelty requires a separate
related-work assessment and application evaluation.

### Review sign-off

Author sign-off remains pending. Check C01–C16 against the linked definitions,
especially finite rejection, zero conventions, group order, original-input ideals,
success obligations, and family membership. Inspect exported certificates with
`./tc verify`; a CLI JSON result alone has not undergone individual kernel replay.
The kernel checks mathematical Lean declarations. The Python driver, parser,
compiled executable, and hardware are separate validation boundaries.

The clean suite checks the declaration links in this checklist and publishes a
[current review-check report](tensor-core/data/regressions/review-claims-report.json).
This records reproducible checks, not human sign-off or paper novelty. Review the
[remaining work](#assessment-and-todo) before making a broader artifact claim.

## GEMM JSON interface

Each nonblank input line contains one request. Output lines correspond in order;
optional `name` labels remain in the input. Words are unsigned decimal bit
encodings, not decimal floating-point values. Arrays are flat and row-major.
Use an integer-preserving JSON parser for FP64 words.

```json
{"operation":"raw","model":"v100","m":1,"n":1,"k":1,"a":[15360],"b":[16384],"c":[0]}
```

The [input schema](tensor-core/data/schemas/gemm.schema.json) specifies fields,
formats, modes, and encoding widths. The executable additionally checks that
array lengths equal `m*k`, `k*n`, and `m*n`.

| Operation | Arithmetic and additional fields |
| --- | --- |
| `raw` | `AB+C`; FP16 A/B, FP32 C |
| `certify` | Input-only certificate for raw GEMM; requires the raw bound fields |
| `scaled` | Input conversion followed by the scalar pipeline below |
| `certify_scaled` | Input-only certificate for the scaled pipeline and original source values |
| `analyze` | Automatic raw FP16 GEMM analysis |
| `analyze_scaled` | Automatic source-relative scaled analysis |
| `analyze_family` | Quantified raw analysis using `a_bound`, `b_bound`, and `c_bound` |
| `analyze_entry_family` | Quantified raw FP16 analysis using row-major `a_bounds`, `b_bounds`, and `c_bounds` arrays |
| `native` | Native BF16/TF32 `AB+C` with FP32 C and output; requires `precision` |
| `analyze_native` | Automatic bounds for the same encoded native inputs |
| `native_scaled` | Source conversion to `precision`, followed by `alpha*AB+beta*C` with FP32 output |
| `analyze_native_scaled` | Automatic source-relative bounds for the complete native scaled pipeline |

All operations require `operation`, `model`, `m`, `n`, and `k`. Concrete requests
require encoded arrays `a`, `b`, and `c`; family requests use rational bounds
instead. Automatic analyses require rational `absolute_tolerance`. Models are
`v100`, `ampere`, and `hopper` for FP16. Native BF16 supports `ampere` and
`hopper`; native TF32 also supports `hopper_mma`. Scaled operations also require:

| Fields | Values |
| --- | --- |
| `input_format`, `output_format` | `fp16`, `bf16`, `fp32`, or `fp64` |
| `input_mode`, `multiply_mode`, `add_mode`, `output_mode` | `rne`, `rtz`, `rdn`, or `rup` |
| `alpha`, `beta` | Encoded FP32 words |

For `native_scaled` and `analyze_native_scaled`, also specify `precision: "bf16"`
or `"tf32"`. These operations require `output_format: "fp32"` and additionally
accept `input_format: "tf32"` for packed 19-bit source words. All four rounding
fields remain explicit. Use `input_format: "fp32"` when supplying FP32 words that
should be rounded to TF32; the conversion is included in the source error bound.

```text
A16, B16 = convert inputs to FP16
P = tensor_core_gemm(A16, B16, +0)
U = round_fp32(alpha * P)
V = round_fp32(beta * C)
S = round_fp32(U + V)
D = convert_output(S)
```

The multiplications and addition are separate rounded operations. Choose
`output_format: "fp32"` for the primary scope. Even with alpha and beta equal
to one, this pipeline can differ from raw GEMM because C enters at a different stage.

The `certify` and `certify_scaled` operations require `accumulator_scale`, `product_scale`, `carry_bits`, and
`initial_bound`. The latter additionally requires `alpha_scale`,
`beta_scale`, `sum_scale`, and `output_scale`. These are sufficient scale and
headroom assumptions, checked against the inputs. Start with the supplied
certificate cases; the [GEMM reference](#wmma-gemm-simulation) gives the contracts.

| Output | Meaning |
| --- | --- |
| `rows[i][j].bits`, `.value` | Encoded output and exact rational value |
| `instructions`, `stages` | Encoded tensor-core and scalar boundaries |
| `ideal`, `entry_bound`, `matrix_bound` | Converted-input ideal and certificate bounds |
| `source_ideal`, `source_entry_bounds`, `source_matrix_bound` | Original encoded-source ideal and bounds, including input conversion |
| `tight_*` | Smaller proved certificate bounds with the same acceptance |
| `accepted: false` | Sufficient certificate was not established |
| `input_conversion_rejected: true` | A source matrix could not be converted |

Fields depend on the operation. Rationals use `"numerator/denominator"` strings.
Matrix bounds use the sum of absolute entry errors. Rejected native and scaled
cells are `null`; raw FP16 cells contain an `error`. A numerical rejection is a valid result and
does not set a process error. Invalid requests stop at the first bad line, return
exit code 2, and emit a JSON diagnostic to stderr. Earlier output lines remain valid.

## Automatic GEMM analysis

Infer sufficient bounds without supplied scale or headroom parameters. The same
launcher accepts raw and complete scaled FP16/BF16/TF32 GEMM, and
families of finite raw FP16 inputs.

```sh
./tc analyze tensor-core/data/examples/gemm.analysis.jsonl --abs-tol 1e-5
./tc analyze tensor-core/data/examples/gemm.scaled-analysis.jsonl --abs-tol 0.01
./tc analyze tensor-core/data/examples/gemm.family.jsonl --abs-tol 0.01
```

All three editable batches certify every request at these tolerances. The CLI
accepts nonnegative exact decimal or rational tolerances. Native JSON uses
`absolute_tolerance: "1/100"`; the launcher supplies it from `--abs-tol`.

| Status | Meaning |
| --- | --- |
| `certified` | Successful model execution and the requested absolute error bound are established for every entry |
| `inconclusive`, `bounds_valid: true` | Proved bounds exceed the requested tolerance |
| `inconclusive`, `bounds_valid: false` | Sufficient finite-input or magnitude conditions were not established |

An inconclusive result does not establish execution failure or excessive actual
error. Bounds measure absolute entry error; `matrix_bound` bounds the sum of
absolute entry errors, not the induced matrix norm.

### Concrete matrices

`analyze` bounds `AB+C` on encoded FP16 A/B and FP32 C. `analyze_scaled` bounds
`alpha*AB+beta*C` decoded from the **original source words**, including conversion
to FP16 and every separately rounded scalar stage. Its source and output conversions
support FP16, BF16, FP32, FP64, and all four rounding modes. Choose FP32 output for
the primary scope. `analyze_native` and `analyze_native_scaled` provide the
corresponding raw and scaled analysis with BF16 or TF32 tensor-core products.
Native scaled analysis also accepts packed TF32 source words and uses FP32 output.

Results contain per-entry `error_bound`, `magnitude_bound`, and inferred
`witness` data. Raw bounds separate alignment and output rounding. Scaled bounds
also separate `input_conversion_bound`, `alpha_rounding_bound`,
`beta_rounding_bound`, `add_rounding_bound`, and `output_rounding_bound`. Tensor
and input-conversion losses already include their `abs(alpha)` factor. Zero
stages have zero error; a final FP32-to-FP32 conversion has zero error in every
mode. Multiplication of a finite FP32 value by +1 or -1 and addition with a
zero-magnitude operand also receive zero error in every mode. Other exact scalar
operations can still receive a positive budget.

The analyzer decodes and converts inputs, checks product grid divisibility, and
propagates unsigned magnitude bounds through the actual ordered groups. It does
not execute GEMM, execute its epilogue, or compute signed ideal dot products.
Empty raw reductions preserve finite C bits with zero error. Empty scaled
reductions still execute the epilogue. Whole-input conversion remains required
even when a scaled output dimension is zero. Finite rejection and zero conventions
are unchanged.

### Native BF16 and TF32

```sh
./tc gemm tensor-core/data/examples/gemm.native.jsonl
./tc analyze tensor-core/data/examples/gemm.native.jsonl --abs-tol 0.001
```

The five cases return FP32 one. BF16 operands use 16-bit encodings; TF32 operands
use packed 19-bit encodings (`0x1fc00` represents one). FP32 register words must
be converted explicitly before submission. No low bits are silently discarded.
BF16 uses increasing K=16 WMMA slices. TF32 uses K=8 slices, with four-product
WMMA groups or eight-product Hopper MMA groups. Output tiles are 16x16 for WMMA
and 16x8 for the selected MMA path. Tail inputs are padded with +0.

The independent matrix specification agrees on every encoded group output and
rejection for all dimensions and input words. The trace-cover theorem preserves
all groups when they are regrouped into instructions. These are logical schedules;
GPU lane mappings, compilation, and performance are separate obligations.

**Native scaled GEMM.** `native_scaled` computes `P = TC(A,B,+0)` after
converting the declared source words to the selected native precision. It then
executes separate FP32 operations `U = round(alpha*P)`, `V = round(beta*C)`,
and `D = round(U+V)`, followed by the explicit FP32 output conversion. Alpha,
beta, C, and D are FP32. Each scalar stage uses its declared rounding mode;
the tensor-core product retains its model's arithmetic. C enters after the
reduction, so even `alpha=beta=1` can differ from raw `TC(A,B,C)`.

```sh
./tc gemm tensor-core/data/examples/gemm.native-scaled.jsonl
./tc analyze tensor-core/data/examples/gemm.native-scaled.jsonl --abs-tol 0.001 --emit tmp/NativeScaled.lean
./tc verify tmp/NativeScaled.lean
```

The five examples compute `2*(1*3)-1 = 5`. Inspect `converted_a`, `converted_b`,
`product_bits`, `instructions`, `stages`, and final `bits`. `ideal` uses converted
inputs; `source_ideal` uses the original words. Analysis bounds refer to the
original source ideal and include both input perturbations, their product effect,
amplification by `abs(alpha)`, and every scalar stage. The matrix bound sums
per-entry bounds. Analysis performs conversion and unsigned bound propagation;
it does not execute GEMM or compute either signed ideal.

The Lean [native pipeline](tensor-core/TensorCore/Programs/NativeScaledGemm.lean),
[source analysis](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean), and
[independent equivalence](tensor-core/TensorCore/PaperSpec/NativeScaledGemmEquivalence.lean)
cover arbitrary dimensions and all five schedules. Conversion rejection remains
whole-matrix rejection, even for unused source entries when an output dimension
is zero. A failed scalar intermediate remains rejection even if later cancellation
would put the final ideal in range. No FMA contraction or EFT is implicit. Native
precision refers to the arithmetic format, not execution on physical GPU hardware.

### Input families

A family fixes the dimensions and independently bounds every encoded entry:
`abs(Aij) <= a_bound`, `abs(Bij) <= b_bound`, and `abs(Cij) <= c_bound`. A/B range
over finite FP16 words and C over finite FP32 words, including subnormals and
both signed-zero encodings. The theorem quantifies over these encoded matrices;
it does not quantify over arbitrary real inputs. No concrete arrays are needed.

```json
{"operation":"analyze_family","model":"hopper","m":2,"n":3,"k":17,"a_bound":"1/1","b_bound":"1/1","c_bound":"1/1","absolute_tolerance":"1/100"}
```

Family results give a uniform `entry_bound`, `matrix_bound`, and inferred static
witness. Bounds use the existing static theory with operand scales derived from
the declared ranges, including the subnormal scale floor. The checker validates
carry and accumulator headroom for every family member. Inference searches the
supported accumulator scales; its conditions are sufficient, not necessary.
It never enumerates matrices or floating-point words. Family bounds can be more
conservative than concrete analysis, which inspects individual products.
For per-entry caps, use `analyze_entry_family` with rational arrays `a_bounds`,
`b_bounds`, and `c_bounds`, sized like the corresponding matrices. A zero cap
requires a decoded zero and permits both signed-zero encodings. The theorem
quantifies over every finite encoded matrix satisfying every cap.

```sh
./tc analyze tensor-core/data/examples/gemm.entry-family.jsonl --abs-tol 0.001
```

Each output uses its A row maximum, B column maximum, and own C cap. Results
provide `entry_bounds`, their summed `matrix_bound`, and one witness per output.
The supplied example reduces the summed bound from about 0.002083 to 0.000521.
This reduction is an example, not a universal factor. The current checker does
not exploit every internal zero or grid relation. Grid constraints, stronger
sparsity bounds, and scaled/source families remain planned.

### Export and review

```sh
mkdir -p tmp
./tc analyze tensor-core/data/examples/gemm.scaled-analysis.jsonl --abs-tol 0.01 --emit tmp/Scaled.lean
./tc verify tmp/Scaled.lean
./tc analyze tensor-core/data/examples/gemm.family.jsonl --abs-tol 0.01 --emit tmp/Family.lean
./tc verify tmp/Family.lean
```

`--emit` writes a new certificate only when every request is certified; existing
files are preserved. Export refusal exits with code 1; invalid input uses code 2.
A batch may mix raw, scaled, native, native_scaled, and family requests. Certificates contain
the input words or family bounds, tolerance, and public accuracy theorem. Native
and per-entry family exports re-infer witnesses in Lean through a single-candidate
decision; other analysis exports carry explicit witnesses.
`verify` checks the canonical format and toolchain/source fingerprint, then
replays the checker with `decide +kernel`. Native JSON results use compiled Lean;
individual kernel replay is established only after verification succeeds.
Regenerate certificates after theory changes. Appended Lean commands are rejected.

| Contract | Main proof entry point |
| --- | --- |
| Concrete raw accuracy and independent output | [GemmAnalysis.lean](tensor-core/TensorCore/Programs/GemmAnalysis.lean) |
| Scalar range, mode-sensitive error, exact FP32 output | [ScalarAnalysis.lean](tensor-core/TensorCore/Programs/ScalarAnalysis.lean) |
| Raw-to-epilogue propagation | [ScaledGemmAnalysis.lean](tensor-core/TensorCore/Programs/ScaledGemmAnalysis.lean) |
| Original-source accuracy, matrix bounds, independent output | [ConvertedGemmAnalysis.lean](tensor-core/TensorCore/Programs/ConvertedGemmAnalysis.lean) |
| Quantified raw families, matrix bounds, independent output | [GemmFamily.lean](tensor-core/TensorCore/Programs/GemmFamily.lean) |
| Exact identity scalar stages | [ExactScalarAnalysis.lean](tensor-core/TensorCore/Programs/ExactScalarAnalysis.lean) |
| Native matrix analysis and completeness | [NativeGemm.lean](tensor-core/TensorCore/Programs/NativeGemm.lean) |
| Native independent equivalence | [NativeGemmEquivalence.lean](tensor-core/TensorCore/PaperSpec/NativeGemmEquivalence.lean), [NativeScaledGemmEquivalence.lean](tensor-core/TensorCore/PaperSpec/NativeScaledGemmEquivalence.lean) |
| Native source conversion, scaled accuracy, matrix error | [NativeConvertedAnalysis.lean](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean) |
| Native scaled proof example | [NativeScaledGemm.lean](tensor-core/examples/NativeScaledGemm.lean) |
| Per-entry quantified families | [EntryFamily.lean](tensor-core/TensorCore/Programs/EntryFamily.lean) |
| Small proof examples | [PipelineAnalysis.lean](tensor-core/examples/PipelineAnalysis.lean), [DecisionExtensions.lean](tensor-core/examples/DecisionExtensions.lean) |

`analyzeGemmCell_complete` proves raw inference succeeds for finite inputs when
`abs(C) + sum(abs(A[l]*B[l])) <= maxFinite32`. This completeness statement does
not extend to every successfully executing scaled pipeline or family.
`analyzeNativeCell_complete` gives the corresponding unsigned-mass condition
for native BF16/TF32 reductions.
[GroupAnalysis.lean](tensor-core/TensorCore/Programs/GroupAnalysis.lean) proves the
local comparison with the previous static budget under explicit scale caps;
[Local.lean](tensor-core/TensorCore/Theory/ProgramBounds/Local.lean) supplies the
magnitude, divisibility, and rounding arguments.

On the supplied 17-product raw workload, bounds improve on valid legacy
certificates using the exact product scale, minimum carry bits, and minimum
accumulator scale permitted by C:

| Model | Legacy bound | Inferred bound | Reduction factor |
| --- | --- | --- | --- |
| V100 | `21/1048576` | `33/8388608` | 5.09 |
| Ampere | `73/4194304` | `3/4194304` | 24.33 |
| Hopper | `273/16777216` | `5/16777216` | 54.60 |

These are checked examples, not universal improvement factors. The
[raw report](tensor-core/data/regressions/analysis-report.json) and
[scaled/family report](tensor-core/data/regressions/pipeline-analysis-report.json)
record independent rational comparisons, kernel replay, altered-certificate
rejections, and transitive audits excluding GEMM execution and ideal-product
computation. Sampled family tests supplement the universally quantified Lean proof.

Unsigned magnitude bounds can be conservative under cancellation. Broader paper
evaluation remains open. Globally correctly rounded GEMM and physical GPU
guarantees remain outside this analysis.

## Certified configuration selection

Supply one workload, candidates in preference order, and an absolute tolerance.
By default, the tool selects the first candidate whose inferred bound certifies
every output entry. The `minimum_cost` policy selects a candidate with minimum
supplied cost among those certified. Both policies report every analysis and
return the selected request.

```sh
./tc select tensor-core/data/examples/gemm.selection.jsonl --abs-tol 1e-6
./tc select tensor-core/data/examples/gemm.selection.jsonl --abs-tol 1e-6 --emit tmp/Decision.lean
./tc verify tmp/Decision.lean
```

The three editable examples select Ampere for concrete raw GEMM, V100 for a raw
input family, and nearest-even input conversion on Hopper for scaled GEMM.
Their zero-based `selected_index` values are `1`, `0`, and `1`.

```json
{"operation":"select","workload":{"operation":"raw","m":1,"n":1,"k":1,"a":[15360],"b":[16384],"c":[0]},"candidates":[{"model":"v100"},{"model":"ampere"},{"model":"hopper"}]}
```

The [selection schema](tensor-core/data/schemas/selection.schema.json) defines
the separate request format. `--abs-tol` supplies `absolute_tolerance`; native
requests include it as a rational string. All candidates share the same workload,
dimensions, original words or family bounds, and mathematical target.

| Workload | Fixed fields | Candidate fields |
| --- | --- | --- |
| `raw` | `m`, `n`, `k`, encoded `a`, `b`, `c` | `model` |
| `family` | `m`, `n`, `k`, rational `a_bound`, `b_bound`, `c_bound` | `model` |
| `entry_family` | Dimensions and rational `a_bounds`, `b_bounds`, `c_bounds` arrays | `model` |
| `native` | Dimensions, `precision: "bf16"` or `"tf32"`, encoded `a`, `b`, `c` | `model` |
| `scaled` | `m`, `n`, `k`, encoded `a`, `b`, `c`, `input_format`, `output_format: "fp32"`, encoded FP32 `alpha`, `beta` | `model`, `input_mode`, `multiply_mode`, `add_mode` |
| `native_scaled` | The scaled fields plus `precision` and `output_mode` | `model`, `input_mode`, `multiply_mode`, `add_mode` |

Both scaled candidate kinds must specify all three rounding modes. FP16 scaled
selection fixes final conversion to nearest-even. Native scaled selection preserves
the workload's explicit `output_mode`; final conversion to FP32 is exact. Raw and family
candidates contain only a model. Unknown fields, invalid candidates, empty
candidate lists, and shape errors are rejected, including invalid entries after
an acceptable candidate. Duplicate candidates are allowed. Preference order breaks
equal-cost ties.

| Result | Meaning |
| --- | --- |
| `status: "selected"` | A candidate is certified at the requested tolerance |
| `selected_index`, `selected_candidate` | Position and configuration in the supplied list |
| `selected_request` | Concrete execution request or family analysis request, accepted by `./tc gemm` |
| `selected_cost` | Exact supplied cost under `minimum_cost`; otherwise null |
| `candidates[i].analysis` | Bounds, witnesses, and acceptance for that candidate |
| `status: "inconclusive"`, `selected_index: null` | No candidate was certified; actual accuracy and feasibility remain undecided |

Models denote different architecture semantics. Supply candidates appropriate to
your available hardware. Both scaled kinds compare conversion and scalar rounding
modes. Native requests compare supported schedules for one fixed product precision.
A single decision across FP16, BF16, and TF32 product precisions remains an extension.

For cost optimization, add `"policy": "minimum_cost"` and a `costs` array with
one nonnegative rational total cost per candidate. Costs use your chosen units;
the tool does not infer GPU timings. The launcher accepts exact decimal strings.

```sh
./tc select tensor-core/data/examples/gemm.cost-selection.jsonl --abs-tol 0.001 --emit tmp/Cost.lean
./tc verify tmp/Cost.lean
```

The example selects Hopper TF32 MMA at supplied cost one. The
[cost theorem](tensor-core/TensorCore/Programs/CostSelection.lean) proves accuracy,
list membership, and cost no greater than any analyzer-certified candidate.
A cheaper candidate may be accurate but uncertified. Optimality over all accurate
configurations, learned cost models, and hardware speedups are not claimed.

The [selection theorem](tensor-core/TensorCore/Programs/GemmSelection.lean)
proves that the selected index belongs to the candidate list, its execution meets
the accuracy contract, and every earlier candidate fails this analyzer's test.
For families, accuracy quantifies over every encoded matrix in the declared
ranges. `selectGemm_none` characterizes absence of a certified candidate without
claiming numerical impossibility. The existing independent-specification
equivalence applies to each selected model.

Export includes the fixed workload, full ordered candidate list, tolerance, and
selected index. Kernel replay recomputes inference and selection through the
selected prefix for preference, or all candidates for cost, then derives the
accuracy and selection theorems. Cost exports include the complete cost array. It does not
trust JSON acceptance flags or supplied rejection witnesses. Export requires a
selection for every request and preserves existing files, using the same exit
codes and source fingerprint checks as `analyze`. See the small
[proof example](tensor-core/examples/GemmSelection.lean).

The initial [evaluation](tensor-core/data/regressions/selection-report.json)
covers 236 decision requests, 1,644 candidate analyses, and 2,874 independent
rational output checks. Later candidates certify 13 requests whose first
candidate is uncertified. The report records conservative refusals, certificate
replay, and CPU costs. These counts describe this fixed suite, not an estimated
success rate for applications. Family sampling remains in the
[family report](tensor-core/data/regressions/pipeline-analysis-report.json).
The [extension evaluation](tensor-core/data/regressions/decision-extensions-report.json)
adds 95 native requests, 1,765 successful output checks, 2,936 encoded boundaries,
91 cost decisions, and 128 sampled family cells. Kernel regressions cover every
native path, tails, negatives, subnormals, signed zero, finite boundaries, and
cost ties. Altered decision data is rejected by kernel replay.
This is an initial artifact evaluation. Representative applications, comparisons
with related tools, and hardware performance measurements remain open.

## Bounded EFT interface

Each batch line has the form `block PATH a0 b0 ... c D`. Operands use unsigned
decimal encodings; C and the supplied output D use FP32. Available paths:

| Path | Product pairs | Operand encoding |
| --- | ---: | --- |
| `v100-fp16` | 4 | FP16 |
| `a100-fp16`, `a100-bf16` | 8 | FP16 or BF16 |
| `h100-fp16`, `h100-bf16` | 16 | FP16 or BF16 |
| `a100-tf32`, `h100-tf32-wmma` | 4 | Packed 19-bit TF32 |
| `h100-tf32-mma` | 8 | Packed 19-bit TF32 |

Results expose `bits`, `branch`, and extraction diagnostics. The bounded procedure
uses a 576-bit workspace and returns a correctly rounded FP32 result whenever
the exact ideal is in the finite FP32 range. See the
[correction reference](#correction-and-its-implementation-boundary) for branch,
range, and operation-budget contracts.

## Validation and trust

```sh
mkdir -p tmp
./tc check > tmp/validation.json
```

The clean suite builds without a cache, runs every standalone example, audits
proof dependencies, and checks independent oracles, archived vectors, rejection
controls, and CLI compatibility. It hashes the source, launcher, README, and pins
before and after copying and validation. Concurrent source changes prevent report
publication. Progress goes to stderr; the final report is JSON on stdout.

| Evidence | Inspect |
| --- | --- |
| Latest clean suite | [clean-build.json](tensor-core/data/regressions/clean-build.json) |
| Public tool compatibility | [tool-report.json](tensor-core/data/regressions/tool-report.json) |
| Editable reviewer cases | [reviewer-report.json](tensor-core/data/regressions/reviewer-report.json) |
| Independent specification | [paper-spec-report.json](tensor-core/data/regressions/paper-spec-report.json) |
| GEMM stages and error certificates | [gemm-extensions-report.json](tensor-core/data/regressions/gemm-extensions-report.json) |
| Automatic raw analysis and certificate replay | [analysis-report.json](tensor-core/data/regressions/analysis-report.json) |
| Scaled and quantified-family analysis | [pipeline-analysis-report.json](tensor-core/data/regressions/pipeline-analysis-report.json) |
| Configuration decisions and initial evaluation | [selection-report.json](tensor-core/data/regressions/selection-report.json) |
| Native paths, richer families, and supplied costs | [decision-extensions-report.json](tensor-core/data/regressions/decision-extensions-report.json) |
| Native scaled/source pipeline and certificates | [native-scaled-report.json](tensor-core/data/regressions/native-scaled-report.json) |
| Bounded EFT | [bounded-eft-report.json](tensor-core/data/regressions/bounded-eft-report.json) |
| Current claim links and nonvacuity witnesses | [review-claims-report.json](tensor-core/data/regressions/review-claims-report.json) |
| Historical paper-source assessment | [claim-review.json](tensor-core/data/regressions/claim-review.json) |
| Complete axiom listing | [axioms.txt](tensor-core/docs/axioms.txt) |
| Pinned CUTLASS source checks | [cutlass-report.json](tensor-core/data/regressions/cutlass-report.json) |

Allowed proof dependencies are `propext`, `Classical.choice`, and `Quot.sound`.
There are no project axioms or compiled reflection. Mathematical proofs concern
the explicit finite-domain definitions. Python checks and archived vectors provide
test evidence. CUTLASS is a reviewed source arithmetic projection; CUDA compilation,
V100 execution, memory transport, and compiler correspondence remain unvalidated.

The latest clean report determines current build evidence. CPU benchmarks remain
separate from correctness and GPU performance claims.

## Assessment and TODO

README.md is the single maintained plan and status document. Current review scope:
FP32-output arithmetic and complete raw/scaled FP16, BF16, and TF32 GEMM;
FP8 is deferred. The implementation includes
four-mode finite rounding, signed encoding bijections, selected tensor-core
contracts, bounded EFT, Eq.20 and extraction grids, complete scaled-GEMM
equivalence, tighter original-input error certificates, automatic raw and scaled
GEMM analysis, quantified raw input families, and configuration selection with
kernel-replayable accuracy, preference, and supplied-cost certificates.

| Priority | Status | Next step |
| --- | --- | --- |
| Reviewer workflow | Implemented | Follow the walkthrough, C01–C16 claim checklist, nonvacuity witnesses, schemas, and replay commands |
| Human claim review | Pending | Inspect definitions and assumptions; record author sign-off |
| Source reproducibility | Implemented | Use a fixed Git revision and compare the clean validation hashes |
| Automatic raw GEMM analysis | Implemented | Review inferred local bounds, completeness domain, and exported Lean certificates |
| Automatic scaled analysis | Implemented | Review source-relative budgets, every scalar stage, and kernel exports |
| Input-family analysis | Implemented for uniform and per-entry raw ranges | Review quantified finite FP16/FP32 membership, local caps, and static headroom |
| Further family precision | Open | Exploit internal sparsity and grid constraints; add scaled/source and native families |
| Certified configuration selection | Implemented | Review preference and minimum supplied cost among certified models, with kernel replay |
| Decision-tool evaluation | Initial suite implemented | Inspect synthetic and boundary cases, conservative refusals, and CPU/replay costs |
| Full-paper evaluation | Next | Add representative application workloads and related-method comparisons; establish useful certification rates and scaling |
| Cost-model validation | Open | Supply measured or justified costs; compare decisions against representative applications |
| Native BF16/TF32 raw GEMM | Implemented | Review five schedules, independent equivalence, encoded input domains, and certificates |
| Native scaled/source integration | Implemented | Review all five schedules, independent stage equivalence, source-relative matrix bounds, and kernel-replayable decisions |
| Selection across product precisions | Open | Compare FP16, BF16, and TF32 candidates for one fixed original-source workload |
| CUTLASS execution | Open | Compile the pinned fixture and compare on V100 |
| CUTLASS generalization | Optional | Model residue-first partial K, other epilogues, and split-K |
| Further error bounds | Optional | Track cancellation and accumulator grids; extend exact scalar cases beyond ±1 and zero addition; add induced norms |
| General scalar arithmetic | Outside current scope | Encoded subtraction, multiplication, division, square root, and generic FMA APIs |
| Globally corrected GEMM | Outside current scope | Prove a complete residual ledger, capacity, and one final rounding |
| Adaptive programs | Outside current scope | Add state, branches, invariants, and decision/composition certificates |
| FP16 tensor-core outputs and FP8 | Deferred | Resolve specification ambiguities and complete remaining paths |

The [main claims](#main-claims-to-review) record current artifact scope; the
[paper map](#paper-claim-review) records manuscript correspondence. The
[coverage review](#remaining-paper-coverage) retains unresolved paper/source
questions. Neither full paper coverage nor universal physical GPU conformance is claimed.

## Source pins and layout

| Source | Pin |
| --- | --- |
| Accurate Models | [arXiv:2512.07004v4](https://arxiv.org/abs/2512.07004v4) |
| TC-EFT | Corrected manuscript; [validation source provenance](tensor-core/vendor/tc-eft-validation/SOURCES.json) |
| MATLAB Tensor Core v0.5 | `bbcf00a273868172494eaacaa8d6128ab0fb8704`; [source manifest](tensor-core/vendor/SOURCES.json) |
| CUTLASS v3.5.1 | `f7b19de32c5d1f3cedfc735c2849f12b537522ee`; [configuration and hashes](tensor-core/kernels/cutlass/pin.json) |

```text
tc                         Public launcher
README.md                  Guide, contracts, plan, and status
tensor-core/
  TensorCore/
    Foundations/           Exact arithmetic and encodings
    Semantics/             Executable arithmetic models
    Theory/                General proofs
    PaperSpec/             Independent definitions and equivalence proofs
    Programs/              Correction, composition, and GEMM
    Applications/          Bounded-dot application
    Meta/                  Typed DSL
    Cli/                   JSON protocol
    Kernels/               Reviewed source projections
    Regression/            Kernel-checked regression cases
  examples/                Small executable and proof examples
  data/examples/           Editable reviewer inputs and expected answers
  data/schemas/            Machine-readable interface contracts
  data/regressions/        Generated validation evidence
  scripts/                 Independent oracles and validation gates
  kernels/cutlass/         Optional CUDA fixture and pinned headers
  vendor/                  Pinned upstream source and data
tmp/                       Ignored local experiments and output
```

Bundled upstream files supply numerical fixtures, source contracts, and validation
generators; their source and licenses remain unchanged. Research PDFs, external
comparison projects, and historical handoff reports are excluded. Build caches and
local experiments stay in ignored `.lake/` and `tmp/` directories.

## Technical reference

Expand a section for proof statements, numerical details, source review, or optional
extensions. Reference commands use `tensor-core/` as their working directory unless stated otherwise.

### Numerical model

<details>
<summary>Expand reference</summary>

One normalization group computes `S = value(c) + Σ value(aᵢ)·value(bᵢ)`:

1. Decode finite operands to signed integer significands and raw scales.
   Subnormals retain their explicit fraction and minimum normal scale.
2. Multiply significands and add scales, preserving the unnormalized product
   metadata. Equal real products with different raw scales can produce different
   tensor-core outputs.
3. Select `η` as the maximum raw scale of nonzero terms, including `c`, then apply
   the profile's optional floor. Zero terms never select the exponent.
4. Truncate each magnitude onto the grid `qA = 2^(η−F)`, restore its sign, and sum
   the integer coefficients exactly, with no intermediate normalization.
5. Normalize and truncate the accumulated value to FP32. Record each alignment
   residual and the output residual, giving `S = D + r_out + Σ rᵢ` exactly.

Alignment truncation discards magnitude bits on the shared grid; its direction is
toward zero, but it is not an IEEE FP32 rounding of each product. Final FP32
conversion is a separate operation. An arithmetic right shift of a negative
integer would round downward and does not implement this signed truncation.

The independent ideal multiplies decoded original operands directly. It does not
use raw-product metadata, alignment, model outputs, or correction code.

The [R1 regression](tensor-core/TensorCore/Regression/Cases.lean) proves that
replacing `1.5 × 1.5` with `1 × 2.25` leaves every product value unchanged but
changes the output from `0x40100001` to `0x40100000`: the different raw scales
select different alignment grids. This checks the tensor-core truncation behavior.

The proved family is `fp16Fp32Profile K extraBits floor`, with `F = 23 + extraBits`:

| FP16 → FP32 path | Products per group `K` | Alignment bits `F` | Floor | Pinned k=16 instruction |
| --- | ---: | ---: | ---: | --- |
| V100 | 4 | 23 | none relevant | `v100Wmma16`: four groups |
| Ampere/Ada | 8 | 24 | −132 | `ampereWmma16`: two groups |
| Hopper/Blackwell | 16 | 25 | −133 | `hopperWmma16`: one group |

These architecture names refer to the paths characterized by the source paper.
Floors at or below −126 are proved inactive for FP16 operands and FP32 `c`.
BF16 and packed TF32 input families now also have FP32-output contracts, with
proofs connecting their published-vector descriptors to the profiles. TF32
register decoding checks the required padding. BF16/TF32 floors can be active;
the FP16 floor-inactivity result does not extend to those inputs.

Native L40S/Ada FP8 has separately named **paper** and **source13** readings in
[FP8.lean](tensor-core/TensorCore/Semantics/FP8.lean), both using 16-product groups
and 13 alignment fraction bits. The `paper` candidate interprets Figure 4's final
stage as direct FP32 conversion; the pinned source additionally truncates the
normalized sum to 13 fraction bits before FP32 encoding. The paper establishes the
alignment width but does not establish that extra normalized truncation. The review
under [Assessment and TODO](#assessment-and-todo) records the unresolved claim and
exact locations.
Published L40S rows distinguish the candidates; paper/source agreement and physical
device conformance are not claimed. E4M3 uses its finite-top-NaN
encoding, including 448; E5M2 uses IEEE-style decoding. The source's −132 alignment
floor is proved inactive for finite FP8 factors and FP32 `c`.

`runL40SFP8` accepts exactly 32 pairs and executes two consecutive groups, passing
the first encoded result as the second accumulator. `runL40SFP8_recovery` proves
the loss ledger against the independent original-input ideal; final conversion
and the source13 intermediate truncation have rounding proofs. See the
[FP8 example](tensor-core/examples/FP8.lean). These additions leave the established
FP16/BF16/TF32 profiles unchanged.

**Finite-domain contract.** Nonfinite operands, incorrect shapes, and conversion
inputs beyond the maximum finite magnitude are rejected. In particular, `round32`
rejects `abs(x) > maxFinite32`, including values where IEEE truncation would
saturate; its internal `round32Core` is not an overflow specification. Each stage
needs its own range condition. Exact zero produces +0; a negative nonzero value
rounded to zero retains its sign. All-zero groups use an arbitrary grid only for
exact zero arithmetic.

Aligned invocations allow `K = 0`; fused invocations require `K = 1`.
`runCanonicalDot` and `runCanonicalDotMachine` require positive group width and a
finite initial accumulator even for an empty list. An empty finite public run
preserves the initial bits; low-level `runBlocks []` is an unconditional no-op.

</details>

### Floating-point theory and principal results

<details>
<summary>Expand reference</summary>

The independent [paper specification](tensor-core/TensorCore/PaperSpec/Definition.lean)
defines decoding, raw product values and exponents, nonzero exponent selection,
shared-grid magnitude truncation, accumulation, and FP32 output rounding directly.
Its definition, profile, schedule, matrix, native matrix, and scalar modules import
only Lean's standard library and each other. They do not call the implementation's arithmetic stages. Final
rounding is characterized by the ordering of all finite encoded FP32 values and
an explicit sign-bit condition. Its output selector is mathematical
(`noncomputable`), with proved existence and uniqueness on its valid domain.

`PaperSpec.supported_eq_paper` proves bit equality for every encoded input of the
eight named FP16/BF16/TF32-to-FP32 paths, including rejections observed as `none`.
`PaperSpec.supported_valid_success` proves successful execution from the independent
paper-side validity predicate. The stronger generic `implementation_eq_paper`
covers arbitrary block-profile parameters; it gives those parameters mathematical
semantics, without asserting that each is a paper-characterized device.
`tf32_eq_paper` connects correctly padded TF32 register words to the specification;
`machine_eq_paper` transfers agreement to adequately wide modular accumulation.
`runBlocks_eq_paper` proves every intermediate encoding of every explicitly ordered
finite group list. The public `PaperSpec.gemm_eq_paper` now proves whole-matrix
agreement for the three FP16 WMMA profiles at arbitrary dimensions, including
original row/column indexing, k=16 padding, output cropping, and every encoded
group/instruction boundary. `gemmBits_eq_paper` projects the final output matrix.
Both are unconditional equalities, observing rejected entries as `none`; specific
implementation error tags are not part of the specification. Empty k preserves
finite C, including its zero sign; empty output dimensions are vacuous.
`convertedGemmCheck_paper_sound` combines an accepted original-source certificate
with independent product traces and mathematical input-conversion/scalar contracts.
The independently defined scalar evaluator now characterizes the binade by
inequalities and rounding by integer-grid rules, with existence and unique encoded
bits proved in `scalarRound_eq`. `scaledGemm_eq_independent` and
`convertedGemm_eq_independent` give unconditional whole-pipeline equality, including
all scalar encoded boundaries, whole-input conversion failure, per-cell rejection,
signed zero, ill-formed output formats, and empty dimensions. They require no
certificate or successful-run premise. This scalar sequence specifies the project
pipeline; it is not an extra hardware rule attributed to Accurate Models.
The [example](tensor-core/examples/PaperSpecification.lean) shows these contracts.

`nativeScaledGemm_eq_independent` and `nativeConvertedGemm_eq_independent` extend
whole-pipeline agreement to the five BF16/TF32 schedules, at arbitrary dimensions
and in all four scalar/conversion rounding modes. They preserve every encoded
boundary and rejection without an execution-success premise.
`nativeConvertedAnalysisCheck_paper` combines this agreement with an accepted
original-source error certificate. See the
[native scaled example](tensor-core/examples/NativeScaledGemm.lean).

The [dedicated gate](tensor-core/scripts/check_paper_spec.py) audits compiled
dependencies of every specification declaration, checks the standard proof-axiom
allowlist, and rejects indirect dependencies on implementation arithmetic or the
implementation's matrix partition or scalar conversion functions. Kernel-checked controls distinguish premature product normalization,
per-term IEEE RTZ alignment, removal of each BF16 hardware floor, and group reversal.
The [report](tensor-core/data/regressions/paper-spec-report.json) records the checked
source hashes. These proofs establish implementation-to-formal-specification
agreement; the [claim review](#paper-claim-review) records the source-to-definition
assessment, with human author/reviewer sign-off still required. The specification
explicitly adopts the finite-range and zero conventions described above.
FP16 tensor-core output, FP8, and physical GPU conformance remain outside the
independent-specification theorem. The matrix theorem covers the selected logical
WMMA schedule, without a lane/register mapping or a full MATLAB/CUDA kernel theorem.

The floating-point foundation proves finite binary decoding, encoding, and all four
rounding directions (nearest-even, toward zero, toward −∞, and toward +∞) for every
well-formed IEEE-style `Format`, including FP16, BF16, packed TF32, FP32, FP64, and E5M2.
Exact scalar addition and common-grid
summation are also proved for every well-formed format, including arbitrary input
orderings and the paper's separate coefficient and absolute-range budgets.
Tensor-core proofs build on this foundation. The rounding
theorems quantify over every rational in the format's finite reference range;
concrete examples use kernel reduction and are reported separately.

`round32` implements toward-zero and nearest-ties-even rounding, with proofs for
both. `roundBinary_towardNegative_correct` and `roundBinary_towardPositive_correct`
prove that the generic converter selects the greatest finite value below the input
and the least finite value above it, respectively. `roundBinary_correct` packages
all four directions; `roundBinary_isSome_iff` characterizes the unchanged finite
rejection domain, and `roundBinary_sign` proves the sign convention even on underflow.
Nearest-ties-away, saturation, stochastic rounding, and round-to-odd are outside
the implemented modes. Beyond rounding, this is not
yet a complete scalar arithmetic library: the scaled GEMM has proved FP32
multiplication/addition stages and FP64 DMMA has a fused contract, but reusable
format-generic subtraction, multiplication, division, square root, and FMA APIs,
exception flags, and operation-specific signed-zero rules remain to be developed. Subnormal values
are supported; flush-to-zero policies are outside the current model.
E4M3's finite-top-NaN `ValueFormat` is outside this generic converter: E4M3 can
encode 448, whereas the IEEE-style layout with the same field widths stops at 240.
`Regression.e4m3_outside_generic_rounding` proves that distinction.

`binary64Fma_correct` completes the FP64 DMMA four-direction finite fused contract:
the rounded input equals the independently decoded exact product plus accumulator.
`binary64Fma_success` derives successful execution from finite decoded inputs, the
one-product shape, and an in-range exact fused result. The product alone need not
be in range. These are arithmetic contracts, without exception flags or a physical
GPU conformance claim.

The [finite bijections](tensor-core/TensorCore/Theory/Binary/SignedBijection.lean)
preserve signed zero explicitly. `FiniteBinaryWord f` contains exactly words with
finite IEEE classification. `finiteBinaryBijection` pairs these words with
`BinaryRep f`: sign, nonnegative significand below `2^(p+1)`, and exponent in
`[emin, emax]`, with a leading bit unless the exponent is `emin`. Zero and
subnormals therefore use `emin`. `signedFiniteBinaryBijection` instead pairs the
words with `SignedFiniteValue f`: an arithmetic representable rational and a sign
bit forced by negativity for nonzero values, freely chosen for zero. Both maps are
executable and both inverse laws are proved. The explicit encoder preserves −0;
rounding its rational projection still produces +0. `binaryValue_roundBinary`
proves bitwise round trips for every nonzero finite word in all four modes.
See the [foundation example](tensor-core/examples/BinaryFoundation.lean) and
[kernel regressions](tensor-core/TensorCore/Regression/DirectedBinary.lean).

All declarations below are in the `TensorCore` namespace. The source directories
are [Foundations](tensor-core/TensorCore/Foundations),
[Theory](tensor-core/TensorCore/Theory), and
[Programs](tensor-core/TensorCore/Programs).

| Contract / paper reference | Principal declarations and domain |
| --- | --- |
| Finite encoding and correct rounding : TC-EFT II.1–II.2 | `decode32_finite`, `value32_finite`, `round32_nearestEven_correct`; finite FP32 encodings and rationals with magnitude at most `maxFinite32` |
| Format-generic conversion | `roundBinary_correct`, `roundBinary_towardNegative_correct`, `roundBinary_towardPositive_correct`, `roundBinary_nearestEven_correct`, `roundBinary_towardZero_correct`; every well-formed format and rational in its finite reference range. The four `conversionStage_*_correct` theorems transfer these contracts to accepted stages. |
| Finite bijections and exact round trips | `finiteBinaryBijection`, `signedFiniteBinaryBijection`, `binaryValue_roundBinary`, `binaryValue_sign_injective`; finite IEEE words, canonical significands/exponents or representable rationals with an explicit zero sign |
| FP64 DMMA, four rounding directions | `binary64Fma_correct`, `binary64Fma_success`, `binary64Fma_towardNegative`, `binary64Fma_towardPositive`; one exact decoded product plus accumulator, finite operands and finite fused result |
| Round trip, uniqueness, truncation | `value32_round32`, `value32_injective` for nonzero finite encodings; `round32_nonzero_spec`; `signedRounded_rtz_monotone` on the finite range |
| Raw products, aligned accumulation, residuals | `rawProduct_value`, `accumulator_value`, `alignment_residual`, `evalBlock_residual_identity` |
| Independent Accurate Models specification, FP32-output paths | `PaperSpec.supported_eq_paper`, `PaperSpec.supported_valid_success`; independent stages and rounding relation, every encoded input, explicit finite domain and signed-zero bits; `PaperSpec.runBlocks_eq_paper` for ordered groups |
| Two-stage error : TC-EFT III.1 | `block_error_bound`, `evalBlock_error_bound`: `abs(S−D) < n·qA + qD`, where `n = K+1` and the aligned accumulator is in range |
| Parameterized FP16 → FP32 contract and exact accepted domain | `fp16Fp32_contract`, `evalBlock_success_iff`; arbitrary product count and extra alignment bits |
| BF16/TF32 → FP32 contracts and descriptor compatibility | `profile_contract`, `bf16Fp32_contract`, `tf19Fp32_contract`, `bf16Fp32_invocation_compatible`, `tf32_invocation_bits`; TF32 equivalence requires padded register words |
| Modular accumulator refinement | `fp16Fp32_machine_eq`; complete results, including rejections, agree when `w ≥ 26 + extraBits + carryBits` and `K+1 ≤ 2^carryBits`; every prefix is safe |
| Floor inactivity and exact alignment with sufficient padding | `canonical_eta_floor_inactive`; `canonical_source_padding_exact` for `extraBits ≥ 156`, floor ≤30; `canonical_padding_exact` for `extraBits ≥ 253`, floor ≤127 |
| Monotonicity and flowback : TC-EFT III.2–III.3, Equation 6 | `MonotoneInAccumulator`, `MonotoneInEncodedAccumulator`, `monotoneInAccumulator_encoded`, `perturbed_accumulator`, `output_condition`, `flowback_necessary`, `flowback_sufficient`; accepted outputs, with representable accumulators required for sufficiency |
| Non-monotonicity family : TC-EFT III.4–III.5, Table III | `nonmonotone_perturbation`, `nonmonotone_encoded`, `nonmonotone_range_encoded`; family and thresholds below |
| Low parts, overlap window, splitting and recovery : TC-EFT IV.1–IV.5 | `lowPart_bound`, `overlap_window_width`, `truncGrid_split`, `accumulator_eq_retained`, `overlap_eq_retained_sub_outputResidual`, `overlap_recovery` |
| Scalar predicate and exact summation : TC-EFT IV.6–IV.11 | `scalarPredicate`, `fp32Add_exact`, `naiveSum32_exact`, `scalarCorrected_eq`, `scalarCorrected_correct`; sufficient component conditions below |
| Format-generic scalar consolidation : TC-EFT IV.7–IV.11, Table IV | `binaryAdd_exact`, `naiveSumBinary_exact`, `naiveSumBinary_exact_perm`, `naiveSum64_exact`, `bitSpan_coefficient_bound`, `scalarCorrectedIn_correct`; correction in a well-formed format, direct final rounding to FP32 |
| Eq.20 and arbitrary extraction grids | `extraction_coefficient_bound`, `ExtractionGrid.eq20_exact_sum`, `ExtractionGrid.eq20_scalarPredicate`, `ExtractionGrid.scalarCorrected_correct`; `extractAt` rejects finer grids and `defaultExtraction_scalar` preserves the original API |
| Two-branch reference correction : TC-EFT Algorithm 1, Table V | `BlockTrace.algorithm1`, `algorithm1_correct`, `algorithm1_bits_isSome_iff`, `referenceLedger`; branch choice remains visible |
| Encoded Algorithm 1 interface | `algorithm1Encoded`, `algorithm1Encoded_correct`, `algorithm1Encoded_of_evalBlock`, `algorithm1Encoded_bits_isSome_iff`; original operand encodings, profile, supplied finite FP32 `D`, explicit all-zero shortcut |
| Guarded scalar correction | `tceft_isSome_iff`, `tceft_correct`, `tceft_eq_corrected`; a result exists exactly when the sufficient predicate holds |
| Bounded multiplication and splitting | `EFMachine.multiplySignificands_exact`, `EFMachine.splitMagnitude_reconstruct`, `EFMachine.splitMagnitude_coarse_truncGrid`, `EFMachine.splitMagnitude_low_residual` |
| Complete bounded EFT | `EFMachine.algorithm1_correct`, `algorithm1_range_iff`, `algorithm1_agrees`, `algorithm1_unitInputs_success`; fixed-width execution for all eight paths and any finite supplied `D`, finite-range nearest-even output, reference refinement, and a magnitude-bounded input family |
| Schedules and ordered tail padding | `runBlocks_residual_ledger`, `runBlocks_uncorrected_error`, `fp16Fp32_schedule_machine_eq`, `canonicalPartition_ideal` |
| Independent WMMA matrix connection | `PaperSpec.gemm_eq_paper`, `PaperSpec.gemmBits_eq_paper`, `PaperSpec.gemm_rejected_iff_paper`; unconditional arbitrary-size FP16 WMMA trace/bit/rejection equivalence. `PaperSpec.convertedGemmCheck_paper_sound` adds the explicit scalar/conversion and original-source accuracy contracts from input-only acceptance. |
| Independent complete scaled pipeline | `PaperSpec.scalarRound_eq`, `PaperSpec.scaledGemm_eq_independent`, `PaperSpec.convertedGemm_eq_independent`; all four modes, scalar bits, source conversion, and rejection, without a success/certificate premise |
| Pinned CUTLASS arithmetic projection | `CutlassWmma.output_coordinates`, `CutlassWmma.operand_addresses`, `CutlassWmma.instructions_eq_paper`, `CutlassWmma.project_eq_gemm`; v3.5.1 Sm70 WMMA, K divisible by 16, identity epilogue; explicit source/compiler/hardware trust boundary |
| WMMA matrix simulation | `gemm`, `gemmBits`, `gemmPairs_get`, `gemmInstructions_shape`, `gemm_entry`, `gemm_entry_count`, `gemm_entry_error`; FP16 matrices, FP32 C/output, explicit 16×16×16 instruction tiles |
| Input-derived matrix certificates | `gemmCheck_sound`, `gemmCheck_matrix_error`; successful execution of every entry, uniform entry error and entrywise 1-norm bound, without model execution or exact ideal prefixes in the check |
| Complete scaled-matrix certificates | `scaledGemmCheck_sound`, `scaledGemmCheck_matrix_error`, `convertedGemmCheck_sound`; input-derived acceptance and accuracy through both multiplications, addition, and output conversion, with all four rounding directions |
| Original-source matrix accuracy | `convertedGemmCheck_source_sound`, `convertedGemmSourceCertificate_sound`, `convertedGemmSourceCertificate_matrix_error`; both input-conversion deviations and their cross term, amplified by `abs(alpha)`, with unchanged acceptance |
| Tighter complete GEMM bounds | `scaledGemmCheck_tight_sound`, `convertedGemmTightSourceCertificate_sound`, `convertedGemmTightSourceCertificate_matrix_error`; half-spacing RNE scalar bounds and a minimum of two input-perturbation expansions, with unchanged acceptance |
| Scaled GEMM and conversions | `scaledGemm`, `gemmEpilogue_correct`, `scaledGemm_entry_error`, `convertGemmInput_entry`, `convertGemmWord_correct`; explicit separately rounded scalar stages, all four rounding directions, optional input/output conversions |
| Static input-derived error bounds | `block_static_error_bound`, `runBlocks_static`, `staticCheck_sound`, `Program.staticCertificate_sound` |
| Changing-state schedules and symbolic repetition | `runBlocks_of_scale_bound`, `Program.accurate_of_scales`, `Program.repeat_accurate_of_scales`; scale, count, and initial-magnitude hypotheses |
| Bounded original-input dot product | `boundedDot_run`, `boundedDot_ideal`, `boundedDot_accurate_of_bits`, `boundedDotCheck_sound`; family below |
| Generalized invocation loss accounting | `evalInvocation_spec`, `evalInvocation_recovery`, `runConversions_recovery`; format-specific rounding claims remain separate |
| DSL correctness and diagnostics | `Program.vc_sound`, `runLocated_erases`, `Program.report_accepts_iff` |

The machine refinement covers modular **accumulation**. It does not refine an
entire encoded hardware pipeline. Padding thresholds are sufficient, not minimal;
more padding can also cause range rejection, so no general monotone improvement
claim follows.

For non-monotonicity, the family has `K` equal products of value `2^-(24+p)`, raw
scale at most −1, floor at most −1, and `K < 2^(24+p)`. Lowering `c` from 1 to
`1−2^-24` raises the output exactly when `K ≥ 3·2^p`. For `c = 1−j·2^-24`, the
witnesses are `1 ≤ j ≤ min(2^23, floor(K/2^p)−2)`, with maximum output at `j=1`.
This characterizes that family, not all inputs. Flowback separately proves
`A'acc = Aacc + ω − ΔA`: `ω > ΔA` is necessary for an output increase and is
sufficient when both aligned accumulators are representable.

</details>

### Correction and its implementation boundary

<details>
<summary>Expand reference</summary>

[Algorithm1.lean](tensor-core/TensorCore/Programs/Algorithm1.lean) implements the
paper's two branches on an exact trace. It selects the guarded scalar branch when
its predicate holds; otherwise it forms `D − ε_o + Σ εᵢ` exactly and rounds once.
The result identifies `.scalar`, `.exactReference`, or `.outOfRange`. Every returned
encoding is nearest-even to the exact ideal, and an encoding exists exactly when
the ideal is in the finite FP32 range. `referenceLedger` records the paper's
operation counts; it is not an execution-cost or timing proof.
`scalarBranchOperations K` counts `K+3` rounded operations in successful scalar
consolidation, including the initial residual addition to zero. The paper's `K+2`
count initializes the sum with its first residual. Extraction and guard work are
excluded from this scalar count.

[EncodedEFT.lean](tensor-core/TensorCore/Programs/EncodedEFT.lean) exposes
`algorithm1Encoded x D`, where `x : BlockInput p` supplies the profile and original
operand encodings and `D : F32` supplies the device output. It decodes both,
reconstructs raw products and extraction components, and returns `.allZero` with
bits `+0` when every term, including `c`, is zero. Otherwise it returns
`.consolidated` with the trace algorithm's scalar, exact-reference, or out-of-range
result. Wrong shapes and nonfinite inputs or `D` are rejected.

The encoded procedure agrees with `algorithm1` on the reconstructed trace's bits
and preserves its branch for nonzero inputs. Its correctness theorem connects
returned bits to the independent original-input ideal, and its finite-domain
theorem characterizes when an encoding exists. Recovery works with any supplied
finite `D`; it does not establish that `D` conforms to a hardware model. Executable
dependency checks ensure that correction does not call the model evaluator or the
independent ideal. See the [encoded example](tensor-core/examples/EncodedEFT.lean).

`encodedBlockValue` expresses `val(TC_θ(a,b,c))` with finite-domain rejection.
`monotoneInAccumulator_encoded` transfers decoded-product monotonicity to this
interface, comparing decoded numerical values of both accumulators and accepted
outputs. The encoded V100 counterexample remains a kernel-checked regression.

The separate `scalarCorrected` and `tceft` APIs return `none` when the sufficient
predicate fails. Their predicate requires a common grid `−149 ≤ ℓ ≤ 104`, a sum
of coefficient magnitudes below `2^24`, representability of the relevant
components, and a finite exact component sum. Extraction and the predicate still
use exact `Rat` arithmetic, including reconstruction for the range check.
`scalarCorrectedUnchecked` is diagnostic and can return incorrect bits outside the
predicate; subnormal and broad finite-input counterexamples remain regressions.

The separately named `scalarPredicateIn f` and `scalarCorrectedIn f` generalize
consolidation to any well-formed IEEE-style correction format; use `f = fp64` for
Table IV's precision 53 and minimum grid `2^-1074`. The generic predicate checks
the paper's absolute residual range in place of a fixed grid upper bound. It
retains representability checks for `D`, the overlap, and the retained sum, and
requires the reconstructed ideal to fit FP32. Every accepted baseline FP32 case
also passes the generic FP32 predicate and returns the same bits.

Residual summation and overlap subtraction execute nearest-even operations in
the correction format. The final sum is formed exactly and rounded **directly to
FP32**, as Corollary IV.11 requires. An FP64 rounded addition followed by FP32
conversion can double-round; the
[scalar regressions](tensor-core/TensorCore/Regression/ScalarEFT.lean) exhibit this
on encoded operands. This remains an exact-reference procedure, with no bounded
final-rounding implementation claim. The
[example](tensor-core/examples/ScalarEFT.lean) applies the correction and any-order
summation contracts. `bitSpan_coefficient_bound` proves that the paper's
`b − ℓ + 1 + ⌈log₂ n⌉ ≤ P` condition implies the strict coefficient budget;
minimum-grid and absolute-range conditions remain separate.

**Eq.20 and selectable extraction.**
[ExtractionGrid.lean](tensor-core/TensorCore/Programs/ExtractionGrid.lean) exposes
`t.extractAt b` for any `qE=2^b` with `qE≥qA`, including a grid different from
`max(qA,qD)`. Finer grids are rejected. Signed low-part bounds, retained alignment,
overlap, exact recovery, and guarded scalar correction are proved for every such
grid. `defaultExtraction_scalar` proves exact compatibility with the old generic
predicate and correction; existing default and bounded-EFT behavior is unchanged.

If the original terms (including C) lie on `2^ℓ`, `ℓ≤b`, each low coefficient has
magnitude at most `2^(b−ℓ)−1`. Eq.20's
`n*(2^(b−ℓ)−1) < 2^P` therefore proves the strict coefficient budget, where
`n=K+1` and `P=f.fractionBits+1`. `eq20_exact_sum` gives exact scalar consolidation;
`eq20_scalarPredicate` packages correction acceptance. The minimum scalar grid,
absolute finite range, representable D/overlap/H, and final FP32 range remain
explicit obligations. Eq.20 supplies the precision condition, not an overflow
or complete-guard theorem by itself. Kernel regressions include a nondefault R3
grid, signed coefficients, zero/subnormals, finer-grid rejection, and strict-budget
and range boundaries.

The complete bounded implementation is
[`EFMachine.algorithm1`](tensor-core/TensorCore/Programs/BoundedEFT.lean), with an
explicit `Path` selecting any of the eight FP16/BF16/TF32 → FP32 groups. It accepts
the original encoded operands and a supplied finite `D`. It decodes subnormals,
multiplies 11-bit significands exactly, selects the raw-exponent extraction grid,
extracts signed coarse and low components, computes the signed overlap, checks the
scalar guard, consolidates, and rounds directly to FP32. Its result distinguishes
`.allZero`, `.scalar`, `.boundedExact`, and `.outOfRange`; invalid shapes and
nonfinite encodings have separate errors. TF32 operands use the existing packed
19-bit API.

All arithmetic in this execution path uses bounded `BitVec` words. A signed
576-bit magnitude on the common grid `2^-272` covers every supported finite
product, including products too large for FP32 that later cancel. A ten-bit shift
count preserves the full exponent span. The
[capacity and extraction proofs](tensor-core/TensorCore/Theory/EFMachine/Extraction.lean)
derive every intermediate's capacity from decoded input bounds and at most 17
terms. The exact branch forms `D − ε_o + Σ εᵢ` in this fixed workspace; it does not
use an unbounded rational fallback. The scalar branch uses encoded FP32 additions
and verifies its exact intermediate values, in addition to the sufficient support,
coefficient, representability, and range checks. Its guard is conservative, so its
branch can differ from the rational reference's while the final bits agree.

[`algorithm1_correct` and `algorithm1_range_iff`](tensor-core/TensorCore/Theory/EFMachine/Correctness.lean)
cover every shape-correct finite input on all eight paths and **any finite supplied
`D`**. An output encoding exists exactly when the independently decoded original
ideal satisfies `abs(S) ≤ maxFinite32`. This is a success family derived from input
assumptions, including arbitrary cancellation; it requires no assumed recovery
identity or model conformance. The
[unit-input success theorem](tensor-core/TensorCore/Theory/EFMachine/Success.lean)
requires only that each decoded operand and `c` have magnitude at most one; it
derives `abs(S) ≤ K+1 ≤ 17` and guarantees a correctly rounded encoding, without
assuming an ideal-range bound. The
[refinement](tensor-core/TensorCore/Theory/EFMachine/Refinement.lean) connects the
returned bits to the encoded reference and to conforming model outputs.
[Direct rounding](tensor-core/TensorCore/Theory/EFMachine/Round.lean) proves bit
equality with FP32 nearest-even conversion, including ties, carries, subnormals,
signed nonzero underflow, and the project's finite-range rejection policy.

The implementation follows these mathematical readings of the paper:

- `qE = max(qA, qD)` uses **unnormalized raw exponents**, preserving different
  metadata for numerically equal products. The
  [grid proof](tensor-core/TensorCore/Theory/EFMachine/Grid.lean) makes the biased
  maximum and architectural floors explicit. Saturating below the common workspace
  grid avoids unsigned underflow without changing `qE`, since `qD ≥ −149`.
- With `H = Σ trunc_qE(Tᵢ)`, the overlap is the signed quantity `ε_o = D − H`.
  Thus `S = D − ε_o + Σ(Tᵢ − trunc_qE(Tᵢ))`. When `qE = qA`, the overlap equals
  the **negative output residual**, and need not vanish. Treating overlap as
  unsigned carries, or dropping this residual, breaks the recovery identity.
- The scalar support grid comes from actual nonzero residual bits. The strict
  coefficient budget `< 2^24`, minimum subnormal grid, component representability,
  and final range are separate checks. The extra intermediate checks make scalar
  acceptance sound even when the sufficient guard rejects more cases.
- Final rounding is directly to FP32. Rounding an intermediate sum to FP64 first
  can double-round and does not implement the intended final-rounding corollary.

The [source-level budgets](tensor-core/TensorCore/Theory/EFMachine/Cost.lean) include
a failed scalar attempt followed by exact consolidation. For `N = K+1`:

| Phase | Maximum source-level work | Maximum over the eight paths |
|---|---|---|
| Preparation | `2K+2` decodes, `K` significand multiplies, `N` raw-maximum visits | 34 decodes, 16 multiplies, 17 visits |
| Extraction and signed recovery | `N` splits, `2N+3` checked signed additions/subtractions | 17 splits, 37 additions/subtractions |
| Scalar attempt | `N+2` encoded additions, `N+4` exact-representability checks | 19 additions, 21 checks |
| Guard coefficient sum and support scan | `N` unsigned additions, `N` support searches of at most ten probes each | 17 of each |
| FP32 conversion, including fallback | `2N+7` direct conversions | 41 conversions |

The [optimized support searches](tensor-core/TensorCore/Foundations/EFMachine/BitScan.lean)
replace the linear leading-zero scan and the full-word reversal used by the
standard trailing-zero operation. Each binary search makes at most ten probes;
all shifted/prefix words have width at most 576. The
[kernel-checked equivalence and trace bounds](tensor-core/TensorCore/Theory/EFMachine/BitScan.lean)
cover every 576-bit word, including zero. The scalar guard computes each nonzero
residual's support once. Rounding, guard decisions, extraction, and branch semantics
are preserved. The total source-level budget is at most 580 support probes per
block, including a failed scalar attempt and exact fallback.

These are operation budgets, not timing or compiler-cost proofs. Lean's standard
`BitVec` runtime executes the implementation; a nine-limb storage layout, optimized
overlap extraction, CUDA lowering, and GPU performance are not claimed.
The bounded exact work is performed before scalar selection, so scalar acceptance
does not by itself establish a speed advantage. See the
[public example](tensor-core/examples/BoundedEFT.lean) and run
`python3 scripts/check_bounded_eft.py` inside `tensor-core/`. The gate builds the
native `tc_bounded_eft` executable, checks independent integer-oracle cases, audits
the proofs, and rejects transitive rational/model dependencies and accidental use
of the old scans with negative controls. Kernel regressions check support searches
at all 576 single-bit positions as well as zero and dense words.

`python3 scripts/benchmark_bounded_eft.py` builds two native executables from one
stable source snapshot. Its baseline uses the standard `BitVec.clz/ctz` operations;
the optimized build uses the proved searches. It compares complete diagnostics,
then alternates paired timing runs on the saved paper corpus, broad finite inputs,
and separate scalar, exact-fallback, and out-of-range subsets. Inputs are parsed
before timing; the timed loop consumes every result in a branch-sensitive checksum.
The [benchmark report](tensor-core/data/regressions/bounded-eft-benchmark.json)
records sources, input and binary hashes, the host/toolchain, and individual samples.
These measurements concern local CPU execution only.

The recorded macOS arm64 / Lean 4.33.1 run uses five paired samples, with two
passes through each dataset per sample. Median baseline/optimized ratios are:

| Dataset | Blocks per pass | Native speedup |
| --- | ---: | ---: |
| Saved paper corpus | 2,926 | 13.65× |
| Broad finite inputs with arbitrary finite `D` | 1,024 | 16.29× |
| Scalar branch subset | 290 | 4.42× |
| Exact fallback subset | 2,786 | 15.49× |
| Out-of-range subset | 866 | 17.60× |

Subset rows reuse cases from the first two datasets. Complete diagnostics agree
for all 3,950 blocks; branch counts are unchanged. The original pre-optimization
executable also agrees byte for byte on these blocks and 3,167 rounding cases.
The benchmark is separate from correctness validation and has no speed threshold
in the clean suite.

</details>

### Programs, DSL, and accuracy certificates

<details>
<summary>Expand reference</summary>

`Program p` is a typed AST with `skip`, `block`, `seq`, and `repeat`. `tc%{ }`
elaborates to these ordinary terms, checks literal widths and group sizes, and
records source locations. A typed operand group can be supplied with
`call "label" operands;`. Operands are fixed independently of rounded state.

```lean
import TensorCore.Meta.Syntax
open TensorCore

def threeAdds : Program v100F16F32 := tc%{
  repeat (3) {
    block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}

tc_verify threeAdds_correct : threeAdds from 0
tc_inspect threeAdds from 0
```

`tc_verify` applies `Program.vc_sound` to a `decide +kernel` proof, or a supplied
`using proof`. The resulting `Program.Correct` states successful execution and
correctly rounded **exact-reference correction** of the final result. It does not
prove that the uncorrected result meets an accuracy tolerance or execute a bounded
correction implementation. Intermediate results are never corrected implicitly.

For raw-output accuracy, import `TensorCore.Meta.Certify`. The
[certificate example](tensor-core/examples/Certify.lean) uses:

```lean
tc_certify dot_accurate : dot from 0x3f800000 scale 1 carry 3 within (1 / 2048)
tc_certificate dot from 0x3f800000 scale 1 carry 3 within (1 / 2048)
```

`tc_certify` proves `Program.Accurate`: execution succeeds and the raw output
meets the requested absolute tolerance against the independent ideal.
`tc_certificate` only reports the checks. The concrete checker computes exact ideal
prefixes and an input-derived budget; it does not run blocks or use their residual
ledger. A refused sufficient certificate does not imply incorrect arithmetic.
Failed theorem generation rolls back the declaration. Diagnostics do not establish
proofs, and elaboration never introduces another arithmetic model.

The [bounded-dot application](tensor-core/TensorCore/Applications/BoundedDot.lean)
accepts at most 256 signed FP16 pairs with magnitude words below `0x2c00`
(magnitudes below 1/16), and finite initial FP32 magnitude at most 1. It preserves
operand order, pads only the final group, and proves absolute raw error at most
`2^-11 = 1/2048` against the unpadded ideal. The underlying bound is
`64·21/4194304 = 21/65536`. `boundedDotCheck` checks family membership without exact
prefixes or model execution. Symbolic repetition follows scale/count invariants
with changing rounded state; it does not assume a cycle or exact execution.
The bound is conservative and gives no relative-error guarantee near cancellation.

`runBlocks` passes each returned FP32 encoding to the next group. Pinned
instructions use contiguous increasing-k groups and reject lengths other than
`k`. `tc_instruction` accepts `v100-wmma-k16`, `ampere-wmma-k16`, and
`hopper-wmma-k16`. A zero group passes through finite `c` other than −0; it turns
−0 into +0. The DSL currently has no matrix indexing, state-dependent operands,
scalar boundary operations, or automatic invariant synthesis.

</details>

### WMMA GEMM simulation

<details>
<summary>Expand reference</summary>

[Gemm.lean](tensor-core/TensorCore/Programs/Gemm.lean) simulates **`A*B+C`** with
encoded FP16 `A : m×k`, FP16 `B : k×n`, and FP32 `C : m×n`. `DenseMatrix` uses
dimension-indexed row-major vectors. Choose `.v100`, `.ampere`, or `.hopper` to use
the existing Accurate Models arithmetic profiles through their WMMA descriptors.

The public instruction contract is
`wmma.mma.sync.aligned.row.col.m16n16k16.f32.f32`: implicit FP16 multiplicands and
FP32 accumulators/results. The [PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html)
specifies the tile interface; Accurate Models supplies the arithmetic that PTX
leaves unspecified. This is logical matrix-level instruction simulation, without
lane/register allocation, CUDA memory/synchronization refinement, or a compiled
kernel correspondence claim.

The simulator executes 16×16 output tiles, initializes each with `C`, and processes
k tiles in increasing order. Loads beyond matrix bounds supply +0; the final k
tile contains 16 pairs even when partly padded. Every internal normalization group
and every instruction boundary carries the previous encoded FP32 output. V100,
Ampere, and Hopper have respectively four, two, and one groups per instruction.
Completed output tiles are cropped to `m×n`. `gemm` retains per-entry traces or
finite-domain errors; `gemmBits` projects the output words. With `k=0`, no instruction
runs and finite `C` is preserved, including negative zero.

`gemmPairs_get` proves the operand-index mapping, `gemmInstructions_shape` proves
that each instruction receives 16 pairs, and `gemm_entry` connects cropped tile
execution to the original row/column chain. `gemm_entry_count` proves each successful
entry executes `ceil(k/16)` instructions. `gemm_entry_error` lifts the existing
composed error bound to the independent, unpadded matrix ideal. This theorem uses
a successful execution trace. The input-derived certificate below additionally
proves execution succeeds. The simulator applies no EFT correction.

Run from `tensor-core/`:

```sh
lake build
lake env lean --run examples/Gemm.lean
python3 scripts/check_gemm.py
```

The [example](tensor-core/examples/Gemm.lean) computes the rectangular result
`[[16,57,-12],[-11,-50,21]]` and a two-instruction example whose architecture
results differ. An optional JSONL path supplies arbitrary dimensions: each object
contains `model`, `m`, `n`, `k`, and flat row-major decimal encoding arrays `a`, `b`,
`c`. Shape and word-width errors are rejected. The
[GEMM report](tensor-core/data/regressions/gemm-report.json) records independent
checks of output bits, original-input ideals, every encoded boundary, and error
bounds, including partial/multiple tiles, empty dimensions, and nonfinite inputs.

**Input-derived certificates.** [GemmBounds.lean](tensor-core/TensorCore/Programs/GemmBounds.lean)
adds `gemmCheck` for all three profiles and arbitrary matrix dimensions.
`GemmBoundConfig` supplies an accumulator scale bound, a raw-product scale bound,
carry headroom, and an initial-accumulator magnitude bound. The checker decodes
operands, checks their scales, and checks that the instruction count and error
budget leave enough accumulator headroom. It evaluates no tensor-core operations,
exact dot products, or ideal prefixes; a transitive executable-dependency test
enforces this separation and rejects a deliberately contaminated checker.

If the check passes, `gemmCheck_sound` guarantees every logical output exists and
its error is at most `gemmStaticError model cfg k`. A failed check is inconclusive:
the sufficient bounds may be too conservative. `gemmCheck_matrix_error` bounds
the sum of absolute errors by `m*n*gemmStaticError model cfg k`; this is the
entrywise 1-norm, not the induced column norm. These input-only acceptance
certificates cover the raw `A*B+C` schedule, including `C=0` for a product stage.

**General scalar scaling.** [ScaledGemm.lean](tensor-core/TensorCore/Programs/ScaledGemm.lean)
adds `scaledGemm` and `scaledGemmBits` with encoded FP32 `alpha`, `beta`, and `C`:

```text
P = tensor-core GEMM(A, B, initial accumulator +0)
U = round_fp32(alpha * P)
V = round_fp32(beta * C)
S = round_fp32(U + V)
D = convert_output(S)
```

The two multiplications and the addition are separate operations; no FMA
contraction is implicit. `GemmEpilogue` selects multiplication, addition, and
output-conversion rounding modes. Each supports nearest-even, toward-zero,
toward-negative, and toward-positive. `gemmEpilogue_correct` proves the four
executed stages satisfy their mathematical rounding relations.
`scaledGemm_entry_error` bounds error against the independently decoded
`alpha*A*B + beta*C` ideal: tensor-core error is multiplied by `abs(alpha)`, and
the scalar/output conversion losses are added. This bound uses the execution
trace; the complete input-only certificate described next avoids that premise.
The original `C`-initialized `gemm` API remains available. A regression proves that
it can differ from `scaledGemm` even when `alpha=beta=1`.

`nativeScaledGemm` uses the same scalar epilogue with BF16 or TF32 products.
`nativeConvertedGemm` first converts source matrices to that native precision.
[NativeConvertedAnalysis.lean](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean)
provides input-only certificates for this complete pipeline, including source
conversion and a matrix bound formed from the individual entry bounds.

**Certificates for the complete scaled pipeline.**
[ScaledGemmBounds.lean](tensor-core/TensorCore/Programs/ScaledGemmBounds.lean)
adds `scaledGemmCheck`. Alongside the raw tensor-core configuration,
`ScaledGemmBoundConfig` gives magnitude scales for `alpha*P`, `beta*C`, the scalar
sum, and the output conversion. The checker proves these stages have sufficient
range by propagating upper bounds; it does not execute them. The format-generic
`gemmConversion_bounded` theorem guarantees conversion succeeds and bounds its
error by one grid spacing at the supplied scale, in all four rounding modes and
including subnormal values.

`scaledGemmCheck_sound` guarantees every output entry of the complete scaled
pipeline exists and meets `scaledGemmStaticError`. That bound is
`abs(alpha)*raw_bound` plus the four input-derived scalar/conversion bounds.
`scaledGemmCheck_matrix_error` lifts it to the entrywise 1-norm. The dependency
audit checks both raw and scaled certificates and a deliberately contaminated
negative control. Tight or invalid caps are rejected separately in regressions;
rejection remains inconclusive rather than proving the actual execution fails.

`convertGemmInput` explicitly converts a source-format matrix to FP16, and
`convertedGemm` composes input conversion with `scaledGemm`. Each accepted input
conversion has a proved rounding contract. `convertedGemmCheck` checks conversion
success and then certifies the complete scaled pipeline; its soundness theorem
connects this check to `convertedGemm`. Input conversion itself can execute during
this check, but the tensor-core and epilogue computations cannot. Output conversion
uses a separate `ConversionStage`; the executable example exposes FP16, BF16, FP32, and FP64
source/output formats. Scalar operations retain the project's **finite-value
conversion policy**: exact zero becomes +0, and an exact intermediate outside the
destination's finite range is rejected. This is not a claim of complete IEEE
exception/zero-sign behavior. Zero `alpha` or `beta` does not bypass operand
validation or the corresponding computation. Input-conversion failure rejects
the matrix; scalar/model failure is `none` at the affected output entry.

**Error against the original source matrices.**
[GemmInputBounds.lean](tensor-core/TensorCore/Programs/GemmInputBounds.lean) adds
`sourceGemmIdeal`, which decodes the original source-format words and computes
`alpha*A*B + beta*C` without input conversion or simulated arithmetic. For each
original pair `a,b` and its converted FP16 values `a',b'`, set
`da = abs(a-a')` and `db = abs(b-b')`. The per-entry bound is

```text
source_bound(i,j) = scaledGemmStaticError
  + abs(alpha) * sum_l (abs(A[i,l])*db + abs(B[l,j])*da + da*db)
```

The sum covers the original `k` operands, before padding. It includes both operand
deviations and their cross term; exact input conversions contribute zero.
`gemmInputDatum_error_le` also bounds each deviation by the existing generic
grid-spacing result when a magnitude cap is supplied. The reference begins at the
decoded source words; any earlier real-to-source encoding loss is outside this bound.

`convertedGemmCheck_source_sound` proves successful outputs and this source-relative
bound from the existing check alone. `convertedGemmSourceCertificate` returns the
varying entry budgets with **exactly the same acceptance** as `convertedGemmCheck`;
its soundness and matrix-error theorems give entrywise and entrywise 1-norm bounds.
These results cover arbitrary dimensions and source formats, all four input modes,
and all three existing WMMA profiles and scalar/output contracts. Empty dimensions,
finite rejection, and zero conventions are preserved. The certificate computes
only input decoding/conversion deviations and existing scale budgets; a transitive
dependency audit excludes tensor-core execution, the epilogue, and exact dot-product
ideals, including a hidden-wrapper negative control.

**Tighter bounds with the same acceptance.**
[GemmRoundingBudget.lean](tensor-core/TensorCore/Programs/GemmRoundingBudget.lean)
proves half a spacing for nearest-even stages, including subnormals, and retains
one spacing for directed modes. [GemmTightBounds.lean](tensor-core/TensorCore/Programs/GemmTightBounds.lean)
carries these budgets through the complete epilogue. The raw tensor-core budget
and sufficient range checks remain unchanged; only the proved error budget shrinks.
[GemmTightInputBounds.lean](tensor-core/TensorCore/Programs/GemmTightInputBounds.lean)
uses the smaller of two exact product-difference expansions:

```text
input_pair_bound = min(abs(a)*db + abs(b')*da,
                       abs(a')*db + abs(b)*da)
```

This bound never exceeds the old cross-term bound. The converted magnitudes
retain the effect of both upward errors, including subnormal inputs.
`convertedGemmTightSourceCertificate` gives source-relative entry and entrywise
1-norm guarantees with exactly the old acceptance and finite/zero conventions.
The reviewer source case improves from `14471/8388608` to `28037/16777216`;
its four nearest-even scalar budgets halve. The CLI preserves the old fields and
adds `tight_entry_bound`, `tight_matrix_bound`, `tight_source_entry_bounds`, and
`tight_source_matrix_bound`. Source certificates are null when the check rejects;
input-conversion failure retains the rejection-only response. Bounds remain
sufficient and conservative. The separate [automatic analysis](#automatic-gemm-analysis)
supplies finer group budgets through the complete source-conversion and scaled
pipeline. Induced matrix norms remain an extension.

Run the certificate and scaled example, or its independent checker:

```sh
lake env lean --run examples/GemmExtensions.lean
python3 scripts/check_gemm_extensions.py
```

The example also accepts a JSONL path. All three operations use `model`, `m`, `n`, `k`
and flat encoding arrays `a`, `b`, `c`. `operation: "certify"` additionally takes
`accumulator_scale`, `product_scale`, `carry_bits`, and integer `initial_bound`
(the Lean API accepts a rational bound). `operation: "scaled"` takes FP32 words
`alpha`, `beta`, format names `input_format`/`output_format`, and rounding names
`input_mode`, `multiply_mode`, `add_mode`, `output_mode` (`rne`, `rtz`, `rdn`, `rup`).
`operation: "certify_scaled"` combines those fields with the raw certificate
fields and integer `alpha_scale`, `beta_scale`, `sum_scale`, and `output_scale`.
It checks input conversion and reports acceptance and bounds without running GEMM.
The existing `entry_bound` and `matrix_bound` refer to the converted FP16 operands;
`source_entry_bounds` and `source_matrix_bound` include input-conversion loss against
the original source words. They are null when scale checking rejects; failed input
conversion retains the rejection-only response. The `scaled` diagnostic
similarly retains its converted-input `ideal` and adds `source_ideal` and
`input_product_bound` for comparison.
The [extension report](tensor-core/data/regressions/gemm-extensions-report.json)
records stage-by-stage Fraction comparisons, certificate acceptance/rejection,
source-relative matrix error checks, parser and mutation controls, and the dependency
audit. [Kernel regressions](tensor-core/TensorCore/Regression/GemmInputConversion.lean)
include an actual error larger than the old post-conversion budget, a subnormal
case requiring the cross term, directed negative inputs, exact conversions, signed
zero, empty dimensions, negative/zero alpha, and finite-range/nonfinite rejection.

These components support further GEMMs, but every new instruction path, reduction
order, or epilogue still needs an explicit contract. EFT correction and
compiled-kernel correspondence remain separate extensions.

External validation can also be strengthened independently. Published GPU outputs
are observations independent of our implementation; the existing FP16 archive
checks cover source-defined instruction groups rather than this entire GEMM.
[MMA-Sim](https://github.com/microsoft/MMA-Sim) is a candidate third-party arithmetic
comparison, pending an instruction/schedule compatibility review. It is not yet
integrated and does not replace Accurate Models as the specification. No new
full-GEMM GPU measurements have been made.

</details>

### Pinned CUTLASS connection

<details>
<summary>Expand reference</summary>

The selected configuration is CUTLASS **v3.5.1**, revision
[`f7b19de32c5d1f3cedfc735c2849f12b537522ee`](https://github.com/NVIDIA/cutlass/tree/f7b19de32c5d1f3cedfc735c2849f12b537522ee).
The [C++ fixture](tensor-core/kernels/cutlass/wmma_sm70.cu) instantiates FP16
row-major A, FP16 column-major B, FP32 accumulation/output, Sm70 WMMA, 64×64×16
CTAs, four 32×32×16 warps (each with four independent WMMA fragments), one pipeline stage, no split-K, and
`ScaleType::Nothing` (identity epilogue, no C/alpha/beta arithmetic). The
[pin and source map](tensor-core/kernels/cutlass/pin.json) record configuration,
source anchors, hashes, license, and assumptions. Selected unchanged headers are
kept under `kernels/cutlass/upstream/` for offline review; they are not a full
CUTLASS installation.

[CutlassWmma.lean](tensor-core/TensorCore/Kernels/CutlassWmma.lean) proves the
reviewed source arithmetic projection equals the zero-C V100 GEMM model, including
CTA/warp output coordinates, row/column addresses, ordered K tiles, and all encoded
WMMA boundaries. `project_check_sound` transfers the existing input-only raw GEMM
accuracy certificate to this projection. M/N edges are cropped to the logical output dimensions. The
connection requires **positive K divisible by 16**: the pinned iterator processes
a partial K tile first, unlike the simulator's last-tile padding. A kernel-checked
K=17 witness gives `2^-24` versus zero, so this restriction is numerically material.
The mathematical projection also defines empty dimensions, but the CUDA launcher
rejects nonpositive dimensions.

The trusted correspondence step is the reviewed C++-to-Lean arithmetic transcription.
Memory safety, shared-memory/lane transport, compiler lowering, PTX/SASS, and physical
WMMA conformance are not proved. Valid allocations, matching strides, and bounded
C++ address arithmetic are external preconditions. The numerical primitive uses
the finite-domain V100 paper model; rejected exceptional hardware behavior is
outside the connection. This configuration does not implement the project's
separately rounded general scalar epilogue.

```sh
# Offline pin, proof regression, and 4,355-word independent rational comparison:
python3 scripts/check_cutlass.py

# Optional, on a V100 with an nvcc supporting sm_70 and a clean full checkout
# at the exact revision above. Builds with -std=c++17 -arch=sm_70 and compares:
python3 scripts/check_cutlass.py --cutlass-root /path/to/pinned/cutlass

# Or compare an already captured C++ fixture JSON:
python3 scripts/check_cutlass.py --hardware-json /path/to/hardware.json
```

The [report](tensor-core/data/regressions/cutlass-report.json) distinguishes source
checks, optional compilation, and device execution. This workspace has no `nvcc`;
CUDA compilation and V100 execution remain unvalidated. Compiler/device logs and
fixture outputs go under ignored `tmp/cutlass/`. A measured fixture match would
still be finite testing, not a universal GPU theorem.

</details>

### Paper claim review

<details>
<summary>Expand reference</summary>

The historical agent-assisted source review was begun 6 September and updated
7 September 2026 against the two pinned PDFs in
[Source pins and layout](#source-pins-and-layout), externally obtained manuscripts and figures,
the vendored MATLAB definitions, and the Lean statements below. This reviews
mathematical scope and transcription; it is not author sign-off, a novelty review,
or independent physical validation. No arithmetic behavior was changed to resolve
a paper ambiguity. The claim map is maintained here; the
[review record](tensor-core/data/regressions/claim-review.json) pins the reviewed
sources and records declaration checks at that time. Its hashes describe that
snapshot, not subsequent native-GEMM and decision-tool additions. The current
[artifact checklist](#main-claims-to-review) and clean-suite report cover those
additions. This final artifact check does not repeat the external manuscript review.

**Supported artifact claim:** finite-domain formalization of the selected
FP16/BF16/TF32-to-FP32 tensor-core paths; their stated error, flowback, recovery,
and guarded correction contracts; bounded EFT refinement; and arbitrary-size
matrices under the explicit FP16 WMMA/scalar schedule, with original-source error
certificates. Native BF16/TF32 GEMM has five raw and complete scaled schedules
with original-source conversion bounds. Independent-specification equivalence covers the eight block paths,
ordered group lists, three raw FP16 WMMA matrix profiles, five native matrix
schedules, and the complete FP16/BF16/TF32 scalar/input-conversion pipelines. Automatic
analysis, uniform and per-entry families, and preference/minimum-supplied-cost
selection expose kernel-replayable accuracy certificates. Eq.20 and all permitted
extraction grids are exposed. One pinned CUTLASS arithmetic projection is connected
with the explicit trust boundary above. Neither paper is claimed fully formalized.

| TC-EFT location | Lean correspondence and review conclusion |
| --- | --- |
| Definitions II.1–II.2, pp.2–3 | `signedFiniteBinaryBijection`, `roundBinary_correct`, `round32_nearestEven_correct`. Finite normals/subnormals and explicit zero sign; all four modes extend the paper's nearest-even definition. Exceptions and IEEE overflow behavior are excluded. |
| §II-B; Tables I–II, pp.3–4 | `rawProduct_value`, `accumulator_value`, `profile_contract`, `fp16Fp32_machine_eq`. Raw subnormal scales, nonzero exponent selection, floors, signed magnitude truncation, and separate final conversion agree with the stated model. No per-product FP32 range requirement; modular refinement needs the stated width/carry budget. |
| Theorem III.1, p.4 | `block_error_bound`, `evalBlock_error_bound`: strict `n*qA + qD`, including the output loss. The pre-conversion aligned sum must be in range; the theorem is not an overflow result. |
| Definition III.2, p.5 | `MonotoneInAccumulator`, `MonotoneInEncodedAccumulator`, `monotoneInAccumulator_encoded`. Numerical order of finite decoded accumulators and accepted outputs, with fixed multiplicands. No monotonicity assertion for all tensor-core profiles. |
| Definition III.3 and Eq.6, p.5 | `perturbed_accumulator`, `output_condition`, `flowback_necessary`, `flowback_sufficient`. Signed flowback minus accumulator loss; the encoded-output criterion is separate from the representable-accumulator sufficient condition. |
| Theorem III.4; Table III, p.5 | `nonmonotone_perturbation`, `nonmonotone_encoded`. The repeated tiny-product family, floor at most −1, realizable factors, and `K < 2^(24+p)` are explicit hypotheses. The `K >= 3*2^p` threshold concerns this family. |
| Theorem III.5, pp.5–6 | `nonmonotone_range_encoded`. Covers `1 <= j <= 2^23`, the exact perturbation interval and output formula, and the maximum increase within that family. It does not prove a universal immunity threshold from extra padding. |
| Lemma IV.1; Eq.11, p.6 | `lowPart_bound`, `retained_add_low`, `ExtractionGrid.lowPart_bound`, `ExtractionGrid.retained_add_low`. Signed components and reconstruction for every permitted coarse power-of-two grid; the default `max(qA,qD)` API is preserved by exact compatibility theorems. |
| Lemma IV.2, p.6 | `overlap_window_width`. The nonnegative exponent difference between extraction and alignment grids, including zero/subnormal output branches; a nonzero selected alignment exponent is an explicit premise. |
| Lemma IV.3, pp.6–7 | `truncGrid_split`, `accumulator_eq_retained`. Per-term signed splitting and the summed retained identity; signed truncation is not distributed through a mixed-sign sum. The splitting lemma allows arbitrary nested power-of-two grids. |
| Lemma IV.4, p.7 | `overlap_eq_retained_sub_outputResidual`. The overlap is signed `D-H=V-r_out`, not an unsigned carry, and need not be a scalar representable value. |
| Theorem IV.5; Eqs.16–17, p.7 | `overlap_recovery`, `evalBlock_residual_identity`. Exact recovery of the original dot; includes arbitrary signs, subnormals, and exact intermediate products beyond FP32 range. The raw-scale counterexample is retained. |
| Definition IV.6, p.7 | `naiveSumBinary`. The executable sum starts at zero, adding one exact initial step for finite representable inputs. Its scalar operation count is therefore one larger than the paper's first-term initialization. |
| Lemma IV.7, p.7 | `binaryAdd_exact`, `fp32Add_exact`. Representable exact sums are fixed by rounding. The low-level rational API has no encoded-operand premise; the guarded scalar pipeline separately checks operand representability. |
| Theorem IV.8; Eq.18, pp.7–8 | `naiveSumBinary_exact`, `naiveSumBinary_exact_perm`, `bitSpan_coefficient_bound`. Minimum grid, absolute coefficient sum below `2^P`, and a separate finite magnitude budget; every input ordering and the bit-span sufficient condition are covered. |
| Theorem IV.9; Eqs.19–20, p.8 | `scalarPredicateIn`, `scalarCorrectedInUnchecked_eq`, `extraction_coefficient_bound`, `ExtractionGrid.eq20_exact_sum`, `ExtractionGrid.eq20_scalarPredicate`. Eq.20 derives the precision budget from the original-term grid, chosen extraction grid, and count including C. Minimum grid, finite range and component representability remain explicit. The default guard can conservatively reject cases the generator accepts. |
| Lemma IV.10, p.8 | `scalarOverlap_exact`; `scalarPredicateIn` checks representability of `D`, overlap, and `H`. The rational addition lemma alone must not be read as a hardware subtraction without representable operands. |
| Corollary IV.11; Table IV, p.8 | `scalarCorrectedIn_correct`, `naiveSum64_exact`. Correction format and FP32 target remain separate. Final rounding is directly to FP32 from the exact recovered sum; a rounded FP64 addition followed by FP32 conversion is not substituted. |
| Algorithm 1, p.12; Table V, p.9 | `algorithm1Encoded_correct`, `algorithm1Encoded_bits_isSome_iff`, `referenceLedger`. Original encodings, finite supplied D, exact all-zero shortcut, guarded scalar branch and exact fallback are covered. Guard branch equality with the Python generator is not claimed; source-level ledgers are not measured GPU cost. |
| §V evaluation and §§VII–VIII outlook | Saved §V-B generators are replayed and bounded EFT has its own integer oracle/refinement. The historical §V-D 100-case GPU vectors are unavailable. Proposed GPU primitives, speedups, and globally corrected GEMM remain outside the proved artifact. |

The independent [Definition.lean](tensor-core/TensorCore/PaperSpec/Definition.lean)
was reviewed stage by stage against Accurate Models §4.1: subnormals retain their
minimum-normal raw scale; multiplication adds raw scales without normalization;
zero terms cannot select the exponent; floors apply before common-grid magnitude
truncation; C participates in the group; final FP32 truncation is characterized by
finite-value ordering and sign. The finite rejection policy and exact-zero +0 rule
are explicit scope conventions, not inferred from unspecified exceptional GPU
behavior. The independently transcribed [profiles](tensor-core/TensorCore/PaperSpec/Profiles.lean)
and [matrix schedule](tensor-core/TensorCore/PaperSpec/Matrix.lean) were checked as follows.

| Accurate Models v4 location | Coverage and exclusions |
| --- | --- |
| §4.1.1 / Fig.2, pp.7–8 | V100 FP16→FP32: K=4, F=23; raw-product factorization witness and in-group C covered. FP16-output arrows admit the unresolved stage-order discrepancy below. |
| §4.1.2 / Fig.3, pp.8–10 | Ampere FP16/BF16 K=8 and packed TF32 K=4, F=24, floor −132: independent equivalence. FP64 has four-direction scalar fused correctness, but no independent FP64 group/matrix equivalence theorem. |
| §§4.1.3–4.1.5, p.10 | A2/A30 and L40S/Ada low-precision aliases share the stated Ampere arithmetic. Architecture aliases are paper assertions, not new device measurements by this artifact. Native FP8 has the separate unresolved normalized-precision question. |
| §4.1.6 / Fig.5a–b, pp.10–13 | Hopper FP16/BF16 K=16, TF32 WMMA K=4 versus MMA K=8, F=25, floor −133: independent block equivalence. The prose's “26-bit” sentence is read with the immediately explicit `(2,23,2)=27` alignment description; F counts fraction bits, excluding sign/integer positions. |
| Fig.4 and Fig.5c–d, pp.11–13 | L40S/Ada native FP8 candidates have arithmetic/replay results but no paper-conformance theorem. Hopper native FP8 and interleaved FP8 emulation with late nearest-even C are unimplemented paths. |
| §§4.1.7–4.1.8; Table 3, pp.12–14 | Selected Blackwell FP16/BF16/TF32 arithmetic aliases are represented. Native FP8 K=32/F=25 and its FP16 outputs remain uncovered; the source's FP16-output wrapper discrepancy is unresolved. |
| Table 4, p.15; ordered figures | The three FP16 m16n16k16 logical WMMA matrix schedules and every encoded group boundary now agree with the independently specified row/column reduction. Tail zero-padding and output cropping are explicit project choices. No lane/register placement, emitted SASS, full MATLAB GEMM, or vendor-library kernel theorem. |
| §§2–3, §4.2–4.4, §5 | Discovery/test-generation algorithms, empirical mismatch tables, and multi-word application experiments are contextual/evaluation claims. Existing archived subsets are replayed; the full experimental ensembles, discovery procedures, and downstream algorithms are not claimed reproduced or formalized. |

The unresolved FP16/FP8 readings have concrete separating evidence in
[Detailed remaining paper coverage](#assessment-and-todo). Their authoritative
resolution remains open. Eq.20 and the alternative extraction-grid API are now
proved extensions of the unchanged core correction theorem. The separate scalar
and CUTLASS specifications have been reviewed against their stated project/source
contracts; they do not resolve the FP16/FP8 paper ambiguities.

</details>

### Validation gate index

<details>
<summary>Expand reference</summary>

| Check, under `tensor-core/` | Evidence |
| --- | --- |
| `lake build` | Generic proofs and concrete regression theorems checked by Lean |
| `scripts/check_axioms.py` | Rebuilds the imported library, enumerates every compiled theorem in the namespace, including generated declarations, verifies the standard-axiom allowlist, and scans source for proof shortcuts; the clean suite also checks stale-cache rejection |
| `scripts/validate.py` | Independent exact Python oracle for V100 blocks and FP32 rounding |
| `scripts/check_features.py` | Independent oracle across product counts, alignment bits, floors, and published FP16 vectors |
| `scripts/check_dot_products.py` | Ordered long dots, partial tails, encoded boundaries, and error budgets |
| `scripts/check_device.py`, `scripts/check_device_formats.py` | Published V100/A100/H100 FP16 and A100/H100 BF16/TF32 vector replay |
| `scripts/check_device_fp8.py` | Hashed L40S E4M3/E5M2 rows, both final-precision readings, exact independent oracle, reversed groups, exhaustive FP8 decoding, and rejection checks |
| `scripts/check_device_half.py` | All 5,000 published V100 FP16-output rows match both candidate stage orders; the rows do not distinguish them |
| `scripts/check_paper_spec.py` | Universal block/ordered-group/WMMA-matrix independent equivalence, dependency and proof-axiom audits, semantic witnesses, and transitive arithmetic/matrix/scalar dependency rejection controls |
| `scripts/check_programs.py`, `scripts/check_certificates.py` | DSL order, rejected inputs/proofs, rollback, supplied proofs, and executable dependency checks |
| `scripts/check_application.py` | Bounded-dot family, boundary cases, independent ideal, accuracy, and certificate cost |
| `scripts/check_gemm.py` | WMMA matrix indexing, tile padding, every encoded boundary, independent matrix ideal, per-entry error bounds, and parser rejection checks |
| `scripts/check_gemm_extensions.py` | Raw, scaled, and original-source matrix certificates and dependency audit; all four rounding directions, every encoded stage, both original and tighter scalar/input-conversion budgets, alpha amplification, source matrix bounds, and rejection/mutation controls |
| `scripts/check_analysis.py` | Automatic raw input-only inference, sufficient completeness domain, independent error oracle, certificate export/replay, and tampering controls |
| `scripts/check_pipeline_analysis.py` | Source-relative scaled analysis and quantified uniform families, input-only dependency audits, independent oracles, and kernel replay |
| `scripts/check_selection.py` | Fixed-workload preference decisions, tolerance sweeps, rejection cases, conservative refusals, and certificate replay/mutations |
| `scripts/check_decision_extensions.py` | Five native schedules, tightened exact scalar stages, per-entry families, minimum supplied cost, oracle comparison, boundary and tampering controls |
| `scripts/check_native_scaled.py` | Five scaled schedules, all input/multiply/add mode combinations, original-source error and every encoded stage, source formats including packed TF32, rejection boundaries, raw/scaled separation, input-only dependency audit, and kernel replay/tampering controls |
| `scripts/check_review_claims.py` | Current C01–C16 declaration/source links, README file links, and explicit kernel-checked nonvacuity witnesses; no automatic semantic or novelty sign-off |
| `scripts/check_eft.py` | Seeded scalar acceptance/rejection coverage, accepted-correction comparisons, bounded primitives, and synthetic hardware replay |
| `scripts/check_paper_eft.py` | Pinned TC-EFT §V-B generators, original named cases and seeds, encoded Algorithm 1, synthetic perturbations, rounding boundaries, excluded draws, and executable dependency checks |
| `scripts/check_bounded_eft.py` | Complete fixed-width EFT, all eight paths, saved paper blocks and arbitrary finite supplied outputs, independent integer rounding oracle, compiled dependency audit, proof audit, and rejection controls |
| `scripts/check_cutlass.py` | Hashes 18 pinned source files, checks the source projection and partial-K witness, compares a 4,355-word fixture with an independent rational oracle; optional explicitly separate CUDA/V100 run |
| `scripts/check_tool.py` | Public CLI, JSONL protocol, stdin/file parity, legacy compatibility, schema export, and parser rejection controls |
| `scripts/check_reviewer.py` | Ten editable walkthrough cases with fixed expected answers and independent Fraction checks |
| `scripts/check_clean_build.py` | Complete suite and every standalone example without a build cache; hashes source before/after copying and validation, refusing report publication if source changed |

</details>

### Remaining paper coverage

<details>
<summary>Expand reference</summary>

**Detailed remaining paper coverage.**

**Accurate Models Table 3.** Proved families: FP16, BF16, and TF32 to FP32, matched to the
published vectors. Remaining rows:

| Path | Remaining obligation |
| --- | --- |
| FP16 output | Both candidate stage orders are correctly rounded at the final stage and match all 5,000 published rows; `Regression.half_output_stage_order` separates them (`4001` versus `4000`). The reference source rounds once, directly to FP16; the paper's figure shows an FP32 truncation first. Decide which reading is the formal path and record it. |
| Native FP8, L40S and Ada | FP32 candidate descriptors, archive replay, ordered-group proofs, and distinguishing kernel regressions are complete. The v4/v0.5 review below cannot establish the extra normalized 13-fraction-bit truncation from the paper; authoritative clarification remains necessary. Neither candidate has a paper-conformance theorem. FP16 output remains to be modeled. |
| Native FP8, H100 and H200 | Warpgroup path: `K = 32`, `F = 13`, `c = 0` in the published rows, FP32 and FP16 outputs. Add descriptors, hashed vectors, replay, and kernel regressions; check final precision explicitly. |
| Native FP8, B200 and RTX PRO | `K = 32`, `F = 25` (`neab = 2`), FP32 and FP16 outputs. Add descriptors, hashed vectors, replay, and kernel regressions. The v0.5 wrapper forces FP32 before testing for FP16 output; the paper lists FP16 output, and the archive has `d_B200_fp16.txt`. |
| Emulated FP8 through the FP16 cores (Fig. 5c) | Interleaved groups and late nearest-even addition of `c`. Model the late-`c` boundary explicitly and the interleaved grouping; no published rows exist for this path. |

**L40S/Ada FP8 precision review (v4 / v0.5).** The unresolved claim is:
*after each 16-product group, must the normalized aligned sum be truncated toward
zero to 13 fraction bits (14 significant bits) before FP32 encoding?* The paper
supports the shared alignment width, but its text, figure, table, and stated probes
do not establish this additional reduction. Keep both explicit candidates and their
finite-domain/zero conventions; changing `paper` to `source13` would assume the
claim being investigated.

The supporting paper locations are §2, pp.5–6 (definition of `neab` as alignment/guard
bits); §4.1.4, p.10 (13-fraction-bit accumulation and the two numerical probes);
§4.1.5, p.10 (Ada equivalence); Figure 4, p.11 (`(2,13,0)` alignment, a 20-bit sum,
and FP32 Norm/Trunc); and Table 3 with its note, p.14 (FP32 output and truncation).
The table explicitly includes carry bits in the accumulator width: `20 = 2+13+5`
is the unnormalized sum width, not a normalized 13-bit fraction contract. An FP32
output label can describe storage of a narrower result, so it does not by itself
rule source13 out; neither does it specify that narrower result.

The pinned [AdaTC.m](tensor-core/vendor/matlab-tensor-core-v0.5/models/AdaTC.m)
sets final `rz`, in-group `c`, denormalized products and floor −132 at lines 55–73,
and `fma=16`, `neab=-10` at 105–107.
[GEMM.m](tensor-core/vendor/matlab-tensor-core-v0.5/models/tools/GEMM.m),
80–96, first selects 23 output fraction bits for FP32, then changes
`NoManBitsOut` to `23-10=13`. In
[Generic_BFMA_TC.m](tensor-core/vendor/matlab-tensor-core-v0.5/models/tools/Generic_BFMA_TC.m),
478–489 and 570–589 align/sum and normalize; 266–293 skip `ieeeround` for `rz`
and slice **the normalized mantissa** to `NoManBitsOut` fraction bits. Thus the
reduction is real, even though no rounding helper is called. `GEMM.m` 233–242
applies it on every group and feeds the resulting value into the next `c`.
MATLAB has been read, not executed; `source13` models these arithmetic stages
under our finite-domain policy, not every MATLAB exceptional-value behavior.

The precise disagreement is between two grids. Alignment truncates on
`qA=2^(eta-13)`. For a normal nonzero sum with exponent `e`, source13 subsequently
truncates on `qN=2^(e-13)`. Carries can make `e>eta`, discarding bits alignment kept.
For `c=0`, products `1,1,2^-13` give `eta=0` and exact accumulated value
`2+2^-13`; FP32 retains `0x40000200`, whereas source13 returns `0x40000000`.
The new kernel proofs check this loss and its negative counterpart in both formats.
The paper's reported probe `1+2^-13+2^-13 = 1+2^-12` has no such carry, and its
`c=1`, two `2^-14` products lose their bits during alignment: both readings agree.
The first probe's prose also prints the inconsistent stopping expression
`1+p1+p2` with `p1=1`; the regressions check its explicit numerical endpoint without
silently repairing that expression. Moving our carry witness to the first group
produces distinct intermediate words but identical final words after a zero group.
Thus final archive agreement cannot identify every intermediate boundary.

The replay favors source13 on these published rows but cannot supply a missing
paper rule. Resolution requires an authoritative statement of the normalized
precision, its placement, and the associated finite-range/zero policy; FP16 output
needs its own stage-order decision. The current rounding and recovery proofs are
about the named definitions, not a proof that either reading fully formalizes the
paper or conforms to a physical GPU. No arithmetic implementation was changed by
this review.

Source questions still to settle from the paper and the v0.5 code, not from hardware:
the FP16 stage order above; the native FP8 output precision (`GEMM.m` reduces the output
width by `neab` when `neab < 0`, which for FP16 output would leave zero fraction bits;
L40S FP32 rows already prove that the normalized precision reduction matters);
and the Blackwell FP16-output wrapper.

</details>
