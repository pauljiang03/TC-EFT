# Tensor Core Arithmetic

Executable tensor-core models, bounded error-free transformations, and certified
GEMM in Lean 4. Exact arithmetic, kernel-checked proofs, and independent numerical
oracles share one reproducible command-line workflow.

[Quick start](#quick-start) · [Scope](#scope) · [Review](#reviewer-walkthrough) ·
[JSON interface](#gemm-json-interface) · [Validation](#validation-and-trust) ·
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
| `./tc schema` | Print the GEMM input JSON Schema |
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
| BF16 | Complete for the selected Ampere and Hopper families | Matrix integration remains open |
| TF32 | Complete for Ampere and Hopper WMMA/MMA paths | Matrix integration remains open |
| FP8 | Separate candidate models and partial coverage | Outside the primary scope |

FP16 GEMM supports arbitrary dimensions, ordered encoded accumulators, input
conversion, raw `AB+C`, separately rounded `alpha*AB+beta*C`, and source-relative
error certificates. Converting BF16 or FP32 source matrices to FP16 does not
provide native BF16 or TF32 multiplication.

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
   equivalence statements. Check assumptions against the [claim map](#paper-claim-review).
4. Run `./tc audit` and `./tc check`. Review the generated reports below.

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

All operations require `operation`, `model`, `m`, `n`, `k`, `a`, `b`, and `c`.
Models are `v100`, `ampere`, and `hopper`. Scaled operations also require:

| Fields | Values |
| --- | --- |
| `input_format`, `output_format` | `fp16`, `bf16`, `fp32`, or `fp64` |
| `input_mode`, `multiply_mode`, `add_mode`, `output_mode` | `rne`, `rtz`, `rdn`, or `rup` |
| `alpha`, `beta` | Encoded FP32 words |

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

Certificates require `accumulator_scale`, `product_scale`, `carry_bits`, and
`initial_bound`. Scaled certificates additionally require `alpha_scale`,
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
Matrix bounds use the sum of absolute entry errors. Rejected scaled cells are
`null`; raw cells contain an `error`. A numerical rejection is a valid result and
does not set a process error. Invalid requests stop at the first bad line, return
exit code 2, and emit a JSON diagnostic to stderr. Earlier output lines remain valid.

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
| Bounded EFT | [bounded-eft-report.json](tensor-core/data/regressions/bounded-eft-report.json) |
| Claim assessment | [claim-review.json](tensor-core/data/regressions/claim-review.json) |
| Complete axiom listing | [axioms.txt](tensor-core/docs/axioms.txt) |
| Pinned CUTLASS source checks | [cutlass-report.json](tensor-core/data/regressions/cutlass-report.json) |

Allowed proof dependencies are `propext`, `Classical.choice`, and `Quot.sound`.
There are no project axioms or compiled reflection. Mathematical proofs concern
the explicit finite-domain definitions. Python checks and archived vectors provide
test evidence. CUTLASS is a reviewed source arithmetic projection; CUDA compilation,
V100 execution, memory transport, and compiler correspondence remain unvalidated.

Historical `*-validation.json` files retain their original scope and source hashes.
The latest clean report determines current build evidence. CPU benchmarks remain
separate from correctness and GPU performance claims.

## Assessment and TODO

README.md is the single maintained plan and status document. Current review scope:
FP32-output arithmetic and FP16 GEMM; FP8 is deferred. The implementation includes
four-mode finite rounding, signed encoding bijections, selected tensor-core
contracts, bounded EFT, Eq.20 and extraction grids, complete scaled-GEMM
equivalence, and tighter original-input error certificates.

| Priority | Status | Next step |
| --- | --- | --- |
| Reviewer workflow | Implemented | Use the launcher, editable cases, schema, and claim map |
| Human claim review | Pending | Inspect definitions and assumptions; record author sign-off |
| Source reproducibility | Implemented | Use a fixed Git revision and compare the clean validation hashes |
| Native BF16/TF32 GEMM | Open | Add matrix interfaces, schedules, operand mappings, and certificate instances |
| CUTLASS execution | Open | Compile the pinned fixture and compare on V100 |
| CUTLASS generalization | Optional | Model residue-first partial K, other epilogues, and split-K |
| Sharper error bounds | Optional | Tighten raw tensor-core budgets, exact scalar stages, and range caps; add induced norms |
| General scalar arithmetic | Outside current scope | Encoded subtraction, multiplication, division, square root, and generic FMA APIs |
| Globally corrected GEMM | Outside current scope | Prove a complete residual ledger, capacity, and one final rounding |
| Adaptive programs | Outside current scope | Add state, branches, invariants, and decision/composition certificates |
| FP16 tensor-core outputs and FP8 | Deferred | Resolve specification ambiguities and complete remaining paths |

The [claim map](#paper-claim-review) records exact proved scope. The
[coverage review](#remaining-paper-coverage) retains unresolved paper/source
questions. Neither full paper coverage nor universal physical GPU conformance is claimed.

## Source pins and layout

| Source | Pin |
| --- | --- |
| Accurate Models | [arXiv:2512.07004v4](2512.07004v4.pdf) |
| TC-EFT | [Corrected manuscript](tc-eft-corrected.pdf) |
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
crosschecks/               Optional external Lean comparisons
tmp/                       Ignored local experiments and output
```

Upstream source and licenses are preserved unchanged. Build caches, local probes,
and generated compiler output stay in ignored `.lake/` and `tmp/` directories.

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
Its definition, profile, schedule, matrix, and scalar modules import only Lean's standard library
and each other. They do not call the implementation's arithmetic stages. Final
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
sufficient and conservative; induced norms and tighter raw tensor-core budgets
are separate extensions.

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

Agent-assisted review begun 6 September and updated 7 September 2026 against the two pinned PDFs in
[Source pins and layout](#source-pins-and-layout), their rendered figures/tables,
the vendored MATLAB definitions, and the Lean statements below. This reviews
mathematical scope and transcription; it is not author sign-off, a novelty review,
or independent physical validation. No arithmetic behavior was changed to resolve
a paper ambiguity. The claim map is maintained here; the
[review record](tensor-core/data/regressions/claim-review.json) pins the reviewed
sources and records declaration checks.

**Supported artifact claim:** finite-domain formalization of the selected
FP16/BF16/TF32-to-FP32 tensor-core paths; their stated error, flowback, recovery,
and guarded correction contracts; bounded EFT refinement; and arbitrary-size
matrices under the explicit FP16 WMMA/scalar schedule, with original-source error
certificates. Independent-specification equivalence covers the eight block paths,
ordered group lists, three raw FP16 WMMA matrix profiles, and the complete
independently specified scalar/input-conversion pipeline. Eq.20 and arbitrary
permitted extraction grids are exposed. One pinned CUTLASS arithmetic projection
is connected with the explicit trust boundary above. Neither paper is claimed
fully formalized.

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

### Related work and research positioning

<details>
<summary>Expand reference</summary>

Literature checked 6 September 2026, using primary papers, official repositories,
and release documentation. Except for the isolated FLoPS check below, this is a
scope comparison without an independent build or proof-dependency audit of the
external projects. **This is not the first
floating-point theory in Lean**, and formal tensor-core algorithm analysis also
predates this project.

| Prior work | Established scope and relevance |
| --- | --- |
| [FLoPS : Chang, Park, Lim, Nagarakatte](https://arxiv.org/abs/2602.15965), first submitted 17 February 2026, revised 17 May | Lean formalization of P3109 formats, representations, rounding, and numerical algorithms including FastTwoSum and ExtractScalar. Its mathematical treatment of low-precision arithmetic is direct prior art for a general Lean FP theory. Its P3109 semantics should not be substituted for tensor-core shared-grid accumulation. |
| [FloatSpec](https://github.com/Beneficial-AI-Foundation/FloatSpec) | Ongoing Lean port of Flocq, with executable reference operations and specification layers. Its own progress report identifies unproved theorems and error-analysis stubs. Useful architecture and candidate lemmas; importing a module is not evidence that all its dependencies are proved. |
| [Flean : McKinsey](https://josephmckinsey.com/flean.html), 20 January 2025; [HOLFloat-Lean](https://github.com/opencompl/HOLFloat-Lean) | Earlier Lean floating-point formalization efforts. The Flean author describes an evolving theory; HOLFloat follows Harrison's floating-point treatment. These are additional prior efforts, without a completeness claim from this review. |
| [Lean 4.33.0](https://lean-lang.org/doc/reference/latest/releases/v4.33.0/#float-is-no-longer-opaque), 10 August 2026 | Adds logical models behind `Float` and `Float32`, with arithmetic, comparisons, and conversions. The release explicitly distinguishes these models from a complete FP mathematics library. Our installed 4.33.1 includes scalar add/subtract/multiply/divide/square-root definitions; a bridge to our finite-range semantics still needs proof. |
| [ARCH HDL : Zhao](https://arxiv.org/abs/2607.23715), 26 July 2026 | Reports Lean proofs of FP32 multiplication/FMA rounding and a bounded FMA refinement, alongside SMT/RTL verification for other operators. This is prior Lean verification of basic FP operations, with a different hardware target and split verification method. |
| [Valpey, Li, Pai, Gopalakrishnan, NFM 2025](https://arxiv.org/abs/2502.15999), first submitted 21 February 2025 | Earlier SMT tensor-core models and correction-algorithm analysis. Their counterexample is relative to their numerical model. Accurate Models v4 corrects earlier characterizations; its Table 5 records missing denormalized-product and alignment-limit behavior in this work. It is historical formal-methods precedent, not this project's numerical authority. |
| [Flocq : Boldo and Melquiond, 2011](https://guillaume.melquiond.fr/doc/11-arith20-article.pdf); [VCFloat2 : Appel and Kellison, CPP 2024](https://www.cs.princeton.edu/~appel/papers/vcfloat2.pdf) | Coq/Rocq precedents: a general FP theory and sound automated roundoff analysis, including interfaces for user-defined functions. They inform how local arithmetic contracts can support program-level error bounds. |
| [TorchLean verification documentation](https://lean-dojo.github.io/TorchLean/blueprint/Verification-and-Certificates/Neural-Network-Verification/) | Lean neural-network verification with explicit finite-precision refinement obligations. Its distinction between real-valued analysis, encoded execution, and error transfer is relevant to a future integration; it supplies no implicit theorem about a vendor tensor-core schedule. |

The supported description of this project's contribution is an executable Lean
formalization of the specified tensor-core arithmetic, with parametric proofs,
encoded-boundary composition, complete bounded EFT, and kernel-checked raw/scaled
matrix accuracy certificates. Mixed scalar/tensor-core execution already exists in
the explicit scaled-GEMM pipeline; general adaptive programs remain a research
direction. A narrower priority claim, such as the first Lean mechanization of a
particular paper's model, has not been established by this review. General FP,
error-free transformations, and tensor-core correction analysis are not new here.

[Accurate Models v4, Section 4.4 and Table 5](https://arxiv.org/html/2512.07004v4#S4.SS4)
distinguishes the corrected numerical model from earlier descriptions, including
the SMT work. Proofs about an earlier model do not establish agreement with the
corrected specification. Here, Accurate Models remains the numerical authority;
Lean checks consequences of our explicit definitions. Faithfulness to the paper
and coverage of its complete statements require a separate source-to-code review.

There is deliberate overlap with FLoPS in the standard representation and rounding
mathematics. Our foundation uses executable rationals and IEEE-style finite
encodings on Lean core; FLoPS's abstract layer uses Mathlib reals, and its separate
encoding layer targets P3109. P3109 encodings cannot serve as IEEE bit-pattern
oracles. The tensor-core shared-grid accumulator, machine refinement, recovery,
composition, and accuracy certificates require their own semantics and proofs.

FLoPS's `ExtractScalar_properties` is also a useful reference for alternative bounded
scalar extractors: its exact split and residual bound have explicit representability,
power-of-two scale, and input-size hypotheses. Reusing that theorem would require
a general representation bridge. This project's generic directed-rounding proofs
and finite encode/decode bijections are now proved independently of that bridge.

</details>

### Independent Lean check against FLoPS

<details>
<summary>Expand reference</summary>

The isolated [checker](crosschecks/flops/check.py) uses the original
[FLoPS Core rounding definitions and theorems](https://github.com/rutgers-apl/FLoPS/blob/95081ac643663da507115abe23ebd5701433587f/Flops/Core/RoundOp.lean),
without changing them or adding a Mathlib dependency to the main project. It checks
the committed source pinned in [pins.json](crosschecks/flops/pins.json), independently
of work in progress. Each project runs under its own pinned Lean version.

The [saved report](crosschecks/flops/report.json), checked 6 September 2026,
records **1,176 passing comparisons**: 49 exact rational inputs per format, each
under all four modes, for FP16, BF16, packed TF32 (`tf19`), FP32, FP64, and E5M2.
Cases cover both signs, zero, subnormal boundaries, even/odd ties, exponent carry,
the largest finite value, non-dyadic fractions, and seeded inputs. All 2,352
generated theorem roots passed the axiom audit; both deliberately wrong results
were rejected. The checked numerical foundation files at `49a310c` are unchanged
in the later review-fix commit `ed4b0fc`.

For every case, our Lean proves the encoded result of `roundBinary` and its decoded
value. FLoPS's Lean proves equality with its own rounding function and applies its
nearest-even, toward-zero, round-down, or round-up correctness theorem. Python only
proposes exact rational inputs and result witnesses; Lean checks those proposals.
The translation uses precision `fractionBits + 1` and minimum coefficient exponent
`1 - bias - fractionBits` (−149 for FP32). It uses the format-agnostic abstract core,
not P3109 bit encodings.

Run from the repository root with Python 3.9+, Git, curl, and elan installed:

```sh
elan toolchain install leanprover/lean4:v4.33.1
elan toolchain install leanprover/lean4:v4.28.0
python3 crosschecks/flops/check.py
```

The first run downloads pinned FLoPS/Mathlib sources and the Mathlib proof cache.
Sources, generated Lean proofs, fixtures, logs, and the current report stay under
ignored `tmp/flops-crosscheck/`. `--formats fp32` runs only the FP32 subset. The
checker verifies the FLoPS archive hash and original source contents, audits every
generated theorem for the standard Lean axioms, and requires deliberately wrong
results to fail on both sides.

This is concrete cross-validation, not a theorem of equivalence for all inputs.
FLoPS's abstract core has no upper exponent bound and does not distinguish signed
zeros, so the comparison is of finite values within our accepted range. Overflow,
NaNs, infinities, E4M3 encodings, separate scalar-operation/error-bound contracts,
and tensor-core shared-grid truncation are outside this check. The tensor-core
specification remains Accurate Models; this check requires no GPU.

</details>

### Reasoning about computations that use tensor cores

<details>
<summary>Expand reference</summary>

The existing downstream interface is `Program.Accurate`: successful execution
and an absolute error bound against the independently decoded original-input
ideal. The bounded-dot and changing-state schedule theorems already provide
instances. A consumer can use this contract without unfolding alignment or
enumerating execution traces.

This use does not require extracting an individual block's output from a running
GPU. Intermediate accumulators can remain mathematical states in the proof.
`runBlocks_uncorrected_error` composes local errors across encoded boundaries;
`runBlocks_of_scale_bound` derives successful execution and a final error bound
from operand scales, group counts, and accumulator headroom, without evaluating
the intermediate outputs. Applying TC-EFT correction inside an opaque sequence
and proving a bound on that sequence are separate tasks.

For a specified matmul schedule, each output entry is an ordered sequence of such
blocks. The matrix corollary is
`abs(D[i,j] - (A*B + C)[i,j]) ≤ sum_t e[i,j,t]`, where `e[i,j,t]` bounds each local
error. Here `A`, `B`, and `C` denote decoded inputs;
conversion from earlier values requires its own error accounting. Matrix indexing,
tile/reduction order, padding, and any scalar epilogue must be specified and
connected to these schedules. The WMMA simulator supplies this mapping, the
entrywise bound, and input-derived acceptance/error certificates for encoded FP16
`A`, `B` and FP32 `C`. It also supplies an entrywise 1-norm corollary and a separate
scaled pipeline with input-derived certificates through input conversion, every scalar
stage, and output conversion, relative to the decoded source-format matrices.
The Accurate Models GEMM
schedule is not an implicit specification of every CUDA library's matmul kernel.

**Public schedules.** Sources checked 6 September 2026 distinguish three layers:

| Layer | What is available for a formal model |
| --- | --- |
| [CUTLASS/CuTe kernel source](https://docs.nvidia.com/cutlass/latest/media/docs/cpp/gemm_api_3x.html) | A chosen configuration exposes the tile and operand mappings, K-loop, MMA calls, synchronization, and epilogue. This supplies a concrete arithmetic dependency graph to translate into Lean. |
| [PTX instruction contract](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html) | Specifies instruction shapes and execution requirements, but leaves accumulation order, rounding, and subnormal handling unspecified for the relevant low-precision MMA paths. Accurate Models supplies our numerical specification inside each instruction. |
| [cuBLAS/cuBLASLt API](https://docs.nvidia.com/cuda/cublas/) | Exposes algorithm selection and options such as split-K count and reduction scheme, rather than a complete, stable arithmetic graph for every call. A library name or GEMM shape alone does not identify the schedule. |

The proof needs arithmetic dependencies and rounding boundaries, not cycle-by-cycle
GPU scheduling. Properly synchronized workers producing disjoint output tiles may
execute in any order without changing those entries' arithmetic. Split-K and atomic
updates to a shared output require a specified reduction order, or a bound proved
for every permitted order. A composition can be a dependency graph with shared
values, rather than a single reduction tree. Public source makes the graph
inspectable; correspondence with the compiled instructions remains a separate
obligation, not something established by reading the source alone.

**First source projection, completed with restrictions.** The
[pinned CUTLASS connection](#pinned-cutlass-connection) uses Sm70 WMMA, sequential
full K tiles, zero initial accumulators, and an identity epilogue. Its reviewed
arithmetic projection agrees with the existing matrix model. Partial-K handling,
compiler/flags validation, memory/lane transport and physical execution remain
explicit obligations. General `alpha`, `beta`, conversions, or a fused epilogue
must be connected in their actual source order; the current configuration has
no such stages. Matrix acceptance/error theorems are available for the matching
raw schedule, subject to their input-derived checks.

For example, on the bounded-dot input family, `abs(d − S) ≤ 1/2048`. It follows
mathematically that `d > 1/2048` certifies `S > 0`, and `d < −1/2048` certifies
`S < 0`. This would support a margin-certified dot-product decision; a dedicated
decision API and theorem have not yet been added. Input conversion error is
separate if `S` is intended to describe real inputs before FP16 encoding.

For composition with a scalar function `f`, the target rule is:

```text
abs(d − S) ≤ E
abs(f(x) − f(y)) ≤ L * abs(x − y) on a proved input interval
abs(z − f(d)) ≤ δ for the encoded scalar implementation
----------------------------------------------------------------
abs(z − f(S)) ≤ δ + L * E
```

Both `d` and `S` must lie in that interval, and every operation must satisfy its
range conditions. This proposed rule explains why downstream errors are not
always just a sum: later multiplication or division can amplify earlier error.
Shared-grid tensor-core truncation retains its own local contract throughout.

| Proposed application | Existing foundation | Additional obligation |
| --- | --- | --- |
| Matrix multiplication or a linear layer | WMMA simulation, proved indexing, input-derived raw/scaled-matrix certificates against original source-format inputs, entrywise 1-norm bounds, and separately rounded scaling/conversions | Tighter raw tensor-core budgets, induced norms, and compiled-kernel/memory correspondence |
| Mixed scalar/tensor-core correction | Complete bounded EFT, encoded scalar operations, universal bit refinement, input-derived success families, and operation budgets | Compose correction with the selected instruction schedule; optimized machine lowering and performance evidence |
| Schedule or precision changes | Explicit grouping, scale-sensitive semantics, non-monotonicity regressions | Prove equivalence under stated conditions or prove both implementations meet a tolerance; real-algebraic equality alone is insufficient |
| Stable decisions or iteration | Certified absolute error and changing-state bounds | A decision margin, or an invariant with amplification/contraction bounds; adaptive operands need a richer AST |

**Promising research questions.** These are proposed extensions, not established
results or priority claims:

- **Explain and bound the multi-word GEMM accuracy reversal.**
  [Accurate Models v4, Section 5](https://arxiv.org/html/2512.07004v4#S5)
  reports lower error for V100 in some FP16 multi-word experiments despite newer
  models having more alignment bits. It suggests an interaction with final
  toward-zero rounding, observes improvement in a modified B200 model using final
  nearest rounding, and leaves further analysis open. A useful result would give
  an explicit input family and conditions for the reversal, then prove a remedy's
  scope. The reported errors use MATLAB binary64 GEMM as reference; our theorem
  should state its independent exact-input ideal. Changing final rounding is a
  hypothetical model variant, not an assumed hardware option or a universal fix.
- **Recheck algorithm comparisons under the corrected semantics.**
  [Valpey et al., Section 6](https://arxiv.org/html/2502.15999v1#S6)
  encoded Markidis and Ootomo–Yokota correction schemes and found inputs where the
  former gives lower absolute error for one output entry, against a binary64
  dot-product reference. This refutes universal accuracy dominance within their
  model and input domain; it is not an average-accuracy or performance result.
  Re-evaluate the witness under Accurate Models, kernel-check any surviving
  counterexample, and seek a general family or sufficient accuracy conditions.
  Corrections to the earlier model do not by themselves invalidate every witness.
- **Certify useful schedule or precision choices.** Prove conditions under which
  regrouping, moving `C`, residual scaling, or scalar consolidation preserves an
  answer or meets a tolerance. TC-EFT Algorithm 1 already supplies a guard/fallback
  correction design, now with bounded operations, input-derived success families,
  and source-level cost budgets. Optimized schedule choices still need refinement
  and performance evidence. A separate tolerance policy could accept
  an uncorrected matmul using its proved error bound. Neither policy follows from
  exact real-algebraic equivalence alone.

These extensions can follow the scoped artifact release unless its claims require
them. Complete paper coverage retains the obligations listed above. Existing Lean FP libraries
are candidates for reuse; their domains, zero policies, rounding modes, and proof
dependencies must match through explicit bridge theorems. No additional GPU
evidence is required for results about the paper's model.

</details>
