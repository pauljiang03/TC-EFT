# TensorCore.TC.Monotonicity

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-8451c87f719a4189"></a>

<details>
<summary><code>TensorCore.oneDecoded</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L12)

```lean
def oneDecoded : Decoded := ⟨8388608, 0, 23⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350)

<details>
<summary>Used by</summary>

[TensorCore.Regression.flowback_without_increase](../EFT/Regression/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.v100_witness_flowback](../EFT/Regression/Flowback.md#decl-d132256d0746be26), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.oneDecoded_value](Monotonicity.md#decl-db6b73ea3b1ff42e)

</details>

</details>

<a id="decl-7f145f1d885aa020"></a>

<details>
<summary><code>TensorCore.belowOneDecoded</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L13)

```lean
def belowOneDecoded : Decoded := ⟨16777215, -1, 23⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350)

<details>
<summary>Used by</summary>

[TensorCore.Regression.flowback_without_increase](../EFT/Regression/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.v100_witness_flowback](../EFT/Regression/Flowback.md#decl-d132256d0746be26), [TensorCore.belowDecoded_one](MonotonicityRange.md#decl-4caa39a5688d3412), [TensorCore.belowOneDecoded_value](Monotonicity.md#decl-48fa61f0bee3fd85), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1)

</details>

</details>

<a id="decl-db6b73ea3b1ff42e"></a>

<details>
<summary><code>TensorCore.oneDecoded_value</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L15)

```lean
theorem oneDecoded_value : oneDecoded.value = 1 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.oneDecoded](Monotonicity.md#decl-8451c87f719a4189)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04)

</details>

</details>

<a id="decl-48fa61f0bee3fd85"></a>

<details>
<summary><code>TensorCore.belowOneDecoded_value</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L16)

```lean
theorem belowOneDecoded_value : belowOneDecoded.value = 16777215 * pow2 (-24) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.belowOneDecoded](Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73)

</details>

</details>

<a id="decl-2bc6cc7079bc2e96"></a>

<details>
<summary><code>TensorCore.construction_eta</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L21)

```lean
/-- The alignment exponent of the construction is the accumulator input's raw scale when
every product's raw scale is at most that value. -/
theorem construction_eta (prof : Profile) (K : ℕ) (da db c : Decoded)
    (hc : c.significand ≠ 0) (_hu : (rawMul da db).significand ≠ 0)
    (hs : (rawMul da db).rawScale ≤ c.rawScale) (hfl : ∀ f ∈ prof.alignFloor, f ≤ c.rawScale) :
    (PreparedBlock.mk prof (List.replicate K (da, db)) c).eta = some c.rawScale := by
  have hterms : (PreparedBlock.mk prof (List.replicate K (da, db)) c).terms =
      ⟨c.significand, c.rawScale, c.fractionalBits⟩ :: List.replicate K (rawMul da db) := by
    simp [PreparedBlock.terms, List.map_replicate]
  have hmem : (⟨c.significand, c.rawScale, c.fractionalBits⟩ : RawProduct) ∈
      (PreparedBlock.mk prof (List.replicate K (da, db)) c).terms := by
    rw [hterms]; simp
  obtain ⟨e, he, hle⟩ := alignmentScale_term _ _ hmem hc
  have hle' : c.rawScale ≤ e := hle
  have hup := alignmentScale_upper (PreparedBlock.mk prof (List.replicate K (da, db)) c).terms
    c.rawScale (by
      intro t ht _
      rw [hterms] at ht
      simp only [List.mem_cons, List.mem_replicate] at ht
      rcases ht with rfl | ⟨_, rfl⟩
      · exact Int.le_refl _
      · exact hs) e (by rw [he]; simp)
  have heq : e = c.rawScale := by omega
  subst heq
  unfold PreparedBlock.eta
  rw [he]
  show prof.applyFloor (some c.rawScale) = some c.rawScale
  unfold Profile.applyFloor
  cases hf : prof.alignFloor with
  | none => rfl
  | some f =>
    have := hfl f (by rw [hf]; simp)
    simp [Int.max_eq_left this]
```

**Supporting proofs:** [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6), [TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00)

</details>

</details>

<a id="decl-0e4d12d646a70bc9"></a>

<details>
<summary><code>TensorCore.rawMul_significand_ne_zero</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L53)

```lean
theorem rawMul_significand_ne_zero (da db : Decoded) (p : ℕ)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) : (rawMul da db).significand ≠ 0 := by
  intro h
  unfold RawProduct.value at hval
  rw [h] at hval
  have := pow2_pos (-(24 + p))
  simp at hval
  grind
```

**Supporting proofs:** [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00)

</details>

</details>

<a id="decl-04cdce600f593f04"></a>

<details>
<summary><code>TensorCore.construction_accumulator_one</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L63)

```lean
/-- Accumulator with `c = 1`: every product truncates to zero. -/
theorem construction_accumulator_one (prof : Profile) (p K : ℕ) (da db : Decoded)
    (hF : prof.alignFraction = 23 + p) (hfl : ∀ f ∈ prof.alignFloor, f ≤ -1)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1) :
    (PreparedBlock.mk prof (List.replicate K (da, db)) oneDecoded).accumulator = 1 := by
  have hu := rawMul_significand_ne_zero da db p hval
  have heta := construction_eta prof K da db oneDecoded (by decide) hu
    (by change (rawMul da db).rawScale ≤ 0; omega)
    (by intro f hf; have := hfl f hf; change f ≤ 0; omega)
  have hq : (PreparedBlock.mk prof (List.replicate K (da, db)) oneDecoded).quantumExponent =
      -(23 + p) := by
    unfold PreparedBlock.quantumExponent
    rw [heta]
    change oneDecoded.rawScale - prof.alignFraction = _
    rw [hF]
    simp only [oneDecoded]
    omega
  have hcoef := construction_coefficients prof K da db oneDecoded
  rw [hq] at hcoef
  have hc : truncCoeff oneDecoded.value (-(23 + p)) = ((2 ^ (23 + p) : ℕ) : ℤ) := by
    rw [oneDecoded_value]
    have h1 : (1 : ℚ) = (((2 ^ (23 + p) : ℕ) : ℤ) : ℚ) * pow2 (-(23 + p)) := by
      rw [Rat.intCast_natCast, ← pow2_natCast, ← pow2_add]
      have : ((23 + p : ℕ) : ℤ) + -(23 + p) = 0 := by omega
      rw [this, pow2_zero]
    rw [h1, truncCoeff_of_grid]
  have hp : truncCoeff (rawMul da db).value (-(23 + p)) = 0 := by
    rw [hval]
    unfold truncCoeff
    have hpos := pow2_pos (-(24 + p))
    rw [if_neg (by grind), pow2_div]
    have : (-(24 + p) : ℤ) - -(23 + p) = -1 := by omega
    rw [this]
    decide +kernel
  unfold PreparedBlock.accumulator
  rw [hcoef, hq]
  simp only [sumZ, hc, hp, sumZ_replicate, Int.mul_zero, Int.add_zero]
  rw [Rat.intCast_natCast, ← pow2_natCast, ← pow2_add]
  have : ((23 + p : ℕ) : ℤ) + -(23 + p) = 0 := by omega
  rw [this, pow2_zero]
```

**Supporting proofs:** [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.oneDecoded_value](Monotonicity.md#decl-db6b73ea3b1ff42e), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_div](../Core/Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.pow2_zero](../Core/Exact.md#decl-ac9c8646649b0ae0), [TensorCore.rawMul_significand_ne_zero](Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.sumZ_replicate](../Core/Sum.md#decl-515e106ddee189db), [TensorCore.truncCoeff_of_grid](../Core/Truncation.md#decl-03b847921a9aec6d)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.oneDecoded](Monotonicity.md#decl-8451c87f719a4189), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff), [TensorCore.truncCoeff](../Core/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1)

</details>

</details>

<a id="decl-e5161ec0a85d5b73"></a>

<details>
<summary><code>TensorCore.construction_accumulator_below</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L104)

```lean
/-- Accumulator with `c' = 1 − 2^-24`: every product is retained. -/
theorem construction_accumulator_below (prof : Profile) (p K : ℕ) (da db : Decoded)
    (hF : prof.alignFraction = 23 + p) (hfl : ∀ f ∈ prof.alignFloor, f ≤ -1)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1) :
    (PreparedBlock.mk prof (List.replicate K (da, db)) belowOneDecoded).accumulator =
      ((16777215 * 2 ^ p + K : ℕ) : ℚ) * pow2 (-(24 + p)) := by
  have hu := rawMul_significand_ne_zero da db p hval
  have heta := construction_eta prof K da db belowOneDecoded (by decide) hu hscale hfl
  have hq : (PreparedBlock.mk prof (List.replicate K (da, db)) belowOneDecoded).quantumExponent =
      -(24 + p) := by
    unfold PreparedBlock.quantumExponent
    rw [heta]
    change belowOneDecoded.rawScale - prof.alignFraction = _
    rw [hF]
    simp only [belowOneDecoded]
    omega
  have hcoef := construction_coefficients prof K da db belowOneDecoded
  rw [hq] at hcoef
  have hc : truncCoeff belowOneDecoded.value (-(24 + p)) = ((16777215 * 2 ^ p : ℕ) : ℤ) := by
    rw [belowOneDecoded_value]
    have h1 : (16777215 : ℚ) * pow2 (-24) =
        (((16777215 * 2 ^ p : ℕ) : ℤ) : ℚ) * pow2 (-(24 + p)) := by
      rw [Rat.intCast_natCast, Rat.natCast_mul, ← pow2_natCast, Rat.mul_assoc, ← pow2_add]
      have : (p : ℤ) + -(24 + p) = -24 := by omega
      rw [this]
      all_goals simp
    rw [h1, truncCoeff_of_grid]
  have hp : truncCoeff (rawMul da db).value (-(24 + p)) = 1 := by
    rw [hval]
    have h1 : pow2 (-(24 + p)) = ((1 : ℤ) : ℚ) * pow2 (-(24 + p)) := by simp
    rw [h1, truncCoeff_of_grid]
  unfold PreparedBlock.accumulator
  rw [hcoef, hq]
  simp only [sumZ, hc, hp, sumZ_replicate, Int.mul_one]
  congr 1
  all_goals rw [Rat.intCast_add, Rat.intCast_natCast, Rat.intCast_natCast, Rat.natCast_add]
```

**Supporting proofs:** [TensorCore.belowOneDecoded_value](Monotonicity.md#decl-48fa61f0bee3fd85), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.rawMul_significand_ne_zero](Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.sumZ_replicate](../Core/Sum.md#decl-515e106ddee189db), [TensorCore.truncCoeff_of_grid](../Core/Truncation.md#decl-03b847921a9aec6d)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.belowOneDecoded](Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff), [TensorCore.truncCoeff](../Core/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1)

</details>

</details>

<a id="decl-c02a591e005269f1"></a>

<details>
<summary><code>TensorCore.nonmonotone_perturbation</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L144)

```lean
/-- TC-EFT Theorem III.4. For any profile with `F = 23 + p`, a floor at most `−1`, and
`K < 2^(24+p)` equal products of value `2^-(24+p)` with raw scale at most `−1`: the block
with `c = 1` returns `1`, and the block with `c' = 1 − 2^-24` returns more than `1` exactly
when `K ≥ 3·2^p`. -/
theorem nonmonotone_perturbation (prof : Profile) (p K : ℕ) (da db : Decoded)
    (hF : prof.alignFraction = 23 + p) (hfl : ∀ f ∈ prof.alignFloor, f ≤ -1)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hK : K < 2 ^ (24 + p)) :
    ∃ t t' : BlockTrace,
      evalPrepared ⟨prof, List.replicate K (da, db), oneDecoded⟩ = .ok t ∧
      evalPrepared ⟨prof, List.replicate K (da, db), belowOneDecoded⟩ = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ p ≤ K) := by
  have hA1 := construction_accumulator_one prof p K da db hF hfl hval hscale
  have hA2 := construction_accumulator_below prof p K da db hF hfl hval hscale
  have hr1 : round32 .towardZero 1 = some (BitVec.ofNat 32 0x3f800000) := by decide +kernel
  have hv1 : value32 (BitVec.ofNat 32 0x3f800000) = some 1 := by decide +kernel
  obtain ⟨f1, hf1, _, hf1v⟩ := finite32_of_value32 _ _ hv1
  have hq := pow2_pos (-(24 + p))
  have h2p24 : 2 ^ (24 + p) = 16777216 * 2 ^ p := by
    rw [Nat.pow_add]
    all_goals simp
  have hPpos := Nat.two_pow_pos p
  generalize hN : 16777215 * 2 ^ p + K = N at hA2
  generalize hA : (N : ℚ) * pow2 (-(24 + p)) = A at hA2
  have hNpos : (0 : ℚ) < (N : ℚ) := Rat.natCast_pos.mpr (by omega)
  have hApos : 0 < A := by
    rw [← hA]
    have := Rat.mul_lt_mul_of_pos_right hNpos hq
    simpa using this
  have hA2lt : A < 2 := by
    rw [← hA]
    have hlt : (N : ℚ) < ((2 ^ (25 + p) : ℕ) : ℚ) := by
      apply Rat.natCast_lt_natCast.mpr
      have h1 : 2 ^ (25 + p) = 2 * (16777216 * 2 ^ p) := by
        rw [show 25 + p = 1 + (24 + p) by omega, Nat.pow_add, Nat.pow_add]
        all_goals simp
      omega
    have := Rat.mul_lt_mul_of_pos_right hlt hq
    rw [← pow2_natCast, ← pow2_add] at this
    have h25 : ((25 + p : ℕ) : ℤ) + -(24 + p) = 1 := by omega
    rw [h25, pow2_one] at this
    exact this
  have hrange : absQ A ≤ maxFinite32 := by
    rw [absQ_of_nonneg (Rat.le_of_lt hApos)]
    have : (2 : ℚ) ≤ maxFinite32 := by decide +kernel
    grind
  obtain ⟨b2, hb2, hv2, _, _⟩ := round32_nonzero_spec .towardZero A (Rat.ne_of_gt hApos) hrange
  obtain ⟨f2, hf2, _, hf2v⟩ := finite32_of_value32 _ _ hv2
  refine ⟨⟨⟨prof, List.replicate K (da, db), oneDecoded⟩, f1⟩,
    ⟨⟨prof, List.replicate K (da, db), belowOneDecoded⟩, f2⟩, ?_, ?_, hf1v, ?_⟩
  · simp only [evalPrepared, hA1, hr1, hf1]
  · simp only [evalPrepared, hA2, hb2, hf2]
  · change 1 < f2.value ↔ _
    rw [hf2v]
    unfold signedRounded
    rw [if_neg (by grind), absQ_of_nonneg (Rat.le_of_lt hApos)]
    unfold magnitudeRounded convCoeff roundCoefficient
    dsimp only
    by_cases hKp : K < 2 ^ p
    · have hAlt : A < 1 := by
        rw [← hA]
        have hlt : (N : ℚ) < ((2 ^ (24 + p) : ℕ) : ℚ) := by
          apply Rat.natCast_lt_natCast.mpr
          omega
        have := Rat.mul_lt_mul_of_pos_right hlt hq
        rw [← pow2_natCast, ← pow2_add] at this
        have h24 : ((24 + p : ℕ) : ℤ) + -(24 + p) = 0 := by omega
        rw [h24, pow2_zero] at this
        exact this
      have hqe := pow2_pos (convExp A - 23)
      have hle : (((A / pow2 (convExp A - 23)).floor : ℤ) : ℚ) * pow2 (convExp A - 23) ≤ A := by
        have := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (A / pow2 (convExp A - 23)))
          (Rat.le_of_lt hqe)
        rwa [Rat.div_mul_cancel (Rat.ne_of_gt hqe)] at this
      constructor
      · intro h; exfalso; grind
      · intro h; exfalso; omega
    · have hAge : 1 ≤ A := by
        rw [← hA]
        have hle : ((2 ^ (24 + p) : ℕ) : ℚ) ≤ (N : ℚ) := by
          apply Rat.natCast_le_natCast.mpr
          omega
        have := Rat.mul_le_mul_of_nonneg_right hle (Rat.le_of_lt hq)
        rw [← pow2_natCast, ← pow2_add] at this
        have h24 : ((24 + p : ℕ) : ℤ) + -(24 + p) = 0 := by omega
        rw [h24, pow2_zero] at this
        exact this
      have hexp : convExp A = 0 := by
        unfold convExp emin32
        rw [magnitudeExponent_eq_of_bounds A 0 (by rw [pow2_zero]; exact hAge)
          (by rw [show (0 : ℤ) + 1 = 1 by omega, pow2_one]; exact hA2lt)]
        decide
      rw [hexp]
      simp only [Int.zero_sub]
      rw [div_pow2, Int.neg_neg]
      have hA23 : A * pow2 23 = (N : ℚ) * pow2 (-(1 + p)) := by
        rw [← hA, Rat.mul_assoc, ← pow2_add]
        congr 2
        omega
      rw [hA23]
      have hq1 := pow2_pos (-(1 + p))
      have hq23 := pow2_pos (-23)
      have hcmp : ∀ m : ℤ, (1 < (m : ℚ) * pow2 (-23) ↔ 8388608 < m) := by
        intro m
        have h1 : (1 : ℚ) = ((8388608 : ℤ) : ℚ) * pow2 (-23) := by decide +kernel
        rw [h1, Rat.mul_lt_mul_right hq23]
        exact Rat.intCast_lt_intCast
      rw [hcmp]
      have hfloor : (8388608 < ((N : ℚ) * pow2 (-(1 + p))).floor) ↔
          ((8388609 : ℤ) : ℚ) * pow2 ((1 + p : ℕ) : ℤ) ≤ (N : ℚ) := by
        rw [Int.lt_iff_add_one_le, Rat.le_floor_iff]
        have hz : -(1 + (p : ℤ)) + ((1 + p : ℕ) : ℤ) = 0 := by omega
        have hz' : ((1 + p : ℕ) : ℤ) + -(1 + (p : ℤ)) = 0 := by omega
        constructor
        · intro h
          have := Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt (pow2_pos ((1 + p : ℕ) : ℤ)))
          rw [Rat.mul_assoc, ← pow2_add, hz, pow2_zero, Rat.mul_one] at this
          exact this
        · intro h
          have := Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt hq1)
          rw [Rat.mul_assoc, ← pow2_add, hz', pow2_zero, Rat.mul_one] at this
          exact this
      rw [hfloor]
      have hcast : ((8388609 : ℤ) : ℚ) * pow2 ((1 + p : ℕ) : ℤ) =
          ((8388609 * 2 ^ (1 + p) : ℕ) : ℚ) := by
        rw [pow2_natCast, Rat.natCast_mul]
        simp
      rw [hcast, Rat.natCast_le_natCast]
      have h2p : 2 ^ (1 + p) = 2 * 2 ^ p := by
        rw [Nat.pow_add]
        all_goals simp
      subst hN
      rw [h2p]
      constructor
      · intro h; omega
      · intro h; omega
```

**Supporting proofs:** [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.div_pow2](../Core/Exact.md#decl-341a7e90774bc1d1), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.magnitudeExponent_eq_of_bounds](../Core/Rounding.md#decl-bf009f29f695c88d), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_one](../Core/Exact.md#decl-8feaca6c2e8345f1), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.pow2_zero](../Core/Exact.md#decl-ac9c8646649b0ae0), [TensorCore.round32_nonzero_spec](../Core/CorrectRounding.md#decl-8b6b01a970bf7f64)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.belowOneDecoded](Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.convCoeff](../Core/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](../Core/RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.magnitudeRounded](../Core/RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.oneDecoded](Monotonicity.md#decl-8451c87f719a4189), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundCoefficient](../Core/RoundOp.md#decl-7662cf06d1725fc5), [TensorCore.signedRounded](../Core/RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f)

</details>

</details>

<a id="decl-7c6c5b1d9751b04f"></a>

<details>
<summary><code>TensorCore.nonmonotone_encoded</code></summary>

[Lean source](../../../TensorCore/TC/Monotonicity.lean#L280)

```lean
/-- The construction on encoded FP16 operands under any canonical profile: `K` copies of
one factor pair whose raw product is `2^-(24+p)` with raw scale at most `−1`, and the two
FP32 accumulator inputs `3f800000` and `3f7fffff`. -/
theorem nonmonotone_encoded (K p : ℕ) (floor : Option ℤ) (hfl : ∀ f ∈ floor, f ≤ -1)
    (a b : (fp16Fp32Profile K p floor).Word) (da db : Decoded)
    (ha : (fp16Fp32Profile K p floor).decode a = some da)
    (hb : (fp16Fp32Profile K p floor).decode b = some db)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hK : K < 2 ^ (24 + p)) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (a, b), 0x3f800000⟩ : BlockInput (fp16Fp32Profile K p floor)) =
        .ok t ∧
      evalBlock (⟨List.replicate K (a, b), 0x3f7fffff⟩ : BlockInput (fp16Fp32Profile K p floor)) =
        .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ p ≤ K) := by
  have hF : (fp16Fp32Profile K p floor).alignFraction = 23 + p := by
    show ((23 + p : ℕ) : ℤ) = 23 + (p : ℤ)
    omega
  obtain ⟨t, t', h1, h2, hv, hiff⟩ :=
    nonmonotone_perturbation (fp16Fp32Profile K p floor) p K da db hF hfl hval hscale hK
  have hc1 : decode32 (0x3f800000 : F32) = some oneDecoded := by decide +kernel
  have hc2 : decode32 (0x3f7fffff : F32) = some belowOneDecoded := by decide +kernel
  have hps := prepareProducts_replicate _ a b da db K ha hb
  have hlen : ¬ ((List.replicate K (a, b)).length != (fp16Fp32Profile K p floor).products) = true := by
    simp [fp16Fp32Profile]
  refine ⟨t, t', ?_, ?_, hv, hiff⟩
  · unfold evalBlock
    rw [if_neg hlen]
    simp only [prepare, hc1, hps]
    exact h1
  · unfold evalBlock
    rw [if_neg hlen]
    simp only [prepare, hc2, hps]
    exact h2
```

**Supporting proofs:** [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.prepareProducts_replicate](Block.md#decl-3ef93e2d1a862b59)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.belowOneDecoded](Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.oneDecoded](Monotonicity.md#decl-8451c87f719a4189), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_ampere_family](Regression/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_hopper_family](Regression/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_v100_family](Regression/Monotonicity.md#decl-06e754610d570873)

</details>

</details>
