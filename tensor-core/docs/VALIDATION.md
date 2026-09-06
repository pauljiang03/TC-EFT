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
fails, the scalar EFT returns nothing, and only the exact-rational reference gives
`4e800003`. A subnormal accumulator `2^-149` with products `1` and `2^-24` returns
`3f800000`; the exact sum rounds to `3f800001`, naive FP32 summation of the low parts would
lose `2^-149` and the scalar branch would return `3f800000`, and the predicate rejects the
case.

Non-monotonicity: `K = 8` Ampere products `2^-12 · 2^-13` and `K = 16` Hopper products
`2^-12 · 2^-14` raise the output from `3f800000` to `3f800001` when c drops from `3f800000`
to `3f7fffff` (TC-EFT Table III); `K = 2` on V100 and `K = 11` on Hopper, below the
`3·2^p` thresholds, stay at `3f800000`. Theorem III.5 ranges: on the source widths
`K = 4, 8, 16` the witness range is `1 ≤ j ≤ 2`, so `c_2 = 3f7ffffe` still returns
`3f800001` and `c_3 = 3f7ffffd` returns `3f800000`. The paper's `K = 5`, `p = 0` example
returns `3f800002` at `j = 1`, `3f800001` at `j = 3`, and `3f800000` at `j = 4`.

Instruction paths: R3's four products padded with twelve zero pairs give `4107ffff` on the
whole V100 k = 16 path, the same as the single group; sixteen ones give `41800000` on both
the two-group Ampere path and the one-group Hopper path; on the Ampere path, cancelling the
accumulator `1` in the first group and adding `2^-24` in the second returns `33800000`, while
the reverse order returns `0` for the same exact dot product. On a k = 16 path, fifteen
pairs, seventeen pairs, and sixteen pairs followed by an infinity are all rejected, so no
operand is padded or discarded; an infinity in the sixteenth position is rejected by the
last group.

Static certificate: eight V100 groups of four products `(1 − 2^-11)(1 + 2^-10)` from
`c = 1` pass `staticCheck` at scale `E = 5`, `L = 3`; the applied theorem gives acceptance
and the bound `168·2^-18`. The executed run returns `42040ff5` with error `7·2^-18` against
the ideal and a trace budget of `541·2^-23`. The certificate refuses `E = 4`, which the
partial sums exceed, and a group with an infinite operand.

The converter proof is separate from these cases: `round32_nearestEven_correct` holds for all
rational inputs with magnitude at most `maxFinite32`.

## Independent oracles

`python3 scripts/validate.py` checks 715 V100 blocks and 2,918 rounding inputs with seed
20260905 and reports zero mismatches; three deliberately nonfinite blocks are rejected. The
oracle has its own IEEE field decoder, aligns on the fixed grid 2^-149 with magnitude
integer division, and finds FP32 neighbors by binary search over the encodings. Records:
`data/regressions/validation-report.json` and `expected-traces.json`.

`python3 scripts/check_features.py` checks the parameterized evaluator with a second exact
oracle over 132 configurations of product count, extra bits, and floor: 2,033 cases, 15
intended rejections, zero mismatches. It then replays the published V100, A100, and H100
FP16 vectors and verifies the SHA-256 of every pinned source file. Record:
`data/regressions/feature-report.json`.

`python3 scripts/check_dot_products.py` checks constructed long dot products: 280 cases
across 25 configurations, including 160 partial tails and 103 nonzero-error cases, with six
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

## Certification and bounded application

`check_certificates.py` checks `tc_certify`/`tc_certificate`, an explicit supplied proof,
eight failed certification commands, and preservation of a valid declaration after an
unrelated earlier error. A failed generated theorem is absent from the environment.
The compiled-definition dependency walk checks three executable entry points and rejects
a deliberately model-dependent negative control. Proof bodies and constant types are
excluded from that walk; proof trust is covered separately by the full axiom audit.

`check_application.py` compares 87 cases at 12 lengths from 0 through 512, including
partial tails, arbitrary signs, cancellation, subnormals, zeros, excessive initial magnitude,
excessive operand magnitude, and nonfinite boundaries. Every ideal uses the unpadded
original bits. There are zero mismatches, 52 family-certified cases (29 with nonzero error,
26 with partial tails), and 69 concretely certified cases. Rejected family conditions occur
14 times for length, 12 for operands, and 13 for initial c; reasons overlap. Thirty-three
cases outside the family still meet the requested tolerance when run.

At 256 positive near-boundary products, the family budget is `21/65536`, trace budget
`3/65536`, and error `1/4194304`: ratios 7 and 1,344 respectively. The 256-product random
small-input case has budget/error ratio about 1,988; cancellation can make actual error
zero, in which case the ratio is reported as null. These are conservative absolute bounds.

The report records timings for 1, 16, 64, and 256 products. Each measurement is the median
of three compiled CLI processes of 100 repeated cases, after one warmup process. The
family and concrete paths include input parsing and diagnostic JSON; the model path also
computes an exact ideal and full trace report. These are whole-tool costs, not GPU
timings or isolated arithmetic costs. Certificate example elaboration separately
includes imports and diagnostic output. Durable records:
`certificate-report.json`, `application-report.json`, and the independent rerun embedded
in `clean-build.json`; timing variation between runs is expected.

Kernel regressions additionally establish a symbolic changing-state repetition theorem,
exhibit nonzero loss, and check small-operand boundaries, signed zeros, partial tails,
excessive count, and nonfinite/too-large initial accumulators. Both new standalone examples
are compiled by the clean-build check. The combined workspace build has 148 jobs and
772 audited roots (471 written in source). The fresh combined run passes all 19
commands and eight standalone examples, with zero Lean warnings and two
`ld64.lld` warnings about missing `/usr/local/lib`. Full results are recorded in
`clean-build.json`; the tested source fingerprint is in `merge-report.json`.

## Guarded scalar coverage and bounded primitives

`check_eft.py` builds and audits the imported EFT modules, runs the actual Lean
scalar predicate against an independent original-input oracle, regenerates the
hardware expectations, and checks synthetic replay behavior. The 21,966 cases in
`eft-coverage.json` preserve the 21,000-case baseline: all 15,000 published and
3,000 near-one cases pass; broad finite-bit acceptance is 73, 13, and 0 of 1,000
for V100, A100, and H100 respectively. Accepted corrections have zero mismatches.
Additional bounded, partial-tail, and application cohorts remain distinct; the
application samples cover individual blocks, not composed correction behavior.

Both guarded public entries reject the subnormal counterexample. A second kernel
regression preserves broad V100 case 250: raw output and exact rounding are
`bf649af9`, unchecked correction is `bf649afa`, and the guarded API returns `none`.
The support-grid investigation is diagnostic only; no broader predicate is used.
Kernel regressions exercise all 256 gap encodings on six boundary/patterned
magnitudes, the maximum 11-bit product, and a negative residual. The general
primitive proofs do not establish a full extractor or correction-success family.

## Targeted hardware preparation

The 99 vectors in `data/hardware/inputs.json` cover multiple groups, later k
positions, cancellation, ordering, signed zeros, and subnormals. `expected.json`
contains unmeasured model expectations, independently checked during generation.
`replay-self-test.json` records 12 synthetic replay checks and zero measured
vectors. CUDA compilation and actual device measurements remain open.

On a supported GPU host with `nvcc` and `cuobjdump`, run
`python3 hardware/run.py --profile A100 --out data/hardware/run-A100`, then
`python3 scripts/replay_hardware.py data/hardware/run-A100/measurements.json`.
Use `V100` or `H100` for those devices. Capture records include raw inputs/outputs,
device/compiler information, binary/SASS hashes, and harness provenance. The
original measurements and vendored sources remain unchanged.

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
python3 scripts/check_certificates.py
python3 scripts/check_application.py
python3 scripts/check_eft.py
python3 scripts/check_clean_build.py
```

`check_clean_build.py` copies the source without `.lake`, builds it, and runs the audit, the
program and certificate checks, both independent oracles, the canonical and dot-product
suites, all device/format replays, the application and EFT checks, hardware generation
and synthetic replay, and every standalone example. It publishes the reports and
axiom listing from that same fresh run, preserving the historical A/B handoffs, and
writes `data/regressions/clean-build.json`. With the pinned toolchain installed,
no network access is needed.
