# Concrete certificate runtime review

Measured September 7, 2026, at revision `94b9aba73f801ef4e74dd48e981092352404b1a0`, using Lean 4.33.1 on macOS arm64. Prepared by Codex for human manual review; no author sign-off is implied. See the [overview and evidence provenance](PRACTICALITY_REVIEW.md).

**Assessment:** concrete kernel replay is the largest measured practical constraint. A 4-by-4 output with K=128 verified in 37.227 seconds; an 8-by-8 output exceeded the 60-second cutoff.

## What concrete proof replay means

The compiled analyzer computes a bound and emits a certificate for specific input words. `tc verify` checks the canonical certificate and source fingerprint, then asks Lean's trusted kernel to validate its checker computation and accuracy theorem. These timings measure that verification work. A change to the concrete inputs requires a corresponding new certificate. Reusable quantified certificates are covered in the [family report](FAMILY_CERTIFICATES_REVIEW.md).

## Measurements

For the dense FP32-to-FP16 pipeline, analysis time grows approximately with the number of products inspected. The following are medians of three processes using already-built binaries. Timing includes process startup, input parsing, analysis, and JSON output, but excludes workload generation, model execution, and Python oracle checks.

| Output M=N | Reduction K | Analysis time |
| ---: | ---: | ---: |
| 1 | 128 | 0.023 s |
| 8 | 128 | 0.171 s |
| 16 | 128 | 0.581 s |
| 32 | 128 | 2.198 s |
| 64 | 128 | 8.567 s |
| 8 | 16 | 0.037 s |
| 8 | 64 | 0.095 s |
| 8 | 256 | 0.323 s |
| 8 | 1024 | 1.258 s |

The 64-by-64 case emits 2.73 MB of analysis JSON. This is already substantial overhead for a small matrix operation; it supports offline use rather than analysis on every latency-sensitive invocation. No timings are extrapolated to unmeasured larger matrices.

Kernel replay is much slower than the compiled analyzer:

| Concrete output shape; K | Certificate bytes | Emit time | `tc verify` time |
| --- | ---: | ---: | ---: |
| 1 by 1; 16 | 2,341 | 0.229 s | 0.841 s |
| 1 by 1; 128 | 8,229 | 0.233 s | 6.896 s |
| 4 by 4; 128 | 32,821 | 0.304 s | 37.227 s |
| 8 by 8; 128 | 78,397 | 0.567 s | Exceeded 60 s cutoff |

These four runs use a loose absolute tolerance of 10 to isolate replay cost. Emission is not verification. The final row was terminated by the benchmark timeout; it is not a proof rejection, and its eventual verification time is unknown. Each replay is measured once and includes wrapper/source checks and incremental build checks.

Additional 1-by-1, K=16 certificates were successfully kernel-checked **at their exact inferred bounds**: FP16 at 0.0007766 in 0.806 s, BF16 at 0.0077214 in 0.925 s, and TF32 at 0.0007774 in 0.954 s. In total, 14 of 15 selected certificate replays completed; one timed out. The 54 numerical cases above were not all separately kernel-replayed.

## Individual analysis samples

All three process timings are retained here to make the reported medians reviewable. JSON sizes count UTF-8 output bytes.

| M=N | K | Run 1 (s) | Run 2 (s) | Run 3 (s) | JSON bytes |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 128 | 0.023248 | 0.022352 | 0.023010 | 998 |
| 8 | 128 | 0.170974 | 0.170397 | 0.172820 | 43,004 |
| 16 | 128 | 0.580686 | 0.596161 | 0.574550 | 170,584 |
| 32 | 128 | 2.197799 | 2.180320 | 2.241935 | 681,145 |
| 64 | 128 | 8.566755 | 8.565046 | 8.571157 | 2,726,169 |
| 8 | 16 | 0.036782 | 0.038528 | 0.036359 | 28,768 |
| 8 | 64 | 0.094795 | 0.094735 | 0.093904 | 35,144 |
| 8 | 256 | 0.323480 | 0.326438 | 0.320850 | 58,148 |
| 8 | 1024 | 1.232832 | 1.268219 | 1.258144 | 147,960 |

## Exact-bound concrete replay details

These use a single output with K=16; the native BF16/TF32 exports also recompute inference through their selection certificates. All three completed successfully.

| Precision | Exact certified tolerance | Certificate bytes | Emit (s) | Verify (s) |
| --- | --- | ---: | ---: | ---: |
| FP16 | `3497475500879/4503599627370496` | 2,393 | 0.227020 | 0.806256 |
| BF16 | `34774268428025/4503599627370496` | 2,600 | 0.231515 | 0.924885 |
| TF32 | `3501099379535/4503599627370496` | 2,598 | 0.228479 | 0.953598 |

## Questions for manual review

- Can certificates be prepared offline, or does the intended workflow require verification for every invocation?
- Can a family certificate amortize the verification work while retaining an acceptable bound?
- Are the measured process/serialization costs acceptable, and does the application require a larger concrete replay budget? The timed-out result is not a proof rejection.
