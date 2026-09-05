# Validation record

## Checked Lean results

`lake build` checks every imported regression theorem and generic proof.
R1a/R1b, R2 and R3 compare complete derived traces against exact expected
scales, signed coefficients, ideal sum, accumulator, per-term alignment
residuals, output residual, total residual, and corrected output bits.
Term order in snapshots is c first, then products; scales list products only.

| Case | V100 output | Corrected FP32 output | Total exact residual |
| --- | --- | --- | --- |
| R1a | `40100001` | `40100001` | 0 |
| R1b | `40100000` | `40100001` | 2^-22 |
| R2 | `40300801` | `40300801` | 0 |
| R3 | `4107ffff` | `41080000` | 15 * 2^-24 |

In R3, alignment loses 2^-24 and output truncation loses 7 * 2^-23.
R4 corrects the handoff midpoint error: `1-3*2^-25` rounds to `3f7ffffe`.
Other checked cases cover even/odd ties, binade carry, the subnormal/normal
boundary, cancellation, positive/negative zero, subnormal operands/c,
exceptional input rejection, malformed block shape, and range rejection.

The two-invocation case feeds R3's actual `4107ffff` into a block subtracting
17/2. The final encoded result is `b5800000` = -2^-20. The exact ledger is
15 * 2^-24, recovering -2^-24. The arbitrary-length theorem is an induction,
not a generalization inferred from this two-call test.
`two_block_corrected` also checks the executable schedule correction returns
`b3800000`, the encoding of that recovered value.

The general converter proof is now separate from these concrete checks:
`round32_nearestEven_correct` establishes finite output existence, nearest
finite-value selection, and even encoding parity at ties for all rational
inputs with magnitude at most `maxFinite32`. Corrected block/schedule theorems
combine it with exact residual recovery. `evalBlock_error_bound` separately
proves the alignment-plus-output error bound for successful model calls.

## Independent exact oracle

`python3 scripts/validate.py` checks 715 blocks and 2,918 rational rounding
inputs with deterministic seed 20260905. It reports **zero mismatches**;
three intentionally nonfinite blocks are explicitly rejected.
The machine-readable record is `data/regressions/validation-report.json`.

The oracle has a separate IEEE field decoder and forms ideal sums directly
from input bits using Python `Fraction`. For alignment it places all V100
terms on the fixed integer grid 2^-149 and uses magnitude integer division.
It finds lower/upper FP32 neighbors by binary search over positive encodings,
then compares exact distances and encoding parity. It does not call Lean's
logarithm/exponent converter or use the recovered value as its ideal sum.

Samples span all finite exponent fields, signed products, opposite-product
cancellation, subnormal multiplicands, and subnormal c. Rounding samples
include exact points, quarter points, midpoints, both signs, every normal
exponent boundary, gradual underflow, and explicit out-of-range rejection.
Eight additional inputs exercise the finite-range boundary and rejection on
both signs. This deterministic differential test supplements the general
conversion proof; it is not exhaustive validation.

## Three comparisons

| Comparison | Current evidence |
| --- | --- |
| Implementation / reference | Raw-product and accumulation value bridges; exact executable residual and schedule theorems; mathematical FP32 rounding and two-stage model-error proofs. No optimized machine implementation yet. |
| Model / independent numerical implementation | Separate Python integer-grid oracle agrees on retained sums, outputs, residual traces and corrected results. |
| Correction / independent ideal sum | Direct original-bit IEEE sum and nearest-neighbor oracle; correction identity proved separately. |
| Model / device | 5,000 V100 GPU vectors from the v0.5 release match the evaluator bit for bit; see below. No new measurements were taken. |

Recovery alone would not detect an incorrect alignment model because the
extractor reconstructs the exact difference. The alignment and output
comparisons are therefore performed independently of the device comparison.

## Device vectors

`python3 scripts/check_device.py` replays the unmodified
`model_validation/V100/fp16` files of MATLAB Tensor Core v0.5 (hashes in
`vendor/SOURCES.json`). `Validate_TC_models.m` reshapes A and B into rows of
K=4 and calls the V100 model once per row with one FP32 c, so each row is one
normalization group and one `evalV100` call. Multiplicands are FP32 words
holding FP16 values and are converted exactly; the script fails if a word is
not an FP16 value. The device output `d_V100_fp32.txt` is compared bitwise.
The record is `data/regressions/device-report.json`.

| Quantity | Count |
| --- | ---: |
| Vectors compared | 5,000 |
| Bit mismatches or model errors | 0 |
| Blocks with alignment loss | 3,275 |
| Blocks with output truncation loss | 1,326 |
| Blocks with both losses | 833 |
| Blocks with mixed-sign terms | 4,689 |
| Blocks containing a product with significand in [2, 4) | 4,704 |
| Blocks whose alignment exponent comes from c alone | 647 |
| Blocks where the correctly rounded sum differs from the device output | 1,885 |

The vectors contain no zero or subnormal multiplicands and no zero or
subnormal c, so the subnormal decoder, the zero policy, and the all-zero block
remain model-only decisions reconciled with v0.5 source. The FP16-output file
`d_V100_fp16.txt` is vendored but not compared because that path is not
implemented. These are GPU measurements published with the reference model,
not measurements taken by this project, and they cover exactly one profile.

## Reproducibility

Run `lake build`, `python3 scripts/check_axioms.py`,
`python3 scripts/validate.py`, and `python3 scripts/check_device.py`. Run
`python3 scripts/check_clean_build.py` to build and audit a fresh source copy
with no `.lake` directory; it records `data/regressions/clean-build.json` and
keeps the log in `tmp/clean-build.log`. `validate.py` fails if the oracle
traces drift from the checked-in `expected-traces.json`. No external Lean
dependency downloads are needed once the pinned toolchain is installed.
The current fresh build checks 51 targets; the audit checks 83 theorem roots
against the standard Lean axiom allowlist.

## Program language and metaprogramming

`python3 scripts/check_programs.py` compiles `examples/Verify.lean`, exercises
`tc_verify`/`tc_inspect`, checks the displayed AST/source sites/results, and
checks the generated theorem dependencies. It then compiles ten intentionally
invalid examples separately. They cover malformed groups, oversized operand
and initial literals, wrong operand format, nonfinite operands/initial state,
final range rejection, unsupported operations, unresolved symbolic conditions,
and an invalid supplied proof. Each must fail; failed verification names must
remain absent. All checks pass; see `data/regressions/program-report.json`.

Imported Lean regressions separately check exact DSL input order, nested-loop
execution, the two-block corrected result, zero-iteration behavior, failure
source/index, and an arbitrary-count loop theorem using a proved invariant.
The symbolic theorem is proved by induction and supplied to the command; it
is not derived from finite enumeration. Final range rejection includes a case
where the model call succeeds at `maxFinite32` but the exact sum is
`maxFinite32 + 1`, outside the declared correction domain.

The fresh-build script now runs the frontend test script after the build and
audit, ensuring that the custom elaborator and generated proofs work in a
source copy without preexisting artifacts.
