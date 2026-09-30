# TensorCore.Numerics.Binary.DirectedRounding

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-1b7bde7add41e53a"></a>

<details>
<summary><code>TensorCore.TowardNegative</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L10)

```lean
/-- Greatest finite value at or below the exact input. -/
def TowardNegative (f : Format) (x : ℚ) (bits : BitVec f.width) : Prop :=
  ∃ d : ℚ, binaryValue f bits = some d ∧ d ≤ x ∧
    ∀ y : ℚ, f.FiniteValue y → y ≤ x → y ≤ d
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.Regression.directed_unusual_format](../../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.negative_subnormal_lower_contract](../../Tests/TC/DirectedBinary.md#decl-6ef36ec120fedf99), [TensorCore.binary64Fma_towardNegative](../../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.conversionStage_towardNegative_correct](../../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.evalInvocation_output_towardNegative](../../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f)

</details>

</details>

<a id="decl-1abd95ba8c4ca756"></a>

<details>
<summary><code>TensorCore.TowardPositive</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L15)

```lean
/-- Least finite value at or above the exact input. -/
def TowardPositive (f : Format) (x : ℚ) (bits : BitVec f.width) : Prop :=
  ∃ d : ℚ, binaryValue f bits = some d ∧ x ≤ d ∧
    ∀ y : ℚ, f.FiniteValue y → x ≤ y → d ≤ y
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.Regression.directed_unusual_format](../../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.negative_subnormal_upper_contract](../../Tests/TC/DirectedBinary.md#decl-7cbd49d6e0ce38c4), [TensorCore.binary64Fma_towardPositive](../../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.conversionStage_towardPositive_correct](../../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.evalInvocation_output_towardPositive](../../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e)

</details>

</details>

<a id="decl-d0e5c511048746ec"></a>

<details>
<summary><code>TensorCore.binary_ceil_magnitude_spec</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L21)

```lean
/-- Ceiling on the input's grid is the least finite upper bound. A value on a
strictly lower binade cannot be an upper competitor. -/
theorem binary_ceil_magnitude_spec (f : Format) (hf : f.WellFormed) (m : ℚ)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) :
    m ≤ binaryMagnitudeRounded f .towardPositive false m ∧
    ∀ y : ℚ, f.FiniteValue y → m ≤ y →
      binaryMagnitudeRounded f .towardPositive false m ≤ y := by
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right
      (Rat.le_ceil (x := m / pow2 (binaryConvExp f m - f.fractionBits))) (Rat.le_of_lt hq)
    rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
  · intro y hy hmy
    obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
    by_cases he : binaryConvExp f m ≤ fe
    · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
      rw [hz] at hmy ⊢
      change (((m / pow2 (binaryConvExp f m - f.fractionBits)).ceil : ℤ) : ℚ) *
        pow2 (binaryConvExp f m - f.fractionBits) ≤ _
      apply Rat.mul_le_mul_of_nonneg_right _ (Rat.le_of_lt hq)
      apply Rat.intCast_le_intCast.mpr
      apply Rat.ceil_le_iff.mpr
      apply Rat.le_of_mul_le_mul_right (c := pow2 (binaryConvExp f m - f.fractionBits)) _ hq
      rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)]
    · obtain ⟨_, _, _, hl⟩ := binaryConvExp_bounds f hf m hm hr
      have hl' : pow2 (binaryConvExp f m) ≤ m := by
        rcases hl with h | h
        · exact h
        · exfalso; omega
      have hsmall := f.finite_below_binade j fe (binaryConvExp f m) hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have := pow2_pos (binaryConvExp f m - f.fractionBits - 1)
      grind
```

**Supporting proofs:** [TensorCore.Format.finite_below_binade](CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.absQ_le_iff](../Exact.md#decl-3513a75c8e3035b2), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b)

</details>

</details>

<a id="decl-5da226e78b7a9948"></a>

<details>
<summary><code>TensorCore.binarySignedRounded_towardNegative</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L53)

```lean
theorem binarySignedRounded_towardNegative (f : Format) (hf : f.WellFormed) (x : ℚ)
    (hx : x ≠ 0) (hr : absQ x ≤ f.maxFinite) :
    binarySignedRounded f .towardNegative x ≤ x ∧
    ∀ y : ℚ, f.FiniteValue y → y ≤ x → y ≤ binarySignedRounded f .towardNegative x := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold binarySignedRounded
  by_cases hn : x < 0
  · rw [if_pos hn]
    have hc := binary_ceil_magnitude_spec f hf (absQ x) hm hr
    have ha := absQ_of_neg hn
    have he : binaryMagnitudeRounded f .towardNegative true (absQ x) =
        binaryMagnitudeRounded f .towardPositive false (absQ x) := rfl
    rw [he]
    refine ⟨by grind, ?_⟩
    intro y hy hyx
    have h := hc.2 (-y) (f.finiteValue_neg hy) (by grind)
    grind
  · rw [if_neg hn]
    have hc := binary_rtz_magnitude_spec f hf false (absQ x) hm hr
    have ha := absQ_of_nonneg (show 0 ≤ x by grind)
    change binaryMagnitudeRounded f .towardZero false (absQ x) ≤ x ∧ _
    refine ⟨by grind, ?_⟩
    intro y hy hyx
    exact hc.2.2 y hy (by grind)
```

**Supporting proofs:** [TensorCore.Format.finiteValue_neg](CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.absQ_of_neg](../Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f)

</details>

</details>

<a id="decl-4864dc665967ec3b"></a>

<details>
<summary><code>TensorCore.binarySignedRounded_towardPositive</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L78)

```lean
theorem binarySignedRounded_towardPositive (f : Format) (hf : f.WellFormed) (x : ℚ)
    (hx : x ≠ 0) (hr : absQ x ≤ f.maxFinite) :
    x ≤ binarySignedRounded f .towardPositive x ∧
    ∀ y : ℚ, f.FiniteValue y → x ≤ y → binarySignedRounded f .towardPositive x ≤ y := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold binarySignedRounded
  by_cases hn : x < 0
  · rw [if_pos hn]
    have hc := binary_rtz_magnitude_spec f hf true (absQ x) hm hr
    have ha := absQ_of_neg hn
    change x ≤ -binaryMagnitudeRounded f .towardZero true (absQ x) ∧ _
    refine ⟨by grind, ?_⟩
    intro y hy hxy
    have h := hc.2.2 (-y) (f.finiteValue_neg hy) (by grind)
    change -binaryMagnitudeRounded f .towardZero true (absQ x) ≤ y
    grind
  · rw [if_neg hn]
    have hc := binary_ceil_magnitude_spec f hf (absQ x) hm hr
    have ha := absQ_of_nonneg (show 0 ≤ x by grind)
    refine ⟨by grind, ?_⟩
    intro y hy hxy
    exact hc.2 y hy (by grind)
```

**Supporting proofs:** [TensorCore.Format.finiteValue_neg](CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.absQ_of_neg](../Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e)

</details>

</details>

<a id="decl-3b3e5c3213c35d5f"></a>

<details>
<summary><code>TensorCore.roundBinary_towardNegative_correct</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L101)

```lean
theorem roundBinary_towardNegative_correct (f : Format) (hf : f.WellFormed) (x : ℚ)
    (hr : absQ x ≤ f.maxFinite) :
    ∃ bits, roundBinary f .towardNegative x = some bits ∧ TowardNegative f x bits := by
  by_cases hx : x = 0
  · subst x
    refine ⟨0, ?_, 0, binaryValue_zero f hf, Rat.le_refl, fun _ _ h => h⟩
    simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
    rw [if_neg (by grind)]
  · obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec f hf .towardNegative x hx hr
    exact ⟨bits, hb, _, hv, binarySignedRounded_towardNegative f hf x hx hr⟩
```

**Supporting proofs:** [TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binaryValue_zero](CorrectRounding.md#decl-316323365131d605), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.TowardNegative](DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.directed_unusual_format](../../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.negative_subnormal_lower_contract](../../Tests/TC/DirectedBinary.md#decl-6ef36ec120fedf99), [TensorCore.conversionStage_towardNegative_correct](../../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e)

</details>

</details>

<a id="decl-a0d617c51646227e"></a>

<details>
<summary><code>TensorCore.roundBinary_towardPositive_correct</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/DirectedRounding.lean#L112)

```lean
theorem roundBinary_towardPositive_correct (f : Format) (hf : f.WellFormed) (x : ℚ)
    (hr : absQ x ≤ f.maxFinite) :
    ∃ bits, roundBinary f .towardPositive x = some bits ∧ TowardPositive f x bits := by
  by_cases hx : x = 0
  · subst x
    refine ⟨0, ?_, 0, binaryValue_zero f hf, Rat.le_refl, fun _ _ h => h⟩
    simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
    rw [if_neg (by grind)]
  · obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec f hf .towardPositive x hx hr
    exact ⟨bits, hb, _, hv, binarySignedRounded_towardPositive f hf x hx hr⟩
```

**Supporting proofs:** [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binaryValue_zero](CorrectRounding.md#decl-316323365131d605), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.TowardPositive](DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.directed_unusual_format](../../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.negative_subnormal_upper_contract](../../Tests/TC/DirectedBinary.md#decl-7cbd49d6e0ce38c4), [TensorCore.conversionStage_towardPositive_correct](../../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e)

</details>

</details>
