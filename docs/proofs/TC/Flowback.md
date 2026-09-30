# TensorCore.TC.Flowback

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-bb2cbdd4e98d833c"></a>

<details>
<summary><code>TensorCore.MonotoneInAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L19)

```lean
/-- Definition III.2: for fixed decoded products, a smaller finite accumulator input never
produces a larger accepted output. -/
def MonotoneInAccumulator (prof : Profile) (products : List (Decoded × Decoded)) : Prop :=
  ∀ (c c' : Decoded) (t t' : BlockTrace),
    evalPrepared ⟨prof, products, c⟩ = .ok t → evalPrepared ⟨prof, products, c'⟩ = .ok t' →
    c'.value < c.value → t'.output.value ≤ t.output.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12)

<details>
<summary>Used by</summary>

[TensorCore.Regression.v100_products_not_monotone](../Tests/EFT/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.not_monotoneInAccumulator_of_encoded](EncodedMonotonicity.md#decl-6b04e8218d0c9697)

</details>

</details>

<a id="decl-69e48afeebdfb15c"></a>

<details>
<summary><code>TensorCore.flowback</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L26)

```lean
/-- Definition III.3: the flowback `ω = Σᵢ (trunc_{q'A}(Tᵢ) − trunc_{qA}(Tᵢ))` of the
products between the alignment grids selected by `c` and by `c'`. -/
def flowback (prof : Profile) (products : List (Decoded × Decoded)) (c c' : Decoded) : ℚ :=
  sumQ (products.map fun (a, b) =>
    truncGrid (rawMul a b).value (PreparedBlock.mk prof products c').quantumExponent -
      truncGrid (rawMul a b).value (PreparedBlock.mk prof products c).quantumExponent)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2)

</details>

</details>

<a id="decl-c8ad334d1cfc26df"></a>

<details>
<summary><code>TensorCore.accumulatorShift</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L32)

```lean
/-- Definition III.3: `ΔA = trunc_{qA}(c) − trunc_{q'A}(c')`. -/
def accumulatorShift (prof : Profile) (products : List (Decoded × Decoded)) (c c' : Decoded) :
    ℚ :=
  truncGrid c.value (PreparedBlock.mk prof products c).quantumExponent -
    truncGrid c'.value (PreparedBlock.mk prof products c').quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.accumulatorShift_of_exact](Flowback.md#decl-d93ce2ab3174723d), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2)

</details>

</details>

<a id="decl-d8db235e56c7f3c2"></a>

<details>
<summary><code>TensorCore.perturbed_accumulator</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L38)

```lean
/-- `A'acc = Aacc + ω − ΔA`. -/
theorem perturbed_accumulator (prof : Profile) (products : List (Decoded × Decoded))
    (c c' : Decoded) :
    (PreparedBlock.mk prof products c').accumulator =
      (PreparedBlock.mk prof products c).accumulator + flowback prof products c c' -
        accumulatorShift prof products c c' := by
  rw [accumulator_value, accumulator_value]
  simp only [PreparedBlock.terms, List.map_cons, List.map_map, sumQ, Function.comp_def]
  unfold flowback accumulatorShift
  rw [sumQ_map_sub]
  have hc : RawProduct.value ⟨c.significand, c.rawScale, c.fractionalBits⟩ = c.value := rfl
  have hc' : RawProduct.value ⟨c'.significand, c'.rawScale, c'.fractionalBits⟩ = c'.value := rfl
  rw [hc, hc']
  grind
```

**Supporting proofs:** [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.sumQ_map_sub](../Numerics/Sum.md#decl-23e4bf84c54e623b)

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.flowback](Flowback.md#decl-69e48afeebdfb15c), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03)

</details>

</details>

<a id="decl-17953b6216d0cce0"></a>

<details>
<summary><code>TensorCore.evalPrepared_output_value</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L53)

```lean
/-- The value of an accepted output is the signed truncation of the accumulator. -/
theorem evalPrepared_output_value {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) :
    t.output.value = signedRounded .towardZero b.accumulator := by
  have hout := evalPrepared_output h
  have hd : value32 t.output.bits = some t.output.value := by
    simp [value32, t.output.valid, Finite32.value]
  by_cases hz : b.accumulator = 0
  · rw [hz] at hout
    have h0 : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [h0] at hout
    have hb : t.output.bits = 0 := (Option.some.inj hout).symm
    rw [hb] at hd
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    have hs : signedRounded .towardZero 0 = 0 := by decide +kernel
    rw [hz, hs]
    exact (Option.some.inj hd).symm
  · obtain ⟨b', hb', hd', _, _⟩ :=
      round32_nonzero_spec .towardZero b.accumulator hz (round32_range hout)
    rw [hout] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    exact Option.some.inj hd'
```

**Supporting proofs:** [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.round32_nonzero_spec](../Numerics/CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](../Numerics/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](../Numerics/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Numerics/RoundOp.md#decl-712564d4fa452350), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03)

</details>

</details>

<a id="decl-baefc4c567a5cd91"></a>

<details>
<summary><code>TensorCore.magnitudeRounded_rtz_monotone</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L78)

```lean
/-- Truncation toward zero of magnitudes is monotone within the finite range. -/
theorem magnitudeRounded_rtz_monotone (x y : ℚ) (hx : 0 ≤ x) (hxy : x ≤ y)
    (hy : y ≤ maxFinite32) :
    magnitudeRounded .towardZero x ≤ magnitudeRounded .towardZero y := by
  unfold magnitudeRounded convCoeff roundCoefficient
  by_cases hx0 : x = 0
  · subst hx0
    have hqy := pow2_pos (convExp y - 23)
    have h0 : ((((0 : ℚ) / pow2 (convExp 0 - 23)).floor : ℤ) : ℚ) * pow2 (convExp 0 - 23) = 0 := by
      rw [Rat.div_def, Rat.zero_mul, ← Rat.intCast_zero, Rat.floor_intCast]
      simp
    rw [h0]
    have hfl : (0 : ℤ) ≤ (y / pow2 (convExp y - 23)).floor := by
      apply Rat.le_floor_iff.mpr
      have := div_nonneg_of_pos _ _ (Rat.le_trans hx hxy) hqy
      simpa using this
    have : (0 : ℚ) ≤ (((y / pow2 (convExp y - 23)).floor : ℤ) : ℚ) := by
      have := Rat.intCast_le_intCast.mpr hfl
      simpa using this
    exact Rat.mul_nonneg this (Rat.le_of_lt hqy)
  · have hxpos : 0 < x := by grind
    have hypos : 0 < y := by grind
    obtain ⟨hex1, _, hexlt, hexge⟩ := convExp_bounds x hxpos (Rat.le_trans hxy hy)
    obtain ⟨_, _, _, heyge⟩ := convExp_bounds y hypos hy
    have hmx := magnitudeExponent_spec x hxpos
    have hmy := magnitudeExponent_spec y hypos
    have hmono : magnitudeExponent x ≤ magnitudeExponent y := by
      apply Classical.byContradiction
      intro hne
      have := pow2_le_of_le (show magnitudeExponent y + 1 ≤ magnitudeExponent x by omega)
      grind
    have hce : convExp x ≤ convExp y := by unfold convExp; omega
    rcases Int.lt_or_eq_of_le hce with hlt | heq
    · have hqy := pow2_pos (convExp y - 23)
      have hey : pow2 (convExp y) ≤ y := by
        rcases heyge with h | h
        · exact h
        · exfalso; omega
      have hlow : pow2 (convExp y) ≤
          (((y / pow2 (convExp y - 23)).floor : ℤ) : ℚ) * pow2 (convExp y - 23) := by
        have h23 : ((8388608 : ℤ) : ℚ) * pow2 (convExp y - 23) = pow2 (convExp y) := by
          have : ((8388608 : ℤ) : ℚ) = pow2 23 := by decide +kernel
          rw [this, ← pow2_add]
          congr 1
          omega
        have hk : (8388608 : ℤ) ≤ (y / pow2 (convExp y - 23)).floor := by
          apply Rat.le_floor_iff.mpr
          apply le_div_of_mul_le _ _ _ hqy
          rw [h23]
          exact hey
        have := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hk) (Rat.le_of_lt hqy)
        rw [h23] at this
        exact this
      have hqx := pow2_pos (convExp x - 23)
      have hhigh : (((x / pow2 (convExp x - 23)).floor : ℤ) : ℚ) * pow2 (convExp x - 23) ≤ x := by
        have := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (x / pow2 (convExp x - 23)))
          (Rat.le_of_lt hqx)
        rwa [Rat.div_mul_cancel (Rat.ne_of_gt hqx)] at this
      have hstep := pow2_le_of_le (show convExp x + 1 ≤ convExp y by omega)
      grind
    · rw [heq]
      have hq := pow2_pos (convExp y - 23)
      have hdiv : x / pow2 (convExp y - 23) ≤ y / pow2 (convExp y - 23) :=
        div_le_div_of_le_right _ _ _ hq hxy
      have hfl := Rat.floor_monotone hdiv
      exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hfl) (Rat.le_of_lt hq)
```

**Supporting proofs:** [TensorCore.convExp_bounds](../Numerics/ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.div_le_div_of_le_right](../Numerics/Exact.md#decl-c05af5c54a1fa836), [TensorCore.div_nonneg_of_pos](../Numerics/Exact.md#decl-67bd25479bf5fb7a), [TensorCore.le_div_of_mul_le](../Numerics/Exact.md#decl-020e94a8d8a6259e), [TensorCore.magnitudeExponent_spec](../Numerics/Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_le_of_le](../Numerics/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.convCoeff](../Numerics/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Numerics/RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](../Numerics/RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.magnitudeExponent](../Numerics/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.magnitudeRounded](../Numerics/RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](../Numerics/RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signedRounded_rtz_monotone](Flowback.md#decl-561aeb37f020d4bf)

</details>

</details>

<a id="decl-561aeb37f020d4bf"></a>

<details>
<summary><code>TensorCore.signedRounded_rtz_monotone</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L145)

```lean
/-- Signed truncation toward zero is monotone within the finite range. -/
theorem signedRounded_rtz_monotone (x y : ℚ) (hxy : x ≤ y) (hx : absQ x ≤ maxFinite32)
    (hy : absQ y ≤ maxFinite32) :
    signedRounded .towardZero x ≤ signedRounded .towardZero y := by
  unfold signedRounded
  have hnonneg : ∀ z : ℚ, 0 ≤ magnitudeRounded .towardZero (absQ z) := by
    intro z
    unfold magnitudeRounded convCoeff roundCoefficient
    have hq := pow2_pos (convExp (absQ z) - 23)
    have hfl : (0 : ℤ) ≤ (absQ z / pow2 (convExp (absQ z) - 23)).floor := by
      apply Rat.le_floor_iff.mpr
      have := div_nonneg_of_pos _ _ (absQ_nonneg z) hq
      simpa using this
    have : (0 : ℚ) ≤ (((absQ z / pow2 (convExp (absQ z) - 23)).floor : ℤ) : ℚ) := by
      have := Rat.intCast_le_intCast.mpr hfl
      simpa using this
    exact Rat.mul_nonneg this (Rat.le_of_lt hq)
  by_cases hxn : x < 0
  · by_cases hyn : y < 0
    · rw [if_pos hxn, if_pos hyn]
      have hab : absQ y ≤ absQ x := by
        rw [absQ_of_neg hxn, absQ_of_neg hyn]
        grind
      have := magnitudeRounded_rtz_monotone (absQ y) (absQ x) (absQ_nonneg y) hab hx
      grind
    · rw [if_pos hxn, if_neg hyn]
      have h1 := hnonneg x
      have h2 := hnonneg y
      grind
  · have hyn : ¬ y < 0 := by grind
    rw [if_neg hxn, if_neg hyn]
    have hxnn : 0 ≤ x := by grind
    have hab : absQ x ≤ absQ y := by
      rw [absQ_of_nonneg hxnn, absQ_of_nonneg (Rat.le_trans hxnn hxy)]
      exact hxy
    exact magnitudeRounded_rtz_monotone (absQ x) (absQ y) (absQ_nonneg x) hab hy
```

**Supporting proofs:** [TensorCore.absQ_nonneg](../Numerics/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_of_neg](../Numerics/Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../Numerics/Exact.md#decl-2aceea0008eec277), [TensorCore.div_nonneg_of_pos](../Numerics/Exact.md#decl-67bd25479bf5fb7a), [TensorCore.magnitudeRounded_rtz_monotone](Flowback.md#decl-baefc4c567a5cd91), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](../Numerics/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Numerics/RoundOp.md#decl-712564d4fa452350), [TensorCore.magnitudeRounded](../Numerics/RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](../Numerics/RoundOp.md#decl-7662cf06d1725fc5), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06)

</details>

</details>

<a id="decl-0e59d06cafb9cfda"></a>

<details>
<summary><code>TensorCore.signedRounded_rtz_of_finite</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L182)

```lean
/-- A representable value is its own truncation. -/
theorem signedRounded_rtz_of_finite (x : ℚ) (h : FiniteValue32 x) :
    signedRounded .towardZero x = x := by
  by_cases hz : x = 0
  · subst hz
    decide +kernel
  · obtain ⟨b, _, hv⟩ := round32_exact_of_finite h
    have hr := value32_round32 .towardZero b x hv hz
    obtain ⟨b', hb', hd', _, _⟩ :=
      round32_nonzero_spec .towardZero x hz (finiteValue32_abs_le h)
    rw [hr] at hb'
    cases Option.some.inj hb'
    rw [hv] at hd'
    exact (Option.some.inj hd').symm
```

**Supporting proofs:** [TensorCore.finiteValue32_abs_le](../Numerics/ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.round32_exact_of_finite](../Numerics/ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_nonzero_spec](../Numerics/CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.value32_round32](../Numerics/RoundTrip.md#decl-46fb757285084429)

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](../Numerics/Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](../Numerics/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Numerics/RoundOp.md#decl-712564d4fa452350), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0)

</details>

</details>

<a id="decl-5dca5d0c5f0f3b03"></a>

<details>
<summary><code>TensorCore.output_condition</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L198)

```lean
/-- Equation 6: the accepted outputs compare exactly as the truncations of
`Aacc` and `Aacc + ω − ΔA`. -/
theorem output_condition (prof : Profile) (products : List (Decoded × Decoded))
    (c c' : Decoded) (t t' : BlockTrace)
    (h : evalPrepared ⟨prof, products, c⟩ = .ok t)
    (h' : evalPrepared ⟨prof, products, c'⟩ = .ok t') :
    (t.output.value < t'.output.value ↔
      signedRounded .towardZero (PreparedBlock.mk prof products c).accumulator <
        signedRounded .towardZero ((PreparedBlock.mk prof products c).accumulator +
          flowback prof products c c' - accumulatorShift prof products c c')) := by
  rw [evalPrepared_output_value h, evalPrepared_output_value h',
    perturbed_accumulator prof products c c']
```

**Supporting proofs:** [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.flowback](Flowback.md#decl-69e48afeebdfb15c), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8f48db3103211d06"></a>

<details>
<summary><code>TensorCore.flowback_necessary</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L210)

```lean
/-- `ω > ΔA` is necessary for an output increase. -/
theorem flowback_necessary (prof : Profile) (products : List (Decoded × Decoded))
    (c c' : Decoded) (t t' : BlockTrace)
    (h : evalPrepared ⟨prof, products, c⟩ = .ok t)
    (h' : evalPrepared ⟨prof, products, c'⟩ = .ok t')
    (hinc : t.output.value < t'.output.value) :
    accumulatorShift prof products c c' < flowback prof products c c' := by
  apply Classical.byContradiction
  intro hle
  have hle' : flowback prof products c c' ≤ accumulatorShift prof products c c' := by grind
  have hA := perturbed_accumulator prof products c c'
  have hr := round32_range (evalPrepared_output h)
  have hr' := round32_range (evalPrepared_output h')
  have hmono := signedRounded_rtz_monotone _ _
    (show (PreparedBlock.mk prof products c').accumulator ≤
      (PreparedBlock.mk prof products c).accumulator by rw [hA]; grind) hr' hr
  rw [evalPrepared_output_value h, evalPrepared_output_value h'] at hinc
  grind
```

**Supporting proofs:** [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.round32_range](../Numerics/RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.signedRounded_rtz_monotone](Flowback.md#decl-561aeb37f020d4bf)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.flowback](Flowback.md#decl-69e48afeebdfb15c), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b0715c384a285eb0"></a>

<details>
<summary><code>TensorCore.flowback_sufficient</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L229)

```lean
/-- `ω > ΔA` is sufficient when both accumulators are representable. -/
theorem flowback_sufficient (prof : Profile) (products : List (Decoded × Decoded))
    (c c' : Decoded) (t t' : BlockTrace)
    (h : evalPrepared ⟨prof, products, c⟩ = .ok t)
    (h' : evalPrepared ⟨prof, products, c'⟩ = .ok t')
    (hA : FiniteValue32 (PreparedBlock.mk prof products c).accumulator)
    (hA' : FiniteValue32 (PreparedBlock.mk prof products c').accumulator)
    (hgt : accumulatorShift prof products c c' < flowback prof products c c') :
    t.output.value < t'.output.value := by
  rw [evalPrepared_output_value h, evalPrepared_output_value h',
    signedRounded_rtz_of_finite _ hA, signedRounded_rtz_of_finite _ hA',
    perturbed_accumulator prof products c c']
  grind
```

**Supporting proofs:** [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.signedRounded_rtz_of_finite](Flowback.md#decl-0e59d06cafb9cfda)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteValue32](../Numerics/Defs.md#decl-916e7e459d399e32), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.flowback](Flowback.md#decl-69e48afeebdfb15c), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d93ce2ab3174723d"></a>

<details>
<summary><code>TensorCore.accumulatorShift_of_exact</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L243)

```lean
/-- When both accumulator inputs are retained exactly on their grids, `ΔA = c − c'`. -/
theorem accumulatorShift_of_exact (prof : Profile) (products : List (Decoded × Decoded))
    (c c' : Decoded)
    (hc : truncGrid c.value (PreparedBlock.mk prof products c).quantumExponent = c.value)
    (hc' : truncGrid c'.value (PreparedBlock.mk prof products c').quantumExponent = c'.value) :
    accumulatorShift prof products c c' = c.value - c'.value := by
  unfold accumulatorShift
  rw [hc, hc']
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-804334e6bcfbdb8f"></a>

<details>
<summary><code>TensorCore.construction_not_monotone</code></summary>

[Lean source](../../../TensorCore/TC/Flowback.lean#L253)

```lean
/-- Theorem III.4 as a failure of Definition III.2: the construction's products are not
monotone in the accumulator input once `K ≥ 3·2^p`. -/
theorem construction_not_monotone (prof : Profile) (p K : ℕ) (da db : Decoded)
    (hF : prof.alignFraction = 23 + p) (hfl : ∀ f ∈ prof.alignFloor, f ≤ -1)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hK : K < 2 ^ (24 + p)) (hthr : 3 * 2 ^ p ≤ K) :
    ¬ MonotoneInAccumulator prof (List.replicate K (da, db)) := by
  intro hmono
  obtain ⟨t, t', h, h', hv, hiff⟩ :=
    nonmonotone_perturbation prof p K da db hF hfl hval hscale hK
  have hlt : belowOneDecoded.value < oneDecoded.value := by decide +kernel
  have := hmono oneDecoded belowOneDecoded t t' h h' hlt
  have h1 := hiff.mpr hthr
  rw [hv] at this
  grind
```

**Supporting proofs:** [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.belowOneDecoded](Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.oneDecoded](Monotonicity.md#decl-8451c87f719a4189), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.v100_products_not_monotone](../Tests/EFT/Flowback.md#decl-725fd4d619d07b0f)

</details>

</details>
