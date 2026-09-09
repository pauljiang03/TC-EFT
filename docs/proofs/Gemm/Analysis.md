# TensorCore.Gemm.Analysis

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b2d9a6ca1b8ee691"></a>

<details>
<summary><code>TensorCore.checkGemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L9)

```lean
def checkGemmCell (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32)
    (ws : List GroupWitness) : Option AnalysisBound := do
  let cv ← value32 c
  checkGroups model.path.profile (gemmBlocks model pairs) (absQ cv) ws
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGroups](../TC/Program/GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_witness_rejects_mutations](Regression/GemmAnalysis.md#decl-18dc193709d671fa), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d)

</details>

</details>

<a id="decl-623f3bbd7dca9d5a"></a>

<details>
<summary><code>TensorCore.checkGemmCell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L14)

```lean
theorem checkGemmCell_sound (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32)
    (ws : List GroupWitness) (b : AnalysisBound) (h : checkGemmCell model pairs c ws = some b) :
    ∃ cell products, simulateGemmCell model pairs c = .ok cell ∧
      idealProducts v100F16F32 pairs = some products ∧ value32 c = some cell.initial.value ∧
      absQ cell.output.value ≤ b.magnitude ∧
      absQ (cell.initial.value + products - cell.output.value) ≤ b.error := by
  simp only [checkGemmCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨cv, hv, hc⟩ := h
  obtain ⟨initial, hi, hb, hval⟩ := finite32_of_value32 c cv hv
  obtain ⟨ts, products, hr, hp, hm, he⟩ := checkGroups_sound model.path.profile
    (gemmBlocks model pairs) (absQ cv) ws b hc initial (by rw [hval]; exact Rat.le_refl)
  obtain ⟨traces, ht, hf⟩ := runGemmInstructions_complete model.path initial
    (gemmInstructions pairs) ts
    (fun g hg => (gemmInstructions_shape pairs g hg).trans (WmmaGemmModel.k model).symm) hr
  refine ⟨⟨initial, traces⟩, products, ?_, ?_, ?_, ?_, ?_⟩
  · simp [simulateGemmCell, hi, ht]
  · rwa [gemmBlocks_ideal] at hp
  · simpa [hval] using hv
  · simpa [GemmCell.output, GemmCell.blocks, hf] using hm
  · simpa [GemmCell.output, GemmCell.blocks, hf] using he
```

**Supporting proofs:** [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.checkGroups_sound](../TC/Program/GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66), [TensorCore.runGemmInstructions_complete](Bounds.md#decl-5e1cd17f4e8c0bf4)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.blocks](Defs.md#decl-f9fc32c91c796407), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGroups](../TC/Program/GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d)

</details>

</details>

<a id="decl-440d2015df04ff83"></a>

<details>
<summary><code>TensorCore.CellAnalysis</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L35)

```lean
structure CellAnalysis where
  witness : List GroupWitness
  bound : AnalysisBound
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.cellJson](Cli/Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.Analysis.report](Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.ReviewClaims.native_accuracy](Regression/ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](Regression/ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.analysis_finite_boundary](Regression/GemmAnalysis.md#decl-8904b8e4b9caf447), [TensorCore.Regression.analysis_improves_existing_certificate](Regression/GemmAnalysis.md#decl-a1392f6a35ba7d56), [TensorCore.Regression.analysis_improves_minimal_static](Regression/GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_negative_subnormal](Regression/GemmAnalysis.md#decl-0aab10efcd43b268), [TensorCore.Regression.analysis_nonfinite_rejected](Regression/GemmAnalysis.md#decl-f472b6e439a11eeb), [TensorCore.Regression.analysis_signed_zero_and_empty](Regression/GemmAnalysis.md#decl-4f1d63703ef328c3), [TensorCore.Regression.analysis_tiny_bounds](Regression/GemmAnalysis.md#decl-613947919eca8929), [TensorCore.Regression.tinyAnalysis](Regression/GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.Regression.tinyWitness](Regression/GemmAnalysis.md#decl-d68e82c966d519d3), [TensorCore.analysisEntryBounds](Analysis.md#decl-d1b4af0b27a0d0ba), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.analyzeNativeGemm_entry_sound](NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618)

</details>

</details>

<a id="decl-6eee488b36c50d94"></a>

<details>
<summary><code>TensorCore.analyzeGemmCell</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L40)

```lean
def analyzeGemmCell (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) :
    Option CellAnalysis := do
  let cv ← value32 c
  let ws ← inferGroups model.path.profile (gemmBlocks model pairs) (absQ cv)
  let b ← checkGemmCell model pairs c ws
  return ⟨ws, b⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.inferGroups](../TC/Program/GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_finite_boundary](Regression/GemmAnalysis.md#decl-8904b8e4b9caf447), [TensorCore.Regression.analysis_negative_subnormal](Regression/GemmAnalysis.md#decl-0aab10efcd43b268), [TensorCore.Regression.analysis_nonfinite_rejected](Regression/GemmAnalysis.md#decl-f472b6e439a11eeb), [TensorCore.Regression.analysis_signed_zero_and_empty](Regression/GemmAnalysis.md#decl-4f1d63703ef328c3), [TensorCore.Regression.tinyAnalysis](Regression/GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.inferScaledWitness](ScaledGemmAnalysis.md#decl-96a36f3e400b3618)

</details>

</details>

<a id="decl-8f79134186f502df"></a>

<details>
<summary><code>TensorCore.analyzeGemmCell_checked</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L47)

```lean
theorem analyzeGemmCell_checked (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32)
    (a : CellAnalysis) (h : analyzeGemmCell model pairs c = some a) :
    checkGemmCell model pairs c a.witness = some a.bound := by
  simp only [analyzeGemmCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨_, _, ws, _, b, hb, he⟩ := h
  cases he
  exact hb
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.inferGroups](../TC/Program/GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991)

</details>

</details>

<a id="decl-e410d155f5952501"></a>

<details>
<summary><code>TensorCore.analyzeGemmCell_complete</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L55)

```lean
theorem analyzeGemmCell_complete (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cv M : ℚ) (hc : value32 c = some cv)
    (hm : scheduleMass model.path.profile (gemmBlocks model pairs) = some M)
    (hr : absQ cv + M ≤ maxFinite32) : ∃ a, analyzeGemmCell model pairs c = some a := by
  obtain ⟨ws, hw⟩ := inferGroups_complete model.path.profile (gemmBlocks model pairs) (absQ cv) M
    (gemmBlocks_shape model pairs) (absQ_nonneg cv) hm hr
  obtain ⟨b, hb⟩ := inferGroups_checked model.path.profile (gemmBlocks model pairs) (absQ cv) ws hw
  exact ⟨⟨ws, b⟩, by simp [analyzeGemmCell, checkGemmCell, hc, hw, hb]⟩
```

**Supporting proofs:** [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.inferGroups_checked](../TC/Program/GroupAnalysis.md#decl-8253aaa6e78b0c34), [TensorCore.inferGroups_complete](../TC/Program/GroupAnalysis.md#decl-f38baddc12606950)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGroups](../TC/Program/GroupAnalysis.md#decl-3ceec23d37a63df0), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.inferGroups](../TC/Program/GroupAnalysis.md#decl-44e47055c844c9f4), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.scheduleMass](../TC/Program/GroupAnalysis.md#decl-dbedd44c59d564b7), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8b640af4e4509e78"></a>

<details>
<summary><code>TensorCore.analyzeGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L64)

```lean
def analyzeGemm (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option CellAnalysis) m n :=
  DenseMatrix.ofFn fun i j => analyzeGemmCell model (gemmPairs A B i j) C[i.val][j.val]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.report](Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d)

</details>

</details>

<a id="decl-d1b4af0b27a0d0ba"></a>

<details>
<summary><code>TensorCore.analysisEntryBounds</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L68)

```lean
def analysisEntryBounds (cells : DenseMatrix (Option CellAnalysis) m n) : DenseMatrix ℚ m n :=
  cells.map fun row => row.map fun a => (a.map fun c => c.bound.error).getD 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.report](Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd)

</details>

</details>

<a id="decl-6640feb1a0c523f2"></a>

<details>
<summary><code>TensorCore.gemmAnalysisCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L71)

```lean
def gemmAnalysisCheck (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ) : Bool :=
  decide (0 ≤ tolerance) &&
  decide (∀ i : Fin m, ∀ j : Fin n,
    ((checkGemmCell model (gemmPairs A B i j) C[i.val][j.val] witness[i.val][j.val]).map
      fun b => decide (b.error ≤ tolerance)).getD false = true)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.report](Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.Regression.analysis_tolerance_certified](Regression/GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.Regression.analysis_tolerance_inconclusive](Regression/GemmAnalysis.md#decl-9f010dd9c59fddca), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d)

</details>

</details>

<a id="decl-3560e57078a6df2b"></a>

<details>
<summary><code>TensorCore.GemmAccurate</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L79)

```lean
def GemmAccurate (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tolerance : ℚ) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ cell z,
    (gemm model A B C)[i.val][j.val] = .ok cell ∧
    (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tolerance
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc)

<details>
<summary>Used by</summary>

[TensorCore.EntryFamilyAccurate](EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.GemmFamilyAccurate](Family.md#decl-6a51b2e27db67ff4), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](Regression/ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.family_members_accurate](Regression/ReviewClaims.md#decl-5a504b60d62ca03e), [TensorCore.Regression.analysis_tolerance_certified](Regression/GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d)

</details>

</details>

<a id="decl-9853d7ce970a5d1d"></a>

<details>
<summary><code>TensorCore.gemmAnalysisCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L85)

```lean
theorem gemmAnalysisCheck_sound (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ)
    (h : gemmAnalysisCheck model A B C witness tolerance = true) :
    GemmAccurate model A B C tolerance := by
  simp only [gemmAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro i j
  have hc := h.2 i j
  cases hb : checkGemmCell model (gemmPairs A B i j) C[i.val][j.val] witness[i.val][j.val] with
  | none => simp [hb] at hc
  | some b =>
    simp only [hb, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
    obtain ⟨cell, products, hr, hp, hv, _, he⟩ := checkGemmCell_sound model _ _ _ b hb
    refine ⟨cell, cell.initial.value + products, ?_, ?_, Rat.le_trans he hc⟩
    · rwa [gemm_entry]
    · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]
```

**Supporting proofs:** [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.Regression.analysis_tolerance_certified](Regression/GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](Analysis.md#decl-7b3d3dd3b1859d7d)

</details>

</details>

<a id="decl-6787ae59a9d8b991"></a>

<details>
<summary><code>TensorCore.analyzeGemm_entry_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L102)

```lean
theorem analyzeGemm_entry_sound (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n)
    (a : CellAnalysis) (h : (analyzeGemm model A B C)[i.val][j.val] = some a) :
    ∃ cell z, (gemm model A B C)[i.val][j.val] = .ok cell ∧
      (gemmIdeal A B C)[i.val][j.val] = some z ∧
      absQ cell.output.value ≤ a.bound.magnitude ∧ absQ (z - cell.output.value) ≤ a.bound.error := by
  simp only [analyzeGemm, DenseMatrix.ofFn, Vector.getElem_ofFn] at h
  have hc := analyzeGemmCell_checked model _ _ a h
  obtain ⟨cell, products, hr, hp, hv, hm, he⟩ := checkGemmCell_sound model _ _ _ _ hc
  refine ⟨cell, cell.initial.value + products, ?_, ?_, hm, he⟩
  · rwa [gemm_entry]
  · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]
```

**Supporting proofs:** [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64)

</details>

</details>

<a id="decl-099e6418fcc0de51"></a>

<details>
<summary><code>TensorCore.gemmAnalysisCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L115)

```lean
theorem gemmAnalysisCheck_matrix_error (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ)
    (h : gemmAnalysisCheck model A B C witness tolerance = true)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tolerance := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨cell, z, hr, hi, he⟩ := gemmAnalysisCheck_sound model A B C witness tolerance h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he
```

**Supporting proofs:** [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-055cab5838c28c64"></a>

<details>
<summary><code>TensorCore.analyzeGemm_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L132)

```lean
theorem analyzeGemm_matrix_error (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : ∀ i : Fin m, ∀ j : Fin n, ∃ a, (analyzeGemm model A B C)[i.val][j.val] = some a)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (analysisEntryBounds (analyzeGemm model A B C)) := by
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨a, ha⟩ := h i j
  obtain ⟨cell, z, hr, hi, _, he⟩ := analyzeGemm_entry_sound model A B C i j a ha
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, analysisEntryBounds, ha, hd i j cell hr] using he
```

**Supporting proofs:** [TensorCore.analyzeGemm_entry_sound](Analysis.md#decl-6787ae59a9d8b991), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analysisEntryBounds](Analysis.md#decl-d1b4af0b27a0d0ba), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7b3d3dd3b1859d7d"></a>

<details>
<summary><code>TensorCore.gemmAnalysisCheck_paper</code></summary>

[Lean source](../../../TensorCore/Gemm/Analysis.lean#L149)

```lean
theorem gemmAnalysisCheck_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ)
    (h : gemmAnalysisCheck model A B C witness tolerance = true) (i : Fin m) (j : Fin n) :
    ∃ bits d z,
      (PaperSpec.wmmaGemmBits (PaperSpec.wmmaModel model) A B C)[i.val][j.val] = some bits ∧
      value32 bits = some d ∧ (gemmIdeal A B C)[i.val][j.val] = some z ∧
      absQ (z - d) ≤ tolerance := by
  obtain ⟨cell, z, hr, hi, he⟩ := gemmAnalysisCheck_sound model A B C witness tolerance h i j
  refine ⟨cell.output.bits, cell.output.value, z, ?_, ?_, hi, he⟩
  · rw [← PaperSpec.gemmBits_eq_paper]
    simp [gemmBits, hr, Except.toOption, Except.map]
  · simp [value32, cell.output.valid, Finite32.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.wmmaGemmBits](Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.gemmBits](Defs.md#decl-adba0115aad6bb7b), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
