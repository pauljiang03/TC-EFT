# TensorCoreTests.EFT.EncodedEFT

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5458dc9dc7e0d9ae"></a>

<details>
<summary><code>TensorCore.Regression.encoded_eft_branches</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EncodedEFT.lean#L12)

```lean
theorem encoded_eft_branches :
    algorithm1Encoded r3 0x4107ffff = .ok (.consolidated (.scalar 0x41080000)) ∧
    algorithm1Encoded subnormalAccumulator 0x3f800000 =
      .ok (.consolidated (.exactReference 0x3f800001)) ∧
    algorithm1Encoded supportOverflow 0x4e800000 =
      .ok (.consolidated (.exactReference 0x4e800003)) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](../../EFT/Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.EncodedEFTResult](../../EFT/Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.r3](../TC/Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.subnormalAccumulator](EFT.md#decl-5abbb5145c17d893), [TensorCore.Regression.supportOverflow](EFT.md#decl-5b2dcd48a837249a), [TensorCore.algorithm1Encoded](../../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-84a376d9133b92c7"></a>

<details>
<summary><code>TensorCore.Regression.encoded_eft_all_zero</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EncodedEFT.lean#L20)

```lean
/-- Signed zero and even an unrelated finite supplied D take the paper's +0 shortcut. -/
theorem encoded_eft_all_zero :
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0x80000000⟩ : V100Input) 0x80000000 =
      .ok .allZero ∧
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0⟩ : V100Input) 0x7f7fffff =
      .ok .allZero ∧
    EncodedEFTResult.allZero.bits = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](../../EFT/Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EncodedEFTResult](../../EFT/Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.EncodedEFTResult.bits](../../EFT/Encoded.md#decl-6b8e900329461f5a), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.algorithm1Encoded](../../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3c8a2a316485713c"></a>

<details>
<summary><code>TensorCore.Regression.encoded_eft_nonzero_c</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EncodedEFT.lean#L28)

```lean
/-- The accumulator is included in the all-zero test; arbitrary finite D is permitted. -/
theorem encoded_eft_nonzero_c :
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0x3f800000⟩ : V100Input) 0x40000000 =
      .ok (.consolidated (.scalar 0x3f800000)) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](../../EFT/Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EncodedEFTResult](../../EFT/Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.algorithm1Encoded](../../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-277a69997e7c7a84"></a>

<details>
<summary><code>TensorCore.Regression.encoded_eft_cancellation</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EncodedEFT.lean#L33)

```lean
/-- Nonzero terms cancelling to zero still execute consolidation. -/
theorem encoded_eft_cancellation :
    algorithm1Encoded (⟨[(0x3c00, 0x3c00), (0xbc00, 0x3c00), (0, 0), (0, 0)], 0⟩ :
      V100Input) 0 = .ok (.consolidated (.scalar 0)) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](../../EFT/Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EncodedEFTResult](../../EFT/Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.algorithm1Encoded](../../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-95e3c5cfb683c2bf"></a>

<details>
<summary><code>TensorCore.Regression.encoded_eft_rejections</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EncodedEFT.lean#L37)

```lean
theorem encoded_eft_rejections :
    algorithm1Encoded (⟨[], 0⟩ : V100Input) 0 = .error .wrongProductCount ∧
    algorithm1Encoded (⟨List.replicate 4 (0x7c00, 0), 0⟩ : V100Input) 0 = .error .nonfiniteInput ∧
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0x7fc00000⟩ : V100Input) 0 =
      .error .nonfiniteInput ∧
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0⟩ : V100Input) 0x7f800000 =
      .error .nonfiniteOutput ∧
    algorithm1Encoded (⟨[(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)], 0x7f7fffff⟩ :
      V100Input) 0 = .ok (.consolidated .outOfRange) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](../../EFT/Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EncodedEFTResult](../../EFT/Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.algorithm1Encoded](../../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-83fcbe1b52439ce7"></a>

<details>
<summary><code>TensorCore.Regression.encoded_v100_not_monotone</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EncodedEFT.lean#L48)

```lean
/-- Definition III.2 on actual FP32 words: decreasing c raises the V100 output. -/
theorem encoded_v100_not_monotone :
    ¬ MonotoneInEncodedAccumulator v100F16F32 (List.replicate 4 (0x0c00, 0x0c00)) := by
  intro h
  have hbad := h 0x3f800000 0x3f7fffff 1 (1 - pow2 (-24)) 1 (1 + pow2 (-23))
    (by decide +kernel) (by decide +kernel) (by decide +kernel) (by decide +kernel)
    (by decide +kernel)
  have hn : ¬ (1 + pow2 (-23) : ℚ) ≤ 1 := by decide +kernel
  exact hn hbad
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.MonotoneInEncodedAccumulator](../../TC/EncodedMonotonicity.md#decl-2fe557d3c0f04019), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.encodedBlockValue](../../TC/EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
