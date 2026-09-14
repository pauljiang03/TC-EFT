# TensorCore.Core.Conversion

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-819c01227290b53b"></a>

<details>
<summary><code>TensorCore.FiniteBinary</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L7)

```lean
structure FiniteBinary (f : Format) where
  bits : BitVec f.width
  decoded : Decoded
  valid : (classify f bits).finite = some decoded
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.scaledCellJson](../Gemm/Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.scaledCellJson](../Gemm/Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32), [TensorCore.InvocationTrace](../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.PaperSpec.EpilogueContract](../Gemm/Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.conversionStage_bits_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.epilogue_contract](../Gemm/Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.input_conversion_contract](../Gemm/Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.scalarConvertWord_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scalar_contract](../Gemm/Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.PaperSpec.scaledCellObservation](../Gemm/Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](../Gemm/Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_paper_contract](../Gemm/Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](../Gemm/Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](../Gemm/Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](../Gemm/Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.fma64Bits](../TC/Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.source_input_loss_matters](../Gemm/Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.zero_product_canonical](../TC/Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.ScaledGemmCell](../Gemm/ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.checkEpilogue_sound](../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkOutput_sound](../Gemm/ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertGemmWord](../Gemm/ScaledGemm.md#decl-90caef944befb68d), [TensorCore.convertGemmWord_correct](../Gemm/ScaledGemm.md#decl-4a6aab3616af53e6), [TensorCore.convertedAnalysisCheck_paper](../Gemm/ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.finiteBinary_none](Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](Conversion.md#decl-66e4132ec74cac83), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_correct](../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.gemmEpilogue](../Gemm/ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](../Gemm/ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](../Gemm/ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemmInputDatum](../Gemm/InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputDatum_error_le](../Gemm/InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputDatum_of_conversion](../Gemm/InputBounds.md#decl-63322710811f0233), [TensorCore.inputDatumTo](../Gemm/MatrixConversion.md#decl-79dff1e7ec8731f0), [TensorCore.inputDatumTo_of_conversion](../Gemm/MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.invocationBits](../TC/Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.nativeConvertedAnalysisCheck_paper](../Gemm/NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.scaledGemmBits](../Gemm/ScaledGemm.md#decl-54ef760c8311c4d0), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemm_entry_error](../Gemm/ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-91103d704c4a7c32"></a>

<details>
<summary><code>TensorCore.FiniteBinary.value</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L13)

```lean
def FiniteBinary.value {f : Format} (d : FiniteBinary f) : ℚ := d.decoded.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.scaledCellJson](../Gemm/Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.scaledCellJson](../Gemm/Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConvertedGemmAccurate](../Gemm/ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.NativeConvertedGemmAccurate](../Gemm/NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.PaperSpec.EpilogueContract](../Gemm/Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](../Gemm/Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.epilogue_contract](../Gemm/Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_paper_contract](../Gemm/Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](../Gemm/Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.paper_source_certificate](../Gemm/Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.scaled_rectangular](../Gemm/Regression/GemmExtensions.md#decl-94ac378f052b4fa8), [TensorCore.ScaledGemmCell.propagate](../Gemm/ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.ScaledGemmCell.scalarError](../Gemm/ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.analyzeConvertedGemm_matrix_error](../Gemm/ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_matrix_error](../Gemm/NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkConvertedCell_sound](../Gemm/ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue_sound](../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkNativeConvertedCell_sound](../Gemm/NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](../Gemm/NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkOutput_sound](../Gemm/ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.checkScaledCell_sound](../Gemm/ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertedAnalysisCheck_matrix_error](../Gemm/ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](../Gemm/ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](../Gemm/ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCheck_sound](../Gemm/ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](../Gemm/InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](../Gemm/TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](../Gemm/TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate_matrix_error](../Gemm/InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](../Gemm/InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](../Gemm/TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](../Gemm/TightInputBounds.md#decl-9670e739c545855d), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmEpilogue](../Gemm/ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](../Gemm/ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](../Gemm/ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemmInputDatum](../Gemm/InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputDatum_error_le](../Gemm/InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputDatum_of_conversion](../Gemm/InputBounds.md#decl-63322710811f0233), [TensorCore.inputDatumTo](../Gemm/MatrixConversion.md#decl-79dff1e7ec8731f0), [TensorCore.inputDatumTo_of_conversion](../Gemm/MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](../Gemm/NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](../Gemm/NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](../Gemm/NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_matrix_error](../Gemm/ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](../Gemm/ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](../Gemm/TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](../Gemm/TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry_error](../Gemm/ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-4947fce7ecea0c20"></a>

<details>
<summary><code>TensorCore.finiteBinary</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L15)

```lean
def finiteBinary (f : Format) (bits : BitVec f.width) : Option (FiniteBinary f) :=
  match h : (classify f bits).finite with
  | none => none
  | some d => some ⟨bits, d, h⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.PaperSpec.conversionStage_bits_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.finiteBinary_none](Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](Conversion.md#decl-66e4132ec74cac83), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-ec8059a2865c017f"></a>

<details>
<summary><code>TensorCore.finiteBinary_none</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L20)

```lean
theorem finiteBinary_none {f : Format} {bits : BitVec f.width}
    (hd : (classify f bits).finite = none) : finiteBinary f bits = none := by
  unfold finiteBinary
  split
  · rfl
  · rename_i d h
    rw [hd] at h
    contradiction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-66e4132ec74cac83"></a>

<details>
<summary><code>TensorCore.finiteBinary_some</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L29)

```lean
theorem finiteBinary_some {f : Format} {bits : BitVec f.width} {d : Decoded}
    (hd : (classify f bits).finite = some d) : finiteBinary f bits = some ⟨bits, d, hd⟩ := by
  unfold finiteBinary
  split
  · rename_i h
    rw [hd] at h
    contradiction
  · rename_i d' h
    rw [hd] at h
    cases Option.some.inj h
    rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.conversionStage_bits_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-19660b95e076faa1"></a>

<details>
<summary><code>TensorCore.ConversionStage</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L41)

```lean
structure ConversionStage where
  format : Format
  mode : BinaryRoundingMode
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.CPlacement](../TC/Invocation.md#decl-465383d437a4df50), [TensorCore.Cli.Gemm.evaluate](../Gemm/Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Gemm.scaledCellJson](../Gemm/Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.evaluate](../Gemm/Cli/NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.NativePipeline.scaledCellJson](../Gemm/Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.ConvertedGemmAccurate](../Gemm/ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.GemmCandidate.epilogue](../Gemm/Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](../Gemm/Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmEpilogue](../Gemm/ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](../Gemm/ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](../Gemm/ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.GemmRounded](../Gemm/ScaledGemm.md#decl-601fdad850a94274), [TensorCore.InvocationSpec](../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](../TC/Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.NativeConvertedGemmAccurate](../Gemm/NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.PaperSpec.EpilogueContract](../Gemm/Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.InputConversionContract](../Gemm/Specification/GemmComposition.md#decl-8e4b3aa57a1c71a3), [TensorCore.PaperSpec.ScalarContract](../Gemm/Specification/GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.PaperSpec.conversionStage_bits_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](../Gemm/Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](../Gemm/Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.epilogue_contract](../Gemm/Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.input_conversion_contract](../Gemm/Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.invocation_eq_paper](../TC/Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](../Gemm/Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](../Gemm/Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarConvertWord_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scalarStageOf](../Gemm/Specification/ScaledGemmEquivalence.md#decl-0d7d7612b2b29253), [TensorCore.PaperSpec.scalar_contract](../Gemm/Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.PaperSpec.scaledCellObservation](../Gemm/Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](../Gemm/Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](../Gemm/Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](../Gemm/Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Profile.toInvocation](../TC/Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.Regression.NativeScaled.cfg](../Gemm/Regression/NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](../Gemm/Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](../Gemm/Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](../Gemm/Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](../Gemm/Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.a100_bf16_published_row](../TC/Regression/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.analysisEpilogue](../Gemm/Regression/PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.Regression.fma64Bits](../TC/Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.fused_requires_one_product](../TC/Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.Regression.h100_bf16_published_row](../TC/Regression/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.identity_epilogue_tight](../Gemm/Regression/DecisionExtensions.md#decl-ce4806500b961d68), [TensorCore.Regression.independent_converted_rejection](../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.input_range_and_special_rejections](../Gemm/Regression/GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.negative_alpha_source_bound](../Gemm/Regression/GemmInputConversion.md#decl-8ffd66ebf0b6eae9), [TensorCore.Regression.paper_source_certificate](../Gemm/Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.scalar_analysis_range_boundary](../Gemm/Regression/PipelineAnalysis.md#decl-314a8146be1eee9e), [TensorCore.Regression.scaled_c_placement](../Gemm/Regression/GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_certificate_rejects_stages](../Gemm/Regression/GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](../Gemm/Regression/GemmExtensions.md#decl-8c37b22a932158df), [TensorCore.Regression.scaled_conversion](../Gemm/Regression/GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_multiply_rounding](../Gemm/Regression/GemmExtensions.md#decl-43dfad9ae9cb03ec), [TensorCore.Regression.scaled_rectangular](../Gemm/Regression/GemmExtensions.md#decl-94ac378f052b4fa8), [TensorCore.Regression.scaled_rejections_and_zero](../Gemm/Regression/GemmExtensions.md#decl-d1b81d931f9d9b7f), [TensorCore.Regression.source_empty_dimensions](../Gemm/Regression/GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.source_input_loss_matters](../Gemm/Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_input_edges](../Regression/FoundationCompletion.md#decl-d874c31dcab129cf), [TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.Regression.zero_product_canonical](../TC/Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.ScaledGemmBoundConfig.valid](../Gemm/ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.ScaledGemmCell](../Gemm/ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.propagate](../Gemm/ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.ScaledGemmCell.scalarError](../Gemm/ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.alignedInvocation](../TC/Profiles.md#decl-08059dfea19f5f55), [TensorCore.analyzeConvertedGemm_matrix_error](../Gemm/ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_matrix_error](../Gemm/NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.bf16Fp32_invocation_compatible](../TC/CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.binary64Fma](../TC/Profiles.md#decl-8bfe46830da92086), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.checkConvertedCell_sound](../Gemm/ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue_sound](../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd](../Gemm/ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply](../Gemm/ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkNativeConvertedCell_sound](../Gemm/NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](../Gemm/NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkOutput](../Gemm/ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.checkOutput_sound](../Gemm/ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar](../Gemm/ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.checkScalar_inferred](../Gemm/ScalarAnalysis.md#decl-6e0263f84e5e0f8c), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.checkScaledCell_sound](../Gemm/ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertGemmWord](../Gemm/ScaledGemm.md#decl-90caef944befb68d), [TensorCore.convertGemmWord_correct](../Gemm/ScaledGemm.md#decl-4a6aab3616af53e6), [TensorCore.convertedAnalysisCheck_matrix_error](../Gemm/ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](../Gemm/ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](../Gemm/ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCheck_sound](../Gemm/ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](../Gemm/InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](../Gemm/TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](../Gemm/TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate_matrix_error](../Gemm/InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](../Gemm/InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](../Gemm/TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](../Gemm/TightInputBounds.md#decl-9670e739c545855d), [TensorCore.evalInvocation](../TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.fp16Fp32_invocation_compatible](../TC/Canonical.md#decl-77d448deb0e063d7), [TensorCore.gemmConversionModeError](../Gemm/RoundingBudget.md#decl-426ed137365dd261), [TensorCore.gemmConversionModeError_le](../Gemm/RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.gemmConversionModeError_pos](../Gemm/RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_correct](../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.gemmEpilogue](../Gemm/ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](../Gemm/ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](../Gemm/ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemmInputDatum](../Gemm/InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputDatum_error_le](../Gemm/InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputDatum_of_conversion](../Gemm/InputBounds.md#decl-63322710811f0233), [TensorCore.inferEpilogue](../Gemm/ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.inputDatumTo](../Gemm/MatrixConversion.md#decl-79dff1e7ec8731f0), [TensorCore.inputDatumTo_of_conversion](../Gemm/MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.invocationBits](../TC/Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](../Gemm/NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](../Gemm/NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](../Gemm/NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.scalarBound](../Gemm/ScalarAnalysis.md#decl-7e61c221e3ed5c6f), [TensorCore.scaledGemmBits](../Gemm/ScaledGemm.md#decl-54ef760c8311c4d0), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_matrix_error](../Gemm/ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](../Gemm/ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](../Gemm/TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](../Gemm/TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmScalarBudget](../Gemm/ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmTightScalarBudget_le](../Gemm/TightBounds.md#decl-e47a9cfbc68a88aa), [TensorCore.scaledGemm_entry_error](../Gemm/ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.stagesValid](../TC/Invocation.md#decl-e34cdc92870df2ae), [TensorCore.tf32_input_bits](../TC/CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_invocation_bits](../TC/Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-5e2170b37d7e10f7"></a>

<details>
<summary><code>TensorCore.ConversionStage.convert</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L46)

```lean
def ConversionStage.convert (s : ConversionStage) (x : ℚ) : Option (FiniteBinary s.format) := do
  finiteBinary s.format (← roundBinary s.format s.mode x)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.conversionStage_bits_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.epilogue_contract](../Gemm/Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.input_conversion_contract](../Gemm/Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.scalarConvertWord_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scalar_contract](../Gemm/Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.PaperSpec.scaledGemm_paper_contract](../Gemm/Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.checkEpilogue_sound](../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkOutput_sound](../Gemm/ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertGemmWord](../Gemm/ScaledGemm.md#decl-90caef944befb68d), [TensorCore.convertGemmWord_correct](../Gemm/ScaledGemm.md#decl-4a6aab3616af53e6), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_correct](../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.gemmEpilogue](../Gemm/ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](../Gemm/ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](../Gemm/ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemmInputDatum](../Gemm/InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputDatum_error_le](../Gemm/InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputDatum_of_conversion](../Gemm/InputBounds.md#decl-63322710811f0233), [TensorCore.inputDatumTo](../Gemm/MatrixConversion.md#decl-79dff1e7ec8731f0), [TensorCore.inputDatumTo_of_conversion](../Gemm/MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemm_entry_error](../Gemm/ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-4715b3224a6fd37c"></a>

<details>
<summary><code>TensorCore.ConversionEvent</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L49)

```lean
structure ConversionEvent where
  stage : ConversionStage
  input : ℚ
  output : FiniteBinary stage.format
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b)

<details>
<summary>Used by</summary>

[TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.LocalAccumulation](../TC/Invocation.md#decl-a84c087ad8e27576), [TensorCore.LocalAccumulation.loss](../TC/Invocation.md#decl-68d84640e3352f8b), [TensorCore.Regression.zero_product_canonical](../TC/Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-60b5dc28ff8bfb5b"></a>

<details>
<summary><code>TensorCore.ConversionEvent.loss</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L55)

```lean
def ConversionEvent.loss (e : ConversionEvent) : ℚ := e.input - e.output.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32)

<details>
<summary>Used by</summary>

[TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.LocalAccumulation.loss](../TC/Invocation.md#decl-68d84640e3352f8b), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-ed5a81cbcde403d2"></a>

<details>
<summary><code>TensorCore.ConversionRun</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L57)

```lean
structure ConversionRun where
  events : List ConversionEvent
  value : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c)

<details>
<summary>Used by</summary>

[TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.InvocationTrace](../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.Regression.zero_product_canonical](../TC/Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-29f602efd8dc0504"></a>

<details>
<summary><code>TensorCore.ConversionRun.loss</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L62)

```lean
def ConversionRun.loss (r : ConversionRun) : ℚ := sumQ (r.events.map ConversionEvent.loss)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-3bc91db620898ff3"></a>

<details>
<summary><code>TensorCore.runConversions</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L65)

```lean
/-- Each following conversion receives the decoded encoding of its predecessor. -/
def runConversions : List ConversionStage → ℚ → Option ConversionRun
  | [], x => some ⟨[], x⟩
  | s :: ss, x => do
    let d ← s.convert x
    let rest ← runConversions ss d.value
    return ⟨⟨s, x, d⟩ :: rest.events, rest.value⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32)

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-3479ab5362b59148"></a>

<details>
<summary><code>TensorCore.conversionStage_output</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L72)

```lean
theorem conversionStage_output {s : ConversionStage} {x : ℚ} {d : FiniteBinary s.format}
    (h : s.convert x = some d) : roundBinary s.format s.mode x = some d.bits := by
  unfold ConversionStage.convert at h
  cases hr : roundBinary s.format s.mode x with
  | none => simp [hr] at h
  | some bits =>
    simp [hr] at h
    unfold finiteBinary at h
    split at h
    · simp at h
    · simp only [Option.some.injEq] at h
      subst d
      rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalar_contract](../Gemm/Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-9878d77fe9422846"></a>

<details>
<summary><code>TensorCore.conversionStage_range</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L86)

```lean
theorem conversionStage_range {s : ConversionStage} {x : ℚ} {d : FiniteBinary s.format}
    (h : s.convert x = some d) : s.format.WellFormed ∧ absQ x ≤ s.format.maxFinite :=
  roundBinary_range (conversionStage_output h)
```

**Supporting proofs:** [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.roundBinary_range](Binary/RoundOp.md#decl-0877ce0e6eb40a61)

**Definitions and types:** [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalar_contract](../Gemm/Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.gemmConversion_correct](../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-9a595a0bbdd2a7fc"></a>

<details>
<summary><code>TensorCore.runConversions_recovery</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L91)

```lean
/-- Executed sequences telescope across actual encodings, with every loss retained. -/
theorem runConversions_recovery (ss : List ConversionStage) (x : ℚ) (r : ConversionRun)
    (h : runConversions ss x = some r) : x = r.value + r.loss := by
  induction ss generalizing x r with
  | nil =>
    simp [runConversions] at h
    subst r
    simp [ConversionRun.loss, sumQ]
    grind
  | cons s ss ih =>
    cases hd : s.convert x with
    | none => simp [runConversions, hd] at h
    | some d =>
      cases hr : runConversions ss d.value with
      | none => simp [runConversions, hd, hr] at h
      | some rest =>
        simp [runConversions, hd, hr] at h
        subst r
        have hi := ih d.value rest hr
        simp only [ConversionRun.loss, List.map_cons, sumQ, ConversionEvent.loss] at *
        grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-ee15bd4271d1b71d"></a>

<details>
<summary><code>TensorCore.runConversions_events</code></summary>

[Lean source](../../../TensorCore/Core/Conversion.lean#L113)

```lean
/-- Every event is a successful conversion; the trace does not invent rounded boundaries. -/
theorem runConversions_events (ss : List ConversionStage) (x : ℚ) (r : ConversionRun)
    (h : runConversions ss x = some r) :
    r.events.map ConversionEvent.stage = ss ∧
      ∀ e ∈ r.events, e.stage.convert e.input = some e.output := by
  induction ss generalizing x r with
  | nil => simp [runConversions] at h; subst r; simp
  | cons s ss ih =>
    cases hd : s.convert x with
    | none => simp [runConversions, hd] at h
    | some d =>
      cases hr : runConversions ss d.value with
      | none => simp [runConversions, hd, hr] at h
      | some rest =>
        simp [runConversions, hd, hr] at h
        subst r
        have hi := ih d.value rest hr
        constructor
        · simpa using hi.1
        · intro e he
          simp only [List.mem_cons] at he
          rcases he with he | he
          · subst e; exact hd
          · exact hi.2 e he
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
