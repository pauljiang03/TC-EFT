# TensorCore.Scalar.LeanBridge

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0fe78f96e2dccae0"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.Native32Valid</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L14)

```lean
/-- Lean's representation permits every non-NaN encoding and one canonical NaN. -/
abbrev Native32Valid (bits : F32) : Prop := Float.Model.Format.binary32.Valid bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.from_toNative32](LeanBridge.md#decl-bcf43c7c2dabc0e2), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeMul32](LeanBridge.md#decl-93b4e43615f002f9), [TensorCore.IEEE.LeanBridge.nativeSub32](LeanBridge.md#decl-d866a0a10fc49206), [TensorCore.IEEE.LeanBridge.toNative32](LeanBridge.md#decl-2ae82772b2af06ec)

</details>

</details>

<a id="decl-2ae82772b2af06ec"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.toNative32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L18)

```lean
/-- No arithmetic or rounding occurs in this adapter; the proof guards Lean's
canonical-NaN representation invariant. -/
def toNative32 (bits : F32) (h : Native32Valid bits) : Float32 :=
  .ofModel ⟨UInt32.ofBitVec bits, h⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.from_toNative32](LeanBridge.md#decl-bcf43c7c2dabc0e2), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeMul32](LeanBridge.md#decl-93b4e43615f002f9), [TensorCore.IEEE.LeanBridge.nativeSub32](LeanBridge.md#decl-d866a0a10fc49206), [TensorCore.IEEE.LeanBridge.to_fromNative32](LeanBridge.md#decl-1b116c7ff570bafe)

</details>

</details>

<a id="decl-7215bce245906415"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.fromNative32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L21)

```lean
def fromNative32 (x : Float32) : F32 := x.toBits.toBitVec
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.from_toNative32](LeanBridge.md#decl-bcf43c7c2dabc0e2), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeMul32](LeanBridge.md#decl-93b4e43615f002f9), [TensorCore.IEEE.LeanBridge.nativeSub32](LeanBridge.md#decl-d866a0a10fc49206), [TensorCore.IEEE.LeanBridge.to_fromNative32](LeanBridge.md#decl-1b116c7ff570bafe)

</details>

</details>

<a id="decl-bcf43c7c2dabc0e2"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.from_toNative32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L23)

```lean
theorem from_toNative32 (bits : F32) (h : Native32Valid bits) :
    fromNative32 (toNative32 bits h) = bits := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.fromNative32](LeanBridge.md#decl-7215bce245906415), [TensorCore.IEEE.LeanBridge.toNative32](LeanBridge.md#decl-2ae82772b2af06ec)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1b116c7ff570bafe"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.to_fromNative32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L26)

```lean
theorem to_fromNative32 (x : Float32) :
    toNative32 (fromNative32 x) x.toModel.valid = x := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.fromNative32](LeanBridge.md#decl-7215bce245906415), [TensorCore.IEEE.LeanBridge.toNative32](LeanBridge.md#decl-2ae82772b2af06ec)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-77f60cc9955604c1"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.sign32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L29)

```lean
def sign32 (a : F32) : Bool := a.toNat / 2147483648 != 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.IEEE.LeanBridge.unpackSign32_eq](LeanBridge.md#decl-389ab00360dd12ec), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe)

</details>

</details>

<a id="decl-853301706a16606f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeSign</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L31)

```lean
def nativeSign (negative : Bool) : Sign := if negative then .negative else .positive
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSign_mul](LeanBridge.md#decl-ab7a5cf4dc018ec2), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.packComponents32_eq](LeanBridge.md#decl-065b88b6b113a09b), [TensorCore.IEEE.LeanBridge.packFinite32_eq](LeanBridge.md#decl-cb2a2e247f1137bf), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packZero32_eq](LeanBridge.md#decl-884838ead8d1b1ab), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.IEEE.LeanBridge.unpackSign32_eq](LeanBridge.md#decl-389ab00360dd12ec)

</details>

</details>

<a id="decl-60e7ca1480f005e2"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpackExponent32_toNat</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L33)

```lean
theorem unpackExponent32_toNat (a : F32) :
    (unpackExponent (spec := Float.Model.Format.binary32) a).toNat = a.toNat / 8388608 % 256 := by
  simp only [unpackExponent, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

</details>

</details>

<a id="decl-982303cf14faf2d4"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpackMantissa32_toNat</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L37)

```lean
theorem unpackMantissa32_toNat (a : F32) :
    (unpackMantissa (spec := Float.Model.Format.binary32) a).toNat = a.toNat % 8388608 := by
  simp only [unpackMantissa, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

</details>

</details>

<a id="decl-389ab00360dd12ec"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpackSign32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L42)

```lean
theorem unpackSign32_eq (a : F32) :
    Sign.ofBitVec (unpackSign (spec := Float.Model.Format.binary32) a) = nativeSign (sign32 a) := by
  have hs : (unpackSign (spec := Float.Model.Format.binary32) a).toNat = a.toNat / 2147483648 := by
    simp only [unpackSign, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
    have ha := a.isLt
    change a.toNat / 2147483648 % 2 = a.toNat / 2147483648
    omega
  have hz : unpackSign (spec := Float.Model.Format.binary32) a = 0 ↔ a.toNat / 2147483648 = 0 := by
    constructor
    · intro h
      have h' := congrArg BitVec.toNat h
      rw [hs] at h'
      exact h'
    · intro h
      apply BitVec.eq_of_toNat_eq
      rw [hs, h]
      rfl
  unfold Sign.ofBitVec nativeSign
  change (if _ = 0 then Sign.positive else Sign.negative) =
    (if (a.toNat / 2147483648 != 0) = true then Sign.negative else Sign.positive)
  by_cases h : a.toNat / 2147483648 = 0
  · rw [if_pos (hz.mpr h)]
    simp [h]
  · rw [if_neg (fun h' => h (hz.mp h'))]
    simp [h]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

</details>

</details>

<a id="decl-b3a588347820a331"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native32Valid_finite</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L69)

```lean
/-- Finite exponent fields satisfy Lean's representation invariant directly. -/
theorem native32Valid_finite (a : F32) (h : a.toNat / 8388608 % 256 < 255) : Native32Valid a := by
  constructor
  intro he _
  have hnat := congrArg BitVec.toNat he
  rw [unpackExponent32_toNat] at hnat
  change a.toNat / 8388608 % 256 = 255 at hnat
  omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.unpackExponent32_toNat](LeanBridge.md#decl-60e7ca1480f005e2)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32](LeanFiniteAddition.md#decl-f0674d78ec7d02c2), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf)

</details>

</details>

<a id="decl-386e42fa55e98031"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.mantissa32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L77)

```lean
def mantissa32 (a : F32) : ℕ :=
  if a.toNat / 8388608 % 256 = 0 then a.toNat % 8388608 else 8388608 + a.toNat % 8388608
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.mantissa32_normal_or_min](LeanBridge.md#decl-c141d314d61139b4), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nonzero32_ne_negative_zero](LeanFiniteAddition.md#decl-df4619107a985056), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.product32_no_leftshift](LeanBridge.md#decl-e5fb0e54c2173ee5), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.IEEE.LeanBridge.zero_or_nonzero32](LeanFiniteAddition.md#decl-8239435efdc98204)

</details>

</details>

<a id="decl-0adbaa005ea3261f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.exponent32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L80)

```lean
def exponent32 (a : F32) : ℤ :=
  if a.toNat / 8388608 % 256 = 0 then -149 else (a.toNat / 8388608 % 256 : ℤ) - 150
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.mantissa32_normal_or_min](LeanBridge.md#decl-c141d314d61139b4), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.product32_no_leftshift](LeanBridge.md#decl-e5fb0e54c2173ee5), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

</details>

</details>

<a id="decl-934581d157f94b85"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.NonzeroFinite32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L83)

```lean
def NonzeroFinite32 (a : F32) : Prop := a.toNat / 8388608 % 256 < 255 ∧ 0 < mantissa32 a
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nonzero32_ne_negative_zero](LeanFiniteAddition.md#decl-df4619107a985056), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.product32_no_leftshift](LeanBridge.md#decl-e5fb0e54c2173ee5), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.LeanBridge.zero_or_nonzero32](LeanFiniteAddition.md#decl-8239435efdc98204)

</details>

</details>

<a id="decl-f123b7b61612ffd1"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpack32_nonzero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L87)

```lean
theorem unpack32_nonzero (a : F32) (h : NonzeroFinite32 a) :
    unpack Float.Model.Format.binary32 a =
      .finite (nativeSign (sign32 a)) (mantissa32 a) (exponent32 a) h.2 := by
  have heMax : unpackExponent (spec := Float.Model.Format.binary32) a ≠ -1#8 := by
    intro he
    have hn := congrArg BitVec.toNat he
    rw [unpackExponent32_toNat] at hn
    change a.toNat / 8388608 % 256 = 255 at hn
    have := h.1
    omega
  have heZero : unpackExponent (spec := Float.Model.Format.binary32) a = 0#8 ↔
      a.toNat / 8388608 % 256 = 0 := by
    constructor
    · intro he
      have hn := congrArg BitVec.toNat he
      rw [unpackExponent32_toNat] at hn
      exact hn
    · intro he
      apply BitVec.eq_of_toNat_eq
      rw [unpackExponent32_toNat, he]
      rfl
  have hcat : (1#1 ++ unpackMantissa (spec := Float.Model.Format.binary32) a).toNat =
      8388608 + a.toNat % 8388608 := by
    rw [BitVec.toNat_append,
      ← Nat.shiftLeft_add_eq_or_of_lt (unpackMantissa (spec := Float.Model.Format.binary32) a).isLt,
      unpackMantissa32_toNat, Nat.shiftLeft_eq]
    rfl
  unfold unpack
  dsimp only
  rw [if_neg heMax]
  by_cases hz : a.toNat / 8388608 % 256 = 0
  · have hmZero : unpackMantissa (spec := Float.Model.Format.binary32) a ≠ 0#23 := by
      intro he
      have hn := congrArg BitVec.toNat he
      rw [unpackMantissa32_toNat] at hn
      have hm := h.2
      simp only [mantissa32, hz, ↓reduceIte] at hm
      change a.toNat % 8388608 = 0 at hn
      omega
    rw [if_pos (heZero.mpr hz), dif_neg hmZero]
    simp only [unpackSign32_eq, unpackMantissa32_toNat, unpackExponent32_toNat,
      mantissa32, exponent32, hz, ↓reduceIte]
    rfl
  · rw [if_neg (fun he => hz (heZero.mp he))]
    simp only [unpackSign32_eq, unpackExponent32_toNat, hcat,
      mantissa32, exponent32, hz, ↓reduceIte]
    rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.unpackExponent32_toNat](LeanBridge.md#decl-60e7ca1480f005e2), [TensorCore.IEEE.LeanBridge.unpackMantissa32_toNat](LeanBridge.md#decl-982303cf14faf2d4), [TensorCore.IEEE.LeanBridge.unpackSign32_eq](LeanBridge.md#decl-389ab00360dd12ec)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78)

</details>

</details>

<a id="decl-3b4b402af08ad974"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.decode32_nonzero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L135)

```lean
theorem decode32_nonzero (a : F32) (h : NonzeroFinite32 a) :
    decode .binary32 a = .finite (sign32 a)
      ((nativeSign (sign32 a) |>.apply (mantissa32 a) : ℤ) * pow2 (exponent32 a)) := by
  have heMax : a.toNat / 8388608 % 256 ≠ 255 := by have := h.1; omega
  by_cases he : a.toNat / 8388608 % 256 = 0
  · have hm : a.toNat % 8388608 ≠ 0 := by
      have := h.2
      simp only [mantissa32, he, ↓reduceIte] at this
      omega
    simp [decode, classify, classifyNat, BinaryFormat.layout, fp32, he, hm,
      mantissa32, exponent32, sign, binarySign, sign32, nativeSign, Sign.apply, Decoded.value]
    split <;> rfl
  · simp [decode, classify, classifyNat, BinaryFormat.layout, fp32, heMax, he,
      mantissa32, exponent32, sign, binarySign, sign32, nativeSign, Sign.apply, Decoded.value]
    by_cases hs : 2147483648 ≤ a.toNat <;> simp only [hs, ↓reduceIte]
    all_goals congr 2 <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Numerics/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe)

</details>

</details>

<a id="decl-065b88b6b113a09b"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packComponents32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L152)

```lean
theorem packComponents32_eq (negative : Bool) (e : BitVec 8) (m : BitVec 23) :
    packComponents Float.Model.Format.binary32 (nativeSign negative) e m =
      BitVec.ofNat 32 ((if negative then 2 ^ 31 else 0) + e.toNat * 2 ^ 23 + m.toNat) := by
  have appendNat {n k : ℕ} (a : BitVec n) (b : BitVec k) :
      (a ++ b).toNat = a.toNat * 2 ^ k + b.toNat := by
    rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt b.isLt, Nat.shiftLeft_eq]
  change (nativeSign negative).toBitVec ++ e ++ m = BitVec.ofNat 32 _
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ofNat]
  cases negative <;>
    simp only [nativeSign, Bool.false_eq_true, ↓reduceIte,
      Sign.toBitVec, appendNat, BitVec.toNat_ofNat]
  all_goals omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packFinite32_eq](LeanBridge.md#decl-cb2a2e247f1137bf), [TensorCore.IEEE.LeanBridge.packZero32_eq](LeanBridge.md#decl-884838ead8d1b1ab)

</details>

</details>

<a id="decl-884838ead8d1b1ab"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packZero32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L166)

```lean
theorem packZero32_eq (negative : Bool) :
    pack Float.Model.Format.binary32 (.zero (nativeSign negative)) = zero .binary32 negative := by
  rw [pack, packedZero, packComponents32_eq]
  cases negative <;> rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packComponents32_eq](LeanBridge.md#decl-065b88b6b113a09b)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e)

</details>

</details>

<a id="decl-98d0f6338db37912"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.encodeZero32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L171)

```lean
theorem encodeZero32_eq (negative : Bool) (e : ℤ) :
    encodeBinary fp32 negative e 0 = zero .binary32 negative := by
  change BitVec.ofNat 32 ((if negative then 2147483648 else 0) + 0) = _
  cases negative <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.encodeBinary](../Numerics/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e)

</details>

</details>

<a id="decl-cb2a2e247f1137bf"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packFinite32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L178)

```lean
/-- Once normalization has produced a bounded coefficient, the two output
encoders agree bit for bit. -/
theorem packFinite32_eq (negative : Bool) (e : ℤ) (k : ℕ)
    (hk : 0 < k) (hu : k < 2 ^ 24) (he : -126 ≤ e) (he' : e ≤ 127) :
    pack Float.Model.Format.binary32 (.finite (nativeSign negative) k (e - 23) hk) =
      encodeBinary fp32 negative e (k : ℤ) := by
  have hb : e - 23 + 127 + 23 = e + 127 := by omega
  have hlo : (e + 127).toNat ≤ 254 := by omega
  have hn : k.log2 + 1 = 24 ↔ 2 ^ 23 ≤ k := by
    have hlog := Nat.log2_eq_iff (show k ≠ 0 by omega) (k := 23)
    omega
  change (if 256 ≤ (e - 23 + 127 + 23).toNat + 1 then
    packedInfinity Float.Model.Format.binary32 (nativeSign negative)
    else if k.log2 + 1 = 24 then
      packComponents Float.Model.Format.binary32 (nativeSign negative)
        (BitVec.ofNat 8 (e - 23 + 127 + 23).toNat) (BitVec.ofNat 23 k)
    else packComponents Float.Model.Format.binary32 (nativeSign negative)
        0 (BitVec.ofNat 23 k)) = _
  rw [hb]
  rw [if_neg (by omega)]
  by_cases hnormal : 2 ^ 23 ≤ k
  · rw [if_pos (hn.mpr hnormal), packComponents32_eq]
    change BitVec.ofNat 32 ((if negative then 2147483648 else 0) +
      ((e + 127).toNat % 256) * 8388608 + k % 8388608) =
      BitVec.ofNat 32 ((if negative then 2147483648 else 0) +
        (if (k : ℤ) < 8388608 then k else
          (e + 127).toNat * 8388608 + ((k : ℤ) - 8388608).toNat))
    rw [if_neg (show ¬ (k : ℤ) < 8388608 from by omega)]
    congr 1
    omega
  · rw [if_neg (fun h => hnormal (hn.mp h)), packComponents32_eq]
    change BitVec.ofNat 32 ((if negative then 2147483648 else 0) +
      0 * 8388608 + k % 8388608) =
      BitVec.ofNat 32 ((if negative then 2147483648 else 0) +
        (if (k : ℤ) < 8388608 then k else
          (e + 127).toNat * 8388608 + ((k : ℤ) - 8388608).toNat))
    rw [if_pos (show (k : ℤ) < 8388608 from by omega)]
    congr 1
    omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packComponents32_eq](LeanBridge.md#decl-065b88b6b113a09b)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.encodeBinary](../Numerics/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78)

</details>

</details>

<a id="decl-e787875815969d2e"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packRound32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L218)

```lean
/-- Complete agreement of normalization and packing on the finite reference
domain. The input mantissa and exponent are arbitrary, not sampled encodings. -/
theorem packRound32_eq (negative : Bool) (m : ℕ) (e : ℤ) (hm : 0 < m)
    (hr : (m : ℚ) * pow2 e ≤ fp32.maxFinite) :
    let x := (m : ℚ) * pow2 e
    let E := binaryConvExp fp32 x
    let K := rneInt (x / pow2 (E - 23))
    pack Float.Model.Format.binary32
      (Float.Model.UnpackedFloat.round Float.Model.Format.binary32 (nativeSign negative) m e) =
        encodeBinary fp32 negative (binaryCarry fp32 E K).1 (binaryCarry fp32 E K).2 := by
  intro x E K
  let q := Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e)
  let d := decreaseExponent m e q
  let first := shiftToTargetExponent Float.Model.Format.binary32 d.1 d.2 .exact
  let k := first.1.roundedMantissa
  have hf : first.2 = q ∧ (k : ℤ) = rneInt (x / pow2 q) := firstPass32 m e hm
  have hq : q = E - 23 := targetExponent32_eq m e hm
  have hk : (k : ℤ) = K := by simpa only [hq] using hf.2
  have hx : 0 < x := Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
  have he := binaryConvExp_bounds fp32 (by decide) x hx hr
  have hb := binaryConvCoeff_bounds fp32 (by decide) .nearestEven negative x hx hr
  change 0 ≤ K ∧ K ≤ 16777216 ∧ (8388608 ≤ K ∨ E = -126) ∧
    (E = 127 → K ≤ 16777215) at hb
  have hEl : -126 ≤ E := he.1
  have hEu : E ≤ 127 := he.2.1
  have hku : k ≤ 2 ^ 24 := by omega
  have hql : -149 ≤ q := by omega
  change pack Float.Model.Format.binary32
    (if h : (shiftToTargetExponent Float.Model.Format.binary32 k first.2 .exact).1.mantissa = 0 then
      .zero (nativeSign negative)
    else .finite (nativeSign negative)
      (shiftToTargetExponent Float.Model.Format.binary32 k first.2 .exact).1.mantissa
      (shiftToTargetExponent Float.Model.Format.binary32 k first.2 .exact).2
      (Nat.pos_of_ne_zero h)) = _
  rw [hf.1, secondPass32 k q hku hql]
  by_cases hc : k = 2 ^ 24
  · have hK : K = 16777216 := by omega
    have hE : E + 1 ≤ 127 := by omega
    rw [if_pos hc]
    simp only [show (2 ^ 23 : ℕ) ≠ 0 from by decide, ↓reduceDIte]
    rw [show q + 1 = (E + 1) - 23 from by omega]
    rw [packFinite32_eq negative (E + 1) (2 ^ 23) (by decide) (by decide) (by omega) hE]
    simp only [binaryCarry, fp32, hK]
    rfl
  · rw [if_neg hc]
    have hK : K ≠ 16777216 := by omega
    have hcarry : binaryCarry fp32 E K = (E, K) := by
      change (if K = 16777216 then _ else _) = _
      rw [if_neg hK]
    rw [hcarry]
    by_cases hz : k = 0
    · rw [dif_pos hz, packZero32_eq]
      have hK0 : K = 0 := by omega
      rw [hK0]
      exact (encodeZero32_eq negative E).symm
    · rw [dif_neg hz, hq]
      rw [packFinite32_eq negative E k (by omega) (by omega) hEl hEu, hk]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.encodeZero32_eq](LeanBridge.md#decl-98d0f6338db37912), [TensorCore.IEEE.LeanBridge.firstPass32](LeanRounding.md#decl-1f3110087e3c2f88), [TensorCore.IEEE.LeanBridge.packFinite32_eq](LeanBridge.md#decl-cb2a2e247f1137bf), [TensorCore.IEEE.LeanBridge.packZero32_eq](LeanBridge.md#decl-884838ead8d1b1ab), [TensorCore.IEEE.LeanBridge.secondPass32](LeanRounding.md#decl-42f813492ff38dd0), [TensorCore.IEEE.LeanBridge.targetExponent32_eq](LeanRounding.md#decl-fe597c4119872d5a), [TensorCore.binaryConvCoeff_bounds](../Numerics/Binary/ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](../Numerics/Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Numerics/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.binaryCarry](../Numerics/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Numerics/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Numerics/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](../Numerics/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348)

</details>

</details>

<a id="decl-d657870ed44b83fa"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteBits32_encode</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L274)

```lean
theorem finiteBits32_encode (x : ℚ) (hx : x ≠ 0) (hr : absQ x ≤ fp32.maxFinite) :
    finiteBits .binary32 .nearestEven x hr =
      let E := binaryConvExp fp32 (absQ x)
      let K := rneInt (absQ x / pow2 (E - 23))
      encodeBinary fp32 (decide (x < 0)) (binaryCarry fp32 E K).1 (binaryCarry fp32 E K).2 := by
  have h := finiteBits_eq .binary32 .nearestEven x hr
  change roundBinary fp32 .nearestEven x = some _ at h
  unfold roundBinary at h
  rw [if_neg (by decide : ¬ ¬ fp32.WellFormed), if_neg (Rat.not_lt.mpr hr), if_neg hx] at h
  dsimp only at h ⊢
  simp only [binaryCoefficient, show fp32.fractionBits = 23 from rfl] at h
  generalize hc : binaryCarry fp32 (binaryConvExp fp32 (absQ x))
    (rneInt (absQ x / pow2 (binaryConvExp fp32 (absQ x) - 23))) = c at h ⊢
  rcases c with ⟨E, K⟩
  change (if E > fp32.emax then none else some (encodeBinary fp32 (decide (x < 0)) E K)) = some _ at h
  split at h
  · contradiction
  · exact (Option.some.inj h).symm
```

**Supporting proofs:** [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Numerics/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Numerics/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Numerics/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Numerics/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](../Numerics/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348)

</details>

</details>

<a id="decl-1ae2176a75745348"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packRound32_reference</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L293)

```lean
theorem packRound32_reference (negative : Bool) (m : ℕ) (e : ℤ) (hm : 0 < m)
    (tinyMode : Tininess) (hr : (m : ℚ) * pow2 e ≤ fp32.maxFinite) :
    pack Float.Model.Format.binary32
      (Float.Model.UnpackedFloat.round Float.Model.Format.binary32 (nativeSign negative) m e) =
      (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ negative
        (if negative then -((m : ℚ) * pow2 e) else (m : ℚ) * pow2 e)).bits := by
  have hx : 0 < (m : ℚ) * pow2 e := Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
  have habs : absQ ((m : ℚ) * pow2 e) = (m : ℚ) * pow2 e := absQ_of_nonneg (Rat.le_of_lt hx)
  have hnabs : absQ (-((m : ℚ) * pow2 e)) = (m : ℚ) * pow2 e := by rw [absQ_neg, habs]
  have hne : (m : ℚ) * pow2 e ≠ 0 := Rat.ne_of_gt hx
  have hnne : -((m : ℚ) * pow2 e) ≠ 0 := by grind
  have hneg : -((m : ℚ) * pow2 e) < 0 := by grind
  have hnneg : ¬ (m : ℚ) * pow2 e < 0 := by grind
  rw [packRound32_eq negative m e hm hr]
  cases negative <;>
    simp only [Bool.false_eq_true, ↓reduceIte, TensorCore.IEEE.round,
      BinaryFormat.layout, hne, hnne, habs, hnabs, hr, ↓reduceDIte] <;>
    rw [finiteBits32_encode _ (by assumption) (by simpa only [habs, hnabs] using hr)] <;>
    simp only [habs, hnabs, hneg, hnneg, decide_true, decide_false]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.finiteBits32_encode](LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e), [TensorCore.absQ_neg](../Numerics/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Numerics/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Numerics/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryConvExp](../Numerics/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryValue](../Numerics/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](../Numerics/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344)

</details>

</details>

<a id="decl-900184c483f9a344"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packNormalize32_reference</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L313)

```lean
theorem packNormalize32_reference (m : ℤ) (e : ℤ) (tinyMode : Tininess)
    (hr : absQ ((m : ℚ) * pow2 e) ≤ fp32.maxFinite) :
    pack Float.Model.Format.binary32
      (normalize Float.Model.Format.binary32 m e .positive) =
      (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
        ((m : ℚ) * pow2 e)).bits := by
  by_cases hz : m = 0
  · subst m
    rw [show (normalize Float.Model.Format.binary32 0 e .positive) = .zero .positive from rfl]
    simp only [Rat.intCast_zero, Rat.zero_mul, round_zero]
    exact packZero32_eq false
  by_cases hn : m < 0
  · have hm : 0 < (-m).toNat := by omega
    have hcast : (((-m).toNat : ℕ) : ℚ) = -(m : ℚ) := by
      rw [← Rat.intCast_natCast, Int.toNat_of_nonneg (by omega), Rat.intCast_neg]
    have hvalue : ((m : ℚ) * pow2 e) = -((((-m).toNat : ℕ) : ℚ) * pow2 e) := by
      rw [hcast]; grind
    have hp : 0 < (((-m).toNat : ℕ) : ℚ) * pow2 e :=
      Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
    have hrange : (((-m).toNat : ℕ) : ℚ) * pow2 e ≤ fp32.maxFinite := by
      simpa only [hvalue, absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
    have h := packRound32_reference true (-m).toNat e hm tinyMode hrange
    simp only [nativeSign, ↓reduceIte] at h
    rw [normalize, Int.compare_eq_lt.mpr hn]
    rw [h]
    rw [hvalue]
    have hne : -((((-m).toNat : ℕ) : ℚ) * pow2 e) ≠ 0 := by grind
    simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
    rfl
  · have hm : 0 < m.toNat := by omega
    have hcast : ((m.toNat : ℕ) : ℚ) = (m : ℚ) := by
      rw [← Rat.intCast_natCast, Int.toNat_of_nonneg (by omega)]
    have hp : 0 < (m : ℚ) * pow2 e := by
      rw [← hcast]
      exact Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
    have hrange : ((m.toNat : ℕ) : ℚ) * pow2 e ≤ fp32.maxFinite := by
      simpa only [hcast, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
    have h := packRound32_reference false m.toNat e hm tinyMode hrange
    simp only [nativeSign, Bool.false_eq_true, ↓reduceIte, hcast] at h
    rw [normalize, Int.compare_eq_gt.mpr (by omega)]
    exact h
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packZero32_eq](LeanBridge.md#decl-884838ead8d1b1ab), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.absQ_neg](../Numerics/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Numerics/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Numerics/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf)

</details>

</details>

<a id="decl-ec545ce67195b15f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteValue32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L355)

```lean
def finiteValue32 (a : F32) : ℚ :=
  (nativeSign (sign32 a) |>.apply (mantissa32 a) : ℤ) * pow2 (exponent32 a)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteValue32_mul](LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe)

</details>

</details>

<a id="decl-e6cb66147cd6c96f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.aligned_add_value</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L358)

```lean
theorem aligned_add_value (sa sb : Sign) (ma mb : ℕ) (ea eb : ℤ) :
    let q := min ea eb
    let m := sa.apply (decreaseExponent ma ea q).1 + sb.apply (decreaseExponent mb eb q).1
    (m : ℚ) * pow2 q = (sa.apply ma : ℚ) * pow2 ea + (sb.apply mb : ℚ) * pow2 eb := by
  intro q m
  have hea : (decreaseExponent ma ea q).2 = q := by
    dsimp [decreaseExponent, q]
    omega
  have heb : (decreaseExponent mb eb q).2 = q := by
    dsimp [decreaseExponent, q]
    omega
  have ha := decreaseExponent_value ma ea q
  have hb := decreaseExponent_value mb eb q
  rw [hea] at ha
  rw [heb] at hb
  dsimp only [m]
  cases sa <;> cases sb <;>
    simp only [Sign.apply, Rat.intCast_add, Rat.intCast_neg, Rat.intCast_natCast] <;> grind
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decreaseExponent_value](LeanRounding.md#decl-8bceb00d2c5415ab)

**Definitions and types:** [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92)

</details>

</details>

<a id="decl-dc54f4b7cbcc4fbf"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L377)

```lean
def nativeAdd32 (a b : F32) (ha : Native32Valid a) (hb : Native32Valid b) : F32 :=
  fromNative32 (toNative32 a ha + toNative32 b hb)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.fromNative32](LeanBridge.md#decl-7215bce245906415), [TensorCore.IEEE.LeanBridge.toNative32](LeanBridge.md#decl-2ae82772b2af06ec)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32](LeanFiniteAddition.md#decl-f0674d78ec7d02c2), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-b1ec0d9884fab564"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd32_reference</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L382)

```lean
/-- Every nonzero finite pair with an in-range exact sum agrees bit for bit.
Tininess affects the reference flags but does not change this value theorem. -/
theorem nativeAdd32_reference (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    nativeAdd32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1) =
      (TensorCore.IEEE.add .binary32 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.add Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)) = _
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.add]
  have hv := aligned_add_value (nativeSign (sign32 a)) (nativeSign (sign32 b))
    (mantissa32 a) (mantissa32 b) (exponent32 a) (exponent32 b)
  have hround := packNormalize32_reference
    ((nativeSign (sign32 a)).apply
      (decreaseExponent (mantissa32 a) (exponent32 a) (min (exponent32 a) (exponent32 b))).1 +
     (nativeSign (sign32 b)).apply
      (decreaseExponent (mantissa32 b) (exponent32 b) (min (exponent32 a) (exponent32 b))).1)
    (min (exponent32 a) (exponent32 b)) tinyMode (by simpa only [hv, finiteValue32] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue32 a + finiteValue32 b)).bits =
    (addDatum .binary32 ⟨.nearestEven, tinyMode⟩ (decode .binary32 a) (decode .binary32 b)).bits
  rw [decode32_nonzero a ha, decode32_nonzero b hb]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue32 a + finiteValue32 b)).bits =
      (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign32 a) (sign32 b))
        (finiteValue32 a + finiteValue32 b)).bits
  cases sa : sign32 a <;> cases sb : sign32 b
  all_goals try rfl
  have hpa : 0 < (mantissa32 a : ℚ) * pow2 (exponent32 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa32 b : ℚ) * pow2 (exponent32 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue32 a + finiteValue32 b ≠ 0 := by
    simp only [finiteValue32, sa, sb, nativeSign, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.aligned_add_value](LeanBridge.md#decl-e6cb66147cd6c96f), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Numerics/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e1219acca53993f8"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.aligned_sub_value</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L421)

```lean
theorem aligned_sub_value (sa sb : Sign) (ma mb : ℕ) (ea eb : ℤ) :
    let q := min ea eb
    let m := sa.apply (decreaseExponent ma ea q).1 - sb.apply (decreaseExponent mb eb q).1
    (m : ℚ) * pow2 q = (sa.apply ma : ℚ) * pow2 ea - (sb.apply mb : ℚ) * pow2 eb := by
  intro q m
  have hea : (decreaseExponent ma ea q).2 = q := by
    dsimp [decreaseExponent, q]
    omega
  have heb : (decreaseExponent mb eb q).2 = q := by
    dsimp [decreaseExponent, q]
    omega
  have ha := decreaseExponent_value ma ea q
  have hb := decreaseExponent_value mb eb q
  rw [hea] at ha
  rw [heb] at hb
  dsimp only [m]
  cases sa <;> cases sb <;>
    simp only [Sign.apply, Rat.intCast_sub, Rat.intCast_neg, Rat.intCast_natCast] <;> grind
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decreaseExponent_value](LeanRounding.md#decl-8bceb00d2c5415ab)

**Definitions and types:** [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf)

</details>

</details>

<a id="decl-d866a0a10fc49206"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeSub32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L440)

```lean
def nativeSub32 (a b : F32) (ha : Native32Valid a) (hb : Native32Valid b) : F32 :=
  fromNative32 (toNative32 a ha - toNative32 b hb)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.fromNative32](LeanBridge.md#decl-7215bce245906415), [TensorCore.IEEE.LeanBridge.toNative32](LeanBridge.md#decl-2ae82772b2af06ec)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf)

</details>

</details>

<a id="decl-8d9a826fd4c8febf"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeSub32_reference</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L445)

```lean
/-- Every nonzero finite pair with an in-range exact difference agrees bit for bit.
Tininess affects the reference flags but does not change this value theorem. -/
theorem nativeSub32_reference (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue32 a - finiteValue32 b) ≤ fp32.maxFinite) :
    nativeSub32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1) =
      (TensorCore.IEEE.sub .binary32 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.sub Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)) = _
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.sub]
  have hv := aligned_sub_value (nativeSign (sign32 a)) (nativeSign (sign32 b))
    (mantissa32 a) (mantissa32 b) (exponent32 a) (exponent32 b)
  have hround := packNormalize32_reference
    ((nativeSign (sign32 a)).apply
      (decreaseExponent (mantissa32 a) (exponent32 a) (min (exponent32 a) (exponent32 b))).1 -
     (nativeSign (sign32 b)).apply
      (decreaseExponent (mantissa32 b) (exponent32 b) (min (exponent32 a) (exponent32 b))).1)
    (min (exponent32 a) (exponent32 b)) tinyMode (by simpa only [hv, finiteValue32] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue32 a - finiteValue32 b)).bits =
    (addDatum .binary32 ⟨.nearestEven, tinyMode⟩ (decode .binary32 a) (decode .binary32 b).negate).bits
  rw [decode32_nonzero a ha, decode32_nonzero b hb]
  simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
  rw [← Rat.sub_eq_add_neg]
  change (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue32 a - finiteValue32 b)).bits =
      (TensorCore.IEEE.round .binary32 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign32 a) (!(sign32 b)))
        (finiteValue32 a - finiteValue32 b)).bits
  cases sa : sign32 a <;> cases sb : sign32 b
  all_goals try rfl
  have hpa : 0 < (mantissa32 a : ℚ) * pow2 (exponent32 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa32 b : ℚ) * pow2 (exponent32 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue32 a - finiteValue32 b ≠ 0 := by
    simp only [finiteValue32, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.aligned_sub_value](LeanBridge.md#decl-e1219acca53993f8), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.nativeSub32](LeanBridge.md#decl-d866a0a10fc49206), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Numerics/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ab7a5cf4dc018ec2"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeSign_mul</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L486)

```lean
theorem nativeSign_mul (a b : Bool) : nativeSign a * nativeSign b = nativeSign (xor a b) := by
  cases a <;> cases b <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537)

</details>

</details>

<a id="decl-c141d314d61139b4"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.mantissa32_normal_or_min</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L489)

```lean
theorem mantissa32_normal_or_min (a : F32) :
    2 ^ 23 ≤ mantissa32 a ∨ exponent32 a = -149 := by
  by_cases h : a.toNat / 8388608 % 256 = 0
  · exact Or.inr (by simp [exponent32, h])
  · left
    simp only [mantissa32, h, ↓reduceIte]
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.product32_no_leftshift](LeanBridge.md#decl-e5fb0e54c2173ee5)

</details>

</details>

<a id="decl-e5fb0e54c2173ee5"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.product32_no_leftshift</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L497)

```lean
theorem product32_no_leftshift (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) :
    exponent32 a + exponent32 b ≤ Float.Model.Format.binary32.targetExponent
      (Float.Model.totalExponent (mantissa32 a * mantissa32 b) (exponent32 a + exponent32 b)) := by
  have hp : 0 < mantissa32 a * mantissa32 b := Nat.mul_pos ha.2 hb.2
  have hma : mantissa32 a ≤ mantissa32 a * mantissa32 b := by
    have hh := Nat.mul_le_mul_left (mantissa32 a) (show 1 ≤ mantissa32 b by have := hb.2; omega)
    simpa using hh
  have hmb : mantissa32 b ≤ mantissa32 a * mantissa32 b := by
    have hh := Nat.mul_le_mul_right (mantissa32 b) (show 1 ≤ mantissa32 a by have := ha.2; omega)
    simpa using hh
  change exponent32 a + exponent32 b ≤
    max ((mantissa32 a * mantissa32 b).log2 + 1 + (exponent32 a + exponent32 b) - 24) (-149 : ℤ)
  rcases mantissa32_normal_or_min a with h | h
  · have hl := (Nat.le_log2 (show mantissa32 a * mantissa32 b ≠ 0 by omega)).mpr (Nat.le_trans h hma)
    omega
  · rcases mantissa32_normal_or_min b with h' | h'
    · have hl := (Nat.le_log2 (show mantissa32 a * mantissa32 b ≠ 0 by omega)).mpr (Nat.le_trans h' hmb)
      omega
    · omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.mantissa32_normal_or_min](LeanBridge.md#decl-c141d314d61139b4)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537)

</details>

</details>

<a id="decl-3eaf36b8f3197151"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.roundWithAccuracy_eq_round32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L517)

```lean
theorem roundWithAccuracy_eq_round32 (s : Sign) (m : ℕ) (e : ℤ)
    (h : e ≤ Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e)) :
    roundWithAccuracy Float.Model.Format.binary32 s m e .exact =
      Float.Model.UnpackedFloat.round Float.Model.Format.binary32 s m e := by
  have hn : (e - Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e)).toNat = 0 := by omega
  simp [Float.Model.UnpackedFloat.round, decreaseExponent, hn]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537)

</details>

</details>

<a id="decl-ff38abc65cb0616b"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteValue32_mul</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L524)

```lean
theorem finiteValue32_mul (a b : F32) :
    finiteValue32 a * finiteValue32 b =
      if xor (sign32 a) (sign32 b) then
        -(((mantissa32 a * mantissa32 b : ℕ) : ℚ) * pow2 (exponent32 a + exponent32 b))
      else ((mantissa32 a * mantissa32 b : ℕ) : ℚ) * pow2 (exponent32 a + exponent32 b) := by
  cases sa : sign32 a <;> cases sb : sign32 b <;>
    simp only [finiteValue32, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte,
      Sign.apply, Rat.intCast_neg, Rat.intCast_natCast, Rat.natCast_mul, pow2_add,
      Bool.false_xor, Bool.true_xor, Bool.not_false, Bool.not_true] <;> grind
```

**Supporting proofs:** [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537)

</details>

</details>

<a id="decl-93b4e43615f002f9"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeMul32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L534)

```lean
def nativeMul32 (a b : F32) (ha : Native32Valid a) (hb : Native32Valid b) : F32 :=
  fromNative32 (toNative32 a ha * toNative32 b hb)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.fromNative32](LeanBridge.md#decl-7215bce245906415), [TensorCore.IEEE.LeanBridge.toNative32](LeanBridge.md#decl-2ae82772b2af06ec)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537)

</details>

</details>

<a id="decl-13c80e51e6db1537"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeMul32_reference</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanBridge.lean#L537)

```lean
theorem nativeMul32_reference (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue32 a * finiteValue32 b) ≤ fp32.maxFinite) :
    nativeMul32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1) =
      (TensorCore.IEEE.mul .binary32 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  have hm := Nat.mul_pos ha.2 hb.2
  have hp : 0 < ((mantissa32 a * mantissa32 b : ℕ) : ℚ) * pow2 (exponent32 a + exponent32 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos _)
  have hrange : ((mantissa32 a * mantissa32 b : ℕ) : ℚ) *
      pow2 (exponent32 a + exponent32 b) ≤ fp32.maxFinite := by
    rw [finiteValue32_mul] at hr
    split at hr <;> simpa only [absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
  change pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.mul Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)) = _
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.mul]
  rw [nativeSign_mul, roundWithAccuracy_eq_round32 _ _ _ (product32_no_leftshift a b ha hb),
    packRound32_reference _ _ _ hm tinyMode hrange, ← finiteValue32_mul]
  change (round .binary32 ⟨.nearestEven, tinyMode⟩ (xor (sign32 a) (sign32 b))
    (finiteValue32 a * finiteValue32 b)).bits =
      (mulDatum .binary32 ⟨.nearestEven, tinyMode⟩ (decode .binary32 a) (decode .binary32 b)).bits
  rw [decode32_nonzero a ha, decode32_nonzero b hb]
  rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.nativeSign_mul](LeanBridge.md#decl-ab7a5cf4dc018ec2), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.product32_no_leftshift](LeanBridge.md#decl-e5fb0e54c2173ee5), [TensorCore.IEEE.LeanBridge.roundWithAccuracy_eq_round32](LeanBridge.md#decl-3eaf36b8f3197151), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1), [TensorCore.absQ_neg](../Numerics/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Numerics/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeMul32](LeanBridge.md#decl-93b4e43615f002f9), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
