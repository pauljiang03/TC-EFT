# Family certificates review

Measured September 7, 2026, at revision `94b9aba73f801ef4e74dd48e981092352404b1a0`, using Lean 4.33.1 on macOS arm64. Prepared by Codex for human manual review; no author sign-off is implied. See the [overview and evidence provenance](PRACTICALITY_REVIEW.md).

**Assessment:** uniform and per-entry family certificates are implemented. Four uniform families with 4096-by-4096 output shapes were successfully kernel-checked at their exact inferred bounds, in approximately 0.5 seconds each.

## Implemented contract

- **Uniform families:** one magnitude cap each for A, B, and C.
- **Per-entry families:** a cap for every A/B/C entry; inference reduces each output's A row and B column to their maxima.
- **Scope:** the raw tensor-core model `TC(A,B,C)`, with finite FP16 A/B and FP32 C, fixed dimensions and architecture, and an absolute accuracy tolerance.
- **Reuse:** the guarantee applies to every encoded matrix satisfying the declared caps. Applying it requires establishing those membership premises for the actual inputs.

The new scaling experiment below covers uniform families. The earlier [manual source review](MANUAL_REVIEW.md) separately inspected both implementations and successfully replayed a per-entry certificate at tolerance 0.001.

## Uniform family measurements

Uniform family analysis does not inspect concrete arrays. For output shape 4096-by-4096, finite FP16 A/B, FP32 C=0, and bounds `abs(A) <= 1`, `abs(B) <= 1/sqrt(K)`, the following **exact-bound family certificates** verified:

| K | B cap | Certified absolute entry bound | Analysis time | Kernel verification |
| ---: | ---: | ---: | ---: | ---: |
| 64 | 1/8 | 0.0010414 | 0.016 s | 0.539 s |
| 256 | 1/16 | 0.0083313 | 0.017 s | 0.495 s |
| 1024 | 1/32 | 0.0666504 | 0.017 s | 0.475 s |
| 4096 | 1/64 | 0.5332031 | 0.017 s | 0.481 s |

The certificates are approximately 1 KB. The theorem covers every encoded matrix satisfying the caps without enumerating its entries. No 4096-by-4096 concrete GEMM was executed. Applying the certificate still requires establishing that the actual inputs satisfy the finite-value and magnitude premises; that membership work was not timed.

The tradeoff is increasingly loose bounds as K grows. These families cover raw `TC(A,B,C)` with FP16 inputs. They do not include FP32-to-FP16 source error, arbitrary scalar epilogues, or BF16/TF32 families. The existing per-entry families retain only A-row and B-column maxima, so internal sparsity does not automatically yield a proportionate improvement. See [GemmFamily.lean](tensor-core/TensorCore/Programs/GemmFamily.lean) and [EntryFamily.lean](tensor-core/TensorCore/Programs/EntryFamily.lean).

## Exact tolerances and witnesses

The following witnesses were inferred from the declared caps. Each certificate was regenerated and verified with its exact entry bound as the requested tolerance. `E` is the accumulator scale, `P` the product scale, `L` the carry-bit parameter, and the initial C bound is zero.

| K | Exact entry tolerance | E | P | L | Certificate bytes |
| ---: | --- | ---: | ---: | ---: | ---: |
| 64 | `273/262144` | 5 | -3 | 5 | 994 |
| 256 | `273/32768` | 6 | -4 | 5 | 998 |
| 1024 | `273/4096` | 7 | -5 | 5 | 1000 |
| 4096 | `273/512` | 8 | -6 | 5 | 998 |

## Replaying a family from the repository

This example reconstructs the K=256 request directly, without the local benchmark harness. Run from the repository root, using a fresh output path if the certificate already exists.

```sh
mkdir -p tmp
cat > tmp/reviewer-family-k256.jsonl <<'JSON'
{"operation":"family","model":"hopper","m":4096,"n":4096,"k":256,"a_bound":"1/1","b_bound":"1/16","c_bound":"0/1"}
JSON
./tc analyze tmp/reviewer-family-k256.jsonl --abs-tol 273/32768 --emit tmp/ReviewerFamilyK256.lean
./tc verify tmp/ReviewerFamilyK256.lean
```

For the existing per-entry demonstration, use `tensor-core/data/examples/gemm.entry-family.jsonl` with `./tc analyze` and tolerance `0.001`.

## Questions for manual review

- Can the application establish the finite-value and magnitude caps for every actual input?
- Is the uniform bound acceptable at the intended K and output scale?
- Does the computation fit raw FP16-input `TC(A,B,C)`, or does it need source-conversion, epilogue, or native-precision family support? Those extensions remain open.
