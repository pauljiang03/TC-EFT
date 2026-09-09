# TensorCore.TC.Program.GroupAnalysis

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f08d46262601f09c"></a>

<details>
<summary><code>TensorCore.GroupWitness</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L7)

```lean
structure GroupWitness where
  scale : ℤ
  outputScale : ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CellAnalysis](../../Gemm/Analysis.md#decl-440d2015df04ff83), [TensorCore.Cli.Analysis.cellJson](../../Gemm/Cli/Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.Analysis.report](../../Gemm/Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.Analysis.witnessJson](../../Gemm/Cli/Analysis.md#decl-4b44e07e32d5394e), [TensorCore.Cli.ExtendedAnalysis.nativeReport](../../Gemm/Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.NativePipeline.report](../../Gemm/Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](../../Gemm/Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.PipelineAnalysis.scaledWitnessJson](../../Gemm/Cli/PipelineAnalysis.md#decl-a1f4cd43d75b82d6), [TensorCore.GemmProblem.Witness](../../Gemm/Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.infer](../../Gemm/Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.ReviewClaims.native_accuracy](../../Gemm/Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](../../Gemm/Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.analysis_witness_rejects_mutations](../../Gemm/Regression/GemmAnalysis.md#decl-18dc193709d671fa), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](../../Gemm/Regression/PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.sourceWitness](../../Gemm/Regression/PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.Regression.tinyWitness](../../Gemm/Regression/GemmAnalysis.md#decl-d68e82c966d519d3), [TensorCore.ScaledWitness](../../Gemm/ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.analyzeGemmCell](../../Gemm/Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](../../Gemm/Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell](../../Gemm/NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](../../Gemm/NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.checkGemmCell](../../Gemm/Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups](GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell](../../Gemm/NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.gemmAnalysisCheck](../../Gemm/Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_matrix_error](../../Gemm/Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](../../Gemm/Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](../../Gemm/Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupBound_le_static](GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.groupWitnessCheck](GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.inferGroup_checked](GroupAnalysis.md#decl-eff90d687eba7bb6), [TensorCore.inferGroups](GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.nativeAnalysisCheck](../../Gemm/NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](../../Gemm/NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-b8d00c6cb811c77e"></a>

<details>
<summary><code>TensorCore.AnalysisBound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L12)

```lean
structure AnalysisBound where
  magnitude : ℚ
  alignment : ℚ
  rounding : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.AnalysisBound.error](GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../../Gemm/Analysis.md#decl-440d2015df04ff83), [TensorCore.Cli.Analysis.cellJson](../../Gemm/Cli/Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Regression.analysis_witness_rejects_mutations](../../Gemm/Regression/GemmAnalysis.md#decl-18dc193709d671fa), [TensorCore.analyzeGemmCell](../../Gemm/Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](../../Gemm/Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeGemm_entry_sound](../../Gemm/Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](../../Gemm/Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeCell](../../Gemm/NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](../../Gemm/NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeGemm_entry_sound](../../Gemm/NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](../../Gemm/NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.checkEpilogue](../../Gemm/ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](../../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkGemmCell](../../Gemm/Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups](GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell](../../Gemm/NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell](../../Gemm/NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](../../Gemm/NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](../../Gemm/NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell](../../Gemm/ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_inputConversion](../../Gemm/ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](../../Gemm/ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.gemmAnalysisCheck](../../Gemm/Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_sound](../../Gemm/Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupBound_le_static](GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.inferEpilogue](../../Gemm/ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroup_checked](GroupAnalysis.md#decl-eff90d687eba7bb6), [TensorCore.inferGroups](GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.nativeAnalysisCheck](../../Gemm/NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](../../Gemm/NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-51f6228293fd16fa"></a>

<details>
<summary><code>TensorCore.AnalysisBound.error</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L18)

```lean
def AnalysisBound.error (b : AnalysisBound) : ℚ := b.alignment + b.rounding
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.cellJson](../../Gemm/Cli/Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.Analysis.report](../../Gemm/Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.nativeReport](../../Gemm/Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Regression.analysis_improves_existing_certificate](../../Gemm/Regression/GemmAnalysis.md#decl-a1392f6a35ba7d56), [TensorCore.Regression.analysis_improves_minimal_static](../../Gemm/Regression/GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_signed_zero_and_empty](../../Gemm/Regression/GemmAnalysis.md#decl-4f1d63703ef328c3), [TensorCore.Regression.analysis_tiny_bounds](../../Gemm/Regression/GemmAnalysis.md#decl-613947919eca8929), [TensorCore.analysisEntryBounds](../../Gemm/Analysis.md#decl-d1b4af0b27a0d0ba), [TensorCore.analyzeGemm_entry_sound](../../Gemm/Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](../../Gemm/Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeGemm_entry_sound](../../Gemm/NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](../../Gemm/NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.checkEpilogue_sound](../../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell_sound](../../Gemm/NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](../../Gemm/ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.gemmAnalysisCheck](../../Gemm/Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_sound](../../Gemm/Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.groupBound_le_static](GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_nonneg](GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.nativeAnalysisCheck](../../Gemm/NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeAnalysisCheck_sound](../../Gemm/NativeGemm.md#decl-f6bddcc98d97f99f)

</details>

</details>

<a id="decl-be16bcf976708cd5"></a>

<details>
<summary><code>TensorCore.productMass</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L20)

```lean
def productMass (qs : List (Decoded × Decoded)) : ℚ :=
  sumQ (qs.map fun ab => absQ (rawMul ab.1 ab.2).value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.RawProduct.value](../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupBound_le_static](GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.groupWitnessCheck](GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.productMass_nonneg](GroupAnalysis.md#decl-b18fa7d0371588fa), [TensorCore.scheduleMass](GroupAnalysis.md#decl-dbedd44c59d564b7), [TensorCore.scheduleMass_nonneg](GroupAnalysis.md#decl-24557ed008ff6b12)

</details>

</details>

<a id="decl-e75a1094a7fa65e5"></a>

<details>
<summary><code>TensorCore.groupBound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L23)

```lean
def groupBound (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : AnalysisBound :=
  let M := C + productMass qs
  if M = 0 then ⟨0, 0, 0⟩ else
    ⟨M, (if C = 0 then 0 else pow2 (w.scale - p.alignFraction)) +
      sumQ (qs.map fun ab => rawAlignmentBudget (rawMul ab.1 ab.2) (w.scale - p.alignFraction)),
      pow2 (w.outputScale - 23)⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawAlignmentBudget](Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.groupBound_le_static](GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-87ee478b88995006"></a>

<details>
<summary><code>TensorCore.groupWitnessCheck</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L31)

```lean
def groupWitnessCheck (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : Bool :=
  decide (qs.length = p.products ∧ 0 ≤ C ∧ -126 ≤ w.scale ∧ -126 ≤ w.outputScale ∧
    (∀ f ∈ p.alignFloor, f ≤ w.scale) ∧ C < pow2 (w.scale + 1) ∧
    C + productMass qs ≤ maxFinite32 ∧ C + productMass qs < pow2 (w.outputScale + 1)) &&
  qs.all (fun ab => (rawMul ab.1 ab.2).significand == 0 ||
    decide ((rawMul ab.1 ab.2).rawScale ≤ w.scale))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

<details>
<summary>Used by</summary>

[TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-f516efc40ceb5b24"></a>

<details>
<summary><code>TensorCore.checkGroup</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L39)

```lean
def checkGroup (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ)
    (w : GroupWitness) : Option AnalysisBound := do
  let qs ← prepareProducts p g
  if groupWitnessCheck p qs C w then some (groupBound p qs C w) else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupWitnessCheck](GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2)

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups](GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroup_checked](GroupAnalysis.md#decl-eff90d687eba7bb6), [TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-b18fa7d0371588fa"></a>

<details>
<summary><code>TensorCore.productMass_nonneg</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L44)

```lean
theorem productMass_nonneg (qs : List (Decoded × Decoded)) : 0 ≤ productMass qs := by
  have h := sumQ_map_mono qs (fun _ => 0) (fun ab => absQ (rawMul ab.1 ab.2).value)
    (fun _ _ => absQ_nonneg _)
  simpa only [sumQ_map_zero, productMass] using h
```

**Supporting proofs:** [TensorCore.absQ_nonneg](../../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.sumQ_map_mono](Bounds/Local.md#decl-880c80c3d3f6df2b), [TensorCore.sumQ_map_zero](../../Core/Sum.md#decl-181b288c0a867eb6)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.RawProduct.value](../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.scheduleMass_nonneg](GroupAnalysis.md#decl-24557ed008ff6b12)

</details>

</details>

<a id="decl-8181aa98ef2aa6c9"></a>

<details>
<summary><code>TensorCore.groupBound_magnitude</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L49)

```lean
theorem groupBound_magnitude (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : (groupBound p qs C w).magnitude = C + productMass qs := by
  unfold groupBound
  dsimp only
  split <;> simp_all
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawAlignmentBudget](Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-b48fb2a8c56e4563"></a>

<details>
<summary><code>TensorCore.groupBound_nonneg</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L55)

```lean
theorem groupBound_nonneg (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : 0 ≤ (groupBound p qs C w).error := by
  unfold groupBound
  dsimp only
  split
  · change (0 : ℚ) ≤ 0 + 0
    decide +kernel
  · have hp := pow2_pos (w.scale - p.alignFraction)
    have hr := pow2_pos (w.outputScale - 23)
    have hs := sumQ_map_mono qs (fun _ => 0)
      (fun ab => rawAlignmentBudget (rawMul ab.1 ab.2) (w.scale - p.alignFraction))
      (fun _ _ => rawAlignmentBudget_nonneg _ _)
    rw [sumQ_map_zero] at hs
    change 0 ≤ ((if C = 0 then 0 else pow2 _) + _) + pow2 _
    split <;> grind
```

**Supporting proofs:** [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120), [TensorCore.rawAlignmentBudget_nonneg](Bounds/Local.md#decl-30f7e6c784a8caa3), [TensorCore.sumQ_map_mono](Bounds/Local.md#decl-880c80c3d3f6df2b), [TensorCore.sumQ_map_zero](../../Core/Sum.md#decl-181b288c0a867eb6)

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawAlignmentBudget](Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0eb9c5d6e9fead1f"></a>

<details>
<summary><code>TensorCore.checkGroup_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L71)

```lean
theorem checkGroup_sound (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ)
    (w : GroupWitness) (b : AnalysisBound) (h : checkGroup p g C w = some b)
    (c : Finite32) (hc : absQ c.value ≤ C) :
    ∃ t, evalBlock (⟨g, c.bits⟩ : BlockInput p) = .ok t ∧
      idealProducts p g = some t.block.exactProducts ∧
      t.block.exactDot = c.value + t.block.exactProducts ∧
      absQ t.output.value ≤ b.magnitude ∧ absQ (t.block.exactDot - t.output.value) ≤ b.error := by
  cases hqs : prepareProducts p g with
  | none => simp [checkGroup, hqs] at h
  | some qs =>
    simp only [checkGroup, hqs, bind, Option.bind_some] at h
    split at h
    next hw =>
      cases Option.some.inj h
      simp only [groupWitnessCheck, Bool.and_eq_true, decide_eq_true_eq] at hw
      obtain ⟨⟨hshape, hC, hE, hR, hfl, hcm, hrange, houtscale⟩, hscales⟩ := hw
      have hp := prepare_of_decodes g c qs hqs
      have hlength := (prepareProducts_bounds p g qs hqs).1
      have hs : ScaleBounded (PreparedBlock.mk p qs c.decoded).terms w.scale := by
        intro t ht
        simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
        rcases ht with rfl | ⟨ab, hab, rfl⟩
        · exact finite32_scale_le c w.scale hE (by grind)
        · have ha := List.all_eq_true.mp hscales ab hab
          simp only [Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at ha
          intro hnz
          exact ha.resolve_left hnz
      have hm : sumQ ((PreparedBlock.mk p qs c.decoded).terms.map fun t => absQ t.value) ≤
          C + productMass qs := by
        simpa only [PreparedBlock.terms, List.map_cons, List.map_map, Function.comp_def,
          sumQ, productMass, RawProduct.value, Finite32.value, Decoded.value] using
          (Rat.add_le_add_right.mpr hc : absQ c.value + productMass qs ≤ C + productMass qs)
      have hacc := Rat.le_trans (accumulator_abs_le_mass ⟨p, qs, c.decoded⟩) hm
      obtain ⟨t, ht⟩ := (evalBlock_success_iff p ⟨g, c.bits⟩).mpr
        ⟨hlength.symm.trans hshape, _, hp, Rat.le_trans hacc hrange⟩
      have hblock : t.block = ⟨p, qs, c.decoded⟩ := by
        have hh := evalBlock_prepared ht
        rw [hp] at hh
        exact (Option.some.inj hh).symm
      have ho := evalPrepared_output (evalBlock_evalPrepared ht)
      have hmout := round32_rtz_abs_le t.block.accumulator t.output ho
      rw [hblock] at ho hmout
      have hmfinal := Rat.le_trans hmout hacc
      refine ⟨t, ht, ?_, ?_, ?_, ?_⟩
      · rw [hblock]
        exact idealProducts_of_prepareProducts p g qs hqs
      · rw [hblock]; rfl
      · rw [groupBound_magnitude]
        exact hmfinal
      · by_cases hz : C + productMass qs = 0
        · have hid : absQ t.block.exactDot ≤ C + productMass qs := by
            have hh := absQ_sumQ_le (t.block.terms.map RawProduct.value)
            rw [List.map_map] at hh
            rw [terms_value] at hh
            rw [hblock] at hh ⊢
            exact Rat.le_trans hh hm
          have ha := absQ_add_le t.block.exactDot (-t.output.value)
          rw [absQ_neg] at ha
          have hsub : t.block.exactDot - t.output.value = t.block.exactDot + -t.output.value := by grind
          rw [hsub]
          simp only [groupBound, hz, ↓reduceIte, AnalysisBound.error]
          rw [hz] at hid hmfinal
          grind
        · have he := block_local_error ⟨p, qs, c.decoded⟩ t.output w.scale w.outputScale
            hs hfl hR (by grind) ho
          have hb := rawAlignmentBudget_le
            ⟨c.decoded.significand, c.decoded.rawScale, c.decoded.fractionalBits⟩
            (w.scale - p.alignFraction)
          have hcb : rawAlignmentBudget
              ⟨c.decoded.significand, c.decoded.rawScale, c.decoded.fractionalBits⟩
              (w.scale - p.alignFraction) ≤ (if C = 0 then 0 else pow2 (w.scale - p.alignFraction)) := by
            split
            next hzero =>
              have hv : c.value = 0 := by
                have hh := (absQ_le_iff c.value C).mp hc
                rw [hzero] at hh
                grind
              rw [rawAlignmentBudget_zero _ _ (by
                simpa only [RawProduct.value, Finite32.value, Decoded.value] using hv)]
              exact Rat.le_refl
            next _ => exact hb
          rw [hblock]
          simp only [groupBound, hz, ↓reduceIte, AnalysisBound.error]
          simp only [PreparedBlock.terms, List.map_cons, List.map_map, Function.comp_def, sumQ] at he
          grind
    next hn => simp at h
```

**Supporting proofs:** [TensorCore.absQ_add_le](../../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_le_iff](../../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_neg](../../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_sumQ_le](../../Core/Sum.md#decl-9728c1755d91fb0d), [TensorCore.accumulator_abs_le_mass](Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.block_local_error](Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.evalBlock_evalPrepared](../StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_prepared](../StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_success_iff](../AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared_output](../ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.finite32_scale_le](../StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.groupBound_magnitude](GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.idealProducts_of_prepareProducts](../StaticBudget.md#decl-46af87ad95b9feb9), [TensorCore.prepareProducts_bounds](../AlignmentScale.md#decl-24fca5acfef90681), [TensorCore.prepare_of_decodes](../StaticBudget.md#decl-db4a0851b6327dd2), [TensorCore.rawAlignmentBudget_le](Bounds/Local.md#decl-7c8beacba137af93), [TensorCore.rawAlignmentBudget_zero](Bounds/Local.md#decl-16ff676e03bc4bb1), [TensorCore.round32_rtz_abs_le](Bounds/Local.md#decl-b5d2bbed636879a7), [TensorCore.terms_value](../StageResiduals.md#decl-7b530e0eb36f1f90)

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](../../Core/Defs.md#decl-716025aa0e922bfd), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](../Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.ScaleBounded](../StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupWitnessCheck](GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](../Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawAlignmentBudget](Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a)

</details>

</details>

<a id="decl-f9bf1f8eba9679a8"></a>

<details>
<summary><code>TensorCore.magnitudeScale</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L158)

```lean
def magnitudeScale (C : ℚ) : ℤ :=
  if C = 0 then -126 else max (-126) (magnitudeExponent C)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.magnitudeExponent](../../Core/RoundOp.md#decl-d0b00fe98f5e4d15)

<details>
<summary>Used by</summary>

[TensorCore.familyOperandScale](../../Gemm/Family.md#decl-c5db35b2aa0f8491), [TensorCore.familyOperandScale_spec](../../Gemm/Family.md#decl-82f743426dfee31b), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.magnitudeScale_spec](GroupAnalysis.md#decl-d51d916c1a50ab6d)

</details>

</details>

<a id="decl-d51d916c1a50ab6d"></a>

<details>
<summary><code>TensorCore.magnitudeScale_spec</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L161)

```lean
theorem magnitudeScale_spec (C : ℚ) (hC : 0 ≤ C) :
    -126 ≤ magnitudeScale C ∧ C < pow2 (magnitudeScale C + 1) := by
  by_cases hz : C = 0
  · simp only [magnitudeScale, hz, ↓reduceIte]
    exact ⟨Int.le_refl _, pow2_pos _⟩
  · have hm := (magnitudeExponent_spec C (show 0 < C by grind)).2
    have he : magnitudeExponent C ≤ max (-126) (magnitudeExponent C) := by omega
    have hp := pow2_le_of_le (show magnitudeExponent C + 1 ≤ max (-126) (magnitudeExponent C) + 1 by omega)
    simp only [magnitudeScale, hz, ↓reduceIte]
    constructor
    · omega
    · grind
```

**Supporting proofs:** [TensorCore.magnitudeExponent_spec](../../Core/Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_le_of_le](../../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.magnitudeExponent](../../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.magnitudeScale](GroupAnalysis.md#decl-f9bf1f8eba9679a8), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyOperandScale_spec](../../Gemm/Family.md#decl-82f743426dfee31b), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22)

</details>

</details>

<a id="decl-39e2f59507cea645"></a>

<details>
<summary><code>TensorCore.productScaleBound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L174)

```lean
def productScaleBound (qs : List (Decoded × Decoded)) (E : ℤ) : ℤ :=
  qs.foldl (fun e ab => if (rawMul ab.1 ab.2).significand = 0 then e
    else max e (rawMul ab.1 ab.2).rawScale) E
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

<details>
<summary>Used by</summary>

[TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.productScaleBound_spec](GroupAnalysis.md#decl-f9a6f232f2424ce7)

</details>

</details>

<a id="decl-f9a6f232f2424ce7"></a>

<details>
<summary><code>TensorCore.productScaleBound_spec</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L178)

```lean
theorem productScaleBound_spec (qs : List (Decoded × Decoded)) (E : ℤ) :
    E ≤ productScaleBound qs E ∧
      ∀ ab ∈ qs, (rawMul ab.1 ab.2).significand ≠ 0 →
        (rawMul ab.1 ab.2).rawScale ≤ productScaleBound qs E := by
  induction qs generalizing E with
  | nil => exact ⟨Int.le_refl _, by simp⟩
  | cons ab qs ih =>
    simp only [productScaleBound, List.foldl_cons]
    split
    next hz =>
      obtain ⟨he, hs⟩ := ih E
      refine ⟨he, ?_⟩
      intro x hx hn
      rcases List.mem_cons.mp hx with rfl | hx
      · exact absurd hz hn
      · exact hs x hx hn
    next hn =>
      obtain ⟨he, hs⟩ := ih (max E (rawMul ab.1 ab.2).rawScale)
      simp only [productScaleBound] at he hs
      refine ⟨by omega, ?_⟩
      intro x hx hne
      rcases List.mem_cons.mp hx with rfl | hx
      · omega
      · exact hs x hx hne
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.productScaleBound](GroupAnalysis.md#decl-39e2f59507cea645), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22)

</details>

</details>

<a id="decl-5b1579771ad89c77"></a>

<details>
<summary><code>TensorCore.inferGroupWitness</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L203)

```lean
def inferGroupWitness (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ) : GroupWitness :=
  let E := productScaleBound qs (max (magnitudeScale C) (p.alignFloor.getD (-126)))
  ⟨E, magnitudeScale (C + productMass qs)⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.magnitudeScale](GroupAnalysis.md#decl-f9bf1f8eba9679a8), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.productScaleBound](GroupAnalysis.md#decl-39e2f59507cea645)

<details>
<summary>Used by</summary>

[TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.inferGroup_checked](GroupAnalysis.md#decl-eff90d687eba7bb6), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-d38055dcae5dab22"></a>

<details>
<summary><code>TensorCore.inferGroupWitness_valid</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L207)

```lean
theorem inferGroupWitness_valid (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (hshape : qs.length = p.products) (hC : 0 ≤ C) (hr : C + productMass qs ≤ maxFinite32) :
    groupWitnessCheck p qs C (inferGroupWitness p qs C) = true := by
  obtain ⟨hc1, hc2⟩ := magnitudeScale_spec C hC
  have hM : 0 ≤ C + productMass qs := by have := productMass_nonneg qs; grind
  obtain ⟨hr1, hr2⟩ := magnitudeScale_spec (C + productMass qs) hM
  obtain ⟨hE, hs⟩ := productScaleBound_spec qs (max (magnitudeScale C) (p.alignFloor.getD (-126)))
  have hpow := pow2_le_of_le (show magnitudeScale C + 1 ≤
    productScaleBound qs (max (magnitudeScale C) (p.alignFloor.getD (-126))) + 1 by omega)
  dsimp only [groupWitnessCheck, inferGroupWitness]
  rw [Bool.and_eq_true, decide_eq_true_eq]
  refine ⟨⟨hshape, hC, by omega, hr1, ?_, by grind, hr, hr2⟩, ?_⟩
  · intro f hf
    cases hp : p.alignFloor with
    | none => simp [hp] at hf
    | some a =>
      simp only [hp, Option.mem_def, Option.some.injEq] at hf
      simp only [hp, Option.getD_some] at hE
      simp only [Option.getD_some]
      omega
  · apply List.all_eq_true.mpr
    intro ab hab
    simp only [Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq]
    by_cases hz : (rawMul ab.1 ab.2).significand = 0
    · exact Or.inl hz
    · exact Or.inr (hs ab hab hz)
```

**Supporting proofs:** [TensorCore.magnitudeScale_spec](GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.pow2_le_of_le](../../Core/Exact.md#decl-064be6edf8651285), [TensorCore.productMass_nonneg](GroupAnalysis.md#decl-b18fa7d0371588fa), [TensorCore.productScaleBound_spec](GroupAnalysis.md#decl-f9a6f232f2424ce7)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.groupWitnessCheck](GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.magnitudeScale](GroupAnalysis.md#decl-f9bf1f8eba9679a8), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.productScaleBound](GroupAnalysis.md#decl-39e2f59507cea645), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-75221a1d1f770b6a"></a>

<details>
<summary><code>TensorCore.inferGroup</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L234)

```lean
def inferGroup (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ) :
    Option (GroupWitness × AnalysisBound) := do
  let qs ← prepareProducts p g
  let w := inferGroupWitness p qs C
  let b ← checkGroup p g C w
  return (w, b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2)

<details>
<summary>Used by</summary>

[TensorCore.inferGroup_checked](GroupAnalysis.md#decl-eff90d687eba7bb6), [TensorCore.inferGroups](GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-eff90d687eba7bb6"></a>

<details>
<summary><code>TensorCore.inferGroup_checked</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L241)

```lean
theorem inferGroup_checked (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ)
    (w : GroupWitness) (b : AnalysisBound) (h : inferGroup p g C = some (w, b)) :
    checkGroup p g C w = some b := by
  simp only [inferGroup, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨qs, _, bound, hb, he⟩ := h
  cases he
  exact hb
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34)

</details>

</details>

<a id="decl-3ceec23d37a63df0"></a>

<details>
<summary><code>TensorCore.checkGroups</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L249)

```lean
def checkGroups (p : Profile) : List (List (p.Word × p.Word)) → ℚ → List GroupWitness →
    Option AnalysisBound
  | [], C, [] => some ⟨C, 0, 0⟩
  | g :: gs, C, w :: ws => do
    let b ← checkGroup p g C w
    let rest ← checkGroups p gs b.magnitude ws
    return ⟨rest.magnitude, b.alignment + rest.alignment, b.rounding + rest.rounding⟩
  | _, _, _ => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24)

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.checkGemmCell](../../Gemm/Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell](../../Gemm/NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34)

</details>

</details>

<a id="decl-1b68b353164cb06a"></a>

<details>
<summary><code>TensorCore.checkGroups_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L258)

```lean
theorem checkGroups_sound (p : Profile) (gs : List (List (p.Word × p.Word))) (C : ℚ)
    (ws : List GroupWitness) (b : AnalysisBound) (h : checkGroups p gs C ws = some b)
    (c : Finite32) (hc : absQ c.value ≤ C) :
    ∃ ts products, runBlocks p c.bits gs = .ok ts ∧ idealContributions p gs = some products ∧
      absQ (lastOutput c ts).value ≤ b.magnitude ∧
      absQ (c.value + products - (lastOutput c ts).value) ≤ b.error := by
  induction gs generalizing C ws b c with
  | nil =>
    cases ws with
    | nil =>
      cases Option.some.inj h
      refine ⟨[], 0, rfl, rfl, hc, ?_⟩
      change absQ (c.value + 0 - c.value) ≤ 0 + 0
      rw [Rat.add_zero, Rat.sub_self]
      decide +kernel
    | cons _ _ => simp [checkGroups] at h
  | cons g gs ih =>
    cases ws with
    | nil => simp [checkGroups] at h
    | cons w ws =>
      simp only [checkGroups, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
      obtain ⟨step, hs, tail, ht, he⟩ := h
      cases he
      obtain ⟨t, hr, hp, hd, hm, herr⟩ := checkGroup_sound p g C w step hs c hc
      obtain ⟨ts, products, hrun, hi, hmag, herror⟩ := ih step.magnitude ws tail ht t.output hm
      refine ⟨t :: ts, t.block.exactProducts + products, ?_, ?_, hmag, ?_⟩
      · simp only [runBlocks, hr, hrun]
      · exact idealContributions_cons p g gs _ _ hp hi
      · have ha := absQ_add_le (c.value + t.block.exactProducts - t.output.value)
          (t.output.value + products - (lastOutput t.output ts).value)
        have heq : c.value + t.block.exactProducts - t.output.value +
            (t.output.value + products - (lastOutput t.output ts).value) =
            c.value + (t.block.exactProducts + products) - (lastOutput t.output ts).value := by grind
        rw [heq] at ha
        rw [hd] at herr
        simp only [lastOutput, AnalysisBound.error] at *
        grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.idealContributions_cons](../StaticBudget.md#decl-0916105e5f507bb2)

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactDot](../Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.checkGroups](GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40)

</details>

</details>

<a id="decl-44e47055c844c9f4"></a>

<details>
<summary><code>TensorCore.inferGroups</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L296)

```lean
def inferGroups (p : Profile) : List (List (p.Word × p.Word)) → ℚ → Option (List GroupWitness)
  | [], _ => some []
  | g :: gs, C => do
    let (w, b) ← inferGroup p g C
    let rest ← inferGroups p gs b.magnitude
    return w :: rest
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a)

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell](../../Gemm/Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](../../Gemm/Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell](../../Gemm/NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](../../Gemm/NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.inferGroups_checked](GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-8253aaa6e78b0c34"></a>

<details>
<summary><code>TensorCore.inferGroups_checked</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L303)

```lean
theorem inferGroups_checked (p : Profile) (gs : List (List (p.Word × p.Word))) (C : ℚ)
    (ws : List GroupWitness) (h : inferGroups p gs C = some ws) :
    ∃ b, checkGroups p gs C ws = some b := by
  induction gs generalizing C ws with
  | nil =>
    cases Option.some.inj h
    exact ⟨⟨C, 0, 0⟩, rfl⟩
  | cons g gs ih =>
    simp only [inferGroups, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
    obtain ⟨⟨w, b⟩, hg, rest, hr, rfl⟩ := h
    obtain ⟨tail, ht⟩ := ih b.magnitude rest hr
    refine ⟨⟨tail.magnitude, b.alignment + tail.alignment, b.rounding + tail.rounding⟩, ?_⟩
    simp [checkGroups, inferGroup_checked p g C w b hg, ht]
```

**Supporting proofs:** [TensorCore.inferGroup_checked](GroupAnalysis.md#decl-eff90d687eba7bb6)

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.checkGroups](GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroups](GroupAnalysis.md#decl-44e47055c844c9f4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50)

</details>

</details>

<a id="decl-dbedd44c59d564b7"></a>

<details>
<summary><code>TensorCore.scheduleMass</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L317)

```lean
def scheduleMass (p : Profile) : List (List (p.Word × p.Word)) → Option ℚ
  | [] => some 0
  | g :: gs => do
    let qs ← prepareProducts p g
    let rest ← scheduleMass p gs
    return productMass qs + rest
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5)

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.scheduleMass_nonneg](GroupAnalysis.md#decl-24557ed008ff6b12)

</details>

</details>

<a id="decl-24557ed008ff6b12"></a>

<details>
<summary><code>TensorCore.scheduleMass_nonneg</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L324)

```lean
theorem scheduleMass_nonneg (p : Profile) (gs : List (List (p.Word × p.Word)))
    (M : ℚ) (h : scheduleMass p gs = some M) : 0 ≤ M := by
  induction gs generalizing M with
  | nil => cases Option.some.inj h; exact Rat.le_refl
  | cons g gs ih =>
    simp only [scheduleMass, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
    obtain ⟨qs, _, rest, hr, rfl⟩ := h
    have := ih rest hr
    have := productMass_nonneg qs
    grind
```

**Supporting proofs:** [TensorCore.productMass_nonneg](GroupAnalysis.md#decl-b18fa7d0371588fa)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.scheduleMass](GroupAnalysis.md#decl-dbedd44c59d564b7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.inferGroups_complete](GroupAnalysis.md#decl-f38baddc12606950)

</details>

</details>

<a id="decl-f38baddc12606950"></a>

<details>
<summary><code>TensorCore.inferGroups_complete</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L336)

```lean
/-- Inference succeeds throughout the finite domain certified by the unsigned input mass. -/
theorem inferGroups_complete (p : Profile) (gs : List (List (p.Word × p.Word))) (C M : ℚ)
    (hshape : ∀ g ∈ gs, g.length = p.products) (hC : 0 ≤ C)
    (hm : scheduleMass p gs = some M) (hr : C + M ≤ maxFinite32) :
    ∃ ws, inferGroups p gs C = some ws := by
  induction gs generalizing C M with
  | nil => exact ⟨[], rfl⟩
  | cons g gs ih =>
    simp only [scheduleMass, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hm
    obtain ⟨qs, hqs, rest, hrest, rfl⟩ := hm
    have hn := scheduleMass_nonneg p gs rest hrest
    have hpos := productMass_nonneg qs
    have hw := inferGroupWitness_valid p qs C
      ((prepareProducts_bounds p g qs hqs).1.trans (hshape g (by simp))) hC (by grind)
    let w := inferGroupWitness p qs C
    let b := groupBound p qs C w
    have hg : inferGroup p g C = some (w, b) := by simp [inferGroup, checkGroup, hqs, hw, w, b]
    obtain ⟨ws, hws⟩ := ih (C + productMass qs) rest
      (fun q hq => hshape q (by simp [hq])) (by grind) hrest (by grind)
    refine ⟨w :: ws, ?_⟩
    have hmag : b.magnitude = C + productMass qs := groupBound_magnitude p qs C w
    simp [inferGroups, hg, hmag, hws]
```

**Supporting proofs:** [TensorCore.groupBound_magnitude](GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.inferGroupWitness_valid](GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.prepareProducts_bounds](../AlignmentScale.md#decl-24fca5acfef90681), [TensorCore.productMass_nonneg](GroupAnalysis.md#decl-b18fa7d0371588fa), [TensorCore.scheduleMass_nonneg](GroupAnalysis.md#decl-24557ed008ff6b12)

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](../../Core/Defs.md#decl-716025aa0e922bfd), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.checkGroup](GroupAnalysis.md#decl-f516efc40ceb5b24), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupWitnessCheck](GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.inferGroup](GroupAnalysis.md#decl-75221a1d1f770b6a), [TensorCore.inferGroupWitness](GroupAnalysis.md#decl-5b1579771ad89c77), [TensorCore.inferGroups](GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.scheduleMass](GroupAnalysis.md#decl-dbedd44c59d564b7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell_complete](../../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell_complete](../../Gemm/NativeGemm.md#decl-6fb9db9d725eff50)

</details>

</details>

<a id="decl-dfb61f21eab0646b"></a>

<details>
<summary><code>TensorCore.groupBound_le_static</code></summary>

[Lean source](../../../../TensorCore/TC/Program/GroupAnalysis.lean#L358)

```lean
theorem groupBound_le_static (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) (E : ℤ) (L : ℕ) (hshape : qs.length = p.products)
    (hE : w.scale ≤ E) (hR : w.outputScale ≤ max (E + 1 + L) (-126)) :
    (groupBound p qs C w).error ≤ staticBudget (p.products + 1) p.alignFraction E L := by
  have hq := pow2_le_of_le (show w.scale - p.alignFraction ≤ E - p.alignFraction by omega)
  have hr := pow2_le_of_le (show w.outputScale - 23 ≤ max (E + 1 + L) (-126) - 23 by omega)
  have hs := sumQ_map_le qs
    (fun ab => rawAlignmentBudget (rawMul ab.1 ab.2) (w.scale - p.alignFraction))
    (pow2 (E - p.alignFraction)) (fun ab _ => Rat.le_trans (rawAlignmentBudget_le _ _) hq)
  rw [hshape] at hs
  have hn : (0 : ℚ) ≤ p.products := Rat.natCast_nonneg
  have hp := pow2_pos (E - p.alignFraction)
  have hprod := Rat.mul_nonneg hn (Rat.le_of_lt hp)
  have hout := pow2_pos (max (E + 1 + L) (-126) - 23)
  unfold groupBound
  dsimp only
  split
  · simp only [AnalysisBound.error, staticBudget, Rat.natCast_add]
    change 0 + 0 ≤ ((p.products : ℚ) + 1) * pow2 _ + pow2 _
    grind
  · simp only [AnalysisBound.error, staticBudget, Rat.natCast_add]
    change (if C = 0 then 0 else pow2 _) + _ + pow2 _ ≤
      ((p.products : ℚ) + 1) * pow2 _ + pow2 _
    split <;> grind
```

**Supporting proofs:** [TensorCore.pow2_le_of_le](../../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120), [TensorCore.rawAlignmentBudget_le](Bounds/Local.md#decl-7c8beacba137af93), [TensorCore.sumQ_map_le](../../Core/Sum.md#decl-02931053452cdfec)

**Definitions and types:** [TensorCore.AnalysisBound](GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupWitness](GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.groupBound](GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.productMass](GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.rawAlignmentBudget](Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
