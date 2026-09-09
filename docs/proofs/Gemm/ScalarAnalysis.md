# TensorCore.Gemm.ScalarAnalysis

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4af01d3e1e19ed79"></a>

<details>
<summary><code>TensorCore.conversion_exact_value</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L9)

```lean
theorem conversion_exact_value (s : ConversionStage) (hf : s.format.WellFormed)
    (x : ℚ) (hx : s.format.FiniteValue x) :
    ∃ d, s.convert x = some d ∧ d.value = x := by
  obtain ⟨d, hd⟩ := gemmConversion_total s hf x (s.format.finiteValue_abs_le hx)
  have hc := gemmConversion_correct s x d hd
  have hv : binaryValue s.format d.bits = some d.value := by
    simp [binaryValue, d.valid, FiniteBinary.value]
  refine ⟨d, hd, ?_⟩
  cases hm : s.mode with
  | nearestEven =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hn, _⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have hh := hn x hx
    rw [Rat.sub_self] at hh
    have := (absQ_le_iff _ _).mp hh
    change -0 ≤ x - d.value ∧ x - d.value ≤ 0 at this
    grind
  | towardZero =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hb, hn⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have hs : Between0 x x := by unfold Between0; grind
    have hh := hn x hx hs
    unfold Between0 at hb
    rcases hb with ⟨hx0, hd0, hdx⟩ | ⟨hx0, hxd, hd0⟩
    · rw [absQ_of_nonneg hx0, absQ_of_nonneg hd0] at hh
      grind
    · have ha : absQ x = -x := by unfold absQ; split <;> grind
      have hb : absQ d.value = -d.value := by unfold absQ; split <;> grind
      rw [ha, hb] at hh
      grind
  | towardNegative =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hb, hn⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have := hn x hx Rat.le_refl
    grind
  | towardPositive =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hb, hn⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have := hn x hx Rat.le_refl
    grind
```

**Supporting proofs:** [TensorCore.Format.finiteValue_abs_le](../Core/Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.gemmConversion_correct](ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmConversion_total](ConversionBounds.md#decl-e4112c653555bb26)

**Definitions and types:** [TensorCore.Between0](../Core/Binary/CorrectRounding.md#decl-e53091bc8dd24dfe), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.FiniteValue](../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmRounded](ScaledGemm.md#decl-601fdad850a94274), [TensorCore.NearestEven](../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardNegative](../Core/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.TowardPositive](../Core/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkFiniteAdd_sound](ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkOutput_sound](ScalarAnalysis.md#decl-f783bada48aebde4)

</details>

</details>

<a id="decl-4226e8a52e034c11"></a>

<details>
<summary><code>TensorCore.ScalarBound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L58)

```lean
structure ScalarBound where
  magnitude : ℚ
  error : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.exact_scalar_budgets](Regression/DecisionExtensions.md#decl-dc66e6e5ce7975e9), [TensorCore.Regression.scalar_analysis_range_boundary](Regression/PipelineAnalysis.md#decl-314a8146be1eee9e), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteAdd_sound](ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.checkOutput_sound](ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.checkScalar_inferred](ScalarAnalysis.md#decl-6e0263f84e5e0f8c), [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.scalarBound](ScalarAnalysis.md#decl-7e61c221e3ed5c6f)

</details>

</details>

<a id="decl-9699e837c1012c63"></a>

<details>
<summary><code>TensorCore.scalarScale</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L63)

```lean
def scalarScale (f : Format) (M : ℚ) : ℤ :=
  if M = 0 then f.emin else max f.emin (magnitudeExponent M + 1)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15)

<details>
<summary>Used by</summary>

[TensorCore.checkScalar_inferred](ScalarAnalysis.md#decl-6e0263f84e5e0f8c), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.scalarScale_spec](ScalarAnalysis.md#decl-ab7863fd9c2c72d3)

</details>

</details>

<a id="decl-ab7863fd9c2c72d3"></a>

<details>
<summary><code>TensorCore.scalarScale_spec</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L66)

```lean
theorem scalarScale_spec (f : Format) (M : ℚ) (hM : 0 ≤ M) :
    f.emin ≤ scalarScale f M ∧ M ≤ pow2 (scalarScale f M) := by
  by_cases hz : M = 0
  · simp only [scalarScale, hz, ↓reduceIte]
    exact ⟨Int.le_refl _, Rat.le_of_lt (pow2_pos _)⟩
  · have hm := (magnitudeExponent_spec M (show 0 < M by grind)).2
    have he : magnitudeExponent M + 1 ≤ max f.emin (magnitudeExponent M + 1) := by omega
    have hp := pow2_le_of_le he
    simp only [scalarScale, hz, ↓reduceIte]
    exact ⟨by omega, by grind⟩
```

**Supporting proofs:** [TensorCore.magnitudeExponent_spec](../Core/Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.scalarScale](ScalarAnalysis.md#decl-9699e837c1012c63)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkScalar_inferred](ScalarAnalysis.md#decl-6e0263f84e5e0f8c)

</details>

</details>

<a id="decl-7e61c221e3ed5c6f"></a>

<details>
<summary><code>TensorCore.scalarBound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L77)

```lean
def scalarBound (s : ConversionStage) (M : ℚ) (E : ℤ) : ScalarBound :=
  let error := if M = 0 then 0 else gemmConversionModeError s E
  ⟨min (M + error) s.format.maxFinite, error⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261)

<details>
<summary>Used by</summary>

[TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.checkScalar_inferred](ScalarAnalysis.md#decl-6e0263f84e5e0f8c), [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314)

</details>

</details>

<a id="decl-96e8393f74f6c382"></a>

<details>
<summary><code>TensorCore.checkScalar</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L81)

```lean
def checkScalar (s : ConversionStage) (M : ℚ) (E : ℤ) : Option ScalarBound :=
  if s.format.WellFormed ∧ 0 ≤ M ∧ M ≤ s.format.maxFinite ∧
      s.format.emin ≤ E ∧ M ≤ pow2 E then some (scalarBound s M E) else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.scalarBound](ScalarAnalysis.md#decl-7e61c221e3ed5c6f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scalar_analysis_range_boundary](Regression/PipelineAnalysis.md#decl-314a8146be1eee9e), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteAdd_sound](ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.checkOutput_sound](ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar_inferred](ScalarAnalysis.md#decl-6e0263f84e5e0f8c), [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314)

</details>

</details>

<a id="decl-fde6315e382f7314"></a>

<details>
<summary><code>TensorCore.checkScalar_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L85)

```lean
theorem checkScalar_sound (s : ConversionStage) (M : ℚ) (E : ℤ) (b : ScalarBound)
    (h : checkScalar s M E = some b) (x : ℚ) (hx : absQ x ≤ M) :
    ∃ d, s.convert x = some d ∧ absQ d.value ≤ b.magnitude ∧ absQ (x - d.value) ≤ b.error := by
  unfold checkScalar at h
  split at h
  next hh =>
    obtain ⟨hf, _, hr, he, hm⟩ := hh
    cases Option.some.inj h
    obtain ⟨d, hd⟩ := gemmConversion_total s hf x (Rat.le_trans hx hr)
    have herr : absQ (x - d.value) ≤ (scalarBound s M E).error := by
      by_cases hz : M = 0
      · have hzero : x = 0 := by have := (absQ_le_iff x M).mp hx; grind
        have hv := conversionStage_output hd
        rw [hzero, roundBinary_zero s.format hf s.mode] at hv
        have hval : binaryValue s.format d.bits = some d.value := by
          simp [binaryValue, d.valid, FiniteBinary.value]
        rw [← Option.some.inj hv, binaryValue_zero s.format hf] at hval
        simp [scalarBound, hz, hzero, ← Option.some.inj hval, Rat.sub_self, absQ]
      · simpa [scalarBound, hz] using gemmConversion_mode_error s E he x (Rat.le_trans hx hm) d hd
    refine ⟨d, hd, ?_, herr⟩
    have ht := absQ_add_le x (d.value - x)
    rw [absQ_sub_comm d.value x] at ht
    have hid : x + (d.value - x) = d.value := by grind
    rw [hid] at ht
    have hfval := classifyNat_finiteValue s.format hf d.bits.toNat d.decoded d.valid
    have hmax := s.format.finiteValue_abs_le hfval
    change absQ d.value ≤ s.format.maxFinite at hmax
    change absQ d.value ≤ min (M + (scalarBound s M E).error) s.format.maxFinite
    rw [Rat.min_def]
    split <;> grind
  next _ => contradiction
```

**Supporting proofs:** [TensorCore.Format.finiteValue_abs_le](../Core/Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_sub_comm](../Core/Exact.md#decl-a632fad01d9c884a), [TensorCore.binaryValue_zero](../Core/Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.classifyNat_finiteValue](../Core/Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.conversionStage_output](../Core/Conversion.md#decl-3479ab5362b59148), [TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.roundBinary_zero](../Core/Binary/RoundingContract.md#decl-765cac64e8b78cf4)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.scalarBound](ScalarAnalysis.md#decl-7e61c221e3ed5c6f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkFiniteAdd_sound](ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkOutput_sound](ScalarAnalysis.md#decl-f783bada48aebde4)

</details>

</details>

<a id="decl-6e0263f84e5e0f8c"></a>

<details>
<summary><code>TensorCore.checkScalar_inferred</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L117)

```lean
theorem checkScalar_inferred (s : ConversionStage) (M : ℚ)
    (hf : s.format.WellFormed) (hM : 0 ≤ M) (hr : M ≤ s.format.maxFinite) :
    checkScalar s M (scalarScale s.format M) = some (scalarBound s M (scalarScale s.format M)) := by
  have hs := scalarScale_spec s.format M hM
  simp [checkScalar, hf, hM, hr, hs]
```

**Supporting proofs:** [TensorCore.scalarScale_spec](ScalarAnalysis.md#decl-ab7863fd9c2c72d3)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.scalarBound](ScalarAnalysis.md#decl-7e61c221e3ed5c6f), [TensorCore.scalarScale](ScalarAnalysis.md#decl-9699e837c1012c63)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4b04c6bba4e64aae"></a>

<details>
<summary><code>TensorCore.checkOutput</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L123)

```lean
def checkOutput (s : ConversionStage) (M : ℚ) (E : ℤ) : Option ScalarBound :=
  if s.format = fp32 then some ⟨M, 0⟩ else checkScalar s M E
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkOutput_sound](ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e)

</details>

</details>

<a id="decl-f783bada48aebde4"></a>

<details>
<summary><code>TensorCore.checkOutput_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScalarAnalysis.lean#L126)

```lean
theorem checkOutput_sound (s : ConversionStage) (M : ℚ) (E : ℤ) (b : ScalarBound)
    (h : checkOutput s M E = some b) (x : FiniteBinary fp32) (hx : absQ x.value ≤ M) :
    ∃ d, s.convert x.value = some d ∧ absQ d.value ≤ b.magnitude ∧
      absQ (x.value - d.value) ≤ b.error := by
  unfold checkOutput at h
  split at h
  next hf =>
    cases Option.some.inj h
    have hfinite : s.format.FiniteValue x.value := by
      rw [hf]
      exact classifyNat_finiteValue fp32 (by decide) x.bits.toNat x.decoded x.valid
    obtain ⟨d, hd, hv⟩ := conversion_exact_value s (by rw [hf]; decide) x.value hfinite
    exact ⟨d, hd, by simpa [hv] using hx, by simp [hv, Rat.sub_self, absQ]⟩
  next _ => exact checkScalar_sound s M E b h x.value hx
```

**Supporting proofs:** [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.classifyNat_finiteValue](../Core/Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.conversion_exact_value](ScalarAnalysis.md#decl-4af01d3e1e19ed79)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkOutput](ScalarAnalysis.md#decl-4b04c6bba4e64aae), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332)

</details>

</details>
