---
title: Modeling scope and limits
description: What the Lean Tensor Core model covers and what it deliberately leaves out.
---

## Covered

- One normalization group with `K` products and FP32 `C`, for the eight
  FP16/BF16/TF32 → FP32 paths of V100, A100, and H100, plus arbitrary
  `K`, `p`, and floor through the generic profile constructors.
- Every finite input encoding, including subnormals and signed zeros.
- Exact raw products, maximum-exponent alignment with a floor, truncation
  toward zero, exact accumulation (and fixed-width accumulation proved
  equivalent at adequate width), and FP32 round-toward-zero output.
- Ordered chains of groups, as in WMMA instructions, passing encoded FP32
  outputs between groups.
- A general `InvocationSpec`, including FP64 fused DMMA and configurable
  conversion stages.

## Not covered, or covered differently from IEEE

- **NaN and infinity.** Nonfinite operands are rejected. The model doesn't
  propagate NaN.
- **Overflow.** Sums with `|accumulator| > maxFinite32` are rejected instead
  of producing infinity. This is also true of the round-to-nearest helper
  used by EFT: IEEE RNE would still round values slightly above
  `maxFinite32` down to it.
- **FP16 or BF16 output.** The validated paths all produce FP32.
- **FP8 and newer formats** (Blackwell and later) are not part of the
  supported paths.
- **Tiles, GEMMs, and scheduling.** The model covers single groups and
  explicitly chained groups. How a full GEMM is split across warps and
  instructions is outside the model.
- **Hardware correspondence** is evidence, not proof. See [hardware
  validation](/TC-EFT/model/validation/) for which features the measured
  data exercises.
