# TensorCore.Gemm.Specification.NativeMatrix

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a26286392090ff3e"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeMatrixCell</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeMatrix.lean#L7)

```lean
noncomputable def nativeMatrixCell (p : Parameters) (inner : ℕ)
    (pairs : List (BitVec p.input.width × BitVec p.input.width)) (c : BitVec 32) :
    Option (List (BitVec 32)) := do
  let _ ← value32 c
  let padding := if pairs.length % inner = 0 then 0 else inner - pairs.length % inner
  let instructions := pairs.length / inner + if pairs.length % inner = 0 then 0 else 1
  runGroups p c (matrixChunks p.products (instructions * (inner / p.products))
    (pairs ++ List.replicate padding (0, 0)))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a), [TensorCore.PaperSpec.runGroups](../../TC/Specification/Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeGemm_eq_paper](NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeMatrix](NativeMatrix.md#decl-faec5dc99cdd0c6d), [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeProductMatrixCell](NativeScaledMatrix.md#decl-d9bdf4b9d079ae28)

</details>

</details>

<a id="decl-faec5dc99cdd0c6d"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeMatrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeMatrix.lean#L16)

```lean
noncomputable def nativeMatrix (p : Parameters) (inner : ℕ)
    (A : Matrix (BitVec p.input.width) m k) (B : Matrix (BitVec p.input.width) k n)
    (C : Matrix (BitVec 32) m n) : Matrix (Option (List (BitVec 32))) m n :=
  Vector.ofFn fun i => Vector.ofFn fun j => nativeMatrixCell p inner
    (List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])) C[i.val][j.val]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.nativeMatrixCell](NativeMatrix.md#decl-a26286392090ff3e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeGemm_eq_paper](NativeGemmEquivalence.md#decl-0c528c944d5eb808)

</details>

</details>
