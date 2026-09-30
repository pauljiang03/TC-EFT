# TensorCore.Numerics.Binary.ConversionBounds

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e0ee28b5db1c0078"></a>

<details>
<summary><code>TensorCore.Format.binade_grid</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L10)

```lean
theorem Format.binade_grid (f : Format) (e : ℤ) :
    pow2 e = ((2 ^ f.fractionBits : ℕ) : ℚ) * pow2 (e - f.fractionBits) := by
  rw [← pow2_natCast, ← pow2_add]
  congr 1
  omega
```

**Supporting proofs:** [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_lower](../../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precision_nearest_all](../../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-fba2cf9fd898146c"></a>

<details>
<summary><code>TensorCore.Format.next_binade_grid</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L16)

```lean
theorem Format.next_binade_grid (f : Format) (e : ℤ) :
    pow2 (e + 1) = ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) * pow2 (e - f.fractionBits) := by
  rw [← pow2_natCast, ← pow2_add]
  congr 1
  omega
```

**Supporting proofs:** [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Format.maxFinite_lt](ConversionBounds.md#decl-27fef2f17e469434), [TensorCore.IEEE.precisionMagnitude_lower](../../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-27fef2f17e469434"></a>

<details>
<summary><code>TensorCore.Format.maxFinite_lt</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L22)

```lean
theorem Format.maxFinite_lt (f : Format) : f.maxFinite < pow2 (f.emax + 1) := by
  unfold Format.maxFinite
  rw [f.next_binade_grid f.emax]
  have hq := pow2_pos (f.emax - f.fractionBits)
  have h : ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) < ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) :=
    Rat.natCast_lt_natCast.mpr (by have := Nat.two_pow_pos (f.fractionBits + 1); omega)
  exact Rat.mul_lt_mul_of_pos_right h hq
```

**Supporting proofs:** [TensorCore.Format.next_binade_grid](ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64)

</details>

</details>

<a id="decl-47b4c2534b697b64"></a>

<details>
<summary><code>TensorCore.binaryConvExp_bounds</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L30)

```lean
theorem binaryConvExp_bounds (f : Format) (hf : f.WellFormed) (m : ℚ) (hm : 0 < m)
    (hr : m ≤ f.maxFinite) :
    f.emin ≤ binaryConvExp f m ∧ binaryConvExp f m ≤ f.emax ∧
    m < pow2 (binaryConvExp f m + 1) ∧
    (pow2 (binaryConvExp f m) ≤ m ∨ binaryConvExp f m = f.emin) := by
  have hs := magnitudeExponent_spec m hm
  have hemin := f.emin_le_emax hf
  have htop : magnitudeExponent m ≤ f.emax := by
    apply Classical.byContradiction
    intro h
    have hg := pow2_le_of_le (e := f.emax + 1) (f := magnitudeExponent m) (by omega)
    have := f.maxFinite_lt
    grind
  have hmax : magnitudeExponent m ≤ binaryConvExp f m := by unfold binaryConvExp; omega
  have he1 : f.emin ≤ binaryConvExp f m := by unfold binaryConvExp; omega
  have he2 : binaryConvExp f m ≤ f.emax := by unfold binaryConvExp; omega
  have hupper := pow2_le_of_le (e := magnitudeExponent m + 1)
    (f := binaryConvExp f m + 1) (by omega)
  refine ⟨he1, he2, by grind, ?_⟩
  by_cases h : f.emin ≤ magnitudeExponent m
  · left
    have : binaryConvExp f m = magnitudeExponent m := by unfold binaryConvExp; omega
    rw [this]
    exact hs.1
  · right
    unfold binaryConvExp
    omega
```

**Supporting proofs:** [TensorCore.Format.emin_le_emax](Encoding.md#decl-f21f4f9c313ac4d5), [TensorCore.Format.maxFinite_lt](ConversionBounds.md#decl-27fef2f17e469434), [TensorCore.magnitudeExponent_spec](../Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_le_of_le](../Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.magnitudeExponent](../RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.precisionMagnitude_le_max](../../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-b47c7fc078e6a58d"></a>

<details>
<summary><code>TensorCore.floor_le_ceil</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L58)

```lean
theorem floor_le_ceil (t : ℚ) : t.floor ≤ t.ceil := by
  have h1 := Rat.floor_le t
  have h2 := Rat.le_ceil (x := t)
  exact Rat.intCast_le_intCast.mp (Rat.le_trans h1 h2)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryCoefficient_bounds](ConversionBounds.md#decl-627eb6051536ce43)

</details>

</details>

<a id="decl-627eb6051536ce43"></a>

<details>
<summary><code>TensorCore.binaryCoefficient_bounds</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L65)

```lean
/-- Every mode selects a coefficient between the floor and the ceiling of the scaled
magnitude, hence within `[0, N]` for a magnitude below `N`. -/
theorem binaryCoefficient_bounds (mode : BinaryRoundingMode) (negative : Bool) (t : ℚ)
    (N : ℕ) (ht : 0 ≤ t) (htop : t < (N : ℚ)) :
    0 ≤ binaryCoefficient mode negative t ∧ binaryCoefficient mode negative t ≤ N ∧
    t.floor ≤ binaryCoefficient mode negative t ∧ binaryCoefficient mode negative t ≤ t.ceil := by
  have hlo := floor_nonneg_of_nonneg t ht
  have hhi : t.floor < N := Rat.floor_lt_iff.mpr (by rw [Rat.intCast_natCast]; exact htop)
  have hceil : t.ceil ≤ N := Rat.ceil_le_iff.mpr (by rw [Rat.intCast_natCast]; exact Rat.le_of_lt htop)
  have hfc := floor_le_ceil t
  have hceil' : t.ceil ≤ t.floor + 1 := by
    have h := Rat.ceil_lt (x := t)
    have h2 := Rat.lt_floor_add_one t
    have h3 : (t.ceil : ℚ) < (t.floor : ℚ) + 2 := by grind
    have h4 : t.ceil < t.floor + 2 := by
      have := Rat.intCast_lt_intCast (a := t.ceil) (b := t.floor + 2)
      simp only [Rat.intCast_add, Rat.intCast_ofNat] at this
      exact this.mp h3
    omega
  cases mode with
  | towardZero => simp only [binaryCoefficient]; omega
  | nearestEven =>
    simp only [binaryCoefficient]
    have hr : rneInt t ≤ t.ceil := by
      rcases rneInt_cases t with ⟨h, hc⟩ | ⟨h, _⟩
      · rw [h]
        by_cases hint : t = t.floor
        · exfalso
          have h0 : t - t.floor = 0 := by rw [← hint]; exact Rat.sub_self
          rw [h0] at hc
          grind
        · have hlt : (t.floor : ℚ) < t := by
            have := Rat.floor_le t
            grind
          have : t.floor + 1 ≤ t.ceil := by
            apply Int.lt_iff_add_one_le.mp
            have := Rat.intCast_lt_intCast (a := t.floor) (b := t.ceil)
            apply this.mp
            have hc' := Rat.le_ceil (x := t)
            grind
          omega
      · omega
    rcases rneInt_cases t with ⟨h, _⟩ | ⟨h, _⟩ <;> omega
  | towardNegative => simp only [binaryCoefficient]; split <;> omega
  | towardPositive => simp only [binaryCoefficient]; split <;> omega
```

**Supporting proofs:** [TensorCore.floor_le_ceil](ConversionBounds.md#decl-b47c7fc078e6a58d), [TensorCore.floor_nonneg_of_nonneg](../Rounding.md#decl-f7facdfc71bea1f2), [TensorCore.rneInt_cases](../Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_lower](../../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296)

</details>

</details>

<a id="decl-e41347a8800b8463"></a>

<details>
<summary><code>TensorCore.binaryCoefficient_le_integer</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L109)

```lean
theorem binaryCoefficient_le_integer (mode : BinaryRoundingMode) (negative : Bool) (t : ℚ)
    (n : ℤ) (h : t ≤ n) : binaryCoefficient mode negative t ≤ n := by
  have hf := Rat.floor_monotone h
  rw [Rat.floor_intCast] at hf
  have hc : t.ceil ≤ n := Rat.ceil_le_iff.mpr h
  cases mode with
  | towardZero => exact hf
  | nearestEven =>
    change rneInt t ≤ n
    rcases rneInt_cases t with ⟨hk, hcond⟩ | ⟨hk, _⟩
    · by_cases he : t.floor = n
      · have : (n : ℚ) ≤ t := by rw [← he]; exact Rat.floor_le t
        have ht : t = n := Rat.le_antisymm h this
        have h0 : t - t.floor = 0 := by rw [he, ht]; exact Rat.sub_self
        rw [h0] at hcond
        grind
      · omega
    · omega
  | towardNegative => simp only [binaryCoefficient]; split <;> omega
  | towardPositive => simp only [binaryCoefficient]; split <;> omega
```

**Supporting proofs:** [TensorCore.rneInt_cases](../Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_le_max](../../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6)

</details>

</details>

<a id="decl-0ab451f72fcbedb6"></a>

<details>
<summary><code>TensorCore.binaryConvCoeff_bounds</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L131)

```lean
/-- The selected coefficient of a positive in-range magnitude. -/
theorem binaryConvCoeff_bounds (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) (hm : 0 < m) (hr : m ≤ f.maxFinite) :
    let e := binaryConvExp f m
    let k := binaryCoefficient mode negative (m / pow2 (e - f.fractionBits))
    0 ≤ k ∧ k ≤ ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ) ∧
    (((2 ^ f.fractionBits : ℕ) : ℤ) ≤ k ∨ e = f.emin) ∧
    (e = f.emax → k ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℤ)) := by
  intro e k
  obtain ⟨he1, he2, hupper, hlower⟩ := binaryConvExp_bounds f hf m hm hr
  have hq := pow2_pos (e - f.fractionBits)
  have ht : 0 < m / pow2 (e - f.fractionBits) := by
    apply (Rat.lt_div_iff hq).mpr
    simpa using hm
  have htop : m / pow2 (e - f.fractionBits) < ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) := by
    apply (Rat.div_lt_iff hq).mpr
    rwa [f.next_binade_grid] at hupper
  have hb := binaryCoefficient_bounds mode negative _ _ (Rat.le_of_lt ht) htop
  refine ⟨hb.1, hb.2.1, ?_, ?_⟩
  · rcases hlower with hl | he
    · left
      have hs : (((2 ^ f.fractionBits : ℕ) : ℤ) : ℚ) ≤ m / pow2 (e - f.fractionBits) := by
        apply Classical.byContradiction
        intro h
        have h' : m / pow2 (e - f.fractionBits) < ((2 ^ f.fractionBits : ℕ) : ℚ) := by
          rw [Rat.intCast_natCast] at h
          grind
        have h'' := (Rat.div_lt_iff hq).mp h'
        rw [f.binade_grid] at hl
        grind
      have hfl : ((2 ^ f.fractionBits : ℕ) : ℤ) ≤ (m / pow2 (e - f.fractionBits)).floor :=
        Rat.le_floor_iff.mpr hs
      have := hb.2.2.1
      omega
    · exact Or.inr he
  · intro he
    apply binaryCoefficient_le_integer
    have hscale : m / pow2 (e - f.fractionBits) ≤ (((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℤ) : ℚ) := by
      rw [he, Rat.intCast_natCast]
      apply Classical.byContradiction
      intro h
      have h' : ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) < m / pow2 (f.emax - f.fractionBits) := by
        grind
      have h'' := (Rat.lt_div_iff (pow2_pos (f.emax - f.fractionBits))).mp h'
      unfold Format.maxFinite at hr
      grind
    exact hscale
```

**Supporting proofs:** [TensorCore.Format.binade_grid](ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.next_binade_grid](ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.binaryCoefficient_bounds](ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.binaryCoefficient_le_integer](ConversionBounds.md#decl-e41347a8800b8463), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-9bdec62f2ae623aa"></a>

<details>
<summary><code>TensorCore.binaryCarry_spec</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ConversionBounds.lean#L179)

```lean
/-- Carry preserves the value and produces a coefficient that fits the encoding. -/
theorem binaryCarry_spec (f : Format) (hf : f.WellFormed) (e k : ℤ) (he1 : f.emin ≤ e)
    (he2 : e ≤ f.emax) (hk0 : 0 ≤ k) (hk1 : k ≤ ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ))
    (hsub : ((2 ^ f.fractionBits : ℕ) : ℤ) ≤ k ∨ e = f.emin)
    (htop : e = f.emax → k ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℤ)) :
    f.emin ≤ (binaryCarry f e k).1 ∧ (binaryCarry f e k).1 ≤ f.emax ∧
    0 ≤ (binaryCarry f e k).2 ∧ (binaryCarry f e k).2 < ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ) ∧
    (((2 ^ f.fractionBits : ℕ) : ℤ) ≤ (binaryCarry f e k).2 ∨ (binaryCarry f e k).1 = f.emin) ∧
    ((binaryCarry f e k).2 : ℚ) * pow2 ((binaryCarry f e k).1 - f.fractionBits) =
      (k : ℚ) * pow2 (e - f.fractionBits) ∧
    e ≤ (binaryCarry f e k).1 ∧ (k % 2 = 0 → (binaryCarry f e k).2 % 2 = 0) := by
  have hpow : 2 ^ (f.fractionBits + 1) = 2 ^ f.fractionBits * 2 := Nat.pow_succ 2 _
  have hP := Nat.two_pow_pos f.fractionBits
  unfold binaryCarry
  split
  · rename_i hk
    have hlt : e < f.emax := by
      apply Classical.byContradiction
      intro h
      have he : e = f.emax := by omega
      have := htop he
      rw [hk] at this
      have h2 := Nat.two_pow_pos (f.fractionBits + 1)
      omega
    have hhalf : k / 2 = ((2 ^ f.fractionBits : ℕ) : ℤ) := by
      rw [hk, hpow]
      omega
    have hval : ((k / 2 : ℤ) : ℚ) * pow2 (e + 1 - f.fractionBits) = (k : ℚ) * pow2 (e - f.fractionBits) := by
      rw [hhalf, hk]
      have : e + 1 - f.fractionBits = (e - f.fractionBits) + 1 := by omega
      rw [this, pow2_succ, hpow]
      simp only [Rat.intCast_natCast, Rat.natCast_mul]
      grind
    refine ⟨by omega, by omega, by omega, by omega, Or.inl (by omega), hval, by omega, ?_⟩
    intro _
    rw [hhalf]
    have : (2 ^ f.fractionBits) % 2 = 0 := by
      obtain ⟨m, hm⟩ : ∃ m, f.fractionBits = m + 1 := ⟨f.fractionBits - 1, by have := hf.1; omega⟩
      rw [hm, Nat.pow_succ]
      simp
    omega
  · exact ⟨he1, he2, hk0, by omega, hsub, rfl, Int.le_refl _, fun h => h⟩
```

**Supporting proofs:** [TensorCore.pow2_succ](../Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>
