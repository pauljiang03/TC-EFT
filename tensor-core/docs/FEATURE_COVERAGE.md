# Single-invocation feature coverage

Reviewed 5 September 2026 against Accurate Models **v4**, especially §2,
§§4.1.1–4.1.8, Figs. 2–5, Tables 2–4, and §4.2.1, and MATLAB Tensor Core
**v0.5**, commit `bbcf00a273868172494eaacaa8d6128ab0fb8704`.
Source hashes and locations are in [SPECIFICATION.md](SPECIFICATION.md).
The arithmetic unit remains one dot product with raw products and one block
accumulation. Group partitions and their order within an instruction are separate.

## Source families

`K` counts products, excluding c. `F` counts all fractional alignment bits,
including extra bits; the paper's two integer bits accommodate unnormalized
product significands below four. The accumulator widths printed in Table 3
are magnitude/carry labels, **not signed two's-complement register widths**.
All listed mixed-precision paths keep raw products and truncate magnitude at
alignment. All source-backed families support subnormal numerical operands.

| Family / source path | K | F | Floor | c / output stages | Current claim |
| --- | ---: | ---: | ---: | --- | --- |
| V100, FP16, WMMA / HMMA.844 | 4 | 23 | none relevant | c in group; FP32 RTZ | Existing executable, proofs, independent oracle, 5,000 published vectors |
| V100, FP16 output | 4 | 23 | none relevant | c is FP16; Fig. 2 depicts FP32 normalization/truncation then FP16 RNE | Needs output-stage reconciliation below |
| A100/A2/A30, FP16/BF16, WMMA / HMMA.1688; L40S/Ada corresponding paths | 8 | 24 | -132 | FP32 c in group; FP32 RTZ | Numeric parameters known; instantiated validation still required |
| Ampere/Ada, TF32, HMMA.1684 | 4 | 24 | -132 | FP32 c in group; FP32 RTZ | Value format versus register/conversion must be explicit |
| H100/H200/B200/RTX PRO, FP16/BF16, HMMA.16816; B200 UTCHMMA f16 | 16 | 25 | -133 | FP32 c in group; FP32 RTZ | Numeric parameters known; instantiated validation still required |
| Hopper/Blackwell TF32, WMMA / HMMA.1684 | 4 | 25 | -133 | FP32 c in group; FP32 RTZ | Do not substitute the K=8 profile for this path |
| Hopper/Blackwell TF32, mma.sync m16n8k8 / HMMA.1688; B200 tcgen05 kind=tf32 | 8 | 25 | -133 | FP32 c in group; FP32 RTZ | Path-specific grouping evidence; larger instruction mapping remains open |
| FP16 output for supported FP16 input paths | as above | as above | as above | final FP16 RNE, ordered stages to resolve | No BF16-to-FP16 device claim inferred from permissive software arguments |
| L40S/Ada native FP8, mma.sync m16n8k16/32 / QMMA.16816 | 16 | 13 | irrelevant for finite FP8 products | c in group; FP32 RTZ or FP16 RNE | Source output-precision issue below; unimplemented |
| Hopper native FP8, wgmma m64nNk32 / QGMMA.16832 | 32 | 13 | irrelevant for finite FP8 products | c in group; FP32 RTZ or FP16 RNE | Different from Hopper mma.sync; source issue below |
| B200 native FP8, tcgen05 kind=f8f6f4 / UTCQMMA; RTX PRO mma.sync / QMMA.16832 | 32 | 25 | irrelevant for finite FP8 products | c in group; FP32 RTZ or FP16 RNE | B200 source forces FP32 output; FP16 branch needs reconciliation |
| Hopper/B200 emulated FP8, mma.sync / HMMA.16816 | 16 per component group | 25 | source figure/path to specify | exact FP8-to-FP16 preparation; normalized product sums; late c with RNE | Fig. 5c describes two interleaved groups; local stage support and downstream group mapping are distinct obligations |
| A100 and later listed FP64 / DMMA.884 | 1 | no truncating alignment | none | exact fused product plus c, one FP64 rounding; four rounding directions | Separate fused variant; no MATLAB model/randomized comparison in v0.5 (§4.2) |

“Hopper/Blackwell” in this table is shorthand for the named devices and paths
in Tables 3–4, not a claim about every instruction on either architecture.
A2/A30 have no FP64 variant (§4.1.3). V100 does not accept BF16 even though
Table 3 groups FP16/BF16 rows. Turing, FP6/FP4, block scaling, and arbitrary
custom-model flags are outside the characterized universe until specified.

## Feature obligations and accepted domains

| Axis | Numerical meaning and source | Existing coverage / needed work |
| --- | --- | --- |
| Encoded value | IEEE-style sign/exponent/fraction for FP16, BF16, TF32 value, FP32, FP64, E5M2 (Table 2; `GEMM.fpformatinfo`) | `Format`/`classify` already parametric for IEEE-style formats, but only FP16/FP32 named and FP32 representation proofs initially present |
| E4M3 | Bias 7, precision 4, maximum 448; exponent 15 is finite except fraction 7 (Table 2 and OCP format cited by paper) | Needs a distinct special-exponent policy; using the IEEE decoder would incorrectly reject 256–448 |
| TF32 storage | Value has 10 fraction bits and 8 exponent bits; source calls it tf19; GEMM uses CPFloat RTZ preparation | Packed 19-bit mathematical encoding is not a CUDA register representation. Model FP32-register padding checks/conversion separately; low bits cannot silently disappear |
| Operand preparation | Already encoded operands versus conversion from another format; subnormal keep/flush | Existing core accepts encoded finite operands and keeps subnormals. Conversions/flushes need their own input-to-prepared loss, outside raw multiplication |
| Raw product | Signed significand multiplication, sum of scales and fractional widths; no normalization or output-range clipping (§4.2.1) | `rawProduct_value` proved for arbitrary decoded operands; retain metadata even when equal products have different factorizations |
| c format and membership | Source `GEMM` prepares c in output format; most paths align it with products; Fig. 5c adds it late | Current `BlockInput` hardcodes FP32 and includes c. Typed c format and explicit late addition required |
| Exponent selection | Ignore zero terms, maximum nonzero raw scale, then floor; nonzero subnormal FP32 c has scale -126 (§4.1.2, §4.1.6) | Executable; need reusable maximum/membership and all-zero proofs. Floor applies only to nonempty selection |
| Alignment | qA = 2^(eta-F); sign times floor of magnitude/qA; no sticky bits on characterized mixed-precision paths | Generic signed residual bound proved. Negative arithmetic shift is a different operation |
| Accumulation | Exact signed integer sum on qA; no intermediate normalization | `accumulator_value` proved. Need derived per-term capacity, prefix bounds, and signed BitVec refinement; magnitude width and sign bit are separate |
| Output | Normalize and convert in explicitly ordered formats/modes, with each returned encoding decoded before next stage | General FP32 RTZ/RNE foundation and RNE correctness exist. General formats, directed modes, staged sequences and stage bounds required |
| Finite domain | Reject nonfinite input, invalid shape/parameters, and out-of-range conversion inputs | Existing finite guard is deliberately narrower than full IEEE overflow handling. Each new stage must check its own range, including a late addition |
| Zero | Exact zero -> +0; negative nonzero rounded to zero retains sign | Model policy, not a hardware signed-zero theorem. Numerical proofs identify both zeros |
| FP64 FMA | One exact a*b+c followed by one rounding; no lossy block-alignment grid | Must use a distinct fused path. K=1 alone does not turn the existing truncating evaluator into IEEE FMA |
| Evidence | Model proof, independent numerical oracle, published device vectors, instruction mapping | Keep separate; existing device evidence covers only finite V100 FP16/FP32 vectors, without zero/subnormal operands |

## Reconciliation register

These findings revise the implementation sequence. They are source questions,
not permission gates; advance independent arithmetic/proof work meanwhile.

1. **FP16 output conversion sequence.** Figs. 2–5 show a normalization/truncation
   branch labeled FP32 followed by FP16 RNE. In `Generic_BFMA_TC.m:257–291`,
   however, `ieeeround` receives `NoManBitsOut` directly after normalization;
   `GEMM.m:80–82` sets it to the requested output's fraction width. No explicit
   FP32 RTZ encoding boundary is present there. Direct FP16 RNE and FP32 RTZ
   followed by FP16 RNE can disagree. Specify both stage sequences, construct
   a distinguishing vector, and compare the applicable published FP16 data
   before assigning the architecture path. The old specification's sequence
   was a diagram interpretation, not a proved v0.5 equivalence.
2. **Native FP8 output precision.** `GEMM.m:92–94` reduces `NoManBitsOut` when
   `neab < 0`, while the generic alignment independently uses `23 + neab`.
   For FP32 output this sets post-normalization precision to 13 fraction bits;
   for FP16 output it sets it to zero. This is not transparently the FP32/FP16
   output conversion drawn in Figs. 4/5d. Do not silently reproduce it as the
   paper's numerical contract. Reconcile via vectors/source history.
3. **Blackwell FP8 output switch.** `B200TC.m:103–106` assigns `outformat='fp32'`
   before testing whether it is FP16, making that FP16 branch unreachable.
   `RTXPRO6000TC.m` delegates to it. Table 3 lists FP16 output. A software
   wrapper limitation is not evidence that the device lacks that output.
4. **Late-c source coverage.** The shipped `H100TC`/`B200TC` defaults set
   `late_partial_sum=0` and select the native FP8 parameters. The generic
   helper's optional late path adds unnormalized sums; it is not automatically
   Fig. 5c's normalized product-sum/RNE path. No profile may stand for both.
5. **FP64 and directed rounding.** §4.2 explicitly excludes DMMA from the
   package and randomized model tests. Use a finite-domain FMA specification,
   not an invented MATLAB profile or extrapolated device test claim.

## Implementation sequence and gate accounting

1. Complete this inventory and the [invocation contract](INVOCATION_CONTRACT.md).
2. Add reusable format/encoding and signed-capacity foundations, with audited
   proofs and explicit V100 specialization. This can proceed independently
   of the unresolved architecture output sequences.
3. Add a typed local pipeline: operand decoding/preparation, raw products,
   aligned or fused accumulation, c placement, and ordered encoded conversions.
   Preserve the old public evaluator until equivalence is proved.
4. Generalize output correctness/error proofs; derive capacity from decoded
   magnitude bounds. Instantiate the unambiguous FP32-output families first.
5. Resolve the register above, add the distinct output/FP8/fused families and
   independent checks, and audit the entire declared feature universe before
   closing the invocation gate. No unimplemented row is counted as complete.
