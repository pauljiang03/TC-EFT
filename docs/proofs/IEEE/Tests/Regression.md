# TensorCore.IEEE.Tests.Regression

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e5e12c7f2e5ab943"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.rn</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L8)

```lean
def rn : Context := ⟨.nearestEven, .afterRounding⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Regression.fused_single_rounding](Regression.md#decl-7b5a3ce3bbe533ba), [TensorCore.IEEE.Regression.fused_without_intermediate_overflow](Regression.md#decl-3089d50d2664c88b), [TensorCore.IEEE.Regression.gradual_underflow](Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.nan_payload_conversion](Regression.md#decl-c125c286409c41d9), [TensorCore.IEEE.Regression.near_overflow](Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.nonfinite_and_payload](Regression.md#decl-3e3bfb1038fb1ac0), [TensorCore.IEEE.Regression.normal_output_underflow](Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.sticky_flags](Regression.md#decl-6f46397e23c85174), [TensorCore.IEEE.Regression.tininess_choice](Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.Regression.zero_signs](Regression.md#decl-c69dca8aa8f614cd)

</details>

</details>

<a id="decl-8c8fb3d8f0c7300e"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.rz</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L9)

```lean
def rz : Context := ⟨.towardZero, .afterRounding⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Regression.near_overflow](Regression.md#decl-c37522c37f5d3371)

</details>

</details>

<a id="decl-881e982d251120cb"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.rd</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L10)

```lean
def rd : Context := ⟨.towardNegative, .afterRounding⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Regression.directed_overflow](Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.fused_zero_sign](Regression.md#decl-a4e45279d595ebe5), [TensorCore.IEEE.Regression.zero_signs](Regression.md#decl-c69dca8aa8f614cd)

</details>

</details>

<a id="decl-5771e8ec4435398b"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.ru</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L11)

```lean
def ru : Context := ⟨.towardPositive, .afterRounding⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Regression.directed_overflow](Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.gradual_underflow](Regression.md#decl-27e28c5348b13b43)

</details>

</details>

<a id="decl-c37522c37f5d3371"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.near_overflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L14)

```lean
theorem near_overflow :
    round .binary16 rn false 65505 = ⟨0x7bff, { inexact := true }⟩ ∧
    round .binary16 rn false 65520 = ⟨0x7c00, { overflow := true, inexact := true }⟩ ∧
    round .binary16 rz false 65535 = ⟨0x7bff, { inexact := true }⟩ ∧
    round .binary16 rz false 65536 = ⟨0x7bff, { overflow := true, inexact := true }⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Regression.rz](Regression.md#decl-8c8fb3d8f0c7300e), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.round](../Rounding.md#decl-e686eb7fa2b669b5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3cdb81d46e18700a"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.directed_overflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L21)

```lean
theorem directed_overflow :
    round .binary16 rd false (-65505) = ⟨0xfc00, { overflow := true, inexact := true }⟩ ∧
    round .binary16 ru false (-65536) = ⟨0xfbff, { overflow := true, inexact := true }⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rd](Regression.md#decl-881e982d251120cb), [TensorCore.IEEE.Regression.ru](Regression.md#decl-5771e8ec4435398b), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.round](../Rounding.md#decl-e686eb7fa2b669b5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-677cac92c14a8565"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.normal_output_underflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L27)

```lean
theorem normal_output_underflow :
    round .binary16 rn false (pow2 (-14) - 3 * pow2 (-27)) =
      ⟨0x0400, { underflow := true, inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.round](../Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0c40571e865c8290"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.tininess_choice</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L31)

```lean
theorem tininess_choice :
    round .binary16 ⟨.nearestEven, .beforeRounding⟩ false (pow2 (-14) - pow2 (-27)) =
      ⟨0x0400, { underflow := true, inexact := true }⟩ ∧
    round .binary16 rn false (pow2 (-14) - pow2 (-27)) =
      ⟨0x0400, { inexact := true }⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.round](../Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-27e28c5348b13b43"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.gradual_underflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L37)

```lean
theorem gradual_underflow :
    round .binary16 rn false (pow2 (-24)) = ⟨1, {}⟩ ∧
    round .binary16 rn false (pow2 (-25)) = ⟨0, { underflow := true, inexact := true }⟩ ∧
    round .binary16 rn false (-pow2 (-25)) = ⟨0x8000, { underflow := true, inexact := true }⟩ ∧
    round .binary16 ru false (pow2 (-25)) = ⟨1, { underflow := true, inexact := true }⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Regression.ru](Regression.md#decl-5771e8ec4435398b), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.round](../Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c69dca8aa8f614cd"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.zero_signs</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L44)

```lean
theorem zero_signs :
    convert .binary64 .binary16 rn 0x8000000000000000 = ⟨0x8000, {}⟩ ∧
    add .binary32 rn 0x80000000 0x80000000 = ⟨0x80000000, {}⟩ ∧
    add .binary32 rd 0 0x80000000 = ⟨0x80000000, {}⟩ ∧
    add .binary32 rn 0 0x80000000 = ⟨0, {}⟩ ∧
    mul .binary32 rn 0x80000000 0xbf800000 = ⟨0, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rd](Regression.md#decl-881e982d251120cb), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](../Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.convert](../Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.mul](../Operations.md#decl-c121f20d96d6a64e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a4e45279d595ebe5"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.fused_zero_sign</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L51)

```lean
theorem fused_zero_sign :
    fma .binary64 rd 0x3ff0000000000000 0x3ff0000000000000 0xbff0000000000000 =
      ⟨0x8000000000000000, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rd](Regression.md#decl-881e982d251120cb), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.fma](../Operations.md#decl-5173f8a4ff82ac61)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3089d50d2664c88b"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.fused_without_intermediate_overflow</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L55)

```lean
theorem fused_without_intermediate_overflow :
    fma .binary64 rn 0x7fefffffffffffff 0x4000000000000000 0xffefffffffffffff =
      ⟨0x7fefffffffffffff, {}⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.fma](../Operations.md#decl-5173f8a4ff82ac61)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7b5a3ce3bbe533ba"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.fused_single_rounding</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L59)

```lean
theorem fused_single_rounding :
    fma .binary32 rn 0x3f800001 0x3f7ffffe 0xbf800000 = ⟨0xa8800000, {}⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.fma](../Operations.md#decl-5173f8a4ff82ac61)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3e3bfb1038fb1ac0"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.nonfinite_and_payload</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L63)

```lean
theorem nonfinite_and_payload :
    add .binary32 rn 0x7f800000 0xff800000 = ⟨0x7fc00000, { invalid := true }⟩ ∧
    mul .binary32 rn 0x80000000 0x7f800000 = ⟨0x7fc00000, { invalid := true }⟩ ∧
    add .binary32 rn 0x7fc12345 0xff800007 = ⟨0xffc00007, { invalid := true }⟩ ∧
    add .binary32 rn 0x7fc12345 0x7f800000 = ⟨0x7fc12345, {}⟩ ∧
    fma .binary32 rn 0 0x7f800000 0x7fc12345 = ⟨0x7fc12345, { invalid := true }⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](../Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.fma](../Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.mul](../Operations.md#decl-c121f20d96d6a64e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c125c286409c41d9"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.nan_payload_conversion</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L71)

```lean
theorem nan_payload_conversion :
    convert .binary16 .binary64 rn 0xfe01 = ⟨0xfff8040000000000, {}⟩ ∧
    convert .binary16 .binary32 rn 0x7c01 = ⟨0x7fc02000, { invalid := true }⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result](../Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](../Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.convert](../Operations.md#decl-4f62188c5500d3b7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6f46397e23c85174"></a>

<details>
<summary><code>TensorCore.IEEE.Regression.sticky_flags</code></summary>

[Lean source](../../../../TensorCore/IEEE/Tests/Regression.lean#L76)

```lean
theorem sticky_flags :
    (round .binary16 rn false 65505).accumulate { invalid := true, underflow := true } =
      { invalid := true, underflow := true, inexact := true } := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](../Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Flags](../Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Regression.rn](Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Result.accumulate](../Basic.md#decl-e2a38f7ec363b4bf), [TensorCore.IEEE.round](../Rounding.md#decl-e686eb7fa2b669b5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
