# Tensor Core Arithmetic

A Lean 4 formalization of floating-point and NVIDIA tensor-core arithmetic from
*Accurate Models of NVIDIA Tensor Cores* and *TC-EFT: Characterizing and Correcting
Tensor Core Arithmetic*. The library includes executable reference semantics,
kernel-checked proofs, a small program DSL, and independent numerical checks.

**Accurate Models v4 is the ground-truth numerical specification.** The pinned
MATLAB v0.5 source supplies implementation details; discrepancies must be resolved
explicitly with the paper as authority. TC-EFT supplies the error, monotonicity,
and correction contracts. GPU access and new measurements are optional external
validation, with no role in deciding whether the paper has been formalized.

This is the single maintained project document. Source comments describe local
contracts; generated reports retain validation evidence. The vendored upstream
README and license remain part of the pinned source distribution.

## Build and use

Requires the pinned Lean 4.33.1 toolchain and Python 3. There are no external Lean
packages, Python dependencies, native floating-point calculations, or external solver calls
in the formal model: specifications use exact `Int`/`Rat`, and bounded primitives
use `BitVec`.

```sh
cd tensor-core
lake build
python3 scripts/check_axioms.py
lake env lean examples/Verify.lean
lake env lean examples/Certify.lean
lake env lean examples/BoundedDot.lean
```

Run the complete validation suite from a fresh source copy with:

```sh
python3 scripts/check_clean_build.py
```

`lake exe tc_trace a0 b0 a1 b1 a2 b2 a3 b3 c` prints a V100 block trace.
Operands are FP16 hexadecimal words and `c` is an FP32 hexadecimal word, without
`0x`. The `tc_features` executable supports parameterized blocks, long dot products,
and certificates; runnable examples are in [examples](tensor-core/examples).

## Numerical model

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

## Floating-point theory and principal results

The floating-point foundation proves finite binary decoding, encoding, and
nearest-even and toward-zero rounding for every well-formed IEEE-style `Format`, including
FP16, BF16, packed TF32, FP32, and FP64. FP32 also has representability and
exact-summation results. Tensor-core proofs build on this foundation. The rounding
theorems quantify over every rational in the format's finite reference range;
concrete examples use kernel reduction and are reported separately.

`round32` implements toward-zero and nearest-ties-even rounding, with proofs for
both, as does `roundBinary` for all well-formed formats. The generic converter also
implements rounding toward −∞ and +∞; general correctness proofs for those two
modes remain open. Nearest-ties-away is not implemented. Beyond rounding, this is not
yet a complete scalar arithmetic library: general subtraction, multiplication,
division, square root, and general FMA contracts, exception flags,
and operation-specific signed-zero rules remain to be developed. Subnormal values
are supported; flush-to-zero policies are outside the current model.
E4M3's finite-top-NaN `ValueFormat` is outside this generic converter: E4M3 can
encode 448, whereas the IEEE-style layout with the same field widths stops at 240.
`Regression.e4m3_outside_generic_rounding` proves that distinction.

All declarations below are in the `TensorCore` namespace. The source directories
are [Foundations](tensor-core/TensorCore/Foundations),
[Theory](tensor-core/TensorCore/Theory), and
[Programs](tensor-core/TensorCore/Programs).

| Contract / paper reference | Principal declarations and domain |
| --- | --- |
| Finite encoding and correct rounding — TC-EFT II.1–II.2 | `decode32_finite`, `value32_finite`, `round32_nearestEven_correct`; finite FP32 encodings and rationals with magnitude at most `maxFinite32` |
| Format-generic conversion | `roundBinary_nearestEven_correct`, `roundBinary_towardZero_correct`; every well-formed format and rational in its finite reference range. `conversionStage_nearestEven_correct` and `conversionStage_towardZero_correct` transfer these contracts to accepted conversion stages. |
| Round trip, uniqueness, truncation | `value32_round32`, `value32_injective` for nonzero finite encodings; `round32_nonzero_spec`; `signedRounded_rtz_monotone` on the finite range |
| Raw products, aligned accumulation, residuals | `rawProduct_value`, `accumulator_value`, `alignment_residual`, `evalBlock_residual_identity` |
| Two-stage error — TC-EFT III.1 | `block_error_bound`, `evalBlock_error_bound`: `abs(S−D) < n·qA + qD`, where `n = K+1` and the aligned accumulator is in range |
| Parameterized FP16 → FP32 contract and exact accepted domain | `fp16Fp32_contract`, `evalBlock_success_iff`; arbitrary product count and extra alignment bits |
| BF16/TF32 → FP32 contracts and descriptor compatibility | `profile_contract`, `bf16Fp32_contract`, `tf19Fp32_contract`, `bf16Fp32_invocation_compatible`, `tf32_invocation_bits`; TF32 equivalence requires padded register words |
| Modular accumulator refinement | `fp16Fp32_machine_eq`; complete results, including rejections, agree when `w ≥ 26 + extraBits + carryBits` and `K+1 ≤ 2^carryBits`; every prefix is safe |
| Floor inactivity and exact alignment with sufficient padding | `canonical_eta_floor_inactive`; `canonical_source_padding_exact` for `extraBits ≥ 156`, floor ≤30; `canonical_padding_exact` for `extraBits ≥ 253`, floor ≤127 |
| Monotonicity and flowback — TC-EFT III.2–III.3, Equation 6 | `MonotoneInAccumulator`, `perturbed_accumulator`, `output_condition`, `flowback_necessary`, `flowback_sufficient`; accepted outputs, with representable accumulators required for sufficiency |
| Non-monotonicity family — TC-EFT III.4–III.5, Table III | `nonmonotone_perturbation`, `nonmonotone_encoded`, `nonmonotone_range_encoded`; family and thresholds below |
| Low parts, overlap window, splitting and recovery — TC-EFT IV.1–IV.5 | `lowPart_bound`, `overlap_window_width`, `truncGrid_split`, `accumulator_eq_retained`, `overlap_eq_retained_sub_outputResidual`, `overlap_recovery` |
| Scalar predicate and exact summation — TC-EFT IV.6–IV.11 | `scalarPredicate`, `fp32Add_exact`, `naiveSum32_exact`, `scalarCorrected_eq`, `scalarCorrected_correct`; sufficient component conditions below |
| Two-branch reference correction — TC-EFT Algorithm 1, Table V | `BlockTrace.algorithm1`, `algorithm1_correct`, `algorithm1_bits_isSome_iff`, `referenceLedger`; branch choice remains visible |
| Guarded scalar correction | `tceft_isSome_iff`, `tceft_correct`, `tceft_eq_corrected`; a result exists exactly when the sufficient predicate holds |
| Bounded multiplication and splitting | `EFMachine.multiplySignificands_exact`, `EFMachine.splitMagnitude_reconstruct`, `EFMachine.splitMagnitude_coarse_truncGrid`, `EFMachine.splitMagnitude_low_residual` |
| Schedules and ordered tail padding | `runBlocks_residual_ledger`, `runBlocks_uncorrected_error`, `fp16Fp32_schedule_machine_eq`, `canonicalPartition_ideal` |
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

## Correction and its implementation boundary

[Algorithm1.lean](tensor-core/TensorCore/Programs/Algorithm1.lean) implements the
paper's two branches on an exact trace. It selects the guarded scalar branch when
its predicate holds; otherwise it forms `D − ε_o + Σ εᵢ` exactly and rounds once.
The result identifies `.scalar`, `.exactReference`, or `.outOfRange`. Every returned
encoding is nearest-even to the exact ideal, and an encoding exists exactly when
the ideal is in the finite FP32 range. `referenceLedger` records the paper's
operation counts; it is not an execution-cost or timing proof.

The separate `scalarCorrected` and `tceft` APIs return `none` when the sufficient
predicate fails. Their predicate requires a common grid `−149 ≤ ℓ ≤ 104`, a sum
of coefficient magnitudes below `2^24`, representability of the relevant
components, and a finite exact component sum. Extraction and the predicate still
use exact `Rat` arithmetic, including reconstruction for the range check.
`scalarCorrectedUnchecked` is diagnostic and can return incorrect bits outside the
predicate; subnormal and broad finite-input counterexamples remain regressions.

The bounded `EFMachine` primitives multiply two 11-bit significands into 24 bits
and split a 24-bit magnitude using an 8-bit gap. Gaps at least 24 take a separate
branch, avoiding masked shifts. No-wrap, reconstruction, and signed residual
refinement are proved. Encoded extraction, bounded overlap, guard, consolidation,
and a useful correction-success family remain extensions beyond the paper's
exact-dyadic reference algorithm.

## Programs, DSL, and accuracy certificates

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

## Validation and trust

| Check, under `tensor-core/` | Evidence |
| --- | --- |
| `lake build` | Generic proofs and concrete regression theorems checked by Lean |
| `scripts/check_axioms.py` | Enumerates every compiled theorem in the namespace, including generated declarations; verifies the standard-axiom allowlist and scans source for proof shortcuts |
| `scripts/validate.py` | Independent exact Python oracle for V100 blocks and FP32 rounding |
| `scripts/check_features.py` | Independent oracle across product counts, alignment bits, floors, and published FP16 vectors |
| `scripts/check_dot_products.py` | Ordered long dots, partial tails, encoded boundaries, and error budgets |
| `scripts/check_device.py`, `scripts/check_device_formats.py` | Published V100/A100/H100 FP16 and A100/H100 BF16/TF32 vector replay |
| `scripts/check_device_half.py` | All 5,000 published V100 FP16-output rows match both candidate stage orders; the rows do not distinguish them |
| `scripts/check_programs.py`, `scripts/check_certificates.py` | DSL order, rejected inputs/proofs, rollback, supplied proofs, and executable dependency checks |
| `scripts/check_application.py` | Bounded-dot family, boundary cases, independent ideal, accuracy, and certificate cost |
| `scripts/check_eft.py` | Seeded scalar acceptance/rejection coverage, accepted-correction comparisons, bounded primitives, and synthetic hardware replay |
| `scripts/check_clean_build.py` | Complete suite and every standalone example from a source copy without a build cache |

Counts, timings, warnings, and pass/fail results belong in the generated
[regression reports](tensor-core/data/regressions), with the full-suite result in
[clean-build.json](tensor-core/data/regressions/clean-build.json) and the axiom
listing in [axioms.txt](tensor-core/docs/axioms.txt). These record completed runs;
a report predating a source change does not validate that change. Historical
handoff and merge manifests record their original source snapshots.

The allowed proof dependencies are `propext`, `Classical.choice`, and `Quot.sound`.
There are no project axioms or compiled reflection. Python comparisons, diagnostic
evaluation, and published vectors are tests, not general theorems. The EFT gate
preserves both high acceptance on published/near-one inputs and broad finite-bit
rejections; it does not infer workload coverage from selected passing cases.

The vendored device rows exercise one nonzero group, followed by zero groups
where needed. They do not establish the ordering of two nonzero groups, and cover
few zero/subnormal cases or active BF16/TF32 floors. No GPU was run for this project.
The [hardware harness](tensor-core/hardware) and [targeted corpus](tensor-core/data/hardware)
are optional external validation; synthetic replay is not a device measurement.
A theorem about an actual GPU keeps `Conforms path device` as an explicit premise.
Taking the paper as specification introduces no axiom asserting physical conformance.

## Remaining paper coverage

This section lists only what remains. Current status and counts are in the generated
[regression reports](tensor-core/data/regressions); the last full-suite result is
[clean-build.json](tensor-core/data/regressions/clean-build.json).

**TC-EFT.** Every numbered definition, lemma, theorem, and corollary of the paper is
formalized. What remains:

1. FP64 scalar consolidation: Table IV gives FP64 constants (precision 53, grid `2^-1074`,
   coefficient sum below `2^53`), but Lemma IV.7, Theorem IV.8, and Corollary IV.11 are
   proved for FP32 only. Generalize `naiveSum32_exact` and the scalar branch over
   `Format.FiniteValue` using the format-generic rounding proofs.
2. The bit-span sufficient condition `b − ℓ + 1 + ⌈log₂ n⌉ ≤ P` of Theorem IV.8, as a lemma
   implying the coefficient-sum bound the predicate uses.
3. Algorithm 1 over the paper's interface: operand encodings, the profile, and the device
   output `D`, decoding and reconstructing the raw products itself (lines 1–17, including
   the all-zero-block return of `+0`), with a theorem that it agrees with `algorithm1` on
   the trace.
4. Definition III.2 at the encoded level, `val(TC_θ(a, b, c'))`, as a corollary of
   `MonotoneInAccumulator`.
5. Section V-B of the paper describes a validation suite (59 named cases; 800 deterministic
   blocks over eight profile and format combinations; 49,005 synthetic perturbations of the
   Section III-C family; 100 rounding cases at ties and boundaries; 1,600 finite blocks under
   seed 20260906) that this repository does not generate. Either add scripts that produce
   those suites or correct the paper's text to the repository's real numbers. The 100-case
   V100 experiment of Section V-D has no surviving vectors and cannot be reproduced.

**Accurate Models Table 3.** Proved families: FP16, BF16, and TF32 to FP32, matched to the
published vectors. Remaining rows:

| Path | Remaining obligation |
| --- | --- |
| FP16 output | Both candidate stage orders are correctly rounded at the final stage and match all 5,000 published rows; `Regression.half_output_stage_order` separates them (`4001` versus `4000`). The reference source rounds once, directly to FP16; the paper's figure shows an FP32 truncation first. Decide which reading is the formal path and record it. |
| Native FP8, L40S and Ada | `K = 16`, alignment `F = 13` (`neab = −10`), FP32 output. The archive's `L40S/{E4M3,E5M2}` rows hold 32 products against `N_FMA = 16`, so each row runs two groups in increasing k; they are the first published data that exercise group order. Add the descriptors, vendor the files with hashes, replay, and kernel-check first rows. |
| Native FP8, H100 and H200 | Warpgroup path: `K = 32`, `F = 13`, `c = 0` in the published rows, FP32 and FP16 outputs. Same steps. |
| Native FP8, B200 and RTX PRO | `K = 32`, `F = 25` (`neab = 2`), FP32 and FP16 outputs. Same steps. The v0.5 wrapper forces FP32 before testing for FP16 output; the paper lists FP16 output, and the archive has `d_B200_fp16.txt`. |
| Emulated FP8 through the FP16 cores (Fig. 5c) | Interleaved groups and late nearest-even addition of `c`. Model the late-`c` boundary explicitly and the interleaved grouping; no published rows exist for this path. |
| FP64 DMMA | `binary64Fma` is a finite fused operation with nearest-even and toward-zero correctness. Remaining: prove rounding toward −∞ and +∞ for the generic converter, which completes the four-direction contract. |

Source questions still to settle from the paper and the v0.5 code, not from hardware:
the FP16 stage order above; the native FP8 output precision (`GEMM.m` reduces the output
width by `neab` when `neab < 0`, which for FP16 output would leave zero fraction bits; the
FP8 rows decide whether that matters); and the Blackwell FP16-output wrapper.

**Foundation.** Prove rounding toward −∞ and +∞ for every IEEE-style `Format`, and package
the generic encode–decode results as one bijection on the finite domain. Both are the items
the FLoPS comparison below identifies. Saturation, stochastic rounding, and round-to-odd
are outside the modeled paths. E4M3's finite-top-NaN encoding is a `ValueFormat` outside
the generic converter; the FP8 rows need no rounding of E4M3 values, only decoding.

**Order of work.** The TC-EFT items above; the FP8 rows with the archive vectors; the
late-`c` path; the directed rounding proofs. Bounded finite-precision extraction and
tightening of the application bound follow as extensions. Hardware experiments remain
optional. Accurate Models' discovery algorithms and mismatch-rate tables describe
empirical methods, not formalization targets.

**Rules that apply to every item.** Preserve the independent original-input ideal and the
adversarial regressions. Derive success and error guarantees from input assumptions or
invariants, never by assuming the conclusion. A practical correction claim needs bounded
operations, refinement, a useful success family, and explicit costs; changing a contract
or wording does not discharge those obligations. Numbers in this document come from the
generated reports. Keep this README current instead of adding new review, plan, or
handoff Markdown files.

## Related work and research positioning

Literature checked 6 September 2026, using primary papers, official repositories,
and release documentation. Except for the isolated FLoPS check below, this is a
scope comparison without an independent build or proof-dependency audit of the
external projects. **This is not the first
floating-point theory in Lean**, and formal tensor-core algorithm analysis also
predates this project.

| Prior work | Established scope and relevance |
| --- | --- |
| [FLoPS — Chang, Park, Lim, Nagarakatte](https://arxiv.org/abs/2602.15965), first submitted 17 February 2026, revised 17 May | Lean formalization of P3109 formats, representations, rounding, and numerical algorithms including FastTwoSum and ExtractScalar. Its mathematical treatment of low-precision arithmetic is direct prior art for a general Lean FP theory. Its P3109 semantics should not be substituted for tensor-core shared-grid accumulation. |
| [FloatSpec](https://github.com/Beneficial-AI-Foundation/FloatSpec) | Ongoing Lean port of Flocq, with executable reference operations and specification layers. Its own progress report identifies unproved theorems and error-analysis stubs. Useful architecture and candidate lemmas; importing a module is not evidence that all its dependencies are proved. |
| [Flean — McKinsey](https://josephmckinsey.com/flean.html), 20 January 2025; [HOLFloat-Lean](https://github.com/opencompl/HOLFloat-Lean) | Earlier Lean floating-point formalization efforts. The Flean author describes an evolving theory; HOLFloat follows Harrison's floating-point treatment. These are additional prior efforts, without a completeness claim from this review. |
| [Lean 4.33.0](https://lean-lang.org/doc/reference/latest/releases/v4.33.0/#float-is-no-longer-opaque), 10 August 2026 | Adds logical models behind `Float` and `Float32`, with arithmetic, comparisons, and conversions. The release explicitly distinguishes these models from a complete FP mathematics library. Our installed 4.33.1 includes scalar add/subtract/multiply/divide/square-root definitions; a bridge to our finite-range semantics still needs proof. |
| [ARCH HDL — Zhao](https://arxiv.org/abs/2607.23715), 26 July 2026 | Reports Lean proofs of FP32 multiplication/FMA rounding and a bounded FMA refinement, alongside SMT/RTL verification for other operators. This is prior Lean verification of basic FP operations, with a different hardware target and split verification method. |
| [Valpey, Li, Pai, Gopalakrishnan, NFM 2025](https://arxiv.org/abs/2502.15999), first submitted 21 February 2025 | SMT tensor-core models used to discriminate arithmetic behavior and compare two mixed-precision matrix-multiplication correction algorithms. Their counterexample refutes a universal accuracy ordering between those algorithms. Downstream analysis of tensor-core algorithms is therefore already established prior work. |
| [Flocq — Boldo and Melquiond, 2011](https://guillaume.melquiond.fr/doc/11-arith20-article.pdf); [VCFloat2 — Appel and Kellison, CPP 2024](https://www.cs.princeton.edu/~appel/papers/vcfloat2.pdf) | Coq/Rocq precedents: a general FP theory and sound automated roundoff analysis, including interfaces for user-defined functions. They inform how local arithmetic contracts can support program-level error bounds. |
| [TorchLean verification documentation](https://lean-dojo.github.io/TorchLean/blueprint/Verification-and-Certificates/Neural-Network-Verification/) | Lean neural-network verification with explicit finite-precision refinement obligations. Its distinction between real-valued analysis, encoded execution, and error transfer is relevant to a future integration; it supplies no implicit theorem about a vendor tensor-core schedule. |

The supported description of this project's contribution is an executable Lean
formalization of the specified tensor-core arithmetic, with parametric proofs,
encoded-boundary composition, and kernel-checked raw-accuracy certificates.
Extending this to mixed scalar/tensor-core programs is a concrete research
direction. A narrower priority claim, such as the first Lean mechanization of a
particular paper's model, has not been established by this review. General FP,
error-free transformations, and tensor-core correction analysis are not new here.

There is deliberate overlap with FLoPS in the standard representation and rounding
mathematics. Our foundation uses executable rationals and IEEE-style finite
encodings on Lean core; FLoPS's abstract layer uses Mathlib reals, and its separate
encoding layer targets P3109. P3109 encodings cannot serve as IEEE bit-pattern
oracles. The tensor-core shared-grid accumulator, machine refinement, recovery,
composition, and accuracy certificates require their own semantics and proofs.

FLoPS's `ExtractScalar_properties` is also a useful reference for a future bounded
scalar extractor: its exact split and residual bound have explicit representability,
power-of-two scale, and input-size hypotheses. Reusing that theorem would require
a general representation bridge. General proofs for rounding toward −∞ and +∞
and a packaged generic encode/decode bijection remain useful foundation work here.

## Independent Lean check against FLoPS

The isolated [checker](crosschecks/flops/check.py) uses the original
[FLoPS Core rounding definitions and theorems](https://github.com/rutgers-apl/FLoPS/blob/95081ac643663da507115abe23ebd5701433587f/Flops/Core/RoundOp.lean),
without changing them or adding a Mathlib dependency to the main project. It checks
the committed source pinned in [pins.json](crosschecks/flops/pins.json), independently
of work in progress. Each project runs under its own pinned Lean version.

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

## Reasoning about computations that use tensor cores

The existing downstream interface is `Program.Accurate`: successful execution
and an absolute error bound against the independently decoded original-input
ideal. The bounded-dot and changing-state schedule theorems already provide
instances. A consumer can use this contract without unfolding alignment or
enumerating execution traces.

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
| Matrix multiplication or a linear layer | Ordered dot products, tail padding, raw-error certificates | Map each matrix entry to the intended operands and schedule; derive entrywise/norm bounds and include conversion or bias errors |
| Mixed scalar/tensor-core correction | Exact recovery, guarded scalar EFT, Algorithm 1 correctness | Encoded scalar operations and composition; a useful input family satisfying the correction guard; bounded extraction for a practical implementation claim |
| Schedule or precision changes | Explicit grouping, scale-sensitive semantics, non-monotonicity regressions | Prove equivalence under stated conditions or prove both implementations meet a tolerance; real-algebraic equality alone is insufficient |
| Stable decisions or iteration | Certified absolute error and changing-state bounds | A decision margin, or an invariant with amplification/contraction bounds; adaptive operands need a richer AST |

After the current paper-coverage work, a focused extension would connect finite
FP32 scalar contracts to encoded tensor-core boundaries and demonstrate one
matrix or decision theorem. Existing Lean FP libraries are candidates for reuse;
their domains, zero policies, rounding modes, and proof dependencies must match
through explicit bridge theorems. No additional GPU evidence is required for
these results about the paper's model.

## Source pins and layout

| Source | Pinned artifact |
| --- | --- |
| Khattak and Mikaitis, *Accurate Models of NVIDIA Tensor Cores*, arXiv:2512.07004v4 | [2512.07004v4.pdf](2512.07004v4.pdf) |
| *TC-EFT: Characterizing and Correcting Tensor Core Arithmetic*, revised | [tc-eft-corrected.pdf](tc-eft-corrected.pdf) |
| MATLAB Tensor Core v0.5 | Commit `bbcf00a273868172494eaacaa8d6128ab0fb8704`; [vendored source manifest](tensor-core/vendor/SOURCES.json) |

```text
20c0594f2f91b8df7618e6d6bd00a04ee0b7bf557a5ce19d08927241f78fdee4  2512.07004v4.pdf
e9b19e9766974d64dad081ea1107bb6d54c6aff8a1fd0620ce9fb13dbd497b3e  tc-eft-corrected.pdf
```

MATLAB was read, not executed; no full MATLAB GEMM equivalence is claimed. The
paper and pinned driver provide the increasing-k composition rule. Format-specific
exceptions require their own grouping and boundary contracts.

Within `tensor-core/`, `Foundations` defines exact arithmetic and encodings,
`Semantics` implements the model, `Theory` proves its properties, `Programs`
handles correction and composition, `Applications` contains the bounded dot,
`Meta` implements the DSL, and `Regression` contains kernel-checked cases. These
modules live under `TensorCore/`; `examples/`, `scripts/`, `data/`, and `vendor/`
contain the runnable examples, checks, evidence, and pinned upstream material.
