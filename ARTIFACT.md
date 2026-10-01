# Reviewer guide

This artifact contains the Lean formalization, executable TC model and TC-EFT algorithm, and validation data supporting the paper. Use this guide to check the main claims; the [theorem index](TensorCore/THEOREMS.md) and [FloatLib correspondence](floatlib-port/COMPARISON.md) give the detailed proof map and hypotheses.

Install elan, Python 3, and Git as described in the [build instructions](README.md#build-and-run). Each Lean project uses its own pinned toolchain. Run the commands below from the repository root, with Python assertions enabled (no `-O` or `PYTHONOPTIMIZE`). The checks require no MATLAB, CUDA, or GPU.

## 1. Smoke check

```sh
lake build
lake env lean examples/GettingStarted.lean
lake env lean examples/NonMonotonicity.lean
```

All three commands must exit successfully. The three numerical results from `GettingStarted.lean`, decoded as FP32 values, are:

| Calculation | FP32 value |
| --- | --- |
| Four products of one | `4.0` |
| TC model with four tiny products and C = 1 | `1.0` |
| EFT correction of the tiny-product result | `1.0000002384185791015625 = 1 + 2^-22` |

The executable prints encoded results; `Except.ok` indicates success and `some` indicates that an optional result is present. The table shows their floating-point values. The file checks these outputs with proof assertions.

`NonMonotonicity.lean` decreases the accumulator from `1.0` to `0.999999940395355224609375 = 1 - 2^-24`, while the model output rises from `1.0` to `1.00000011920928955078125 = 1 + 2^-23`. Both EFT-corrected outputs are `1.0000002384185791015625 = 1 + 2^-22`: the first exact sum is already representable, and the second is a midpoint that nearest-even rounding maps to the same FP32 value. The file checks these assertions and prints the general theorem types.

## 2. Paper claims and evidence

Run the individual commands after the smoke build. Lean files check their proof assertions and may finish without printing output; a successful check exits with code zero.

| Paper claim | Proof or data to inspect | Review command |
| --- | --- | --- |
| Consistency of finite binary encodings, including subnormals and signed zero | [`signedFiniteBinaryBijection`](TensorCore/Numerics/Binary/SignedBijection.lean) and its inverse laws | `lake env lean examples/BinaryFoundation.lean` |
| TC block model and total output error bound | [`PaperSpec.supported_eq_paper`](TensorCore/TC/Specification/Supported.lean); [`evalBlock_error_bound`](TensorCore/TC/ErrorBounds.lean) | `python3 scripts/check_paper_spec.py` |
| Hardware conditions for non-monotonicity and the perturbation range | [`nonmonotone_encoded`](TensorCore/TC/Monotonicity.lean); [`nonmonotone_range_encoded`](TensorCore/TC/MonotonicityRange.lean) | `lake env lean tests/TensorCoreTests/TC/Monotonicity.lean` |
| Exact Sum Recovery | [`overlap_recovery`](TensorCore/EFT/Extraction.lean) | `lake env lean tests/TensorCoreTests/EFT/EFT.lean` |
| Precondition for Correct Rounding and its application to TC-EFT | [`ExtractionGrid.eq20_scalarPredicate`](TensorCore/EFT/ExtractionGrid.lean); [`scalarCorrected_correct`](TensorCore/EFT/Extraction.lean); [`algorithm1Encoded_correct`](TensorCore/EFT/Encoded.lean) | `python3 scripts/check_eft.py` |
| Bitwise agreement with all 35,000 published validation cases | [Pinned source hashes](vendor/SOURCES.json) and [recorded inputs/outputs](vendor/matlab-tensor-core-v0.5/model_validation/) | `python3 scripts/check_features.py` followed by `python3 scripts/check_device_formats.py` |
| Correspondence between the first-principles and FloatLib implementations | [`paper_one_to_one`](floatlib-port/TCFloat/Equivalence/Representations.lean) and `paper_one_to_one_inverse` | Run the FloatLib commands in section 3 |

The reviewed TC paths use FP16, BF16, or TF32 operands and FP32 outputs. The scalar correctness results require the stated grid, coefficient-budget, representability, and range premises. The reference algorithm also provides exact accumulation when its scalar guard fails. Hardware evidence consists of replaying recorded GPU outputs; the universal proofs concern the defined model under their hypotheses. The [theorem index](TensorCore/THEOREMS.md) also identifies the bounded backend and native FP32 refinement proofs.

## 3. Full validation

For the first-principles implementation:

```sh
python3 scripts/check_clean_build.py
```

This creates a source snapshot without a build cache, checks the proofs and allowed axioms, runs exact-arithmetic comparisons and recorded-vector replay, and checks the examples, documentation, and layout. Expected evidence is `success: true` in [data/regressions/clean-build.json](data/regressions/clean-build.json), zero numerical mismatches, and an audit permitting only `propext`, `Classical.choice`, and `Quot.sound`. The command regenerates the reports under `data/regressions/`.

For the independent FloatLib implementation, run this block from the repository root:

```sh
(
  set -e
  cd floatlib-port
  python3 scripts/check_all.py
  python3 scripts/check_equivalence.py
)
```

`check_all.py` builds the universal equivalence proofs, audits executable independence and allowed axioms, and runs the numerical suites. It must print `All FloatLib-port checks passed.` and write `status: passed` in `floatlib-port/test-results/summary.json`. The direct comparator then checks 115,029 command observations and 668,944 decoding cases, with zero mismatches and a passing comparator negative control in `floatlib-port/test-results/equivalence/report.json`. Run the commands in this order because the comparator uses generated test inputs. The finite comparisons supplement the universal equivalence proofs.

Any failed proof, process, comparison, or negative control stops its runner with a nonzero exit code. See the [test walkthrough](tests/README.md) for individual suites, input formats, and failure behavior.
