# TensorCoreTests.EFT.BoundedEFT

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-7ab8f7f39dc32a3e"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.consolidation_branches</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L12)

```lean
theorem consolidation_branches :
    EFMachine.algorithm1 .v100F16 r3 0x4107ffff = .ok (.scalar 0x41080000) ∧
    EFMachine.algorithm1 .v100F16 subnormalAccumulator 0x3f800000 =
      .ok (.boundedExact 0x3f800001) ∧
    EFMachine.algorithm1 .v100F16 supportOverflow 0x4e800000 =
      .ok (.boundedExact 0x4e800003) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Error](../../Kernels/EFT/Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](../../Kernels/EFT/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Result](../../Kernels/EFT/Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.algorithm1](../../Kernels/EFT/Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Regression.r3](../TC/Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.subnormalAccumulator](EFT.md#decl-5abbb5145c17d893), [TensorCore.Regression.supportOverflow](EFT.md#decl-5b2dcd48a837249a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7cd9ddb4bc8c279c"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.zero_and_rejections</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L19)

```lean
theorem zero_and_rejections :
    EFMachine.algorithm1 .v100F16 ⟨List.replicate 4 (0, 0), 0x80000000⟩ 0x7f7fffff =
      .ok .allZero ∧
    EFMachine.algorithm1 .v100F16 ⟨[], 0⟩ 0 = .error .wrongProductCount ∧
    EFMachine.algorithm1 .v100F16 ⟨List.replicate 4 (0x7c00, 0), 0⟩ 0 = .error .nonfiniteInput ∧
    EFMachine.algorithm1 .v100F16 ⟨List.replicate 4 (0, 0), 0x7fc00000⟩ 0 = .error .nonfiniteInput ∧
    EFMachine.algorithm1 .v100F16 ⟨List.replicate 4 (0, 0), 0⟩ 0x7f800000 = .error .nonfiniteOutput ∧
    EFMachine.algorithm1 .v100F16 ⟨[(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)], 0x7f7fffff⟩ 0 =
      .ok .outOfRange := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](../../Kernels/EFT/Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](../../Kernels/EFT/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](../../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](../../Kernels/EFT/Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.algorithm1](../../Kernels/EFT/Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7b1c5dfc5773a1d1"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.wide_cancellation</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L30)

```lean
/-- Products near 2^256 cancel exactly. The scalar final input is still ordinary FP32. -/
theorem wide_cancellation :
    (EFMachine.algorithm1 .ampereBF16
      ⟨[(0x7f7f, 0x7f7f), (0xff7f, 0x7f7f)] ++ List.replicate 6 (0, 0), 0x3f800000⟩
      0xff7fffff).map Result.bits = .ok (some 0x3f800000) ∧
    (EFMachine.algorithm1 .hopperTF32Mma
      ⟨[(0x3fbff, 0x3fbff), (0x7fbff, 0x3fbff)] ++ List.replicate 6 (0, 0), 0x3f800000⟩
      0x7f7fffff).map Result.bits = .ok (some 0x3f800000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](../../Kernels/EFT/Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](../../Kernels/EFT/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](../../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](../../Kernels/EFT/Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](../../Kernels/EFT/Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](../../Kernels/EFT/Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-94ac05b809d0614c"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L39)

```lean
/-- Full gap width, negative underflow, normal carry, even ties, and range boundary. -/
theorem extraction_and_rounding_boundaries :
    (Word.split ⟨true, 1⟩ 256).low.magnitude = 1 ∧
    (Word.split ⟨false, 1⟩ 576).coarse.magnitude = 0 ∧
    (Word.round32 ⟨true, 1⟩) = some 0x80000000 ∧
    (Word.round32 ⟨false, (1 : Magnitude) <<< 122⟩) = some 0 ∧
    (Word.round32 ⟨false, (3 : Magnitude) <<< 122⟩) = some 2 ∧
    (Word.round32 ⟨false, (33554431 : Magnitude) <<< 248⟩) = some 0x40000000 ∧
    (Word.round32 ⟨false, maxMagnitude32⟩) = some 0x7f7fffff ∧
    (Word.round32 ⟨false, maxMagnitude32 + 1⟩) = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](../../Kernels/EFT/WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](../../Kernels/EFT/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](../../Kernels/EFT/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](../../Kernels/EFT/WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.split](../../Kernels/EFT/WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.WordSplit](../../Kernels/EFT/WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.maxMagnitude32](../../Kernels/EFT/WordDefs.md#decl-e1240926dd0c8785), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5787e0f814574c53"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.tiny_products</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L50)

```lean
/-- Minimum TF32 product occupies the least workspace bit; BF16 needs no host underflow. -/
theorem tiny_products :
    (EFMachine.algorithm1 .ampereTF32 ⟨[(1, 1)] ++ List.replicate 3 (0, 0), 0⟩ 0).map
      Result.bits = .ok (some 0) ∧
    (EFMachine.algorithm1 .ampereTF32 ⟨[(0x40001, 1)] ++ List.replicate 3 (0, 0), 0⟩ 0).map
      Result.bits = .ok (some 0x80000000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](../../Kernels/EFT/Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](../../Kernels/EFT/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](../../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](../../Kernels/EFT/Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](../../Kernels/EFT/Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](../../Kernels/EFT/Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e61b364a168e9302"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.single_bit_scans</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L58)

```lean
/-- Every workspace bit is a possible support boundary, including positions far
above FP32's range and shifts that cannot be represented by an eight-bit count. -/
theorem single_bit_scans : ∀ i : Fin 576,
    leadingZeros ((1 : Magnitude) <<< i.val) = BitVec.ofNat 576 (575 - i.val) ∧
    trailingZeros ((1 : Magnitude) <<< i.val) = BitVec.ofNat 576 i.val := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](../../Kernels/EFT/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.leadingZeros](../../Kernels/EFT/BitScanDefs.md#decl-dc7b8bb67a09f476), [TensorCore.EFMachine.trailingZeros](../../Kernels/EFT/BitScanDefs.md#decl-f7c3937192f344ad)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-244a495c7ceef46f"></a>

<details>
<summary><code>TensorCore.Regression.BoundedEFT.zero_and_dense_scans</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/BoundedEFT.lean#L62)

```lean
theorem zero_and_dense_scans :
    leadingZeros 0 = 576 ∧ trailingZeros 0 = 576 ∧
    leadingZeros (-1) = 0 ∧ trailingZeros (-1) = 0 ∧
    leadingZeros (((1 : Magnitude) <<< 512) + 1) = 63 ∧
    trailingZeros (((1 : Magnitude) <<< 512) + 1) = 0 ∧
    leadingZeros (((1 : Magnitude) <<< 575) + ((1 : Magnitude) <<< 288)) = 0 ∧
    trailingZeros (((1 : Magnitude) <<< 575) + ((1 : Magnitude) <<< 288)) = 288 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](../../Kernels/EFT/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.leadingZeros](../../Kernels/EFT/BitScanDefs.md#decl-dc7b8bb67a09f476), [TensorCore.EFMachine.trailingZeros](../../Kernels/EFT/BitScanDefs.md#decl-f7c3937192f344ad)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
