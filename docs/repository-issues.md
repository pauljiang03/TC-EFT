# Repository issues and paper-readiness review

Reviewed on 23 September 2026 against commit [`39dc35d`](https://github.com/pauljiang03/tensor-core-arithmetic/tree/39dc35d547ba3f1fe08c3e08e6e047e0ea6cb2bf) and the supplied 13-page manuscript, `arith_2027_tc_eft (4).pdf`. This is an AI-assisted review of selected definitions, theorem statements, implementations, and validation results, not an independent human audit of every proof.

The core finite FP32-output model and error-free transformation (EFT) are in good shape. The issues below concern the match between the paper and the formal statements, the clarity of the evidence, and repository usability. No incorrect EFT result was found in the checks performed.

For commands, dataset layout, expected results, and MATLAB setup, see [How to reproduce the MATLAB-source validation](#how-to-reproduce-the-matlab-source-validation).

## What passed, and what that means

`lake build` and all 52 commands in `./tc check` passed during this review. The executable Lean results agreed with the expected numerical results in the suite. The proof audit found no unfinished proofs or custom axioms in its audited public theorem roots. The EFT acceptance counts in the manuscript were also reproduced: all 15,000 published FP16 cases passed scalar correction, and 3,848 of the 6,966 additional cases passed that scalar check.

The EFT guarantee is stronger than passing examples. The [bounded implementation's correctness theorems](../TensorCore/EFT/Machine/Correctness.lean) prove that a successful correction returns the correctly rounded FP32 value of the exact original sum, under their input assumptions. They also prove success when the exact sum is in the supported finite range. The [scalar correction theorem](../TensorCore/EFT/Scalar.lean) proves correctness when its sufficient conditions hold. Failure of those scalar conditions does not establish that the result is wrong; the full implementation can use an exact fallback.

Passing these checks does not prove that every test oracle is flawless, that the tests cover every input, or that the specified arithmetic matches every physical GPU execution. The review did not run new GPU experiments, SoftFloat, or the separate con-leche checker. These limits should remain visible when describing the results.

## Issues to resolve for the paper artifact

1. **The general flowback statement in the paper is broader than the corresponding Lean theorem.** Definition III.3 and Equation (6), on page 4, describe changing any one summand and tracking the resulting change in the other retained terms. The corresponding Lean theorems are `output_condition`, `flowback_necessary`, and `flowback_sufficient` in [Flowback.lean](../TensorCore/TC/Flowback.lean): the products stay fixed and only the accumulator input, C, changes. This is enough for the constructed nonmonotonicity examples, but it does not directly formalize the paper's full general statement. Add the arbitrary-summand theorem, or say explicitly that Lean proves the accumulator-only specialization used by the examples. This gap concerns the general flowback statement, not the EFT recovery theorem.

2. **The scalar-only algorithm and the full correction implementation need clearer labels.** The paper's Algorithm 1 and acceptance statistics describe correction that proceeds only when scalar exactness checks pass. The current executable can also use an exact fallback. For example, the manuscript's 3,118 additional cases without a scalar result should not be read as 3,118 failures of the full EFT implementation. Explain this distinction beside the experiment and provide the command that reproduces those particular statistics. The relevant paths are [EFTCoverage.lean](../examples/EFTCoverage.lean), [the coverage checker](../scripts/check_eft_coverage.py), and [the bounded correction proofs](../TensorCore/EFT/Machine/Correctness.lean).

3. **Different scalar acceptance checks are easy to mistake for numerical disagreement.** The [paper comparison report](../data/regressions/eft-paper-report.json) records 27 differences between the older Lean reference check and the source Python check, with zero numerical mismatches. They choose the residual grid differently, so one can accept scalar correction where another takes an exact path. These are not 27 demonstrated failures of the current bounded executable. In the inspected named example, the current bounded implementation and Python both accept scalar correction and return the same bits; the older reference reaches those bits through its exact path. Document which implementations are being compared and whether a comparison promises identical outputs, identical branch choices, or both. The paper permits choosing the grid and gives sufficient conditions, so differing sound checks are not themselves an EFT correctness defect.

4. **The supplied manuscript is not the version identified by the validation provenance.** [SOURCES.json](../vendor/tc-eft-validation/SOURCES.json) names an unbundled manuscript and a local source-package location. Its paper hash is `e9b19e9766974d64dad081ea1107bb6d54c6aff8a1fd0620ce9fb13dbd497b3e`; the supplied draft has hash `b1718e80eecc8a5c1178aaad2e34fa1e28c403a0e3cef32b69ac1956aff6fa41`. This does not show an arithmetic error, but it prevents a reader from treating the recorded provenance as an exact match to this draft. Add a stable manuscript or review-artifact reference and identify the matching repository release. Include a short table mapping each paper claim to its Lean theorem and assumptions. Update stale references: [ExtractionGrid.lean](../TensorCore/EFT/ExtractionGrid.lean) refers to Equation 20 where this draft uses Equation (17), and [Algorithm1.lean](../TensorCore/EFT/Algorithm1.lean) refers to a Table V absent from this draft. Preserve historical provenance rather than silently replacing it.

5. **A few manuscript claims need correction or tighter wording.** The abstract says the operation count falls from 2n to n-1. Section V-A correctly gives n+1 when products are already available: n-1 residual additions and two final operations. Keep n defined consistently as K+1 summands, and distinguish this count from the implementation's extra zero-initialized addition. The abstract's statement that nothing formal is known also needs reconciliation with its own discussion of earlier SMT formalization. Finally, claims about how many padding bits prevent nonmonotonicity should retain the body’s restriction to the constructed input family. The repository proves those examples; they are not a global classification of all possible inputs. These are paper-alignment issues, not discovered failures of the Lean arithmetic.

6. **The separate external proof audit applies to an older commit.** The [con-leche audit](con-leche-audit-2026-09-14.md) explicitly identifies commit `9b42a43` and predates the archive reorganization. It is useful evidence for that version, but should not be presented as a fresh external audit of the submission release. Repeat it for the chosen release, or continue to state its historical scope prominently. This is separate from the successful Lean build and axiom audit performed in this review.

## Broader limitations and maintenance work

7. **The archived GPU comparisons leave some important arithmetic cases untested.** The A100/H100 BF16 and TF32 rows in the [device report](../data/regressions/device-formats-report.json) each contain 5,000 vectors, but no zero or subnormal operands or accumulators, and they do not exercise the minimum alignment exponent. Add targeted hardware cases for those behaviors before claiming comprehensive device agreement. Record the GPU, instruction, compiler, and configuration. This is a limitation of the physical-hardware evidence, not a missing proof of the defined model. New GPU deployment and performance work are not required to establish the paper's explicitly scoped mathematical result.

8. **The accuracy analyzer can decline to certify an exact computation.** In a reproduced V100 example with a 1-by-1 matrix, one product, A = B = 1 and C = 0, execution returns exactly 1. At zero allowed error, the analyzer nevertheless reports `inconclusive` with bound `7/8388608`. It certifies the same case at tolerance `1e-6`, and the exported certificate verifies. This shows conservative bounds, not an incorrect certificate or an EFT failure. Improve bounds for exact operations and measure how often useful workloads are rejected before claiming broad practical usefulness. The [selection report](../data/regressions/selection-report.json) also records conservative refusals.

9. **Practical speed and scale are not established by the proof or operation count.** Exact fallback uses a bounded 576-bit representation, and existing tests and small synthetic timings do not establish useful GPU throughput or certification cost on realistic matrices. Measure runtime, memory use, and acceptance rates on representative workloads before making performance claims. This is application work beyond the paper's core block-level correctness result; the manuscript already treats GPU performance as future work.

10. **The repository needs easier entry points and routine automation.** At the reviewed commit there is no committed GitHub Actions workflow and no top-level license for the project's own code. The README is roughly 5,120 lines and mixes introductory material with generated proof documentation. Choose and add a project license, automate suitable existing checks, and give readers a short introduction with one working example and links to the detailed proof guide. Move generated material out of the main entry point by updating its generator, so regeneration does not undo the improvement. These changes would make the artifact easier to reproduce and maintain; they do not change the mathematical guarantees.

The highest-priority work for this paper is to align the theorem scope, algorithm labels, manuscript references, and operation-count claim. The broader hardware and performance limitations should remain explicit without being presented as defects in the proved finite model.

## How to reproduce the MATLAB-source validation

### Three different checks

The phrase "MATLAB tests" can mean three things here. They should be reported separately:

| Check | What runs | What is compared | Requirements |
| --- | --- | --- | --- |
| Lean replay of published GPU data | Python drivers and compiled Lean | Lean model output bits against recorded GPU output bits distributed by the MATLAB project | Python 3, the pinned Lean toolchain, and a native build toolchain; no MATLAB, CUDA, or GPU |
| MATLAB model replay | The upstream MATLAB model functions | MATLAB model results against those same recorded GPU outputs | MATLAB, a working CPFloat installation, and the vendored model/data files; no GPU |
| EFT validation using published inputs | Python and executable Lean | Corrected results against independently computed, correctly rounded exact sums | Python and Lean; no MATLAB or GPU |

None of these commands collects new GPU measurements. Running MATLAB is not a prerequisite for the Lean replay. Also, the device's uncorrected output is not the expected answer for EFT: correction can legitimately change it.

### Where the data came from

The data and MATLAB sources are the unmodified subset of [MATLAB-tensor-core v0.5](https://github.com/north-numerical-computing/MATLAB-tensor-core/tree/bbcf00a273868172494eaacaa8d6128ab0fb8704), pinned at commit `bbcf00a273868172494eaacaa8d6128ab0fb8704`. [vendor/SOURCES.json](../vendor/SOURCES.json) records the origin and SHA-256 hashes. The files live under [vendor/matlab-tensor-core-v0.5/](../vendor/matlab-tensor-core-v0.5/).

The upstream project describes its `model_validation` directory as a published subset of the GPU data used to validate its models; it does not distribute all of its full-sized experiments. This repository reuses that archived evidence. It does not establish a new chain of custody for the original device runs.

All seven datasets below use an FP32 accumulator C and FP32 output D. K is the number of products in one internal accumulation group, not the dimensions of a whole CUDA instruction tile.

| GPU | Product input format | K | Rows | Lean replay |
| --- | --- | ---: | ---: | --- |
| V100 | FP16 | 4 | 5,000 | `check_device.py` and `check_features.py` |
| A100 | FP16 | 8 | 5,000 | `check_features.py` |
| H100 | FP16 | 16 | 5,000 | `check_features.py` |
| A100 | BF16 | 8 | 5,000 | `check_device_formats.py` |
| H100 | BF16 | 16 | 5,000 | `check_device_formats.py` |
| A100 | TF32 | 4 | 5,000 | `check_device_formats.py` |
| H100 | TF32 | 4 | 5,000 | `check_device_formats.py` |

There are **35,000 distinct published rows**. V100's 5,000 rows are checked through two Lean entry points; that does not make them additional independent measurements. The H100 TF32 rows exercise the K=4 path, not the separate K=8 MMA path. B200, FP8, and FP16-output validation are outside this active replay.

### How each row is encoded

Each GPU/format directory contains four files, for example `model_validation/A100/bf16/`:

- `a_A100_bf16.txt` and `b_A100_bf16.txt`: K hexadecimal FP32 words per row, holding values representable in the named input format.
- `c_A100_fp32.txt`: one 32-character binary string per row, encoding the FP32 accumulator.
- `d_A100_fp32.txt`: one 32-character binary string per row, encoding the recorded FP32 device result.

Matching row indices describe one evaluation of `sum(a[i] * b[i]) + c`. The words are bit patterns, not decimal numbers to round again while parsing. For example, FP16 value 1 is stored in the input file as FP32 word `3f800000`; the Lean FP16 interface receives encoding `3c00` after an exact conversion.

The Python drivers check the conversion and layout. FP16 inputs must be exactly representable as FP16. BF16 words must have 16 zero low bits and are shifted into their 16-bit encoding. TF32 words must have 13 zero low bits and remain in their padded FP32-register encoding. C and D are parsed directly as 32-bit integers. The drivers check matching row counts and the required number of products.

### Run the Lean replay

Run the following from the repository root. Install Python 3, Git, [elan](https://github.com/leanprover/elan), and a native C/C++ build toolchain first. The committed `lean-toolchain` selects `leanprover/lean4:v4.33.1`; do not substitute a different Lean release when reproducing these results. The replay scripts use Python's standard library. Run ordinary `python3`, without `-O`, because their validation includes Python assertions.

```sh
git clone https://github.com/pauljiang03/tensor-core-arithmetic.git
cd tensor-core-arithmetic
elan toolchain install leanprover/lean4:v4.33.1
./tc doctor
lake build tc_trace tc_features
python3 scripts/check_features.py
python3 scripts/check_device.py
python3 scripts/check_device_formats.py
```

For a release-specific reproduction, check out that release commit before building and record `git rev-parse HEAD`. The commands above use the checkout's current source. Each script must finish with exit code zero. They print JSON summaries and write these reports:

| Script | What it checks | Report |
| --- | --- | --- |
| [check_features.py](../scripts/check_features.py) | Verifies every source/data hash listed in `vendor/SOURCES.json`; compares 2,033 synthetic cases across 132 parameter configurations with an exact Python rational oracle; then replays all 15,000 FP16 device rows | [feature-report.json](../data/regressions/feature-report.json) |
| [check_device.py](../scripts/check_device.py) | Replays the 5,000 V100 FP16 rows through `tc_trace`, compares output bits, and records which loss mechanisms occur | [device-report.json](../data/regressions/device-report.json) |
| [check_device_formats.py](../scripts/check_device_formats.py) | Replays 20,000 BF16/TF32 rows through both the instruction-descriptor and arithmetic-profile entry points in `tc_features`; compares each with device bits and with the other entry point | [device-formats-report.json](../data/regressions/device-formats-report.json) |

The synthetic oracle decodes inputs into exact rational numbers, performs the specified alignment and accumulation, and searches ordered FP32 encodings for the rounded result. Its cases include cancellation, zero and subnormal values, different padding counts, and deliberate invalid inputs. These are software tests, not additional measured GPU vectors. The 15 expected rejections in `feature-report.json` are part of the passing result.

When adding this guide, the three replay commands were rerun successfully after building `tc_trace` and `tc_features`. All 35,000 published rows matched, both BF16/TF32 entry points agreed, and the 2,033 synthetic cases passed their expected result/rejection checks. No MATLAB or new GPU execution was part of that run.

For the published rows, expect zero model errors and zero bit mismatches. The BF16/TF32 report should also show zero `profile_bit_mismatches` and zero `descriptor_profile_disagreements`. A nonzero exit status, assertion, parser error, or missing executable is a failed or incomplete run, even if an old report file still says it passed.

Reports under `data/regressions/` are overwritten by these commands. Intermediate inputs are written under `tmp/validation/`. Preserve the console logs, exit statuses, reports, and commit ID for an artifact evaluation. Timing fields in other suites may differ between runs.

The V100 report also counts alignment loss, final output loss, mixed signs, products kept unnormalized, and cases where C determines the alignment exponent. A positive `corrected_differs_from_device` is expected: it counts corrections that change the raw device result, not model/device mismatches.

To run the entire repository acceptance suite instead of only this replay:

```sh
./tc check
```

This builds and checks a fresh source snapshot and includes the three replay scripts plus proof audits, EFT checks, and other repository tests. It does not launch MATLAB or collect GPU measurements.

### Run the MATLAB models against the same files

This is an optional, separate reproduction of the upstream numerical model. MATLAB and Octave were not available in the review environment, so the procedure below was checked against the source but was not executed here. Do not report it as a completed MATLAB run on the strength of the Lean replay.

First install CPFloat's MATLAB interface. Its [official installation instructions](https://github.com/north-numerical-computing/cpfloat#installation) describe `make mexmat`, which compiles and autotunes the MEX interface. A typical setup in a separate dependency directory is:

```sh
git clone --recurse-submodules https://github.com/north-numerical-computing/cpfloat.git
cd cpfloat
make mexmat
git rev-parse HEAD
```

Use a compiler supported by your MATLAB installation and make MATLAB available to the build command. CPFloat's `bin/` directory must be on MATLAB's search path. CPFloat also documents a `mex/cpfloat_compile_nomake.m` alternative for environments without `make`. Record the CPFloat revision, MATLAB version, and compiler used; this repository does not pin a CPFloat installation for MATLAB replay. The Lean tests do not depend on CPFloat.

Do not run the bundled [Validate_TC_models.m](../vendor/matlab-tensor-core-v0.5/model_validation/Validate_TC_models.m) unchanged against this subset. Its defaults include Ada, H200, B200, FP8, and FP16-output files that are not in the active vendored selection. It also expects paths relative to `model_validation/`. The following restricted runner calls the same V100/A100/H100 model functions, uses the same readers and row reshaping, and selects only the seven FP32-output datasets above. It adds explicit bit comparisons to the upstream driver's numerical comparison and does not modify the hashed vendor files.

From the repository root, create `tmp/validation/` if necessary, then save the following as `tmp/validation/validate_matlab_fp32.m`:

```matlab
function validate_matlab_fp32(repoRoot, cpfloatRoot)
% Pass absolute paths for both arguments.
vendorRoot = fullfile(repoRoot, 'vendor', 'matlab-tensor-core-v0.5');
dataRoot = fullfile(vendorRoot, 'model_validation');
savedPath = path;
savedWarnings = warning;
pathGuard = onCleanup(@() path(savedPath));
warningGuard = onCleanup(@() warning(savedWarnings));
addpath(fullfile(cpfloatRoot, 'bin'));
addpath(fullfile(vendorRoot, 'models'));
addpath(fullfile(vendorRoot, 'models', 'tools'));
addpath(dataRoot);
assert(exist('cpfloat', 'file') == 3, 'CPFloat MEX is not on the path.');
fprintf('MATLAB: %s\nCPFloat: %s\n', version, which('cpfloat'));

datasets = {
    'V100', 'fp16', 4;
    'A100', 'fp16', 8;
    'H100', 'fp16', 16;
    'A100', 'bf16', 8;
    'H100', 'bf16', 16;
    'A100', 'tf32', 4;
    'H100', 'tf32', 4
};
totalRows = 0;
for datasetIndex = 1:size(datasets, 1)
    gpu = datasets{datasetIndex, 1};
    inputFormat = datasets{datasetIndex, 2};
    k = datasets{datasetIndex, 3};
    folder = fullfile(dataRoot, gpu, inputFormat);
    a = readHexFloatFile(fullfile(folder, ['a_' gpu '_' inputFormat '.txt']));
    b = readHexFloatFile(fullfile(folder, ['b_' gpu '_' inputFormat '.txt']));
    a = reshape(a, k, []).';
    b = reshape(b, k, []).';
    c = readIeeeFloatsFromFile(fullfile(folder, ['c_' gpu '_fp32.txt']));
    device = readIeeeFloatsFromFile(fullfile(folder, ['d_' gpu '_fp32.txt']));
    n = numel(device);
    assert(n == 5000 && size(a, 1) == n && size(b, 1) == n && numel(c) == n);
    modeled = zeros(n, 1);
    for row = 1:n
        ar = double(a(row, :));
        br = double(b(row, :)).';
        cr = double(c(row));
        switch gpu
            case 'V100'
                modeled(row) = V100TC(1, ar, br, 1, cr, 'fp32');
            case 'A100'
                modeled(row) = A100TC(1, ar, br, 1, cr, inputFormat, 'fp32');
            case 'H100'
                modeled(row) = H100TC(1, ar, br, 1, cr, inputFormat, 'fp32');
        end
    end
    % Check values before conversion as well as the FP32 encodings.
    numericMismatch = modeled(:) ~= double(device(:));
    modelBits = typecast(single(modeled(:)), 'uint32');
    deviceBits = typecast(single(device(:)), 'uint32');
    bitMismatch = modelBits(:) ~= deviceBits(:);
    fprintf('%s %s -> fp32: %d rows, %d value mismatches, %d bit mismatches\n', ...
        gpu, inputFormat, n, nnz(numericMismatch), nnz(bitMismatch));
    bad = find(numericMismatch | bitMismatch, 1);
    if ~isempty(bad)
        error('First mismatch: %s %s row %d, model=%08x device=%08x', ...
            gpu, inputFormat, bad, modelBits(bad), deviceBits(bad));
    end
    totalRows = totalRows + n;
end
fprintf('PASS: %d published rows across seven datasets.\n', totalRows);
end
```

Launch it from the repository root, replacing the CPFloat path:

```sh
matlab -batch "addpath('tmp/validation'); validate_matlab_fp32(pwd, '/absolute/path/to/cpfloat')" > tmp/validation/matlab-replay.log 2>&1
```

Check that MATLAB exits successfully and that `matlab-replay.log` contains seven lines with zero mismatches and the final 35,000-row PASS line. This runner writes a console log, not the Lean JSON reports. The original upstream driver checks numerical differences; the runner above additionally compares encodings, which can distinguish positive and negative zero. MATLAB error row numbers are one-based; Python mismatch indices in these replay scripts are zero-based.

The upstream project also advertises Octave support, and CPFloat documents `make mexoct`. That is a separate environment to validate and record; this guide does not claim an executed Octave reproduction.

### Check EFT on the published inputs

The GPU rows validate the raw TC behavior model. To check recovery, the repository separately uses the original inputs to compute the exact rational sum and independently rounds it to nearest-even FP32. Accepted Lean scalar corrections must equal that result, even when it differs from the recorded GPU result.

Run from the repository root:

```sh
lake build
python3 scripts/check_eft_coverage.py
```

This runs [examples/EFTCoverage.lean](../examples/EFTCoverage.lean) through `lake env lean --run`. It verifies the hashes of the reused FP16 files, checks raw Lean outputs against recorded GPU outputs on those rows, checks the actual scalar guard and safe correction API, and compares accepted corrected bits against the independent exact-sum oracle. It writes [eft-coverage.json](../data/regressions/eft-coverage.json) and the per-case [eft-coverage-cases.json](../data/regressions/eft-coverage-cases.json). Inputs are retained in `tmp/eft/coverage.txt`.

There are 21,966 cases: the 15,000 FP16 device rows plus 6,966 generated cases. All 15,000 published cases pass the scalar guard. Among the additional cases, 3,848 pass and 3,118 do not produce a scalar result. Those latter cases include guard failures and model-domain rejections; they are not 3,118 incorrect corrected outputs. This is the reference scalar procedure, not an acceptance-rate benchmark of the bounded executable with its exact fallback. The report's `floor: null` records this FP16 coverage runner's profile; it should not be substituted for the BF16/TF32 floor tests. `unchecked_mismatches` records a deliberately unchecked scalar computation and must not be mistaken for failures of the guarded API.

For the wider EFT acceptance suite, including the source Python comparison and bounded implementation:

```sh
python3 scripts/check_eft.py
```

Or, for that EFT suite in a fresh source copy without a preexisting build cache:

```sh
python3 scripts/check_eft.py --clean
```

These commands build Lean, audit the imported proofs, run scalar coverage, check the paper-source implementation and bounded correction, and check the preparation/replay machinery for hardware experiments. Generating expected hardware results and running replay self-tests does not execute CUDA. The summary is [eft-checks.json](../data/regressions/eft-checks.json), with logs under `tmp/eft/`; the clean command prints the location of its separate source copy.

### Limits and troubleshooting

- A missing `.lake/build/bin/tc_trace` or `tc_features` means the required executable has not been built. Rerun the build command and check its exit status. `./tc doctor` checks the pinned Lean installation.
- A hash failure means the vendored sources or vectors differ from the recorded input to this review. Identify the difference before claiming reproduction. Keep experimental edits outside the vendored directory.
- Missing Ada/B200/FP8/FP16-output files usually mean the unrestricted upstream MATLAB driver was used. Use the seven-dataset runner above for this repository's active scope.
- A missing or unloadable `cpfloat` MEX requires fixing its build or MATLAB search path. The provided runner deliberately requires CPFloat even though the upstream GEMM function has a path that assumes inputs were already rounded.
- A new mismatch should be reported with the source commit, GPU/format, row index, input words, expected and actual output bits, and tool versions. Do not change expected outputs merely to make a comparison pass.
- Agreement on archived rows is evidence about those rows. In particular, the BF16/TF32 device report records no zero/subnormal inputs or accumulators and does not exercise the alignment floor. Synthetic edge-case tests cover more of the software model, but do not replace missing hardware observations.

For paper reporting, distinguish the three claims: the mathematical model and EFT have Lean proofs under stated assumptions; executable Lean agrees with the archived device rows; and accepted scalar EFT outputs agree with an independent exact-sum oracle. None of these statements claims exhaustive physical-GPU conformance or a GPU performance measurement.
