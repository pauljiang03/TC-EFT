# TensorCore.Numerics.RawProduct

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-48ce8d4df2fad1f4"></a>

<details>
<summary><code>TensorCore.RawProduct</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L7)

```lean
structure RawProduct where
  significand : ℤ
  rawScale : ℤ
  fractionalBits : ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.coarse](../EFT/Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.lowParts](../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.supportExponent](../EFT/Extraction.md#decl-3d45598c93a47213), [TensorCore.EFMachine.product_value](../Kernels/EFT/Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](../EFT/ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.exponent_eq](../TC/Specification/Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.largestExponent_eq](../TC/Specification/Stages.md#decl-03502dce6de5b53e), [TensorCore.PaperSpec.product_eq](../TC/Specification/Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.rawTermOf](../TC/Specification/Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.raw_value_zero](../TC/Specification/Stages.md#decl-1b686554b9d985d5), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](../TC/Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PreparedBlock.AlignmentExact](../TC/ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.alignmentResiduals](../TC/Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.allZeroTerms](../EFT/Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.PreparedBlock.coefficients](../TC/Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](RawProduct.md#decl-549312d8d1563679), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.v100_products_not_monotone](../Tests/EFT/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignmentScale](../TC/Block.md#decl-2785502e5e4cba7a), [TensorCore.alignmentScale_lower](../TC/CanonicalFloor.md#decl-e1b8106c4610681f), [TensorCore.alignmentScale_none](../TC/AlignmentScale.md#decl-7a39bdbbb3758c27), [TensorCore.alignmentScale_term](../TC/AlignmentScale.md#decl-b69cdabe679ea4e6), [TensorCore.alignmentScale_upper](../TC/AlignmentScale.md#decl-4c48f1374c92ea89), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](../TC/StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.canonical_eta_floor_inactive](../TC/CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_exact](../TC/Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](../TC/Padding.md#decl-9c7b63268cdf83a8), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](../TC/Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.construction_not_monotone](../TC/Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.eta_term](../TC/AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.eta_upper](../TC/AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepare_fp16_products_metadata](../TC/Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](../TC/Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](../TC/CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.rawMul](RawProduct.md#decl-ebe5dd867373b275), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.zero_products_eta](../TC/Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-549312d8d1563679"></a>

<details>
<summary><code>TensorCore.RawProduct.value</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L13)

```lean
def RawProduct.value (x : RawProduct) : ℚ :=
  (x.significand : ℚ) * pow2 (x.rawScale - x.fractionalBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RawProduct](RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.coarse](../EFT/Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.lowParts](../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.EFMachine.decodeProduct_value](../Kernels/EFT/Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.product_value](../Kernels/EFT/Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](../EFT/ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.largestExponent_eq](../TC/Specification/Stages.md#decl-03502dce6de5b53e), [TensorCore.PaperSpec.product_eq](../TC/Specification/Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.rawTermOf](../TC/Specification/Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.raw_value_zero](../TC/Specification/Stages.md#decl-1b686554b9d985d5), [TensorCore.PreparedBlock.alignmentResiduals](../TC/Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.coefficients](../TC/Block.md#decl-c0369f010f61825c), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.Regression.v100_products_not_monotone](../Tests/EFT/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_residual_identity](../TC/StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.construction_not_monotone](../TC/Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback](../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-ebe5dd867373b275"></a>

<details>
<summary><code>TensorCore.rawMul</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L16)

```lean
def rawMul (a b : Decoded) : RawProduct :=
  ⟨a.significand * b.significand, a.rawScale + b.rawScale,
    a.fractionalBits + b.fractionalBits⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.RawProduct](RawProduct.md#decl-48ce8d4df2fad1f4)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_value](../Kernels/EFT/Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.product_value](../Kernels/EFT/Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.PaperSpec.decode_products_eq](../TC/Specification/Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.product_eq](../TC/Specification/Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.v100_products_not_monotone](../Tests/EFT/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.canonical_source_padding_exact](../TC/Padding.md#decl-9c7b63268cdf83a8), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](../TC/Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.construction_not_monotone](../TC/Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.flowback](../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.prepare_fp16_products_metadata](../TC/Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](../TC/Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](../TC/CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.zero_products_eta](../TC/Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-f5273efeebd6d86f"></a>

<details>
<summary><code>TensorCore.rawProduct_value</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L20)

```lean
theorem rawProduct_value (a b : Decoded) :
    (rawMul a b).value = a.value * b.value := by
  simp only [rawMul, RawProduct.value, Decoded.value, Rat.intCast_mul]
  have h : a.rawScale + b.rawScale - (a.fractionalBits + b.fractionalBits) =
      (a.rawScale - a.fractionalBits) + (b.rawScale - b.fractionalBits) := by omega
  rw [h, pow2_add]
  grind
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.RawProduct](RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_value](../Kernels/EFT/Preparation.md#decl-72fa6f01d649afc4), [TensorCore.PaperSpec.product_eq](../TC/Specification/Stages.md#decl-f6a180380cb5f7be), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90)

</details>

</details>

<a id="decl-3e529071d4e652db"></a>

<details>
<summary><code>TensorCore.RawProduct.Bounded</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L29)

```lean
/-- A common bound for c (significand below two) and raw products (below four). -/
def RawProduct.Bounded (t : RawProduct) : Prop := absQ t.value < 4 * pow2 t.rawScale
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RawProduct](RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018)

</details>

</details>

<a id="decl-8b1220a1d4a27018"></a>

<details>
<summary><code>TensorCore.rawMul_bounded</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L31)

```lean
theorem rawMul_bounded (a b : Decoded) (ha : a.Bounded) (hb : b.Bounded) :
    (rawMul a b).Bounded := by
  have hpa := pow2_pos a.rawScale
  have hpb := pow2_pos b.rawScale
  have hna := absQ_nonneg a.value
  have hnb := absQ_nonneg b.value
  have hm : absQ (a.value * b.value) = absQ a.value * absQ b.value := by
    by_cases hz : b.value = 0
    · simp [hz, absQ]
    · by_cases hpos : 0 < b.value
      · rw [absQ_mul_pos _ _ hpos, absQ_of_nonneg (Rat.le_of_lt hpos)]
      · have hneg : b.value < 0 := by grind
        have hm := absQ_mul_pos a.value (-b.value) (by grind)
        rw [Rat.mul_neg, absQ_neg] at hm
        rw [hm, absQ_of_neg hneg]
  change absQ (rawMul a b).value < 4 * pow2 (a.rawScale + b.rawScale)
  rw [rawProduct_value, hm, pow2_add]
  unfold Decoded.Bounded at ha hb
  have h1 := Rat.mul_le_mul_of_nonneg_right (Rat.le_of_lt ha) hnb
  have h2 := Rat.mul_lt_mul_of_pos_left hb (show 0 < 2 * pow2 a.rawScale by grind)
  grind
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_nonneg](Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c)

</details>

</details>

<a id="decl-a5b1dc2326008483"></a>

<details>
<summary><code>TensorCore.c_term_bounded</code></summary>

[Lean source](../../../TensorCore/Numerics/RawProduct.lean#L53)

```lean
theorem c_term_bounded (c : Decoded) (hc : c.Bounded) :
    (RawProduct.mk c.significand c.rawScale c.fractionalBits).Bounded := by
  have hp := pow2_pos c.rawScale
  change absQ c.value < 4 * pow2 c.rawScale
  unfold Decoded.Bounded at hc
  grind
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.RawProduct](RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c)

</details>

</details>
