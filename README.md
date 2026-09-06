# tc-lean-mp

Machine-checked reference semantics for NVIDIA tensor-core dot products, in Lean 4.

The model follows *Accurate Models of NVIDIA Tensor Cores* (Khattak and Mikaitis,
arXiv:2512.07004v4) and its MATLAB Tensor Core v0.5 release, and formalizes the arithmetic
results of *TC-EFT: Characterizing and Correcting Tensor Core Arithmetic*. The claimed family
is FP16 products with an FP32 accumulator, parameterized by the number of products per group
and the number of extra alignment bits, which covers the V100, Ampere/Ada, and
Hopper/Blackwell FP16 paths. Reference arithmetic uses exact `Int` and `Rat`;
bounded machine primitives use `BitVec`. There are no external Lean dependencies
and no native `Float`.

*Accurate Models* is the ground-truth specification for this formalization. The
goal is to faithfully encode its numerical semantics and prove results about
them in Lean. New GPU measurements are optional external validation of the
paper's correspondence with hardware; GPU access is not a completion requirement.

## The modeled operation

One invocation is one dot product `S = c + Σ aᵢ·bᵢ`, computed according to the source model:

1. Decode each operand to a signed integer significand and a raw scale. Subnormals keep
   their explicit fraction and the minimum normal scale.
2. Multiply significands and add scales. Products are not renormalized: `1.5 × 1.5` and
   `1 × 2.25` have the same value but different raw scales, and can produce different outputs.
3. Take the alignment exponent η as the maximum raw scale over the nonzero terms, including
   c, then apply the profile's floor if it has one.
4. Truncate every term toward zero onto the grid `qA = 2^(η−F)`, with `F = 23 + extraBits`,
   and sum the integer coefficients exactly.
5. Normalize and truncate the sum to FP32.

Each trace keeps the exact alignment residual of every term and the output residual, so
`S = D + r_out + Σ rᵢ` holds exactly and can be used to correct `D`.

## What is proved

Every theorem is checked by the Lean kernel. The complete contract → declaration map is in
[docs/THEOREM_MAP.md](tensor-core/docs/THEOREM_MAP.md).

| Result | Declaration |
| --- | --- |
| Raw products preserve value; alignment residual is strictly below the grid | `rawProduct_value`, `alignment_residual` |
| Exact recovery for any supplied output; two-stage error bound `abs(S − D) < n·qA + qD` | `block_residual_identity`, `evalBlock_error_bound` |
| Nearest-even FP32 conversion is correct for every rational in range | `round32_nearestEven_correct` |
| Contract for any product count and extra alignment bits, with a modular signed-word accumulator returning the same complete result | `fp16Fp32_contract`, `fp16Fp32_machine_eq` |
| Exact accepted domain; floors at or below −126 inactive; padding thresholds that make alignment exact | `evalBlock_success_iff`, `canonical_eta_floor_inactive`, `canonical_source_padding_exact` |
| Scalar EFT: naive FP32 summation is exact under the coefficient bound; the scalar EFT returns a result only when its predicate holds, and every result is the correctly rounded dot product (TC-EFT IV.3–IV.4, IV.7–IV.11) | `naiveSum32_exact`, `truncGrid_split`, `tceft_isSome_iff`, `tceft_correct` |
| Bounded significand multiplication and coarse/low splitting refine exact products, truncation, and residuals | `EFMachine.multiplySignificands_exact`, `EFMachine.splitMagnitude_coarse_truncGrid`, `EFMachine.splitMagnitude_low_residual` |
| Non-monotonicity for the specified equal-product family: `K` products of value `2^-(24+p)`, raw scale at most `−1`, floor at most `−1`, and `K < 2^(24+p)`. Lowering c from `1` to `1 − 2^-24` raises the output iff `K ≥ 3·2^p` (III.4); for `c = 1 − j·2^-24`, witnesses are exactly `1 ≤ j ≤ min(2^23, ⌊K/2^p⌋ − 2)`, with the greatest witness output at `j = 1` (III.5). This does not characterize all inputs. | `nonmonotone_perturbation`, `nonmonotone_encoded`, `nonmonotone_range_encoded` |
| Exact residual ledger over any finite chain through encoded FP32 boundaries; composed uncorrected error bound; machine equivalence through schedules | `runBlocks_residual_ledger`, `runBlocks_uncorrected_error`, `fp16Fp32_schedule_machine_eq` |
| Ordered partition of a long dot product with proved ideal preservation and tail padding | `OrderedPartition.uncorrected_error`, `canonicalPartition_ideal` |
| Input-derived error budget: a scale bound on the operands and bounded ideal partial sums give acceptance of a whole schedule and an error bound, decided by a certificate that never runs the model | `block_static_error_bound`, `runBlocks_static`, `staticCheck_sound` |
| Decoder/encoder round trip: converting a nonzero finite value returns its own bits; nonzero values have unique encodings | `value32_round32`, `value32_injective` |
| Instruction paths: exactly `k` operands, contiguous increasing-k grouping, zero groups pass the accumulator through, single-group inputs reproduce one group, and the composed error bound holds for any device that agrees with the model on its accepted domain | `single_group_output`, `conforms_uncorrected_error` |
| Exact-reference correction checker soundness | `Program.vc_sound` |
| Successful execution and requested raw-output tolerance, checked on concrete inputs | `Program.staticCertificate_sound`, `tc_certify` |
| Input-scale/count bounds for changing-state schedules and symbolic repetition | `runBlocks_of_scale_bound`, `Program.repeat_accurate_of_scales` |
| Bounded ordered dot: up to 256 signed FP16 pairs below magnitude 1/16, finite FP32 initial magnitude at most 1, raw absolute error at most 2^-11 | `boundedDot_accurate_of_bits`, `boundedDotCheck_sound` |
| R1–R4, Table III, EFT examples, rounding boundaries, rejections | `Regression.*` |

The rounding theorem is a general proof over all rationals with magnitude at most
`maxFinite32`, not a test. Concrete regressions are decided by kernel reduction of the actual
evaluator (`decide +kernel`).

## What is tested

- `scripts/validate.py`: an independent Python oracle agrees with the V100 evaluator on 715
  blocks and 2,918 rounding inputs.
- `scripts/check_features.py`: a second oracle agrees with the parameterized evaluator on
  2,033 cases over 132 combinations of product count, extra bits, and floor, and replays the
  published V100, A100, and H100 FP16 vectors: 5,000 rows each, zero mismatches.
- `scripts/check_dot_products.py`: constructed long dot products with partial tails, every
  encoded boundary and error budget compared: 280 cases over 25 configurations.
- `scripts/check_device_formats.py`: the published A100 and H100 BF16 and TF32 vectors
  match the deferred-format descriptors, 5,000 rows each. Evidence only; no proofs for those
  formats are claimed.
- `scripts/check_programs.py`: the DSL example compiles, ten malformed programs are rejected,
  an unrelated earlier error does not roll back a later verification, the three pinned
  instruction paths print their parameters, and an unsourced path name is refused.
- `scripts/check_certificates.py`: eight certification failures, successful supplied proofs,
  rollback behavior, and executable dependency checks pass.
- `scripts/check_application.py`: 87 bounded-dot and boundary cases agree with the independent
  oracle; 52 pass the family certificate and 69 the concrete certificate. Timing and bound
  tightness are recorded in `data/regressions/application-report.json`.
- `scripts/check_eft.py`: 21,966 scalar-coverage cases preserve the seeded baseline,
  with zero accepted-correction mismatches; bounded primitive regressions and
  synthetic replay tests pass. The 99 targeted hardware vectors are unmeasured.
- `scripts/check_axioms.py`: every theorem in the `TensorCore` namespace, enumerated from the
  compiled environment (772 constants, 471 written in source, the rest generated structural
  lemmas), depends only on `propext`, `Classical.choice`, and `Quot.sound`; no Lean source
  contains `sorry`, `axiom`, `native_decide`, or compiled reflection.

## Build and check

Lean 4.33.1 (pinned in `tensor-core/lean-toolchain`). Python 3 standard library only.

```sh
cd tensor-core
lake build
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_features.py
python3 scripts/check_dot_products.py
python3 scripts/check_device.py
python3 scripts/check_device_formats.py
python3 scripts/check_programs.py
python3 scripts/check_certificates.py
python3 scripts/check_application.py
python3 scripts/check_eft.py
python3 scripts/check_clean_build.py
```

`lake exe tc_trace a0 b0 a1 b1 a2 b2 a3 b3 c` prints the exact trace of one V100 block; operands
are FP16 hex words and `c` is an FP32 hex word, without `0x`. `lake exe tc_features` evaluates
the parameterized profiles, descriptors, and constructed long dot products from a file of
commands (`canonical K extra floor words…`, `block profile words…`, `dot K extra floor words…`).

## Layout

```
tensor-core/
  TensorCore/Foundations   exact rationals, IEEE formats and decoding, FP32 and general conversion
  TensorCore/Semantics     profiles, raw products, block evaluator, machine accumulator,
                           generalized invocation evaluator
  TensorCore/Theory        residual identities, error bounds, rounding correctness, machine
                           refinement, parameterized contract, padding, floor inactivity,
                           scalar summation, non-monotonicity
  TensorCore/Programs      schedules, exact ledger, error budgets, ordered partitions, program AST,
                           checker, Algorithm 1 (EFT), instruction paths and conformance
  TensorCore/Applications  bounded ordered dot product and changing-state repetition
  TensorCore/Meta          tc%{ } syntax, tc_verify, tc_certify, tc_certificate, tc_inspect, tc_instruction
  TensorCore/Regression    kernel-checked witnesses
  examples/                runnable examples
  scripts/                 audit and validation
  data/regressions/        inputs, expected traces, reports
  vendor/                  pinned MATLAB v0.5 subset and the published device vectors
  docs/                    specification, theorem map, trust report, validation, plan
```

## Scope and limits

- The claimed family is FP16 products with FP32 c and output, c in the common alignment,
  any product count, any number of extra alignment bits, and one FP32 truncation. The
  generalized `InvocationSpec` also describes BF16, TF32, FP64-FMA, and FP16-output variants
  as executable specifications with exact loss accounting; the BF16 and TF32 descriptors
  match published vectors, but they have no rounding-correctness proofs and are not claimed.
- Aligned single invocations permit `K = 0`; fused specifications require `K = 1`.
  The public dot-product wrapper requires positive group width and finite initial c even
  for empty inputs. Low-level `runBlocks` retains its empty-list no-op.
- NaN and infinity inputs are rejected. Accumulators above `maxFinite32` are rejected rather
  than saturated; no overflow policy is claimed.
- `scalarCorrected` and `tceft` check the sufficient predicate and return `none`
  when it fails. `scalarCorrectedUnchecked` remains an explicitly unsafe diagnostic
  for the preserved counterexamples. Extraction and predicate evaluation still use
  exact reference arithmetic. Bounded multiplication/split primitives are proved;
  encoded extraction, overlap, guard, consolidation, and a success-family theorem
  remain open.
- Schedules execute the supplied order and feed each FP32 output to the next call. An
  instruction path fixes the contiguous increasing-k grouping the reference software uses;
  theorems about a real device take conformance to that path as an explicit premise, and no
  proof asserts it. See [docs/COMPOSITION.md](tensor-core/docs/COMPOSITION.md).
- The bounded-dot theorem is an accuracy result for the supplied normalization-group
  schedule, with an independently decoded ideal. It does not prove a CUDA kernel, matrix
  memory layout, or hardware conformance. Its absolute bound is deliberately conservative;
  no relative-error guarantee is made near cancellation.
- Device agreement is separate empirical evidence. No GPU was run for this project;
  new device experiments are optional and do not block this paper-based formalization.

## Sources

| Source | Pin |
| --- | --- |
| Khattak and Mikaitis, *Accurate Models of NVIDIA Tensor Cores*, arXiv:2512.07004v4 | `2512.07004v4.pdf`, SHA-256 `20c0594f…8fdee4` |
| *TC-EFT: Characterizing and Correcting Tensor Core Arithmetic*, revised | `tc-eft-corrected.pdf`, SHA-256 `e9b19e97…497b3e` |
| MATLAB Tensor Core v0.5 | commit `bbcf00a273868172494eaacaa8d6128ab0fb8704` |

Full hashes and every numerical decision are in
[docs/SPECIFICATION.md](tensor-core/docs/SPECIFICATION.md).

## Documentation

- [SPECIFICATION](tensor-core/docs/SPECIFICATION.md): pinned sources and numerical decisions
- [THEOREM_MAP](tensor-core/docs/THEOREM_MAP.md): contracts, declarations, domains
- [ASSUMPTIONS](tensor-core/docs/ASSUMPTIONS.md): trust boundary and open obligations
- [VALIDATION](tensor-core/docs/VALIDATION.md): oracle, device, and program checks
- [DSL](tensor-core/docs/DSL.md): program language and verification commands
- [COMPOSITION](tensor-core/docs/COMPOSITION.md): how invocations compose inside instructions and across calls
- [FEATURE_COVERAGE](tensor-core/docs/FEATURE_COVERAGE.md): feature matrix for the other tensor-core paths
- [INVOCATION_CONTRACT](tensor-core/docs/INVOCATION_CONTRACT.md): target interface for the parameterized invocation
- [PLAN / Fable handoff](tensor-core/docs/PLAN.md): verified status, prioritized fixes, acceptance criteria, and requirements against superficial fixes
