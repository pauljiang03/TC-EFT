# TensorCore.Gemm.Specification.ScalarRounding

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d2db74b0263bc16a"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarModeOf</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L9)

```lean
def scalarModeOf : BinaryRoundingMode → ScalarMode
  | .towardZero => .towardZero | .nearestEven => .nearestEven
  | .towardNegative => .towardNegative | .towardPositive => .towardPositive
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.scalarCoefficient_eq](ScalarRounding.md#decl-2089a73178eb37e6), [TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarGridValue_eq](ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45), [TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b), [TensorCore.PaperSpec.scalarStageOf](ScaledGemmEquivalence.md#decl-0d7d7612b2b29253), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scalar_directions](../../Regression/FoundationCompletion.md#decl-ac87bcf2ff18868c), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-5f6e455aabd909c4"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarValue_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L13)

```lean
theorem scalarValue_eq (f : Format) (b : BitVec f.width) :
    scalarValue (layoutOf f) b = binaryValue f b := by
  unfold scalarValue
  rw [decode_eq]
  simp only [Option.map_map]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.decode_eq](../../TC/Specification/Stages.md#decl-16342b2304718371)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.decode](../../TC/Specification/Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.PaperSpec.termOf](../../TC/Specification/Stages.md#decl-5d5575e19169b785), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classifyNat](../../Core/Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-8b6a74aaa17139cc"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarSign_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L20)

```lean
theorem scalarSign_eq (f : Format) (b : BitVec f.width) :
    scalarSign (layoutOf f) b = binarySign f b := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarSign](Scalar.md#decl-bbecaf1f5b504db0), [TensorCore.binarySign](../../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2089a73178eb37e6"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarCoefficient_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L23)

```lean
theorem scalarCoefficient_eq (mode : BinaryRoundingMode) (negative : Bool) (x : ℚ) :
    scalarCoefficient (scalarModeOf mode) negative x = binaryCoefficient mode negative x := by
  cases mode <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.PaperSpec.scalarCoefficient](Scalar.md#decl-8418bbbe47ded436), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.binaryCoefficient](../../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarGridValue_eq](ScalarRounding.md#decl-b4fe8f74d8aee01a)

</details>

</details>

<a id="decl-dc1d766095dea794"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarExponent_unique</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L27)

```lean
theorem scalarExponent_unique (f : Format) (x : ℚ) (a b : ℤ)
    (ha : ScalarExponent (layoutOf f) x a) (hb : ScalarExponent (layoutOf f) x b) : a = b := by
  obtain ⟨hal, _, hau, had⟩ := ha
  obtain ⟨hbl, _, hbu, hbd⟩ := hb
  by_cases hab : a < b
  · have hp := pow2_le_of_le (show a + 1 ≤ b by omega)
    change pow2 b ≤ x ∨ b = _ at hbd
    change x < pow2 (a + 1) at hau
    rcases hbd with h | h <;> grind
  · by_cases hba : b < a
    · have hp := pow2_le_of_le (show b + 1 ≤ a by omega)
      change pow2 a ≤ x ∨ a = _ at had
      change x < pow2 (b + 1) at hbu
      rcases had with h | h <;> grind
    · omega
```

**Supporting proofs:** [TensorCore.pow2_le_of_le](../../Core/Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.PaperSpec.Layout.maximumExponent](Scalar.md#decl-5d3f38169613a858), [TensorCore.PaperSpec.Layout.minimumExponent](Scalar.md#decl-2937477b30ef6eb0), [TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-b4fe8f74d8aee01a"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarGridValue_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L43)

```lean
theorem scalarGridValue_eq (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    scalarGridValue (layoutOf f) (scalarModeOf mode) x (binaryConvExp f (absQ x)) =
      binarySignedRounded f mode x := by
  by_cases hx : x < 0 <;>
    simp [scalarGridValue, scalarCoefficient_eq, binarySignedRounded,
      binaryMagnitudeRounded, hx, layoutOf, magnitude, absQ, pow2]
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarCoefficient_eq](ScalarRounding.md#decl-2089a73178eb37e6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.scalarCoefficient](Scalar.md#decl-8418bbbe47ded436), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryMagnitudeRounded](../../Core/Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binarySignedRounded](../../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b)

</details>

</details>

<a id="decl-50e39e663380ba0c"></a>

<details>
<summary><code>TensorCore.PaperSpec.word_value_sign_unique</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L50)

```lean
private theorem word_value_sign_unique (f : Format) (hf : f.WellFormed)
    (a b : BitVec f.width) (v : ℚ) (ha : binaryValue f a = some v)
    (hb : binaryValue f b = some v) (hs : binarySign f a = binarySign f b) : a = b := by
  obtain ⟨da, hda, _⟩ := Option.map_eq_some_iff.mp ha
  obtain ⟨db, hdb, _⟩ := Option.map_eq_some_iff.mp hb
  exact congrArg Subtype.val (binaryValue_sign_injective f hf ⟨a, da, hda⟩ ⟨b, db, hdb⟩ v ha hb hs)
```

**Supporting proofs:** [TensorCore.binaryValue_sign_injective](../../Core/Binary/SignedBijection.md#decl-9cff42a1aec63f03)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.binarySign](../../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-00aa06dd6d65901b"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarResult_of_roundBinary</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L57)

```lean
theorem scalarResult_of_roundBinary (f : Format) (mode : BinaryRoundingMode) (x : ℚ)
    (b : BitVec f.width) (h : roundBinary f mode x = some b) :
    ScalarResult (layoutOf f) (scalarModeOf mode) x b := by
  obtain ⟨hf, hr⟩ := roundBinary_range h
  refine ⟨hf, hr, roundBinary_sign f mode x b h, ?_⟩
  by_cases hx : x = 0
  · subst x
    rw [roundBinary_zero f hf mode] at h
    cases Option.some.inj h
    simpa [scalarValue_eq] using binaryValue_zero f hf
  · rw [if_neg hx]
    obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec f hf mode x hx hr
    have heq := Option.some.inj (hb.symm.trans h)
    subst bits
    refine ⟨binaryConvExp f (absQ x), binaryConvExp_bounds f hf _ (absQ_pos_of_ne_zero x hx) hr, ?_⟩
    rw [scalarValue_eq, scalarGridValue_eq]
    exact hv
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarGridValue_eq](ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.PaperSpec.scalarValue_eq](ScalarRounding.md#decl-5f6e455aabd909c4), [TensorCore.absQ_pos_of_ne_zero](../../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.binaryConvExp_bounds](../../Core/Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.binaryValue_zero](../../Core/Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.roundBinary_nonzero_spec](../../Core/Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](../../Core/Binary/RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](../../Core/Binary/RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_zero](../../Core/Binary/RoundingContract.md#decl-765cac64e8b78cf4)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.maximumFinite](Scalar.md#decl-4205908460964844), [TensorCore.PaperSpec.Layout.scalarValid](Scalar.md#decl-e1c152549472c20f), [TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarSign](Scalar.md#decl-bbecaf1f5b504db0), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binarySignedRounded](../../Core/Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b)

</details>

</details>

<a id="decl-4b9521bc6b0ebd45"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarResult_unique</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L75)

```lean
theorem scalarResult_unique (f : Format) (mode : BinaryRoundingMode) (x : ℚ)
    (a b : BitVec f.width)
    (ha : ScalarResult (layoutOf f) (scalarModeOf mode) x a)
    (hb : ScalarResult (layoutOf f) (scalarModeOf mode) x b) : a = b := by
  obtain ⟨hf, _, hsa, ha⟩ := ha
  obtain ⟨_, _, hsb, hb⟩ := hb
  have hs : binarySign f a = binarySign f b := hsa.trans hsb.symm
  by_cases hx : x = 0
  · simp only [hx, ↓reduceIte, scalarValue_eq] at ha hb
    exact word_value_sign_unique f hf a b 0 ha hb hs
  · rw [if_neg hx] at ha hb
    obtain ⟨ea, hea, hva⟩ := ha
    obtain ⟨eb, heb, hvb⟩ := hb
    have he := scalarExponent_unique f _ ea eb hea heb
    subst eb
    rw [scalarValue_eq] at hva hvb
    exact word_value_sign_unique f hf a b _ hva hvb hs
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarExponent_unique](ScalarRounding.md#decl-dc1d766095dea794), [TensorCore.PaperSpec.scalarValue_eq](ScalarRounding.md#decl-5f6e455aabd909c4), [TensorCore.PaperSpec.word_value_sign_unique](ScalarRounding.md#decl-50e39e663380ba0c)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.maximumFinite](Scalar.md#decl-4205908460964844), [TensorCore.PaperSpec.Layout.scalarValid](Scalar.md#decl-e1c152549472c20f), [TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarSign](Scalar.md#decl-bbecaf1f5b504db0), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.binarySign](../../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185)

</details>

</details>

<a id="decl-950c566a7a363185"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarResult_iff</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L93)

```lean
theorem scalarResult_iff (f : Format) (mode : BinaryRoundingMode) (x : ℚ) (b : BitVec f.width) :
    ScalarResult (layoutOf f) (scalarModeOf mode) x b ↔ roundBinary f mode x = some b := by
  constructor
  · intro h
    obtain ⟨a, ha, _⟩ := roundBinary_correct f h.1 mode x h.2.1
    have he := scalarResult_unique f mode x a b (scalarResult_of_roundBinary f mode x a ha) h
    rwa [he] at ha
  · exact scalarResult_of_roundBinary f mode x b
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45), [TensorCore.roundBinary_correct](../../Core/Binary/RoundingContract.md#decl-12a22af180d3ad5e)

**Definitions and types:** [TensorCore.BinaryRoundSpec](../../Core/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.maximumFinite](Scalar.md#decl-4205908460964844), [TensorCore.PaperSpec.Layout.scalarValid](Scalar.md#decl-e1c152549472c20f), [TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarSign](Scalar.md#decl-bbecaf1f5b504db0), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b)

</details>

</details>

<a id="decl-dac12f3fa291169b"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarRound_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScalarRounding.lean#L104)

```lean
/-- Unconditional agreement includes ill-formed target formats and finite-range
rejections. The mathematical selector has no implementation dependency. -/
theorem scalarRound_eq (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    scalarRound (layoutOf f) (scalarModeOf mode) x = roundBinary f mode x := by
  classical
  unfold scalarRound
  split
  · rename_i h
    exact ((scalarResult_iff f mode x _).mp (Classical.choose_spec h)).symm
  · rename_i h
    cases hr : roundBinary f mode x with
    | none => rfl
    | some b => exact False.elim (h ⟨b, scalarResult_of_roundBinary f mode x b hr⟩)
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.Regression.independent_scalar_directions](../../Regression/FoundationCompletion.md#decl-ac87bcf2ff18868c)

</details>

</details>
