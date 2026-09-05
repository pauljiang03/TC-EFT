# Feature coverage

Reviewed against Accurate Models v4 (§2, §§4.1.1–4.1.8, Figs. 2–5, Tables 2–4, §4.2.1) and
MATLAB Tensor Core v0.5, commit `bbcf00a273868172494eaacaa8d6128ab0fb8704`. The arithmetic
unit is one dot product with raw products and one block accumulation. Group partitions and
their order inside an instruction are a separate question ([COMPOSITION.md](COMPOSITION.md)).

The claimed family is FP16 products with FP32 c and output, any product count `K`, and any
number of extra alignment bits. Every other row is either an executable specification
without proofs beyond exact loss accounting, or not implemented.

## Source families

`K` counts products, excluding c. `F` counts all fractional alignment bits, including extra
bits; the two integer bits accommodate unnormalized product significands below four. The
accumulator widths in Table 3 are magnitude/carry labels, not signed register widths. All
listed mixed-precision paths keep raw products and truncate magnitudes at alignment, and all
support subnormal operands.

| Family / source path | K | F | Floor | c / output stages | Current claim |
| --- | ---: | ---: | ---: | --- | --- |
| V100, FP16, WMMA / HMMA.844 | 4 | 23 | none relevant | c in group; FP32 RTZ | `fp16Fp32Profile 4 0`; proved, oracle-checked, 5,000 published vectors |
| A100/A2/A30, FP16, WMMA / HMMA.1688; L40S/Ada corresponding paths | 8 | 24 | −132 | FP32 c in group; FP32 RTZ | `fp16Fp32Profile 8 1 (−132)`; proved, oracle-checked, 5,000 published A100 vectors; floor proved inert |
| H100/H200/B200/RTX PRO, FP16, HMMA.16816; B200 UTCHMMA f16 | 16 | 25 | −133 | FP32 c in group; FP32 RTZ | `fp16Fp32Profile 16 2 (−133)`; proved, oracle-checked, 5,000 published H100 vectors; floor proved inert |
| A100/A2/A30 and Hopper/Blackwell BF16 | 8 / 16 | 24 / 25 | −132 / −133 | FP32 c in group; FP32 RTZ | `a100BF16Invocation`, `hopperBF16Invocation`: descriptors match 5,000 published rows each, none reaching the floor; no rounding proof; not claimed |
| Ampere/Ada, TF32, HMMA.1684 | 4 | 24 | −132 | FP32 c in group; FP32 RTZ | `a100TF32Invocation` with `tf32Register` padding checks: matches 5,000 published rows; no rounding proof; not claimed |
| Hopper/Blackwell TF32, WMMA / HMMA.1684 | 4 | 25 | −133 | FP32 c in group; FP32 RTZ | `hopperTF32WmmaInvocation`: matches 5,000 published rows; distinct from the K = 8 path; not claimed |
| Hopper/Blackwell TF32, mma.sync m16n8k8 / HMMA.1688; B200 tcgen05 kind=tf32 | 8 | 25 | −133 | FP32 c in group; FP32 RTZ | `InvocationSpec` only; instruction mapping open |
| V100 and later, FP16 output | as above | as above | as above | final FP16 RNE; stage order to resolve | Two candidate specifications kept (register item 1); neither claimed |
| L40S/Ada native FP8, mma.sync m16n8k16/32 / QMMA.16816 | 16 | 13 | irrelevant for finite FP8 products | c in group; FP32 RTZ or FP16 RNE | Not implemented; output-precision question (register item 2) |
| Hopper native FP8, wgmma m64nNk32 / QGMMA.16832 | 32 | 13 | irrelevant | c in group; FP32 RTZ or FP16 RNE | Not implemented; register item 2 |
| B200 native FP8, tcgen05 kind=f8f6f4 / UTCQMMA; RTX PRO mma.sync / QMMA.16832 | 32 | 25 | irrelevant | c in group; FP32 RTZ or FP16 RNE | Not implemented; register item 3 |
| Hopper/B200 emulated FP8, mma.sync / HMMA.16816 | 16 per component group | 25 | to specify | exact FP8→FP16 preparation; interleaved groups; late c with RNE | Not implemented; group combination to reconcile (register item 4) |
| A100 and later FP64 / DMMA.884 | 1 | no truncating alignment | none | exact fused product plus c, one FP64 rounding; four directions | `binary64Fma` executable specification; no rounding proof; not modeled in v0.5 (§4.2) |

"Hopper/Blackwell" abbreviates the named devices and paths in Tables 3–4. A2/A30 have no
FP64 variant (§4.1.3). V100 does not accept BF16. Turing, FP6/FP4, block scaling, and
arbitrary custom-model flags are outside the characterized universe.

## Feature obligations

| Axis | Meaning and source | Coverage and needed work |
| --- | --- | --- |
| Encoded value | IEEE-style sign/exponent/fraction for FP16, BF16, TF32 value, FP32, FP64, E5M2 (Table 2; `GEMM.fpformatinfo`) | `Format`/`classify` are parametric and the formats are named; representation and rounding proofs exist for FP32 only |
| E4M3 | Bias 7, precision 4, maximum 448; exponent 15 is finite except fraction 7 (Table 2, OCP) | `ValueFormat` with the `finiteTopNaN` policy decodes it; no further proofs |
| TF32 storage | 10 fraction bits and 8 exponent bits; the source calls it tf19 and prepares it with CPFloat RTZ | `tf32Register` requires the 13 low bits to be zero; conversion from arbitrary FP32 is separate and not modeled |
| Operand preparation | Already-encoded operands versus conversion; subnormal keep/flush | The core accepts encoded finite operands and keeps subnormals; conversions need their own loss accounting |
| Raw product | Signed significand product, sum of scales and fractional widths; no normalization or clipping (§4.2.1) | `rawProduct_value` proved; metadata retained |
| c format and membership | Source prepares c in the output format; most paths align it with products; Fig. 5c adds it late | `InvocationSpec` has a c format and `CPlacement` (in group, or after products through conversion stages); exact loss accounting proved; no late-c device evidence |
| Exponent selection | Ignore zero terms, maximum nonzero raw scale, then floor; nonzero subnormal FP32 c has scale −126 (§4.1.2, §4.1.6) | `alignmentScale_none`, `eta_term`, `alignmentScale_lower` proved; floors at or below −126 proved inert for FP16 operands |
| Alignment | `qA = 2^(η−F)`; sign times floor of magnitude/qA; no sticky bits on the characterized paths | Generic signed residual bound proved; arithmetic shift of negatives is a different operation |
| Accumulation | Exact signed integer sum on qA; no intermediate normalization | `accumulator_value` proved; per-term bound `2^(F+2)`, prefix exactness, and the derived signed width `F + 2 + carry + 1` proved |
| Output | Normalize and convert through explicitly ordered formats and modes, decoding between stages | `roundBinary` implements every format and directed mode and `runConversions` chains stages with proved loss accounting; correctness is proved for FP32 only |
| Finite domain | Reject nonfinite input, invalid shape, and out-of-range conversion inputs | The finite guard is narrower than IEEE overflow handling; each stage checks its own range |
| Zero | Exact zero gives +0; negative nonzero rounded to zero keeps its sign | Model policy, not a hardware theorem; value-level proofs identify both zeros |
| FP64 FMA | One exact a·b + c and one rounding; no lossy alignment grid | `AccumulationKind.fused` with `binary64Fma`; no rounding proof |
| Evidence | Model proof, independent oracle, published vectors, instruction mapping | Kept separate; device evidence covers single groups on V100, A100, and H100 for FP16 (claimed family) and on A100 and H100 for BF16 and TF32 (descriptors only) |

## Reconciliation register

Source questions to settle before the corresponding rows are assigned to hardware.
Independent arithmetic and proof work can proceed meanwhile.

1. **FP16 output stage order.** Figs. 2–5 show a normalize/truncate stage labeled FP32
   followed by FP16 RNE. In `Generic_BFMA_TC.m` lines 257–291, `ieeeround` receives
   `NoManBitsOut` directly after normalization, and `GEMM.m` lines 80–82 set it to the
   requested output's fraction width; there is no FP32 encoding boundary. Direct FP16 RNE and
   FP32 RTZ followed by FP16 RNE can disagree. Both are kept as `v100HalfDirectCandidate` and
   `v100HalfStagedCandidate`. Construct a distinguishing vector and compare with the vendored
   `d_*_fp16.txt` files before assigning either.
2. **Native FP8 output precision.** `GEMM.m` lines 92–94 reduce `NoManBitsOut` when
   `neab < 0`, while alignment independently uses `23 + neab`. For FP32 output this sets the
   post-normalization precision to 13 fraction bits; for FP16 output to zero. This does not
   transparently match Figs. 4/5d. Reconcile through vectors or source history.
3. **Blackwell FP8 output switch.** `B200TC.m` lines 103–106 assign `outformat = 'fp32'`
   before testing for FP16, making that branch unreachable; `RTXPRO6000TC.m` delegates to
   it. Table 3 lists FP16 output. A wrapper limitation is not evidence about the device.
4. **Late c.** The shipped `H100TC`/`B200TC` defaults set `late_partial_sum = 0` and select
   the native FP8 parameters. The generic helper's late path adds unnormalized sums; it is
   not automatically Fig. 5c's normalized product-sum/RNE path. No profile may stand for both.
5. **FP64 and directed rounding.** §4.2 excludes DMMA from the package and the randomized
   tests. Use a finite-domain FMA specification, not an invented MATLAB profile.

Implementation order is in [PLAN.md](PLAN.md); the target interface is
[INVOCATION_CONTRACT.md](INVOCATION_CONTRACT.md).
