# TensorCore.Numerics.Binary.RoundingContract

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-88c3ff9da8e0df3a"></a>

<details>
<summary><code>TensorCore.BinaryRoundSpec</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundingContract.lean#L9)

```lean
def BinaryRoundSpec (f : Format) (mode : BinaryRoundingMode) (x : ℚ)
    (bits : BitVec f.width) : Prop :=
  match mode with
  | .nearestEven => NearestEven f x bits
  | .towardZero => TowardZero f x bits
  | .towardNegative => TowardNegative f x bits
  | .towardPositive => TowardPositive f x bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardNegative](DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.TowardPositive](DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.TowardZero](CorrectRounding.md#decl-ea87f85641f1fbf8)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec.finite](RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.IEEE.RoundSpec](../../Scalar/Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.finiteBits_correct](../../Scalar/Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.round_correct](../../Scalar/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.binary64Fma_correct](../../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_success](../../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_isSome_iff](RoundingContract.md#decl-9083817d3e897973)

</details>

</details>

<a id="decl-12a22af180d3ad5e"></a>

<details>
<summary><code>TensorCore.roundBinary_correct</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundingContract.lean#L17)

```lean
theorem roundBinary_correct (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (x : ℚ) (hr : absQ x ≤ f.maxFinite) :
    ∃ bits, roundBinary f mode x = some bits ∧ BinaryRoundSpec f mode x bits := by
  cases mode
  · exact roundBinary_towardZero_correct f hf x hr
  · exact roundBinary_nearestEven_correct f hf x hr
  · exact roundBinary_towardNegative_correct f hf x hr
  · exact roundBinary_towardPositive_correct f hf x hr
```

**Supporting proofs:** [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

**Definitions and types:** [TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.finiteBits_correct](../../Scalar/Rounding.md#decl-95af8d895fd749ac), [TensorCore.binary64Fma_correct](../../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_success](../../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.roundBinary_isSome_iff](RoundingContract.md#decl-9083817d3e897973)

</details>

</details>

<a id="decl-5fa4e1dc58d238c5"></a>

<details>
<summary><code>TensorCore.BinaryRoundSpec.finite</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundingContract.lean#L26)

```lean
theorem BinaryRoundSpec.finite {f : Format} {mode : BinaryRoundingMode} {x : ℚ}
    {bits : BitVec f.width} (h : BinaryRoundSpec f mode x bits) :
    ∃ d, (classify f bits).finite = some d := by
  have hv : ∃ v, binaryValue f bits = some v := by
    cases mode <;> obtain ⟨v, hv, _⟩ := h <;> exact ⟨v, hv⟩
  obtain ⟨v, hv⟩ := hv
  unfold binaryValue at hv
  cases hd : (classify f bits).finite with
  | none => simp [hd] at hv
  | some d => exact ⟨d, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Between0](CorrectRounding.md#decl-e53091bc8dd24dfe), [TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_success](../../TC/FusedRounding.md#decl-b369329edfc5a2cd)

</details>

</details>

<a id="decl-9083817d3e897973"></a>

<details>
<summary><code>TensorCore.roundBinary_isSome_iff</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundingContract.lean#L37)

```lean
theorem roundBinary_isSome_iff (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    (roundBinary f mode x).isSome = true ↔ f.WellFormed ∧ absQ x ≤ f.maxFinite := by
  constructor
  · intro h
    cases hb : roundBinary f mode x with
    | none => simp [hb] at h
    | some b => exact roundBinary_range hb
  · rintro ⟨hf, hr⟩
    obtain ⟨b, hb, _⟩ := roundBinary_correct f hf mode x hr
    simp [hb]
```

**Supporting proofs:** [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61)

**Definitions and types:** [TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.finiteBits](../../Scalar/Rounding.md#decl-1cdd013ea2ce0dce)

</details>

</details>

<a id="decl-765cac64e8b78cf4"></a>

<details>
<summary><code>TensorCore.roundBinary_zero</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundingContract.lean#L48)

```lean
theorem roundBinary_zero (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode) :
    roundBinary f mode 0 = some 0 := by
  have hr : 0 ≤ f.maxFinite := Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
  rw [if_neg (by simpa [absQ] using Rat.not_lt.mpr hr)]
```

**Supporting proofs:** [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-89538250b2c31eac"></a>

<details>
<summary><code>TensorCore.roundBinary_sign</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundingContract.lean#L56)

```lean
/-- The output sign is the input's strict negativity, even when it underflows to zero.
Exact rational zero therefore has a positive sign in every mode. -/
theorem roundBinary_sign (f : Format) (mode : BinaryRoundingMode) (x : ℚ)
    (bits : BitVec f.width) (h : roundBinary f mode x = some bits) :
    binarySign f bits = decide (x < 0) := by
  obtain ⟨hf, hr⟩ := roundBinary_range h
  by_cases hx : x = 0
  · subst x
    rw [roundBinary_zero f hf mode] at h
    cases Option.some.inj h
    simp [binarySign]
  · have hm := absQ_pos_of_ne_zero x hx
    obtain ⟨he1, he2, _, _⟩ := binaryConvExp_bounds f hf (absQ x) hm hr
    obtain ⟨hk0, hk1, hsub, htop⟩ := binaryConvCoeff_bounds f hf mode (decide (x < 0)) (absQ x) hm hr
    have hs := binaryCarry_spec f hf _ _ he1 he2 hk0 hk1 hsub htop
    let e := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
      (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).1
    let k := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
      (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).2
    have hk : 0 ≤ k := hs.2.2.1
    let r : BinaryRep f := ⟨decide (x < 0), e, k.toNat, hs.1, hs.2.1,
      by have := hs.2.2.2.1; change k < _ at this; omega,
      by have := hs.2.2.2.2.1; change _ ≤ k ∨ e = _ at this; omega⟩
    have heq : encodeBinary f (decide (x < 0)) e k = bits := by
      unfold roundBinary at h
      rw [if_neg (fun hn => hn hf), if_neg (Rat.not_lt.mpr hr), if_neg hx] at h
      change (if e > f.emax then none else some (encodeBinary f (decide (x < 0)) e k)) = some bits at h
      rw [if_neg (Int.not_lt.mpr hs.2.1)] at h
      exact Option.some.inj h
    have hsign := (encodeBinary_fields f hf r).1
    simpa only [r, BinaryRep.encode, Int.toNat_of_nonneg hk, heq] using hsign
```

**Supporting proofs:** [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binaryCarry_spec](ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_correct](../../Scalar/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.binary64Fma_correct](../../TC/FusedRounding.md#decl-818649bb83af8ab6)

</details>

</details>
