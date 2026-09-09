# TensorCore.Gemm.NativeScaledGemm

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-33acf60ccf6fd24f"></a>

<details>
<summary><code>TensorCore.nativeProductTrace</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L9)

```lean
def nativeProductTrace (model : NativeGemmModel p) (k : ℕ) (cell : NativeGemmCell) : GemmCell :=
  ⟨cell.initial, chunks (p.inner / model.products) (groupCount p.inner k) cell.blocks⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.chunks](../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e)

</details>

</details>

<a id="decl-bbcadd81514a3d7e"></a>

<details>
<summary><code>TensorCore.nativeProductTrace_output</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L12)

```lean
theorem nativeProductTrace_output (model : NativeGemmModel p)
    (pairs : List (NativeWord p × NativeWord p)) (cell : NativeGemmCell)
    (h : nativeGemmCell model pairs 0 = some cell) :
    (nativeProductTrace model pairs.length cell).output = cell.output := by
  unfold GemmCell.output GemmCell.blocks nativeProductTrace
  rw [native_instruction_trace_covers model pairs 0 cell h]
  rfl
```

**Supporting proofs:** [TensorCore.native_instruction_trace_covers](NativeGemm.md#decl-fd3ddc25e4345bca)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.blocks](Defs.md#decl-f9fc32c91c796407), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.chunks](../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78)

</details>

</details>

<a id="decl-b4ad7b6a1c2586e6"></a>

<details>
<summary><code>TensorCore.nativeProductCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L20)

```lean
def nativeProductCell (model : NativeGemmModel p) (pairs : List (NativeWord p × NativeWord p)) :
    Option GemmCell := (nativeGemmCell model pairs 0).map (nativeProductTrace model pairs.length)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeProductCell_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257)

</details>

</details>

<a id="decl-727eddedc05f8257"></a>

<details>
<summary><code>TensorCore.nativeScaledGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L23)

```lean
def nativeScaledGemm (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option (ScaledGemmCell cfg)) m n :=
  DenseMatrix.ofFn fun i j => do
    let product ← nativeProductCell model (nativePairs A B i j)
    gemmEpilogue cfg alpha beta C[i.val][j.val] product
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.nativePairs](NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33)

</details>

</details>

<a id="decl-fffa475379689f33"></a>

<details>
<summary><code>TensorCore.nativeConvertedGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L30)

```lean
def nativeConvertedGemm (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option (ScaledGemmCell cfg)) m n) := do
  let a ← convertMatrixTo source p.format mode A
  let b ← convertMatrixTo source p.format mode B
  return nativeScaledGemm model cfg alpha beta a b C
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.nativeScaledGemm](NativeScaledGemm.md#decl-727eddedc05f8257)

<details>
<summary>Used by</summary>

[TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](Regression/NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](Regression/NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.intermediate_overflow_rejected](Regression/NativeScaledGemm.md#decl-6d29392f8e156c74), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](Regression/NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](Regression/NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-96b481624502c00b"></a>

<details>
<summary><code>TensorCore.checkNativeScaledCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L38)

```lean
def checkNativeScaledCell (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord p × NativeWord p)) (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← checkNativeCell model pairs 0 w.groups
  checkEpilogue cfg a b cv raw w.epilogue
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78)

</details>

</details>

<a id="decl-1e3769740c5dad78"></a>

<details>
<summary><code>TensorCore.checkNativeScaledCell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L46)

```lean
theorem checkNativeScaledCell_sound (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (NativeWord p × NativeWord p))
    (w : ScaledWitness) (bound : PipelineBound)
    (h : checkNativeScaledCell model cfg alpha beta c pairs w = some bound) :
    ∃ product t z, nativeProductCell model pairs = some product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      sourceGemmCellIdeal p.format alpha beta c pairs = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkNativeScaledCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨a, ha, b, hb, cv, hc, raw, hraw, hepi⟩ := h
  obtain ⟨cell, v, hp, hi, hv, hm, he⟩ := checkNativeCell_sound model pairs 0 w.groups raw hraw
  have hz : cell.initial.value = 0 := by
    have hzero : value32 0 = some 0 := by decide +kernel
    rw [hzero] at hv
    exact (Option.some.inj hv).symm
  rw [hz, Rat.zero_add] at he
  let product := nativeProductTrace model pairs.length cell
  have ho : product.output = cell.output := nativeProductTrace_output model pairs cell hp
  obtain ⟨t, ht, hmag, herr⟩ := checkEpilogue_sound cfg alpha beta c a b cv ha hb hc raw
    w.epilogue bound hepi product v (by simpa [ho] using hm) (by simpa [ho] using he)
  have hi' : sourceGemmProducts p.format pairs = some v :=
    (sourceGemmProducts_eq_idealProducts model.profile pairs).trans hi
  exact ⟨product, t, a * v + b * cv, by unfold nativeProductCell; rw [hp]; rfl, ht,
    by simp [sourceGemmCellIdeal, ha, hb, hc, hi'], hmag, herr⟩
```

**Supporting proofs:** [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeCell_sound](NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.nativeProductTrace_output](NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.sourceGemmProducts_eq_idealProducts](InputBounds.md#decl-1c676a2d69d32e7d)

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmCell](NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.nativeGemmCell](NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeProductCell](NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace](NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109)

</details>

</details>

<a id="decl-8f4272a5891a3a72"></a>

<details>
<summary><code>TensorCore.inferNativeScaledWitness</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L71)

```lean
def inferNativeScaledWitness (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord p × NativeWord p)) : Option ScaledWitness := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← analyzeNativeCell model pairs 0
  return ⟨raw.witness, inferEpilogue cfg a b cv raw.bound⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.analyzeNativeCell](NativeGemm.md#decl-75268401e2373f4a), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778)

</details>

</details>

<a id="decl-00cd2688fa55eadc"></a>

<details>
<summary><code>TensorCore.analyzeNativeScaledCell</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L79)

```lean
def analyzeNativeScaledCell (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord p × NativeWord p)) : Option ScaledAnalysis := do
  let w ← inferNativeScaledWitness model cfg alpha beta c pairs
  let b ← checkNativeScaledCell model cfg alpha beta c pairs w
  return ⟨w, b⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72)

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeScaledCell_checked](NativeScaledGemm.md#decl-0e60391d7ab89778)

</details>

</details>

<a id="decl-0e60391d7ab89778"></a>

<details>
<summary><code>TensorCore.analyzeNativeScaledCell_checked</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L85)

```lean
theorem analyzeNativeScaledCell_checked (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (NativeWord p × NativeWord p)) (a : ScaledAnalysis)
    (h : analyzeNativeScaledCell model cfg alpha beta c pairs = some a) :
    checkNativeScaledCell model cfg alpha beta c pairs a.witness = some a.bound := by
  simp only [analyzeNativeScaledCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨w, _, b, hb, rfl⟩ := h
  exact hb
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.analyzeNativeScaledCell](NativeScaledGemm.md#decl-00cd2688fa55eadc), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.inferNativeScaledWitness](NativeScaledGemm.md#decl-8f4272a5891a3a72)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c)

</details>

</details>

<a id="decl-2c010389886bef3a"></a>

<details>
<summary><code>TensorCore.checkNativeScaledCell_inputConversion</code></summary>

[Lean source](../../../TensorCore/Gemm/NativeScaledGemm.lean#L93)

```lean
theorem checkNativeScaledCell_inputConversion (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (NativeWord p × NativeWord p)) (w : ScaledWitness) (b : PipelineBound)
    (h : checkNativeScaledCell model cfg alpha beta c pairs w = some b) : b.inputConversion = 0 := by
  simp only [checkNativeScaledCell, checkEpilogue, bind, pure, Option.bind_eq_some_iff,
    Option.some.injEq] at h
  obtain ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, rfl⟩ := h
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PipelineBound](ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkNativeCell](NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeScaledCell](NativeScaledGemm.md#decl-96b481624502c00b), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109)

</details>

</details>
