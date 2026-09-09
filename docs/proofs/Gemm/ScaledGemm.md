# TensorCore.Gemm.ScaledGemm

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-88c6d32ebe9ea7bf"></a>

<details>
<summary><code>TensorCore.GemmEpilogue</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L13)

```lean
structure GemmEpilogue where
  multiplyMode : BinaryRoundingMode := .nearestEven
  addMode : BinaryRoundingMode := .nearestEven
  output : ConversionStage := ⟨fp32, .nearestEven⟩
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Gemm.scaledCellJson](Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.evaluate](Cli/NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.NativePipeline.scaledCellJson](Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.GemmCandidate.epilogue](Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.PaperSpec.EpilogueContract](Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.epilogueOf](Specification/ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledCellObservation](Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.NativeScaled.cfg](Regression/NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.analysisEpilogue](Regression/PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.Regression.identity_epilogue_tight](Regression/DecisionExtensions.md#decl-ce4806500b961d68), [TensorCore.Regression.independent_converted_rejection](../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.input_range_and_special_rejections](Regression/GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.negative_alpha_source_bound](Regression/GemmInputConversion.md#decl-8ffd66ebf0b6eae9), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.scaled_c_placement](Regression/GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_certificate_rejects_stages](Regression/GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](Regression/GemmExtensions.md#decl-8c37b22a932158df), [TensorCore.Regression.scaled_conversion](Regression/GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_multiply_rounding](Regression/GemmExtensions.md#decl-43dfad9ae9cb03ec), [TensorCore.Regression.scaled_rectangular](Regression/GemmExtensions.md#decl-94ac378f052b4fa8), [TensorCore.Regression.scaled_rejections_and_zero](Regression/GemmExtensions.md#decl-d1b81d931f9d9b7f), [TensorCore.Regression.source_empty_dimensions](Regression/GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.ScaledGemmBoundConfig.valid](ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.errorBudget](ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceCertificate_acceptance](TightInputBounds.md#decl-533bbea7ddad7c67), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmBits](ScaledGemm.md#decl-54ef760c8311c4d0), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-d5926afbc7beec92"></a>

<details>
<summary><code>TensorCore.GemmEpilogue.multiplyStage</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L19)

```lean
def GemmEpilogue.multiplyStage (cfg : GemmEpilogue) : ConversionStage :=
  ⟨fp32, cfg.multiplyMode⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.EpilogueContract](Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-e11a69df69709a91"></a>

<details>
<summary><code>TensorCore.GemmEpilogue.addStage</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L22)

```lean
def GemmEpilogue.addStage (cfg : GemmEpilogue) : ConversionStage :=
  ⟨fp32, cfg.addMode⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.EpilogueContract](Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-37e2cfa554d68ad1"></a>

<details>
<summary><code>TensorCore.ScaledGemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L25)

```lean
structure ScaledGemmCell (cfg : GemmEpilogue) where
  product : GemmCell
  alpha : Finite32
  beta : Finite32
  c : Finite32
  scaledProduct : FiniteBinary fp32
  scaledC : FiniteBinary fp32
  sum : FiniteBinary fp32
  output : FiniteBinary cfg.output.format
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Gemm.scaledCellJson](Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.NativePipeline.scaledCellJson](Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.PaperSpec.EpilogueContract](Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledCellObservation](Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.intermediate_overflow_rejected](Regression/NativeScaledGemm.md#decl-6d29392f8e156c74), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.independent_converted_rejection](../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.scaled_rectangular](Regression/GemmExtensions.md#decl-94ac378f052b4fa8), [TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.ScaledGemmCell.errorBudget](ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmBits](ScaledGemm.md#decl-54ef760c8311c4d0), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-830c6be1cd273929"></a>

<details>
<summary><code>TensorCore.gemmEpilogue</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L37)

```lean
/-- Every scalar stage consumes the decoded encoding returned by its predecessor. -/
def gemmEpilogue (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell) :
    Option (ScaledGemmCell cfg) := do
  let a ← finite32 alpha
  let b ← finite32 beta
  let c ← finite32 c
  let ad ← cfg.multiplyStage.convert (a.value * product.output.value)
  let bc ← cfg.multiplyStage.convert (b.value * c.value)
  let sum ← cfg.addStage.convert (ad.value + bc.value)
  let out ← cfg.output.convert sum.value
  return ⟨product, a, b, c, ad, bc, sum, out⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-6abb69dd837ac6d2"></a>

<details>
<summary><code>TensorCore.gemmEpilogue_spec</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L48)

```lean
theorem gemmEpilogue_spec (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell)
    (t : ScaledGemmCell cfg) (h : gemmEpilogue cfg alpha beta c product = some t) :
    t.product = product ∧ finite32 alpha = some t.alpha ∧ finite32 beta = some t.beta ∧
      finite32 c = some t.c ∧
      cfg.multiplyStage.convert (t.alpha.value * product.output.value) = some t.scaledProduct ∧
      cfg.multiplyStage.convert (t.beta.value * t.c.value) = some t.scaledC ∧
      cfg.addStage.convert (t.scaledProduct.value + t.scaledC.value) = some t.sum ∧
      cfg.output.convert t.sum.value = some t.output := by
  simp only [gemmEpilogue, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨a, ha, b, hb, c', hc, ad, had, bc, hbc, s, hs, out, ho, he⟩ := h
  cases Option.some.inj he
  exact ⟨rfl, ha, hb, hc, had, hbc, hs, ho⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-601fdad850a94274"></a>

<details>
<summary><code>TensorCore.GemmRounded</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L62)

```lean
/-- Mathematical rounding relation selected by each scalar/conversion stage. -/
def GemmRounded (stage : ConversionStage) (x : ℚ) (bits : BitVec stage.format.width) : Prop :=
  match stage.mode with
  | .nearestEven => NearestEven stage.format x bits
  | .towardZero => TowardZero stage.format x bits
  | .towardNegative => TowardNegative stage.format x bits
  | .towardPositive => TowardPositive stage.format x bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardNegative](../Core/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.TowardPositive](../Core/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarContract](Specification/GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.PaperSpec.scalar_contract](Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.conversion_exact_value](ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertGemmWord_correct](ScaledGemm.md#decl-4a6aab3616af53e6), [TensorCore.gemmConversion_correct](ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3)

</details>

</details>

<a id="decl-e58a1d25b374dba1"></a>

<details>
<summary><code>TensorCore.gemmConversion_correct</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L69)

```lean
theorem gemmConversion_correct (stage : ConversionStage) (x : ℚ)
    (d : FiniteBinary stage.format) (h : stage.convert x = some d) :
    GemmRounded stage x d.bits := by
  have hf := (conversionStage_range h).1
  cases hm : stage.mode with
  | nearestEven => simpa [GemmRounded, hm] using conversionStage_nearestEven_correct stage hf hm x d h
  | towardZero => simpa [GemmRounded, hm] using conversionStage_towardZero_correct stage hf hm x d h
  | towardNegative => simpa [GemmRounded, hm] using conversionStage_towardNegative_correct stage hf hm x d h
  | towardPositive => simpa [GemmRounded, hm] using conversionStage_towardPositive_correct stage hf hm x d h
```

**Supporting proofs:** [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_range](../Core/Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmRounded](ScaledGemm.md#decl-601fdad850a94274), [TensorCore.NearestEven](../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardNegative](../Core/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.TowardPositive](../Core/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalar_contract](Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.conversion_exact_value](ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertGemmWord_correct](ScaledGemm.md#decl-4a6aab3616af53e6), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3)

</details>

</details>

<a id="decl-a55a9cf36affc3d3"></a>

<details>
<summary><code>TensorCore.gemmEpilogue_correct</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L80)

```lean
/-- All four executed scalar stages satisfy their independent rounding relations. -/
theorem gemmEpilogue_correct (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell)
    (t : ScaledGemmCell cfg) (h : gemmEpilogue cfg alpha beta c product = some t) :
    GemmRounded cfg.multiplyStage (t.alpha.value * product.output.value) t.scaledProduct.bits ∧
    GemmRounded cfg.multiplyStage (t.beta.value * t.c.value) t.scaledC.bits ∧
    GemmRounded cfg.addStage (t.scaledProduct.value + t.scaledC.value) t.sum.bits ∧
    GemmRounded cfg.output t.sum.value t.output.bits := by
  obtain ⟨_, _, _, _, ha, hb, hs, ho⟩ := gemmEpilogue_spec cfg alpha beta c product t h
  exact ⟨gemmConversion_correct _ _ _ ha, gemmConversion_correct _ _ _ hb,
    gemmConversion_correct _ _ _ hs, gemmConversion_correct _ _ _ ho⟩
```

**Supporting proofs:** [TensorCore.gemmConversion_correct](ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.GemmRounded](ScaledGemm.md#decl-601fdad850a94274), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5bb52d0e23c81596"></a>

<details>
<summary><code>TensorCore.ScaledGemmCell.scalarError</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L91)

```lean
/-- Explicit epilogue losses, including final output conversion. -/
def ScaledGemmCell.scalarError (t : ScaledGemmCell cfg) : ℚ :=
  absQ (t.alpha.value * t.product.output.value - t.scaledProduct.value) +
  absQ (t.beta.value * t.c.value - t.scaledC.value) +
  absQ (t.scaledProduct.value + t.scaledC.value - t.sum.value) +
  absQ (t.sum.value - t.output.value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.ScaledGemmCell.errorBudget](ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-4b85a5b450b169a8"></a>

<details>
<summary><code>TensorCore.ScaledGemmCell.errorBudget</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L97)

```lean
def ScaledGemmCell.errorBudget (t : ScaledGemmCell cfg) : ℚ :=
  absQ t.alpha.value * t.product.errorBudget + t.scalarError
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell.errorBudget](Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.scaledCellJson](Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.scaledCellJson](Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-be05cc60206155ae"></a>

<details>
<summary><code>TensorCore.gemmAbs_mul</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L100)

```lean
theorem gemmAbs_mul (x y : ℚ) : absQ (x * y) = absQ x * absQ y := by
  by_cases hy : 0 < y
  · rw [absQ_mul_pos x y hy]
    have : absQ y = y := by simp [absQ, Rat.not_lt.mpr (Rat.le_of_lt hy)]
    rw [this]
  · by_cases hz : y = 0
    · simp [hz, absQ]
    · have hn : 0 < -y := by grind
      have he := absQ_mul_pos x (-y) hn
      have hx : x * -y = -(x * y) := by grind
      rw [hx, absQ_neg] at he
      have ha : absQ y = -y := by simp [absQ, show y < 0 by grind]
      rwa [ha]
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](../Core/Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53)

**Definitions and types:** [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.gemmInputPairError_bound](InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.gemmInputPairTightError_bound](TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.gemmSourceError_propagate](InputBounds.md#decl-7a3b7a6efc84a1d7), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>

<a id="decl-0c7811dde43338db"></a>

<details>
<summary><code>TensorCore.ScaledGemmCell.propagate</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L116)

```lean
/-- Scalar rounding losses are added; the preceding tensor-core error is
amplified by |alpha|. This theorem accepts any bound on the product stage. -/
theorem ScaledGemmCell.propagate (t : ScaledGemmCell cfg) (z E : ℚ)
    (h : absQ (z - t.product.output.value) ≤ E) :
    absQ (t.alpha.value * z + t.beta.value * t.c.value - t.output.value) ≤
      absQ t.alpha.value * E + t.scalarError := by
  have hm := Rat.mul_le_mul_of_nonneg_left h (absQ_nonneg t.alpha.value)
  rw [← gemmAbs_mul] at hm
  have h1 := absQ_add_le (t.alpha.value * (z - t.product.output.value))
    (t.alpha.value * t.product.output.value - t.scaledProduct.value)
  have h2 := absQ_add_le
    (t.alpha.value * (z - t.product.output.value) +
      (t.alpha.value * t.product.output.value - t.scaledProduct.value))
    (t.beta.value * t.c.value - t.scaledC.value)
  have h3 := absQ_add_le
    (t.alpha.value * (z - t.product.output.value) +
      (t.alpha.value * t.product.output.value - t.scaledProduct.value) +
      (t.beta.value * t.c.value - t.scaledC.value))
    (t.scaledProduct.value + t.scaledC.value - t.sum.value)
  have h4 := absQ_add_le
    (t.alpha.value * (z - t.product.output.value) +
      (t.alpha.value * t.product.output.value - t.scaledProduct.value) +
      (t.beta.value * t.c.value - t.scaledC.value) +
      (t.scaledProduct.value + t.scaledC.value - t.sum.value))
    (t.sum.value - t.output.value)
  unfold scalarError
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-aee47dc0721f3c2d"></a>

<details>
<summary><code>TensorCore.scaledGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L144)

```lean
/-- None denotes rejection by a finite input or conversion stage. Alpha=0 and
beta=0 do not bypass validation or execution of their respective operands. -/
def scaledGemm (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    DenseMatrix (Option (ScaledGemmCell cfg)) m n :=
  let products := gemm model A B (DenseMatrix.ofFn fun _ _ => 0)
  DenseMatrix.ofFn fun i j => do
    let product ← products[i.val][j.val].toOption
    gemmEpilogue cfg alpha beta C[i.val][j.val] product
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.PaperSpec.convertMatrix_eq](Specification/ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.input_conversion_contract](Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.scaled_rectangular](Regression/GemmExtensions.md#decl-94ac378f052b4fa8), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmInput_entry](ScaledGemm.md#decl-fa0fab71bf8fc712), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.scaledGemmBits](ScaledGemm.md#decl-54ef760c8311c4d0), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-54ef760c8311c4d0"></a>

<details>
<summary><code>TensorCore.scaledGemmBits</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L152)

```lean
def scaledGemmBits (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    DenseMatrix (Option (BitVec cfg.output.format.width)) m n :=
  (scaledGemm model cfg alpha beta A B C).map fun row => row.map fun cell => cell.map (·.output.bits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scaledGemmBits_eq_independent](Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.Regression.independent_scaled_complete](../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.scaled_c_placement](Regression/GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_conversion](Regression/GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_multiply_rounding](Regression/GemmExtensions.md#decl-43dfad9ae9cb03ec), [TensorCore.Regression.scaled_rejections_and_zero](Regression/GemmExtensions.md#decl-d1b81d931f9d9b7f)

</details>

</details>

<a id="decl-d68ce5e2862aec7d"></a>

<details>
<summary><code>TensorCore.scaledGemmCellIdeal</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L157)

```lean
def scaledGemmCellIdeal (alpha beta c : F32) (pairs : List (F16 × F16)) : Option ℚ := do
    let a ← value32 alpha
    let b ← value32 beta
    let c ← value32 c
    let p ← idealProducts v100F16F32 pairs
    return a * p + b * c
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-566f73fbf4351125"></a>

<details>
<summary><code>TensorCore.scaledGemmIdeal</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L164)

```lean
def scaledGemmIdeal (alpha beta : F32) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => scaledGemmCellIdeal alpha beta C[i.val][j.val] (gemmPairs A B i j)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-438d50a92caf24c7"></a>

<details>
<summary><code>TensorCore.scaledGemm_entry</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L168)

```lean
theorem scaledGemm_entry (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (i : Fin m) (j : Fin n) (t : ScaledGemmCell cfg)
    (h : (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t) :
    ∃ product, simulateGemmCell model (gemmPairs A B i j) 0 = .ok product ∧
      gemmEpilogue cfg alpha beta C[i.val][j.val] product = some t := by
  simp only [scaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn, gemm_entry] at h
  change ((simulateGemmCell model (gemmPairs A B i j) (0 : F32)).toOption.bind
    fun product => gemmEpilogue cfg alpha beta C[i.val][j.val] product) = some t at h
  cases hr : simulateGemmCell model (gemmPairs A B i j) 0 with
  | error e => rw [hr] at h; contradiction
  | ok product =>
    rw [hr] at h
    exact ⟨product, rfl, h⟩
```

**Supporting proofs:** [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-38cc18d9d963e536"></a>

<details>
<summary><code>TensorCore.finite32_value</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L183)

```lean
private theorem finite32_value {bits : F32} {d : Finite32}
    (h : finite32 bits = some d) : value32 bits = some d.value := by
  rw [← finite32_bits h]
  simp [value32, d.valid, Finite32.value]
```

**Supporting proofs:** [TensorCore.finite32_bits](../TC/Program/Defs.md#decl-08ec57f1c290b572)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-41d7005d3d150b02"></a>

<details>
<summary><code>TensorCore.scaledGemm_entry_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L188)

```lean
theorem scaledGemm_entry_error (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (i : Fin m) (j : Fin n) (t : ScaledGemmCell cfg) (z : ℚ)
    (h : (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t)
    (hi : (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some z) :
    absQ (z - t.output.value) ≤ t.errorBudget := by
  obtain ⟨product, hr, he⟩ := scaledGemm_entry model cfg alpha beta A B C i j t h
  obtain ⟨ht, ha, hb, hc, _⟩ := gemmEpilogue_spec cfg alpha beta _ product t he
  have hv := finite32_value (simulateGemmCell_spec _ _ _ _ hr).1
  have hz : product.initial.value = 0 := by
    have h0 : value32 0 = some 0 := by decide +kernel
    rw [h0] at hv
    exact (Option.some.inj hv).symm
  simp only [scaledGemmIdeal, scaledGemmCellIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, bind, pure,
    finite32_value ha, finite32_value hb, finite32_value hc, Option.bind_some] at hi
  cases hp : idealProducts v100F16F32 (gemmPairs A B i j) with
  | none => simp [hp] at hi
  | some p =>
    have hprod := simulateGemmCell_error _ _ _ _ _ hr hp
    simp only [hz, Rat.zero_add] at hprod
    have hfinal := t.propagate p product.errorBudget (by simpa [ht] using hprod)
    simp only [hp, Option.bind_some, Option.some.injEq] at hi
    rw [← hi]
    simpa [ht, ScaledGemmCell.errorBudget] using hfinal
```

**Supporting proofs:** [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87), [TensorCore.finite32_value](ScaledGemm.md#decl-38cc18d9d963e536)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.errorBudget](Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.errorBudget](ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-90caef944befb68d"></a>

<details>
<summary><code>TensorCore.convertGemmWord</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L214)

```lean
/-- Explicit input conversion. Exact zero follows the generic +0 convention. -/
def convertGemmWord (source target : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) : Option (BitVec target.width) := do
  let x ← binaryValue source bits
  let y ← (ConversionStage.mk target mode).convert x
  return y.bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrixToLayout_eq](Specification/NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.convertMatrix_eq](Specification/ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.input_conversion_contract](Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.scalarConvertWord_eq](Specification/ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.Regression.NativeScaled.directed_input_conversion](Regression/NativeScaledGemm.md#decl-e7e7e2b3bee0ac7e), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.subnormal_zero_boundaries](Regression/NativeScaledGemm.md#decl-bc504f6ac48ae017), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmInput_entry](ScaledGemm.md#decl-fa0fab71bf8fc712), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertGemmWord_correct](ScaledGemm.md#decl-4a6aab3616af53e6), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.convertMatrixTo_entry](MatrixConversion.md#decl-d6a9de60120b6e01), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.gemmInputDatum_of_conversion](InputBounds.md#decl-63322710811f0233), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.inputDatumTo_of_conversion](MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

</details>

</details>

<a id="decl-4a6aab3616af53e6"></a>

<details>
<summary><code>TensorCore.convertGemmWord_correct</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L220)

```lean
theorem convertGemmWord_correct (source target : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (output : BitVec target.width)
    (h : convertGemmWord source target mode input = some output) :
    ∃ x, binaryValue source input = some x ∧ GemmRounded ⟨target, mode⟩ x output := by
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, hx, y, hy, he⟩ := h
  cases Option.some.inj he
  exact ⟨x, hx, gemmConversion_correct _ _ _ hy⟩
```

**Supporting proofs:** [TensorCore.gemmConversion_correct](ScaledGemm.md#decl-e58a1d25b374dba1)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmRounded](ScaledGemm.md#decl-601fdad850a94274), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-02d35e3c713c1e24"></a>

<details>
<summary><code>TensorCore.convertGemmInput</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L230)

```lean
/-- Conversion failure rejects the matrix; it never substitutes a zero operand. -/
def convertGemmInput (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) : Option (DenseMatrix F16 m n) :=
  if ∀ i : Fin m, ∀ j : Fin n, (convertGemmWord source fp16 mode A[i.val][j.val]).isSome then
    some (DenseMatrix.ofFn fun i j => (convertGemmWord source fp16 mode A[i.val][j.val]).getD 0)
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.PaperSpec.convertMatrix_eq](Specification/ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.input_conversion_contract](Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.scaled_conversion](Regression/GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_rejections_and_zero](Regression/GemmExtensions.md#decl-d1b81d931f9d9b7f), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertGemmInput_entry](ScaledGemm.md#decl-fa0fab71bf8fc712), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58)

</details>

</details>

<a id="decl-fa0fab71bf8fc712"></a>

<details>
<summary><code>TensorCore.convertGemmInput_entry</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L236)

```lean
theorem convertGemmInput_entry (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix F16 m n)
    (h : convertGemmInput source mode A = some B) (i : Fin m) (j : Fin n) :
    convertGemmWord source fp16 mode A[i.val][j.val] = some B[i.val][j.val] := by
  unfold convertGemmInput at h
  split at h
  · rename_i hs
    cases Option.some.inj h
    have hi := hs i j
    cases hv : convertGemmWord source fp16 mode A[i.val][j.val] with
    | none => simp [hv] at hi
    | some v => simp [DenseMatrix.ofFn, hv]
  · contradiction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.input_conversion_contract](Specification/GemmComposition.md#decl-ac7f025391a91852), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c)

</details>

</details>

<a id="decl-f354aa226c12ed99"></a>

<details>
<summary><code>TensorCore.convertedGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemm.lean#L252)

```lean
/-- Convenience pipeline for explicitly converted input matrices. The scaledGemm
error theorem concerns the converted operands; source-to-FP16 loss is additional. -/
def convertedGemm (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option (ScaledGemmCell cfg)) m n) := do
  let a ← convertGemmInput source inputMode A
  let b ← convertGemmInput source inputMode B
  return scaledGemm model cfg alpha beta a b C
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d)

<details>
<summary>Used by</summary>

[TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.Regression.independent_converted_rejection](../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d)

</details>

</details>
