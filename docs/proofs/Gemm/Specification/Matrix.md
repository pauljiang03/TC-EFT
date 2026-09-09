# TensorCore.Gemm.Specification.Matrix

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0b93e30a9665e8db"></a>

<details>
<summary><code>TensorCore.PaperSpec.Matrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L14)

```lean
abbrev Matrix (α : Type) (m n : ℕ) := Vector (Vector α n) m
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](../Kernels/CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.matrixPairs](Matrix.md#decl-a2b1744a02af852c), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.nativeGemm_eq_paper](NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeMatrix](NativeMatrix.md#decl-faec5dc99cdd0c6d), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaGemmBits](Matrix.md#decl-50cf3300dfca2e74), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_gemm_empty_and_nonfinite](../Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](../Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](../Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](../Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](../Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.familyCheck_paper](../Family.md#decl-0234d61782492f02), [TensorCore.gemmAnalysisCheck_paper](../Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-9f438a42365ca5b2"></a>

<details>
<summary><code>TensorCore.PaperSpec.WmmaModel</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L16)

```lean
inductive WmmaModel where
  | v100 | ampere | hopper
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project](../Kernels/CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.WmmaModel.parameters](Matrix.md#decl-ef4b49759ceb3b29), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.instructionGroups](Matrix.md#decl-dc882eadd7b8d7ef), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.runMatrixInstructions](Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaGemmBits](Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_gemm_empty_and_nonfinite](../Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](../Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](../Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](../Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](../Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>

<a id="decl-ef4b49759ceb3b29"></a>

<details>
<summary><code>TensorCore.PaperSpec.WmmaModel.parameters</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L20)

```lean
def WmmaModel.parameters (model : WmmaModel) : Parameters :=
  ⟨⟨10, 5, 15⟩,
    (match model with | .v100 => 4 | .ampere => 8 | .hopper => 16),
    (match model with | .v100 => 23 | .ampere => 24 | .hopper => 25),
    (match model with | .v100 => none | .ampere => some (-132) | .hopper => some (-133))⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.instructionGroups](Matrix.md#decl-dc882eadd7b8d7ef), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.runMatrixInstructions](Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.wmma_parameters](GemmEquivalence.md#decl-193ac1310155f18d)

</details>

</details>

<a id="decl-4b229a112eae4f8a"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrixChunks</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L27)

```lean
/-- Contiguous, ordered groups; no arithmetic or implementation partition call. -/
def matrixChunks (width : ℕ) : ℕ → List α → List (List α)
  | 0, _ => []
  | count + 1, xs => xs.take width :: matrixChunks width count (xs.drop width)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](../Kernels/CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.PaperSpec.chunks_eq_matrixChunks](GemmEquivalence.md#decl-d259480c970e3a94), [TensorCore.PaperSpec.gemmInstructions_eq_paper](GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.instructionGroups](Matrix.md#decl-dc882eadd7b8d7ef), [TensorCore.PaperSpec.matrixChunks_map](NativeScaledGemmEquivalence.md#decl-0835735bf484ace3), [TensorCore.PaperSpec.matrixInstructions](Matrix.md#decl-41c588bee8af8a91), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeMatrixCell](NativeMatrix.md#decl-a26286392090ff3e), [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeProductMatrixCell](NativeScaledMatrix.md#decl-d9bdf4b9d079ae28), [TensorCore.CutlassWmma.chunks_tabulate](../Kernels/CutlassWmma.md#decl-0031843440b4c3e1)

</details>

</details>

<a id="decl-a2b1744a02af852c"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrixPairs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L31)

```lean
def matrixPairs (A : Matrix (BitVec 16) m k) (B : Matrix (BitVec 16) k n)
    (i : Fin m) (j : Fin n) : List (BitVec 16 × BitVec 16) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](../Kernels/CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c)

</details>

</details>

<a id="decl-41c588bee8af8a91"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrixInstructions</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L36)

```lean
/-- Exactly ceil(k/16) complete slices. Empty and exact-multiple inputs add no padding. -/
def matrixInstructions (pairs : List (BitVec 16 × BitVec 16)) :=
  matrixChunks 16 ((pairs.length + 15) / 16)
    (pairs ++ List.replicate ((16 - pairs.length % 16) % 16) (0, 0))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](../Kernels/CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.gemmInstructions_eq_paper](GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c)

</details>

</details>

<a id="decl-dc882eadd7b8d7ef"></a>

<details>
<summary><code>TensorCore.PaperSpec.instructionGroups</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L40)

```lean
def instructionGroups (model : WmmaModel) (pairs : List (BitVec 16 × BitVec 16)) :=
  matrixChunks model.parameters.products (16 / model.parameters.products) pairs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.WmmaModel.parameters](Matrix.md#decl-ef4b49759ceb3b29), [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.instructionGroups_eq_paper](GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.runMatrixInstructions](Matrix.md#decl-70ab1b5e8c6e625e)

</details>

</details>

<a id="decl-70ab1b5e8c6e625e"></a>

<details>
<summary><code>TensorCore.PaperSpec.runMatrixInstructions</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L44)

```lean
/-- Preserve every normalization-group output, nested by instruction boundary. -/
noncomputable def runMatrixInstructions (model : WmmaModel) : BitVec 32 →
    List (List (BitVec 16 × BitVec 16)) → Option (List (List (BitVec 32)))
  | _, [] => some []
  | c, pairs :: rest => do
    let ds ← runGroups model.parameters c (instructionGroups model pairs)
    let tail ← runMatrixInstructions model (ds.getLast?.getD c) rest
    return ds :: tail
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.WmmaModel.parameters](Matrix.md#decl-ef4b49759ceb3b29), [TensorCore.PaperSpec.instructionGroups](Matrix.md#decl-dc882eadd7b8d7ef), [TensorCore.PaperSpec.runGroups](../../TC/Specification/Schedule.md#decl-34d3305155927c9e)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project](../Kernels/CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c)

</details>

</details>

<a id="decl-78b1933617aed7a4"></a>

<details>
<summary><code>TensorCore.PaperSpec.MatrixCell</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L52)

```lean
structure MatrixCell where
  initial : BitVec 32
  instructions : List (List (BitVec 32))
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project](../Kernels/CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.CutlassWmma.project_check_sound](../Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.MatrixCell.output](Matrix.md#decl-2e5dc86c7c48029c), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeProductMatrixCell](NativeScaledMatrix.md#decl-d9bdf4b9d079ae28), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaGemmBits](Matrix.md#decl-50cf3300dfca2e74), [TensorCore.Regression.cutlass_fixture_connection](../Regression/CutlassWmma.md#decl-e2a0bcb3a499b023), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>

<a id="decl-2e5dc86c7c48029c"></a>

<details>
<summary><code>TensorCore.PaperSpec.MatrixCell.output</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L57)

```lean
def MatrixCell.output (cell : MatrixCell) : BitVec 32 :=
  cell.instructions.flatten.getLast?.getD cell.initial
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemmCellObservation_output](GemmEquivalence.md#decl-4e01e4b2fe2487ea), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.wmmaGemmBits](Matrix.md#decl-50cf3300dfca2e74)

</details>

</details>

<a id="decl-0760d932c690b0cb"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrixCell</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L62)

```lean
/-- The public matrix domain checks finite C even when k=0. Empty k preserves
finite C bit-for-bit, including -0; a nonempty all-zero instruction may change it. -/
noncomputable def matrixCell (model : WmmaModel) (pairs : List (BitVec 16 × BitVec 16))
    (c : BitVec 32) : Option MatrixCell := do
  let _ ← value32 c
  let ds ← runMatrixInstructions model c (matrixInstructions pairs)
  return ⟨c, ds⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.matrixInstructions](Matrix.md#decl-41c588bee8af8a91), [TensorCore.PaperSpec.runMatrixInstructions](Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c)

</details>

</details>

<a id="decl-66a4e74e5f4e4b6c"></a>

<details>
<summary><code>TensorCore.PaperSpec.wmmaGemm</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L69)

```lean
/-- Original dimensions and direct row/column indexing, independent of output tiling. -/
noncomputable def wmmaGemm (model : WmmaModel) (A : Matrix (BitVec 16) m k)
    (B : Matrix (BitVec 16) k n) (C : Matrix (BitVec 32) m n) :
    Matrix (Option MatrixCell) m n :=
  Vector.ofFn fun i => Vector.ofFn fun j => matrixCell model (matrixPairs A B i j) C[i.val][j.val]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.matrixPairs](Matrix.md#decl-a2b1744a02af852c)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaGemmBits](Matrix.md#decl-50cf3300dfca2e74), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>

<a id="decl-50cf3300dfca2e74"></a>

<details>
<summary><code>TensorCore.PaperSpec.wmmaGemmBits</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Matrix.lean#L74)

```lean
noncomputable def wmmaGemmBits (model : WmmaModel) (A : Matrix (BitVec 16) m k)
    (B : Matrix (BitVec 16) k n) (C : Matrix (BitVec 32) m n) :
    Matrix (Option (BitVec 32)) m n :=
  (wmmaGemm model A B C).map fun row => row.map fun cell => cell.map MatrixCell.output
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.MatrixCell.output](Matrix.md#decl-2e5dc86c7c48029c), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.Regression.paper_gemm_empty_and_nonfinite](../Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](../Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](../Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](../Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](../Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.familyCheck_paper](../Family.md#decl-0234d61782492f02), [TensorCore.gemmAnalysisCheck_paper](../Analysis.md#decl-7b3d3dd3b1859d7d)

</details>

</details>
