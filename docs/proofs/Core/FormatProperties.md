# TensorCore.Core.FormatProperties

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4fcf0bbda143bae8"></a>

<details>
<summary><code>TensorCore.decoded_signed_bounded</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L7)

```lean
theorem decoded_signed_bounded (negative : Bool) (m : ℕ) (e : ℤ) (f : ℕ)
    (hm : m < 2 ^ (f + 1)) :
    (Decoded.mk (if negative then -(m : ℤ) else m) e f).Bounded := by
  have hq := pow2_pos (e - f)
  have hm' := Rat.natCast_lt_natCast.mpr hm
  have hs : ((2 ^ (f + 1) : ℕ) : ℚ) * pow2 (e - f) = 2 * pow2 e := by
    rw [← pow2_natCast, ← pow2_add]
    have he : ((f + 1 : ℕ) : ℤ) + (e - f) = e + 1 := by omega
    rw [he, pow2_succ, Rat.mul_comm]
  have hb := Rat.mul_lt_mul_of_pos_right hm' hq
  rw [hs] at hb
  unfold Decoded.Bounded Decoded.value
  cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte, Rat.intCast_neg,
    Rat.intCast_natCast, Rat.neg_mul]
  · rw [absQ_mul_pos _ _ hq, absQ_of_nonneg Rat.natCast_nonneg]
    exact hb
  · rw [absQ_neg, absQ_mul_pos _ _ hq, absQ_of_nonneg Rat.natCast_nonneg]
    exact hb
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.classifyNat_bounded](FormatProperties.md#decl-210634dc2026dbec), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

</details>

</details>

<a id="decl-552117025e86e0df"></a>

<details>
<summary><code>TensorCore.decoded_zero_bounded</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L26)

```lean
theorem decoded_zero_bounded : (Decoded.mk 0 0 0).Bounded := by
  simp [Decoded.Bounded, Decoded.value, absQ, pow2]
  decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.classifyNat_bounded](FormatProperties.md#decl-210634dc2026dbec)

</details>

</details>

<a id="decl-210634dc2026dbec"></a>

<details>
<summary><code>TensorCore.classifyNat_bounded</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L30)

```lean
theorem classifyNat_bounded (f : Format) (n : ℕ) (d : Decoded)
    (h : (classifyNat f n).finite = some d) : d.Bounded := by
  have hfrac := Nat.mod_lt n (Nat.two_pow_pos f.fractionBits)
  have hpow : 2 ^ (f.fractionBits + 1) = 2 ^ f.fractionBits * 2 := by rw [Nat.pow_succ]
  unfold classifyNat at h
  dsimp only at h
  split at h
  · split at h <;> simp [Classification.finite] at h
  · split at h
    · split at h
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d; exact decoded_zero_bounded
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d; apply decoded_signed_bounded; omega
    · simp only [Classification.finite, Option.some.injEq] at h
      subst d; apply decoded_signed_bounded; omega
```

**Supporting proofs:** [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.decoded_zero_bounded](FormatProperties.md#decl-552117025e86e0df)

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepareProducts_bounds](../TC/AlignmentScale.md#decl-24fca5acfef90681), [TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.small16_value](../TC/Examples/BoundedDot.md#decl-a57578c06982c772), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

</details>

</details>

<a id="decl-e40ee371a7256cc2"></a>

<details>
<summary><code>TensorCore.valueFormat_decode_bounded</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L47)

```lean
theorem valueFormat_decode_bounded (f : ValueFormat) (n : ℕ) (d : Decoded)
    (h : (f.classifyNat n).finite = some d) : d.Bounded := by
  cases hs : f.special with
  | ieee => exact classifyNat_bounded f.layout n d (by simpa [ValueFormat.classifyNat, hs] using h)
  | finiteTopNaN =>
    simp only [ValueFormat.classifyNat, hs] at h
    split at h
    · split at h
      · simp [Classification.finite] at h
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        apply decoded_signed_bounded
        have := Nat.mod_lt n (Nat.two_pow_pos f.layout.fractionBits)
        rw [Nat.pow_succ]
        omega
    · exact classifyNat_bounded f.layout n d h
```

**Supporting proofs:** [TensorCore.classifyNat_bounded](FormatProperties.md#decl-210634dc2026dbec), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8)

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.SpecialEncoding](Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.operand_decode_bounded](FormatProperties.md#decl-af739da0b7be09a5)

</details>

</details>

<a id="decl-af739da0b7be09a5"></a>

<details>
<summary><code>TensorCore.operand_decode_bounded</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L64)

```lean
theorem operand_decode_bounded {s : OperandEncoding} {bits : s.Word} {d : Decoded}
    (h : s.decode bits = some d) : d.Bounded :=
  valueFormat_decode_bounded _ _ _ (padded_decode_value h)
```

**Supporting proofs:** [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f92353957f44c1cf"></a>

<details>
<summary><code>TensorCore.classifyNat_scale_lower</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L70)

```lean
/-- A nonzero finite IEEE-style encoding uses at least its minimum normal raw scale;
subnormal values retain that scale instead of normalizing their significand. -/
theorem classifyNat_scale_lower (f : Format) (n : ℕ) (d : Decoded)
    (h : (classifyNat f n).finite = some d) (hnz : d.significand ≠ 0) :
    1 - f.bias ≤ d.rawScale := by
  unfold classifyNat at h
  dsimp only at h
  split at h
  · split at h <;> simp [Classification.finite] at h
  · split at h
    · split at h
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        simp at hnz
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        exact Int.le_refl _
    · simp only [Classification.finite, Option.some.injEq] at h
      subst d
      change 1 - f.bias ≤ ((n / 2 ^ f.fractionBits % 2 ^ f.exponentBits : ℕ) : ℤ) - f.bias
      omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.l40sFP8_floor_inactive](../TC/FP8.md#decl-6a5e1a3ab5a4a57a), [TensorCore.prepare_fp16_terms_lower](../TC/CanonicalFloor.md#decl-25e55191ad23626f)

</details>

</details>

<a id="decl-939dd915424f2515"></a>

<details>
<summary><code>TensorCore.classifyNat_metadata</code></summary>

[Lean source](../../../TensorCore/Core/FormatProperties.lean#L92)

```lean
/-- Nonzero finite decoded values retain the format's fraction width and bounded
raw scale. The exponent field has at least two bits. -/
theorem classifyNat_metadata (f : Format) (he : 2 ≤ f.exponentBits) (n : ℕ) (d : Decoded)
    (h : (classifyNat f n).finite = some d) (hnz : d.significand ≠ 0) :
    d.fractionalBits = f.fractionBits ∧ 1 - f.bias ≤ d.rawScale ∧
      d.rawScale ≤ ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) - f.bias := by
  have hp : (2 : ℕ) ^ 2 ≤ 2 ^ f.exponentBits := Nat.pow_le_pow_right (by decide) he
  have hm := Nat.mod_lt (n / 2 ^ f.fractionBits) (Nat.two_pow_pos f.exponentBits)
  unfold classifyNat at h
  dsimp only at h
  split at h
  · split at h <;> simp [Classification.finite] at h
  · split at h
    · split at h
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        simp at hnz
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        refine ⟨rfl, Int.le_refl _, ?_⟩
        change 1 - f.bias ≤ ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) - f.bias
        omega
    · simp only [Classification.finite, Option.some.injEq] at h
      subst d
      refine ⟨rfl, ?_, ?_⟩
      · change 1 - f.bias ≤ ((n / 2 ^ f.fractionBits % 2 ^ f.exponentBits : ℕ) : ℤ) - f.bias
        omega
      · change ((n / 2 ^ f.fractionBits % 2 ^ f.exponentBits : ℕ) : ℤ) - f.bias ≤
          ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) - f.bias
        omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_source_padding_exact](../TC/Padding.md#decl-9c7b63268cdf83a8), [TensorCore.prepare_fp16_products_metadata](../TC/Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](../TC/Padding.md#decl-c6cfd5be70ed4ce2)

</details>

</details>
