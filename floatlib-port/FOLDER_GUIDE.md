# Guide to the FloatLib port

`floatlib-port/` is an isolated Lean project inside `tensor-core-arithmetic`. It implements the paper's FP32-output Tensor Core block model and reference TC-EFT using FloatLib, and proves that its checked interfaces agree with the original implementation. The original arithmetic source and project configuration remain unchanged.

This guide explains the folder and the strength of its evidence. The [README](README.md) gives the detailed numerical behavior and executable commands. The [comparison document](COMPARISON.md) maps the arithmetic stages and paper statements to their Lean theorems.

## What “correct” means here

There is strong evidence that this port correctly implements the formal model. Some claims are stronger than “probably”: Lean has checked universal theorems about the implementations, including their equivalence and the EFT's correctly rounded result under the stated conditions.

Three different claims should be kept separate:

| Claim | Evidence |
|---|---|
| The port computes the same modeled behavior as the original implementation. | A universal equivalence theorem, including output bits, EFT branches and validation errors. |
| The formal EFT recovers the exact sum and produces correctly rounded FP32 results under its conditions. | Exact-recovery and rounding proofs; the scalar path retains its grid, coefficient and representability conditions. |
| The behavior model describes physical Tensor Cores. | Agreement with recorded hardware measurements on the tested cases. This is not a proof covering every hardware execution. |

Equivalence cannot rule out an assumption shared by both models being wrong about hardware. Likewise, Lean checks the written theorem and its hypotheses; relating those definitions to the manuscript and hardware remains part of the specification review.

## Scope of the 1:1 result

The main theorem is [`TCFloat.Equivalence.paper_one_to_one`](TCFloat/Equivalence/Representations.lean). It covers FP16, BF16 and packed TF32 operands with FP32 output, using alignment precision `F = 23 + extra`. Product count, the natural number of extra bits and the optional alignment floor are parameters.

For every bounded encoded block and every supplied FP32 word D, the two checked interfaces return the same TC bits and the same EFT branch/bits, or corresponding validation errors. D does not have to be the TC model's output. Nonfinite encodings and wrong product counts are included as rejected cases.

`inputEquiv` supplies a two-way mapping between the encoded input types. `paper_one_to_one_inverse` states the result starting from a port input. Separate equivalences cover words, canonical decoded terms, errors and tagged EFT outcomes. [`round32_eq`](TCFloat/Equivalence/Conversion.lean) connects the actual converters for every rational input in both toward-zero and nearest-even modes.

These claims concern the checked interfaces and the stated representation invariants. Unrestricted raw `Term` and `Trace` records can contain inconsistent metadata or output fields. Their entire raw types are not identified with the original types. See [RepresentationFacts.lean](tests/RepresentationFacts.lean) for checked examples of those distinctions.

## What transferring an original theorem means

Some proofs follow this argument:

1. The original implementation has a proved property.
2. A proved equivalence connects the relevant original and FloatLib computations.
3. Rewriting through those equalities establishes the property for the FloatLib implementation.

For example, [`paper_error_bound`](TCFloat/Equivalence/PaperTheorems.lean) uses the original `TensorCore.evalPrepared_error_bound`, then translates its ideal sum, accumulator, output and grid quantities through the proved correspondence. Lean checks that translation and all required hypotheses.

This is a rigorous proof with a dependency on the original theorem. It is not an independent derivation of that result. The equivalence is itself proved, rather than assumed.

The executable remains independent: FloatLib performs its decoding, exact dyadic multiplication and FP32 conversion. The port also has proofs of recovery, scalar correction and rounding in its own theory modules. The dependency audit checks that executable arithmetic never calls the original `TensorCore` implementation, and that EFT correction does not obtain its answer by calling the TC evaluator or the ideal-sum function.

## Folder map

| Path | Purpose |
|---|---|
| [TCFloat/Model.lean](TCFloat/Model.lean) | Executable TC stages, extraction, scalar guard and reference EFT branches. |
| [TCFloat/Paper.lean](TCFloat/Paper.lean) | Encoded paper interfaces, bounded inputs and typed validation errors. |
| [TCFloat/Theory.lean](TCFloat/Theory.lean), [Rounding.lean](TCFloat/Rounding.lean), [EFT.lean](TCFloat/EFT.lean) | Recovery, FloatLib rounding semantics and EFT correctness proofs. |
| [Behavior.lean](TCFloat/Behavior.lean), [DirectedRounding.lean](TCFloat/DirectedRounding.lean), [Monotonicity.lean](TCFloat/Monotonicity.lean) | Alignment, flowback, directed rounding and general nonmonotonicity results. |
| [TCFloat/Equivalence/](TCFloat/Equivalence/) | Decoder/converter/stage bridges, universal equivalence, inverse maps and additional paper theorems. |
| [Main.lean](Main.lean) | Batch executable adapter used by the regression scripts. |
| [TCFloat.lean](TCFloat.lean) | Root import that includes the equivalence and paper proof modules in the build. |
| [tests/](tests/) | Axiom/dependency audit, representation checks and decoder comparison programs. |
| [scripts/](scripts/) | Source preparation, regression runners and direct comparison with the original executable. |
| `reference-compat/` | Generated, ignored compatibility copy of the original proof dependencies. |
| `test-results/` | Generated, ignored inputs, logs, comparison outputs and reports. |
| `.lake/` | Downloaded dependencies and compiled artifacts. |
| [verification.json](verification.json), [equivalence-verification.json](equivalence-verification.json) | Recorded verification results, revisions and source hashes. |

The paper additions include the full output error bound, arbitrary-summand flowback, the general perturbation range, overlap identities, any-order exact summation and the paper's chosen-grid scalar conditions. The [comparison table](COMPARISON.md#correspondence-to-the-papers-fp32-statements) lists the individual theorem names.

The executable scalar guard deliberately matches the original repository's conservative guard. The paper theorems also handle a suitably chosen common grid with separate coefficient and absolute-range conditions. A failed executable guard does not prove scalar summation is impossible; the reference EFT can use exact consolidation followed by one FP32 rounding.

## How to build and verify

Use a full repository checkout, since the scripts read the parent project's source, Git history and saved test data. Install elan/Lean and Python 3. Initial dependency setup needs network access and several GB of storage. MATLAB, CUDA and a GPU are unnecessary for replaying the saved measurements.

From the repository root:

```sh
cd floatlib-port
python3 scripts/check_all.py
python3 scripts/check_equivalence.py
```

The first command prepares the source compatibility copy, builds the executable and proofs, runs the axiom/dependency audit and representation checks, then runs the model, hardware replay, EFT, edge and monotonicity suites. The second builds the original executable separately and compares both implementations on identical inputs. Run them in that order because the direct comparison consumes generated test inputs.

For a build and proof audit without rerunning the regression suites:

```sh
python3 scripts/prepare_reference.py
lake build
lake env lean tests/Audit.lean
```

The port uses Lean 4.34.0 and FloatLib revision `0d91825727839f597fd06b22fdd038ea21480f0c`. The reference revision is `990afac10b94a84f3de24743206756dd7acc3276`; its separate executable uses Lean 4.33.1.

The preparation script verifies original dependency files against the pinned Git revision before copying them. Only three Nat/Int/Rat notation declarations are renamed and scoped to avoid mathlib parser collisions. Arithmetic and proof source is copied verbatim. The parent source is never rewritten. A changed original dependency causes preparation to fail rather than silently proving something about another revision.

## Running Lean and the models against the test cases

Run all commands below from `floatlib-port/`. There are two activities: Lean checks the universal proofs when building the library; the regression scripts execute compiled Lean code on concrete test inputs and compare its outputs with expected results. The Python scripts are test harnesses, not substitutes for executing the Lean model.

### 1. Compile the proofs and executable

```sh
python3 scripts/prepare_reference.py
lake build
```

`lake build` includes the root `TCFloat` library, its equivalence and paper theorems, and the `tc_floatlib` executable. A successful build produces `.lake/build/bin/tc_floatlib`. Run `lake env lean tests/Audit.lean` to check the proof dependencies and executable independence, and `lake env lean tests/RepresentationFacts.lean` for the representation checks.

For a specific proof module after preparation, use Lake so that its dependencies are built too:

```sh
lake build TCFloat.Equivalence.Representations
lake build TCFloat.Equivalence.PaperScalar
```

### 2. Execute each saved/generated test suite

| Command | What executes and is compared | Main report under `test-results/` |
|---|---|---|
| `python3 scripts/check_features.py` | Compiled Lean TC model on synthetic FP16 cases and recorded V100/A100/H100 FP16 rows; compares bits and exact stage values. | `feature-report.json` |
| `python3 scripts/check_replay.py` | Compiled Lean model on recorded A100/H100 BF16/TF32 rows, plus model/EFT execution on the saved scalar-coverage corpus. | `replay-report.json` |
| `python3 scripts/check_paper.py` | Pinned paper generators produce inputs and expected results; compiled Lean executes the blocks, perturbation families and rounding cases. | `eft-paper-report.json` |
| `python3 scripts/check_edges.py` | Compiled Lean on supplied-D, rounding and invalid-input edge cases; also checks that deliberately contaminated dependency audits fail. | `edges-report.json` |
| `python3 scripts/check_monotonicity.py` | Compiled Lean on 360 boundary cases around the proved nonmonotonicity threshold. | `monotonicity-report.json` |

The easiest way to execute all of these in the required build context is still:

```sh
python3 scripts/check_all.py
```

Success ends with `All FloatLib-port checks passed.` and writes `test-results/summary.json`. Commands exit with a nonzero status on failure. Inspect the reported assertion or Lean error and the `test-results/check-*.log` files; do not treat the existence of an older report as evidence that the latest run passed. Expected invalid-input rejections are successful test cases when they match the expected rejection.

### 3. Compare directly against the original Lean implementation

After `check_all.py` has generated the corpus:

```sh
python3 scripts/check_equivalence.py
```

This builds the pinned original `tc_eft_paper` executable under `test-results/reference-source/`, sends the same commands to it and `.lake/build/bin/tc_floatlib`, and compares complete JSON records. It also executes both decoder comparison programs. The result is `test-results/equivalence/report.json`; paired outputs are saved as `observations-original.jsonl`, `observations-floatlib.jsonl`, `decoding-original.jsonl` and `decoding-floatlib.jsonl` in that directory.

### 4. Run a small input file yourself

```sh
mkdir -p test-results
cat > test-results/example-inputs.txt <<'EOF'
block fp16 1 0 none 3072 3072 1065353216 1065353216
round 16777217 16777216
family 0 4 1
EOF
.lake/build/bin/tc_floatlib test-results/example-inputs.txt > test-results/example-outputs.jsonl
cat test-results/example-outputs.jsonl
```

There is one JSON output record per input line. The `block` command runs the TC model and EFT with an explicit supplied D. Its arguments are `FORMAT K EXTRA FLOOR a0 b0 ... c D`, with interleaved operand pairs and decimal encoded words. `none` means no alignment floor. The first example uses FP16 operands equal to `2^-12`, C = 1 and D = 1; its exact ideal is `1 + 2^-24`, and the correctly rounded FP32 answer is 1, word `1065353216`. `round` tests the exact rational numerator/denominator in RTZ and RNE. `family` executes a member of the encoded nonmonotonicity family.

The `block` command expects packed 19-bit TF32 words when FORMAT is `tf32`. The separate feature command named `tf32` expects 32-bit register words with their low 13 bits zero. See the [README's executable interface](README.md#executable-interface) for the command forms.

To rerun the generated paper inputs directly after `check_paper.py`:

```sh
.lake/build/bin/tc_floatlib test-results/eft-paper/inputs.txt > test-results/paper-rerun.jsonl
```

This last command executes the model and writes observations. Use `check_paper.py` to also perform the expected-result comparisons. The same distinction applies to custom input files: producing JSON alone does not check an expected answer.

## Recorded verification

The saved successful run records:

- 270 audited proof roots, using only `propext`, `Classical.choice` and `Quot.sound`; the checks reject unfinished proofs and forbidden proof shortcuts.
- 115,029 direct command comparisons and 668,944 decoder comparisons, with zero mismatches.
- 35,000 unique recorded hardware rows, plus synthetic, EFT and monotonicity cases documented in the README. Suite counts overlap and should not be added as if all were distinct hardware experiments.
- Negative controls that reject mutated outputs and forbidden executable dependencies.

These are recorded results, not a promise that future edits remain verified. Rerun the commands after changing code. Creating this guide required no arithmetic changes; the recorded source and verification-script hashes were checked against the current files.
