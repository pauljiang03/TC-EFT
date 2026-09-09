# TensorCore.Gemm.NativeGemm

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-1b7c099e42422b0b"></a>

<details>
<summary><code>TensorCore.NativePrecision</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L7)

```lean
inductive NativePrecision where
  | bf16 | tf32
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](Cli/ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.ExtendedAnalysis.nativeModel](Cli/ExtendedAnalysis.md#decl-f07e458a7c9f11ef), [TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.ExtendedAnalysis.precision](Cli/ExtendedAnalysis.md#decl-070682d91fce08b6), [TensorCore.Cli.NativePipeline.evaluate](Cli/NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Cli.Selection.problem](Cli/GemmSelection.md#decl-2fb1639c2044a112), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.columns](NativeGemm.md#decl-bd8f696cbf181bd5), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.native_parameters](Specification/NativeGemmEquivalence.md#decl-09f18a2164359124), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.intermediate_overflow_rejected](Regression/NativeScaledGemm.md#decl-6d29392f8e156c74), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.sourceProblem](Regression/NativeScaledGemm.md#decl-8b6ac1fc2c8cb122), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.NativeScaled.tiny](Regression/NativeScaledGemm.md#decl-9de6ebab37ab361d), [TensorCore.Regression.ReviewClaims.nativeA](Regression/ReviewClaims.md#decl-4c34aadebeebde79), [TensorCore.Regression.ReviewClaims.nativeB](Regression/ReviewClaims.md#decl-547d89a71879883e), [TensorCore.Regression.ReviewClaims.nativeTiny](Regression/ReviewClaims.md#decl-80e9eadb0c11a7c4), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_empty_domain](Regression/DecisionExtensions.md#decl-0c0badea6a26af57), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca), [TensorCore.native_shape](NativeGemm.md#decl-dc473181786d5771), [TensorCore.native_zero_products](NativeGemm.md#decl-f24f4761f46023ad)

</details>

</details>

<a id="decl-837815a482deb8b3"></a>

<details>
<summary><code>TensorCore.NativePrecision.format</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L11)

```lean
@[implicit_reducible] def NativePrecision.format : NativePrecision → Format
  | .bf16 => TensorCore.bf16 | .tf32 => tf19
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.bf16](../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.tf19](../Core/Defs.md#decl-1b853137564a343d)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](Cli/ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.Selection.problem](Cli/GemmSelection.md#decl-2fb1639c2044a112), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.Regression.NativeScaled.tiny](Regression/NativeScaledGemm.md#decl-9de6ebab37ab361d), [TensorCore.Regression.ReviewClaims.nativeTiny](Regression/ReviewClaims.md#decl-80e9eadb0c11a7c4), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312)

</details>

</details>

<a id="decl-a3abe0ff1ca91653"></a>

<details>
<summary><code>TensorCore.NativeGemmModel</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L14)

```lean
inductive NativeGemmModel : NativePrecision → Type where
  | ampere : NativeGemmModel p
  | hopper : NativeGemmModel p
  | hopperMma : NativeGemmModel .tf32
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](Cli/ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.ExtendedAnalysis.nativeModel](Cli/ExtendedAnalysis.md#decl-f07e458a7c9f11ef), [TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.NativePipeline.evaluate](Cli/NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmModel.columns](NativeGemm.md#decl-bd8f696cbf181bd5), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.native_parameters](Specification/NativeGemmEquivalence.md#decl-09f18a2164359124), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.intermediate_overflow_rejected](Regression/NativeScaledGemm.md#decl-6d29392f8e156c74), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_empty_domain](Regression/DecisionExtensions.md#decl-0c0badea6a26af57), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca), [TensorCore.native_shape](NativeGemm.md#decl-dc473181786d5771), [TensorCore.native_zero_products](NativeGemm.md#decl-f24f4761f46023ad)

</details>

</details>

<a id="decl-ac6b62d5b4f2d47b"></a>

<details>
<summary><code>TensorCore.NativeGemmModel.products</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L20)

```lean
def NativeGemmModel.products : NativeGemmModel p → ℕ
  | .ampere => match p with | .bf16 => 8 | .tf32 => 4
  | .hopper => match p with | .bf16 => 16 | .tf32 => 4
  | .hopperMma => 8
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca), [TensorCore.native_shape](NativeGemm.md#decl-dc473181786d5771)

</details>

</details>

<a id="decl-55e737716812459e"></a>

<details>
<summary><code>TensorCore.NativeGemmModel.profile</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L25)

```lean
@[implicit_reducible] def NativeGemmModel.profile (model : NativeGemmModel p) : Profile :=
  ⟨p.format, model.products,
    (match model with | .ampere => 24 | _ => 25),
    some (match model with | .ampere => -132 | _ => -133)⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.native_parameters](Specification/NativeGemmEquivalence.md#decl-09f18a2164359124), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.native_zero_products](NativeGemm.md#decl-f24f4761f46023ad)

</details>

</details>

<a id="decl-9b4f9f60884163ac"></a>

<details>
<summary><code>TensorCore.NativePrecision.inner</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L30)

```lean
def NativePrecision.inner : NativePrecision → ℕ
  | .bf16 => 16 | .tf32 => 8
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca), [TensorCore.native_shape](NativeGemm.md#decl-dc473181786d5771)

</details>

</details>

<a id="decl-bd8f696cbf181bd5"></a>

<details>
<summary><code>TensorCore.NativeGemmModel.columns</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L33)

```lean
def NativeGemmModel.columns : NativeGemmModel p → ℕ
  | .hopperMma => 8 | _ => 16
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a)

</details>

</details>

<a id="decl-adb4602de4a52395"></a>

<details>
<summary><code>TensorCore.NativeWord</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L36)

```lean
abbrev NativeWord (p : NativePrecision) := BitVec p.format.width
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.NativeScaled.tiny](Regression/NativeScaledGemm.md#decl-9de6ebab37ab361d), [TensorCore.Regression.ReviewClaims.nativeA](Regression/ReviewClaims.md#decl-4c34aadebeebde79), [TensorCore.Regression.ReviewClaims.nativeB](Regression/ReviewClaims.md#decl-547d89a71879883e), [TensorCore.Regression.ReviewClaims.nativeTiny](Regression/ReviewClaims.md#decl-80e9eadb0c11a7c4), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_empty_domain](Regression/DecisionExtensions.md#decl-0c0badea6a26af57), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca)

</details>

</details>

<a id="decl-dc473181786d5771"></a>

<details>
<summary><code>TensorCore.native_shape</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L38)

```lean
theorem native_shape (model : NativeGemmModel p) :
    0 < p.inner ∧ p.inner / model.products * model.products = p.inner := by
  cases p <;> cases model <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312)

</details>

</details>

<a id="decl-160e768b2358c84f"></a>

<details>
<summary><code>TensorCore.nativePairs</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L42)

```lean
def nativePairs (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (i : Fin m) (j : Fin n) : List (NativeWord p × NativeWord p) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395)

<details>
<summary>Used by</summary>

[TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257)

</details>

</details>

<a id="decl-68c397c28ec873bf"></a>

<details>
<summary><code>TensorCore.nativePadded</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L46)

```lean
def nativePadded (p : NativePrecision) (xs : List (NativeWord p × NativeWord p)) :=
  xs ++ List.replicate (tailPadding p.inner xs.length) (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.tailPadding](../TC/Program/Partition.md#decl-139b8e76e9854993)

<details>
<summary>Used by</summary>

[TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312)

</details>

</details>

<a id="decl-f6682c5a0b1f9312"></a>

<details>
<summary><code>TensorCore.nativePartition</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L49)

```lean
def nativePartition (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :
    OrderedPartition model.profile (nativePadded p xs) :=
  partitionExact model.profile (groupCount p.inner xs.length * (p.inner / model.products))
    (nativePadded p xs) (by
      simp only [nativePadded, List.length_append, List.length_replicate]
      change xs.length + tailPadding p.inner xs.length =
        groupCount p.inner xs.length * (p.inner / model.products) * model.products
      rw [padded_length _ _ (native_shape model).1, Nat.mul_assoc, (native_shape model).2])
```

**Supporting proofs:** [TensorCore.native_shape](NativeGemm.md#decl-dc473181786d5771), [TensorCore.padded_length](../TC/Program/Partition.md#decl-61da2d73822bd178)

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.partitionExact](../TC/Program/Partition.md#decl-4082e3bf596a58d7), [TensorCore.tailPadding](../TC/Program/Partition.md#decl-139b8e76e9854993)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5)

</details>

</details>

<a id="decl-ae9fa1eae5c4de10"></a>

<details>
<summary><code>TensorCore.nativeBlocks</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L58)

```lean
def nativeBlocks (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :=
  (nativePartition model xs).inputs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.OrderedPartition.inputs](../TC/Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5)

</details>

</details>

<a id="decl-7c945534c2fd32b9"></a>

<details>
<summary><code>TensorCore.nativeBlocks_shape</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L61)

```lean
theorem nativeBlocks_shape (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :
    ∀ g ∈ nativeBlocks model xs, g.length = model.profile.products := by
  intro g hg
  obtain ⟨block, _, rfl⟩ := List.mem_map.mp hg
  exact block.shape
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50)

</details>

</details>

<a id="decl-f24f4761f46023ad"></a>

<details>
<summary><code>TensorCore.native_zero_products</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L67)

```lean
theorem native_zero_products (model : NativeGemmModel p) (n : ℕ) :
    idealProducts model.profile (List.replicate n (0, 0)) = some 0 := by
  have hz : model.profile.decode (BitVec.ofNat _ 0) = some ⟨0, 0, 0⟩ := by
    cases p <;> cases model <;> decide +kernel
  have hp : prepareProducts model.profile (List.replicate n (0, 0)) =
      some (List.replicate n (Decoded.mk 0 0 0, Decoded.mk 0 0 0)) := by
    induction n with
    | zero => rfl
    | succ n ih =>
      simp [prepareProducts] at ih
      simp [prepareProducts, List.replicate_succ, List.mapM_cons, hz, ih]
  simp only [idealProducts, hp, Option.map_some]
  congr 1
  clear hp
  induction n with
  | zero => rfl
  | succ n ih =>
    simp [Decoded.value] at ih
    simp [List.replicate_succ, sumQ, ih, Decoded.value]
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../TC/Defs.md#decl-178599198b2d538e), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepareProducts](../TC/Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b)

</details>

</details>

<a id="decl-0c5bde18a7b3d55b"></a>

<details>
<summary><code>TensorCore.nativeBlocks_ideal</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L88)

```lean
theorem nativeBlocks_ideal (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :
    idealContributions model.profile (nativeBlocks model xs) = idealProducts model.profile xs := by
  rw [nativeBlocks, OrderedPartition.ideal, nativePadded, idealProducts_append, native_zero_products]
  cases idealProducts model.profile xs <;> simp [Rat.add_zero]
```

**Supporting proofs:** [TensorCore.OrderedPartition.ideal](../TC/Program/DotProduct.md#decl-b269022d73a4c27d), [TensorCore.idealProducts_append](../TC/Program/DotProduct.md#decl-623f08595b227aca), [TensorCore.native_zero_products](NativeGemm.md#decl-f24f4761f46023ad)

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.OrderedPartition.inputs](../TC/Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.tailPadding](../TC/Program/Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40)

</details>

</details>

<a id="decl-7bd05491f02ceac8"></a>

<details>
<summary><code>TensorCore.NativeGemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L93)

```lean
structure NativeGemmCell where
  initial : Finite32
  blocks : List BlockTrace
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_empty_domain](Regression/DecisionExtensions.md#decl-0c0badea6a26af57), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca)

</details>

</details>

<a id="decl-270e5e5e51ac1063"></a>

<details>
<summary><code>TensorCore.NativeGemmCell.output</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L98)

```lean
def NativeGemmCell.output (c : NativeGemmCell) : Finite32 := lastOutput c.initial c.blocks
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_empty_domain](Regression/DecisionExtensions.md#decl-0c0badea6a26af57), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e)

</details>

</details>

<a id="decl-74e63a5f52eb41d5"></a>

<details>
<summary><code>TensorCore.nativeGemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L100)

```lean
def nativeGemmCell (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) (c : F32) :
    Option NativeGemmCell := do
  let initial ← finite32 c
  let ts ← (runBlocks model.profile c (nativeBlocks model xs)).toOption
  return ⟨initial, ts⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeGemmCell_eq_paper](Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.native_bf16_cases](Regression/DecisionExtensions.md#decl-38aebe2520c2a30b), [TensorCore.Regression.native_empty_domain](Regression/DecisionExtensions.md#decl-0c0badea6a26af57), [TensorCore.Regression.native_tf32_cases](Regression/DecisionExtensions.md#decl-519be474ddd83571), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca)

</details>

</details>

<a id="decl-3e7365cc3e663fc5"></a>

<details>
<summary><code>TensorCore.nativeGemmCell_blocks_length</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L106)

```lean
theorem nativeGemmCell_blocks_length (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (cell : NativeGemmCell)
    (h : nativeGemmCell model xs c = some cell) :
    cell.blocks.length = groupCount p.inner xs.length * (p.inner / model.products) := by
  cases hf : finite32 c with
  | none => simp [nativeGemmCell, hf] at h
  | some initial =>
    cases hr : runBlocks model.profile c (nativeBlocks model xs) with
    | error e => simp [nativeGemmCell, hf, hr, Except.toOption] at h
    | ok ts =>
      have he : cell = ⟨initial, ts⟩ := by simpa [nativeGemmCell, hf, hr, Except.toOption] using h.symm
      rw [he]
      have hl := runBlocks_length model.profile c (nativeBlocks model xs) ts hr
      simpa [nativeBlocks, OrderedPartition.inputs, nativePartition, partitionExact_count] using hl
```

**Supporting proofs:** [TensorCore.partitionExact_count](../TC/Program/Partition.md#decl-f23e6df7073e6ba8), [TensorCore.runBlocks_length](../TC/Program/ErrorBounds.md#decl-60cd89558816c4b8)

**Definitions and types:** [TensorCore.BlockOperands](../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativePadded](NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.partitionExact](../TC/Program/Partition.md#decl-4082e3bf596a58d7), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca)

</details>

</details>

<a id="decl-fd3ddc25e4345bca"></a>

<details>
<summary><code>TensorCore.native_instruction_trace_covers</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L121)

```lean
theorem native_instruction_trace_covers (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (cell : NativeGemmCell)
    (h : nativeGemmCell model xs c = some cell) :
    (chunks (p.inner / model.products) (groupCount p.inner xs.length) cell.blocks).flatten = cell.blocks :=
  chunks_flatten _ _ _ (nativeGemmCell_blocks_length model xs c cell h)
```

**Supporting proofs:** [TensorCore.chunks_flatten](../TC/Instruction.md#decl-0e5864e5ebfec510), [TensorCore.nativeGemmCell_blocks_length](NativeGemm.md#decl-3e7365cc3e663fc5)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.chunks](../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e)

</details>

</details>

<a id="decl-0dc3f0675850245e"></a>

<details>
<summary><code>TensorCore.nativeGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L128)

```lean
def nativeGemm (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) :
    DenseMatrix (Option NativeGemmCell) m n :=
  DenseMatrix.ofFn fun i j => nativeGemmCell model (nativePairs A B i j) C[i.val][j.val]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.PaperSpec.nativeGemm_eq_paper](Specification/NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-b9b24fce99a6a8c6"></a>

<details>
<summary><code>TensorCore.nativeGemmIdeal</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L133)

```lean
def nativeGemmIdeal (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) : DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => do
    let c ← value32 C[i.val][j.val]
    let products ← idealProducts model.profile (nativePairs A B i j)
    return c + products
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-9b50e2e7318616a8"></a>

<details>
<summary><code>TensorCore.checkNativeCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L140)

```lean
def checkNativeCell (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p))
    (c : F32) (ws : List GroupWitness) : Option AnalysisBound := do
  let cv ← value32 c
  checkGroups model.profile (nativeBlocks model xs) (absQ cv) ws
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGroups](../TC/Program/GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-3d33153bf5b5dc40"></a>

<details>
<summary><code>TensorCore.checkNativeCell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L145)

```lean
theorem checkNativeCell_sound (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p))
    (c : F32) (ws : List GroupWitness) (b : AnalysisBound) (h : checkNativeCell model xs c ws = some b) :
    ∃ cell products, nativeGemmCell model xs c = some cell ∧
      idealProducts model.profile xs = some products ∧ value32 c = some cell.initial.value ∧
      absQ cell.output.value ≤ b.magnitude ∧
      absQ (cell.initial.value + products - cell.output.value) ≤ b.error := by
  simp only [checkNativeCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨cv, hv, hc⟩ := h
  obtain ⟨initial, hi, hb, hval⟩ := finite32_of_value32 c cv hv
  obtain ⟨ts, products, hr, hp, hm, he⟩ := checkGroups_sound model.profile
    (nativeBlocks model xs) (absQ cv) ws b hc initial (by rw [hval]; exact Rat.le_refl)
  rw [hb] at hr
  exact ⟨⟨initial, ts⟩, products, by simp [nativeGemmCell, hi, hr, Except.toOption],
    by rwa [nativeBlocks_ideal] at hp, by simpa [hval] using hv, hm, he⟩
```

**Supporting proofs:** [TensorCore.checkGroups_sound](../TC/Program/GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.nativeBlocks_ideal](NativeGemm.md#decl-0c5bde18a7b3d55b)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGroups](../TC/Program/GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-75268401e2373f4a"></a>

<details>
<summary><code>TensorCore.analyzeNativeCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L160)

```lean
def analyzeNativeCell (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) (c : F32) :
    Option CellAnalysis := do
  let cv ← value32 c
  let ws ← inferGroups model.profile (nativeBlocks model xs) (absQ cv)
  let b ← checkNativeCell model xs c ws
  return ⟨ws, b⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.inferGroups](../TC/Program/GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72)

</details>

</details>

<a id="decl-6973598426e420da"></a>

<details>
<summary><code>TensorCore.analyzeNativeCell_checked</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L167)

```lean
theorem analyzeNativeCell_checked (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (a : CellAnalysis)
    (h : analyzeNativeCell model xs c = some a) : checkNativeCell model xs c a.witness = some a.bound := by
  simp only [analyzeNativeCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨_, _, _, _, _, hb, rfl⟩ := h
  exact hb
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.inferGroups](../TC/Program/GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee)

</details>

</details>

<a id="decl-6fb9db9d725eff50"></a>

<details>
<summary><code>TensorCore.analyzeNativeCell_complete</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L174)

```lean
theorem analyzeNativeCell_complete (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (cv M : ℚ)
    (hc : value32 c = some cv) (hm : scheduleMass model.profile (nativeBlocks model xs) = some M)
    (hr : absQ cv + M ≤ maxFinite32) : ∃ a, analyzeNativeCell model xs c = some a := by
  obtain ⟨ws, hw⟩ := inferGroups_complete model.profile (nativeBlocks model xs) (absQ cv) M
    (nativeBlocks_shape model xs) (absQ_nonneg cv) hm hr
  obtain ⟨b, hb⟩ := inferGroups_checked model.profile (nativeBlocks model xs) (absQ cv) ws hw
  exact ⟨⟨ws, b⟩, by simp [analyzeNativeCell, checkNativeCell, hc, hw, hb]⟩
```

**Supporting proofs:** [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.inferGroups_checked](../TC/Program/GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](../TC/Program/GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.nativeBlocks_shape](NativeGemm.md#decl-7c945534c2fd32b9)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.checkGroups](../TC/Program/GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.inferGroups](../TC/Program/GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.nativeBlocks](NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.scheduleMass](../TC/Program/GroupAnalysis.md#decl-dbedd44c59d564b7), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7ea04ca33432bb35"></a>

<details>
<summary><code>TensorCore.analyzeNativeGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L184)

```lean
def analyzeNativeGemm (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) :=
  DenseMatrix.ofFn fun i j => analyzeNativeCell model (nativePairs A B i j) C[i.val][j.val]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd)

</details>

</details>

<a id="decl-10bee9068a09e5e3"></a>

<details>
<summary><code>TensorCore.nativeAnalysisCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L188)

```lean
def nativeAnalysisCheck (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n)
    (ws : DenseMatrix (List GroupWitness) m n) (tol : ℚ) : Bool :=
  decide (0 ≤ tol) && decide (∀ i : Fin m, ∀ j : Fin n,
    ((checkNativeCell model (nativePairs A B i j) C[i.val][j.val] ws[i.val][j.val]).map
      fun b => decide (b.error ≤ tol)).getD false = true)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-05565e34f54e5d74"></a>

<details>
<summary><code>TensorCore.NativeGemmAccurate</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L195)

```lean
def NativeGemmAccurate (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) (tol : ℚ) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ cell z,
    (nativeGemm model A B C)[i.val][j.val] = some cell ∧
    (nativeGemmIdeal model A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-f6bddcc98d97f99f"></a>

<details>
<summary><code>TensorCore.nativeAnalysisCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L201)

```lean
theorem nativeAnalysisCheck_sound (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n)
    (ws : DenseMatrix (List GroupWitness) m n) (tol : ℚ)
    (h : nativeAnalysisCheck model A B C ws tol = true) : NativeGemmAccurate model A B C tol := by
  simp only [nativeAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro i j
  have hc := h.2 i j
  cases hb : checkNativeCell model (nativePairs A B i j) C[i.val][j.val] ws[i.val][j.val] with
  | none => simp [hb] at hc
  | some b =>
    simp only [hb, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
    obtain ⟨cell, products, hr, hp, hv, _, he⟩ := checkNativeCell_sound model _ _ _ b hb
    exact ⟨cell, cell.initial.value + products, by simpa [nativeGemm, DenseMatrix.ofFn] using hr,
      by simp [nativeGemmIdeal, DenseMatrix.ofFn, hv, hp], Rat.le_trans he hc⟩
```

**Supporting proofs:** [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27)

</details>

</details>

<a id="decl-3cd7435d85d547ee"></a>

<details>
<summary><code>TensorCore.analyzeNativeGemm_entry_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L216)

```lean
theorem analyzeNativeGemm_entry_sound (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) (a : CellAnalysis)
    (h : (analyzeNativeGemm model A B C)[i.val][j.val] = some a) :
    ∃ cell z, (nativeGemm model A B C)[i.val][j.val] = some cell ∧
      (nativeGemmIdeal model A B C)[i.val][j.val] = some z ∧
      absQ cell.output.value ≤ a.bound.magnitude ∧ absQ (z - cell.output.value) ≤ a.bound.error := by
  have hc := analyzeNativeCell_checked model (nativePairs A B i j) C[i.val][j.val] a (by simpa [analyzeNativeGemm, DenseMatrix.ofFn] using h)
  obtain ⟨cell, products, hr, hp, hv, hm, he⟩ := checkNativeCell_sound model _ _ _ _ hc
  exact ⟨cell, cell.initial.value + products, by simpa [nativeGemm, DenseMatrix.ofFn] using hr,
    by simp [nativeGemmIdeal, DenseMatrix.ofFn, hv, hp], hm, he⟩
```

**Supporting proofs:** [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd)

</details>

</details>

<a id="decl-8f01a47ceaac6ebd"></a>

<details>
<summary><code>TensorCore.analyzeNativeGemm_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeGemm.lean#L228)

```lean
theorem analyzeNativeGemm_matrix_error (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n)
    (h : ∀ i : Fin m, ∀ j : Fin n, ∃ a, (analyzeNativeGemm model A B C)[i.val][j.val] = some a)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (nativeGemm model A B C)[i.val][j.val] = some cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (nativeGemmIdeal model A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (analysisEntryBounds (analyzeNativeGemm model A B C)) := by
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨a, ha⟩ := h i j
  obtain ⟨cell, z, hr, hi, _, he⟩ := analyzeNativeGemm_entry_sound model A B C i j a ha
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, analysisEntryBounds, ha, hd i j cell hr] using he
```

**Supporting proofs:** [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analysisEntryBounds](Analysis.md#decl-d1b4af0b27a0d0ba), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.nativeGemm](NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmIdeal](NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
