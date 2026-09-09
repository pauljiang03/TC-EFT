# TensorCore.Gemm.Specification.NativeGemmEquivalence

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-09f18a2164359124"></a>

<details>
<summary><code>TensorCore.PaperSpec.native_parameters</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeGemmEquivalence.lean#L9)

```lean
theorem native_parameters (model : NativeGemmModel p) :
    parametersOf model.profile = (match p, model with
      | .bf16, .ampere => parameters .ampereBF16
      | .bf16, .hopper => parameters .hopperBF16
      | .tf32, .ampere => parameters .ampereTF32
      | .tf32, .hopper => parameters .hopperTF32Wmma
      | .tf32, .hopperMma => parameters .hopperTF32Mma) := by
  cases p <;> cases model <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](../NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Path](../../TC/Specification/Profiles.md#decl-4e0e2e5d21f848a7), [TensorCore.PaperSpec.parameters](../../TC/Specification/Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ad9e45da7765a5c5"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeGemmCell_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeGemmEquivalence.lean#L18)

```lean
theorem nativeGemmCell_eq_paper (model : NativeGemmModel p)
    (pairs : List (NativeWord p × NativeWord p)) (c : F32) :
    (nativeGemmCell model pairs c).map (fun cell => cell.blocks.map fun t => t.output.bits) =
      nativeMatrixCell (parametersOf model.profile) p.inner pairs c := by
  have hg := runBlocks_eq_paper model.profile c (nativeBlocks model pairs)
  have hs : nativeBlocks model pairs = matrixChunks model.profile.products
      ((pairs.length / p.inner + if pairs.length % p.inner = 0 then 0 else 1) *
        (p.inner / model.products))
      (pairs ++ List.replicate (if pairs.length % p.inner = 0 then 0 else p.inner - pairs.length % p.inner) (0, 0)) := by
    simp only [nativeBlocks, nativePartition, partitionExact_inputs_chunks, chunks_eq_matrixChunks,
      nativePadded, groupCount, tailPadding]
  unfold nativeMatrixCell
  rw [matrix_value32_finite]
  cases hf : finite32 c with
  | none => simp [nativeGemmCell, hf]
  | some initial =>
    simp only [Option.map_some, bind, Option.bind_some]
    calc
      _ = runGroups (parametersOf model.profile) c (nativeBlocks model pairs) := by
        rw [← hg]
        cases hr : runBlocks model.profile c (nativeBlocks model pairs) <;>
          simp [nativeGemmCell, hf, hr, Except.toOption]
      _ = _ := congrArg (fun (gs : List (List (NativeWord p × NativeWord p))) =>
        runGroups (parametersOf model.profile) c gs) hs
```

**Supporting proofs:** [TensorCore.PaperSpec.chunks_eq_matrixChunks](GemmEquivalence.md#decl-d259480c970e3a94), [TensorCore.PaperSpec.matrix_value32_finite](GemmEquivalence.md#decl-9ce8d5ea689e94d1), [TensorCore.PaperSpec.partitionExact_inputs_chunks](GemmEquivalence.md#decl-2c86a9b78704d3ca), [TensorCore.PaperSpec.runBlocks_eq_paper](../../TC/Specification/Composition.md#decl-eaffa3538905399a)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](../NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](../NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.OrderedPartition.inputs](../../TC/Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a), [TensorCore.PaperSpec.nativeMatrixCell](NativeMatrix.md#decl-a26286392090ff3e), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.runGroups](../../TC/Specification/Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.chunks](../../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.groupCount](../../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.nativeBlocks](../NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativePartition](../NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.partitionExact](../../TC/Program/Partition.md#decl-4082e3bf596a58d7), [TensorCore.runBlocks](../../TC/Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeGemm_eq_paper](NativeGemmEquivalence.md#decl-0c528c944d5eb808), [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe)

</details>

</details>

<a id="decl-0c528c944d5eb808"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeGemm_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeGemmEquivalence.lean#L44)

```lean
theorem nativeGemm_eq_paper (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) :
    (nativeGemm model A B C).map (fun row => row.map fun cell =>
      cell.map fun t => t.blocks.map fun b => b.output.bits) =
      nativeMatrix (parametersOf model.profile) p.inner A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [nativeGemm, DenseMatrix.ofFn, nativeMatrix, Vector.getElem_map, Vector.getElem_ofFn]
  exact nativeGemmCell_eq_paper model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩) C[i][j]
```

**Supporting proofs:** [TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](../NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.nativeMatrix](NativeMatrix.md#decl-faec5dc99cdd0c6d), [TensorCore.PaperSpec.nativeMatrixCell](NativeMatrix.md#decl-a26286392090ff3e), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.nativeGemm](../NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativePairs](../NativeGemm.md#decl-160e768b2358c84f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
