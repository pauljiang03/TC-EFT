# TensorCore.TC.MonotonicityRange

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-690eb856a27a1d7c"></a>

<details>
<summary><code>TensorCore.belowDecoded</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L12)

```lean
/-- `c_j = 1 − j·2^-24` in decoded form: significand `2^24 − j` on raw scale `−1`. -/
def belowDecoded (j : ℕ) : Decoded := ⟨((16777216 - j : ℕ) : ℤ), -1, 23⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350)

<details>
<summary>Used by</summary>

[TensorCore.belowDecoded_one](MonotonicityRange.md#decl-4caa39a5688d3412), [TensorCore.belowDecoded_value](MonotonicityRange.md#decl-5392c153e1597baf), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.decode32_below](MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38)

</details>

</details>

<a id="decl-4caa39a5688d3412"></a>

<details>
<summary><code>TensorCore.belowDecoded_one</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L14)

```lean
theorem belowDecoded_one : belowDecoded 1 = belowOneDecoded := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.belowDecoded](MonotonicityRange.md#decl-690eb856a27a1d7c), [TensorCore.belowOneDecoded](Monotonicity.md#decl-7f145f1d885aa020)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5392c153e1597baf"></a>

<details>
<summary><code>TensorCore.belowDecoded_value</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L16)

```lean
theorem belowDecoded_value (j : ℕ) (hj : j ≤ 16777216) :
    (belowDecoded j).value = 1 - (j : ℚ) * pow2 (-24) := by
  have h : ((16777216 - j : ℕ) : ℚ) + (j : ℚ) = ((16777216 : ℕ) : ℚ) := by
    rw [← Rat.natCast_add, Nat.sub_add_cancel hj]
  have h24 : ((16777216 : ℕ) : ℚ) * pow2 (-24) = 1 := by decide +kernel
  show (((16777216 - j : ℕ) : ℤ) : ℚ) * pow2 (-1 - 23) = _
  rw [Rat.intCast_natCast, show (-1 - 23 : ℤ) = -24 by decide]
  grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.belowDecoded](MonotonicityRange.md#decl-690eb856a27a1d7c), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8ed3e1baf1df681b"></a>

<details>
<summary><code>TensorCore.floor_eq_of_bounds</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L25)

```lean
theorem floor_eq_of_bounds (x : ℚ) (z : ℤ) (h1 : (z : ℚ) ≤ x) (h2 : x < (z : ℚ) + 1) :
    x.floor = z := by
  have a : z ≤ x.floor := Rat.le_floor_iff.mpr h1
  have b : x.floor < z + 1 := Rat.floor_lt_iff.mpr (by rw [Rat.intCast_add, Rat.intCast_one]; exact h2)
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.floor_natCast_mul_pow2_neg](MonotonicityRange.md#decl-1f5df0d5f93e1feb)

</details>

</details>

<a id="decl-1f5df0d5f93e1feb"></a>

<details>
<summary><code>TensorCore.floor_natCast_mul_pow2_neg</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L32)

```lean
/-- The floor of a natural number scaled by `2^-d` is its quotient by `2^d`. -/
theorem floor_natCast_mul_pow2_neg (N d : ℕ) :
    ((N : ℚ) * pow2 (-(d : ℤ))).floor = ((N / 2 ^ d : ℕ) : ℤ) := by
  have hnd := pow2_pos (-(d : ℤ))
  have hcancel : pow2 (d : ℤ) * pow2 (-(d : ℤ)) = 1 := by
    rw [← pow2_add]
    have : (d : ℤ) + -(d : ℤ) = 0 := by omega
    rw [this, pow2_zero]
  apply floor_eq_of_bounds
  · have h : ((N / 2 ^ d * 2 ^ d : ℕ) : ℚ) ≤ (N : ℚ) :=
      Rat.natCast_le_natCast.mpr (Nat.div_mul_le_self N (2 ^ d))
    have := Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt hnd)
    rw [Rat.natCast_mul, ← pow2_natCast, Rat.mul_assoc, hcancel, Rat.mul_one] at this
    rw [Rat.intCast_natCast]
    exact this
  · have h : (N : ℚ) < ((2 ^ d * (N / 2 ^ d + 1) : ℕ) : ℚ) :=
      Rat.natCast_lt_natCast.mpr (Nat.lt_mul_div_succ N (Nat.two_pow_pos d))
    have := Rat.mul_lt_mul_of_pos_right h hnd
    rw [Rat.natCast_mul, ← pow2_natCast, Rat.mul_comm (pow2 _), Rat.mul_assoc, hcancel,
      Rat.mul_one, Rat.natCast_add] at this
    rw [Rat.intCast_natCast]
    simpa using this
```

**Supporting proofs:** [TensorCore.floor_eq_of_bounds](MonotonicityRange.md#decl-8ed3e1baf1df681b), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.pow2_zero](../Core/Exact.md#decl-ac9c8646649b0ae0)

**Definitions and types:** [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4)

</details>

</details>

<a id="decl-d9208cfa13b8ff00"></a>

<details>
<summary><code>TensorCore.construction_accumulator_range</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L56)

```lean
/-- Accumulator with `c_j`: every product is retained and `A_j = 1 + (K − j·2^p)·2^-(24+p)`,
written as a natural coefficient on the grid `2^-(24+p)`. -/
theorem construction_accumulator_range (prof : Profile) (p K j : ℕ) (da db : Decoded)
    (hF : prof.alignFraction = 23 + p) (hfl : ∀ f ∈ prof.alignFloor, f ≤ -1)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hj : j ≤ 2 ^ 23) :
    (PreparedBlock.mk prof (List.replicate K (da, db)) (belowDecoded j)).accumulator =
      (((16777216 - j) * 2 ^ p + K : ℕ) : ℚ) * pow2 (-(24 + p)) := by
  have hu := rawMul_significand_ne_zero da db p hval
  have hsig : (belowDecoded j).significand ≠ 0 := by
    show ((16777216 - j : ℕ) : ℤ) ≠ 0
    omega
  have heta := construction_eta prof K da db (belowDecoded j) hsig hu hscale hfl
  have hq : (PreparedBlock.mk prof (List.replicate K (da, db)) (belowDecoded j)).quantumExponent =
      -(24 + p) := by
    unfold PreparedBlock.quantumExponent
    rw [heta]
    change (belowDecoded j).rawScale - prof.alignFraction = _
    rw [hF]
    simp only [belowDecoded]
    omega
  have hcoef := construction_coefficients prof K da db (belowDecoded j)
  rw [hq] at hcoef
  have hc : truncCoeff (belowDecoded j).value (-(24 + p)) =
      (((16777216 - j) * 2 ^ p : ℕ) : ℤ) := by
    have h1 : (belowDecoded j).value =
        ((((16777216 - j) * 2 ^ p : ℕ) : ℤ) : ℚ) * pow2 (-(24 + p)) := by
      show (((16777216 - j : ℕ) : ℤ) : ℚ) * pow2 (-1 - 23) = _
      rw [Rat.intCast_natCast, Rat.intCast_natCast, Rat.natCast_mul, ← pow2_natCast,
        Rat.mul_assoc, ← pow2_add]
      congr 2
      omega
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

**Supporting proofs:** [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.rawMul_significand_ne_zero](Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.sumZ_replicate](../Core/Sum.md#decl-515e106ddee189db), [TensorCore.truncCoeff_of_grid](../Core/Truncation.md#decl-03b847921a9aec6d)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.belowDecoded](MonotonicityRange.md#decl-690eb856a27a1d7c), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff), [TensorCore.truncCoeff](../Core/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4)

</details>

</details>

<a id="decl-d5c8fadfda678cb4"></a>

<details>
<summary><code>TensorCore.nonmonotone_range</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L102)

```lean
/-- TC-EFT Theorem III.5 on prepared blocks. For any profile with `F = 23 + p`, a floor at
most `−1`, `K < 2^(24+p)` equal products of value `2^-(24+p)` with raw scale at most `−1`,
and `1 ≤ j ≤ 2^23`: the block with `c_j = 1 − j·2^-24` returns more than `1` exactly when
`(j + 2)·2^p ≤ K`; when `j·2^p ≤ K` its output is `1 + 2^-23·⌊(K − j·2^p)/2^(p+1)⌋`; and
its output never exceeds `1 + 2^-23·⌊(K − 2^p)/2^(p+1)⌋`, the value at `j = 1`. -/
theorem nonmonotone_range (prof : Profile) (p K j : ℕ) (da db : Decoded)
    (hF : prof.alignFraction = 23 + p) (hfl : ∀ f ∈ prof.alignFloor, f ≤ -1)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hK : K < 2 ^ (24 + p)) (hj1 : 1 ≤ j) (hj2 : j ≤ 2 ^ 23) :
    ∃ t : BlockTrace,
      evalPrepared ⟨prof, List.replicate K (da, db), belowDecoded j⟩ = .ok t ∧
      (1 < t.output.value ↔ (j + 2) * 2 ^ p ≤ K) ∧
      (j * 2 ^ p ≤ K →
        t.output.value = 1 + (((K - j * 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23)) ∧
      t.output.value ≤ 1 + (((K - 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23) := by
  have hA := construction_accumulator_range prof p K j da db hF hfl hval hscale hj2
  have hq := pow2_pos (-(24 + p))
  have hq23 := pow2_pos (-23)
  have hPpos := Nat.two_pow_pos p
  have h2p24 : 2 ^ (24 + p) = 16777216 * 2 ^ p := by
    rw [Nat.pow_add]
    all_goals simp
  have h2p25 : 2 ^ (25 + p) = 2 * (16777216 * 2 ^ p) := by
    rw [show 25 + p = 1 + (24 + p) by omega, Nat.pow_add, Nat.pow_add]
    all_goals simp
  have h2p1 : 2 ^ (p + 1) = 2 ^ p * 2 := Nat.pow_succ 2 p
  have hjP : j * 2 ^ p ≤ 8388608 * 2 ^ p := Nat.mul_le_mul_right _ hj2
  have hjP1 : 2 ^ p ≤ j * 2 ^ p := by
    have := Nat.mul_le_mul_right (2 ^ p) hj1
    simpa using this
  have hsub : (16777216 - j) * 2 ^ p = 16777216 * 2 ^ p - j * 2 ^ p := Nat.sub_mul _ _ _
  have hM : ∀ m : ℕ, (0 : ℚ) ≤ (m : ℚ) * pow2 (-23) := fun m =>
    Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt hq23)
  have hMle : (K - j * 2 ^ p) / 2 ^ (p + 1) ≤ (K - 2 ^ p) / 2 ^ (p + 1) :=
    Nat.div_le_div_right (Nat.sub_le_sub_left hjP1 K)
  have hMle' : (((K - j * 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23) ≤
      (((K - 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23) :=
    Rat.mul_le_mul_of_nonneg_right (Rat.natCast_le_natCast.mpr hMle) (Rat.le_of_lt hq23)
  generalize hN : (16777216 - j) * 2 ^ p + K = N at hA
  generalize hA' : (N : ℚ) * pow2 (-(24 + p)) = A at hA
  have hNpos : (0 : ℚ) < (N : ℚ) := Rat.natCast_pos.mpr (by omega)
  have hApos : 0 < A := by
    rw [← hA']
    have := Rat.mul_lt_mul_of_pos_right hNpos hq
    simpa using this
  have hA2lt : A < 2 := by
    rw [← hA']
    have hlt : (N : ℚ) < ((2 ^ (25 + p) : ℕ) : ℚ) := by
      apply Rat.natCast_lt_natCast.mpr
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
  obtain ⟨b, hb, hv, _, _⟩ := round32_nonzero_spec .towardZero A (Rat.ne_of_gt hApos) hrange
  obtain ⟨f, hf, _, hfv⟩ := finite32_of_value32 _ _ hv
  refine ⟨⟨⟨prof, List.replicate K (da, db), belowDecoded j⟩, f⟩, ?_, ?_⟩
  · simp only [evalPrepared, hA, hb, hf]
  · change (1 < f.value ↔ _) ∧ (_ → f.value = _) ∧ f.value ≤ _
    rw [hfv]
    unfold signedRounded
    rw [if_neg (by grind), absQ_of_nonneg (Rat.le_of_lt hApos)]
    unfold magnitudeRounded convCoeff roundCoefficient
    dsimp only
    by_cases hjK : j * 2 ^ p ≤ K
    · have hAge : 1 ≤ A := by
        rw [← hA']
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
      have hA23 : A * pow2 23 = (N : ℚ) * pow2 (-((1 + p : ℕ) : ℤ)) := by
        rw [← hA', Rat.mul_assoc, ← pow2_add]
        congr 2
        omega
      rw [hA23, floor_natCast_mul_pow2_neg]
      have hdiv : N / 2 ^ (1 + p) = 8388608 + (K - j * 2 ^ p) / 2 ^ (p + 1) := by
        have h1 : N = 2 ^ (p + 1) * 8388608 + (K - j * 2 ^ p) := by
          rw [h2p1]
          omega
        rw [Nat.add_comm 1 p, h1, Nat.mul_add_div (Nat.two_pow_pos _)]
      rw [hdiv]
      have hval' : (((8388608 + (K - j * 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℤ) : ℚ) * pow2 (-23) =
          1 + (((K - j * 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23) := by
        rw [Rat.intCast_natCast, Rat.natCast_add, Rat.add_mul]
        have : ((8388608 : ℕ) : ℚ) * pow2 (-23) = 1 := by decide +kernel
        rw [this]
      refine ⟨?_, fun _ => hval', ?_⟩
      · rw [hval']
        have hpos : 1 ≤ (K - j * 2 ^ p) / 2 ^ (p + 1) ↔ 1 * 2 ^ (p + 1) ≤ K - j * 2 ^ p :=
          Nat.le_div_iff_mul_le (Nat.two_pow_pos _)
        generalize hm : (K - j * 2 ^ p) / 2 ^ (p + 1) = m at hpos
        constructor
        · intro h
          have h1 : 1 ≤ m := by
            rcases Nat.eq_zero_or_pos m with hm0 | hm0
            · subst hm0
              have h0 : ((0 : ℕ) : ℚ) * pow2 (-23) = 0 := by simp
              rw [h0, Rat.add_zero] at h
              exact absurd h Rat.lt_irrefl
            · exact hm0
          rw [Nat.add_mul]
          omega
        · intro h
          rw [Nat.add_mul] at h
          have h1 : 1 ≤ m := hpos.mpr (by omega)
          have : (1 : ℚ) ≤ (m : ℚ) := by
            have := Rat.natCast_le_natCast.mpr h1
            simpa using this
          have := Rat.mul_le_mul_of_nonneg_right this (Rat.le_of_lt hq23)
          rw [Rat.one_mul] at this
          grind
      · rw [hval']
        grind
    · have hAlt : A < 1 := by
        rw [← hA']
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
      refine ⟨⟨fun h => ?_, fun h => ?_⟩, fun h => absurd h hjK, ?_⟩
      · exfalso; grind
      · exfalso; rw [Nat.add_mul] at h; omega
      · have := hM ((K - 2 ^ p) / 2 ^ (p + 1))
        grind
```

**Supporting proofs:** [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.div_pow2](../Core/Exact.md#decl-341a7e90774bc1d1), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.floor_natCast_mul_pow2_neg](MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.magnitudeExponent_eq_of_bounds](../Core/Rounding.md#decl-bf009f29f695c88d), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_one](../Core/Exact.md#decl-8feaca6c2e8345f1), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.pow2_zero](../Core/Exact.md#decl-ac9c8646649b0ae0), [TensorCore.round32_nonzero_spec](../Core/CorrectRounding.md#decl-8b6b01a970bf7f64)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.belowDecoded](MonotonicityRange.md#decl-690eb856a27a1d7c), [TensorCore.convCoeff](../Core/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](../Core/RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.magnitudeRounded](../Core/RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundCoefficient](../Core/RoundOp.md#decl-7662cf06d1725fc5), [TensorCore.signedRounded](../Core/RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38)

</details>

</details>

<a id="decl-a2d2d541bf27443e"></a>

<details>
<summary><code>TensorCore.nonmonotone_range_iff</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L251)

```lean
/-- Equation 9: with `1 ≤ j`, the witness condition `j ≤ 2^23 ∧ (j + 2)·2^p ≤ K` is
`j ≤ min(2^23, ⌊K/2^p⌋ − 2)`. -/
theorem nonmonotone_range_iff (p K j : ℕ) (hj1 : 1 ≤ j) :
    (j ≤ 2 ^ 23 ∧ (j + 2) * 2 ^ p ≤ K) ↔ j ≤ min (2 ^ 23) (K / 2 ^ p - 2) := by
  have h : j + 2 ≤ K / 2 ^ p ↔ (j + 2) * 2 ^ p ≤ K := Nat.le_div_iff_mul_le (Nat.two_pow_pos p)
  rw [← h]
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38)

</details>

</details>

<a id="decl-a811310312b96b08"></a>

<details>
<summary><code>TensorCore.decode32_below</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L258)

```lean
/-- The FP32 encoding `3f800000 − j` decodes to `c_j` for `1 ≤ j ≤ 2^23`. -/
theorem decode32_below (j : ℕ) (hj1 : 1 ≤ j) (hj2 : j ≤ 2 ^ 23) :
    decode32 (BitVec.ofNat 32 (0x3f800000 - j)) = some (belowDecoded j) := by
  rw [decode32_eq, BitVec.toNat_ofNat, classifyNat_fp32]
  have hmod : (0x3f800000 - j) % 2 ^ 32 = 0x3f800000 - j := Nat.mod_eq_of_lt (by omega)
  rw [hmod, if_neg (by omega), if_neg (by omega)]
  have hs : ((0x3f800000 - j) / 2147483648 != 0) = false := by
    have : (0x3f800000 - j) / 2147483648 = 0 := by omega
    rw [this]
    rfl
  simp only [Classification.finite, Option.some.injEq, hs, Bool.false_eq_true, if_false]
  unfold belowDecoded
  congr 1
  · omega
  · omega
```

**Supporting proofs:** [TensorCore.classifyNat_fp32](../Core/EncodingProperties.md#decl-e78f14689117d01e), [TensorCore.decode32_eq](../Core/Encoding.md#decl-d61e64a2750bda68)

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.belowDecoded](MonotonicityRange.md#decl-690eb856a27a1d7c), [TensorCore.classifyNat](../Core/Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38)

</details>

</details>

<a id="decl-25e9827b84766b38"></a>

<details>
<summary><code>TensorCore.nonmonotone_range_encoded</code></summary>

[Lean source](../../../TensorCore/TC/MonotonicityRange.lean#L278)

```lean
/-- Theorem III.5 on encoded FP16 operands under any canonical profile: `K` copies of one
factor pair whose raw product is `2^-(24+p)` with raw scale at most `−1`, and the FP32
accumulator input `3f800000 − j`. The output exceeds `1` exactly for
`1 ≤ j ≤ min(2^23, ⌊K/2^p⌋ − 2)`, equals `1 + 2^-23·⌊(K − j·2^p)/2^(p+1)⌋` whenever
`j·2^p ≤ K`, and never exceeds the `j = 1` value `1 + 2^-23·⌊(K − 2^p)/2^(p+1)⌋`. -/
theorem nonmonotone_range_encoded (K p j : ℕ) (floor : Option ℤ)
    (hfl : ∀ f ∈ floor, f ≤ -1)
    (a b : (fp16Fp32Profile K p floor).Word) (da db : Decoded)
    (ha : (fp16Fp32Profile K p floor).decode a = some da)
    (hb : (fp16Fp32Profile K p floor).decode b = some db)
    (hval : (rawMul da db).value = pow2 (-(24 + p))) (hscale : (rawMul da db).rawScale ≤ -1)
    (hK : K < 2 ^ (24 + p)) (hj1 : 1 ≤ j) (hj2 : j ≤ 2 ^ 23) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (a, b), BitVec.ofNat 32 (0x3f800000 - j)⟩ :
        BlockInput (fp16Fp32Profile K p floor)) = .ok t ∧
      (1 < t.output.value ↔ j ≤ min (2 ^ 23) (K / 2 ^ p - 2)) ∧
      (j * 2 ^ p ≤ K →
        t.output.value = 1 + (((K - j * 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23)) ∧
      t.output.value ≤ 1 + (((K - 2 ^ p) / 2 ^ (p + 1) : ℕ) : ℚ) * pow2 (-23) := by
  have hF : (fp16Fp32Profile K p floor).alignFraction = 23 + p := by
    show ((23 + p : ℕ) : ℤ) = 23 + (p : ℤ)
    omega
  obtain ⟨t, h1, hiff, hform, hbound⟩ :=
    nonmonotone_range (fp16Fp32Profile K p floor) p K j da db hF hfl hval hscale hK hj1 hj2
  have hc := decode32_below j hj1 hj2
  have hps := prepareProducts_replicate _ a b da db K ha hb
  have hlen : ¬ ((List.replicate K (a, b)).length != (fp16Fp32Profile K p floor).products) = true := by
    simp [fp16Fp32Profile]
  refine ⟨t, ?_, ?_, hform, hbound⟩
  · unfold evalBlock
    rw [if_neg hlen]
    simp only [prepare, hc, hps]
    exact h1
  · rw [hiff, ← nonmonotone_range_iff p K j hj1]
    exact ⟨fun h => ⟨hj2, h⟩, fun h => h.2⟩
```

**Supporting proofs:** [TensorCore.decode32_below](MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_iff](MonotonicityRange.md#decl-a2d2d541bf27443e), [TensorCore.prepareProducts_replicate](Block.md#decl-3ef93e2d1a862b59)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.belowDecoded](MonotonicityRange.md#decl-690eb856a27a1d7c), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_range_ampere_family](Regression/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_hopper_family](Regression/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](Regression/Monotonicity.md#decl-28d0c042c0f25900)

</details>

</details>
