# TensorCore.Core.Binary.CorrectRounding

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-bc28d8b9cd0c1242"></a>

<details>
<summary><code>TensorCore.binaryMagnitudeRounded</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L16)

```lean
def binaryMagnitudeRounded (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m : ℚ) : ℚ :=
  (binaryCoefficient mode negative (m / pow2 (binaryConvExp f m - f.fractionBits)) : ℚ) *
    pow2 (binaryConvExp f m - f.fractionBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarGridValue_eq](../../Gemm/Specification/ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binarySignedRounded_nearest](CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.magnitude_error](../../Gemm/ConversionBounds.md#decl-1936078aa7bb5925), [TensorCore.signed_error](../../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.magnitude_error](../../Gemm/RoundingBudget.md#decl-31adebb3a0727f59), [TensorCore.signed_error](../../Gemm/RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-d04cb97895a8bf6c"></a>

<details>
<summary><code>TensorCore.binarySignedRounded</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L21)

```lean
def binarySignedRounded (f : Format) (mode : BinaryRoundingMode) (x : ℚ) : ℚ :=
  if x < 0 then -binaryMagnitudeRounded f mode true (absQ x)
  else binaryMagnitudeRounded f mode false (absQ x)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarGridValue_eq](../../Gemm/Specification/ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.PaperSpec.scalarResult_of_roundBinary](../../Gemm/Specification/ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.binarySignedRounded_nearest](CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.gemmConversion_error](../../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.signed_error](../../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.signed_error](../../Gemm/RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-ca751f6fe596d9e8"></a>

<details>
<summary><code>TensorCore.rne_grid_nearest_q</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L27)

```lean
theorem rne_grid_nearest_q (m q : ℚ) (hq : 0 < q) (j : ℤ) :
    absQ (m - (rneInt (m / q) : ℚ) * q) ≤ absQ (m - (j : ℚ) * q) := by
  rw [dist_scale _ _ hq _, dist_scale _ _ hq _]
  exact Rat.mul_le_mul_of_nonneg_right (rneInt_nearest _ j) (Rat.le_of_lt hq)
```

**Supporting proofs:** [TensorCore.dist_scale](../Rounding.md#decl-b773da87e31ab58f), [TensorCore.rneInt_nearest](../Rounding.md#decl-17ccd373bb12baa1)

**Definitions and types:** [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precision_nearest_all](../../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b)

</details>

</details>

<a id="decl-45e49aee9dd44e9c"></a>

<details>
<summary><code>TensorCore.Format.finite_on_grid</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L32)

```lean
theorem Format.finite_on_grid (f : Format) (k e2 e : ℤ) (h : e ≤ e2) :
    ∃ j : ℤ, (k : ℚ) * pow2 (e2 - f.fractionBits) = j * pow2 (e - f.fractionBits) := by
  refine ⟨k * 2 ^ (e2 - e).toNat, ?_⟩
  have : pow2 (e2 - f.fractionBits) = pow2 (e - f.fractionBits) * pow2 ((e2 - e).toNat : ℤ) := by
    rw [← pow2_add]; congr 1; omega
  rw [this, pow2_natCast, Rat.intCast_mul, Rat.intCast_pow]
  simp only [Rat.intCast_ofNat, Rat.natCast_pow, Rat.natCast_ofNat]
  grind
```

**Supporting proofs:** [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_le_max](../../IEEE/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precision_ceil_all](../../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa)

</details>

</details>

<a id="decl-287dcf11c77d730d"></a>

<details>
<summary><code>TensorCore.Format.finite_below_binade</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L42)

```lean
/-- A finite value with exponent below `e` is at most `2^e − 2^(e−p−1)` in magnitude. -/
theorem Format.finite_below_binade (f : Format) (k e2 e : ℤ)
    (hk : k.natAbs < 2 ^ (f.fractionBits + 1)) (h : e2 < e) :
    absQ ((k : ℚ) * pow2 (e2 - f.fractionBits)) ≤ pow2 e - pow2 (e - f.fractionBits - 1) := by
  have hq := pow2_pos (e2 - f.fractionBits)
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have hk' : ((k.natAbs : ℤ) : ℚ) ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) := by
    have h1 : (k.natAbs : ℤ) ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℤ) := by omega
    have h2 := Rat.intCast_le_intCast.mpr h1
    simpa [Rat.intCast_natCast] using h2
  have hgrid : pow2 (e2 - f.fractionBits) ≤ pow2 (e - f.fractionBits - 1) :=
    pow2_le_of_le (by omega)
  have hnn : (0 : ℚ) ≤ ((k.natAbs : ℤ) : ℚ) := Rat.intCast_nonneg.mpr (by omega)
  have step1 : ((k.natAbs : ℤ) : ℚ) * pow2 (e2 - f.fractionBits) ≤
      ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) * pow2 (e - f.fractionBits - 1) :=
    calc ((k.natAbs : ℤ) : ℚ) * pow2 (e2 - f.fractionBits)
        ≤ ((k.natAbs : ℤ) : ℚ) * pow2 (e - f.fractionBits - 1) :=
          Rat.mul_le_mul_of_nonneg_left hgrid hnn
      _ ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) * pow2 (e - f.fractionBits - 1) :=
          Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _))
  have step2 : ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) * pow2 (e - f.fractionBits - 1) =
      pow2 e - pow2 (e - f.fractionBits - 1) := by
    have hp1 : pow2 e = ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) * pow2 (e - f.fractionBits - 1) := by
      rw [← pow2_natCast, ← pow2_add]; congr 1; omega
    have hsub : ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) + 1 =
        ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) := by
      rw [show (1 : ℚ) = ((1 : ℕ) : ℚ) from rfl, ← Rat.natCast_add,
        Nat.sub_add_cancel (Nat.two_pow_pos _)]
    rw [hp1]
    grind
  rw [← step2]
  exact step1
```

**Supporting proofs:** [TensorCore.absQ_intCast](../Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](../Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_le_of_le](../Exact.md#decl-064be6edf8651285), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precision_ceil_all](../../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa)

</details>

</details>

<a id="decl-72bfac3090586308"></a>

<details>
<summary><code>TensorCore.binaryCoefficient_nearestEven</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L75)

```lean
/-- The nearest-even coefficient ignores the sign flag. -/
theorem binaryCoefficient_nearestEven (negative : Bool) (t : ℚ) :
    binaryCoefficient .nearestEven negative t = rneInt t := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1)

</details>

</details>

<a id="decl-5a9bc5842c8ce296"></a>

<details>
<summary><code>TensorCore.binaryMagnitudeRounded_lower</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L78)

```lean
theorem binaryMagnitudeRounded_lower (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) (hm : 0 < m) (hr : m ≤ f.maxFinite)
    (he : f.emin < binaryConvExp f m) :
    pow2 (binaryConvExp f m) ≤ binaryMagnitudeRounded f mode negative m := by
  obtain ⟨_, _, _, hl⟩ := binaryConvExp_bounds f hf m hm hr
  have hl' : pow2 (binaryConvExp f m) ≤ m := by
    rcases hl with h | h
    · exact h
    · exfalso; omega
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  have hs : (((2 ^ f.fractionBits : ℕ) : ℤ) : ℚ) ≤
      m / pow2 (binaryConvExp f m - f.fractionBits) := by
    apply le_div_of_mul_le _ _ _ hq
    rw [Rat.intCast_natCast, ← f.binade_grid]
    exact hl'
  have hfl : ((2 ^ f.fractionBits : ℕ) : ℤ) ≤
      (m / pow2 (binaryConvExp f m - f.fractionBits)).floor := Rat.le_floor_iff.mpr hs
  have hb := binaryCoefficient_bounds mode negative (m / pow2 (binaryConvExp f m - f.fractionBits))
    (2 ^ (f.fractionBits + 1)) (Rat.le_of_lt ((Rat.lt_div_iff hq).mpr (by simpa using hm)))
    (by
      apply (Rat.div_lt_iff hq).mpr
      obtain ⟨_, _, hupper, _⟩ := binaryConvExp_bounds f hf m hm hr
      rwa [f.next_binade_grid] at hupper)
  have hk : ((2 ^ f.fractionBits : ℕ) : ℤ) ≤
      binaryCoefficient mode negative (m / pow2 (binaryConvExp f m - f.fractionBits)) := by
    have := hb.2.2.1
    omega
  unfold binaryMagnitudeRounded
  rw [f.binade_grid (binaryConvExp f m), ← Rat.intCast_natCast]
  exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hk) (Rat.le_of_lt hq)
```

**Supporting proofs:** [TensorCore.Format.binade_grid](ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.next_binade_grid](ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.binaryCoefficient_bounds](ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.le_div_of_mul_le](../Exact.md#decl-020e94a8d8a6259e), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa)

</details>

</details>

<a id="decl-b59c1df23dc23823"></a>

<details>
<summary><code>TensorCore.binary_rne_lower_binade_strict</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L110)

```lean
/-- A finer grid below the input's binade cannot supply an equally near competitor. -/
theorem binary_rne_lower_binade_strict (f : Format) (hf : f.WellFormed) (negative : Bool) (m : ℚ)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) (j fe : ℤ) (hfe : f.emin ≤ fe)
    (hj : j.natAbs < 2 ^ (f.fractionBits + 1)) (he : fe < binaryConvExp f m) :
    absQ (m - binaryMagnitudeRounded f .nearestEven negative m) <
      absQ (m - (j : ℚ) * pow2 (fe - f.fractionBits)) := by
  obtain ⟨_, _, _, hl⟩ := binaryConvExp_bounds f hf m hm hr
  have hl' : pow2 (binaryConvExp f m) ≤ m := by
    rcases hl with h | h
    · exact h
    · exfalso; omega
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  have hb := rne_grid_nearest_q m _ hq ((2 ^ f.fractionBits : ℕ) : ℤ)
  change absQ (m - binaryMagnitudeRounded f .nearestEven negative m) ≤
    absQ (m - (((2 ^ f.fractionBits : ℕ) : ℤ) : ℚ) * pow2 (binaryConvExp f m - f.fractionBits)) at hb
  rw [Rat.intCast_natCast, ← f.binade_grid] at hb
  have hsmall := f.finite_below_binade j fe (binaryConvExp f m) hj he
  have hsmall' := (absQ_le_iff _ _).mp hsmall
  have hq' := pow2_pos (binaryConvExp f m - f.fractionBits - 1)
  have h1 : 0 ≤ m - pow2 (binaryConvExp f m) := by grind
  have h2 : 0 ≤ m - (j : ℚ) * pow2 (fe - f.fractionBits) := by grind
  rw [absQ_of_nonneg h1] at hb
  rw [absQ_of_nonneg h2]
  grind
```

**Supporting proofs:** [TensorCore.Format.binade_grid](ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finite_below_binade](CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.absQ_le_iff](../Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120), [TensorCore.rne_grid_nearest_q](CorrectRounding.md#decl-ca751f6fe596d9e8)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1)

</details>

</details>

<a id="decl-c16cdcb9f5fea95b"></a>

<details>
<summary><code>TensorCore.binary_rne_magnitude_nearest</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L134)

```lean
theorem binary_rne_magnitude_nearest (f : Format) (hf : f.WellFormed) (negative : Bool) (m y : ℚ)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) (hy : f.FiniteValue y) :
    absQ (m - binaryMagnitudeRounded f .nearestEven negative m) ≤ absQ (m - y) := by
  obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
  by_cases he : binaryConvExp f m ≤ fe
  · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
    rw [hz]
    exact rne_grid_nearest_q m _ (pow2_pos _) z
  · exact Rat.le_of_lt (binary_rne_lower_binade_strict f hf negative m hm hr j fe hfe hj (by omega))
```

**Supporting proofs:** [TensorCore.Format.finite_on_grid](CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120), [TensorCore.rne_grid_nearest_q](CorrectRounding.md#decl-ca751f6fe596d9e8)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_nearest](CorrectRounding.md#decl-8b4b18fd2c76f51e)

</details>

</details>

<a id="decl-2c3656de977c4db1"></a>

<details>
<summary><code>TensorCore.binary_rne_magnitude_tie_even</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L144)

```lean
theorem binary_rne_magnitude_tie_even (f : Format) (hf : f.WellFormed) (negative : Bool) (m y : ℚ)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) (hy : f.FiniteValue y)
    (hne : y ≠ binaryMagnitudeRounded f .nearestEven negative m)
    (ht : absQ (m - y) = absQ (m - binaryMagnitudeRounded f .nearestEven negative m)) :
    binaryCoefficient .nearestEven negative (m / pow2 (binaryConvExp f m - f.fractionBits)) % 2 = 0 := by
  obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
  by_cases he : binaryConvExp f m ≤ fe
  · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
    rw [hz] at hne ht
    have hz' : z ≠ rneInt (m / pow2 (binaryConvExp f m - f.fractionBits)) := by
      intro h
      apply hne
      rw [h]; rfl
    unfold binaryMagnitudeRounded at ht
    rw [binaryCoefficient_nearestEven] at ht ⊢
    rw [dist_scale _ _ (pow2_pos _) _, dist_scale _ _ (pow2_pos _) _] at ht
    have hcancel := congrArg (fun a : ℚ => a / pow2 (binaryConvExp f m - f.fractionBits)) ht
    simp only [Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos _))] at hcancel
    exact rneInt_tie_even _ z hcancel hz'
  · have h := binary_rne_lower_binade_strict f hf negative m hm hr j fe hfe hj (by omega)
    rw [ht] at h
    exact False.elim (Rat.lt_irrefl h)
```

**Supporting proofs:** [TensorCore.Format.finite_on_grid](CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.binaryCoefficient_nearestEven](CorrectRounding.md#decl-72bfac3090586308), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.dist_scale](../Rounding.md#decl-b773da87e31ab58f), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120), [TensorCore.rneInt_tie_even](../Rounding.md#decl-b3bf5bfe6d222ec7)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0)

</details>

</details>

<a id="decl-31d0c738bfc17cd1"></a>

<details>
<summary><code>TensorCore.Format.finiteValue_neg</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L167)

```lean
theorem Format.finiteValue_neg (f : Format) {y : ℚ} (h : f.FiniteValue y) :
    f.FiniteValue (-y) := by
  obtain ⟨k, e, he1, he2, hk, rfl⟩ := h
  refine ⟨-k, e, he1, he2, ?_, ?_⟩
  · simpa using hk
  · simp [Rat.intCast_neg, Rat.neg_mul]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_nearest](CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.checkFiniteMultiply_sound](../../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-8b4b18fd2c76f51e"></a>

<details>
<summary><code>TensorCore.binarySignedRounded_nearest</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L174)

```lean
theorem binarySignedRounded_nearest (f : Format) (hf : f.WellFormed) (x y : ℚ) (hx : x ≠ 0)
    (hr : absQ x ≤ f.maxFinite) (hy : f.FiniteValue y) :
    absQ (x - binarySignedRounded f .nearestEven x) ≤ absQ (x - y) := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold binarySignedRounded
  split
  · rename_i hn
    have h := binary_rne_magnitude_nearest f hf true (absQ x) (-y) hm hr (f.finiteValue_neg hy)
    rw [absQ_of_neg hn] at h
    have h1 : -x - binaryMagnitudeRounded f .nearestEven true (-x) =
      -(x - -binaryMagnitudeRounded f .nearestEven true (-x)) := by grind
    have h2 : -x - -y = -(x - y) := by grind
    rw [h1, h2, absQ_neg, absQ_neg] at h
    simpa [absQ_of_neg hn] using h
  · have h := binary_rne_magnitude_nearest f hf false (absQ x) y hm hr hy
    have hn : 0 ≤ x := by grind
    simpa [absQ_of_nonneg hn] using h
```

**Supporting proofs:** [TensorCore.Format.finiteValue_neg](CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.absQ_neg](../Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](../Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893)

</details>

</details>

<a id="decl-18fdd18d08f1b0b0"></a>

<details>
<summary><code>TensorCore.binarySignedRounded_tie_even</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L192)

```lean
theorem binarySignedRounded_tie_even (f : Format) (hf : f.WellFormed) (x y : ℚ) (hx : x ≠ 0)
    (hr : absQ x ≤ f.maxFinite) (hy : f.FiniteValue y)
    (hne : y ≠ binarySignedRounded f .nearestEven x)
    (ht : absQ (x - y) = absQ (x - binarySignedRounded f .nearestEven x)) :
    binaryCoefficient .nearestEven (decide (x < 0))
      (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)) % 2 = 0 := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold binarySignedRounded at hne ht
  split at hne
  · rename_i hn
    simp only [hn, ↓reduceIte, absQ_of_neg hn, decide_true] at ht hne ⊢
    have h1 : -x - -y = -(x - y) := by grind
    have h2 : -x - binaryMagnitudeRounded f .nearestEven true (-x) =
      -(x - -binaryMagnitudeRounded f .nearestEven true (-x)) := by grind
    apply binary_rne_magnitude_tie_even f hf true (-x) (-y)
      (by simpa [absQ_of_neg hn] using hm) (by simpa [absQ_of_neg hn] using hr)
      (f.finiteValue_neg hy)
    · intro h; apply hne; grind
    · rw [h1, h2, absQ_neg, absQ_neg]; exact ht
  · have hn : 0 ≤ x := by grind
    simp only [show ¬x < 0 by grind, ↓reduceIte, absQ_of_nonneg hn, decide_false] at ht hne ⊢
    apply binary_rne_magnitude_tie_even f hf false x y (by simpa [absQ_of_nonneg hn] using hm)
      (by simpa [absQ_of_nonneg hn] using hr) hy hne ht
```

**Supporting proofs:** [TensorCore.Format.finiteValue_neg](CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.absQ_neg](../Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](../Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893)

</details>

</details>

<a id="decl-8fec043a874087be"></a>

<details>
<summary><code>TensorCore.roundBinary_nonzero_spec</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L218)

```lean
/-- The converter returns the signed selected grid value, with the coefficient's parity in
the low bit. -/
theorem roundBinary_nonzero_spec (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (x : ℚ) (hx : x ≠ 0) (hr : absQ x ≤ f.maxFinite) :
    ∃ bits : BitVec f.width, roundBinary f mode x = some bits ∧
      binaryValue f bits = some (binarySignedRounded f mode x) ∧
      (binaryCoefficient mode (decide (x < 0))
        (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)) % 2 = 0 →
        bits.toNat % 2 = 0) := by
  have hm := absQ_pos_of_ne_zero x hx
  obtain ⟨he1, he2, _, _⟩ := binaryConvExp_bounds f hf (absQ x) hm hr
  obtain ⟨hk0, hk1, hsub, htop⟩ := binaryConvCoeff_bounds f hf mode (decide (x < 0)) (absQ x) hm hr
  have hs := binaryCarry_spec f hf _ _ he1 he2 hk0 hk1 hsub htop
  let e := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
    (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).1
  let k := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
    (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).2
  let bits := encodeBinary f (decide (x < 0)) e k
  refine ⟨bits, ?_, ?_, ?_⟩
  · unfold roundBinary
    have hn : ¬absQ x > f.maxFinite := by grind
    rw [if_neg (by intro h; exact h hf), if_neg hn, if_neg hx]
    have hh : ¬e > f.emax := Int.not_lt.mpr hs.2.1
    change (if e > f.emax then none else some bits) = some bits
    rw [if_neg hh]
  · have he := encodeBinary_value f hf (decide (x < 0)) e k hs.1 hs.2.1 hs.2.2.1
      hs.2.2.2.1 hs.2.2.2.2.1
    change binaryValue f bits = _ at he
    rw [he]
    unfold binarySignedRounded binaryMagnitudeRounded
    have hv := hs.2.2.2.2.2.1
    change (k : ℚ) * pow2 (e - f.fractionBits) = _ at hv
    by_cases hn : x < 0 <;> simp [hn] <;> grind
  · intro h
    have he := encodeBinary_parity f hf (decide (x < 0)) e k hs.2.2.1 hs.2.2.2.1 hs.1 hs.2.1
    change bits.toNat % 2 = k.toNat % 2 at he
    have hk : k % 2 = 0 := hs.2.2.2.2.2.2.2 h
    have hk0 : 0 ≤ k := hs.2.2.1
    omega
```

**Supporting proofs:** [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binaryCarry_spec](ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.encodeBinary_parity](Encoding.md#decl-9ed3eec562cea40c), [TensorCore.encodeBinary_value](Encoding.md#decl-4c3ec26630f2de66)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_of_roundBinary](../../Gemm/Specification/ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.gemmConversion_error](../../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-316323365131d605"></a>

<details>
<summary><code>TensorCore.binaryValue_zero</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L256)

```lean
theorem binaryValue_zero (f : Format) (hf : f.WellFormed) : binaryValue f 0 = some 0 := by
  obtain ⟨_, hE⟩ := hf
  have hW : 4 ≤ 2 ^ f.exponentBits := by
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) hE
    simpa using this
  have h0 : (0 : BitVec f.width).toNat = 0 := by simp
  unfold binaryValue classify classifyNat
  dsimp only
  rw [h0, Nat.zero_mod, Nat.zero_div, Nat.zero_mod, Nat.zero_div]
  rw [if_neg (by omega), if_pos rfl, if_pos rfl]
  simp [Classification.finite, Decoded.value]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.classifyNat](../Encoding.md#decl-52d401d7433cac5a), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_of_roundBinary](../../Gemm/Specification/ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.checkScalar_sound](../../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.gemmConversion_error](../../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-8a557a5be79cc256"></a>

<details>
<summary><code>TensorCore.NearestEven</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L269)

```lean
/-- Nearest finite value of the format, ties to an even low bit. -/
def NearestEven (f : Format) (x : ℚ) (bits : BitVec f.width) : Prop :=
  ∃ d : ℚ, binaryValue f bits = some d ∧
    (∀ y : ℚ, f.FiniteValue y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : ℚ, f.FiniteValue y → y ≠ d → absQ (x - y) = absQ (x - d) → bits.toNat % 2 = 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.GemmRounded](../../Gemm/ScaledGemm.md#decl-601fdad850a94274), [TensorCore.Regression.bf16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.fp16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp32_generic_agrees](../../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.fp64_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.tf19_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.binary64Fma_nearestEven](../../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.conversionStage_nearestEven_correct](../../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversion_exact_value](../../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.evalInvocation_output_nearestEven](../../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.fp32_nearestEven](CorrectRounding.md#decl-b9ecfe2e37db1cfd), [TensorCore.gemmConversion_correct](../../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.halfDirect_output_nearestEven](../../TC/Conversion.md#decl-6700d9bdc64b16bf), [TensorCore.halfStaged_output_nearestEven](../../TC/Conversion.md#decl-9493c87a2b6026cd), [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893)

</details>

</details>

<a id="decl-b9ecfe2e37db1cfd"></a>

<details>
<summary><code>TensorCore.fp32_nearestEven</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L274)

```lean
theorem fp32_nearestEven (x : ℚ) (bits : F32) : NearestEven fp32 x bits ↔ NearestEven32 x bits :=
  Iff.rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven](CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.NearestEven32](../RoundOp.md#decl-e8aa71a6813779de), [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-56aa49cf9819c893"></a>

<details>
<summary><code>TensorCore.roundBinary_nearestEven_correct</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L278)

```lean
/-- Total correctness of nearest-even conversion on the finite range of any format. -/
theorem roundBinary_nearestEven_correct (f : Format) (hf : f.WellFormed) (x : ℚ)
    (hr : absQ x ≤ f.maxFinite) :
    ∃ bits : BitVec f.width, roundBinary f .nearestEven x = some bits ∧ NearestEven f x bits := by
  by_cases hx : x = 0
  · subst x
    have hz : roundBinary f .nearestEven 0 = some 0 := by
      unfold roundBinary
      rw [if_neg (by intro h; exact h hf), if_neg (by have := absQ_nonneg (0 : ℚ); grind),
        if_pos rfl]
    refine ⟨0, hz, 0, binaryValue_zero f hf, ?_, ?_⟩
    · intro y _
      have h := absQ_nonneg (0 - y)
      have hz0 : absQ (0 - 0) = 0 := by decide +kernel
      rw [hz0]; exact h
    · intros; simp
  · obtain ⟨bits, hb, hv, hp⟩ := roundBinary_nonzero_spec f hf .nearestEven x hx hr
    refine ⟨bits, hb, binarySignedRounded f .nearestEven x, hv, ?_, ?_⟩
    · intro y hy; exact binarySignedRounded_nearest f hf x y hx hr hy
    · intro y hy hne ht
      exact hp (binarySignedRounded_tie_even f hf x y hx hr hy hne ht)
```

**Supporting proofs:** [TensorCore.absQ_nonneg](../Exact.md#decl-137ea017d6c4d0cd), [TensorCore.binarySignedRounded_nearest](CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binaryValue_zero](CorrectRounding.md#decl-316323365131d605), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.bf16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.fp16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp32_generic_agrees](../../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.fp64_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.tf19_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.conversionStage_nearestEven_correct](../../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10)

</details>

</details>

<a id="decl-e53091bc8dd24dfe"></a>

<details>
<summary><code>TensorCore.Between0</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L302)

```lean
/-- `y` lies between zero and `x`, inclusive. -/
def Between0 (x y : ℚ) : Prop := (0 ≤ x ∧ 0 ≤ y ∧ y ≤ x) ∨ (x ≤ 0 ∧ x ≤ y ∧ y ≤ 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec.finite](RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.PaperSpec.between_eq](../../TC/Specification/Rounding.md#decl-f713036600fa453d), [TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.TowardZero](CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.conversion_exact_value](../../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-9bf23e7c9d56beaa"></a>

<details>
<summary><code>TensorCore.binary_rtz_magnitude_spec</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L304)

```lean
theorem binary_rtz_magnitude_spec (f : Format) (hf : f.WellFormed) (negative : Bool) (m : ℚ)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) :
    0 ≤ binaryMagnitudeRounded f .towardZero negative m ∧
    binaryMagnitudeRounded f .towardZero negative m ≤ m ∧
    (∀ y : ℚ, f.FiniteValue y → y ≤ m → y ≤ binaryMagnitudeRounded f .towardZero negative m) := by
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  have hfl : (0 : ℤ) ≤ (m / pow2 (binaryConvExp f m - f.fractionBits)).floor := by
    apply Rat.le_floor_iff.mpr
    have := div_nonneg_of_pos _ _ (Rat.le_of_lt hm) hq
    simpa using this
  refine ⟨?_, ?_, ?_⟩
  · unfold binaryMagnitudeRounded
    have : (0 : ℚ) ≤ (((m / pow2 (binaryConvExp f m - f.fractionBits)).floor : ℤ) : ℚ) := by
      have := Rat.intCast_le_intCast.mpr hfl
      simpa using this
    exact Rat.mul_nonneg this (Rat.le_of_lt hq)
  · unfold binaryMagnitudeRounded
    change (((m / pow2 (binaryConvExp f m - f.fractionBits)).floor : ℤ) : ℚ) *
      pow2 (binaryConvExp f m - f.fractionBits) ≤ m
    have := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (m / pow2 (binaryConvExp f m - f.fractionBits)))
      (Rat.le_of_lt hq)
    rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at this
  · intro y hy hym
    obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
    by_cases he : binaryConvExp f m ≤ fe
    · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
      rw [hz] at hym ⊢
      unfold binaryMagnitudeRounded
      change (z : ℚ) * pow2 (binaryConvExp f m - f.fractionBits) ≤
        (((m / pow2 (binaryConvExp f m - f.fractionBits)).floor : ℤ) : ℚ) *
          pow2 (binaryConvExp f m - f.fractionBits)
      apply Rat.mul_le_mul_of_nonneg_right _ (Rat.le_of_lt hq)
      apply Rat.intCast_le_intCast.mpr
      apply Rat.le_floor_iff.mpr
      exact le_div_of_mul_le _ _ _ hq hym
    · have hlow := binaryMagnitudeRounded_lower f hf .towardZero negative m hm hr (by omega)
      have hsmall := f.finite_below_binade j fe (binaryConvExp f m) hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have := pow2_pos (binaryConvExp f m - f.fractionBits - 1)
      grind
```

**Supporting proofs:** [TensorCore.Format.finite_below_binade](CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.absQ_le_iff](../Exact.md#decl-3513a75c8e3035b2), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.div_nonneg_of_pos](../Exact.md#decl-67bd25479bf5fb7a), [TensorCore.le_div_of_mul_le](../Exact.md#decl-020e94a8d8a6259e), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-ea87f85641f1fbf8"></a>

<details>
<summary><code>TensorCore.TowardZero</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L347)

```lean
/-- Toward-zero result: between zero and the input, of largest magnitude among the format's
finite values there. -/
def TowardZero (f : Format) (x : ℚ) (bits : BitVec f.width) : Prop :=
  ∃ d : ℚ, binaryValue f bits = some d ∧ Between0 x d ∧
    ∀ y : ℚ, f.FiniteValue y → Between0 x y → absQ y ≤ absQ d
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Between0](CorrectRounding.md#decl-e53091bc8dd24dfe), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.GemmRounded](../../Gemm/ScaledGemm.md#decl-601fdad850a94274), [TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.Regression.bf16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.fp16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp64_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.tf19_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.binary64Fma_towardZero](../../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.conversionStage_towardZero_correct](../../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.conversion_exact_value](../../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.evalInvocation_output_towardZero](../../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.gemmConversion_correct](../../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.l40sFP8_output_towardZero](../../TC/FP8.md#decl-0c85684a50a21181), [TensorCore.l40sFP8_paper_towardZero_accumulation](../../TC/FP8.md#decl-b1b414c8fa00ce08), [TensorCore.l40sFP8_source13_boundary](../../TC/FP8.md#decl-7b2640435fca348a), [TensorCore.l40sFP8_source13_towardZero](../../TC/FP8.md#decl-289dcc55b6b1f28b), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-7cd93a19048f4025"></a>

<details>
<summary><code>TensorCore.roundBinary_towardZero_correct</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/CorrectRounding.lean#L351)

```lean
theorem roundBinary_towardZero_correct (f : Format) (hf : f.WellFormed) (x : ℚ)
    (hr : absQ x ≤ f.maxFinite) :
    ∃ bits : BitVec f.width, roundBinary f .towardZero x = some bits ∧ TowardZero f x bits := by
  by_cases hx : x = 0
  · subst x
    have hz : roundBinary f .towardZero 0 = some 0 := by
      unfold roundBinary
      rw [if_neg (by intro h; exact h hf), if_neg (by have := absQ_nonneg (0 : ℚ); grind),
        if_pos rfl]
    refine ⟨0, hz, 0, binaryValue_zero f hf, Or.inl ⟨Rat.le_refl, Rat.le_refl, Rat.le_refl⟩, ?_⟩
    intro y _ hy
    have : y = 0 := by unfold Between0 at hy; grind
    rw [this]
    exact Rat.le_refl
  · obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec f hf .towardZero x hx hr
    refine ⟨bits, hb, binarySignedRounded f .towardZero x, hv, ?_, ?_⟩
    · unfold binarySignedRounded
      split
      · rename_i hn
        have hm := absQ_pos_of_ne_zero x hx
        obtain ⟨h0, hle, _⟩ := binary_rtz_magnitude_spec f hf true (absQ x) hm hr
        have hax := absQ_of_neg hn
        right
        exact ⟨Rat.le_of_lt hn, by grind, by grind⟩
      · rename_i hn
        have hm := absQ_pos_of_ne_zero x hx
        obtain ⟨h0, hle, _⟩ := binary_rtz_magnitude_spec f hf false (absQ x) hm hr
        have hn' : 0 ≤ x := by grind
        have hax := absQ_of_nonneg hn'
        left
        exact ⟨hn', h0, by grind⟩
    · intro y hy hb0
      have hm := absQ_pos_of_ne_zero x hx
      unfold binarySignedRounded
      split
      · rename_i hn
        obtain ⟨h0, _, hmax⟩ := binary_rtz_magnitude_spec f hf true (absQ x) hm hr
        have hyx : -y ≤ absQ x := by
          rw [absQ_of_neg hn]
          unfold Between0 at hb0
          grind
        have hle := hmax (-y) (f.finiteValue_neg hy) hyx
        have hy0 : y ≤ 0 := by unfold Between0 at hb0; grind
        rw [absQ_neg, absQ_of_nonneg h0]
        apply (absQ_le_iff _ _).mpr
        constructor <;> grind
      · rename_i hn
        obtain ⟨h0, _, hmax⟩ := binary_rtz_magnitude_spec f hf false (absQ x) hm hr
        have hn' : 0 ≤ x := by grind
        have hyx : y ≤ absQ x := by
          rw [absQ_of_nonneg hn']
          unfold Between0 at hb0
          grind
        have hle := hmax y hy hyx
        have hy0 : 0 ≤ y := by unfold Between0 at hb0; grind
        rw [absQ_of_nonneg h0]
        apply (absQ_le_iff _ _).mpr
        constructor <;> grind
```

**Supporting proofs:** [TensorCore.Format.finiteValue_neg](CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.absQ_le_iff](../Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_neg](../Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_nonneg](../Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_of_neg](../Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](../CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binaryValue_zero](CorrectRounding.md#decl-316323365131d605), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be)

**Definitions and types:** [TensorCore.Between0](CorrectRounding.md#decl-e53091bc8dd24dfe), [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.TowardZero](CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.Regression.bf16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.fp16_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp64_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.tf19_rounding_correct](../../TC/Regression/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.conversionStage_towardZero_correct](../../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e)

</details>

</details>
