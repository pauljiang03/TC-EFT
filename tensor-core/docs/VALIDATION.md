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

In R3 alignment loses 2^-24 and output truncation loses 7 · 2^-23. R4 records a corrected
expectation: `1 − 3·2^-25` is a midpoint and rounds to `3f7ffffe`, the even neighbor. Other
cases cover even and odd ties, a carry into the next binade, the subnormal boundary,
cancellation, positive and negative zero, subnormal operands and c, nonfinite and malformed
inputs, range rejection, one extra alignment bit changing an output, and the Ampere and
Hopper profiles on a block of ones.

The two-invocation case feeds R3's `4107ffff` into a group that subtracts 17/2. The final
encoded result is `b5800000` (−2^-20); the exact ledger of 15 · 2^-24 recovers −2^-24, and
`two_block_corrected` checks the executable correction returns `b3800000`. The
arbitrary-length ledger theorem is an induction, not a generalization of this test.

The converter proof is separate from these cases: `round32_nearestEven_correct` holds for all
rational inputs with magnitude at most `maxFinite32`.

## Independent oracles

`python3 scripts/validate.py` checks 715 V100 blocks and 2,918 rounding inputs with seed
20260905 and reports zero mismatches; three deliberately nonfinite blocks are rejected. The
record is `data/regressions/validation-report.json`, and the named traces must match
`data/regressions/expected-traces.json`.

The oracle has its own IEEE field decoder and forms the ideal sum from input bits with
Python `Fraction`. It aligns every V100 term on the fixed integer grid 2^-149 with magnitude
integer division, finds FP32 neighbors by binary search over the positive encodings, and
compares exact distances and encoding parity. It never calls the Lean exponent logic and never
uses the recovered value as the ideal.

`python3 scripts/check_features.py` checks the parameterized evaluator (`tc_features`) with
a second exact oracle over 111 combinations of product count (`1, 3, 4, 7, 8, 16, 17, 37, 64`),
extra bits (`0, 1, 2, 5, 9, 24`), and floor (none, −132, 4): 1,783 cases, 3 rejections, zero
mismatches, then replays the V100 vectors through the new API. The record is
`data/regressions/feature-report.json`.

Samples span all finite exponent fields, signed products, opposite-product cancellation,
subnormal multiplicands, subnormal c, boundary encodings, and similar-scale cancellation.
Rounding samples include exact points, quarter points, midpoints, both signs, every normal
exponent boundary, gradual underflow, and out-of-range rejection. This is differential
testing, not exhaustive validation.

## Three comparisons

| Comparison | Evidence |
| --- | --- |
| Implementation against reference | Value bridges for raw products and accumulation; exact residual and schedule theorems; rounding and error-bound proofs; machine-width refinement. No optimized machine implementation yet. |
| Model against an independent implementation | Two Python oracles agree on retained sums, outputs, residual traces, and corrected results. |
| Correction against an independent ideal | Direct original-bit sum and nearest-neighbor oracle; the recovery identity is proved separately. |
| Model against device | 15,000 published FP16 vectors across V100, A100, and H100 match bit for bit. No new measurements. |

Recovery alone cannot detect a wrong alignment model, because the extractor reconstructs the
exact difference whatever the output is. The alignment and output comparisons are therefore
made independently of the device comparison.

## Device vectors

`python3 scripts/check_device.py` and `python3 scripts/check_device_families.py` replay the
unmodified `model_validation/{V100,A100,H100}/fp16` files of MATLAB Tensor Core v0.5
(hashes in `vendor/SOURCES.json`). `Validate_TC_models.m` reshapes A and B into rows of
`K = N_FMA` and calls the model once per row with one FP32 c, so one row is one group and one
evaluator call. The CUDA harness placed those `K` products in k positions `0..K−1` of one
WMMA instruction with zeros elsewhere. Multiplicands are FP32 words holding FP16 values and
are converted exactly; the scripts fail if a word is not an FP16 value. Records are
`data/regressions/device-report.json` and `data/regressions/device-families-report.json`.

| Family | Profile | Vectors | Mismatches | Rows with a zero or subnormal operand or c |
| --- | --- | ---: | ---: | ---: |
| V100 | `fp16Fp32Profile 4 0 none` | 5,000 | 0 | 0 |
| A100 | `fp16Fp32Profile 8 1 (−132)` | 5,000 | 0 | 1 |
| H100 | `fp16Fp32Profile 16 2 (−133)` | 5,000 | 0 | 5 |

V100 coverage detail from `check_device.py`:

| Quantity | Count |
| --- | ---: |
| Blocks with alignment loss | 3,275 |
| Blocks with output truncation loss | 1,326 |
| Blocks with both losses | 833 |
| Blocks with mixed-sign terms | 4,689 |
| Blocks with a product significand in [2, 4) | 4,704 |
| Blocks whose alignment exponent comes from c alone | 647 |
| Blocks where the correctly rounded sum differs from the device output | 1,885 |

Zero and subnormal branches therefore rest almost entirely on the MATLAB source. The
FP16-output files `d_*_fp16.txt` are vendored but not compared because that path is not
implemented. These are measurements published with the reference model, one group per row;
they do not test the order of groups inside an instruction.

## Program language

`python3 scripts/check_programs.py` compiles `examples/Verify.lean`, checks the displayed
AST, source sites, results, and theorem dependencies, then compiles ten invalid examples
separately: malformed groups, oversized operand and initial literals, wrong operand format,
nonfinite operands or initial state, final range rejection, unsupported operations, an
unresolved symbolic condition, and an invalid supplied proof. Each must fail, and the failed
verification names must be absent from the environment. The record is
`data/regressions/program-report.json`.

Imported regressions separately check DSL operand order, nested loops, the two-block
corrected result, zero iterations, failure location and index, and an arbitrary-count loop
theorem proved by induction and supplied to the command.

## Reproducibility

```sh
cd tensor-core
lake build
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_features.py
python3 scripts/check_device.py
python3 scripts/check_device_families.py
python3 scripts/check_programs.py
python3 scripts/check_clean_build.py
```

`check_clean_build.py` copies the source without `.lake`, builds it, runs the audit and the
program checks, and writes `data/regressions/clean-build.json`. With the pinned toolchain
installed, no network access is needed.
