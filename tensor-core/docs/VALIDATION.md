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

## Independent exact oracle

`python3 scripts/validate.py` checks 715 blocks and 2,910 rational rounding
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
This is deterministic differential testing, not exhaustive validation or a
parametric conversion-correctness proof.

## Three comparisons

| Comparison | Current evidence |
| --- | --- |
| Implementation / reference | Raw-product and accumulation value bridges; exact executable residual and schedule theorems. No optimized machine implementation yet. |
| Model / independent numerical implementation | Separate Python integer-grid oracle agrees on retained sums, outputs, residual traces and corrected results. |
| Correction / independent ideal sum | Direct original-bit IEEE sum and nearest-neighbor oracle; correction identity proved separately. |
| Model / device | No new measurements; controlling paper's evidence remains external. |

The fourth row makes the absent device comparison explicit. Recovery alone
would not detect an incorrect alignment model because the extractor reconstructs
the exact difference. The alignment and output comparisons are therefore
performed independently.

## Reproducibility

Run `lake build`, `python3 scripts/check_axioms.py`, and
`python3 scripts/validate.py`. Run `python3 scripts/check_clean_build.py` to
build and audit a fresh source copy with no `.lake` directory. The script saves
its log in `tmp/clean-build.log`. No external Lean dependency downloads are
needed once the pinned toolchain is installed.
