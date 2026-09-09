# TensorCore.IEEE.LeanBridge64

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5e4c6b31b1817a74"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.F64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L11)

```lean
abbrev F64 := BitVec 64
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.fromNative64](LeanBridge64.md#decl-deb8fe9c1e65efcb), [TensorCore.IEEE.LeanBridge.from_toNative64](LeanBridge64.md#decl-571edf6125854bcc), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.mantissa64_normal_or_min](LeanBridge64.md#decl-51d99b65e12a8651), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.product64_no_leftshift](LeanBridge64.md#decl-5bf600a946cde73f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.IEEE.LeanBridge.unpackExponent64_toNat](LeanBridge64.md#decl-fb53a60b10f075e9), [TensorCore.IEEE.LeanBridge.unpackMantissa64_toNat](LeanBridge64.md#decl-661938012be8e9c4), [TensorCore.IEEE.LeanBridge.unpackSign64_eq](LeanBridge64.md#decl-13e18a6fcee97ddf), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-0e67059acc4694a0"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.Native64Valid</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L13)

```lean
abbrev Native64Valid (bits : F64) : Prop := Float.Model.Format.binary64.Valid bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.from_toNative64](LeanBridge64.md#decl-571edf6125854bcc), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff)

</details>

</details>

<a id="decl-04c8275660328ad9"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.toNative64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L15)

```lean
def toNative64 (bits : F64) (h : Native64Valid bits) : Float :=
  .ofModel ⟨UInt64.ofBitVec bits, h⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.from_toNative64](LeanBridge64.md#decl-571edf6125854bcc), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.LeanBridge.to_fromNative64](LeanBridge64.md#decl-98f12180901b6069)

</details>

</details>

<a id="decl-deb8fe9c1e65efcb"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.fromNative64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L18)

```lean
def fromNative64 (x : Float) : F64 := x.toBits.toBitVec
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.from_toNative64](LeanBridge64.md#decl-571edf6125854bcc), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.LeanBridge.to_fromNative64](LeanBridge64.md#decl-98f12180901b6069)

</details>

</details>

<a id="decl-571edf6125854bcc"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.from_toNative64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L20)

```lean
theorem from_toNative64 (bits : F64) (h : Native64Valid bits) :
    fromNative64 (toNative64 bits h) = bits := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0), [TensorCore.IEEE.LeanBridge.fromNative64](LeanBridge64.md#decl-deb8fe9c1e65efcb), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-98f12180901b6069"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.to_fromNative64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L23)

```lean
theorem to_fromNative64 (x : Float) :
    toNative64 (fromNative64 x) x.toModel.valid = x := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.fromNative64](LeanBridge64.md#decl-deb8fe9c1e65efcb), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8986cde2dee9c242"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.sign64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L26)

```lean
def sign64 (a : F64) : Bool := a.toNat / 9223372036854775808 != 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.IEEE.LeanBridge.unpackSign64_eq](LeanBridge64.md#decl-13e18a6fcee97ddf), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-fb53a60b10f075e9"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpackExponent64_toNat</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L28)

```lean
theorem unpackExponent64_toNat (a : F64) :
    (unpackExponent (spec := Float.Model.Format.binary64) a).toNat = a.toNat / 4503599627370496 % 2048 := by
  simp only [unpackExponent, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0)

</details>

</details>

<a id="decl-661938012be8e9c4"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpackMantissa64_toNat</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L32)

```lean
theorem unpackMantissa64_toNat (a : F64) :
    (unpackMantissa (spec := Float.Model.Format.binary64) a).toNat = a.toNat % 4503599627370496 := by
  simp only [unpackMantissa, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0)

</details>

</details>

<a id="decl-13e18a6fcee97ddf"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpackSign64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L37)

```lean
theorem unpackSign64_eq (a : F64) :
    Sign.ofBitVec (unpackSign (spec := Float.Model.Format.binary64) a) = nativeSign (sign64 a) := by
  have hs : (unpackSign (spec := Float.Model.Format.binary64) a).toNat = a.toNat / 9223372036854775808 := by
    simp only [unpackSign, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
    have ha := a.isLt
    change a.toNat / 9223372036854775808 % 2 = a.toNat / 9223372036854775808
    omega
  have hz : unpackSign (spec := Float.Model.Format.binary64) a = 0 ↔ a.toNat / 9223372036854775808 = 0 := by
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
    (if (a.toNat / 9223372036854775808 != 0) = true then Sign.negative else Sign.positive)
  by_cases h : a.toNat / 9223372036854775808 = 0
  · rw [if_pos (hz.mpr h)]
    simp [h]
  · rw [if_neg (fun h' => h (hz.mp h'))]
    simp [h]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0)

</details>

</details>

<a id="decl-f4a4ecb5975d5479"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.native64Valid_finite</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L63)

```lean
theorem native64Valid_finite (a : F64) (h : a.toNat / 4503599627370496 % 2048 < 2047) : Native64Valid a := by
  constructor
  intro he _
  have hnat := congrArg BitVec.toNat he
  rw [unpackExponent64_toNat] at hnat
  change a.toNat / 4503599627370496 % 2048 = 2047 at hnat
  omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.unpackExponent64_toNat](LeanBridge64.md#decl-fb53a60b10f075e9)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-aae21efd45125e0b"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.mantissa64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L71)

```lean
def mantissa64 (a : F64) : ℕ :=
  if a.toNat / 4503599627370496 % 2048 = 0 then a.toNat % 4503599627370496 else 4503599627370496 + a.toNat % 4503599627370496
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.mantissa64_normal_or_min](LeanBridge64.md#decl-51d99b65e12a8651), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.product64_no_leftshift](LeanBridge64.md#decl-5bf600a946cde73f), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-ed36d48aa19e3495"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.exponent64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L74)

```lean
def exponent64 (a : F64) : ℤ :=
  if a.toNat / 4503599627370496 % 2048 = 0 then -1074 else (a.toNat / 4503599627370496 % 2048 : ℤ) - 1075
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.mantissa64_normal_or_min](LeanBridge64.md#decl-51d99b65e12a8651), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.product64_no_leftshift](LeanBridge64.md#decl-5bf600a946cde73f), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-ba104ae2a8389734"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.NonzeroFinite64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L77)

```lean
def NonzeroFinite64 (a : F64) : Prop := a.toNat / 4503599627370496 % 2048 < 2047 ∧ 0 < mantissa64 a
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.product64_no_leftshift](LeanBridge64.md#decl-5bf600a946cde73f), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-df22d92cc0097ad0"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.unpack64_nonzero</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L81)

```lean
theorem unpack64_nonzero (a : F64) (h : NonzeroFinite64 a) :
    unpack Float.Model.Format.binary64 a =
      .finite (nativeSign (sign64 a)) (mantissa64 a) (exponent64 a) h.2 := by
  have heMax : unpackExponent (spec := Float.Model.Format.binary64) a ≠ -1#11 := by
    intro he
    have hn := congrArg BitVec.toNat he
    rw [unpackExponent64_toNat] at hn
    change a.toNat / 4503599627370496 % 2048 = 2047 at hn
    have := h.1
    omega
  have heZero : unpackExponent (spec := Float.Model.Format.binary64) a = 0#11 ↔
      a.toNat / 4503599627370496 % 2048 = 0 := by
    constructor
    · intro he
      have hn := congrArg BitVec.toNat he
      rw [unpackExponent64_toNat] at hn
      exact hn
    · intro he
      apply BitVec.eq_of_toNat_eq
      rw [unpackExponent64_toNat, he]
      rfl
  have hcat : (1#1 ++ unpackMantissa (spec := Float.Model.Format.binary64) a).toNat =
      4503599627370496 + a.toNat % 4503599627370496 := by
    rw [BitVec.toNat_append,
      ← Nat.shiftLeft_add_eq_or_of_lt (unpackMantissa (spec := Float.Model.Format.binary64) a).isLt,
      unpackMantissa64_toNat, Nat.shiftLeft_eq]
    rfl
  unfold unpack
  dsimp only
  rw [if_neg heMax]
  by_cases hz : a.toNat / 4503599627370496 % 2048 = 0
  · have hmZero : unpackMantissa (spec := Float.Model.Format.binary64) a ≠ 0#52 := by
      intro he
      have hn := congrArg BitVec.toNat he
      rw [unpackMantissa64_toNat] at hn
      have hm := h.2
      simp only [mantissa64, hz, ↓reduceIte] at hm
      change a.toNat % 4503599627370496 = 0 at hn
      omega
    rw [if_pos (heZero.mpr hz), dif_neg hmZero]
    simp only [unpackSign64_eq, unpackMantissa64_toNat, unpackExponent64_toNat,
      mantissa64, exponent64, hz, ↓reduceIte]
    rfl
  · rw [if_neg (fun he => hz (heZero.mp he))]
    simp only [unpackSign64_eq, unpackExponent64_toNat, hcat,
      mantissa64, exponent64, hz, ↓reduceIte]
    rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.unpackExponent64_toNat](LeanBridge64.md#decl-fb53a60b10f075e9), [TensorCore.IEEE.LeanBridge.unpackMantissa64_toNat](LeanBridge64.md#decl-661938012be8e9c4), [TensorCore.IEEE.LeanBridge.unpackSign64_eq](LeanBridge64.md#decl-13e18a6fcee97ddf)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90)

</details>

</details>

<a id="decl-67377a612a0cb18b"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.decode64_nonzero</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L129)

```lean
theorem decode64_nonzero (a : F64) (h : NonzeroFinite64 a) :
    decode .binary64 a = .finite (sign64 a)
      ((nativeSign (sign64 a) |>.apply (mantissa64 a) : ℤ) * pow2 (exponent64 a)) := by
  have heMax : a.toNat / 4503599627370496 % 2048 ≠ 2047 := by have := h.1; omega
  by_cases he : a.toNat / 4503599627370496 % 2048 = 0
  · have hm : a.toNat % 4503599627370496 ≠ 0 := by
      have := h.2
      simp only [mantissa64, he, ↓reduceIte] at this
      omega
    simp [decode, classify, classifyNat, BinaryFormat.layout, fp64, he, hm,
      mantissa64, exponent64, sign, binarySign, sign64, nativeSign, Sign.apply, Decoded.value]
    split <;> rfl
  · simp [decode, classify, classifyNat, BinaryFormat.layout, fp64, heMax, he,
      mantissa64, exponent64, sign, binarySign, sign64, nativeSign, Sign.apply, Decoded.value]
    by_cases hs : 9223372036854775808 ≤ a.toNat <;> simp only [hs, ↓reduceIte]
    all_goals congr 2 <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-324f642054e3e262"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packComponents64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L146)

```lean
theorem packComponents64_eq (negative : Bool) (e : BitVec 11) (m : BitVec 52) :
    packComponents Float.Model.Format.binary64 (nativeSign negative) e m =
      BitVec.ofNat 64 ((if negative then 2 ^ 63 else 0) + e.toNat * 2 ^ 52 + m.toNat) := by
  have appendNat {n k : ℕ} (a : BitVec n) (b : BitVec k) :
      (a ++ b).toNat = a.toNat * 2 ^ k + b.toNat := by
    rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt b.isLt, Nat.shiftLeft_eq]
  change (nativeSign negative).toBitVec ++ e ++ m = BitVec.ofNat 64 _
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

[TensorCore.IEEE.LeanBridge.packFinite64_eq](LeanBridge64.md#decl-05949554c1fd3c44), [TensorCore.IEEE.LeanBridge.packZero64_eq](LeanBridge64.md#decl-25839643d33202cf)

</details>

</details>

<a id="decl-25839643d33202cf"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packZero64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L160)

```lean
theorem packZero64_eq (negative : Bool) :
    pack Float.Model.Format.binary64 (.zero (nativeSign negative)) = zero .binary64 negative := by
  rw [pack, packedZero, packComponents64_eq]
  cases negative <;> rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packComponents64_eq](LeanBridge64.md#decl-324f642054e3e262)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb)

</details>

</details>

<a id="decl-9db9d280d3c864b3"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.encodeZero64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L165)

```lean
theorem encodeZero64_eq (negative : Bool) (e : ℤ) :
    encodeBinary fp64 negative e 0 = zero .binary64 negative := by
  change BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) + 0) = _
  cases negative <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb)

</details>

</details>

<a id="decl-05949554c1fd3c44"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packFinite64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L170)

```lean
theorem packFinite64_eq (negative : Bool) (e : ℤ) (k : ℕ)
    (hk : 0 < k) (hu : k < 2 ^ 53) (he : -1022 ≤ e) (he' : e ≤ 1023) :
    pack Float.Model.Format.binary64 (.finite (nativeSign negative) k (e - 52) hk) =
      encodeBinary fp64 negative e (k : ℤ) := by
  have hb : e - 52 + 1023 + 52 = e + 1023 := by omega
  have hlo : (e + 1023).toNat ≤ 2046 := by omega
  have hn : k.log2 + 1 = 53 ↔ 2 ^ 52 ≤ k := by
    have hlog := Nat.log2_eq_iff (show k ≠ 0 by omega) (k := 52)
    omega
  change (if 2048 ≤ (e - 52 + 1023 + 52).toNat + 1 then
    packedInfinity Float.Model.Format.binary64 (nativeSign negative)
    else if k.log2 + 1 = 53 then
      packComponents Float.Model.Format.binary64 (nativeSign negative)
        (BitVec.ofNat 11 (e - 52 + 1023 + 52).toNat) (BitVec.ofNat 52 k)
    else packComponents Float.Model.Format.binary64 (nativeSign negative)
        0 (BitVec.ofNat 52 k)) = _
  rw [hb]
  rw [if_neg (by omega)]
  by_cases hnormal : 2 ^ 52 ≤ k
  · rw [if_pos (hn.mpr hnormal), packComponents64_eq]
    change BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
      ((e + 1023).toNat % 2048) * 4503599627370496 + k % 4503599627370496) =
      BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
        (if (k : ℤ) < 4503599627370496 then k else
          (e + 1023).toNat * 4503599627370496 + ((k : ℤ) - 4503599627370496).toNat))
    rw [if_neg (show ¬ (k : ℤ) < 4503599627370496 from by omega)]
    congr 1
    omega
  · rw [if_neg (fun h => hnormal (hn.mp h)), packComponents64_eq]
    change BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
      0 * 4503599627370496 + k % 4503599627370496) =
      BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
        (if (k : ℤ) < 4503599627370496 then k else
          (e + 1023).toNat * 4503599627370496 + ((k : ℤ) - 4503599627370496).toNat))
    rw [if_pos (show (k : ℤ) < 4503599627370496 from by omega)]
    congr 1
    omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packComponents64_eq](LeanBridge64.md#decl-324f642054e3e262)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb)

</details>

</details>

<a id="decl-0c708a8abb7275bb"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packRound64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L208)

```lean
theorem packRound64_eq (negative : Bool) (m : ℕ) (e : ℤ) (hm : 0 < m)
    (hr : (m : ℚ) * pow2 e ≤ fp64.maxFinite) :
    let x := (m : ℚ) * pow2 e
    let E := binaryConvExp fp64 x
    let K := rneInt (x / pow2 (E - 52))
    pack Float.Model.Format.binary64
      (Float.Model.UnpackedFloat.round Float.Model.Format.binary64 (nativeSign negative) m e) =
        encodeBinary fp64 negative (binaryCarry fp64 E K).1 (binaryCarry fp64 E K).2 := by
  intro x E K
  let q := Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)
  let d := decreaseExponent m e q
  let first := shiftToTargetExponent Float.Model.Format.binary64 d.1 d.2 .exact
  let k := first.1.roundedMantissa
  have hf : first.2 = q ∧ (k : ℤ) = rneInt (x / pow2 q) := firstPass64 m e hm
  have hq : q = E - 52 := targetExponent64_eq m e hm
  have hk : (k : ℤ) = K := by simpa only [hq] using hf.2
  have hx : 0 < x := Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
  have he := binaryConvExp_bounds fp64 (by decide) x hx hr
  have hb := binaryConvCoeff_bounds fp64 (by decide) .nearestEven negative x hx hr
  change 0 ≤ K ∧ K ≤ 9007199254740992 ∧ (4503599627370496 ≤ K ∨ E = -1022) ∧
    (E = 1023 → K ≤ 9007199254740991) at hb
  have hEl : -1022 ≤ E := he.1
  have hEu : E ≤ 1023 := he.2.1
  have hku : k ≤ 2 ^ 53 := by omega
  have hql : -1074 ≤ q := by omega
  change pack Float.Model.Format.binary64
    (if h : (shiftToTargetExponent Float.Model.Format.binary64 k first.2 .exact).1.mantissa = 0 then
      .zero (nativeSign negative)
    else .finite (nativeSign negative)
      (shiftToTargetExponent Float.Model.Format.binary64 k first.2 .exact).1.mantissa
      (shiftToTargetExponent Float.Model.Format.binary64 k first.2 .exact).2
      (Nat.pos_of_ne_zero h)) = _
  rw [hf.1, secondPass64 k q hku hql]
  by_cases hc : k = 2 ^ 53
  · have hK : K = 9007199254740992 := by omega
    have hE : E + 1 ≤ 1023 := by omega
    rw [if_pos hc]
    simp only [show (2 ^ 52 : ℕ) ≠ 0 from by decide, ↓reduceDIte]
    rw [show q + 1 = (E + 1) - 52 from by omega]
    rw [packFinite64_eq negative (E + 1) (2 ^ 52) (by decide) (by decide) (by omega) hE]
    simp only [binaryCarry, fp64, hK]
    rfl
  · rw [if_neg hc]
    have hK : K ≠ 9007199254740992 := by omega
    have hcarry : binaryCarry fp64 E K = (E, K) := by
      change (if K = 9007199254740992 then _ else _) = _
      rw [if_neg hK]
    rw [hcarry]
    by_cases hz : k = 0
    · rw [dif_pos hz, packZero64_eq]
      have hK0 : K = 0 := by omega
      rw [hK0]
      exact (encodeZero64_eq negative E).symm
    · rw [dif_neg hz, hq]
      rw [packFinite64_eq negative E k (by omega) (by omega) hEl hEu, hk]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.encodeZero64_eq](LeanBridge64.md#decl-9db9d280d3c864b3), [TensorCore.IEEE.LeanBridge.firstPass64](LeanRounding64.md#decl-25a14bb65450486f), [TensorCore.IEEE.LeanBridge.packFinite64_eq](LeanBridge64.md#decl-05949554c1fd3c44), [TensorCore.IEEE.LeanBridge.packZero64_eq](LeanBridge64.md#decl-25839643d33202cf), [TensorCore.IEEE.LeanBridge.secondPass64](LeanRounding64.md#decl-1b6cc21d58f9cda6), [TensorCore.IEEE.LeanBridge.targetExponent64_eq](LeanRounding64.md#decl-459c5dd362ffb581), [TensorCore.binaryConvCoeff_bounds](../Core/Binary/ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](../Core/Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.binaryCarry](../Core/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4)

</details>

</details>

<a id="decl-6e29d2958e392228"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteBits64_encode</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L264)

```lean
theorem finiteBits64_encode (x : ℚ) (hx : x ≠ 0) (hr : absQ x ≤ fp64.maxFinite) :
    finiteBits .binary64 .nearestEven x hr =
      let E := binaryConvExp fp64 (absQ x)
      let K := rneInt (absQ x / pow2 (E - 52))
      encodeBinary fp64 (decide (x < 0)) (binaryCarry fp64 E K).1 (binaryCarry fp64 E K).2 := by
  have h := finiteBits_eq .binary64 .nearestEven x hr
  change roundBinary fp64 .nearestEven x = some _ at h
  unfold roundBinary at h
  rw [if_neg (by decide : ¬ ¬ fp64.WellFormed), if_neg (Rat.not_lt.mpr hr), if_neg hx] at h
  dsimp only at h ⊢
  simp only [binaryCoefficient, show fp64.fractionBits = 52 from rfl] at h
  generalize hc : binaryCarry fp64 (binaryConvExp fp64 (absQ x))
    (rneInt (absQ x / pow2 (binaryConvExp fp64 (absQ x) - 52))) = c at h ⊢
  rcases c with ⟨E, K⟩
  change (if E > fp64.emax then none else some (encodeBinary fp64 (decide (x < 0)) E K)) = some _ at h
  split at h
  · contradiction
  · exact (Option.some.inj h).symm
```

**Supporting proofs:** [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Core/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4)

</details>

</details>

<a id="decl-de5cd6300d590df4"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packRound64_reference</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L283)

```lean
theorem packRound64_reference (negative : Bool) (m : ℕ) (e : ℤ) (hm : 0 < m)
    (tinyMode : Tininess) (hr : (m : ℚ) * pow2 e ≤ fp64.maxFinite) :
    pack Float.Model.Format.binary64
      (Float.Model.UnpackedFloat.round Float.Model.Format.binary64 (nativeSign negative) m e) =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ negative
        (if negative then -((m : ℚ) * pow2 e) else (m : ℚ) * pow2 e)).bits := by
  have hx : 0 < (m : ℚ) * pow2 e := Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
  have habs : absQ ((m : ℚ) * pow2 e) = (m : ℚ) * pow2 e := absQ_of_nonneg (Rat.le_of_lt hx)
  have hnabs : absQ (-((m : ℚ) * pow2 e)) = (m : ℚ) * pow2 e := by rw [absQ_neg, habs]
  have hne : (m : ℚ) * pow2 e ≠ 0 := Rat.ne_of_gt hx
  have hnne : -((m : ℚ) * pow2 e) ≠ 0 := by grind
  have hneg : -((m : ℚ) * pow2 e) < 0 := by grind
  have hnneg : ¬ (m : ℚ) * pow2 e < 0 := by grind
  rw [packRound64_eq negative m e hm hr]
  cases negative <;>
    simp only [Bool.false_eq_true, ↓reduceIte, TensorCore.IEEE.round,
      BinaryFormat.layout, hne, hnne, habs, hnabs, hr, ↓reduceDIte] <;>
    rw [finiteBits64_encode _ (by assumption) (by simpa only [habs, hnabs] using hr)] <;>
    simp only [habs, hnabs, hneg, hnneg, decide_true, decide_false]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.finiteBits64_encode](LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Core/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349)

</details>

</details>

<a id="decl-a816cd1acc4bf349"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.packNormalize64_reference</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L303)

```lean
theorem packNormalize64_reference (m : ℤ) (e : ℤ) (tinyMode : Tininess)
    (hr : absQ ((m : ℚ) * pow2 e) ≤ fp64.maxFinite) :
    pack Float.Model.Format.binary64
      (normalize Float.Model.Format.binary64 m e .positive) =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
        ((m : ℚ) * pow2 e)).bits := by
  by_cases hz : m = 0
  · subst m
    rw [show (normalize Float.Model.Format.binary64 0 e .positive) = .zero .positive from rfl]
    simp only [Rat.intCast_zero, Rat.zero_mul, round_zero]
    exact packZero64_eq false
  by_cases hn : m < 0
  · have hm : 0 < (-m).toNat := by omega
    have hcast : (((-m).toNat : ℕ) : ℚ) = -(m : ℚ) := by
      rw [← Rat.intCast_natCast, Int.toNat_of_nonneg (by omega), Rat.intCast_neg]
    have hvalue : ((m : ℚ) * pow2 e) = -((((-m).toNat : ℕ) : ℚ) * pow2 e) := by
      rw [hcast]; grind
    have hp : 0 < (((-m).toNat : ℕ) : ℚ) * pow2 e :=
      Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
    have hrange : (((-m).toNat : ℕ) : ℚ) * pow2 e ≤ fp64.maxFinite := by
      simpa only [hvalue, absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
    have h := packRound64_reference true (-m).toNat e hm tinyMode hrange
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
    have hrange : ((m.toNat : ℕ) : ℚ) * pow2 e ≤ fp64.maxFinite := by
      simpa only [hcast, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
    have h := packRound64_reference false m.toNat e hm tinyMode hrange
    simp only [nativeSign, Bool.false_eq_true, ↓reduceIte, hcast] at h
    rw [normalize, Int.compare_eq_gt.mpr (by omega)]
    exact h
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.packZero64_eq](LeanBridge64.md#decl-25839643d33202cf), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90)

</details>

</details>

<a id="decl-719acb811d540de8"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteValue64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L345)

```lean
def finiteValue64 (a : F64) : ℚ :=
  (nativeSign (sign64 a) |>.apply (mantissa64 a) : ℤ) * pow2 (exponent64 a)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteValue64_mul](LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-edb49af988e758ce"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L348)

```lean
def nativeAdd64 (a b : F64) (ha : Native64Valid a) (hb : Native64Valid b) : F64 :=
  fromNative64 (toNative64 a ha + toNative64 b hb)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0), [TensorCore.IEEE.LeanBridge.fromNative64](LeanBridge64.md#decl-deb8fe9c1e65efcb), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858)

</details>

</details>

<a id="decl-33dce507c25c18ec"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd64_reference</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L351)

```lean
theorem nativeAdd64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a + finiteValue64 b) ≤ fp64.maxFinite) :
    nativeAdd64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.add .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.add Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.add]
  have hv := aligned_add_value (nativeSign (sign64 a)) (nativeSign (sign64 b))
    (mantissa64 a) (mantissa64 b) (exponent64 a) (exponent64 b)
  have hround := packNormalize64_reference
    ((nativeSign (sign64 a)).apply
      (decreaseExponent (mantissa64 a) (exponent64 a) (min (exponent64 a) (exponent64 b))).1 +
     (nativeSign (sign64 b)).apply
      (decreaseExponent (mantissa64 b) (exponent64 b) (min (exponent64 a) (exponent64 b))).1)
    (min (exponent64 a) (exponent64 b)) tinyMode (by simpa only [hv, finiteValue64] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue64 a + finiteValue64 b)).bits =
    (addDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b)).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue64 a + finiteValue64 b)).bits =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign64 a) (sign64 b))
        (finiteValue64 a + finiteValue64 b)).bits
  cases sa : sign64 a <;> cases sb : sign64 b
  all_goals try rfl
  have hpa : 0 < (mantissa64 a : ℚ) * pow2 (exponent64 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa64 b : ℚ) * pow2 (exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue64 a + finiteValue64 b ≠ 0 := by
    simp only [finiteValue64, sa, sb, nativeSign, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.aligned_add_value](LeanBridge.md#decl-e6cb66147cd6c96f), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858)

</details>

</details>

<a id="decl-7e84d1bdfb668472"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeSub64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L390)

```lean
def nativeSub64 (a b : F64) (ha : Native64Valid a) (hb : Native64Valid b) : F64 :=
  fromNative64 (toNative64 a ha - toNative64 b hb)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0), [TensorCore.IEEE.LeanBridge.fromNative64](LeanBridge64.md#decl-deb8fe9c1e65efcb), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-44c97805468e4e90"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeSub64_reference</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L393)

```lean
theorem nativeSub64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a - finiteValue64 b) ≤ fp64.maxFinite) :
    nativeSub64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.sub .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.sub Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.sub]
  have hv := aligned_sub_value (nativeSign (sign64 a)) (nativeSign (sign64 b))
    (mantissa64 a) (mantissa64 b) (exponent64 a) (exponent64 b)
  have hround := packNormalize64_reference
    ((nativeSign (sign64 a)).apply
      (decreaseExponent (mantissa64 a) (exponent64 a) (min (exponent64 a) (exponent64 b))).1 -
     (nativeSign (sign64 b)).apply
      (decreaseExponent (mantissa64 b) (exponent64 b) (min (exponent64 a) (exponent64 b))).1)
    (min (exponent64 a) (exponent64 b)) tinyMode (by simpa only [hv, finiteValue64] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue64 a - finiteValue64 b)).bits =
    (addDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b).negate).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
  rw [← Rat.sub_eq_add_neg]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue64 a - finiteValue64 b)).bits =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign64 a) (!(sign64 b)))
        (finiteValue64 a - finiteValue64 b)).bits
  cases sa : sign64 a <;> cases sb : sign64 b
  all_goals try rfl
  have hpa : 0 < (mantissa64 a : ℚ) * pow2 (exponent64 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa64 b : ℚ) * pow2 (exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue64 a - finiteValue64 b ≠ 0 := by
    simp only [finiteValue64, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.aligned_sub_value](LeanBridge.md#decl-e1219acca53993f8), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-51d99b65e12a8651"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.mantissa64_normal_or_min</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L434)

```lean
theorem mantissa64_normal_or_min (a : F64) :
    2 ^ 52 ≤ mantissa64 a ∨ exponent64 a = -1074 := by
  by_cases h : a.toNat / 4503599627370496 % 2048 = 0
  · exact Or.inr (by simp [exponent64, h])
  · left
    simp only [mantissa64, h, ↓reduceIte]
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.product64_no_leftshift](LeanBridge64.md#decl-5bf600a946cde73f)

</details>

</details>

<a id="decl-5bf600a946cde73f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.product64_no_leftshift</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L442)

```lean
theorem product64_no_leftshift (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) :
    exponent64 a + exponent64 b ≤ Float.Model.Format.binary64.targetExponent
      (Float.Model.totalExponent (mantissa64 a * mantissa64 b) (exponent64 a + exponent64 b)) := by
  have hp : 0 < mantissa64 a * mantissa64 b := Nat.mul_pos ha.2 hb.2
  have hma : mantissa64 a ≤ mantissa64 a * mantissa64 b := by
    have hh := Nat.mul_le_mul_left (mantissa64 a) (show 1 ≤ mantissa64 b by have := hb.2; omega)
    simpa using hh
  have hmb : mantissa64 b ≤ mantissa64 a * mantissa64 b := by
    have hh := Nat.mul_le_mul_right (mantissa64 b) (show 1 ≤ mantissa64 a by have := ha.2; omega)
    simpa using hh
  change exponent64 a + exponent64 b ≤
    max ((mantissa64 a * mantissa64 b).log2 + 1 + (exponent64 a + exponent64 b) - 53) (-1074 : ℤ)
  rcases mantissa64_normal_or_min a with h | h
  · have hl := (Nat.le_log2 (show mantissa64 a * mantissa64 b ≠ 0 by omega)).mpr (Nat.le_trans h hma)
    omega
  · rcases mantissa64_normal_or_min b with h' | h'
    · have hl := (Nat.le_log2 (show mantissa64 a * mantissa64 b ≠ 0 by omega)).mpr (Nat.le_trans h' hmb)
      omega
    · omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.mantissa64_normal_or_min](LeanBridge64.md#decl-51d99b65e12a8651)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519)

</details>

</details>

<a id="decl-4ffd08fe45f76628"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.roundWithAccuracy_eq_round64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L462)

```lean
theorem roundWithAccuracy_eq_round64 (s : Sign) (m : ℕ) (e : ℤ)
    (h : e ≤ Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)) :
    roundWithAccuracy Float.Model.Format.binary64 s m e .exact =
      Float.Model.UnpackedFloat.round Float.Model.Format.binary64 s m e := by
  have hn : (e - Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)).toNat = 0 := by omega
  simp [Float.Model.UnpackedFloat.round, decreaseExponent, hn]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519)

</details>

</details>

<a id="decl-4c9ad531b46eeeaa"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteValue64_mul</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L469)

```lean
theorem finiteValue64_mul (a b : F64) :
    finiteValue64 a * finiteValue64 b =
      if xor (sign64 a) (sign64 b) then
        -(((mantissa64 a * mantissa64 b : ℕ) : ℚ) * pow2 (exponent64 a + exponent64 b))
      else ((mantissa64 a * mantissa64 b : ℕ) : ℚ) * pow2 (exponent64 a + exponent64 b) := by
  cases sa : sign64 a <;> cases sb : sign64 b <;>
    simp only [finiteValue64, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte,
      Sign.apply, Rat.intCast_neg, Rat.intCast_natCast, Rat.natCast_mul, pow2_add,
      Bool.false_xor, Bool.true_xor, Bool.not_false, Bool.not_true] <;> grind
```

**Supporting proofs:** [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519)

</details>

</details>

<a id="decl-ead2c816910837bb"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeMul64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L479)

```lean
def nativeMul64 (a b : F64) (ha : Native64Valid a) (hb : Native64Valid b) : F64 :=
  fromNative64 (toNative64 a ha * toNative64 b hb)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0), [TensorCore.IEEE.LeanBridge.fromNative64](LeanBridge64.md#decl-deb8fe9c1e65efcb), [TensorCore.IEEE.LeanBridge.toNative64](LeanBridge64.md#decl-04c8275660328ad9)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5)

</details>

</details>

<a id="decl-3fb33b56bef96519"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeMul64_reference</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanBridge64.lean#L482)

```lean
theorem nativeMul64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a * finiteValue64 b) ≤ fp64.maxFinite) :
    nativeMul64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.mul .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  have hm := Nat.mul_pos ha.2 hb.2
  have hp : 0 < ((mantissa64 a * mantissa64 b : ℕ) : ℚ) * pow2 (exponent64 a + exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos _)
  have hrange : ((mantissa64 a * mantissa64 b : ℕ) : ℚ) *
      pow2 (exponent64 a + exponent64 b) ≤ fp64.maxFinite := by
    rw [finiteValue64_mul] at hr
    split at hr <;> simpa only [absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.mul Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.mul]
  rw [nativeSign_mul, roundWithAccuracy_eq_round64 _ _ _ (product64_no_leftshift a b ha hb),
    packRound64_reference _ _ _ hm tinyMode hrange, ← finiteValue64_mul]
  change (round .binary64 ⟨.nearestEven, tinyMode⟩ (xor (sign64 a) (sign64 b))
    (finiteValue64 a * finiteValue64 b)).bits =
      (mulDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b)).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.nativeSign_mul](LeanBridge.md#decl-ab7a5cf4dc018ec2), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.product64_no_leftshift](LeanBridge64.md#decl-5bf600a946cde73f), [TensorCore.IEEE.LeanBridge.roundWithAccuracy_eq_round64](LeanBridge64.md#decl-4ffd08fe45f76628), [TensorCore.IEEE.LeanBridge.unpack64_nonzero](LeanBridge64.md#decl-df22d92cc0097ad0), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5)

</details>

</details>
