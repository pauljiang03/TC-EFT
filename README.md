# tc-lean-mp

Machine-checked reference semantics for NVIDIA tensor-core dot products, in Lean 4.

The model follows *Accurate Models of NVIDIA Tensor Cores* (Khattak and Mikaitis,
arXiv:2512.07004v4) and its MATLAB Tensor Core v0.5 release, and formalizes the arithmetic
results of *TC-EFT: Characterizing and Correcting Tensor Core Arithmetic*. The claimed family
is FP16 products with an FP32 accumulator, parameterized by the number of products per group
and the number of extra alignment bits, which covers the V100, Ampere/Ada, and
Hopper/Blackwell FP16 paths. All arithmetic is exact (`Int`, `Rat`); there are no external
Lean dependencies and no native `Float`.

## The modeled operation

One invocation is one dot product `S = c + Σ aᵢ·bᵢ`, computed the way the hardware does:

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
| Scalar EFT: naive FP32 summation is exact under the coefficient bound, and Algorithm 1's scalar branch returns the correctly rounded dot product (TC-EFT IV.7–IV.11) | `naiveSum32_exact`, `scalarCorrected_correct`, `tceft_correct` |
| Non-monotonicity as a theorem over `K` and padding `p`: lowering the accumulator from `1` to `1 − 2^-24` raises the output exactly when `K ≥ 3·2^p` (TC-EFT III.4) | `nonmonotone_perturbation`, `nonmonotone_encoded` |
| Exact residual ledger over any finite chain through encoded FP32 boundaries; composed uncorrected error bound; machine equivalence through schedules | `runBlocks_residual_ledger`, `runBlocks_uncorrected_error`, `fp16Fp32_schedule_machine_eq` |
| Ordered partition of a long dot product with proved ideal preservation and tail padding | `OrderedPartition.uncorrected_error`, `canonicalPartition_ideal` |
| Program checker soundness | `Program.vc_sound` |
| R1–R4, Table III, EFT examples, rounding boundaries, rejections | `Regression.*` |

The rounding theorem is a general proof over all rationals with magnitude at most
`maxFinite32`, not a test. Concrete regressions are decided by kernel reduction of the actual
evaluator (`decide +kernel`).

## What is tested

- `scripts/validate.py`: an independent Python oracle agrees with the V100 evaluator on 715
  blocks and 2,918 rounding inputs.
- `scripts/check_features.py`: a second oracle agrees with the parameterized evaluator on
  1,985 cases over 129 combinations of product count, extra bits, and floor, and replays the
  published V100, A100, and H100 FP16 vectors: 5,000 rows each, zero mismatches.
- `scripts/check_dot_products.py`: constructed long dot products with partial tails, every
  encoded boundary and error budget compared: 278 cases over 25 configurations.
- `scripts/check_device_formats.py`: the published A100 and H100 BF16 and TF32 vectors
  match the deferred-format descriptors, 5,000 rows each. Evidence only; no proofs for those
  formats are claimed.
- `scripts/check_programs.py`: the DSL example compiles and ten malformed programs are rejected.
- `scripts/check_axioms.py`: 201 theorem roots depend only on `propext`, `Classical.choice`,
  and `Quot.sound`; the sources contain no `sorry`, `axiom`, `native_decide`, or compiled
  reflection.

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
                           checker, Algorithm 1 (EFT)
  TensorCore/Meta          tc%{ } syntax, tc_verify, tc_inspect
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
- NaN and infinity inputs are rejected. Accumulators above `maxFinite32` are rejected rather
  than saturated; no overflow policy is claimed.
- The scalar EFT is proved for the paper's left-to-right naive summation on values; a
  machine implementation of the residual extraction is not modeled.
- Schedules execute the supplied order and feed each FP32 output to the next call. How an
  instruction groups its k dimension is an empirical question; see
  [docs/COMPOSITION.md](tensor-core/docs/COMPOSITION.md).
- Device agreement is evidence, not a theorem. No GPU was run for this project.

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
- [PLAN](tensor-core/docs/PLAN.md): status, assessment, next steps, known issues
