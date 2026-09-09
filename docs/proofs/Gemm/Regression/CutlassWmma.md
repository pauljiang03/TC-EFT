# TensorCore.Gemm.Regression.CutlassWmma

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a585f914d026a68b"></a>

<details>
<summary><code>TensorCore.Regression.cutlassWord</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L10)

```lean
def cutlassWord (index : ℕ) : F16 :=
  match index % 5 with | 0 => 0 | 1 => 0x3c00 | 2 => 0xbc00 | 3 => 0x3800 | _ => 0xb800
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cutlassA](CutlassWmma.md#decl-6f12ec59212c07f6), [TensorCore.Regression.cutlassB](CutlassWmma.md#decl-cc6d34d8ad6c7add)

</details>

</details>

<a id="decl-6f12ec59212c07f6"></a>

<details>
<summary><code>TensorCore.Regression.cutlassA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L13)

```lean
def cutlassA : DenseMatrix F16 65 32 := DenseMatrix.ofFn fun i l => cutlassWord (i.val + l.val)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Regression.cutlassWord](CutlassWmma.md#decl-a585f914d026a68b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cutlass_fixture_connection](CutlassWmma.md#decl-e2a0bcb3a499b023)

</details>

</details>

<a id="decl-cc6d34d8ad6c7add"></a>

<details>
<summary><code>TensorCore.Regression.cutlassB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L14)

```lean
def cutlassB : DenseMatrix F16 32 67 := DenseMatrix.ofFn fun l j => cutlassWord (l.val + 3 * j.val)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Regression.cutlassWord](CutlassWmma.md#decl-a585f914d026a68b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cutlass_fixture_connection](CutlassWmma.md#decl-e2a0bcb3a499b023)

</details>

</details>

<a id="decl-45c4e75f7456872b"></a>

<details>
<summary><code>TensorCore.Regression.cutlassC</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L15)

```lean
def cutlassC : DenseMatrix F32 65 67 := DenseMatrix.ofFn fun _ _ => 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cutlass_fixture_connection](CutlassWmma.md#decl-e2a0bcb3a499b023)

</details>

</details>

<a id="decl-e53c82c122ea1f6d"></a>

<details>
<summary><code>TensorCore.Regression.cutlass_coordinates</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L18)

```lean
/-- Both CTA boundaries, all four warp positions, and K iteration coordinates. -/
theorem cutlass_coordinates :
    CutlassWmma.warpOf 32 32 = 3 ∧ CutlassWmma.warpOf 64 66 = 0 ∧
    CutlassWmma.outputRow 1 0 0 = 64 ∧ CutlassWmma.outputCol 1 0 2 = 66 ∧
    CutlassWmma.addressA 32 64 31 = 2079 ∧ CutlassWmma.addressB 32 31 66 = 2143 ∧
    CutlassWmma.addressD 67 64 66 = 4354 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CutlassWmma.addressA](../Kernels/CutlassWmma.md#decl-f24d2711d55bb49a), [TensorCore.CutlassWmma.addressB](../Kernels/CutlassWmma.md#decl-321f0efe41b36f2f), [TensorCore.CutlassWmma.addressD](../Kernels/CutlassWmma.md#decl-2fabf10b25b488c7), [TensorCore.CutlassWmma.outputCol](../Kernels/CutlassWmma.md#decl-2a37779a83662108), [TensorCore.CutlassWmma.outputRow](../Kernels/CutlassWmma.md#decl-b5544610edcfb7a2), [TensorCore.CutlassWmma.warpOf](../Kernels/CutlassWmma.md#decl-ef24333303142de0)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e2a0bcb3a499b023"></a>

<details>
<summary><code>TensorCore.Regression.cutlass_fixture_connection</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L26)

```lean
/-- The full fixture is compared independently by check_cutlass.py; the kernel
checks the complete matrix connection for the same 65×67, K=32 inputs. -/
theorem cutlass_fixture_connection :
    CutlassWmma.project (tiles := 2) cutlassA cutlassB = (gemm .v100 cutlassA cutlassB cutlassC).map
      (fun row => row.map fun cell => cell.toOption.map PaperSpec.gemmCellObservation) :=
  CutlassWmma.project_eq_gemm (tiles := 2) cutlassA cutlassB
```

**Supporting proofs:** [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842)

**Definitions and types:** [TensorCore.CutlassWmma.project](../Kernels/CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.MatrixCell](../Specification/Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](../Specification/GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.Regression.cutlassA](CutlassWmma.md#decl-6f12ec59212c07f6), [TensorCore.Regression.cutlassB](CutlassWmma.md#decl-cc6d34d8ad6c7add), [TensorCore.Regression.cutlassC](CutlassWmma.md#decl-45c4e75f7456872b), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2f7d0809e7afac71"></a>

<details>
<summary><code>TensorCore.Regression.cutlassPartialPairs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L31)

```lean
def cutlassPartialPairs : List (F16 × F16) := List.ofFn fun i : Fin 17 =>
  (if i.val = 0 then 0x3c00 else if i.val = 3 then 0xbc00 else if i.val = 4 then 1 else 0, 0x3c00)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cutlass_partial_k_differs](CutlassWmma.md#decl-dd106a85bafc0aee)

</details>

</details>

<a id="decl-dd106a85bafc0aee"></a>

<details>
<summary><code>TensorCore.Regression.cutlass_partial_k_differs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/CutlassWmma.lean#L36)

```lean
/-- Residue-first (one pair, then sixteen) and tail padding change numerical bits.
The extra zeros model unused slots in the first WMMA tile, not extra operands. -/
theorem cutlass_partial_k_differs :
    ((simulateGemmCell .v100 cutlassPartialPairs 0).toOption.map fun t => t.output.bits) =
      some 0x33800000 ∧
    ((simulateGemmCell .v100 (cutlassPartialPairs.take 1 ++ List.replicate 15 (0, 0) ++
      cutlassPartialPairs.drop 1) 0).toOption.map fun t => t.output.bits) = some 0 ∧
    17 % 16 ≠ 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.cutlassPartialPairs](CutlassWmma.md#decl-2f7d0809e7afac71), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.simulateGemmCell](../Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
