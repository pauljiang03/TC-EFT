# TensorCore.Kernels.EFT.BitScanDefs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c67168584d6cebcb"></a>

<details>
<summary><code>TensorCore.EFMachine.scanBoundary</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/BitScanDefs.lean#L9)

```lean
def scanBoundary (test : ℕ → Bool) : ℕ → ℕ → ℕ → ℕ
  | 0, lo, _ => lo
  | fuel + 1, lo, hi =>
    if lo < hi then
      let mid := (lo + hi) / 2
      if test mid then scanBoundary test fuel (mid + 1) hi
      else scanBoundary test fuel lo mid
    else lo
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.leadingZeros](BitScanDefs.md#decl-dc7b8bb67a09f476), [TensorCore.EFMachine.leadingZeros_eq](BitScan.md#decl-6a874aca0a7bf352), [TensorCore.EFMachine.scanBoundaryTrace_result](BitScan.md#decl-eb1ad31b2f0a011c), [TensorCore.EFMachine.scanBoundary_correct](BitScan.md#decl-613a0696640783fc), [TensorCore.EFMachine.trailingZeros](BitScanDefs.md#decl-f7c3937192f344ad), [TensorCore.EFMachine.trailingZeros_eq](BitScan.md#decl-e84601fe6258d42b)

</details>

</details>

<a id="decl-dc7b8bb67a09f476"></a>

<details>
<summary><code>TensorCore.EFMachine.leadingZeros</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/BitScanDefs.lean#L18)

```lean
def leadingZeros (m : BitVec 576) : BitVec 576 :=
  576 - BitVec.ofNat 576 (scanBoundary (fun n => (m >>> n) != 0) 10 0 576)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.scanBoundary](BitScanDefs.md#decl-c67168584d6cebcb)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.leadingZeros_eq](BitScan.md#decl-6a874aca0a7bf352), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a), [TensorCore.Regression.BoundedEFT.single_bit_scans](../../Tests/EFT/BoundedEFT.md#decl-e61b364a168e9302), [TensorCore.Regression.BoundedEFT.zero_and_dense_scans](../../Tests/EFT/BoundedEFT.md#decl-244a495c7ceef46f)

</details>

</details>

<a id="decl-f7c3937192f344ad"></a>

<details>
<summary><code>TensorCore.EFMachine.trailingZeros</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/BitScanDefs.lean#L21)

```lean
def trailingZeros (m : BitVec 576) : BitVec 576 :=
  BitVec.ofNat 576 (scanBoundary (fun n => m.setWidth (n + 1) == 0) 10 0 576)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.scanBoundary](BitScanDefs.md#decl-c67168584d6cebcb)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.trailingZeros_eq](BitScan.md#decl-e84601fe6258d42b), [TensorCore.Regression.BoundedEFT.single_bit_scans](../../Tests/EFT/BoundedEFT.md#decl-e61b364a168e9302), [TensorCore.Regression.BoundedEFT.zero_and_dense_scans](../../Tests/EFT/BoundedEFT.md#decl-244a495c7ceef46f)

</details>

</details>
