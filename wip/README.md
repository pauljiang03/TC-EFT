# Archived FP16-output and FP8 work

This directory contains the V100 FP16-output tensor-core candidates and all FP8
models, dedicated tests, examples, and evidence. They were moved out of the active
library on 14 September 2026. The archive preserves the work for reconciliation.

| Work | Why it is archived | Evidence retained |
| --- | --- | --- |
| V100 FP16 output | Direct FP16 rounding and FP32 truncation followed by FP16 rounding disagree on a constructed input. Existing device rows do not determine the stage order. | Both candidates match all 5,000 published rows. The kernel-checked `half_output_stage_order` witness distinguishes them. |
| L40S/Ada FP8, E4M3 and E5M2 | The paper reading and MATLAB v0.5 source reading differ in normalized output precision. | Across 10,000 published rows, the paper reading has 2,017 mismatches. The separate `source13` candidate has zero. |

These are unresolved model-to-source or model-to-device questions. The candidate
proofs remain useful statements about their explicit definitions. A passing WIP
check preserves the evidence and does not resolve either question.

## Contents

- [`TensorCoreWip/`](TensorCoreWip): FP8 formats, candidate definitions, proofs, and regression witnesses.
- [`WipMain/Features.lean`](WipMain/Features.lean): the separate candidate executable.
- [`scripts/`](scripts) and [`examples/`](examples): reproducible candidate checks.
- [`data/regressions/`](data/regressions): FP16-output and FP8 evidence reports.
- [`vendor/`](vendor): dedicated, unmodified MATLAB v0.5 sources and device vectors, with hashes and license.
- [`docs/proofs/`](docs/proofs): historical proof pages with links pinned to the source revision.
- [`ARCHIVE.json`](ARCHIVE.json): original paths, destination paths, source revision, and pre-archive hashes.

Shared V100 inputs and MATLAB helpers remain in the repository's `vendor/` because
the active FP32-output checks also use them. The WIP source manifest records that
dependency. Historical audits under the repository's `reviews/` retain their
original scope and counts.

## Run the archive

From the repository root:

```sh
python3 wip/scripts/check.py
```

This verifies pinned file hashes, builds the optional library and executable,
checks the FP8 example, and reruns both evidence scripts. To build only:

```sh
lake build TensorCoreWip tc_wip_features
```

Use `import TensorCoreWip` for the archived library. Existing declaration namespaces
are preserved; module paths now start with `TensorCoreWip`. Candidate commands use
`.lake/build/bin/tc_wip_features`. They are no longer accepted by `tc_features`.

`lake build`, `import TensorCore.All`, and `./tc check` cover the active development
and exclude WIP candidates. The layout check rejects active imports of WIP modules.

## Active scope and next validation

FP16-input/FP32-output TC and TC-EFT remain active, along with the existing BF16 and
TF32 paths, scalar arithmetic, and GEMM extensions. The FP16 scalar format and
generic rounding operations are still needed for input conversion and scalar
semantics; the archived FP16 work concerns tensor-core output behavior.

For the main FP16-input/FP32-output path, the formal proofs, independent
specification equivalence proofs, negative controls, and 15,000 matching published
device rows provide good evidence of agreement with the formalized paper model.
Human review of the paper-to-definition translation is still valuable. The next
hardware step is targeted conformance testing on the intended GPU and instruction,
especially cancellation, rounding boundaries, subnormals, and group order.

Restoring the archived paths requires resolving the FP16-output stage order and
FP8 normalized precision against the intended specification and discriminating
hardware measurements. More rows that make both candidates agree cannot settle
those questions.
