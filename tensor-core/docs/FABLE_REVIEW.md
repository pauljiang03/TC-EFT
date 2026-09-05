# Fable work review — 5 September 2026

This records the arithmetic review before the DSL increment. Current frontend
capabilities and verification totals are in [status](STATUS.md).

Reviewed commits `ce7954f` (published device-vector comparison) and `c20e688`
(profile generalization), plus the uncommitted encoding and rounding work
present at the start of this review. The committed changes were useful and
are retained. The incoming working tree did not build and had changed the
declared range contract; both issues are repaired.

## Findings and changes

| Finding | Resolution |
| --- | --- |
| `Theory/Encoding.lean` failed to compile where simplification changed integer-to-natural casts into `max` expressions. | Proved the required nonnegativity facts and controlled simplification; retained the encoding proof structure. |
| The uncommitted converter removed `absQ x > maxFinite32` rejection, changed the oracle and regression to accept some out-of-range values, and described the result as IEEE overflow handling. This contradicted the frozen specification. | Kept the refactored bounded conversion as `round32Core`, restored the public finite-range guard and independent oracle guard, expanded rejection checks, and removed the unsupported overflow claim. The additional eight boundary inputs are retained. |
| New rounding foundations had no completed end-to-end nearest-value theorem, and status/theorem documentation still described the original V100-specific API. | Completed the general rounding and error proofs, connected them to generic block/schedule evaluation, imported every new module from the root, expanded the audit, and refreshed the documentation. |
| Profile generalization preserved raw scales, encoded call boundaries, and the existing V100 parameters. | Retained it. Generic algebraic proofs apply to its parameters; no additional architecture is claimed. |
| The device reader compares one four-product normalization group per row and requires exact conversion of FP32-stored FP16 operands. | Retained it and reproduced all 5,000 bitwise matches. All 15 vendored file hashes were checked against the source manifest. Zero and subnormal operand/c coverage is absent and remains documented. |

## Completed continuation

`Theory/Encoding.lean` proves finite-value coverage and bounded encoding
value/parity/quantum preservation. `Theory/Rounding.lean` supplies integer RNE,
exponent, and grid lemmas. `Theory/ConversionBounds.lean` proves the chosen
exponent and significand fit a finite output, including a carry.

`Theory/CorrectRounding.lean` proves the independent `NearestEven32` contract:
the returned bits decode to a finite value no farther from the input than any
finite FP32 value, with even encoding parity at a tie between distinct values.
The proof covers every rational input in the explicit finite range, including
zero, signs, subnormals, and binade boundaries. It is not inferred from device
agreement or numerical regressions.

`Theory/ErrorBounds.lean` proves strict output truncation loss and the two-stage
block bound, including c in the alignment term count. `Programs/Correction.lean`
connects mathematical rounding to exact block recovery and the arbitrary finite
schedule ledger. The executable two-block correction is also kernel-checked.

## Verification and remaining scope

- `lake build`: passes, 41 targets.
- Fresh source copy with no build cache: builds and passes the 62-root audit.
- Independent oracle: 715 blocks, 2,918 rounding inputs, zero mismatches;
  three deliberately nonfinite blocks rejected.
- Published V100 device vectors: 5,000 rows, zero bit mismatches or model errors.
- Axiom audit: only `propext`, `Classical.choice`, and `Quot.sound` allowed;
  no unfinished proof terms or compiled reflection.

Residuals and their consolidation still use exact rational arithmetic. The
nearest-even theorem does not establish scalar residual representability,
machine-width accumulation, optimized overlap extraction, or hardware
conformance. The next work is explicit residual support/representation bounds
and the scalar consolidation contract, as recorded in [status](STATUS.md).
