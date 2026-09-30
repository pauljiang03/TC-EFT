# TensorCore.Numerics.ConversionBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5b97691144435e79"></a>

<details>
<summary><code>TensorCore.binade_grid</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L7)

```lean
theorem binade_grid (e : ℤ) : pow2 e = 8388608 * pow2 (e - 23) := by
  have h : e = 23 + (e - 23) := by omega
  rw [h, pow2_add]
  have hc : pow2 23 = 8388608 := by decide
  rw [hc]
  congr 2 <;> omega
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b)

</details>

</details>

<a id="decl-6e741e2915b593fa"></a>

<details>
<summary><code>TensorCore.next_binade_grid</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L14)

```lean
theorem next_binade_grid (e : ℤ) : pow2 (e + 1) = 16777216 * pow2 (e - 23) := by
  rw [pow2_succ, binade_grid]
  grind
```

**Supporting proofs:** [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b)

</details>

</details>

<a id="decl-5f5cd77d343a83f6"></a>

<details>
<summary><code>TensorCore.maxFinite32_lt_pow128</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L18)

```lean
theorem maxFinite32_lt_pow128 : maxFinite32 < pow2 128 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102)

</details>

</details>

<a id="decl-a4885e74ce89d102"></a>

<details>
<summary><code>TensorCore.convExp_bounds</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L20)

```lean
theorem convExp_bounds (m : ℚ) (hm : 0 < m) (hr : m ≤ maxFinite32) :
    -126 ≤ convExp m ∧ convExp m ≤ 127 ∧
    m < pow2 (convExp m + 1) ∧ (pow2 (convExp m) ≤ m ∨ convExp m = -126) := by
  have hs := magnitudeExponent_spec m hm
  have htop : magnitudeExponent m ≤ 127 := by
    apply Classical.byContradiction
    intro h
    have hg := pow2_le_of_le (e := 128) (f := magnitudeExponent m) (by omega)
    have := maxFinite32_lt_pow128
    grind
  have hmax : magnitudeExponent m ≤ convExp m := by unfold convExp; omega
  have he1 : -126 ≤ convExp m := by unfold convExp emin32; omega
  have he2 : convExp m ≤ 127 := by unfold convExp emin32; omega
  have hupper := pow2_le_of_le (e := magnitudeExponent m + 1)
    (f := convExp m + 1) (by omega)
  refine ⟨he1, he2, by grind, ?_⟩
  by_cases h : -126 ≤ magnitudeExponent m
  · left
    have : convExp m = magnitudeExponent m := by unfold convExp emin32; omega
    rw [this]; exact hs.1
  · right; unfold convExp emin32; omega
```

**Supporting proofs:** [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.maxFinite32_lt_pow128](ConversionBounds.md#decl-5f5cd77d343a83f6), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../Kernels/EFT/Round.md#decl-9fc51118cee048d6), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64)

</details>

</details>

<a id="decl-73fca2c325f92d4a"></a>

<details>
<summary><code>TensorCore.roundCoefficient_bounds</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L42)

```lean
theorem roundCoefficient_bounds (mode : RoundingMode) (t : ℚ)
    (ht : 0 ≤ t) (htop : t < 16777216) :
    0 ≤ roundCoefficient mode t ∧ roundCoefficient mode t ≤ 16777216 ∧
    t.floor ≤ roundCoefficient mode t := by
  have hlo := floor_nonneg_of_nonneg t ht
  have hhi : t.floor < 16777216 := Rat.floor_lt_iff.mpr htop
  cases mode with
  | towardZero => simp only [roundCoefficient]; omega
  | nearestEven =>
    simp only [roundCoefficient]
    rcases rneInt_cases t with ⟨h, _⟩ | ⟨h, _⟩ <;> omega
```

**Supporting proofs:** [TensorCore.floor_nonneg_of_nonneg](Rounding.md#decl-f7facdfc71bea1f2), [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2)

</details>

</details>

<a id="decl-90034c8b2f8bb971"></a>

<details>
<summary><code>TensorCore.roundCoefficient_le_integer</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L54)

```lean
theorem roundCoefficient_le_integer (mode : RoundingMode) (t : ℚ) (n : ℤ)
    (h : t ≤ n) : roundCoefficient mode t ≤ n := by
  have hf := Rat.floor_monotone h
  rw [Rat.floor_intCast] at hf
  cases mode with
  | towardZero => exact hf
  | nearestEven =>
    change rneInt t ≤ n
    rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩
    · by_cases he : t.floor = n
      · rw [he] at hc
        exfalso; grind
      · omega
    · omega
```

**Supporting proofs:** [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2)

</details>

</details>

<a id="decl-515c53877d1bedf2"></a>

<details>
<summary><code>TensorCore.convCoeff_bounds</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L69)

```lean
theorem convCoeff_bounds (mode : RoundingMode) (m : ℚ)
    (hm : 0 < m) (hr : m ≤ maxFinite32) :
    0 ≤ convCoeff mode m ∧ convCoeff mode m ≤ 16777216 ∧
    (8388608 ≤ convCoeff mode m ∨ convExp m = -126) ∧
    (convExp m = 127 → convCoeff mode m ≤ 16777215) := by
  obtain ⟨he1, he2, hupper, hlower⟩ := convExp_bounds m hm hr
  have hq := pow2_pos (convExp m - 23)
  have ht : 0 < m / pow2 (convExp m - 23) := by
    apply (Rat.lt_div_iff hq).mpr
    simpa using hm
  have htop : m / pow2 (convExp m - 23) < 16777216 := by
    apply (Rat.div_lt_iff hq).mpr
    rwa [next_binade_grid] at hupper
  have hb := roundCoefficient_bounds mode _ (Rat.le_of_lt ht) htop
  change 0 ≤ convCoeff mode m ∧ convCoeff mode m ≤ 16777216 ∧
    (m / pow2 (convExp m - 23)).floor ≤ convCoeff mode m at hb
  refine ⟨hb.1, hb.2.1, ?_, ?_⟩
  · rcases hlower with hl | he
    · left
      have hs : (8388608 : ℚ) ≤ m / pow2 (convExp m - 23) := by
        apply Classical.byContradiction
        intro h
        have h' : m / pow2 (convExp m - 23) < 8388608 := by grind
        have h'' := (Rat.div_lt_iff hq).mp h'
        rw [binade_grid] at hl
        grind
      have hf : 8388608 ≤ (m / pow2 (convExp m - 23)).floor := Rat.le_floor_iff.mpr hs
      omega
    · exact Or.inr he
  · intro he
    unfold convCoeff
    apply roundCoefficient_le_integer
    have hscale : m / pow2 (convExp m - 23) ≤ (16777215 : ℚ) := by
      rw [he]
      apply Classical.byContradiction
      intro h
      have h' : (16777215 : ℚ) < m / pow2 (127 - 23) := by grind
      have h'' := (Rat.lt_div_iff (pow2_pos (127 - 23))).mp h'
      change (16777215 : ℚ) * pow2 104 < m at h''
      change m ≤ (16777215 : ℚ) * pow2 104 at hr
      grind
    exact hscale
```

**Supporting proofs:** [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.roundCoefficient_bounds](ConversionBounds.md#decl-73fca2c325f92d4a), [TensorCore.roundCoefficient_le_integer](ConversionBounds.md#decl-90034c8b2f8bb971)

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../Kernels/EFT/Round.md#decl-9fc51118cee048d6), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64)

</details>

</details>

<a id="decl-d852b3768f22ee03"></a>

<details>
<summary><code>TensorCore.carry_spec</code></summary>

[Lean source](../../../TensorCore/Numerics/ConversionBounds.lean#L113)

```lean
/-- Carry preserves the value and produces a coefficient that fits the encoding. -/
theorem carry_spec (e k : ℤ) (he1 : -126 ≤ e) (he2 : e ≤ 127)
    (hk0 : 0 ≤ k) (hk1 : k ≤ 16777216)
    (hsub : 8388608 ≤ k ∨ e = -126) (htop : e = 127 → k ≤ 16777215) :
    -126 ≤ (carry e k).1 ∧ (carry e k).1 ≤ 127 ∧
    0 ≤ (carry e k).2 ∧ (carry e k).2 < 16777216 ∧
    (8388608 ≤ (carry e k).2 ∨ (carry e k).1 = -126) ∧
    ((carry e k).2 : ℚ) * pow2 ((carry e k).1 - 23) = (k : ℚ) * pow2 (e - 23) ∧
    e ≤ (carry e k).1 ∧ (k % 2 = 0 → (carry e k).2 % 2 = 0) := by
  unfold carry
  split
  · rename_i hk
    have hk' : k = 16777216 := hk
    subst k
    change -126 ≤ e + 1 ∧ e + 1 ≤ 127 ∧
      0 ≤ (8388608 : ℤ) ∧ (8388608 : ℤ) < 16777216 ∧
      ((8388608 : ℤ) ≤ 8388608 ∨ e + 1 = -126) ∧
      (8388608 : ℚ) * pow2 (e + 1 - 23) = 16777216 * pow2 (e - 23) ∧
      e ≤ e + 1 ∧ ((16777216 : ℤ) % 2 = 0 → (8388608 : ℤ) % 2 = 0)
    have hpow : pow2 (e + 1 - 23) = 2 * pow2 (e - 23) := by
      have : e + 1 - 23 = (e - 23) + 1 := by omega
      rw [this, pow2_succ]; grind
    rw [hpow]
    have he : e < 127 := by omega
    constructor
    · omega
    constructor
    · omega
    constructor
    · decide
    constructor
    · decide
    constructor
    · exact Or.inl (by decide)
    constructor
    · grind
    constructor
    · omega
    · simp
  · exact ⟨he1, he2, hk0, by omega, hsub, rfl, by omega, fun h => h⟩
```

**Supporting proofs:** [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.carry](RoundOp.md#decl-e870a105595fff5f), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../Kernels/EFT/Round.md#decl-9fc51118cee048d6), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64)

</details>

</details>
