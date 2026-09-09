# TensorCore.Gemm.Regression.GemmFamily

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e34f5ac08cbdf2e5"></a>

<details>
<summary><code>TensorCore.Regression.unitFamily</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L10)

```lean
def unitFamily : GemmFamily := ⟨1, 1, 1⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1)

<details>
<summary>Used by</summary>

[TensorCore.Regression.family_membership_signed_subnormal](GemmFamily.md#decl-a3201c4c5fa5173c), [TensorCore.Regression.family_witness_controls](GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.unitFamilyWitness](GemmFamily.md#decl-6f4d7edf02c5d4d3), [TensorCore.Regression.unit_family_accuracy](GemmFamily.md#decl-276ef0fbf20b36cf)

</details>

</details>

<a id="decl-6f4d7edf02c5d4d3"></a>

<details>
<summary><code>TensorCore.Regression.unitFamilyWitness</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L11)

```lean
def unitFamilyWitness (model : WmmaGemmModel) : GemmBoundConfig :=
  (inferFamily model 17 unitFamily).getD ⟨0, 0, 0, 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.Regression.unitFamily](GemmFamily.md#decl-e34f5ac08cbdf2e5), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.inferFamily](../Family.md#decl-868633a6b6bbc848)

<details>
<summary>Used by</summary>

[TensorCore.Regression.family_witness_controls](GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.unit_family_accuracy](GemmFamily.md#decl-276ef0fbf20b36cf)

</details>

</details>

<a id="decl-276ef0fbf20b36cf"></a>

<details>
<summary><code>TensorCore.Regression.unit_family_accuracy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L14)

```lean
theorem unit_family_accuracy (model : WmmaGemmModel) :
    GemmFamilyAccurate model unitFamily 2 3 17 (1 / 100) := by
  apply familyCheck_sound model unitFamily (unitFamilyWitness model)
  cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.familyCheck_sound](../Family.md#decl-f329ec5471dc4d5e)

**Definitions and types:** [TensorCore.GemmFamilyAccurate](../Family.md#decl-6a51b2e27db67ff4), [TensorCore.Regression.unitFamily](GemmFamily.md#decl-e34f5ac08cbdf2e5), [TensorCore.Regression.unitFamilyWitness](GemmFamily.md#decl-6f4d7edf02c5d4d3), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyCheck](../Family.md#decl-43a043749bf35c52)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a3201c4c5fa5173c"></a>

<details>
<summary><code>TensorCore.Regression.family_membership_signed_subnormal</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L19)

```lean
theorem family_membership_signed_subnormal :
    unitFamily.Contains (#v[#v[0x8001, 0xbc00, 0x8000]] : DenseMatrix F16 1 3)
      (#v[#v[1], #v[0x3c00], #v[0]] : DenseMatrix F16 3 1)
      (#v[#v[0x80000000]] : DenseMatrix F32 1 1) := by
  refine ⟨?_, ?_, ?_⟩
  · intro i j
    refine ⟨((classify fp16 (#v[#v[0x8001, 0xbc00, 0x8000]] : DenseMatrix F16 1 3)[i.val][j.val]).finite).getD ⟨0, 0, 0⟩, ?_⟩
    revert i j
    decide +kernel
  · intro i j
    refine ⟨((classify fp16 (#v[#v[1], #v[0x3c00], #v[0]] : DenseMatrix F16 3 1)[i.val][j.val]).finite).getD ⟨0, 0, 0⟩, ?_⟩
    revert i j
    decide +kernel
  · intro i j
    refine ⟨⟨0, 0, 0⟩, ?_⟩
    revert i j
    decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](../Family.md#decl-eaee8494d54b2afc), [TensorCore.MatrixWithin](../Family.md#decl-71221945e17a1cdc), [TensorCore.Regression.unitFamily](GemmFamily.md#decl-e34f5ac08cbdf2e5), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4b7acaae99672922"></a>

<details>
<summary><code>TensorCore.Regression.family_witness_controls</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L37)

```lean
theorem family_witness_controls :
    familyCheck .v100 17 unitFamily ⟨-126, 0, 3, 1⟩ 1 = false ∧
    familyCheck .v100 17 unitFamily ⟨7, -1, 3, 1⟩ 1 = false ∧
    familyCheck .v100 17 unitFamily ⟨7, 0, 0, 1⟩ 1 = false ∧
    familyCheck .v100 17 unitFamily (unitFamilyWitness .v100) 0 = false ∧
    (inferFamily .v100 17 ⟨65504, 65504, fp32.maxFinite⟩).isSome = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.Regression.unitFamily](GemmFamily.md#decl-e34f5ac08cbdf2e5), [TensorCore.Regression.unitFamilyWitness](GemmFamily.md#decl-6f4d7edf02c5d4d3), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyCheck](../Family.md#decl-43a043749bf35c52), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.inferFamily](../Family.md#decl-868633a6b6bbc848)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-df50441d5d2cb648"></a>

<details>
<summary><code>TensorCore.Regression.empty_family_accuracy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L44)

```lean
theorem empty_family_accuracy :
    GemmFamilyAccurate .hopper ⟨0, 0, fp32.maxFinite⟩ 2 2 0 0 := by
  apply familyCheck_sound .hopper _ ⟨0, 0, 0, 0⟩
  decide +kernel
```

**Supporting proofs:** [TensorCore.familyCheck_sound](../Family.md#decl-f329ec5471dc4d5e)

**Definitions and types:** [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamilyAccurate](../Family.md#decl-6a51b2e27db67ff4), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyCheck](../Family.md#decl-43a043749bf35c52), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-604135b609aa95d6"></a>

<details>
<summary><code>TensorCore.Regression.family_subnormal_scales</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmFamily.lean#L49)

```lean
theorem family_subnormal_scales :
    familyOperandScale (pow2 (-24)) = -14 ∧
    familyOperandScale 1 = 0 ∧ familyOperandScale 65504 = 15 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.familyOperandScale](../Family.md#decl-c5db35b2aa0f8491), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
