# TensorCore.Gemm.NativeConvertedAnalysis

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-aa9a1f5af4f849da"></a>

<details>
<summary><code>TensorCore.convertNativeInput_products_error</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L8)

```lean
theorem convertNativeInput_products_error (source : Format) (precision : NativePrecision) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (a : DenseMatrix (NativeWord precision) m k) (b : DenseMatrix (NativeWord precision) k n)
    (ha : convertMatrixTo source precision.format mode A = some a)
    (hb : convertMatrixTo source precision.format mode B = some b) (i : Fin m) (j : Fin n) :
    ∃ s p e, sourceGemmProducts source (sourceGemmPairs source A B i j) = some s ∧
      sourceGemmProducts precision.format (nativePairs a b i j) = some p ∧
      inputProductErrorTo source precision.format mode (sourceGemmPairs source A B i j) = some e ∧ absQ (s - p) ≤ e := by
  have h := inputProductErrorTo_bound source precision.format mode (List.finRange k)
    (fun l : Fin k => (A[i.val][l.val], B[l.val][j.val]))
    (fun l : Fin k => (a[i.val][l.val], b[l.val][j.val]))
    (by intro l _; exact ⟨convertMatrixTo_entry source precision.format mode A a ha i l,
      convertMatrixTo_entry source precision.format mode B b hb l j⟩)
  simpa [List.finRange, List.map_ofFn, Function.comp_def, sourceGemmPairs, nativePairs] using h
```

**Supporting proofs:** [TensorCore.convertMatrixTo_entry](MatrixConversion.md#decl-d6a9de60120b6e01), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109)

</details>

</details>

<a id="decl-1fde80241417645a"></a>

<details>
<summary><code>TensorCore.nativeSourceAnalysisCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L23)

```lean
def nativeSourceAnalysisCell (source target : Format) (mode : BinaryRoundingMode)
    (alpha : F32) (pairs : List (BitVec source.width × BitVec source.width))
    (cell : ScaledAnalysis) : Option ScaledAnalysis := do
  let a ← value32 alpha
  let e ← inputProductErrorTo source target mode pairs
  return ⟨cell.witness, {cell.bound with inputConversion := absQ a * e}⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4)

</details>

</details>

<a id="decl-c0dcde0fbb1acc93"></a>

<details>
<summary><code>TensorCore.analyzeNativeConvertedGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L30)

```lean
def analyzeNativeConvertedGemm (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option ScaledAnalysis) m n) := do
  let a ← convertMatrixTo source precision.format mode A
  let b ← convertMatrixTo source precision.format mode B
  return DenseMatrix.ofFn fun i j => do
    let cell ← analyzeNativeScaledCell model cfg alpha beta C[i.val][j.val] (nativePairs a b i j)
    nativeSourceAnalysisCell source precision.format mode alpha (sourceGemmPairs source A B i j) cell
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeSourceAnalysisCell](NativeConvertedAnalysis.md#decl-1fde80241417645a), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-391b325129d3f272"></a>

<details>
<summary><code>TensorCore.checkNativeConvertedCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L40)

```lean
def checkNativeConvertedCell (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord precision × NativeWord precision)) (original : List (BitVec source.width × BitVec source.width))
    (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let e ← inputProductErrorTo source precision.format mode original
  let b ← checkNativeScaledCell model cfg alpha beta c pairs w
  return {b with inputConversion := absQ a * e}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-5abbeacff71576c1"></a>

<details>
<summary><code>TensorCore.nativeConvertedAnalysisCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L49)

```lean
def nativeConvertedAnalysisCheck (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ) : Bool :=
  decide (0 ≤ tol) && match convertMatrixTo source precision.format mode A, convertMatrixTo source precision.format mode B with
  | some a, some b => decide (∀ i : Fin m, ∀ j : Fin n,
      ((checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
        (nativePairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val]).map
          fun bound => decide (bound.error ≤ tol)).getD false = true)
  | _, _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-ea71efe82ee92d2a"></a>

<details>
<summary><code>TensorCore.NativeConvertedGemmAccurate</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L60)

```lean
def NativeConvertedGemmAccurate (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : ℚ) : Prop :=
  ∃ D, nativeConvertedGemm source mode model cfg alpha beta A B C = some D ∧
    ∀ i : Fin m, ∀ j : Fin n, ∃ t z, D[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ tol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-fe18412a5491e109"></a>

<details>
<summary><code>TensorCore.checkNativeConvertedCell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L69)

```lean
theorem checkNativeConvertedCell_sound (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (a : DenseMatrix (NativeWord precision) m k) (b : DenseMatrix (NativeWord precision) k n)
    (ha : convertMatrixTo source precision.format mode A = some a) (hb : convertMatrixTo source precision.format mode B = some b)
    (i : Fin m) (j : Fin n) (w : ScaledWitness) (bound : PipelineBound)
    (h : checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (nativePairs a b i j) (sourceGemmPairs source A B i j) w = some bound) :
    ∃ t z, (nativeScaledGemm model cfg alpha beta a b C)[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkNativeConvertedCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨av, hav, e, herr, bound, hbound, rfl⟩ := h
  have hzero := checkNativeScaledCell_inputConversion model cfg alpha beta _ _ w bound hbound
  obtain ⟨product, t, z, hp, ht, hz, hm, he⟩ := checkNativeScaledCell_sound model cfg alpha beta _ _ w bound hbound
  obtain ⟨s, p, e', hs, hi, he', hdiff⟩ := convertNativeInput_products_error source precision mode A B a b ha hb i j
  rw [herr] at he'
  cases Option.some.inj he'
  simp only [sourceGemmCellIdeal, hav, bind, pure, Option.bind_some, Option.bind_eq_some_iff] at hz
  obtain ⟨bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hi] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, ?_, ?_, hm, ?_⟩
  · simp only [nativeScaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn]
    rw [hp]
    exact ht
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · have hfinal := gemmSourceError_propagate av bv cv s p t.output.value e bound.error hdiff he
    simpa [PipelineBound.error, hzero, Rat.add_zero] using hfinal
```

**Supporting proofs:** [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.gemmSourceError_propagate](InputBounds.md#decl-7a3b7a6efc84a1d7)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-bcd2971126fa98b6"></a>

<details>
<summary><code>TensorCore.nativeConvertedAnalysisCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L100)

```lean
theorem nativeConvertedAnalysisCheck_sound (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    NativeConvertedGemmAccurate source mode model cfg alpha beta A B C tol := by
  simp only [nativeConvertedAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  cases ha : convertMatrixTo source precision.format mode A with
  | none => simp [ha] at h
  | some a =>
    cases hb : convertMatrixTo source precision.format mode B with
    | none => simp [ha, hb] at h
    | some b =>
      simp only [ha, hb, decide_eq_true_eq] at h
      refine ⟨nativeScaledGemm model cfg alpha beta a b C, by simp [nativeConvertedGemm, ha, hb], ?_⟩
      intro i j
      have hc := h.2 i j
      cases he : checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
          (nativePairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val] with
      | none => simp [he] at hc
      | some bound =>
        simp only [he, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
        obtain ⟨t, z, ht, hz, _, herr⟩ := checkNativeConvertedCell_sound source mode model cfg alpha beta
          A B C a b ha hb i j _ bound he
        exact ⟨t, z, ht, hz, Rat.le_trans herr hc⟩
```

**Supporting proofs:** [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-94b16087f568439c"></a>

<details>
<summary><code>TensorCore.analyzeNativeConvertedGemm_checked</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L126)

```lean
theorem analyzeNativeConvertedGemm_checked (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeNativeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (a : DenseMatrix (NativeWord precision) m k) (b : DenseMatrix (NativeWord precision) k n)
    (ha : convertMatrixTo source precision.format mode A = some a) (hb : convertMatrixTo source precision.format mode B = some b)
    (i : Fin m) (j : Fin n) (cell : ScaledAnalysis) (hc : cells[i.val][j.val] = some cell) :
    checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (nativePairs a b i j) (sourceGemmPairs source A B i j) cell.witness = some cell.bound := by
  simp only [analyzeNativeConvertedGemm, ha, hb, bind, pure, Option.bind_some, Option.some.injEq] at h
  rw [← h] at hc
  simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, Option.bind_eq_some_iff] at hc
  obtain ⟨raw, hraw, hsource⟩ := hc
  simp only [nativeSourceAnalysisCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hsource
  obtain ⟨av, hav, e, he, rfl⟩ := hsource
  simp [checkNativeConvertedCell, hav, he, analyzeNativeScaledCell_checked model cfg alpha beta _ _ raw hraw]
```

**Supporting proofs:** [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeSourceAnalysisCell](NativeConvertedAnalysis.md#decl-1fde80241417645a), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4)

</details>

</details>

<a id="decl-4bdd23a2e2a4ea33"></a>

<details>
<summary><code>TensorCore.nativeConvertedAnalysisCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L144)

```lean
theorem nativeConvertedAnalysisCheck_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, nativeConvertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tol := by
  obtain ⟨out, hr, entries⟩ := nativeConvertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, ht, hi, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd out hr i j t ht] using he
```

**Supporting proofs:** [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1f1d6e0e7d0c4faa"></a>

<details>
<summary><code>TensorCore.nativeConvertedAnalysisCheck_paper</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L164)

```lean
theorem nativeConvertedAnalysisCheck_paper (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ∃ D, PaperSpec.nativeConvertedMatrix (PaperSpec.layoutOf source) (PaperSpec.scalarModeOf mode)
        (PaperSpec.parametersOf model.profile) precision.inner (PaperSpec.epilogueOf cfg) alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t d z, D[i.val][j.val] = some t ∧
        binaryValue cfg.output.format t.output = some d ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨out, hr, entries⟩ := nativeConvertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  refine ⟨out.map (fun row => row.map fun t => t.map PaperSpec.scaledCellObservation), ?_, ?_⟩
  · rw [← PaperSpec.nativeConvertedGemm_eq_independent, hr]
    rfl
  · intro i j
    obtain ⟨t, z, ht, hz, he⟩ := entries i j
    refine ⟨PaperSpec.scaledCellObservation t, t.output.value, z, ?_, ?_, hz, he⟩
    · simp [ht]
    · simp [PaperSpec.scaledCellObservation, binaryValue, t.output.valid, FiniteBinary.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.PaperSpec.Matrix](Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarEpilogue](Specification/Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Specification/Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Specification/Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.epilogueOf](Specification/ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.layoutOf](../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.nativeConvertedMatrix](Specification/NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.parametersOf](../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.scalarModeOf](Specification/ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scaledCellObservation](Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9e1e0b7ef35671a4"></a>

<details>
<summary><code>TensorCore.analyzeNativeConvertedGemm_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeConvertedAnalysis.lean#L184)

```lean
theorem analyzeNativeConvertedGemm_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeNativeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (hcells : ∀ i : Fin m, ∀ j : Fin n, ∃ cell, cells[i.val][j.val] = some cell)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, nativeConvertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (pipelineEntryBounds cells) := by
  cases ha : convertMatrixTo source precision.format mode A with
  | none => simp [analyzeNativeConvertedGemm, ha] at h
  | some a =>
    cases hb : convertMatrixTo source precision.format mode B with
    | none => simp [analyzeNativeConvertedGemm, ha, hb] at h
    | some b =>
      have hr : nativeConvertedGemm source mode model cfg alpha beta A B C =
          some (nativeScaledGemm model cfg alpha beta a b C) := by simp [nativeConvertedGemm, ha, hb]
      apply matrixAbsSum_le_entry_bounds
      intro i j
      obtain ⟨cell, hcell⟩ := hcells i j
      have hchecked := analyzeNativeConvertedGemm_checked source mode model cfg alpha beta A B C cells h
        a b ha hb i j cell hcell
      obtain ⟨t, z, ht, hi, _, he⟩ := checkNativeConvertedCell_sound source mode model cfg alpha beta
        A B C a b ha hb i j cell.witness cell.bound hchecked
      rw [hz i j] at hi
      cases Option.some.inj hi
      simpa [DenseMatrix.ofFn, pipelineEntryBounds, hcell, hd _ hr i j t ht] using he
```

**Supporting proofs:** [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.nativeSourceAnalysisCell](NativeConvertedAnalysis.md#decl-1fde80241417645a), [TensorCore.pipelineEntryBounds](ConvertedGemmAnalysis.md#decl-2800a71c520f2518), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
