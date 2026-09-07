# Accuracy bounds review

Measured September 7, 2026, at revision `94b9aba73f801ef4e74dd48e981092352404b1a0`, using Lean 4.33.1 on macOS arm64. Prepared by Codex for human manual review; no author sign-off is implied. See the [overview and evidence provenance](PRACTICALITY_REVIEW.md).

**Assessment:** the bounds were sound on the measured model outputs. Source-conversion conservatism prevented certification of several inputs whose actual model errors met the requested tolerance. All 54 cases certified 0.0001 when the reference used already-quantized operands.

## Workloads and validation

The local benchmark harness (`tensor-core/scripts/benchmark_practicality.py`, not included in this Markdown-only publication) generates six workload types, with three fixed seeds each. Each computes an 8-by-128 times 128-by-8 product, with the declared scalar epilogue. All source operands start as FP32; product precision is separately FP16, BF16, or TF32 under the Hopper WMMA model. Conversion and scalar stages use nearest-even rounding. These are 54 synthetic cases, not trained-model weights, application traces, or hardware executions.

| Workload | Construction |
| --- | --- |
| Dense layer | Standard normal A, normal B scaled by `1/sqrt(K)`, small normal C, alpha=beta=1 |
| Attention scores | Standard normal A/B, alpha rounded to FP32 `1/sqrt(K)`, C=0 |
| Nonnegative product | Absolute values of the dense operands, C=0 |
| Sparse product | Approximately 90% of A entries zero, normal B scaled by `1/sqrt(K)`, C=0 |
| Gram matrix | `A Aᵀ/K`, C=0 |
| Cancellation diagnostic | Consecutive opposing A terms and repeated B rows; a small final perturbation leaves a near-zero ideal |

The benchmark independently recomputes both signed rational ideals for all **3,456 output entries**, checks their encoded model errors against the reported bounds, and compares every group and epilogue stage with the repository's independent Python oracle at **162 sampled output coordinates**. There were no discrepancies. The four original-source tolerance decisions are also exercised through the compiled analyzer, rather than inferred only from the reported bounds.

The measured target is the separately rounded pipeline `alpha*TC(convert(A),convert(B),+0) + beta*C`, including its scalar stages. It is not an arbitrary vendor GEMM epilogue. Here, "actual error" means the exact error of that executable arithmetic model.

## Results and interpretation

Against the **original FP32 source ideal**, the following counts hold. "Within" means all 64 model outputs actually satisfy the absolute tolerance; "certified" means the analyzer establishes it.

| Product precision | Certified at 0.001 | Within 0.001 | Certified at 0.01 | Within 0.01 |
| --- | ---: | ---: | ---: | ---: |
| FP16 | 6/18 | 18/18 | 18/18 | 18/18 |
| BF16 | 0/18 | 6/18 | 6/18 | 18/18 |
| TF32 | 6/18 | 18/18 | 18/18 | 18/18 |

For FP16/TF32 at 0.001, the certified cases are the sparse and Gram workloads. The other 12 in each precision are conservative refusals. Across all three precisions, 42 cases meet 0.001 but only 12 certify. No original-source case certifies 0.0001. These fixed-suite counts are not estimates of production acceptance rates.

Input conversion contributes a median **99.67% / 99.98% / 99.29%** of the summed FP16/BF16/TF32 bounds. Excluding the cancellation diagnostic, the ratio of maximum bound to maximum observed error has a median near four for each precision. The cancellation ratios range from approximately 47 to 1,879. The analysis propagates absolute magnitudes and per-product conversion bounds; it loses cancellation that can reduce the final signed error. See [GroupAnalysis.lean](tensor-core/TensorCore/Programs/GroupAnalysis.lean) and [NativeConvertedAnalysis.lean](tensor-core/TensorCore/Programs/NativeConvertedAnalysis.lean).

For a second pass, the source words are replaced by FP32 encodings of the already-quantized operands. Their conversion to the product format is then exact, and the tensor execution is unchanged. **All 54 cases certify 0.0001 against this different ideal.** The observed maximum errors across each precision are:

| Product precision | Largest observed error | Largest inferred bound |
| --- | ---: | ---: |
| FP16 | 5.71e-6 | 1.44e-5 |
| BF16 | 2.30e-6 | 6.65e-6 |
| TF32 | 1.15e-5 | 3.14e-5 |

This makes the tool more promising when an application needs a guarantee relative to values already stored at reduced precision. That guarantee does not recover the original FP32 values' accuracy. These are separate precision experiments, not a certified decision selecting among all three formats.

Absolute tolerance must also match the application. In the cancellation diagnostics, every output passes 0.001, but the maximum actual error is about **1–18.5 times the largest ideal output magnitude**. Passing that tolerance gives little useful relative accuracy there. The normalized values retained in the local measurement JSON are descriptive; they are not elementwise relative-error certificates.

## Per-case measurements

All cases have M=N=8 and K=128. Values below are rounded to eight significant digits for display; comparisons used exact rationals. "Source" references the original FP32 ideal; "quantized" references the ideal after conversion to product precision. The same tensor execution underlies both errors.

### FP16

| Workload / seed | Source max error | Source max bound | Quantized max error | Quantized max bound | Source certifies 0.001 |
| --- | ---: | ---: | ---: | ---: | --- |
| dense / 20260907 | 0.00065806486 | 0.0032988741 | 8.3062332e-07 | 1.0758638e-05 | No |
| dense / 20260908 | 0.00077169962 | 0.0031391225 | 5.3353142e-07 | 1.4159828e-05 | No |
| dense / 20260909 | 0.00070805587 | 0.003045031 | 3.8271537e-07 | 1.0639429e-05 | No |
| attention / 20260907 | 0.00097042102 | 0.0031513726 | 9.8068936e-07 | 1.306294e-05 | No |
| attention / 20260908 | 0.00060000592 | 0.0034744965 | 7.1457857e-07 | 1.4435397e-05 | No |
| attention / 20260909 | 0.00072294903 | 0.0032045188 | 4.3257371e-07 | 1.1782729e-05 | No |
| nonnegative / 20260907 | 0.00074081127 | 0.0032979204 | 4.6220375e-06 | 9.8049641e-06 | No |
| nonnegative / 20260908 | 0.00061390721 | 0.0031381688 | 5.7120924e-06 | 1.3206154e-05 | No |
| nonnegative / 20260909 | 0.00077391711 | 0.0030440773 | 4.9178925e-06 | 1.0162592e-05 | No |
| sparse90 / 20260907 | 0.00029020185 | 0.00045452403 | 1.1152588e-07 | 6.2957406e-07 | Yes |
| sparse90 / 20260908 | 0.00030789324 | 0.00055374056 | 1.4225952e-07 | 9.9092722e-07 | Yes |
| sparse90 / 20260909 | 0.00036849834 | 0.00072264584 | 1.0459917e-07 | 9.0152025e-07 | Yes |
| gram / 20260907 | 7.4211023e-05 | 0.00039884295 | 5.1818643e-07 | 1.4139805e-06 | Yes |
| gram / 20260908 | 0.00011780052 | 0.00040948186 | 7.3045885e-07 | 1.9297004e-06 | Yes |
| gram / 20260909 | 0.00010131026 | 0.00035671204 | 5.4603208e-07 | 1.4121179e-06 | Yes |
| cancellation / 20260907 | 8.6163219e-05 | 0.0040792277 | 3.7252903e-09 | 1.2770295e-05 | No |
| cancellation / 20260908 | 3.9906562e-05 | 0.003520526 | 1.8626451e-09 | 1.3679266e-05 | No |
| cancellation / 20260909 | 5.8584734e-05 | 0.0037613369 | 0 | 1.1645257e-05 | No |

### BF16

| Workload / seed | Source max error | Source max bound | Quantized max error | Quantized max bound | Source certifies 0.001 |
| --- | ---: | ---: | ---: | ---: | --- |
| dense / 20260907 | 0.0066053833 | 0.025580825 | 6.4074993e-07 | 5.3942204e-06 | No |
| dense / 20260908 | 0.0097398918 | 0.02854139 | 4.4330955e-07 | 6.6459179e-06 | No |
| dense / 20260909 | 0.0049016757 | 0.023551268 | 3.7904829e-07 | 5.2154064e-06 | No |
| attention / 20260907 | 0.0074380037 | 0.025497292 | 4.8079935e-07 | 5.4844605e-06 | No |
| attention / 20260908 | 0.0066351405 | 0.028468079 | 3.5624102e-07 | 6.15881e-06 | No |
| attention / 20260909 | 0.004012467 | 0.025684588 | 2.7664855e-07 | 6.3484708e-06 | No |
| nonnegative / 20260907 | 0.0042133898 | 0.025579872 | 1.8971041e-06 | 4.440546e-06 | No |
| nonnegative / 20260908 | 0.0052467168 | 0.028540437 | 2.2985041e-06 | 5.6922436e-06 | No |
| nonnegative / 20260909 | 0.0065445645 | 0.023550314 | 1.8775463e-06 | 4.440546e-06 | No |
| sparse90 / 20260907 | 0.0021773637 | 0.0039749773 | 2.2351742e-08 | 5.8487058e-07 | No |
| sparse90 / 20260908 | 0.0021468269 | 0.0044360704 | 8.9406967e-08 | 9.0152025e-07 | No |
| sparse90 / 20260909 | 0.0024912376 | 0.0047575527 | 4.2840838e-08 | 7.9721212e-07 | No |
| gram / 20260907 | 0.00046948696 | 0.0033730919 | 2.1528831e-07 | 7.7113509e-07 | No |
| gram / 20260908 | 0.00062934488 | 0.0030907928 | 2.5914051e-07 | 9.2759728e-07 | No |
| gram / 20260909 | 0.0009350974 | 0.003050215 | 2.4989276e-07 | 7.0035458e-07 | No |
| cancellation / 20260907 | 0.00041077011 | 0.029455702 | 0 | 5.1707029e-06 | No |
| cancellation / 20260908 | 4.0028069e-05 | 0.030315197 | 0 | 5.7220459e-06 | No |
| cancellation / 20260909 | 1.5086607e-05 | 0.028353739 | 0 | 5.453825e-06 | No |

### TF32

| Workload / seed | Source max error | Source max bound | Quantized max error | Quantized max bound | Source certifies 0.001 |
| --- | ---: | ---: | ---: | ---: | --- |
| dense / 20260907 | 0.00065794565 | 0.0033106013 | 2.2611348e-06 | 2.2489578e-05 | No |
| dense / 20260908 | 0.00077134199 | 0.0031517214 | 1.3315293e-06 | 2.9087067e-05 | No |
| dense / 20260909 | 0.0007084135 | 0.003056572 | 1.4368379e-06 | 2.1696091e-05 | No |
| attention / 20260907 | 0.00097030181 | 0.0031623413 | 2.0592681e-06 | 2.5730702e-05 | No |
| attention / 20260908 | 0.0005997973 | 0.0034874566 | 2.14509e-06 | 2.6626373e-05 | No |
| attention / 20260909 | 0.00072282982 | 0.0032155982 | 1.5755081e-06 | 2.4753421e-05 | No |
| nonnegative / 20260907 | 0.00074319546 | 0.0033096476 | 8.5302745e-06 | 2.1535903e-05 | No |
| nonnegative / 20260908 | 0.00061724507 | 0.0031507678 | 1.1451077e-05 | 2.8133392e-05 | No |
| nonnegative / 20260909 | 0.00077582445 | 0.0030556183 | 8.4718631e-06 | 2.1219254e-05 | No |
| sparse90 / 20260907 | 0.00029020185 | 0.00045533731 | 2.3073517e-07 | 2.19699e-06 | Yes |
| sparse90 / 20260908 | 0.00030789324 | 0.00055584162 | 2.3585744e-07 | 3.6219135e-06 | Yes |
| sparse90 / 20260909 | 0.00036846854 | 0.00072503747 | 1.587905e-07 | 3.2261014e-06 | Yes |
| gram / 20260907 | 7.4214748e-05 | 0.00040013385 | 9.9502358e-07 | 3.0412339e-06 | Yes |
| gram / 20260908 | 0.00011827735 | 0.00041079595 | 1.0880867e-06 | 3.5366975e-06 | Yes |
| gram / 20260909 | 0.00010154868 | 0.00035788993 | 1.0228692e-06 | 2.7827919e-06 | Yes |
| cancellation / 20260907 | 8.6163219e-05 | 0.0040932012 | 0 | 2.6186928e-05 | No |
| cancellation / 20260908 | 3.9906562e-05 | 0.003535904 | 0 | 3.1415373e-05 | No |
| cancellation / 20260909 | 5.8584734e-05 | 0.0037763843 | 0 | 2.6692636e-05 | No |

## Questions for manual review

- Does the intended application need accuracy relative to original FP32 values or values already stored at product precision?
- Is an absolute per-entry tolerance meaningful at the application's output scale, especially near cancellation?
- Are these synthetic distributions representative enough to justify the intended use, or should application inputs replace them?
