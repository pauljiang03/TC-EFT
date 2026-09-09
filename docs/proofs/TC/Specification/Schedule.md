# TensorCore.TC.Specification.Schedule

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-34d3305155927c9e"></a>

<details>
<summary><code>TensorCore.PaperSpec.runGroups</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Schedule.lean#L11)

```lean
noncomputable def runGroups (p : Parameters) : BitVec 32 →
    List (List (BitVec p.input.width × BitVec p.input.width)) → Option (List (BitVec 32))
  | _, [] => some []
  | c, group :: rest => do
    let d ← bits p ⟨group, c⟩
    let tail ← runGroups p d rest
    return d :: tail
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.lastBits](Schedule.md#decl-3bc0435f1504df60), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](../../Gemm/Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeMatrixCell](../../Gemm/Specification/NativeMatrix.md#decl-a26286392090ff3e), [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.runMatrixInstructions](../../Gemm/Specification/Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.schedule_last_eq_paper](Composition.md#decl-551846c5cac8f668)

</details>

</details>

<a id="decl-3bc0435f1504df60"></a>

<details>
<summary><code>TensorCore.PaperSpec.lastBits</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Schedule.lean#L19)

```lean
noncomputable def lastBits (p : Parameters) (c : BitVec 32)
    (groups : List (List (BitVec p.input.width × BitVec p.input.width))) : Option (BitVec 32) :=
  (runGroups p c groups).map fun ds => ds.getLast?.getD c
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.group_reversal_detected](../../Regression/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.schedule_last_eq_paper](Composition.md#decl-551846c5cac8f668)

</details>

</details>
