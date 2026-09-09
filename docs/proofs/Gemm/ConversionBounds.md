# TensorCore.Gemm.ConversionBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f64f69d45bdd3bc3"></a>

<details>
<summary><code>TensorCore.coefficient_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L8)

```lean
private theorem coefficient_error (mode : BinaryRoundingMode) (negative : Bool) (x : ℚ) :
    absQ (x - binaryCoefficient mode negative x) ≤ 1 := by
  have hf := Rat.floor_le x
  have hf' := Rat.lt_floor_add_one x
  have hc := Rat.le_ceil (x := x)
  have hc' := Rat.ceil_lt (x := x)
  cases mode with
  | nearestEven =>
    have h := rneInt_dist_le_half x
    change absQ (x - rneInt x) ≤ 1
    grind
  | towardZero =>
    apply (absQ_le_iff _ _).mpr
    simp only [binaryCoefficient]
    constructor <;> grind
  | towardNegative =>
    simp only [binaryCoefficient]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind
  | towardPositive =>
    simp only [binaryCoefficient]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind
```

**Supporting proofs:** [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.rneInt_dist_le_half](../Core/Rounding.md#decl-926c4e219d946918)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.magnitude_error](ConversionBounds.md#decl-1936078aa7bb5925)

</details>

</details>

<a id="decl-1936078aa7bb5925"></a>

<details>
<summary><code>TensorCore.magnitude_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L30)

```lean
private theorem magnitude_error (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) :
    absQ (m - binaryMagnitudeRounded f mode negative m) ≤
      pow2 (binaryConvExp f m - f.fractionBits) := by
  let q := pow2 (binaryConvExp f m - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  have h := Rat.mul_le_mul_of_nonneg_right (coefficient_error mode negative (m / q))
    (Rat.le_of_lt hq)
  rw [← absQ_mul_pos _ q hq, Rat.one_mul] at h
  have he : (m / q - (binaryCoefficient mode negative (m / q) : ℚ)) * q =
      m - (binaryCoefficient mode negative (m / q) : ℚ) * q := by
    have := Rat.div_mul_cancel (Rat.ne_of_gt hq) (a := m)
    grind
  rw [he] at h
  exact h
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](../Core/Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.coefficient_error](ConversionBounds.md#decl-f64f69d45bdd3bc3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](../Core/Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signed_error](ConversionBounds.md#decl-5a8644e3b68e60af)

</details>

</details>

<a id="decl-5a8644e3b68e60af"></a>

<details>
<summary><code>TensorCore.signed_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L46)

```lean
private theorem signed_error (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    absQ (x - binarySignedRounded f mode x) ≤
      pow2 (binaryConvExp f (absQ x) - f.fractionBits) := by
  by_cases hn : x < 0
  · have h := magnitude_error f mode true (absQ x)
    have he : x - -binaryMagnitudeRounded f mode true (absQ x) =
        -(absQ x - binaryMagnitudeRounded f mode true (absQ x)) := by
      rw [absQ_of_neg hn]
      grind
    simpa only [binarySignedRounded, if_pos hn, he, absQ_neg] using h
  · have h := magnitude_error f mode false (absQ x)
    have hx : absQ x = x := absQ_of_nonneg (by grind)
    simpa only [binarySignedRounded, if_neg hn, hx] using h
```

**Supporting proofs:** [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](../Core/Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.magnitude_error](ConversionBounds.md#decl-1936078aa7bb5925)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](../Core/Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversion_error](ConversionBounds.md#decl-e310928c2b037b3f)

</details>

</details>

<a id="decl-e4112c653555bb26"></a>

<details>
<summary><code>TensorCore.gemmConversion_total</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L61)

```lean
/-- Finite-domain conversion is total for every supported rounding direction. -/
theorem gemmConversion_total (s : ConversionStage) (hf : s.format.WellFormed)
    (x : ℚ) (hr : absQ x ≤ s.format.maxFinite) :
    ∃ d, s.convert x = some d := by
  have hex : ∃ bits y, roundBinary s.format s.mode x = some bits ∧
      binaryValue s.format bits = some y := by
    by_cases hx : x = 0
    · subst x
      refine ⟨0, 0, ?_, binaryValue_zero s.format hf⟩
      simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
      rw [if_neg (by grind)]
    · obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec s.format hf s.mode x hx hr
      exact ⟨bits, _, hb, hv⟩
  obtain ⟨bits, y, hb, hv⟩ := hex
  cases hd : (classify s.format bits).finite with
  | none => simp [binaryValue, hd] at hv
  | some d =>
    refine ⟨⟨bits, d, hd⟩, ?_⟩
    simp [ConversionStage.convert, hb, finiteBinary_some hd]
```

**Supporting proofs:** [TensorCore.binaryValue_zero](../Core/Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.finiteBinary_some](../Core/Conversion.md#decl-66e4132ec74cac83), [TensorCore.roundBinary_nonzero_spec](../Core/Binary/CorrectRounding.md#decl-8fec043a874087be)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Core/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.finiteBinary](../Core/Conversion.md#decl-4947fce7ecea0c20), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.conversion_exact_value](ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.gemmConversion_bounded](ConversionBounds.md#decl-42b2253d93dfc597)

</details>

</details>

<a id="decl-74312d1a61a1a984"></a>

<details>
<summary><code>TensorCore.gemmConversionError</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L80)

```lean
def gemmConversionError (f : Format) (E : ℤ) : ℚ := pow2 (E - f.fractionBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.gemmConversionModeError_le](RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.gemmConversionModeError_pos](RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.gemmConversion_bounded](ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_error](ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmInputDatum_error_le](InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-e310928c2b037b3f"></a>

<details>
<summary><code>TensorCore.gemmConversion_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L83)

```lean
/-- Supplied magnitude scales bound rounding error without inspecting an output. -/
theorem gemmConversion_error (s : ConversionStage) (E : ℤ) (hE : s.format.emin ≤ E)
    (x : ℚ) (hx : absQ x ≤ pow2 E) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : absQ (x - d.value) ≤ gemmConversionError s.format E := by
  have hf := (conversionStage_range h).1
  have hr := (conversionStage_range h).2
  have hb := conversionStage_output h
  have hd : binaryValue s.format d.bits = some d.value := by simp [binaryValue, d.valid, FiniteBinary.value]
  by_cases hz : x = 0
  · subst x
    have hb0 : roundBinary s.format s.mode 0 = some 0 := by
      simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
      rw [if_neg (by grind)]
    rw [hb0] at hb
    rw [← Option.some.inj hb, binaryValue_zero s.format hf] at hd
    have hv : d.value = 0 := (Option.some.inj hd).symm
    simp only [hv, Rat.sub_self]
    exact Rat.le_of_lt (pow2_pos _)
  · obtain ⟨bits, hb', hv, _⟩ := roundBinary_nonzero_spec s.format hf s.mode x hz hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hv
    have hvalue := Option.some.inj hv
    have he := magnitudeExponent_le_of_lt (absQ x) (absQ_pos_of_ne_zero x hz) E
      (by have := pow2_lt_succ E; grind)
    have hconv : binaryConvExp s.format (absQ x) ≤ E := by
      unfold binaryConvExp
      omega
    have hq := pow2_le_of_le (show binaryConvExp s.format (absQ x) - s.format.fractionBits ≤
      E - s.format.fractionBits by omega)
    rw [hvalue]
    exact Rat.le_trans (signed_error s.format s.mode x) hq
```

**Supporting proofs:** [TensorCore.absQ_pos_of_ne_zero](../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binaryValue_zero](../Core/Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.conversionStage_output](../Core/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Core/Conversion.md#decl-9878d77fe9422846), [TensorCore.magnitudeExponent_le_of_lt](../Core/Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_lt_succ](../Core/Exact.md#decl-b1dfe79296f2080d), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.roundBinary_nonzero_spec](../Core/Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.signed_error](ConversionBounds.md#decl-5a8644e3b68e60af)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Core/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversion_bounded](ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmInputDatum_error_le](InputBounds.md#decl-6e5aac7e5b718d88)

</details>

</details>

<a id="decl-42b2253d93dfc597"></a>

<details>
<summary><code>TensorCore.gemmConversion_bounded</code></summary>

[Lean source](../../../TensorCore/Gemm/ConversionBounds.lean#L116)

```lean
/-- Acceptance, rounding error and an output-magnitude bound derived from a cap. -/
theorem gemmConversion_bounded (s : ConversionStage) (E : ℤ)
    (hf : s.format.WellFormed) (hE : s.format.emin ≤ E)
    (hmax : pow2 E ≤ s.format.maxFinite) (x : ℚ) (hx : absQ x ≤ pow2 E) :
    ∃ d, s.convert x = some d ∧
      absQ (x - d.value) ≤ gemmConversionError s.format E ∧
      absQ d.value ≤ pow2 E + gemmConversionError s.format E := by
  obtain ⟨d, hd⟩ := gemmConversion_total s hf x (Rat.le_trans hx hmax)
  have he := gemmConversion_error s E hE x hx d hd
  have ha := absQ_add_le x (d.value - x)
  rw [absQ_sub_comm d.value x] at ha
  refine ⟨d, hd, he, ?_⟩
  have hid : x + (d.value - x) = d.value := by grind
  rw [hid] at ha
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_sub_comm](../Core/Exact.md#decl-a632fad01d9c884a), [TensorCore.gemmConversion_error](ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_total](ConversionBounds.md#decl-e4112c653555bb26)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>
