**Reproducing the independent review of `49e8768`**

Read the [assessment](../../INDEPENDENT_REVIEW.md) before interpreting the results.
These checks concern the declared finite arithmetic model, not physical GPU
conformance. They require the repository's pinned Lean toolchain, a working native
C toolchain, and Python 3. No Python packages or repository test oracles are used.

From the repository root:

```sh
python3 reviews/2026-09-07/run_review.py
```

The runner verifies the original Lean source hashes before running. A later
revision with different theory sources must be reviewed again; changing or
bypassing the manifest does not extend this assessment. The review publication
changes documentation and adds these checks without changing the theory.

The runner builds the probe, checks 284,735 exact-value cases and 144 matrix
requests, audits theorem dependencies, checks scope/refusal witnesses, replays the
valid certificate, and requires the deliberately invalid proof to fail. Both
oracles use fixed seeds. Successful checks fail the process on a mismatch;
the negative control additionally requires a Lean `decide` failure diagnostic.
The separate refusal witness proves the stricter Boolean condition is false.

Generated transcripts and binaries are ignored by Git. The deterministic
`independent-results.json` and `matrix-checks.json` summaries are regenerated.
Fresh command logs and a step summary are written under `tmp/` in this directory.
The top-level audit logs and `validation-reports/` are evidence from the original
review run, not automatically replaced by the runner.

Individual commands, starting at the repository root:

```sh
python3 reviews/2026-09-07/build_probe.py
python3 reviews/2026-09-07/check_independent.py
python3 reviews/2026-09-07/check_gemm_independent.py
./tc verify reviews/2026-09-07/AccuracyCertificate.lean
```

From the `tensor-core` subdirectory:

```sh
lake env lean -t 0 ../reviews/2026-09-07/TrustAudit.lean
lake env lean -t 0 ../reviews/2026-09-07/ScopeWitnesses.lean
lake env lean -t 0 ../reviews/2026-09-07/RefusalWitness.lean
lake env lean -t 0 ../reviews/2026-09-07/TamperedCertificate.lean
```

The **last command must fail**. `TamperedCertificate.lean` is intentionally invalid
and is not part of the library's import graph or a valid exported certificate.
The valid certificate used a tolerance of `1/1000000`; the negative control asks
the same fixed input checker to accept `1/1000000000`.

To regenerate the valid certificate, use a new output filename:

```sh
./tc analyze reviews/2026-09-07/certificate-input.jsonl --abs-tol 0.000001 --emit tmp/review-certificate.lean
./tc verify tmp/review-certificate.lean
```

For the repository's separate complete suite, run `./tc build` and `./tc check`
from the root. The latter creates a fresh source copy and rewrites generated
reports under `tensor-core/data/regressions/`. Its archived review result is
`validation-reports/clean-build.json`: all 50 gates passed with no Lean warnings.
Do not mistake the independent runner for a replacement for that full suite.

`review-provenance.json` pins the reviewed revision, toolchain, and library source
hashes. The fresh-copy build report supplies broader validation provenance.
The full suite and these extra checks do not constitute an exhaustive manual
review of every informal claim or a human sign-off.
