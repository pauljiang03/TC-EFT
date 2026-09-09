# TensorCore.Gemm.Specification.NativeScaledMatrix

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d9bdf4b9d079ae28"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeProductMatrixCell</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledMatrix.lean#L8)

```lean
noncomputable def nativeProductMatrixCell (p : Parameters) (inner : ℕ)
    (pairs : List (BitVec p.input.width × BitVec p.input.width)) : Option MatrixCell := do
  let groups ← nativeMatrixCell p inner pairs 0
  return ⟨0, matrixChunks (inner / p.products)
    (pairs.length / inner + if pairs.length % inner = 0 then 0 else 1) groups⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a), [TensorCore.PaperSpec.nativeMatrixCell](NativeMatrix.md#decl-a26286392090ff3e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76)

</details>

</details>

<a id="decl-d8536b49742f0b76"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeScaledMatrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledMatrix.lean#L14)

```lean
noncomputable def nativeScaledMatrix (p : Parameters) (inner : ℕ) (cfg : ScalarEpilogue)
    (alpha beta : BitVec 32) (A : Matrix (BitVec p.input.width) m k)
    (B : Matrix (BitVec p.input.width) k n) (C : Matrix (BitVec 32) m n) :
    Matrix (Option (ScaledMatrixCell cfg.output.format)) m n :=
  Vector.ofFn fun i => Vector.ofFn fun j => do
    let product ← nativeProductMatrixCell p inner (List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val]))
    scalarEpilogue cfg alpha beta C[i.val][j.val] product
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.nativeProductMatrixCell](NativeScaledMatrix.md#decl-d9bdf4b9d079ae28), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f)

</details>

</details>

<a id="decl-ba133c7a4812ff93"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertMatrixToLayout</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledMatrix.lean#L22)

```lean
noncomputable def convertMatrixToLayout (source target : Layout) (mode : ScalarMode)
    (A : Matrix (BitVec source.width) m n) : Option (Matrix (BitVec target.width) m n) := by
  classical
  exact if ∀ i : Fin m, ∀ j : Fin n, (scalarConvertWord source target mode A[i.val][j.val]).isSome then
    some (Vector.ofFn fun i => Vector.ofFn fun j =>
      (scalarConvertWord source target mode A[i.val][j.val]).getD 0)
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca)

</details>

</details>

<a id="decl-a193a5e500a7adca"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeConvertedMatrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledMatrix.lean#L30)

```lean
noncomputable def nativeConvertedMatrix (source : Layout) (mode : ScalarMode)
    (p : Parameters) (inner : ℕ) (cfg : ScalarEpilogue) (alpha beta : BitVec 32)
    (A : Matrix (BitVec source.width) m k) (B : Matrix (BitVec source.width) k n)
    (C : Matrix (BitVec 32) m n) : Option (Matrix (Option (ScaledMatrixCell cfg.output.format)) m n) := do
  let a ← convertMatrixToLayout source p.input mode A
  let b ← convertMatrixToLayout source p.input mode B
  return nativeScaledMatrix p inner cfg alpha beta a b C
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>
