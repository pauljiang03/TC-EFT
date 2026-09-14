> Archived proof page from `050b50734a9cc9cb4fe6c229b676042874c87f79`. Links refer to that revision.

# TensorCore.TC.FP8Defs

[Index](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-78e3fc6efd64066b"></a>

<details>
<summary><code>TensorCore.FP8Format</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/FP8Defs.lean#L18)

```lean
inductive FP8Format where
  | e4m3 | e5m2
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.FP8Format.encoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.L40SFP8Trace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-d69c3bd866542897), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8CarryGroup](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-73888eadcc082064), [TensorCore.Regression.fp8ProbeFactors](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-4ff560fd1ef23469), [TensorCore.Regression.fp8Words](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-2374fcf020170b26), [TensorCore.Regression.fp8_carry_loss_location](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-76941f28bab96ef3), [TensorCore.Regression.fp8_e4m3_top_exponent](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-8e88f76e54239b4f), [TensorCore.Regression.fp8_first_group_precision_absorbed](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5ab8cf23366a16c9), [TensorCore.Regression.fp8_negative_carry_loss](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-6c159cd63c367ede), [TensorCore.Regression.fp8_normalized_precision_discrepancy](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-cb21b0591273445d), [TensorCore.Regression.fp8_paper_alignment_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-84347f748f0310f4), [TensorCore.Regression.fp8_paper_early_c_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-cd54f684b17fecf1), [TensorCore.Regression.fp8_subnormal_preserved](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-b1bb8f3ca4418b7a), [TensorCore.Regression.fp8_zero_and_rejections](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.Regression.l40s_e4m3_group_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-e82ac8c050018571), [TensorCore.Regression.l40s_e4m3_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5a82486ca62db36a), [TensorCore.Regression.l40s_e5m2_group_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-321185f5fa7cfdba), [TensorCore.Regression.l40s_e5m2_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-3f757599746339b2), [TensorCore.adaFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-f8e3a3297ba93f71), [TensorCore.fp8Products](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-5a8d724cdc17e186), [TensorCore.fp8Products_append](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b8243d18187847d4), [TensorCore.fp8_decode_scale_lower](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-9c397a6123b7b235), [TensorCore.fp8_prepared](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-00c973e643ed24e8), [TensorCore.fp8_prepared_decoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-43f0b7c463d8816d), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.l40sFP8Ideal](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-2edcb7111d5346e0), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.l40sFP8_floor_inactive](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-6a5e1a3ab5a4a57a), [TensorCore.l40sFP8_output_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-0c85684a50a21181), [TensorCore.l40sFP8_paper_towardZero_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1b414c8fa00ce08), [TensorCore.l40sFP8_partition](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-93fd1bf0e5a1115e), [TensorCore.l40sFP8_readings_same_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-9472354441f51e82), [TensorCore.l40sFP8_source13_boundary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-7b2640435fca348a), [TensorCore.l40sFP8_source13_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-289dcc55b6b1f28b), [TensorCore.l40sFP8_valid](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1dde6489ea0dcce), [TensorCore.prepareFP8Products](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.prepareFP8Products_scale_lower](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-ffabd823616a9c18), [TensorCore.runL40SFP8](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-e991942d01778b03), [TensorCore.runL40SFP8_recovery](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-dde9ab033428f350), [TensorCore.runL40SFP8_spec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-2554ef9de5987089)

</details>

</details>

<a id="decl-7d4020de8dd132ce"></a>

<details>
<summary><code>TensorCore.FP8Format.encoding</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/FP8Defs.lean#L22)

```lean
@[implicit_reducible] def FP8Format.encoding : FP8Format → OperandEncoding
  | .e4m3 => packedE4M3
  | .e5m2 => packedIEEE TensorCore.e5m2
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.OperandEncoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-372baaa74f9e3836), [TensorCore.e5m2](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-e90066ecba9097ee), [TensorCore.packedE4M3](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-d71b628934693ce8), [TensorCore.packedIEEE](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8Words](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-2374fcf020170b26), [TensorCore.Regression.fp8_e4m3_top_exponent](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-8e88f76e54239b4f), [TensorCore.Regression.fp8_subnormal_preserved](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-b1bb8f3ca4418b7a), [TensorCore.Regression.fp8_zero_and_rejections](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.fp8Products](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-5a8d724cdc17e186), [TensorCore.fp8Products_append](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b8243d18187847d4), [TensorCore.fp8_decode_scale_lower](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-9c397a6123b7b235), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.l40sFP8Ideal](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-2edcb7111d5346e0), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.l40sFP8_paper_towardZero_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1b414c8fa00ce08), [TensorCore.l40sFP8_partition](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-93fd1bf0e5a1115e), [TensorCore.prepareFP8Products](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.prepareFP8Products_scale_lower](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-ffabd823616a9c18), [TensorCore.runL40SFP8](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-e991942d01778b03), [TensorCore.runL40SFP8_recovery](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-dde9ab033428f350), [TensorCore.runL40SFP8_spec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-2554ef9de5987089)

</details>

</details>

<a id="decl-7f168fd32dc7bd16"></a>

<details>
<summary><code>TensorCore.FP8Reading</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/FP8Defs.lean#L26)

```lean
inductive FP8Reading where
  /-- Direct FP32 interpretation of Table 3 / Figure 4; a specification candidate,
  not a claim that the paper unambiguously settles normalized precision. -/
  | paper
  /-- `GEMM.m` reduces `NoManBitsOut` by ten before `Generic_BFMA_TC`. -/
  | source13
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.L40SFP8Trace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-d69c3bd866542897), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8_carry_loss_location](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-76941f28bab96ef3), [TensorCore.Regression.fp8_e4m3_top_exponent](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-8e88f76e54239b4f), [TensorCore.Regression.fp8_first_group_precision_absorbed](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5ab8cf23366a16c9), [TensorCore.Regression.fp8_negative_carry_loss](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-6c159cd63c367ede), [TensorCore.Regression.fp8_normalized_precision_discrepancy](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-cb21b0591273445d), [TensorCore.Regression.fp8_paper_alignment_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-84347f748f0310f4), [TensorCore.Regression.fp8_paper_early_c_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-cd54f684b17fecf1), [TensorCore.Regression.fp8_subnormal_preserved](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-b1bb8f3ca4418b7a), [TensorCore.Regression.fp8_zero_and_rejections](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.Regression.l40s_e4m3_group_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-e82ac8c050018571), [TensorCore.Regression.l40s_e4m3_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5a82486ca62db36a), [TensorCore.Regression.l40s_e5m2_group_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-321185f5fa7cfdba), [TensorCore.Regression.l40s_e5m2_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-3f757599746339b2), [TensorCore.adaFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-f8e3a3297ba93f71), [TensorCore.fp8_prepared](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-00c973e643ed24e8), [TensorCore.fp8_prepared_decoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-43f0b7c463d8816d), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.l40sFP8_floor_inactive](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-6a5e1a3ab5a4a57a), [TensorCore.l40sFP8_output_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-0c85684a50a21181), [TensorCore.l40sFP8_paper_towardZero_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1b414c8fa00ce08), [TensorCore.l40sFP8_readings_same_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-9472354441f51e82), [TensorCore.l40sFP8_source13_boundary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-7b2640435fca348a), [TensorCore.l40sFP8_source13_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-289dcc55b6b1f28b), [TensorCore.l40sFP8_valid](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1dde6489ea0dcce), [TensorCore.runL40SFP8](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-e991942d01778b03), [TensorCore.runL40SFP8_recovery](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-dde9ab033428f350), [TensorCore.runL40SFP8_spec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-2554ef9de5987089)

</details>

</details>

<a id="decl-0d06616c12063adf"></a>

<details>
<summary><code>TensorCore.fp32With13FractionBits</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/FP8Defs.lean#L36)

```lean
/-- An internal precision with FP32 exponent range and 13 stored fraction bits.
Its encodings are intermediate values, not a new device output format. -/
@[implicit_reducible] def fp32With13FractionBits : Format := ⟨13, 8, 127⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.l40sFP8_source13_boundary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-7b2640435fca348a), [TensorCore.l40sFP8_source13_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-289dcc55b6b1f28b)

</details>

</details>

<a id="decl-aaf89d9b9aca6e42"></a>

<details>
<summary><code>TensorCore.l40sFP8Invocation</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/FP8Defs.lean#L38)

```lean
@[implicit_reducible] def l40sFP8Invocation (f : FP8Format) (reading : FP8Reading) :
    InvocationSpec :=
  ⟨f.encoding, fp32, 16, .aligned 13 none .inGroup,
    match reading with
    | .paper => []
    | .source13 => [⟨fp32With13FractionBits, .towardZero⟩],
    ⟨fp32, .towardZero⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CPlacement](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.fp32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp32With13FractionBits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-0d06616c12063adf)

<details>
<summary>Used by</summary>

[TensorCore.L40SFP8Trace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-d69c3bd866542897), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8_first_group_precision_absorbed](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5ab8cf23366a16c9), [TensorCore.Regression.fp8_zero_and_rejections](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.adaFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-f8e3a3297ba93f71), [TensorCore.fp8_prepared](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-00c973e643ed24e8), [TensorCore.fp8_prepared_decoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-43f0b7c463d8816d), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.l40sFP8_floor_inactive](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-6a5e1a3ab5a4a57a), [TensorCore.l40sFP8_output_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-0c85684a50a21181), [TensorCore.l40sFP8_paper_towardZero_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1b414c8fa00ce08), [TensorCore.l40sFP8_readings_same_accumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-9472354441f51e82), [TensorCore.l40sFP8_source13_boundary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-7b2640435fca348a), [TensorCore.l40sFP8_source13_towardZero](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-289dcc55b6b1f28b), [TensorCore.l40sFP8_valid](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-b1dde6489ea0dcce), [TensorCore.runL40SFP8](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-e991942d01778b03), [TensorCore.runL40SFP8_recovery](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-dde9ab033428f350), [TensorCore.runL40SFP8_spec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8.md#decl-2554ef9de5987089)

</details>

</details>

<a id="decl-f8e3a3297ba93f71"></a>

<details>
<summary><code>TensorCore.adaFP8Invocation</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/FP8Defs.lean#L48)

```lean
/-- Ada RTX 1000 shares these numerical parameters (paper Section 4.1.5).
The vendored measurements are L40S rows, not a separate Ada measurement set. -/
abbrev adaFP8Invocation := l40sFP8Invocation
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
