---
title: The Ozaki schemes at a glance
description: What the Ozaki schemes do, what the Lean development proves about them on the Tensor Core and AMD matrix-core models, and where to read each proof.
---

The Ozaki schemes compute a high-precision matrix product on a low-precision
matrix engine. They turn the inputs into small integers, which the engine
multiplies exactly, and combine the exact integer results. The
[`ozaki/`](https://github.com/pauljiang03/TC-EFT/tree/main/ozaki) project
formalizes three of them in Lean on this repository's NVIDIA Tensor Core model
and on the AMD matrix-core model in `amd/`, following a set of bit-precise Z3
models of the schemes. Every theorem uses only Lean's standard axioms.

| Scheme | Idea | Read |
| --- | --- | --- |
| **Ozaki-I** (Ozaki, Ogita, Oishi and Rump, 2012) | Cut every input into slices of small integers, multiply slice pairs on the engine, add the scaled products. | [Ozaki-I, proved end to end](/TC-EFT/ozaki/ozaki-1/) |
| **Ozaki-II** (Ozaki, Uchino and Imamura, 2025) | Scale the inputs to integers, multiply them modulo a few moduli on the engine, rebuild the product with the Chinese remainder theorem. | [Ozaki-II, proved end to end](/TC-EFT/ozaki/ozaki-2/) |
| **ADP and ESC** (Schwarz et al., NVIDIA, 2025) | Ozaki-I on INT8 engines for FP64, with a slice count chosen from the inputs' exponent spread and a fallback to native FP64. | [ADP and ESC](/TC-EFT/ozaki/adp/) |

## What is proved

- **The engine is exact, from the hardware model.** Every scheme assumes the
  engine multiplies its small integers exactly. Lean proves this on all eight
  NVIDIA paths and on the AMD SFMA, CDNA 1, 2 and 3 fp16, bf16 and XF32 paths,
  from the bit-level models. It holds while the products of one call total at
  most `2^24`, a bound set by the binary32 output, not the accumulator.
- **Error bounds** for Ozaki-I and Ozaki-II, and a Grade-A bound
  `|C − AB| ≤ (4k + 1) 2^-53 |A||B|` for ADP's whole routine on normal inputs,
  and on all inputs with one added guardrail; the paper establishes Grade A by
  experiment.
- **Dot products of any length** (split-K), **full A100 and H100 groups** by a
  second pass through `C`, a TC-EFT technique, and **FP64 emulation** on fp16,
  bf16 and tf32 Tensor Cores and on AMD matrix cores.
- **Correct rounding.** Each scheme has a variant that returns the round to
  nearest even of the exact product for every input, with the same result on
  both vendors: it checks whether the scheme's proved error interval rounds to
  one value, refines if not, and falls back to an exact path. For Ozaki-I
  the check, the exact path and the final rounding run in integer registers
  whose width does not depend on the inputs' exponents, and zero results get
  IEEE's sign.
- **One rounding on both vendors.** The schemes round with IEEE's round to
  nearest even; TensorCore's and MatrixCore's own roundings are proved to
  compute the same values on their ranges.

## Findings

- A full A100 or H100 group of `11`-bit slice products can exceed the
  `2^24` budget; NVIDIA truncates and AMD rounds to nearest, so they give
  different wrong answers.
- ADP can return a wrong result, even of the wrong sign, on subnormal inputs;
  the Z3 model of ADP fails its own final-rounding check on the same input.
  One added guardrail fixes it.
- On the Z3 test matrices, Ozaki-I's configuration (`4` slices) is correctly
  rounded on every entry and Ozaki-II's (`P = 22`) on none.

## Not covered

FP8 paths, an INT8 Tensor Core instruction model, and a GPU
implementation. The theorems are about the models; that GPUs behave like them
rests on the models' [validation](/TC-EFT/model/validation/). The full list,
with every Lean name, is in
[`ozaki/THEOREMS.md`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/THEOREMS.md).
