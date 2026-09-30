# FP32-output tensor-core arithmetic with FloatLib

This is an isolated Lean project inside `TC-EFT`. It independently implements the FP32-output TC block model and the reference TC-EFT algorithm using FloatLib. Its executable runtime imports no `TensorCore` modules. A separate proof layer imports hash-checked copies of the actual original definitions to prove universal equivalence. Building it does not change the parent project's toolchain, Lake configuration, source, or reports.

Start with the [folder guide](FOLDER_GUIDE.md) for the project layout, what the correctness claims mean, how transferred proofs work, and the verification commands.

Arithmetic/proof body reference revision: `990afac10b94a84f3de24743206756dd7acc3276`.
FloatLib dependency: `https://github.com/lean-dojo/FloatLib`, pinned to `0d91825727839f597fd06b22fdd038ea21480f0c`.
Lean: **4.34.0**; the parent project uses its own separate toolchain. The committed `lake-manifest.json` pins transitive dependencies.

## Build and run

Install [elan](https://github.com/leanprover/elan) and Python 3. No third-party Python packages, MATLAB, CUDA, or GPU are required for these checks. The first build needs network access to fetch Lean, FloatLib, mathlib, and their dependencies. Expect several GB of dependency/build storage.

From the repository root:

```sh
cd floatlib-port
python3 scripts/check_all.py
```

`check_all.py` first prepares the isolated, hash-checked original-source dependencies, then builds both the independent executable and all equivalence proofs. For a manual build, run `python3 scripts/prepare_reference.py` followed by `lake build`. The pinned manifest supplies the dependency revisions. No original source or build configuration is changed. The compatibility copy is generated under ignored `reference-compat/`; test outputs stay under ignored `test-results/`.

Individual checks:

```sh
lake env lean tests/Audit.lean
python3 scripts/check_features.py
python3 scripts/check_replay.py
python3 scripts/check_paper.py
python3 scripts/check_edges.py
python3 scripts/check_monotonicity.py
```

`check_all.py` builds, runs those checks, rejects unfinished proofs and forbidden proof shortcuts in the port, and writes `test-results/summary.json`. The Lean audit checks the transitive axioms of the port's public theorems; only `propext`, `Classical.choice`, and `Quot.sound` are allowed. It also checks that executable correction does not depend on TC model evaluation or the original-input ideal. A negative control deliberately violates that rule and must be rejected.

## Validation reports

Reproduce validation with `scripts/check_all.py`. Current reports and source hashes are generated under `test-results/summary.json`; the direct comparison writes `test-results/equivalence/report.json`.

The parent cleanup removes one unused application import from the reference dependency graph. `prepare_reference.py` compares every arithmetic and proof body to the pinned revision, accepts only documented module-path relocations and deletion of existing import lines, and copies the actual current parent sources. Its generated manifest records those deletions and the current source hashes.

## Direct comparison with the original

[COMPARISON.md](COMPARISON.md) maps the definitions and paper statements one by one. **`TCFloat.Equivalence.paper_one_to_one` is a universal Lean theorem**: the two encoded interfaces agree on TC bits, EFT bits and branches, and validation errors for every encoded input in the paper's FP16/BF16/TF32 profile family and every supplied D. `inputEquiv` and `paper_one_to_one_inverse` supply the two-way input correspondence. `round32_eq` proves the actual converters agree for every rational input in both RTZ and RNE modes.

The theorem concerns checked encoded inputs and consistent/canonical numerical representations; it does not identify arbitrary raw `Term` or `Trace` records. See the comparison for the precise scope and inverse laws. Direct differential tests additionally compare command observations and exhaustive FP16/BF16/TF32 decoder cases against a snapshot of the current parent sources. Reproduce with `python3 scripts/check_equivalence.py` after `check_all.py`.

## What FloatLib supplies

* `FloatFormat.binary16`, `bfloat16`, `tf32`, and `binary32` describe the actual encodings.
* `Model.toDyadic?` rejects nonfinite values and decodes finite words exactly.
* `Numerics.Dyadic.mul` forms exact products, with its rational-semantics theorem used in the proof.
* `Model.roundRatWithRounding` implements FP32 toward-zero and nearest-even rounding. Every scalar addition uses FloatLib nearest-even rounding and FloatLib decoding.
* FloatLib's real-valued `roundAt` and format-grid theorems prove that the executable EFT result has mathematical nearest-even semantics, including ties. This is a proof connection, not only an output comparison with a second program.

The TC-specific alignment, extraction, guard, and flowback definitions are new code in this directory. FloatLib does not provide a ready-made TC model or TC-EFT implementation.

## Model and numerical scope

A block contains K exact products and an FP32 accumulator input C. The model retains the original input exponents separately from each dyadic value. A product's alignment scale is the sum of its input scales, even if the product value could be normalized differently. Zero inputs have the parent's neutral metadata `(scale, fractionBits) = (0, 0)`; zero terms do not select the alignment maximum.

The nonzero raw-scale maximum, optionally clamped by the architecture floor, selects the alignment quantum `2^(eta - 23 - extra)`. Each term is truncated toward zero on that grid; the retained terms are added exactly; FloatLib converts the accumulator to FP32 toward zero. There is no integer accumulator wraparound. Inputs and the accumulated result must satisfy the parent's finite-domain rules. In particular, `|accumulator| > maxFinite32` is rejected before rounding, even though native IEEE toward-zero overflow would saturate.

Named FP16 profiles are V100 `(K=4, extra=0, no floor)`, A100 `(8, 1, -132)`, and H100 `(16, 2, -133)`. The same profile constructor supports BF16 and packed 19-bit TF32. Tests also cover A100 TF32 K=4, H100 WMMA TF32 K=4, and the paper's H100 MMA TF32 K=8. Arbitrary K, extra-bit counts, and floors can be evaluated.

The feature-test interface accepts TF32 in 32-bit registers and requires the low 13 bits to be zero. The EFT `block` interface accepts **packed 19-bit TF32**. These are different representations, not an implicit input-rounding operation.

Exact zero is canonicalized to +0, as in the parent reference; negative underflow can produce -0. NaNs and infinities are rejected. This project does not model exception flags, instruction scheduling, matrix tiling, undocumented hardware paths, or FP16 outputs.

## EFT and proofs

The extraction grid is the coarser of the alignment grid and supplied D's FP32 grid. Each original term splits into a retained part and a low part. The overlap is `D - sum(retained parts)`. Consequently, `D - overlap + sum(low parts)` recovers the independent original-input sum. The proof works for **any supplied finite D**, even one unrelated to the TC model output.

The scalar guard is the **existing Lean repository's guard**: the original-term support grid lies between -149 and 104, residual coefficients are exact integers with total absolute coefficient sum below `2^24`, D/overlap/retained sum are representable, and the reconstructed sum is in finite FP32 range. The paper permits choosing a suitable common grid and gives sufficient mathematical conditions; this deterministic executable guard is one conservative implementation of them. The equivalence theorem preserves the repository's exact branch decisions. Separate paper theorems cover the chosen-grid coefficient and absolute-range conditions.

The guarded scalar path sequentially adds the low parts in FP32, computes `D - overlap` in FP32, then performs the final FP32 addition. `naiveSumFrom_exact` proves every accepted prefix sum is exact. `scalar_correct` proves the result equals FloatLib nearest-even rounding of the original ideal. `scalar_success_iff` proves this path succeeds exactly when its guard holds.

On a failed scalar guard, Algorithm 1 uses exact rational consolidation and one FloatLib rounding. This is the parent's **reference fallback**, not its bounded 576-bit implementation. `algorithm_correct` proves both branches return the same rounded ideal; `algorithm_range` proves success exactly when that ideal is within the source finite range. `encodedAlgorithm_correct` includes the all-zero shortcut. `encodedAlgorithm_nearest` connects the returned word to mathematical nearest-even rounding over the reals.

| File | Main contents |
|---|---|
| `TCFloat/Model.lean` | Executable formats, decode, TC stages, extraction, scalar guard and both EFT branches |
| `TCFloat/Theory.lean` | Product denotation, exact loss accounting, overlap recovery, signed-truncation error and monotonicity |
| `TCFloat/Rounding.lean` | FloatLib executable-to-real rounding bridge and FP32 grid representability |
| `TCFloat/EFT.lean` | Prefix-sum exactness, scalar correctness, full Algorithm 1 correctness and range |
| `TCFloat/Behavior.lean` | C-perturbation flowback identity, exact internal-increase criterion, fixed-grid monotonicity, alignment error bounds, kernel-checked nonmonotonic outputs for V100/A100/H100 |
| `TCFloat/DirectedRounding.lean` | Proved connection from FloatLib RTZ conversion to signed-grid truncation for positive normal binary intervals |
| `TCFloat/Monotonicity.lean` | General K/p nonmonotonicity threshold, actual encoded FP16 version, and formal failure of accumulator monotonicity |
| `Main.lean` | Batch executable adapter |

**Paper theorem coverage:** the bridge layer adds the full output-ULP error bound, arbitrary-summand output-level flowback criteria, the general K/p/j nonmonotonicity range, overlap identities, any-order exact summation, the input bit-span/coefficient preconditions, and exact scalar correction on an arbitrary valid common grid. [COMPARISON.md](COMPARISON.md) gives the theorem-by-theorem correspondence. These proofs use actual FloatLib operations; some transport original results through the proved equivalence. They do not establish universal GPU conformance.

| New file | Purpose |
|---|---|
| `TCFloat/Paper.lean` | Independent encoded interfaces, including typed validation results |
| `TCFloat/Equivalence/Conversion.lean` | Universal RTZ/RNE converter bit equality |
| `TCFloat/Equivalence/Encoded.lean` | Universal TC/EFT encoded-interface equivalence |
| `TCFloat/Equivalence/Representations.lean` | Two-way input/result mappings and exact-error equivalence |
| `TCFloat/Equivalence/PaperTheorems.lean` | Error, flowback, perturbation-range and overlap statements |
| `TCFloat/Equivalence/PaperScalar.lean` | Paper scalar-summation and chosen-grid conditions |

## What the tests do

1. **`check_features.py`:** 2,033 synthetic FP16 model cases plus 15,000 recorded FP16 GPU vectors. It checks output bits, exact ideal, accumulator, output value, and total residual. Synthetic cases include arbitrary block sizes, extra-bit counts, floors, cancellation, zeros, subnormals, overflow, and nonfinite inputs. The independent Python oracle uses `Fraction` arithmetic and binary search over FP32 encodings.
2. **`check_replay.py`:** 20,000 additional recorded BF16/TF32 GPU rows (5,000 per A100/H100 format pair). It also replays 21,966 existing scalar-coverage records, checking model bits, low parts, the exact guard decision, scalar bits, and full-EFT bits. Two records are nonfinite-input rejections. The source coverage suite deliberately uses no alignment floor; the hardware replay uses the architecture floors.
3. **`check_paper.py`:** reruns the hash-pinned original Python generators in an isolated scratch directory. It sends 52,031 cases to the compiled FloatLib executable: 59 named blocks, 800 deterministic blocks, 1,600 full-range blocks, retained out-of-domain draws, 8 boundary/composition blocks, 49,005 encoded perturbation-family cases, and 100 rounding cases. It compares intermediate extraction values as well as final bits. Mutating model/correction bits must make the comparator fail; malformed commands must be rejected.
4. **`check_edges.py`:** unrelated finite supplied D values, signed zeros, underflow ties, finite endpoints and rejection beyond them, nonfinite D, nonfinite operands, invalid TF32 padding, and a negative executable-dependency control.

5. **`check_monotonicity.py`:** boundary cases immediately below, at, and above the proven `3·2^p` threshold, as well as zero/small K, p=0 through 8, and three alignment-floor configurations. Both alignment-grid selection and accumulator formulas are checked, together with the final FP32 output inequality. The universal theorem is established by Lean, not by this finite enumeration.

The two adapted oracle scripts retain their parent's arithmetic and case generation; only paths, executable selection, and the port-specific audit integration change. The 21,966-record scalar corpus is a saved reference regression corpus; replaying it is distinct from regenerating the paper oracles. Counts across suites overlap: in particular, scalar coverage includes the same 15,000 FP16 hardware rows. There are **35,000 unique recorded hardware rows**, not the sum of every suite count.

### Where the MATLAB data fits

Recorded inputs and GPU outputs live in the parent's `vendor/matlab-tensor-core-v0.5/model_validation/`. Each row represents one source-defined normalization group. FP16/BF16/TF32 operands in those files are stored using FP32 word representations; the harness converts them to the corresponding input encoding without numerical rounding. The c/d files contain binary FP32 words. Vendor hashes are checked before replay.

MATLAB and new hardware runs are unnecessary for this replay because the inputs and measured outputs are already present. The tests are software comparisons against those recorded measurements. They do not take new GPU measurements or reproduce every possible hardware input. No recorded H100 TF32 K=8 hardware corpus is claimed here; that path is covered by the paper's software cases.

## Executable interface

Write commands to a text file, one per line, and run:

```sh
.lake/build/bin/tc_floatlib input.txt
```

Examples (all words are decimal):

```text
block fp16 1 0 none 3072 3072 1065353216 1065353216
round 16777217 16777216
family 0 4 1
canonical 1 0 none 15360 15360 0
```

`block FORMAT K EXTRA FLOOR a0 b0 ... c D` returns the independent ideal, model-stage diagnostics, and correction using supplied D. FORMAT is `fp16`, `bf16`, or packed `tf32`; FLOOR is an integer or `none`. `round N D` compares FloatLib RNE/RTZ on the exact rational N/D under the source finite-range restriction. `family p K j` evaluates the encoded FP16 perturbation family. `canonical`/`bf16`/`tf32` feature commands omit supplied D; feature `tf32` uses register words.

The reference algorithms use arbitrary-precision exact arithmetic plus specified FP32 roundings. This is an executable formal model, not a native GPU implementation or a performance benchmark.
