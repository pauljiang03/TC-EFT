# TensorCore.Gemm.RoundingBudget

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b1b46e87eaa6e07f"></a>

<details>
<summary><code>TensorCore.roundingBudgetFactor</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L9)

```lean
def roundingBudgetFactor : BinaryRoundingMode → ℚ
  | .nearestEven => 1 / 2
  | _ => 1
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a)

<details>
<summary>Used by</summary>

[TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.gemmConversionModeError_le](RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.gemmConversionModeError_pos](RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.roundingBudgetFactor_le_one](RoundingBudget.md#decl-f338b44782680bc2), [TensorCore.roundingBudgetFactor_pos](RoundingBudget.md#decl-fae3c42fcb78ec85), [TensorCore.coefficient_error](RoundingBudget.md#decl-f755f2a49fffbd90), [TensorCore.magnitude_error](RoundingBudget.md#decl-31adebb3a0727f59), [TensorCore.signed_error](RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-fae3c42fcb78ec85"></a>

<details>
<summary><code>TensorCore.roundingBudgetFactor_pos</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L13)

```lean
theorem roundingBudgetFactor_pos (mode : BinaryRoundingMode) : 0 < roundingBudgetFactor mode := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversionModeError_pos](RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-f338b44782680bc2"></a>

<details>
<summary><code>TensorCore.roundingBudgetFactor_le_one</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L16)

```lean
theorem roundingBudgetFactor_le_one (mode : BinaryRoundingMode) : roundingBudgetFactor mode ≤ 1 := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversionModeError_le](RoundingBudget.md#decl-a884460a8acd89fe)

</details>

</details>

<a id="decl-426ed137365dd261"></a>

<details>
<summary><code>TensorCore.gemmConversionModeError</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L19)

```lean
def gemmConversionModeError (s : ConversionStage) (E : ℤ) : ℚ :=
  roundingBudgetFactor s.mode * gemmConversionError s.format E
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.tight_input_edges](../Regression/FoundationCompletion.md#decl-d874c31dcab129cf), [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.gemmConversionModeError_le](RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.gemmConversionModeError_pos](RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.scalarBound](ScalarAnalysis.md#decl-7e61c221e3ed5c6f), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-56f45d66ad10df52"></a>

<details>
<summary><code>TensorCore.gemmConversionModeError_pos</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L22)

```lean
theorem gemmConversionModeError_pos (s : ConversionStage) (E : ℤ) :
    0 < gemmConversionModeError s E :=
  Rat.mul_pos (roundingBudgetFactor_pos s.mode) (pow2_pos _)
```

**Supporting proofs:** [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.roundingBudgetFactor_pos](RoundingBudget.md#decl-fae3c42fcb78ec85)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-a884460a8acd89fe"></a>

<details>
<summary><code>TensorCore.gemmConversionModeError_le</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L26)

```lean
theorem gemmConversionModeError_le (s : ConversionStage) (E : ℤ) :
    gemmConversionModeError s E ≤ gemmConversionError s.format E := by
  have h := Rat.mul_le_mul_of_nonneg_right (roundingBudgetFactor_le_one s.mode)
    (Rat.le_of_lt (pow2_pos (E - s.format.fractionBits)))
  simpa only [Rat.one_mul, gemmConversionModeError, gemmConversionError] using h
```

**Supporting proofs:** [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.roundingBudgetFactor_le_one](RoundingBudget.md#decl-f338b44782680bc2)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-f755f2a49fffbd90"></a>

<details>
<summary><code>TensorCore.coefficient_error</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L32)

```lean
private theorem coefficient_error (mode : BinaryRoundingMode) (negative : Bool) (x : ℚ) :
    absQ (x - binaryCoefficient mode negative x) ≤ roundingBudgetFactor mode := by
  have hf := Rat.floor_le x
  have hf' := Rat.lt_floor_add_one x
  have hc := Rat.le_ceil (x := x)
  have hc' := Rat.ceil_lt (x := x)
  cases mode with
  | nearestEven =>
    have h := rneInt_dist_le_half x
    change absQ (x - rneInt x) ≤ 1 / 2
    grind
  | towardZero =>
    change absQ (x - x.floor) ≤ 1
    apply (absQ_le_iff _ _).mpr
    constructor <;> grind
  | towardNegative =>
    simp only [binaryCoefficient, roundingBudgetFactor]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind
  | towardPositive =>
    simp only [binaryCoefficient, roundingBudgetFactor]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind
```

**Supporting proofs:** [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.rneInt_dist_le_half](../Core/Rounding.md#decl-926c4e219d946918)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.magnitude_error](RoundingBudget.md#decl-31adebb3a0727f59)

</details>

</details>

<a id="decl-31adebb3a0727f59"></a>

<details>
<summary><code>TensorCore.magnitude_error</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L54)

```lean
private theorem magnitude_error (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) :
    absQ (m - binaryMagnitudeRounded f mode negative m) ≤
      roundingBudgetFactor mode * pow2 (binaryConvExp f m - f.fractionBits) := by
  let q := pow2 (binaryConvExp f m - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  have h := Rat.mul_le_mul_of_nonneg_right (coefficient_error mode negative (m / q))
    (Rat.le_of_lt hq)
  rw [← absQ_mul_pos _ q hq] at h
  have he : (m / q - (binaryCoefficient mode negative (m / q) : ℚ)) * q =
      m - (binaryCoefficient mode negative (m / q) : ℚ) * q := by
    have := Rat.div_mul_cancel (Rat.ne_of_gt hq) (a := m)
    grind
  rw [he] at h
  exact h
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](../Core/Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.coefficient_error](RoundingBudget.md#decl-f755f2a49fffbd90)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](../Core/Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signed_error](RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-05aed2e9019958e7"></a>

<details>
<summary><code>TensorCore.signed_error</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L70)

```lean
private theorem signed_error (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    absQ (x - binarySignedRounded f mode x) ≤
      roundingBudgetFactor mode * pow2 (binaryConvExp f (absQ x) - f.fractionBits) := by
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

**Supporting proofs:** [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](../Core/Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.magnitude_error](RoundingBudget.md#decl-31adebb3a0727f59)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](../Core/Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-d3d71a31e2b78bab"></a>

<details>
<summary><code>TensorCore.gemmConversion_mode_error</code></summary>

[Lean source](../../../TensorCore/Gemm/RoundingBudget.lean#L85)

```lean
/-- Supplied magnitude scales bound rounding error without inspecting an output. -/
theorem gemmConversion_mode_error (s : ConversionStage) (E : ℤ) (hE : s.format.emin ≤ E)
    (x : ℚ) (hx : absQ x ≤ pow2 E) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : absQ (x - d.value) ≤ gemmConversionModeError s E := by
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
    exact Rat.le_of_lt (gemmConversionModeError_pos s E)
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
    exact Rat.le_trans (signed_error s.format s.mode x)
      (Rat.mul_le_mul_of_nonneg_left hq (Rat.le_of_lt (roundingBudgetFactor_pos s.mode)))
```

**Supporting proofs:** [TensorCore.absQ_pos_of_ne_zero](../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binaryValue_zero](../Core/Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.conversionStage_output](../Core/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Core/Conversion.md#decl-9878d77fe9422846), [TensorCore.gemmConversionModeError_pos](RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.magnitudeExponent_le_of_lt](../Core/Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_lt_succ](../Core/Exact.md#decl-b1dfe79296f2080d), [TensorCore.roundBinary_nonzero_spec](../Core/Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundingBudgetFactor_pos](RoundingBudget.md#decl-fae3c42fcb78ec85), [TensorCore.signed_error](RoundingBudget.md#decl-05aed2e9019958e7)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](../Core/Binary/RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundingBudgetFactor](RoundingBudget.md#decl-b1b46e87eaa6e07f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>
