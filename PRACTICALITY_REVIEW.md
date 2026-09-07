# Practicality review overview

**Assessment:** useful as a formal arithmetic reference and for offline certification, especially reusable input families. Conservative source-conversion bounds and expensive concrete kernel replay are the main measured limitations. These results do not establish deployed application usefulness or GPU performance.

Measured September 7, 2026, at revision `94b9aba73f801ef4e74dd48e981092352404b1a0`, using Lean 4.33.1 on macOS arm64. Prepared by Codex for human manual review; no author sign-off is implied. The existing [manual source review](MANUAL_REVIEW.md) covers arithmetic correctness claims.

## Separate reports

| Report | Main finding |
| --- | --- |
| [Accuracy bounds](ACCURACY_BOUNDS_REVIEW.md) | All 54 quantized-reference cases certified 0.0001. At original-source tolerance 0.001, 42 cases met the tolerance but only 12 certified. Includes every case's measured maxima. |
| [Concrete analysis and certificate runtime](CERTIFICATE_RUNTIME_REVIEW.md) | Analysis took 8.567 s for 64-by-64 outputs at K=128. Concrete replay took 37.227 s for 4-by-4 outputs; 8-by-8 exceeded 60 s. |
| [Family certificates](FAMILY_CERTIFICATES_REVIEW.md) | Uniform and per-entry families are implemented. Four large-shape uniform family certificates verified at their exact bounds in about 0.5 s each. Includes a standalone replay command. |
| [Earlier manual source review](MANUAL_REVIEW.md) | No actionable correctness defect found in the reviewed C01–C16 claims; all 50 clean-suite gates passed, subject to the documented source and hardware limits. |

## Overall implications

- **Useful now:** a formal reference, small offline concrete certificates, and reusable range guarantees when their absolute bounds meet an application's requirements.
- **Main measured constraints:** conservative source-conversion bounds and slow concrete kernel replay. Inputs already represented at product precision fare substantially better in this suite.
- **Still needed for deployment claims:** an actual application and its error budget, validation of the hardware/compiler/epilogue mapping, and measured execution costs. The current selector minimizes supplied costs among analyzer-certified candidates; it does not discover GPU costs or establish that uncertified candidates are inaccurate. A single decision across FP16/BF16/TF32 is not implemented.
- **Highest-value next work:** evaluate one concrete application's accuracy criterion, improve conversion-bound tightness for its data, and reduce or amortize kernel replay. Additional arithmetic fuzzing would not resolve these measured limitations.

The repository separately reports CPU improvements to bounded EFT against its own previous bit-scan implementation. Those measurements do not establish an advantage over GPU libraries, and this review does not re-benchmark EFT throughput. The [README](README.md) already distinguishes these implementation and hardware boundaries.

## Evidence and publication scope

The empirical suite uses six synthetic workload types, three seeds, and three product precisions. Both signed rational ideals were independently recomputed for all 3,456 output entries; model group and scalar-stage outputs were compared against the existing independent Python oracle at 162 coordinates. There were no discrepancies. Of 15 selected certificate replays, 14 completed and one exceeded a 60-second cutoff. The reports distinguish compiled analysis from individual kernel replay.

This publication contains Markdown reports only. The benchmark harness, machine-readable summary, concrete inputs, certificates, and logs remain in the local checkout; no implementation or proof files are included in the report commit. The earlier `MANUAL_REVIEW.md` is unchanged.

Local evidence locations, which are deliberately not GitHub links:

- `tensor-core/scripts/benchmark_practicality.py`: standard-library Python benchmark harness.
- `tensor-core/data/regressions/practicality-report.json`: exact rational measurements, decisions, timings, and fingerprints.
- `tmp/practicality/`: generated requests, per-case analyses, certificates, and execution logs.

With the local harness present, `python3 tensor-core/scripts/benchmark_practicality.py --out tmp/practicality-independent` starts an independent run. A fresh GitHub clone has the Markdown reports and existing project commands, but does not include that unpublished harness. The family report's standalone command can be used directly from a clone.

| Provenance | Recorded value |
| --- | --- |
| Measured revision | `94b9aba73f801ef4e74dd48e981092352404b1a0` |
| Theory SHA-256 | `2e3d7845b170bc6e68eb899d3ab329698cd25fc41a8a73c758dbbbc47bc4ae27` |
| Benchmark SHA-256 | `12b10406cc1f287eaa6f34bbbb4575bc0d2d643d3d5ed078ddf3be257ca8eb65` |
| Local measurement JSON SHA-256 | `92a05a075e90d6117b1024b904e61fcab96d512cbaebf85a9175739dd3059831` |
| Seeds | `20260907, 20260908, 20260909` |
| Host | `macOS-26.6.2-arm64-arm-64bit` |
| Python | `3.9.6` |
| Lean | `4.33.1` |

All 54 regenerated request hashes matched the recorded inputs after completing the harness. Analysis medians use three processes with built binaries; supplementary quantized analyses and individual replay timings use one sample. Timings are local CPU observations, with no confidence interval or extrapolation to other machines. The CPU brand query was sandbox-restricted; macOS arm64 is the available host identification.
