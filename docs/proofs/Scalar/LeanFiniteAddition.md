# TensorCore.Scalar.LeanFiniteAddition

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-6dac9e31f477fbbe"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.value32_nonzero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L13)

```lean
theorem value32_nonzero (a : F32) (ha : NonzeroFinite32 a) :
    TensorCore.value32 a = some (finiteValue32 a) := by
  have h := (decode_finite_iff .binary32 a (sign32 a) (finiteValue32 a)).mp
    (decode32_nonzero a ha)
  exact h.1
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.binaryValue](../Numerics/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](LeanFiniteAddition.md#decl-4eefaec604b419ba)

</details>

</details>

<a id="decl-22752ecea454be9e"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L19)

```lean
theorem round32_ieee_positive_zero (x : ℚ) (hr : absQ x ≤ fp32.maxFinite) :
    TensorCore.round32 .nearestEven x = some (round .binary32 {} false x).bits := by
  by_cases hz : x = 0
  · subst x
    rw [round_zero]
    change TensorCore.round32 .nearestEven 0 = some (0 : F32)
    decide +kernel
  · exact round_agrees_finite .binary32 {} false x hz hr
```

**Supporting proofs:** [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92)

</details>

</details>

<a id="decl-704bb8c1299ecd92"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd32_round</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L28)

```lean
theorem nativeAdd32_round (a b : F32) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    TensorCore.round32 .nearestEven (finiteValue32 a + finiteValue32 b) =
      some (nativeAdd32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1)) := by
  have hv := aligned_add_value (nativeSign (sign32 a)) (nativeSign (sign32 b))
    (mantissa32 a) (mantissa32 b) (exponent32 a) (exponent32 b)
  have hround := packNormalize32_reference
    ((nativeSign (sign32 a)).apply
      (decreaseExponent (mantissa32 a) (exponent32 a) (min (exponent32 a) (exponent32 b))).1 +
     (nativeSign (sign32 b)).apply
      (decreaseExponent (mantissa32 b) (exponent32 b) (min (exponent32 a) (exponent32 b))).1)
    (min (exponent32 a) (exponent32 b)) .afterRounding (by simpa only [hv, finiteValue32] using hr)
  change _ = some (pack Float.Model.Format.binary32
    (Float.Model.UnpackedFloat.add Float.Model.Format.binary32
      (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 b)))
  rw [unpack32_nonzero a ha, unpack32_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.add]
  rw [hround, hv]
  exact round32_ieee_positive_zero _ hr
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.aligned_add_value](LeanBridge.md#decl-e6cb66147cd6c96f), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-8239435efdc98204"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.zero_or_nonzero32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L48)

```lean
theorem zero_or_nonzero32 (a : F32) (hf : a.toNat / 8388608 % 256 < 255) :
    a = 0 ∨ a = 0x80000000 ∨ NonzeroFinite32 a := by
  by_cases hm : 0 < mantissa32 a
  · exact Or.inr (Or.inr ⟨hf, hm⟩)
  · have hn := a.isLt
    have he : a.toNat / 8388608 % 256 = 0 := by
      simp only [mantissa32] at hm
      split at hm <;> omega
    have hm' : a.toNat % 8388608 = 0 := by simpa [mantissa32, he] using hm
    have h : a.toNat = 0 ∨ a.toNat = 2147483648 := by omega
    rcases h with h | h
    · exact Or.inl (BitVec.eq_of_toNat_eq h)
    · exact Or.inr (Or.inl (BitVec.eq_of_toNat_eq h))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-343e8c9e056e8d78"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L62)

```lean
theorem pack_unpack32_nonzero (a : F32) (ha : NonzeroFinite32 a) :
    pack Float.Model.Format.binary32 (unpack Float.Model.Format.binary32 a) = a := by
  rw [unpack32_nonzero a ha]
  have hm : a.toNat % 8388608 < 8388608 := Nat.mod_lt _ (by decide)
  have hn := a.isLt
  have he := ha.1
  by_cases hz : a.toNat / 8388608 % 256 = 0
  · have hk : 0 < a.toNat % 8388608 := by simpa [mantissa32, hz] using ha.2
    simp only [mantissa32, exponent32, hz, ↓reduceIte]
    rw [show (-149 : ℤ) = -126 - 23 by decide,
      packFinite32_eq _ _ _ hk (by omega) (by omega) (by omega)]
    apply BitVec.eq_of_toNat_eq
    simp only [encodeBinary, fp32, BitVec.toNat_ofNat, sign32]
    by_cases hs : a.toNat / 2147483648 = 0 <;>
      simp [Format.width, hs, show (a.toNat % 8388608 : ℤ) < 8388608 by omega] <;> omega
  · simp only [mantissa32, exponent32, hz, ↓reduceIte]
    rw [show (a.toNat / 8388608 % 256 : ℤ) - 150 =
      ((a.toNat / 8388608 % 256 : ℤ) - 127) - 23 by omega,
      packFinite32_eq _ _ _ (by omega) (by omega) (by omega) (by omega)]
    apply BitVec.eq_of_toNat_eq
    simp only [encodeBinary, fp32, BitVec.toNat_ofNat, sign32]
    by_cases hs : a.toNat / 2147483648 = 0 <;>
      simp [Format.width, hs, show ¬ (8388608 + a.toNat % 8388608 : ℤ) < 8388608 by omega] <;> omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.packFinite32_eq](LeanBridge.md#decl-cb2a2e247f1137bf), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.encodeBinary](../Numerics/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893)

</details>

</details>

<a id="decl-11d149ae2446df9e"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L87)

```lean
theorem finiteValue32_ne_zero (a : F32) (ha : NonzeroFinite32 a) : finiteValue32 a ≠ 0 := by
  have hp : 0 < (mantissa32 a : ℚ) * pow2 (exponent32 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  unfold finiteValue32 nativeSign
  split <;> simp only [Sign.apply, Rat.intCast_neg, Rat.intCast_natCast] <;> grind
```

**Supporting proofs:** [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.round32_finiteValue32](LeanFiniteAddition.md#decl-4eefaec604b419ba)

</details>

</details>

<a id="decl-4eefaec604b419ba"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.round32_finiteValue32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L93)

```lean
theorem round32_finiteValue32 (a : F32) (ha : NonzeroFinite32 a) :
    TensorCore.round32 .nearestEven (finiteValue32 a) = some a :=
  binaryValue_roundBinary fp32 (by decide) .nearestEven a (finiteValue32 a)
    (value32_nonzero a ha) (finiteValue32_ne_zero a ha)
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.binaryValue_roundBinary](../Numerics/Binary/RoundTrip.md#decl-9a5b73ab13b18c71)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-a1ca25ab4be5c9ff"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L98)

```lean
theorem nativeAdd32_zero_left (a : F32) (ha : NonzeroFinite32 a)
    (zeroBits : F32) (hz : zeroBits = 0 ∨ zeroBits = 0x80000000)
    (hv : Native32Valid zeroBits) :
    nativeAdd32 zeroBits a hv (native32Valid_finite a ha.1) = a := by
  change pack Float.Model.Format.binary32 (Float.Model.UnpackedFloat.add _
    (unpack Float.Model.Format.binary32 zeroBits) (unpack Float.Model.Format.binary32 a)) = a
  rcases hz with rfl | rfl
  all_goals
    first
    | rw [show unpack Float.Model.Format.binary32 (0 : F32) = .zero .positive by rfl]
    | rw [show unpack Float.Model.Format.binary32 (0x80000000 : F32) = .zero .negative by rfl]
  all_goals
    have hp := pack_unpack32_nonzero a ha
    rw [unpack32_nonzero a ha] at hp ⊢
    exact hp
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-9ad827220cf97893"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L114)

```lean
theorem nativeAdd32_zero_right (a : F32) (ha : NonzeroFinite32 a)
    (zeroBits : F32) (hz : zeroBits = 0 ∨ zeroBits = 0x80000000)
    (hv : Native32Valid zeroBits) :
    nativeAdd32 a zeroBits (native32Valid_finite a ha.1) hv = a := by
  change pack Float.Model.Format.binary32 (Float.Model.UnpackedFloat.add _
    (unpack Float.Model.Format.binary32 a) (unpack Float.Model.Format.binary32 zeroBits)) = a
  rcases hz with rfl | rfl
  all_goals
    first
    | rw [show unpack Float.Model.Format.binary32 (0 : F32) = .zero .positive by rfl]
    | rw [show unpack Float.Model.Format.binary32 (0x80000000 : F32) = .zero .negative by rfl]
  all_goals
    have hp := pack_unpack32_nonzero a ha
    rw [unpack32_nonzero a ha] at hp ⊢
    exact hp
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.LeanBridge.unpack32_nonzero](LeanBridge.md#decl-f123b7b61612ffd1)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-df4619107a985056"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nonzero32_ne_negative_zero</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L130)

```lean
theorem nonzero32_ne_negative_zero (a : F32) (ha : NonzeroFinite32 a) : a ≠ 0x80000000 := by
  intro h
  subst a
  exact (by decide : ¬ NonzeroFinite32 0x80000000) ha
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-f0674d78ec7d02c2"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeFiniteAdd32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L137)

```lean
/-- Finite EFT arithmetic identifies exact zero with positive zero. Native RNE
addition differs only for two negative-zero operands, which this adapter normalizes. -/
def nativeFiniteAdd32 (a b : F32)
    (ha : a.toNat / 8388608 % 256 < 255) (hb : b.toNat / 8388608 % 256 < 255) : F32 :=
  if a = 0x80000000 ∧ b = 0x80000000 then 0
  else nativeAdd32 a b (native32Valid_finite a ha) (native32Valid_finite b hb)
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.add32WithLean](../Kernels/EFT/Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.add32WithLean_eq](../Kernels/EFT/Native.md#decl-606ce6330a627312), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

</details>

</details>

<a id="decl-ee1136b3a2cc3036"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanFiniteAddition.lean#L145)

```lean
/-- Every finite encoded pair uses native addition, with the EFT zero convention.
The range premise is the original finite converter's domain, not just finite output. -/
theorem nativeFiniteAdd32_round (a b : F32)
    (ha : a.toNat / 8388608 % 256 < 255) (hb : b.toNat / 8388608 % 256 < 255)
    (x y : ℚ) (hx : TensorCore.value32 a = some x) (hy : TensorCore.value32 b = some y)
    (hr : absQ (x + y) ≤ fp32.maxFinite) :
    TensorCore.round32 .nearestEven (x + y) = some (nativeFiniteAdd32 a b ha hb) := by
  rcases zero_or_nonzero32 a ha with rfl | rfl | ha'
  all_goals rcases zero_or_nonzero32 b hb with rfl | rfl | hb'
  case inl.inl | inl.inr.inl | inr.inl.inl | inr.inl.inr.inl =>
    simp only [show TensorCore.value32 (0 : F32) = some 0 by decide +kernel,
      show TensorCore.value32 (0x80000000 : F32) = some 0 by decide +kernel, Option.some.injEq] at hx hy
    subst x
    subst y
    decide +kernel +revert
  case inl.inr.inr | inr.inl.inr.inr =>
    have hy' := Option.some.inj (hy.symm.trans (value32_nonzero _ hb'))
    have hx' : x = 0 := Option.some.inj (hx.symm.trans (by decide +kernel))
    rw [hx', hy', Rat.zero_add]
    unfold nativeFiniteAdd32
    rw [if_neg (fun h => nonzero32_ne_negative_zero _ hb' h.2),
      nativeAdd32_zero_left _ hb' _ (by first | exact Or.inl rfl | exact Or.inr rfl)]
    exact round32_finiteValue32 _ hb'
  case inr.inr.inl | inr.inr.inr.inl =>
    have hx' := Option.some.inj (hx.symm.trans (value32_nonzero _ ha'))
    have hy' : y = 0 := Option.some.inj (hy.symm.trans (by decide +kernel))
    rw [hx', hy', Rat.add_zero]
    unfold nativeFiniteAdd32
    rw [if_neg (fun h => nonzero32_ne_negative_zero _ ha' h.1),
      nativeAdd32_zero_right _ ha' _ (by first | exact Or.inl rfl | exact Or.inr rfl)]
    exact round32_finiteValue32 _ ha'
  case inr.inr.inr.inr =>
    have hx' := Option.some.inj (hx.symm.trans (value32_nonzero _ ha'))
    have hy' := Option.some.inj (hy.symm.trans (value32_nonzero _ hb'))
    rw [hx', hy'] at hr ⊢
    unfold nativeFiniteAdd32
    rw [if_neg (fun h => nonzero32_ne_negative_zero _ ha' h.1)]
    exact nativeAdd32_round a b ha' hb' hr
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_left](LeanFiniteAddition.md#decl-a1ca25ab4be5c9ff), [TensorCore.IEEE.LeanBridge.nativeAdd32_zero_right](LeanFiniteAddition.md#decl-9ad827220cf97893), [TensorCore.IEEE.LeanBridge.nonzero32_ne_negative_zero](LeanFiniteAddition.md#decl-df4619107a985056), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.LeanBridge.zero_or_nonzero32](LeanFiniteAddition.md#decl-8239435efdc98204)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32](LeanFiniteAddition.md#decl-f0674d78ec7d02c2), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.add32WithLean_eq](../Kernels/EFT/Native.md#decl-606ce6330a627312)

</details>

</details>
