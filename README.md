# tc-lean-mp

Machine-checked reference semantics for NVIDIA tensor-core dot products, in Lean 4.

The model follows *Accurate Models of NVIDIA Tensor Cores* (Khattak and Mikaitis,
arXiv:2512.07004v4) and its MATLAB Tensor Core v0.5 release. The implemented and
validated path is the V100 FP16 → FP32 normalization group. All arithmetic is exact
(`Int`, `Rat`); there are no external Lean dependencies and no native `Float`.

## The modeled operation

One invocation is one dot product `S = c + Σ aᵢ·bᵢ`, computed the way the hardware does:

1. Decode each operand to a signed integer significand and a raw scale. Subnormals keep
   their explicit fraction and the minimum normal scale.
2. Multiply significands and add scales. Products are not renormalized: `1.5 × 1.5` and
   `1 × 2.25` have the same value but different raw scales, and can produce different outputs.
3. Take the alignment exponent η as the maximum raw scale over the nonzero terms, including
   c, then apply the profile's floor if it has one.
4. Truncate every term toward zero onto the grid `qA = 2^(η−F)` and sum the integer
   coefficients exactly.
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
| R1–R4 witnesses, rounding boundaries, rejections, non-monotonicity | `Regression.*` |

The rounding theorem is a general proof over all rationals with magnitude at most
`maxFinite32`, not a test. Concrete regressions are decided by kernel reduction of the actual
evaluator (`decide +kernel`).

## What is tested

- `scripts/validate.py`: an independent Python oracle (separate IEEE decoder, fixed 2^-149
  integer grid, binary-search nearest neighbor) agrees with the Lean evaluator on 715 blocks
  and 2,918 rounding inputs.
- `scripts/check_device.py`: the 5,000 V100 FP16/FP32 vectors published with MATLAB Tensor
  Core v0.5 match the evaluator bit for bit. Those vectors contain no zero or subnormal operands.
- `scripts/check_programs.py`: the DSL example compiles and ten malformed programs are rejected.
- `scripts/check_axioms.py`: 83 theorem roots depend only on `propext`, `Classical.choice`,
  and `Quot.sound`; the sources contain no `sorry`, `axiom`, `native_decide`, or compiled
  reflection.

## Build and check

Lean 4.33.1 (pinned in `tensor-core/lean-toolchain`). Python 3 standard library only.

```sh
cd tensor-core
lake build
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_device.py
python3 scripts/check_programs.py
lake env lean examples/Verify.lean
```

`lake exe tc_trace a0 b0 a1 b1 a2 b2 a3 b3 c` prints the exact trace of one block. Operands are
FP16 hex words and `c` is an FP32 hex word, without `0x`.

## Layout

```
tensor-core/
  TensorCore/Foundations   exact rationals, IEEE field decoding, FP32 conversion
  TensorCore/Semantics     profile, raw products, block evaluator
  TensorCore/Theory        residual identities, error bounds, rounding correctness
  TensorCore/Programs      schedules, exact ledger, program AST, checker
  TensorCore/Meta          tc%{ } syntax, tc_verify, tc_inspect
  TensorCore/Regression    kernel-checked witnesses
  examples/                runnable DSL examples
  scripts/                 audit and validation
  data/regressions/        inputs, expected traces, reports
  vendor/                  pinned MATLAB v0.5 subset and V100 vectors
  docs/                    specification, theorem map, trust report, validation, roadmap
```

## Scope and limits

- Only V100 FP16 → FP32 is instantiated. `Profile` varies the input format, product count,
  alignment fraction, and floor; c and the output are fixed to FP32, and the output stage is a
  single truncation.
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
- [ROADMAP](tensor-core/docs/ROADMAP.md): status, next work, known issues
