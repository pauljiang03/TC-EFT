# tc-lean-mp

Machine-checked reference semantics for NVIDIA tensor-core dot products, in Lean 4.

The model follows *Accurate Models of NVIDIA Tensor Cores* (Khattak and Mikaitis,
arXiv:2512.07004v4) and its MATLAB Tensor Core v0.5 release. The implemented and validated
family is FP16 products with an FP32 accumulator, parameterized by the number of products
per group and the number of extra alignment bits, which covers the V100, Ampere/Ada, and
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
| Raw products preserve value | `rawProduct_value` |
| Alignment residual is strictly below the grid | `alignment_residual` |
| Exact recovery for any supplied output | `block_residual_identity`, `evalBlock_residual_identity` |
| Two-stage error bound `abs(S − D) < n·qA + qD` | `block_error_bound`, `evalBlock_error_bound` |
| Nearest-even FP32 conversion is correct for every rational in range | `round32_nearestEven_correct`, `finalRound_correct` |
| Corrected output is the correctly rounded exact sum | `evalBlock_corrected_correct`, `runBlocks_corrected_correct` |
| Exact residual ledger over any finite chain of invocations through encoded FP32 boundaries | `runBlocks_residual_ledger` |
| Program checker soundness | `Program.vc_sound` |
| Contract for any product count and extra alignment bits, with a signed machine-width refinement | `fp16Fp32_contract`, `evalBlock_machineAccumulator` |
| Floors at or below −126 are inactive on FP16 paths | `canonical_eta_floor_inactive` |
| Generalized invocation evaluator: exact loss accounting and bitwise agreement with the original evaluator | `evalInvocation_recovery`, `v100_invocation_bits` |
| R1–R4 witnesses, rounding boundaries, rejections, non-monotonicity, extra-bit sensitivity | `Regression.*` |

The rounding theorem is a general proof over all rationals with magnitude at most
`maxFinite32`, not a test. Concrete regressions are decided by kernel reduction of the actual
evaluator (`decide +kernel`).

## What is tested

- `scripts/validate.py`: an independent Python oracle (separate IEEE decoder, fixed 2^-149
  integer grid, binary-search nearest neighbor) agrees with the V100 evaluator on 715 blocks
  and 2,918 rounding inputs.
- `scripts/check_features.py`: a second oracle agrees with the parameterized evaluator on
  1,783 cases over 111 combinations of product count, extra bits, and floor.
- `scripts/check_device.py` and `scripts/check_device_families.py`: the FP16 vectors
  published with MATLAB Tensor Core v0.5 match bit for bit: 5,000 rows each for V100
  (`K = 4`), A100 (`K = 8`, 1 extra bit), and H100 (`K = 16`, 2 extra bits). Each row is one
  group; the vectors contain almost no zero or subnormal operands.
- `scripts/check_programs.py`: the DSL example compiles and ten malformed programs are rejected.
- `scripts/check_axioms.py`: 117 theorem roots depend only on `propext`, `Classical.choice`,
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
python3 scripts/check_device.py
python3 scripts/check_device_families.py
python3 scripts/check_programs.py
lake env lean examples/Verify.lean
```

`lake exe tc_trace a0 b0 a1 b1 a2 b2 a3 b3 c` prints the exact trace of one V100 block; operands
are FP16 hex words and `c` is an FP32 hex word, without `0x`. `lake exe tc_features` does the
same for the parameterized profiles from a file of `canonical K extraBits floor words...` rows.

## Layout

```
tensor-core/
  TensorCore/Foundations   exact rationals, IEEE formats and decoding, FP32 and general conversion
  TensorCore/Semantics     profiles, raw products, block evaluator, generalized invocation evaluator
  TensorCore/Theory        residual identities, error bounds, rounding correctness, machine width,
                           parameterized contract, floor inactivity
  TensorCore/Programs      schedules, exact ledger, program AST, checker
  TensorCore/Meta          tc%{ } syntax, tc_verify, tc_inspect
  TensorCore/Regression    kernel-checked witnesses
  examples/                runnable DSL examples
  scripts/                 audit and validation
  data/regressions/        inputs, expected traces, reports
  vendor/                  pinned MATLAB v0.5 subset and V100, A100, H100 FP16 vectors
  docs/                    specification, theorem map, trust report, validation, plan
```

## Scope and limits

- The claimed family is FP16 products with FP32 c and output, c in the common alignment,
  any product count, any number of extra alignment bits, and one FP32 truncation. The
  generalized `InvocationSpec` can also describe BF16, TF32, FP64-FMA, and FP16-output
  variants as executable specifications with exact loss accounting, but they have no
  rounding-correctness proofs beyond FP32 and no device evidence, and are not claimed.
- NaN and infinity inputs are rejected. Accumulators above `maxFinite32` are rejected rather
  than saturated; no overflow policy is claimed.
- Residual correction uses exact rational arithmetic. The scalar floating-point EFT of the
  TC-EFT paper is not formalized.
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
