# TensorCore.Core.Binary.RoundTrip

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b8f8bffe28447932"></a>

<details>
<summary><code>TensorCore.binaryCoefficient_intCast</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/RoundTrip.lean#L10)

```lean
theorem binaryCoefficient_intCast (mode : BinaryRoundingMode) (negative : Bool) (k : ℤ) :
    binaryCoefficient mode negative (k : ℚ) = k := by
  have hr := roundCoefficient_intCast .nearestEven k
  change rneInt (k : ℚ) = k at hr
  cases mode <;> cases negative <;> simp [binaryCoefficient, Rat.floor_intCast, Rat.ceil_intCast, hr]
```

**Supporting proofs:** [TensorCore.roundCoefficient_intCast](../RoundTrip.md#decl-19d63265706221b3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.RoundingMode](../RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](../RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-8ccfd6c43d66f303"></a>

<details>
<summary><code>TensorCore.BinaryRep.finiteValue</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/RoundTrip.lean#L16)

```lean
theorem BinaryRep.finiteValue {f : Format} (r : BinaryRep f) : f.FiniteValue r.value := by
  refine ⟨if r.negative then -(r.significand : ℤ) else r.significand, r.exponent,
    r.exponent_min, r.exponent_max, ?_, ?_⟩
  · cases r.negative <;> simpa using r.significand_lt
  · unfold BinaryRep.value
    cases r.negative <;> simp [Rat.intCast_natCast]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-45ba7850d1a076bc"></a>

<details>
<summary><code>TensorCore.BinaryRep.value_eq_zero_iff</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/RoundTrip.lean#L23)

```lean
theorem BinaryRep.value_eq_zero_iff {f : Format} (r : BinaryRep f) :
    r.value = 0 ↔ r.significand = 0 := by
  have hq := pow2_pos (r.exponent - f.fractionBits)
  unfold BinaryRep.value
  cases r.negative <;> simp only [Bool.false_eq_true, ↓reduceIte, Rat.neg_mul]
  · rw [Rat.mul_eq_zero]; simp [Rat.ne_of_gt hq]
  · have h : -(r.significand : ℚ) * pow2 (r.exponent - f.fractionBits) = 0 ↔
        (r.significand : ℚ) * pow2 (r.exponent - f.fractionBits) = 0 := by grind
    rw [Rat.neg_mul] at h
    rw [h, Rat.mul_eq_zero]; simp [Rat.ne_of_gt hq]
```

**Supporting proofs:** [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.sign_of_nonzero](SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-3e97bd2100d6f1d3"></a>

<details>
<summary><code>TensorCore.roundBinary_canonical</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/RoundTrip.lean#L35)

```lean
/-- All four modes fix every nonzero canonical finite encoding. -/
theorem roundBinary_canonical (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (r : BinaryRep f) (hk : r.significand ≠ 0) :
    roundBinary f mode r.value = some r.encode := by
  have hq := pow2_pos (r.exponent - f.fractionBits)
  have hkR : (0 : ℚ) < (r.significand : ℚ) := Rat.natCast_pos.mpr (by omega)
  have hpos := Rat.mul_pos hkR hq
  have hmag : absQ r.value = (r.significand : ℚ) * pow2 (r.exponent - f.fractionBits) := by
    unfold BinaryRep.value
    cases r.negative <;> simp only [Bool.false_eq_true, ↓reduceIte]
    · exact absQ_of_nonneg (Rat.le_of_lt hpos)
    · rw [Rat.neg_mul, absQ_neg, absQ_of_nonneg (Rat.le_of_lt hpos)]
  have hrange := f.finiteValue_abs_le r.finiteValue
  have hne : r.value ≠ 0 := by simpa [r.value_eq_zero_iff] using hk
  have hexp : binaryConvExp f ((r.significand : ℚ) * pow2 (r.exponent - f.fractionBits)) =
      r.exponent := by
    unfold binaryConvExp
    by_cases hnormal : 2 ^ f.fractionBits ≤ r.significand
    · have hlo : pow2 r.exponent ≤ (r.significand : ℚ) * pow2 (r.exponent - f.fractionBits) := by
        rw [f.binade_grid]
        exact Rat.mul_le_mul_of_nonneg_right (Rat.natCast_le_natCast.mpr hnormal) (Rat.le_of_lt hq)
      have hhi : (r.significand : ℚ) * pow2 (r.exponent - f.fractionBits) < pow2 (r.exponent + 1) := by
        rw [f.next_binade_grid]
        exact Rat.mul_lt_mul_of_pos_right (Rat.natCast_lt_natCast.mpr r.significand_lt) hq
      rw [magnitudeExponent_eq_of_bounds _ r.exponent hlo hhi]
      exact Int.max_eq_left r.exponent_min
    · have he : r.exponent = f.emin := by have := r.normalized; omega
      have hsmall : (r.significand : ℚ) * pow2 (r.exponent - f.fractionBits) < pow2 r.exponent := by
        rw [f.binade_grid r.exponent]
        exact Rat.mul_lt_mul_of_pos_right
          (Rat.natCast_lt_natCast.mpr (show r.significand < 2 ^ f.fractionBits by omega)) hq
      have hme : magnitudeExponent ((r.significand : ℚ) * pow2 (r.exponent - f.fractionBits)) <
          r.exponent := by
        apply Classical.byContradiction
        intro hn
        have h1 := (magnitudeExponent_spec _ hpos).1
        have h2 := pow2_le_of_le (show r.exponent ≤ magnitudeExponent
          ((r.significand : ℚ) * pow2 (r.exponent - f.fractionBits)) by omega)
        grind
      rw [he] at hme ⊢
      exact Int.max_eq_right (by omega)
  have hsign : decide (r.value < 0) = r.negative := by
    unfold BinaryRep.value
    cases r.negative <;> simp only [Bool.false_eq_true, ↓reduceIte, decide_eq_true_eq,
      decide_eq_false_iff_not]
    · exact Rat.not_lt.mpr (Rat.le_of_lt hpos)
    · rw [Rat.neg_mul]; grind
  unfold roundBinary
  rw [if_neg (by exact fun h => h hf), if_neg (Rat.not_lt.mpr hrange), if_neg hne,
    hsign, hmag, hexp]
  dsimp only
  rw [Rat.mul_div_cancel (Rat.ne_of_gt hq)]
  rw [show (r.significand : ℚ) = ((r.significand : ℤ) : ℚ) from rfl,
    binaryCoefficient_intCast]
  have hcarry : binaryCarry f r.exponent r.significand = (r.exponent, (r.significand : ℤ)) := by
    unfold binaryCarry
    rw [if_neg (by have := r.significand_lt; omega)]
  rw [hcarry]
  dsimp only
  rw [if_neg (Int.not_lt.mpr r.exponent_max)]
  rfl
```

**Supporting proofs:** [TensorCore.BinaryRep.finiteValue](RoundTrip.md#decl-8ccfd6c43d66f303), [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.Format.binade_grid](ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finiteValue_abs_le](ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.next_binade_grid](ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.absQ_neg](../Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.binaryCoefficient_intCast](RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.magnitudeExponent_eq_of_bounds](../Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_spec](../Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_le_of_le](../Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.magnitudeExponent](../RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71)

</details>

</details>

<a id="decl-9a5b73ab13b18c71"></a>

<details>
<summary><code>TensorCore.binaryValue_roundBinary</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/RoundTrip.lean#L96)

```lean
theorem binaryValue_roundBinary (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (b : BitVec f.width) (v : ℚ) (hv : binaryValue f b = some v) (hnz : v ≠ 0) :
    roundBinary f mode v = some b := by
  have hb : ∃ d, (classify f b).finite = some d := by
    unfold binaryValue at hv
    cases hd : (classify f b).finite with
    | none => simp [hd] at hv
    | some d => exact ⟨d, rfl⟩
  let w : FiniteBinaryWord f := ⟨b, hb⟩
  let r := decodeBinaryRep f hf w
  have hval : r.value = v := Option.some.inj ((decodeBinaryRep_value f hf w).symm.trans hv)
  have hbits := congrArg Subtype.val (encode_decodeBinaryRep f hf w)
  have hround := roundBinary_canonical f hf mode r
    (by intro hz; exact hnz (hval.symm.trans (r.value_eq_zero_iff.mpr hz)))
  change r.encode = b at hbits
  rwa [hval, hbits] at hround
```

**Supporting proofs:** [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.round32_finiteValue32](../../IEEE/LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.convert_self_finite](../../IEEE/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.Regression.finite_bijection_endpoints](../../TC/Regression/DirectedBinary.md#decl-b74680eb28ad51fd), [TensorCore.binaryValue_injective_nonzero](RoundTrip.md#decl-0ab63ba315dd3cca)

</details>

</details>

<a id="decl-0ab63ba315dd3cca"></a>

<details>
<summary><code>TensorCore.binaryValue_injective_nonzero</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/RoundTrip.lean#L113)

```lean
theorem binaryValue_injective_nonzero (f : Format) (hf : f.WellFormed)
    (b₁ b₂ : BitVec f.width) (v : ℚ) (h₁ : binaryValue f b₁ = some v)
    (h₂ : binaryValue f b₂ = some v) (hnz : v ≠ 0) : b₁ = b₂ := by
  have r₁ := binaryValue_roundBinary f hf .towardZero b₁ v h₁ hnz
  have r₂ := binaryValue_roundBinary f hf .towardZero b₂ v h₂ hnz
  exact Option.some.inj (r₁.symm.trans r₂)
```

**Supporting proofs:** [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03)

</details>

</details>
