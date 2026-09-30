# TensorCore.Numerics.RoundTrip

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b49162d7ac8baacf"></a>

<details>
<summary><code>TensorCore.decode32_fields</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundTrip.lean#L11)

```lean
/-- Field decomposition of a finite FP32 encoding. -/
theorem decode32_fields (b : F32) (d : Decoded) (h : decode32 b = some d) :
    (b.toNat / 8388608 % 256 = 0 ∧ b.toNat % 8388608 = 0 ∧ d = ⟨0, 0, 0⟩) ∨
    (b.toNat / 8388608 % 256 = 0 ∧ b.toNat % 8388608 ≠ 0 ∧
      d = ⟨if (b.toNat / 2147483648 != 0) then -((b.toNat % 8388608 : ℕ) : ℤ)
           else ((b.toNat % 8388608 : ℕ) : ℤ), -126, 23⟩) ∨
    (1 ≤ b.toNat / 8388608 % 256 ∧ b.toNat / 8388608 % 256 ≤ 254 ∧
      d = ⟨if (b.toNat / 2147483648 != 0) then -((8388608 + b.toNat % 8388608 : ℕ) : ℤ)
           else ((8388608 + b.toNat % 8388608 : ℕ) : ℤ),
           ((b.toNat / 8388608 % 256 : ℕ) : ℤ) - 127, 23⟩) := by
  rw [decode32_eq, classifyNat_fp32] at h
  by_cases h1 : b.toNat / 8388608 % 256 = 255
  · by_cases h3 : b.toNat % 8388608 = 0 <;> simp [h1, h3, Classification.finite] at h
  · by_cases h2 : b.toNat / 8388608 % 256 = 0
    · by_cases h3 : b.toNat % 8388608 = 0
      · rw [if_neg h1, if_pos h2, if_pos h3] at h
        simp only [Classification.finite, Option.some.injEq] at h
        subst h
        exact Or.inl ⟨h2, h3, rfl⟩
      · rw [if_neg h1, if_pos h2, if_neg h3] at h
        simp only [Classification.finite, Option.some.injEq] at h
        subst h
        exact Or.inr (Or.inl ⟨h2, h3, rfl⟩)
    · rw [if_neg h1, if_neg h2] at h
      simp only [Classification.finite, Option.some.injEq] at h
      subst h
      exact Or.inr (Or.inr ⟨by omega, by omega, rfl⟩)
```

**Supporting proofs:** [TensorCore.classifyNat_fp32](EncodingProperties.md#decl-e78f14689117d01e), [TensorCore.decode32_eq](Encoding.md#decl-d61e64a2750bda68)

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.zero_value_bits](../TC/Instruction.md#decl-f684c66c118692c8), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-19d63265706221b3"></a>

<details>
<summary><code>TensorCore.roundCoefficient_intCast</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundTrip.lean#L38)

```lean
theorem roundCoefficient_intCast (mode : RoundingMode) (k : ℤ) :
    roundCoefficient mode (k : ℚ) = k := by
  cases mode with
  | towardZero => exact Rat.floor_intCast k
  | nearestEven =>
    show rneInt (k : ℚ) = k
    unfold rneInt
    rw [Rat.floor_intCast]
    have h : (k : ℚ) - (k : ℚ) = 0 := by grind
    rw [h]
    have h' : ¬ ((1 : ℚ) < 2 * 0 ∨ (2 * (0 : ℚ) = 1 ∧ k % 2 = 1)) := by
      intro hc
      rcases hc with hc | ⟨hc, _⟩ <;> exact absurd hc (by decide +kernel)
    rw [if_neg h']
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryCoefficient_intCast](Binary/RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b)

</details>

</details>

<a id="decl-253dec4b19f59f2b"></a>

<details>
<summary><code>TensorCore.round32_canonical</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundTrip.lean#L54)

```lean
/-- The converter returns the canonical encoding of any nonzero representable value. -/
theorem round32_canonical (mode : RoundingMode) (negative : Bool) (e k : ℤ)
    (he1 : -126 ≤ e) (he2 : e ≤ 127) (hk0 : 0 < k) (hk1 : k < 2 ^ 24)
    (hsub : 2 ^ 23 ≤ k ∨ e = -126) :
    round32 mode ((if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - 23)) =
      some (encode32 negative e k) := by
  have hq := pow2_pos (e - 23)
  have hkR : (0 : ℚ) < (k : ℚ) := Rat.intCast_pos.mpr hk0
  have hmag : absQ ((if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - 23)) =
      (k : ℚ) * pow2 (e - 23) := by
    cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte]
    · rw [absQ_of_nonneg (Rat.le_of_lt (Rat.mul_pos hkR hq))]
    · rw [Rat.neg_mul, absQ_neg, absQ_of_nonneg (Rat.le_of_lt (Rat.mul_pos hkR hq))]
  have hfin : FiniteValue32 ((if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - 23)) := by
    refine ⟨if negative then -k else k, e, he1, he2, ?_, ?_⟩
    · cases negative <;> simp <;> omega
    · cases negative <;> simp
  have hrange := finiteValue32_abs_le hfin
  have hpos : 0 < (k : ℚ) * pow2 (e - 23) := Rat.mul_pos hkR hq
  have hne : (if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - 23) ≠ 0 := by
    intro h0
    rw [h0] at hmag
    simp [absQ] at hmag
    grind
  -- Exponent selection.
  have hexp : convExp ((k : ℚ) * pow2 (e - 23)) = e := by
    unfold convExp emin32
    by_cases hk : 2 ^ 23 ≤ k
    · have hlo : pow2 e ≤ (k : ℚ) * pow2 (e - 23) := by
        rw [binade_grid]
        apply Rat.mul_le_mul_of_nonneg_right _ (Rat.le_of_lt hq)
        have := Rat.intCast_le_intCast.mpr hk
        simpa using this
      have hhi : (k : ℚ) * pow2 (e - 23) < pow2 (e + 1) := by
        rw [next_binade_grid]
        apply Rat.mul_lt_mul_of_pos_right _ hq
        have := Rat.intCast_lt_intCast.mpr hk1
        simpa using this
      rw [magnitudeExponent_eq_of_bounds _ e hlo hhi]
      omega
    · have he : e = -126 := by rcases hsub with h | h <;> omega
      subst he
      have hsmall : (k : ℚ) * pow2 (-126 - 23) < pow2 (-126) := by
        rw [binade_grid (-126)]
        apply Rat.mul_lt_mul_of_pos_right _ (pow2_pos _)
        have hk23 : k < 8388608 := by omega
        have := Rat.intCast_lt_intCast.mpr hk23
        simpa using this
      have hme : magnitudeExponent ((k : ℚ) * pow2 (-126 - 23)) < -126 := by
        apply Classical.byContradiction
        intro hn
        have hge : -126 ≤ magnitudeExponent ((k : ℚ) * pow2 (-126 - 23)) := by omega
        have h1 := (magnitudeExponent_spec _ hpos).1
        have h2 := pow2_le_of_le hge
        grind
      omega
  have hcoef : convCoeff mode ((k : ℚ) * pow2 (e - 23)) = k := by
    unfold convCoeff
    rw [hexp, Rat.mul_div_cancel (Rat.ne_of_gt hq)]
    exact roundCoefficient_intCast mode k
  have hcarry : carry e k = (e, k) := by
    unfold carry
    rw [if_neg (by omega)]
  have hsign : decide ((if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - 23) < 0) =
      negative := by
    cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte, decide_eq_true_eq,
      decide_eq_false_iff_not]
    · exact Rat.not_lt.mpr (Rat.le_of_lt hpos)
    · rw [Rat.neg_mul]; grind
  unfold round32 round32Core
  rw [if_neg (by rw [hmag]; rw [hmag] at hrange; exact Rat.not_lt.mpr hrange), if_neg hne,
    hmag, hexp, hcoef, hcarry, hsign]
  try dsimp only
  rw [if_neg (show ¬ (e > 127) by omega)]
```

**Supporting proofs:** [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.roundCoefficient_intCast](RoundTrip.md#decl-19d63265706221b3)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.carry](RoundOp.md#decl-e870a105595fff5f), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec), [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429)

</details>

</details>

<a id="decl-46fb757285084429"></a>

<details>
<summary><code>TensorCore.value32_round32</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundTrip.lean#L129)

```lean
/-- Converting the value of a nonzero finite encoding returns the same bits. -/
theorem value32_round32 (mode : RoundingMode) (b : F32) (v : ℚ)
    (h : value32 b = some v) (hnz : v ≠ 0) : round32 mode v = some b := by
  unfold value32 at h
  cases hd : decode32 b with
  | none => simp [hd] at h
  | some d =>
    simp only [hd, Option.map_some, Option.some.injEq] at h
    subst h
    have hlt := b.isLt
    have hquot : b.toNat / 2147483648 = 0 ∨ b.toNat / 2147483648 = 1 := by omega
    rcases decode32_fields b d hd with ⟨_, _, rfl⟩ | ⟨hE, hm, rfl⟩ | ⟨hE1, hE2, rfl⟩
    · exact absurd (by decide +kernel : (Decoded.mk 0 0 0).value = 0) hnz
    · -- Subnormal.
      have hval : (Decoded.mk (if (b.toNat / 2147483648 != 0) then
            -((b.toNat % 8388608 : ℕ) : ℤ) else ((b.toNat % 8388608 : ℕ) : ℤ)) (-126) 23).value =
          (if (b.toNat / 2147483648 != 0) then -(((b.toNat % 8388608 : ℕ) : ℤ) : ℚ)
            else (((b.toNat % 8388608 : ℕ) : ℤ) : ℚ)) * pow2 (-126 - 23) := by
        unfold Decoded.value
        cases hs : (b.toNat / 2147483648 != 0) <;> simp
      rw [hval]
      rw [round32_canonical mode _ (-126) _ (by omega) (by omega) (by omega) (by omega)
        (Or.inr rfl)]
      refine congrArg some ?_
      apply BitVec.eq_of_toNat_eq
      rw [encode32_toNat _ _ _ (by omega) (by omega) (by omega) (by omega)]
      cases hs : (b.toNat / 2147483648 != 0)
      · have : b.toNat / 2147483648 = 0 := by simpa using hs
        simp only [Bool.false_eq_true, ↓reduceIte, Nat.reducePow, Int.reducePow]
        rw [if_pos (by omega)]
        omega
      · have : b.toNat / 2147483648 ≠ 0 := by simpa using hs
        simp only [↓reduceIte, Nat.reducePow, Int.reducePow]
        rw [if_pos (by omega)]
        omega
    · -- Normal.
      have hval : (Decoded.mk (if (b.toNat / 2147483648 != 0) then
            -((8388608 + b.toNat % 8388608 : ℕ) : ℤ) else ((8388608 + b.toNat % 8388608 : ℕ) : ℤ))
            (((b.toNat / 8388608 % 256 : ℕ) : ℤ) - 127) 23).value =
          (if (b.toNat / 2147483648 != 0) then -(((8388608 + b.toNat % 8388608 : ℕ) : ℤ) : ℚ)
            else (((8388608 + b.toNat % 8388608 : ℕ) : ℤ) : ℚ)) *
            pow2 (((b.toNat / 8388608 % 256 : ℕ) : ℤ) - 127 - 23) := by
        unfold Decoded.value
        cases hs : (b.toNat / 2147483648 != 0) <;> simp
      rw [hval]
      rw [round32_canonical mode _ _ _ (by omega) (by omega) (by omega) (by omega)
        (Or.inl (by omega))]
      refine congrArg some ?_
      apply BitVec.eq_of_toNat_eq
      rw [encode32_toNat _ _ _ (by omega) (by omega) (by omega) (by omega)]
      cases hs : (b.toNat / 2147483648 != 0)
      · have : b.toNat / 2147483648 = 0 := by simpa using hs
        simp only [Bool.false_eq_true, ↓reduceIte, Nat.reducePow, Int.reducePow]
        rw [if_neg (by omega)]
        omega
      · have : b.toNat / 2147483648 ≠ 0 := by simpa using hs
        simp only [↓reduceIte, Nat.reducePow, Int.reducePow]
        rw [if_neg (by omega)]
        omega
```

**Supporting proofs:** [TensorCore.decode32_fields](RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.encode32_toNat](EncodingProperties.md#decl-69d2d972fbf20b0d), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.value32_injective](RoundTrip.md#decl-c92b8ed7f76cc40c), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-c92b8ed7f76cc40c"></a>

<details>
<summary><code>TensorCore.value32_injective</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundTrip.lean#L189)

```lean
/-- Nonzero finite values have unique encodings. -/
theorem value32_injective (b₁ b₂ : F32) (v : ℚ) (h₁ : value32 b₁ = some v)
    (h₂ : value32 b₂ = some v) (hnz : v ≠ 0) : b₁ = b₂ := by
  have r₁ := value32_round32 .towardZero b₁ v h₁ hnz
  have r₂ := value32_round32 .towardZero b₂ v h₂ hnz
  rw [r₁] at r₂
  exact Option.some.inj r₂
```

**Supporting proofs:** [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.rounds_unique](../TC/Specification/Rounding.md#decl-ca5813743de21e20)

</details>

</details>
