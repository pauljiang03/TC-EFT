# TensorCore.Gemm.Defs

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a44ab2c261ff842b"></a>

<details>
<summary><code>TensorCore.WmmaGemmModel</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L19)

```lean
/-- Select a sourced FP16 WMMA m16n16k16 arithmetic path. -/
inductive WmmaGemmModel where
  | v100 | ampere | hopper
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.report](Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.ExtendedAnalysis.evaluate](Cli/ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.GemmInput.model](Cli/GemmInput.md#decl-fc8688802cab1a09), [TensorCore.Cli.PipelineAnalysis.familyReport](Cli/PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.Selection.candidate](Cli/GemmSelection.md#decl-0ce6164bf816c3c9), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.CutlassWmma.project_eq_gemm](Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.EntryFamilyAccurate](EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmFamilyAccurate](Family.md#decl-6a51b2e27db67ff4), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](Specification/GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](Specification/GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](Specification/GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.instructionGroups_eq_paper](Specification/GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.PaperSpec.wmmaModel](Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.PaperSpec.wmma_parameters](Specification/GemmEquivalence.md#decl-193ac1310155f18d), [TensorCore.Regression.NativeScaled.candidates](Regression/NativeScaledGemm.md#decl-bc91542b4d9b5ae6), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.chosen](Regression/ReviewClaims.md#decl-faca76b37ee54430), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](Regression/ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.chosen_decision](Regression/ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.Regression.ReviewClaims.family_members_accurate](Regression/ReviewClaims.md#decl-5a504b60d62ca03e), [TensorCore.Regression.ReviewClaims.tiny_outputs](Regression/ReviewClaims.md#decl-d3401f2e29412655), [TensorCore.Regression.analysis_finite_boundary](Regression/GemmAnalysis.md#decl-8904b8e4b9caf447), [TensorCore.Regression.analysis_improves_existing_certificate](Regression/GemmAnalysis.md#decl-a1392f6a35ba7d56), [TensorCore.Regression.analysis_improves_minimal_static](Regression/GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_negative_subnormal](Regression/GemmAnalysis.md#decl-0aab10efcd43b268), [TensorCore.Regression.analysis_nonfinite_rejected](Regression/GemmAnalysis.md#decl-f472b6e439a11eeb), [TensorCore.Regression.analysis_signed_zero_and_empty](Regression/GemmAnalysis.md#decl-4f1d63703ef328c3), [TensorCore.Regression.analysis_tiny_bounds](Regression/GemmAnalysis.md#decl-613947919eca8929), [TensorCore.Regression.analysis_tolerance_certified](Regression/GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.Regression.analysis_tolerance_inconclusive](Regression/GemmAnalysis.md#decl-9f010dd9c59fddca), [TensorCore.Regression.analysis_witness_rejects_mutations](Regression/GemmAnalysis.md#decl-18dc193709d671fa), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.cutlass_fixture_connection](Regression/CutlassWmma.md#decl-e2a0bcb3a499b023), [TensorCore.Regression.cutlass_partial_k_differs](Regression/CutlassWmma.md#decl-dd106a85bafc0aee), [TensorCore.Regression.empty_family_accuracy](Regression/GemmFamily.md#decl-df50441d5d2cb648), [TensorCore.Regression.family_witness_controls](Regression/GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.gemm_architecture_rounding](Regression/Gemm.md#decl-20028f6cbef3dc31), [TensorCore.Regression.gemm_certificate_rejects](Regression/GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_certifies_all_profiles](Regression/GemmExtensions.md#decl-04b959ba551a2db5), [TensorCore.Regression.gemm_empty_k](Regression/Gemm.md#decl-0d8cc5e759e48b07), [TensorCore.Regression.gemm_instruction_boundaries](Regression/Gemm.md#decl-060ec72439234e38), [TensorCore.Regression.gemm_nonfinite](Regression/Gemm.md#decl-f949b3d601cf0ac9), [TensorCore.Regression.gemm_rectangular](Regression/Gemm.md#decl-eede3fdd46c21165), [TensorCore.Regression.identity_epilogue_tight](Regression/DecisionExtensions.md#decl-ce4806500b961d68), [TensorCore.Regression.independent_converted_rejection](../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.input_range_and_special_rejections](Regression/GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.minimalTinyBounds](Regression/GemmAnalysis.md#decl-09d5251e48e6effa), [TensorCore.Regression.minimum_cost_ties](Regression/DecisionExtensions.md#decl-8dfd56f09e57d26a), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.negative_alpha_source_bound](Regression/GemmInputConversion.md#decl-8ffd66ebf0b6eae9), [TensorCore.Regression.paper_gemm_boundaries](Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_gemm_empty_and_nonfinite](Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.pricedModels](Regression/DecisionExtensions.md#decl-bc632cc65faf1783), [TensorCore.Regression.scaled_analysis_empty_output_still_converts](Regression/PipelineAnalysis.md#decl-f9edf42bc23be958), [TensorCore.Regression.scaled_analysis_finite_rejection](Regression/PipelineAnalysis.md#decl-c163cf5fae20f854), [TensorCore.Regression.scaled_analysis_fp32_output_exact](Regression/PipelineAnalysis.md#decl-11515fce5906431f), [TensorCore.Regression.scaled_analysis_source_accuracy](Regression/PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_subnormal](Regression/PipelineAnalysis.md#decl-909c54c1801f1bd8), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](Regression/PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.scaled_analysis_zero](Regression/PipelineAnalysis.md#decl-110688352cbe87bb), [TensorCore.Regression.scaled_c_placement](Regression/GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_certificate_rejects_stages](Regression/GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](Regression/GemmExtensions.md#decl-8c37b22a932158df), [TensorCore.Regression.scaled_conversion](Regression/GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_multiply_rounding](Regression/GemmExtensions.md#decl-43dfad9ae9cb03ec), [TensorCore.Regression.scaled_rectangular](Regression/GemmExtensions.md#decl-94ac378f052b4fa8), [TensorCore.Regression.scaled_rejections_and_zero](Regression/GemmExtensions.md#decl-d1b81d931f9d9b7f), [TensorCore.Regression.selectionModels](Regression/GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.Regression.selectionModes](Regression/GemmSelection.md#decl-c6149ee3773e3071), [TensorCore.Regression.selection_preference_and_duplicates](Regression/GemmSelection.md#decl-904c1ea57c4ea668), [TensorCore.Regression.selection_source_accuracy](Regression/GemmSelection.md#decl-04a6c70aaf01cddf), [TensorCore.Regression.sourceWitness](Regression/PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.Regression.source_empty_dimensions](Regression/GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.Regression.tinyAnalysis](Regression/GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.Regression.tinyWitness](Regression/GemmAnalysis.md#decl-d68e82c966d519d3), [TensorCore.Regression.unitFamilyWitness](Regression/GemmFamily.md#decl-6f4d7edf02c5d4d3), [TensorCore.Regression.unit_family_accuracy](Regression/GemmFamily.md#decl-276ef0fbf20b36cf), [TensorCore.Regression.varied_family_certifies](Regression/DecisionExtensions.md#decl-18eefe337a464c5b), [TensorCore.Regression.varied_family_universal](Regression/DecisionExtensions.md#decl-316ae3e57a6f638f), [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceCertificate_acceptance](TightInputBounds.md#decl-533bbea7ddad7c67), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyError](Family.md#decl-966b1b857128f203), [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d), [TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmBits](Defs.md#decl-adba0115aad6bb7b), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.gemmTiles](Defs.md#decl-374eb9f948a3f6da), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.inferEntryFamily](EntryFamily.md#decl-5e36ba2c223b5587), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848), [TensorCore.inferFamily_valid](Family.md#decl-01c631b0665f69f3), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmBits](ScaledGemm.md#decl-54ef760c8311c4d0), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87), [TensorCore.simulateGemmTile](Defs.md#decl-e29d83b23aa10afc), [TensorCore.gemm_ideal_profile](Defs.md#decl-d3150262da998973)

</details>

</details>

<a id="decl-860954743cbdf9bb"></a>

<details>
<summary><code>TensorCore.WmmaGemmModel.path</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L23)

```lean
def WmmaGemmModel.path : WmmaGemmModel → InstructionPath
  | .v100 => v100Wmma16
  | .ampere => ampereWmma16
  | .hopper => hopperWmma16
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.ampereWmma16](../TC/Instruction.md#decl-b62114cc7439c99c), [TensorCore.hopperWmma16](../TC/Instruction.md#decl-7464b2b22b93945c), [TensorCore.v100Wmma16](../TC/Instruction.md#decl-4d5414e366b3073f)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.instructionGroups_eq_paper](Specification/GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.PaperSpec.wmma_parameters](Specification/GemmEquivalence.md#decl-193ac1310155f18d), [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d), [TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87), [TensorCore.gemm_ideal_profile](Defs.md#decl-d3150262da998973)

</details>

</details>

<a id="decl-d7ce31e450277fbc"></a>

<details>
<summary><code>TensorCore.WmmaGemmModel.k</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L28)

```lean
@[simp] theorem WmmaGemmModel.k (model : WmmaGemmModel) : model.path.k = 16 := by
  cases model <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.runGemmInstructions_eq_paper](Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-5a2664b8ab0c94ef"></a>

<details>
<summary><code>TensorCore.gemmPairs</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L32)

```lean
/-- The original ordered operands for output (i,j), without padding or decoding. -/
def gemmPairs (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (i : Fin m) (j : Fin n) : List (F16 × F16) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemm_eq_paper](Specification/GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmPairs_get](Defs.md#decl-835d11333cc92445), [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-5e4e68c0669cd541"></a>

<details>
<summary><code>TensorCore.gemmPairs_length</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L36)

```lean
@[simp] theorem gemmPairs_length (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (i : Fin m) (j : Fin n) : (gemmPairs A B i j).length = k := by simp [gemmPairs]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmPairs_get](Defs.md#decl-835d11333cc92445), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

</details>

</details>

<a id="decl-835d11333cc92445"></a>

<details>
<summary><code>TensorCore.gemmPairs_get</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L40)

```lean
/-- Each original k index selects exactly its intended row/column operands. -/
theorem gemmPairs_get (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (i : Fin m) (j : Fin n) (l : Fin k) :
    (gemmPairs A B i j)[l.val]'(by simp) = (A[i.val][l.val], B[l.val][j.val]) := by
  simp [gemmPairs]
```

**Supporting proofs:** [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-20dedfe15b3a55c3"></a>

<details>
<summary><code>TensorCore.gemmInstructions</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L46)

```lean
/-- One full k=16 operand slice per WMMA instruction, including zero tail pairs. -/
def gemmInstructions (pairs : List (F16 × F16)) : List (List (F16 × F16)) :=
  (canonicalPartition 16 0 none (by decide) pairs).inputs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition.inputs](../TC/Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.canonicalPartition](../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmInstructions_flatten](Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87)

</details>

</details>

<a id="decl-353da63dd578fcb7"></a>

<details>
<summary><code>TensorCore.gemmInstructions_flatten</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L49)

```lean
theorem gemmInstructions_flatten (pairs : List (F16 × F16)) :
    (gemmInstructions pairs).flatten = padFp16Pairs 16 pairs :=
  (canonicalPartition 16 0 none (by decide) pairs).covers
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.canonicalPartition](../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-863019b6c0164a66"></a>

<details>
<summary><code>TensorCore.gemmInstructions_shape</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L53)

```lean
theorem gemmInstructions_shape (pairs : List (F16 × F16))
    (instruction : List (F16 × F16)) (h : instruction ∈ gemmInstructions pairs) :
    instruction.length = 16 := by
  obtain ⟨group, _, rfl⟩ := List.mem_map.mp h
  exact group.shape
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.canonicalPartition](../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-fa58899497fedd29"></a>

<details>
<summary><code>TensorCore.runGemmInstructions</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L60)

```lean
/-- Execute one output cell's instruction chain; every boundary carries encoded FP32. -/
def runGemmInstructions (p : InstructionPath) :
    Finite32 → List (List (F16 × F16)) → Except ModelError (List (List BlockTrace))
  | _, [] => .ok []
  | initial, pairs :: rest =>
    match p.run initial.bits pairs with
    | .error e => .error e
    | .ok ts => match runGemmInstructions p (lastOutput initial ts) rest with
      | .error e => .error e
      | .ok tail => .ok (ts :: tail)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.run](../TC/Instruction.md#decl-70072ebede7f95c1), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.runGemmInstructions_eq_paper](Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.runGemmInstructions_blocks](Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runGemmInstructions_count](Defs.md#decl-f9db8f5ae7e28a9c), [TensorCore.runGemmInstructions_coverage](Defs.md#decl-ebd5f42a485ed596), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87)

</details>

</details>

<a id="decl-eb60bf287a9ae3b9"></a>

<details>
<summary><code>TensorCore.runGemmInstructions_blocks</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L70)

```lean
theorem runGemmInstructions_blocks (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (traces : List (List BlockTrace))
    (h : runGemmInstructions p initial inputs = .ok traces) :
    runBlocks p.profile initial.bits (inputs.flatMap p.schedule) = .ok traces.flatten := by
  induction inputs generalizing initial traces with
  | nil => simp [runGemmInstructions] at h; subst traces; rfl
  | cons pairs rest ih =>
    cases ht : p.run initial.bits pairs with
    | error e => simp [runGemmInstructions, ht] at h
    | ok ts =>
      cases hr : runGemmInstructions p (lastOutput initial ts) rest with
      | error e => simp [runGemmInstructions, ht, hr] at h
      | ok tail =>
        simp [runGemmInstructions, ht, hr] at h
        subst traces
        exact runBlocks_append p.profile initial _ _ _ _ (p.run_blocks _ _ _ ht) (ih _ _ hr)
```

**Supporting proofs:** [TensorCore.InstructionPath.run_blocks](../TC/Instruction.md#decl-7596119277e0d9b0), [TensorCore.runBlocks_append](../TC/Program/Loops.md#decl-2442f227fffe5cf3)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](../TC/Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-ebd5f42a485ed596"></a>

<details>
<summary><code>TensorCore.runGemmInstructions_coverage</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L87)

```lean
theorem runGemmInstructions_coverage (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (traces : List (List BlockTrace))
    (h : runGemmInstructions p initial inputs = .ok traces) :
    (inputs.flatMap p.schedule).flatten = inputs.flatten := by
  induction inputs generalizing initial traces with
  | nil => rfl
  | cons pairs rest ih =>
    cases ht : p.run initial.bits pairs with
    | error e => simp [runGemmInstructions, ht] at h
    | ok ts =>
      cases hr : runGemmInstructions p (lastOutput initial ts) rest with
      | error e => simp [runGemmInstructions, ht, hr] at h
      | ok tail =>
        simp only [List.flatMap_cons, List.flatten_append, List.flatten_cons]
        rw [p.schedule_flatten pairs (p.run_length _ _ _ ht), ih _ _ hr]
```

**Supporting proofs:** [TensorCore.InstructionPath.run_length](../TC/Instruction.md#decl-812320a0c4dc3b22), [TensorCore.InstructionPath.schedule_flatten](../TC/Instruction.md#decl-2652b6482c26797c)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](../TC/Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-f9db8f5ae7e28a9c"></a>

<details>
<summary><code>TensorCore.runGemmInstructions_count</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L103)

```lean
theorem runGemmInstructions_count (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (traces : List (List BlockTrace))
    (h : runGemmInstructions p initial inputs = .ok traces) : traces.length = inputs.length := by
  induction inputs generalizing initial traces with
  | nil => simp [runGemmInstructions] at h; subst traces; rfl
  | cons pairs rest ih =>
    cases ht : p.run initial.bits pairs with
    | error e => simp [runGemmInstructions, ht] at h
    | ok ts =>
      cases hr : runGemmInstructions p (lastOutput initial ts) rest with
      | error e => simp [runGemmInstructions, ht, hr] at h
      | ok tail =>
        simp [runGemmInstructions, ht, hr] at h
        subst traces
        simpa using ih _ _ hr
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.run](../TC/Instruction.md#decl-70072ebede7f95c1), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f)

</details>

</details>

<a id="decl-36e8239d9f1fd59e"></a>

<details>
<summary><code>TensorCore.GemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L119)

```lean
structure GemmCell where
  initial : Finite32
  instructions : List (List BlockTrace)
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Gemm.scaledCellJson](Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.scaledCellJson](Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.CutlassWmma.project_eq_gemm](Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmCell.blocks](Defs.md#decl-f9fc32c91c796407), [TensorCore.GemmCell.errorBudget](Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemmCellObservation](Specification/GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.gemmCellObservation_output](Specification/GemmEquivalence.md#decl-4e01e4b2fe2487ea), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](Specification/GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](Specification/GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](Specification/GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.tiny_outputs](Regression/ReviewClaims.md#decl-d3401f2e29412655), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.cutlass_fixture_connection](Regression/CutlassWmma.md#decl-e2a0bcb3a499b023), [TensorCore.Regression.cutlass_partial_k_differs](Regression/CutlassWmma.md#decl-dd106a85bafc0aee), [TensorCore.Regression.gemm_instruction_boundaries](Regression/Gemm.md#decl-060ec72439234e38), [TensorCore.Regression.paper_gemm_boundaries](Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmBits](Defs.md#decl-adba0115aad6bb7b), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemmTiles](Defs.md#decl-374eb9f948a3f6da), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87), [TensorCore.simulateGemmTile](Defs.md#decl-e29d83b23aa10afc), [TensorCore.Cli.Gemm.cellJson](Cli/Gemm.md#decl-5aa1c2dea45f7f03)

</details>

</details>

<a id="decl-f9fc32c91c796407"></a>

<details>
<summary><code>TensorCore.GemmCell.blocks</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L124)

```lean
def GemmCell.blocks (cell : GemmCell) : List BlockTrace := cell.instructions.flatten
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e)

<details>
<summary>Used by</summary>

[TensorCore.GemmCell.errorBudget](Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e)

</details>

</details>

<a id="decl-d8688321b8d2ae7f"></a>

<details>
<summary><code>TensorCore.GemmCell.output</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L125)

```lean
def GemmCell.output (cell : GemmCell) : Finite32 := lastOutput cell.initial cell.blocks
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.blocks](Defs.md#decl-f9fc32c91c796407), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.scaledCellJson](Cli/Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.NativePipeline.scaledCellJson](Cli/NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.PaperSpec.EpilogueContract](Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.epilogue_contract](Specification/GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemmCellObservation_output](Specification/GemmEquivalence.md#decl-4e01e4b2fe2487ea), [TensorCore.PaperSpec.scalarEpilogue_eq](Specification/ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.NativeScaled.exact_scaled](Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.tiny_outputs](Regression/ReviewClaims.md#decl-d3401f2e29412655), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.cutlass_partial_k_differs](Regression/CutlassWmma.md#decl-dd106a85bafc0aee), [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmBits](Defs.md#decl-adba0115aad6bb7b), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmEpilogue_correct](ScaledGemm.md#decl-a55a9cf36affc3d3), [TensorCore.gemmEpilogue_spec](ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.Cli.Gemm.cellJson](Cli/Gemm.md#decl-5aa1c2dea45f7f03)

</details>

</details>

<a id="decl-77bf8f0088e678b8"></a>

<details>
<summary><code>TensorCore.GemmCell.errorBudget</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L126)

```lean
def GemmCell.errorBudget (cell : GemmCell) : ℚ := sumQ (cell.blocks.map BlockTrace.errorBudget)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](../TC/Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.blocks](Defs.md#decl-f9fc32c91c796407), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.ScaledGemmCell.errorBudget](ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.Cli.Gemm.cellJson](Cli/Gemm.md#decl-5aa1c2dea45f7f03)

</details>

</details>

<a id="decl-f667f4469749d691"></a>

<details>
<summary><code>TensorCore.simulateGemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L129)

```lean
/-- K=0 performs no instructions and preserves finite C, including signed zero. -/
def simulateGemmCell (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) :
    Except ModelError GemmCell :=
  match finite32 c with
  | none => .error .nonfiniteInput
  | some initial => match runGemmInstructions model.path initial (gemmInstructions pairs) with
    | .error e => .error e
    | .ok traces => .ok ⟨initial, traces⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemm_eq_paper](Specification/GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.Regression.cutlass_partial_k_differs](Regression/CutlassWmma.md#decl-dd106a85bafc0aee), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87), [TensorCore.simulateGemmTile](Defs.md#decl-e29d83b23aa10afc)

</details>

</details>

<a id="decl-73d76a7ad6000a87"></a>

<details>
<summary><code>TensorCore.simulateGemmCell_spec</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L137)

```lean
theorem simulateGemmCell_spec (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cell : GemmCell) (h : simulateGemmCell model pairs c = .ok cell) :
    finite32 c = some cell.initial ∧
      runGemmInstructions model.path cell.initial (gemmInstructions pairs) = .ok cell.instructions := by
  cases hi : finite32 c with
  | none => simp [simulateGemmCell, hi] at h
  | some initial =>
    cases hr : runGemmInstructions model.path initial (gemmInstructions pairs) with
    | error e => simp [simulateGemmCell, hi, hr] at h
    | ok ts =>
      simp [simulateGemmCell, hi, hr] at h
      subst cell
      exact ⟨rfl, hr⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-fa30d201f6e3a65f"></a>

<details>
<summary><code>TensorCore.simulateGemmCell_count</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L151)

```lean
theorem simulateGemmCell_count (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cell : GemmCell) (h : simulateGemmCell model pairs c = .ok cell) :
    cell.instructions.length = groupCount 16 pairs.length := by
  have hc := runGemmInstructions_count _ _ _ _ (simulateGemmCell_spec _ _ _ _ h).2
  simpa [gemmInstructions, OrderedPartition.inputs, canonicalPartition_count] using hc
```

**Supporting proofs:** [TensorCore.canonicalPartition_count](../TC/Program/Partition.md#decl-1992fedc2c2443e2), [TensorCore.runGemmInstructions_count](Defs.md#decl-f9db8f5ae7e28a9c), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87)

**Definitions and types:** [TensorCore.BlockOperands](../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.canonicalPartition](../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577)

</details>

</details>

<a id="decl-d3150262da998973"></a>

<details>
<summary><code>TensorCore.gemm_ideal_profile</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L157)

```lean
private theorem gemm_ideal_profile (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    idealProducts model.path.profile pairs = idealProducts v100F16F32 pairs := by
  cases model <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-0dd9b9d7ce010319"></a>

<details>
<summary><code>TensorCore.simulateGemmCell_error</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L163)

```lean
/-- Successful simulation inherits the existing local-error composition theorem.
The reference products are decoded directly from the original unpadded input words. -/
theorem simulateGemmCell_error (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cell : GemmCell) (products : ℚ)
    (h : simulateGemmCell model pairs c = .ok cell)
    (hi : idealProducts v100F16F32 pairs = some products) :
    absQ (cell.initial.value + products - cell.output.value) ≤ cell.errorBudget := by
  have hr := (simulateGemmCell_spec _ _ _ _ h).2
  have hblocks := runGemmInstructions_blocks _ _ _ _ hr
  have hideal : idealContributions model.path.profile
      ((gemmInstructions pairs).flatMap model.path.schedule) = some products := by
    rw [idealContributions_flatten, runGemmInstructions_coverage _ _ _ _ hr,
      gemmInstructions_flatten, gemm_ideal_profile]
    change idealProducts (fp16Fp32Profile 16 0 none) (padFp16Pairs 16 pairs) = some products
    rw [idealProducts_padFp16Pairs]
    exact hi
  exact (runBlocks_uncorrected_error _ _ _ _ _ hblocks hideal).1
```

**Supporting proofs:** [TensorCore.gemmInstructions_flatten](Defs.md#decl-353da63dd578fcb7), [TensorCore.idealContributions_flatten](../TC/Program/DotProduct.md#decl-9ddff146f804b161), [TensorCore.idealProducts_padFp16Pairs](../TC/Program/Partition.md#decl-78a2a3efb15b0ed0), [TensorCore.runBlocks_uncorrected_error](../TC/Program/ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runGemmInstructions_blocks](Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_coverage](Defs.md#decl-ebd5f42a485ed596), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87), [TensorCore.gemm_ideal_profile](Defs.md#decl-d3150262da998973)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](../TC/Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.errorBudget](Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemm_entry_error](ScaledGemm.md#decl-41d7005d3d150b02)

</details>

</details>

<a id="decl-e29d83b23aa10afc"></a>

<details>
<summary><code>TensorCore.simulateGemmTile</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L181)

```lean
/-- Simulate every cell of one 16×16 output tile, including padded edge cells.
The per-cell projections share the same increasing-k WMMA instruction sequence. -/
def simulateGemmTile (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (rowTile colTile : ℕ) :
    DenseMatrix (Except ModelError GemmCell) 16 16 :=
  DenseMatrix.ofFn fun i j =>
    let row := 16 * rowTile + i.val
    let col := 16 * colTile + j.val
    simulateGemmCell model
      (List.ofFn fun l : Fin k => (A.padded 0 row l.val, B.padded 0 l.val col))
      (C.padded 0 row col)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.DenseMatrix.padded](Matrix.md#decl-95c7a9b947ecc858), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

<details>
<summary>Used by</summary>

[TensorCore.gemmTiles](Defs.md#decl-374eb9f948a3f6da), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

</details>

</details>

<a id="decl-374eb9f948a3f6da"></a>

<details>
<summary><code>TensorCore.gemmTiles</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L192)

```lean
/-- Execute each output tile once. C is loaded before the k loop; no scalar epilogue. -/
def gemmTiles (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    DenseMatrix (DenseMatrix (Except ModelError GemmCell) 16 16)
      (groupCount 16 m) (groupCount 16 n) :=
  DenseMatrix.ofFn fun i j => simulateGemmTile model A B C i.val j.val
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.simulateGemmTile](Defs.md#decl-e29d83b23aa10afc)

<details>
<summary>Used by</summary>

[TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

</details>

</details>

<a id="decl-e8122c22357e0edd"></a>

<details>
<summary><code>TensorCore.gemm_tileIndex_lt</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L198)

```lean
private theorem gemm_tileIndex_lt (i : Fin m) : i.val / 16 < groupCount 16 m := by
  have hp := padded_length 16 m (by decide)
  apply (Nat.div_lt_iff_lt_mul (by decide : 0 < 16)).2
  omega
```

**Supporting proofs:** [TensorCore.padded_length](../TC/Program/Partition.md#decl-61da2d73822bd178)

**Definitions and types:** [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.tailPadding](../TC/Program/Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

</details>

</details>

<a id="decl-9b05da03dbb16cdd"></a>

<details>
<summary><code>TensorCore.gemm</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L206)

```lean
/-- A*B+C, cropping the executed WMMA tiles back to the original output dimensions.
Each entry retains either its trace or its finite-model error. Errors cannot shift
or remove rows/columns. -/
def gemm (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Except ModelError GemmCell) m n :=
  let tiles := gemmTiles model A B C
  DenseMatrix.ofFn fun i j =>
    let tile := (tiles[i.val / 16]'(gemm_tileIndex_lt i))[j.val / 16]'(gemm_tileIndex_lt j)
    (tile[i.val % 16]'(Nat.mod_lt _ (by decide)))[j.val % 16]'(Nat.mod_lt _ (by decide))
```

**Supporting proofs:** [TensorCore.gemm_tileIndex_lt](Defs.md#decl-e8122c22357e0edd)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmTiles](Defs.md#decl-374eb9f948a3f6da), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.CutlassWmma.project_eq_gemm](Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](Specification/GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](Specification/GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](Specification/GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.scaledGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.tiny_outputs](Regression/ReviewClaims.md#decl-d3401f2e29412655), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.cutlass_fixture_connection](Regression/CutlassWmma.md#decl-e2a0bcb3a499b023), [TensorCore.Regression.gemm_instruction_boundaries](Regression/Gemm.md#decl-060ec72439234e38), [TensorCore.Regression.paper_gemm_boundaries](Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmBits](Defs.md#decl-adba0115aad6bb7b), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7)

</details>

</details>

<a id="decl-adba0115aad6bb7b"></a>

<details>
<summary><code>TensorCore.gemmBits</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L213)

```lean
def gemmBits (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Except ModelError F32) m n :=
  (gemm model A B C).map fun row => row.map fun cell => cell.map fun t => t.output.bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.Regression.gemm_architecture_rounding](Regression/Gemm.md#decl-20028f6cbef3dc31), [TensorCore.Regression.gemm_empty_k](Regression/Gemm.md#decl-0d8cc5e759e48b07), [TensorCore.Regression.gemm_nonfinite](Regression/Gemm.md#decl-f949b3d601cf0ac9), [TensorCore.Regression.gemm_rectangular](Regression/Gemm.md#decl-eede3fdd46c21165), [TensorCore.Regression.paper_gemm_empty_and_nonfinite](Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.scaled_c_placement](Regression/GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d)

</details>

</details>

<a id="decl-1f55842952d81ccc"></a>

<details>
<summary><code>TensorCore.gemmIdeal</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L218)

```lean
/-- Independently decoded mathematical target, without model execution or padding. -/
def gemmIdeal (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => do
    let c ← value32 C[i.val][j.val]
    let products ← idealProducts v100F16F32 (gemmPairs A B i j)
    return c + products
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.tiny_ideal](Regression/ReviewClaims.md#decl-e1a821af196f19ca), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9)

</details>

</details>

<a id="decl-e24588ca0d6e9549"></a>

<details>
<summary><code>TensorCore.gemm_entry</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L225)

```lean
@[simp] theorem gemm_entry (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) :
    (gemm model A B C)[i.val][j.val] =
      simulateGemmCell model (gemmPairs A B i j) C[i.val][j.val] := by
  have hi : 16 * (i.val / 16) + i.val % 16 = i.val := by omega
  have hj : 16 * (j.val / 16) + j.val % 16 = j.val := by omega
  simp [gemm, gemmTiles, simulateGemmTile, DenseMatrix.ofFn, hi, hj,
    DenseMatrix.padded, i.isLt, j.isLt, gemmPairs]
```

**Supporting proofs:** [TensorCore.gemm_tileIndex_lt](Defs.md#decl-e8122c22357e0edd)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.padded](Matrix.md#decl-95c7a9b947ecc858), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.gemmTiles](Defs.md#decl-374eb9f948a3f6da), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.simulateGemmTile](Defs.md#decl-e29d83b23aa10afc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemm_eq_paper](Specification/GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.scaledGemm_paper_contract](Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemm_entry_count](Defs.md#decl-7f36b4999e122577), [TensorCore.gemm_entry_error](Defs.md#decl-ca7357044cdac1e9), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemm_entry](ScaledGemm.md#decl-438d50a92caf24c7)

</details>

</details>

<a id="decl-7f36b4999e122577"></a>

<details>
<summary><code>TensorCore.gemm_entry_count</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L234)

```lean
theorem gemm_entry_count (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n)
    (cell : GemmCell) (h : (gemm model A B C)[i.val][j.val] = .ok cell) :
    cell.instructions.length = groupCount 16 k := by
  rw [gemm_entry] at h
  simpa using simulateGemmCell_count _ _ _ _ h
```

**Supporting proofs:** [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.simulateGemmCell_count](Defs.md#decl-fa30d201f6e3a65f)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ca7357044cdac1e9"></a>

<details>
<summary><code>TensorCore.gemm_entry_error</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L242)

```lean
/-- Entrywise matrix accuracy against A*B+C, with each exact ideal independent of execution. -/
theorem gemm_entry_error (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n)
    (cell : GemmCell) (z : ℚ) (h : (gemm model A B C)[i.val][j.val] = .ok cell)
    (hi : (gemmIdeal A B C)[i.val][j.val] = some z) :
    absQ (z - cell.output.value) ≤ cell.errorBudget := by
  rw [gemm_entry] at h
  have hc := finite32_bits (simulateGemmCell_spec _ _ _ _ h).1
  have hv : value32 C[i.val][j.val] = some cell.initial.value := by
    rw [← hc]
    simp [value32, cell.initial.valid, Finite32.value]
  simp only [gemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, hv] at hi
  cases hp : idealProducts v100F16F32 (gemmPairs A B i j) with
  | none => simp [hp] at hi
  | some products =>
    simp [hp] at hi
    rw [← hi]
    exact simulateGemmCell_error _ _ _ _ _ h hp
```

**Supporting proofs:** [TensorCore.finite32_bits](../TC/Program/Defs.md#decl-08ec57f1c290b572), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.simulateGemmCell_error](Defs.md#decl-0dd9b9d7ce010319), [TensorCore.simulateGemmCell_spec](Defs.md#decl-73d76a7ad6000a87)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.errorBudget](Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bacd4f631a1fc68b"></a>

<details>
<summary><code>TensorCore.gemmTileOperands</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L261)

```lean
/-- Logical tile loads for a 16×16×16 WMMA. Out-of-bounds operands are +0. -/
def gemmTileOperands (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (rowTile colTile kTile : ℕ) : DenseMatrix F16 16 16 × DenseMatrix F16 16 16 :=
  (DenseMatrix.ofFn fun i l => A.padded 0 (16 * rowTile + i.val) (16 * kTile + l.val),
   DenseMatrix.ofFn fun l j => B.padded 0 (16 * kTile + l.val) (16 * colTile + j.val))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.DenseMatrix.padded](Matrix.md#decl-95c7a9b947ecc858), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.gemm_tile_layout](Regression/Gemm.md#decl-6e703ef4fc6e510e)

</details>

</details>

<a id="decl-0f85cf51aeea8448"></a>

<details>
<summary><code>TensorCore.gemmTileSchedule</code></summary>

[Lean source](../../../TensorCore/Gemm/Defs.lean#L268)

```lean
/-- The chosen instruction schedule, expressed as output-tile and k-tile indices.
This counts planned whole warp instructions, not per-cell scalar projections. -/
def gemmTileSchedule (m n k : ℕ) : List (ℕ × ℕ × ℕ) :=
  (List.range (groupCount 16 m)).flatMap fun i =>
    (List.range (groupCount 16 n)).flatMap fun j =>
      (List.range (groupCount 16 k)).map fun l => (i, j, l)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Regression.gemm_tile_layout](Regression/Gemm.md#decl-6e703ef4fc6e510e)

</details>

</details>
