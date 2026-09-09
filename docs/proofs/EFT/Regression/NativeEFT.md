# TensorCore.EFT.Regression.NativeEFT

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3071ab2d5754b0bc"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.signed_zeros</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L11)

```lean
theorem signed_zeros : add32WithLean 0x80000000 0x80000000 = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0d3f5bc8fb58156f"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.zero_then_negative</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L13)

```lean
theorem zero_then_negative : add32WithLean 0 0xbf800000 = some 0xbf800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-930dda5cb1894be0"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.cancellation</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L15)

```lean
theorem cancellation : add32WithLean 0x3f800000 0xbf800000 = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-720a137e57ae3e91"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.subnormal_boundary</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L17)

```lean
theorem subnormal_boundary : add32WithLean 0x007fffff 1 = some 0x00800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-48dab98648ef1601"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.tie_even</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L19)

```lean
theorem tie_even : add32WithLean 0x3f800000 0x33800000 = some 0x3f800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-da66c5c7c6f4fdb9"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.tie_odd</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L21)

```lean
theorem tie_odd : add32WithLean 0x3f800001 0x33800000 = some 0x3f800002 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1dae0023c1d953c1"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.every_step_rounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L24)

```lean
/-- Each addition rounds, so two separately lost half-ULPs do not accumulate. -/
theorem every_step_rounds :
    naiveSum32WithLeanFrom 0 [0x3f800000, 0x33800000, 0x33800000] = some 0x3f800000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.naiveSum32WithLeanFrom](../Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-28c95db87f81e51e"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.order_loses_one</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L28)

```lean
theorem order_loses_one :
    naiveSum32WithLeanFrom 0 [0x4b800000, 0x3f800000, 0xcb800000] = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.naiveSum32WithLeanFrom](../Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7140319c6bf416e5"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.order_keeps_one</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L31)

```lean
theorem order_keeps_one :
    naiveSum32WithLeanFrom 0 [0x4b800000, 0xcb800000, 0x3f800000] = some 0x3f800000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.naiveSum32WithLeanFrom](../Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c73a68794427db72"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.exact_residual_sum</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L35)

```lean
theorem exact_residual_sum :
    naiveSum32WithLeanFrom 0 [0x3f800000, 0xbf000000, 0x3e800000] = some 0x3f400000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.naiveSum32WithLeanFrom](../Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-cf11a49dc1ee98a2"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.exact_range_rejection</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L41)

```lean
/-- The finite EFT contract rejects even an exact sum just above maxFinite that
ordinary IEEE nearest-even arithmetic could round back to maxFinite. -/
theorem exact_range_rejection : add32WithLean 0x7f7fffff 0x3f800000 = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a559ac394785e8f8"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.intermediate_range_rejection</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L43)

```lean
theorem intermediate_range_rejection :
    naiveSum32WithLeanFrom 0 [0x7f7fffff, 0x7f7fffff, 0xff7fffff] = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.naiveSum32WithLeanFrom](../Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-973f944c128871db"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.nonfinite_rejection</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L46)

```lean
theorem nonfinite_rejection : add32WithLean 0 0x7f800000 = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1dc392af8475ca8d"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.nan_rejection</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L48)

```lean
theorem nan_rejection : add32WithLean 0x7fc00007 0 = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8bc682481480e65b"></a>

<details>
<summary><code>TensorCore.Regression.NativeEFT.single_v100_corrected</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/NativeEFT.lean#L50)

```lean
theorem single_v100_corrected :
    algorithm1WithLean .v100F16
      ⟨[(0x3e00, 0x3d00), (0x3e00, 0x3d00), (0x3e00, 0x3d00), (0x3e00, 0x3d00)],
        0x3f7fffff⟩ 0x4107ffff = .ok (.scalar 0x41080000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](../Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](../Machine/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](../Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](../Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.algorithm1WithLean](../Native.md#decl-e854b34f0fadc9c3), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
