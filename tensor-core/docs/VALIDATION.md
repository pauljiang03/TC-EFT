# Validation

## Kernel-checked cases

`lake build` checks every regression theorem. R1a, R1b, R2, and R3 compare the complete
derived trace against explicit expectations: raw scales, signed coefficients, ideal sum,
accumulator, per-term alignment residuals, output residual, total residual, and corrected
bits. Traces list c first, then the products; scales list products only.

| Case | V100 output | Corrected output | Total residual |
| --- | --- | --- | --- |
| R1a | `40100001` | `40100001` | 0 |
| R1b | `40100000` | `40100001` | 2^-22 |
| R2 | `40300801` | `40300801` | 0 |
| R3 | `4107ffff` | `41080000` | 15 · 2^-24 |

R4 records a corrected expectation: `1 − 3·2^-25` is a midpoint and rounds to `3f7ffffe`.
Other cases cover ties, binade carries, the subnormal boundary, cancellation, both zeros,
subnormal operands and c, nonfinite and malformed inputs, range rejection, one extra alignment
bit changing an output, padding and range boundaries, an undersized machine width changing a
result, and the Ampere and Hopper profiles on a block of ones.

Composition cases: R3's `4107ffff` fed into a group that subtracts 17/2 returns `b5800000`,
the exact ledger recovers −2^-24, and the executable correction returns `b3800000`. Cancelling
the initial `1` before a `2^-24` contribution preserves it, while reversing the two groups
returns zero with the same ideal sum. Constructed partitions with partial tails and nonfinite
operands are checked, and the public error theorem is applied to them.

EFT cases (Algorithm 1 on a trace): R2 has extraction grid `2^-22`, low parts
`[0, 0, 2^-23, 2^-23, 0]`, overlap `2^-22`, and the scalar branch returns `40300801`. R3 has
extraction grid `2^-20`, one low part `15·2^-24`, zero overlap, and the scalar branch returns
`41080000`. The TC-EFT §V-D cancellation example returns `449fbe50` with low parts `5/16384`
and `15/8192`, and the scalar branch resolves the tie to `449fbe62`. A block with three
products near 128 next to a `2^-48` product exceeds the coefficient budget, so the predicate
fails and Algorithm 1 takes the exact-dyadic branch, returning `4e800003`.

Non-monotonicity: `K = 8` Ampere products `2^-12 · 2^-13` and `K = 16` Hopper products
`2^-12 · 2^-14` raise the output from `3f800000` to `3f800001` when c drops from `3f800000`
to `3f7fffff` (TC-EFT Table III); `K = 2` on V100 and `K = 11` on Hopper, below the
`3·2^p` thresholds, stay at `3f800000`.

Instruction paths: R3's four products padded with twelve zero pairs give `4107ffff` on the
whole V100 k = 16 path, the same as the single group; sixteen ones give `41800000` on both
the two-group Ampere path and the one-group Hopper path; on the Ampere path, cancelling the
accumulator `1` in the first group and adding `2^-24` in the second returns `33800000`, while
the reverse order returns `0` for the same exact dot product; and fifteen pairs on a k = 16
path are rejected.

The converter proof is separate from these cases: `round32_nearestEven_correct` holds for all
rational inputs with magnitude at most `maxFinite32`.

## Independent oracles

`python3 scripts/validate.py` checks 715 V100 blocks and 2,918 rounding inputs with seed
20260905 and reports zero mismatches; three deliberately nonfinite blocks are rejected. The
oracle has its own IEEE field decoder, aligns on the fixed grid 2^-149 with magnitude
integer division, and finds FP32 neighbors by binary search over the encodings. Records:
`data/regressions/validation-report.json` and `expected-traces.json`.

`python3 scripts/check_features.py` checks the parameterized evaluator with a second exact
oracle over 129 configurations of product count, extra bits, and floor: 1,985 cases, 15
intended rejections, zero mismatches. It then replays the published V100, A100, and H100
FP16 vectors and verifies the SHA-256 of every pinned source file. Record:
`data/regressions/feature-report.json`.

`python3 scripts/check_dot_products.py` checks constructed long dot products: 278 cases
across 25 configurations, including 160 partial tails and 103 nonzero-error cases, with four
intended rejections. Every encoded boundary and every error budget is compared with
`Fraction` arithmetic, using the unpadded original bits for the ideal. Record:
`data/regressions/dot-product-report.json`.

## Three comparisons

| Comparison | Evidence |
| --- | --- |
| Implementation against reference | Value bridges; exact residual and schedule theorems; rounding, error-bound, EFT, and monotonicity proofs; complete-result machine equivalence. |
| Model against an independent implementation | Two Python oracles agree on retained sums, outputs, residual traces, corrected results, and long-dot-product budgets. |
| Correction against an independent ideal | Direct original-bit sum and nearest-neighbor oracle; the recovery identity is proved separately. |
| Model against device | 35,000 published rows across seven device/format pairs match bit for bit. No new measurements. |

Recovery alone cannot detect a wrong alignment model, because the extractor reconstructs the
exact difference whatever the output is. The alignment and output comparisons are therefore
made independently of the device comparison.

## Device vectors

The vectors are the unmodified `model_validation` files of MATLAB Tensor Core v0.5, hashed
in `vendor/SOURCES.json`. `Validate_TC_models.m` reshapes A and B into rows of `K = N_FMA`
and calls the model once per row with one FP32 c, so one row is one group. The CUDA harness
placed those `K` products in k positions `0..K−1` of one WMMA instruction with zeros
elsewhere, so the rows do not test the order of groups inside an instruction. Multiplicands
are FP32 words holding FP16, BF16, or TF32 values and are converted exactly; the scripts fail
otherwise. Records: `device-report.json`, `feature-report.json`, `device-formats-report.json`.

| Device | Format | Profile or descriptor | Rows | Mismatches | Status |
| --- | --- | --- | ---: | ---: | --- |
| V100 | FP16 | `fp16Fp32Profile 4 0 none` | 5,000 | 0 | claimed, proved family |
| A100 | FP16 | `fp16Fp32Profile 8 1 (−132)` | 5,000 | 0 | claimed, proved family |
| H100 | FP16 | `fp16Fp32Profile 16 2 (−133)` | 5,000 | 0 | claimed, proved family |
| A100 | BF16 | `a100BF16Invocation` | 5,000 | 0 | descriptor evidence only |
| A100 | TF32 | `a100TF32Invocation` | 5,000 | 0 | descriptor evidence only |
| H100 | BF16 | `hopperBF16Invocation` | 5,000 | 0 | descriptor evidence only |
| H100 | TF32 | `hopperTF32WmmaInvocation` | 5,000 | 0 | descriptor evidence only |

Rows with a zero or subnormal operand or c: none on V100, one on A100 FP16, five on H100
FP16, none in the BF16/TF32 files. The BF16/TF32 alignment floors are therefore not
exercised, and the zero and subnormal branches rest on the MATLAB source. The FP16-output
files `d_*_fp16.txt` are vendored but not compared because that path is not implemented.

V100 coverage detail from `check_device.py`: 3,275 rows with alignment loss, 1,326 with
output truncation loss, 833 with both, 4,689 with mixed signs, 4,704 with a product
significand in [2, 4), 647 whose alignment exponent comes from c alone, and 1,885 where the
correctly rounded sum differs from the device output.

## Program language

`python3 scripts/check_programs.py` compiles `examples/Verify.lean`, checks the displayed
AST, source sites, results, and theorem dependencies, then compiles ten invalid examples
separately. Each must fail and the failed verification names must be absent from the
environment. It also checks that an unrelated earlier error in a file does not roll back a
later `tc_verify`, that `tc_instruction` prints the three pinned paths with their group
counts, and that an unsourced path name is refused. Record:
`data/regressions/program-report.json`.

## Reproducibility

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

`check_clean_build.py` copies the source without `.lake`, builds it, and runs the audit, the
program checks, the canonical and dot-product suites, the format evidence, and the standalone
examples. It writes `data/regressions/clean-build.json`. With the pinned toolchain installed,
no network access is needed.
