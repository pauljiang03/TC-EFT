# TensorCore.Gemm.ConvertedGemmAnalysis

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-9df6da962c5020b7"></a>

<details>
<summary><code>TensorCore.sourceAnalysisCell</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L9)

```lean
def sourceAnalysisCell (source : Format) (mode : BinaryRoundingMode)
    (alpha : F32) (pairs : List (BitVec source.width × BitVec source.width))
    (cell : ScaledAnalysis) : Option ScaledAnalysis := do
  let a ← value32 alpha
  let e ← gemmInputProductTightError source mode pairs
  return ⟨cell.witness, {cell.bound with inputConversion := absQ a * e}⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243)

</details>

</details>

<a id="decl-373563c7ab17b86a"></a>

<details>
<summary><code>TensorCore.analyzeConvertedGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L16)

```lean
def analyzeConvertedGemm (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option ScaledAnalysis) m n) := do
  let a ← convertGemmInput source mode A
  let b ← convertGemmInput source mode B
  return DenseMatrix.ofFn fun i j => do
    let cell ← analyzeScaledCell model cfg alpha beta C[i.val][j.val] (gemmPairs a b i j)
    sourceAnalysisCell source mode alpha (sourceGemmPairs source A B i j) cell
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.sourceAnalysisCell](ConvertedGemmAnalysis.md#decl-9df6da962c5020b7), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.scaled_analysis_empty_output_still_converts](Regression/PipelineAnalysis.md#decl-f9edf42bc23be958), [TensorCore.Regression.sourceWitness](Regression/PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

</details>

</details>

<a id="decl-f8060bc8fd76f1ba"></a>

<details>
<summary><code>TensorCore.checkConvertedCell</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L26)

```lean
def checkConvertedCell (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) (original : List (BitVec source.width × BitVec source.width))
    (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let e ← gemmInputProductTightError source mode original
  let b ← checkScaledCell model cfg alpha beta c pairs w
  return {b with inputConversion := absQ a * e}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

</details>

</details>

<a id="decl-bc39b43acd1fa4bf"></a>

<details>
<summary><code>TensorCore.convertedAnalysisCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L35)

```lean
def convertedAnalysisCheck (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ) : Bool :=
  decide (0 ≤ tol) && match convertGemmInput source mode A, convertGemmInput source mode B with
  | some a, some b => decide (∀ i : Fin m, ∀ j : Fin n,
      ((checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
        (gemmPairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val]).map
          fun bound => decide (bound.error ≤ tol)).getD false = true)
  | _, _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.Regression.scaled_analysis_source_accuracy](Regression/PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](Regression/PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

</details>

</details>

<a id="decl-63f5f66fca4e28d5"></a>

<details>
<summary><code>TensorCore.ConvertedGemmAccurate</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L46)

```lean
def ConvertedGemmAccurate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : ℚ) : Prop :=
  ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
    ∀ i : Fin m, ∀ j : Fin n, ∃ t z, D[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ tol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.Regression.scaled_analysis_source_accuracy](Regression/PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

</details>

</details>

<a id="decl-aacb76261a0f16bf"></a>

<details>
<summary><code>TensorCore.checkConvertedCell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L55)

```lean
theorem checkConvertedCell_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) (w : ScaledWitness) (bound : PipelineBound)
    (h : checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (gemmPairs a b i j) (sourceGemmPairs source A B i j) w = some bound) :
    ∃ t z, (scaledGemm model cfg alpha beta a b C)[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkConvertedCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨av, hav, e, herr, bound, hbound, rfl⟩ := h
  have hzero := checkScaledCell_inputConversion model cfg alpha beta _ _ w bound hbound
  obtain ⟨product, t, z, hp, ht, hz, hm, he⟩ := checkScaledCell_sound model cfg alpha beta _ _ w bound hbound
  obtain ⟨s, p, e', hs, hi, he', hdiff⟩ := convertGemmInput_products_tight_error source mode A B a b ha hb i j
  rw [herr] at he'
  cases Option.some.inj he'
  simp only [scaledGemmCellIdeal, hav, bind, pure, Option.bind_some, Option.bind_eq_some_iff] at hz
  obtain ⟨bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hi] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, ?_, ?_, hm, ?_⟩
  · simp only [scaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn, gemm_entry]
    change ((simulateGemmCell model (gemmPairs a b i j) (0 : F32)).toOption.bind
      fun product => gemmEpilogue cfg alpha beta C[i.val][j.val] product) = some t
    rw [hp]
    exact ht
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · have hfinal := gemmSourceError_propagate av bv cv s p t.output.value e bound.error hdiff he
    simpa [PipelineBound.error, hzero, Rat.add_zero] using hfinal
```

**Supporting proofs:** [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.gemmSourceError_propagate](InputBounds.md#decl-7a3b7a6efc84a1d7), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

</details>

</details>

<a id="decl-4fef0511ab9972bb"></a>

<details>
<summary><code>TensorCore.convertedAnalysisCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L88)

```lean
theorem convertedAnalysisCheck_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ConvertedGemmAccurate source mode model cfg alpha beta A B C tol := by
  simp only [convertedAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  cases ha : convertGemmInput source mode A with
  | none => simp [ha] at h
  | some a =>
    cases hb : convertGemmInput source mode B with
    | none => simp [ha, hb] at h
    | some b =>
      simp only [ha, hb, decide_eq_true_eq] at h
      refine ⟨scaledGemm model cfg alpha beta a b C, by simp [convertedGemm, ha, hb], ?_⟩
      intro i j
      have hc := h.2 i j
      cases he : checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
          (gemmPairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val] with
      | none => simp [he] at hc
      | some bound =>
        simp only [he, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
        obtain ⟨t, z, ht, hz, _, herr⟩ := checkConvertedCell_sound source mode model cfg alpha beta
          A B C a b ha hb i j _ bound he
        exact ⟨t, z, ht, hz, Rat.le_trans herr hc⟩
```

**Supporting proofs:** [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.Regression.scaled_analysis_source_accuracy](Regression/PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39)

</details>

</details>

<a id="decl-3e25466cb1f5da5e"></a>

<details>
<summary><code>TensorCore.analyzeConvertedGemm_checked</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L114)

```lean
theorem analyzeConvertedGemm_checked (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) (cell : ScaledAnalysis) (hc : cells[i.val][j.val] = some cell) :
    checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (gemmPairs a b i j) (sourceGemmPairs source A B i j) cell.witness = some cell.bound := by
  simp only [analyzeConvertedGemm, ha, hb, bind, pure, Option.bind_some, Option.some.injEq] at h
  rw [← h] at hc
  simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, Option.bind_eq_some_iff] at hc
  obtain ⟨raw, hraw, hsource⟩ := hc
  simp only [sourceAnalysisCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hsource
  obtain ⟨av, hav, e, he, rfl⟩ := hsource
  simp [checkConvertedCell, hav, he, analyzeScaledCell_checked model cfg alpha beta _ _ raw hraw]
```

**Supporting proofs:** [TensorCore.analyzeScaledCell_checked](ScaledGemmAnalysis.md#decl-21d9c2a697906c7e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkScaledCell](ScaledGemmAnalysis.md#decl-91f28fb432d0e99c), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.sourceAnalysisCell](ConvertedGemmAnalysis.md#decl-9df6da962c5020b7), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243)

</details>

</details>

<a id="decl-1df5f7ac9d761951"></a>

<details>
<summary><code>TensorCore.convertedAnalysisCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L132)

```lean
theorem convertedAnalysisCheck_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tol := by
  obtain ⟨out, hr, entries⟩ := convertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, ht, hi, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd out hr i j t ht] using he
```

**Supporting proofs:** [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6a4213fedaaf8e39"></a>

<details>
<summary><code>TensorCore.convertedAnalysisCheck_paper</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L152)

```lean
theorem convertedAnalysisCheck_paper (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ∃ D, PaperSpec.convertedMatrix (PaperSpec.layoutOf source) (PaperSpec.scalarModeOf mode)
        (PaperSpec.wmmaModel model) (PaperSpec.epilogueOf cfg) alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t d z, D[i.val][j.val] = some t ∧
        binaryValue cfg.output.format t.output = some d ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨out, hr, entries⟩ := convertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  refine ⟨out.map (fun row => row.map fun t => t.map PaperSpec.scaledCellObservation), ?_, ?_⟩
  · rw [← PaperSpec.convertedGemm_eq_independent, hr]
    rfl
  · intro i j
    obtain ⟨t, z, ht, hz, he⟩ := entries i j
    refine ⟨PaperSpec.scaledCellObservation t, t.output.value, z, ?_, ?_, hz, he⟩
    · simp [ht]
    · simp [PaperSpec.scaledCellObservation, binaryValue, t.output.valid, FiniteBinary.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.convertedGemm_eq_independent](Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.Matrix](Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarEpilogue](Specification/Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Specification/Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Specification/Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.convertedMatrix](Specification/Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.epilogueOf](Specification/ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.layoutOf](../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarModeOf](Specification/ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scaledCellObservation](Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.wmmaModel](Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2800a71c520f2518"></a>

<details>
<summary><code>TensorCore.pipelineEntryBounds</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L172)

```lean
def pipelineEntryBounds (cells : DenseMatrix (Option ScaledAnalysis) m n) : DenseMatrix ℚ m n :=
  cells.map fun row => row.map fun a => (a.map fun c => c.bound.error).getD 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4)

</details>

</details>

<a id="decl-ed9b066ca6295243"></a>

<details>
<summary><code>TensorCore.analyzeConvertedGemm_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ConvertedGemmAnalysis.lean#L175)

```lean
theorem analyzeConvertedGemm_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (hcells : ∀ i : Fin m, ∀ j : Fin n, ∃ cell, cells[i.val][j.val] = some cell)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (pipelineEntryBounds cells) := by
  cases ha : convertGemmInput source mode A with
  | none => simp [analyzeConvertedGemm, ha] at h
  | some a =>
    cases hb : convertGemmInput source mode B with
    | none => simp [analyzeConvertedGemm, ha, hb] at h
    | some b =>
      have hr : convertedGemm source mode model cfg alpha beta A B C =
          some (scaledGemm model cfg alpha beta a b C) := by simp [convertedGemm, ha, hb]
      apply matrixAbsSum_le_entry_bounds
      intro i j
      obtain ⟨cell, hcell⟩ := hcells i j
      have hchecked := analyzeConvertedGemm_checked source mode model cfg alpha beta A B C cells h
        a b ha hb i j cell hcell
      obtain ⟨t, z, ht, hi, _, he⟩ := checkConvertedCell_sound source mode model cfg alpha beta
        A B C a b ha hb i j cell.witness cell.bound hchecked
      rw [hz i j] at hi
      cases Option.some.inj hi
      simpa [DenseMatrix.ofFn, pipelineEntryBounds, hcell, hd _ hr i j t ht] using he
```

**Supporting proofs:** [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeScaledCell](ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.pipelineEntryBounds](ConvertedGemmAnalysis.md#decl-2800a71c520f2518), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.sourceAnalysisCell](ConvertedGemmAnalysis.md#decl-9df6da962c5020b7), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
