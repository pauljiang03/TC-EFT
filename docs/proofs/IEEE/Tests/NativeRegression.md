# TensorCore.IEEE.Tests.NativeRegression

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d52724a037d59c51"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_tie_even</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L8)

```lean
/-- An exact midpoint keeps the even low bit and reports inexact. -/
theorem native_add_tie_even :
    addWithLean .binary32 {} 0x3f800000 0x33800000 =
      ⟨0x3f800000, { inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-40fc35ae2a109a6b"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_tie_odd</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L12)

```lean
theorem native_add_tie_odd :
    addWithLean .binary32 {} 0x3f800001 0x33800000 =
      ⟨0x3f800002, { inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8130d7b95ed450eb"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_subnormals</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L16)

```lean
theorem native_add_subnormals :
    addWithLean .binary32 {} 1 1 = ⟨2, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-fef2176eaa98e50c"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_normal_boundary</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L19)

```lean
theorem native_add_normal_boundary :
    addWithLean .binary32 {} 0x007fffff 1 = ⟨0x00800000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0d24d41da51d5fb1"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_cancellation</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L22)

```lean
theorem native_add_cancellation :
    addWithLean .binary32 {} 0xbf800000 0x3f800000 = ⟨0, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9fa4ce1cfef11803"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_negative</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L25)

```lean
theorem native_add_negative :
    addWithLean .binary32 {} 0xbf800000 0xbf800000 = ⟨0xc0000000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-40190124dd527b0f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_negative_zeros</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L29)

```lean
/-- Signed-zero and exceptional paths retain the reference's full contract. -/
theorem native_add_negative_zeros :
    addWithLean .binary32 {} 0x80000000 0x80000000 = ⟨0x80000000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6bdd07b1f042e387"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_overflow_fallback</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L32)

```lean
theorem native_add_overflow_fallback :
    addWithLean .binary32 {} 0x7f7fffff 0x7f7fffff =
      ⟨0x7f800000, { overflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9347153f31158d97"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L36)

```lean
theorem native_add_nan_payload_fallback :
    addWithLean .binary32 {} 0x7fc00007 0xff800003 =
      ⟨0xffc00003, { invalid := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0431fc6ebe0197cb"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_add_directed_fallback</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L40)

```lean
theorem native_add_directed_fallback :
    addWithLean .binary32 { mode := .towardNegative } 0xbf800000 0x3f800000 =
      ⟨0x80000000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ad2f91691620f560"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_sub_cancellation</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L44)

```lean
theorem native_sub_cancellation :
    subWithLean .binary32 {} 0xbf800000 0xbf800000 = ⟨0, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.subWithLean](../NativeOperations.md#decl-9d4b383e5cf47f67)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5ca30f1420f360fe"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_sub_negative</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L47)

```lean
theorem native_sub_negative :
    subWithLean .binary32 {} 0xbf800000 0x3f800000 = ⟨0xc0000000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.subWithLean](../NativeOperations.md#decl-9d4b383e5cf47f67)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1f68d851a7407949"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L50)

```lean
theorem native_mul_half_min_subnormal :
    mulWithLean .binary32 {} 1 0x3f000000 =
      ⟨0, { underflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b3f17b64f004bbd3"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_mul_negative_underflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L54)

```lean
theorem native_mul_negative_underflow :
    mulWithLean .binary32 {} 0x80000001 0x3f000000 =
      ⟨0x80000000, { underflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9c67c207afa08825"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L58)

```lean
theorem native_mul_subnormal_exact :
    mulWithLean .binary32 {} 1 0x40000000 = ⟨2, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9156056ee2053925"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_mul_signed</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L61)

```lean
theorem native_mul_signed :
    mulWithLean .binary32 {} 0xbf800000 0x40000000 = ⟨0xc0000000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3bedd6a0f89ab144"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L64)

```lean
theorem native_mul_invalid_fallback :
    mulWithLean .binary32 {} 0 0x7f800000 =
      ⟨0x7fc00000, { invalid := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4e76972a36eefeed"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64_add_tie_even</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L68)

```lean
theorem native64_add_tie_even :
    addWithLean .binary64 {} 0x3ff0000000000000 0x3ca0000000000000 =
      ⟨0x3ff0000000000000, { inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-509dda658fbaa14b"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64_add_tie_odd</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L72)

```lean
theorem native64_add_tie_odd :
    addWithLean .binary64 {} 0x3ff0000000000001 0x3ca0000000000000 =
      ⟨0x3ff0000000000002, { inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5f0c50d4c0a7d7b8"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64_sub_cancellation</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L76)

```lean
theorem native64_sub_cancellation :
    subWithLean .binary64 {} 0xbff0000000000000 0xbff0000000000000 =
      ⟨0, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.subWithLean](../NativeOperations.md#decl-9d4b383e5cf47f67)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-18c5a84da5d728f4"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L80)

```lean
theorem native64_mul_half_min_subnormal :
    mulWithLean .binary64 {} 1 0x3fe0000000000000 =
      ⟨0, { underflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0b23ddfcd7aaaa18"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L84)

```lean
theorem native64_mul_negative_underflow :
    mulWithLean .binary64 {} 0x8000000000000001 0x3fe0000000000000 =
      ⟨0x8000000000000000, { underflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mulWithLean](../NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-264a03a8124d39b4"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L88)

```lean
theorem native64_add_overflow_fallback :
    addWithLean .binary64 {} 0x7fefffffffffffff 0x7fefffffffffffff =
      ⟨0x7ff0000000000000, { overflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../NativeOperations.md#decl-69353adf32ad8f12)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0ba4789c10c4d857"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native_nan_payload_differs</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/NativeRegression.lean#L94)

```lean
/-- Directly replacing payload-preserving arithmetic by a native value would
change an observable result; the wrapper must keep this reference path. -/
theorem native_nan_payload_differs :
    (Float32.ofBits 0x7fc00007).toBits.toNat ≠
      (add .binary32 {} 0x7fc00007 0).bits.toNat := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](../Operations.md#decl-7e1f336bdb43c1b4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
