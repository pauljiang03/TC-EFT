# TensorCore.Gemm.ScaledGemmAnalysis

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3e3379db8d7cd6f8"></a>

<details>
<summary><code>TensorCore.EpilogueWitness</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L8)

```lean
structure EpilogueWitness where
  alphaScale : ℤ
  betaScale : ℤ
  sumScale : ℤ
  outputScale : ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.PipelineAnalysis.scaledWitnessJson](Cli/PipelineAnalysis.md#decl-a1f4cd43d75b82d6), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](Regression/PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.sourceWitness](Regression/PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572)

</details>

</details>

<a id="decl-689b6d14860c84bb"></a>

<details>
<summary><code>TensorCore.ScaledWitness</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L15)

```lean
structure ScaledWitness where
  groups : List GroupWitness
  epilogue : EpilogueWitness
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.PipelineAnalysis.scaledWitnessJson](Cli/PipelineAnalysis.md#decl-a1f4cd43d75b82d6), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](Regression/PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.sourceWitness](Regression/PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-6cb812882dfa62f2"></a>

<details>
<summary><code>TensorCore.PipelineBound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L20)

```lean
structure PipelineBound where
  magnitude : ℚ
  alignment : ℚ
  rounding : ℚ
  alphaRounding : ℚ
  betaRounding : ℚ
  addRounding : ℚ
  outputRounding : ℚ
  inputConversion : ℚ := 0
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.PipelineAnalysis.scaledCellJson](Cli/PipelineAnalysis.md#decl-1aed0be8e56c2ba3), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.identity_epilogue_tight](Regression/DecisionExtensions.md#decl-ce4806500b961d68), [TensorCore.Regression.scaled_analysis_fp32_output_exact](Regression/PipelineAnalysis.md#decl-11515fce5906431f), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeSourceAnalysisCell](NativeConvertedAnalysis.md#decl-1fde80241417645a), [TensorCore.sourceAnalysisCell](ConvertedGemmAnalysis.md#decl-9df6da962c5020b7)

</details>

</details>

<a id="decl-7e75458ed410184c"></a>

<details>
<summary><code>TensorCore.PipelineBound.error</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L31)

```lean
def PipelineBound.error (b : PipelineBound) : ℚ :=
  b.alignment + b.rounding + b.alphaRounding + b.betaRounding +
    b.addRounding + b.outputRounding + b.inputConversion
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.PipelineAnalysis.scaledCellJson](Cli/PipelineAnalysis.md#decl-1aed0be8e56c2ba3), [TensorCore.Regression.scaled_analysis_zero](Regression/PipelineAnalysis.md#decl-110688352cbe87bb), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.pipelineEntryBounds](ConvertedGemmAnalysis.md#decl-2800a71c520f2518)

</details>

</details>

<a id="decl-0bc331b6c15db37e"></a>

<details>
<summary><code>TensorCore.checkEpilogue</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L35)

```lean
def checkEpilogue (cfg : GemmEpilogue) (a b c : ℚ) (raw : AnalysisBound)
    (w : EpilogueWitness) : Option PipelineBound := do
  let ad ← checkFiniteMultiply cfg.multiplyMode a raw.magnitude w.alphaScale
  let bd ← checkFiniteMultiply cfg.multiplyMode b (absQ c) w.betaScale
  let sd ← checkFiniteAdd cfg.addMode ad.magnitude bd.magnitude w.sumScale
  let out ← checkOutput cfg.output sd.magnitude w.outputScale
  return ⟨out.magnitude, absQ a * raw.alignment, absQ a * raw.rounding,
    ad.error, bd.error, sd.error, out.error, 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae)

<details>
<summary>Used by</summary>

[TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f)

</details>

</details>

<a id="decl-c09f0572310ed572"></a>

<details>
<summary><code>TensorCore.inferEpilogue</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L44)

```lean
def inferEpilogue (cfg : GemmEpilogue) (a b c : ℚ) (raw : AnalysisBound) : EpilogueWitness :=
  let A := absQ a * raw.magnitude
  let B := absQ b * absQ c
  let ae := scalarScale fp32 A
  let be := scalarScale fp32 B
  let ad := (checkFiniteMultiply cfg.multiplyMode a raw.magnitude ae).getD ⟨A, 0⟩
  let bd := (checkFiniteMultiply cfg.multiplyMode b (absQ c) be).getD ⟨B, 0⟩
  let S := ad.magnitude + bd.magnitude
  let se := scalarScale fp32 S
  let O := ((checkFiniteAdd cfg.addMode ad.magnitude bd.magnitude se).getD ⟨S, 0⟩).magnitude
  ⟨ae, be, se, scalarScale cfg.output.format O⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scalarScale](ScalarAnalysis.md#decl-9699e837c1012c63)

<details>
<summary>Used by</summary>

[TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618)

</details>

</details>

<a id="decl-5f865e4aa38a6332"></a>

<details>
<summary><code>TensorCore.checkEpilogue_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L56)

```lean
theorem checkEpilogue_sound (cfg : GemmEpilogue) (alpha beta c : F32) (a b cv : ℚ)
    (ha : value32 alpha = some a) (hb : value32 beta = some b) (hc : value32 c = some cv)
    (raw : AnalysisBound) (w : EpilogueWitness) (bound : PipelineBound)
    (h : checkEpilogue cfg a b cv raw w = some bound) (product : GemmCell) (p : ℚ)
    (hm : absQ product.output.value ≤ raw.magnitude)
    (he : absQ (p - product.output.value) ≤ raw.error) :
    ∃ t, gemmEpilogue cfg alpha beta c product = some t ∧
      absQ t.output.value ≤ bound.magnitude ∧
      absQ (a * p + b * cv - t.output.value) ≤ bound.error := by
  simp only [checkEpilogue, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨ad, had, bd, hbd, sd, hsd, out, hout, rfl⟩ := h
  obtain ⟨ac, hac, _, hav⟩ := finite32_of_value32 alpha a ha
  obtain ⟨bc, hbc, _, hbv⟩ := finite32_of_value32 beta b hb
  obtain ⟨cc, hcc, _, hcv⟩ := finite32_of_value32 c cv hc
  obtain ⟨adatum, hat, hatm, hate⟩ := checkFiniteMultiply_sound _ _ _ _ ad had
    product.output.value (classifyNat_finiteValue fp32 (by decide) _ _ product.output.valid) hm
  obtain ⟨bt, hbt, hbtm, hbte⟩ := checkFiniteMultiply_sound _ _ _ _ bd hbd
    cc.value (classifyNat_finiteValue fp32 (by decide) _ _ cc.valid) (by rw [hcv]; exact Rat.le_refl)
  rw [← hav] at hat hate
  rw [← hbv] at hbt hbte
  obtain ⟨st, hst, hstm, hste⟩ := checkFiniteAdd_sound _ _ _ _ sd hsd adatum bt hatm hbtm
  obtain ⟨ot, hot, hotm, hote⟩ := checkOutput_sound _ _ _ out hout st hstm
  change cfg.output.convert st.value = some ot at hot
  change absQ (st.value - ot.value) ≤ out.error at hote
  let t : ScaledGemmCell cfg := ⟨product, ac, bc, cc, adatum, bt, st, ot⟩
  refine ⟨t, ?_, hotm, ?_⟩
  · simp [gemmEpilogue, GemmEpilogue.multiplyStage, GemmEpilogue.addStage, hac, hbc, hcc, hat, hbt, hst, hot, t]
  · have hs : t.scalarError ≤ ad.error + bd.error + sd.error + out.error := by
      change absQ (ac.value * product.output.value - adatum.value) +
        absQ (bc.value * cc.value - bt.value) + absQ (adatum.value + bt.value - st.value) +
        absQ (st.value - ot.value) ≤ _
      grind
    have hp := t.propagate p raw.error he
    change absQ (ac.value * p + bc.value * cc.value - ot.value) ≤
      absQ ac.value * raw.error + t.scalarError at hp
    rw [hav, hbv, hcv] at hp
    simp only [PipelineBound.error, AnalysisBound.error] at *
    change absQ (a * p + b * cv - ot.value) ≤ _
    grind
```

**Supporting proofs:** [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.checkFiniteAdd_sound](ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkOutput_sound](ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.classifyNat_finiteValue](../Core/Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f)

</details>

</details>

<a id="decl-91f28fb432d0e99c"></a>

<details>
<summary><code>TensorCore.checkScaledCell</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L96)

```lean
def checkScaledCell (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← checkGemmCell model pairs 0 w.groups
  checkEpilogue cfg a b cv raw w.epilogue
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f)

</details>

</details>

<a id="decl-4ba652d62c50104f"></a>

<details>
<summary><code>TensorCore.checkScaledCell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L104)

```lean
theorem checkScaledCell_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (F16 × F16)) (w : ScaledWitness) (bound : PipelineBound)
    (h : checkScaledCell model cfg alpha beta c pairs w = some bound) :
    ∃ product t z, simulateGemmCell model pairs 0 = .ok product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      scaledGemmCellIdeal alpha beta c pairs = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkScaledCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨a, ha, b, hb, cv, hc, raw, hraw, hepi⟩ := h
  obtain ⟨product, p, hp, hi, hv, hm, he⟩ := checkGemmCell_sound model pairs 0 w.groups raw hraw
  have hzero : product.initial.value = 0 := by
    have hz : value32 0 = some 0 := by decide +kernel
    rw [hz] at hv
    exact (Option.some.inj hv).symm
  rw [hzero, Rat.zero_add] at he
  obtain ⟨t, ht, hmag, herr⟩ := checkEpilogue_sound cfg alpha beta c a b cv ha hb hc
    raw w.epilogue bound hepi product p hm he
  exact ⟨product, t, a * p + b * cv, hp, ht,
    by simp [scaledGemmCellIdeal, ha, hb, hc, hi], hmag, herr⟩
```

**Supporting proofs:** [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf)

</details>

</details>

<a id="decl-96a36f3e400b3618"></a>

<details>
<summary><code>TensorCore.inferScaledWitness</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L124)

```lean
def inferScaledWitness (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) : Option ScaledWitness := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← analyzeGemmCell model pairs 0
  return ⟨raw.witness, inferEpilogue cfg a b cv raw.bound⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e)

</details>

</details>

<a id="decl-e3e466f30da2b9b7"></a>

<details>
<summary><code>TensorCore.ScaledAnalysis</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L132)

```lean
structure ScaledAnalysis where
  witness : ScaledWitness
  bound : PipelineBound
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.PipelineAnalysis.scaledCellJson](Cli/PipelineAnalysis.md#decl-1aed0be8e56c2ba3), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.identity_epilogue_tight](Regression/DecisionExtensions.md#decl-ce4806500b961d68), [TensorCore.Regression.scaled_analysis_empty_output_still_converts](Regression/PipelineAnalysis.md#decl-f9edf42bc23be958), [TensorCore.Regression.scaled_analysis_finite_rejection](Regression/PipelineAnalysis.md#decl-c163cf5fae20f854), [TensorCore.Regression.scaled_analysis_fp32_output_exact](Regression/PipelineAnalysis.md#decl-11515fce5906431f), [TensorCore.Regression.scaled_analysis_subnormal](Regression/PipelineAnalysis.md#decl-909c54c1801f1bd8), [TensorCore.Regression.scaled_analysis_zero](Regression/PipelineAnalysis.md#decl-110688352cbe87bb), [TensorCore.Regression.sourceWitness](Regression/PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e), [TensorCore.nativeSourceAnalysisCell](NativeConvertedAnalysis.md#decl-1fde80241417645a), [TensorCore.pipelineEntryBounds](ConvertedGemmAnalysis.md#decl-2800a71c520f2518), [TensorCore.sourceAnalysisCell](ConvertedGemmAnalysis.md#decl-9df6da962c5020b7)

</details>

</details>

<a id="decl-41a297c61c8a49d2"></a>

<details>
<summary><code>TensorCore.analyzeScaledCell</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L137)

```lean
def analyzeScaledCell (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) : Option ScaledAnalysis := do
  let w ← inferScaledWitness model cfg alpha beta c pairs
  let b ← checkScaledCell model cfg alpha beta c pairs w
  return ⟨w, b⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618)

<details>
<summary>Used by</summary>

[TensorCore.Regression.identity_epilogue_tight](Regression/DecisionExtensions.md#decl-ce4806500b961d68), [TensorCore.Regression.scaled_analysis_finite_rejection](Regression/PipelineAnalysis.md#decl-c163cf5fae20f854), [TensorCore.Regression.scaled_analysis_fp32_output_exact](Regression/PipelineAnalysis.md#decl-11515fce5906431f), [TensorCore.Regression.scaled_analysis_subnormal](Regression/PipelineAnalysis.md#decl-909c54c1801f1bd8), [TensorCore.Regression.scaled_analysis_zero](Regression/PipelineAnalysis.md#decl-110688352cbe87bb), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e)

</details>

</details>

<a id="decl-21d9c2a697906c7e"></a>

<details>
<summary><code>TensorCore.analyzeScaledCell_checked</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L143)

```lean
theorem analyzeScaledCell_checked (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (F16 × F16)) (a : ScaledAnalysis)
    (h : analyzeScaledCell model cfg alpha beta c pairs = some a) :
    checkScaledCell model cfg alpha beta c pairs a.witness = some a.bound := by
  simp only [analyzeScaledCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨w, _, b, hb, rfl⟩ := h
  exact hb
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e)

</details>

</details>

<a id="decl-cf8f65ecdf30f25e"></a>

<details>
<summary><code>TensorCore.checkScaledCell_inputConversion</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmAnalysis.lean#L151)

```lean
theorem checkScaledCell_inputConversion (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (F16 × F16)) (w : ScaledWitness) (b : PipelineBound)
    (h : checkScaledCell model cfg alpha beta c pairs w = some b) : b.inputConversion = 0 := by
  simp only [checkScaledCell, checkEpilogue, bind, pure, Option.bind_eq_some_iff,
    Option.some.injEq] at h
  obtain ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, rfl⟩ := h
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf)

</details>

</details>
