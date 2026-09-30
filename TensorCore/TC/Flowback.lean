import TensorCore.TC.Monotonicity
import TensorCore.Numerics.RoundTrip
import TensorCore.Numerics.ScalarSum
import TensorCore.TC.ErrorBounds

/-! TC-EFT Definitions III.2 and III.3 and Equation 6. `MonotoneInAccumulator` is
monotonicity of a block in its accumulator input for fixed products. For two accumulator
inputs `c` and `c'`, the flowback `ω` is the change in the retained products between the
two alignment grids and `ΔA` is the change in the retained accumulator input, so that
`A'acc = Aacc + ω − ΔA`. The encoded outputs compare exactly as the truncations of those
two accumulators (Equation 6); `ω > ΔA` is necessary for an output increase because FP32
truncation is monotone in its real argument, and it is sufficient when both accumulators
are representable. Theorem III.4 gives a family where monotonicity fails. -/

namespace TensorCore

/-- Definition III.2: for fixed decoded products, a smaller finite accumulator input never
produces a larger accepted output. -/
def MonotoneInAccumulator (prof : Profile) (products : List (Decoded × Decoded)) : Prop :=
  ∀ (c c' : Decoded) (t t' : BlockTrace),
    evalPrepared ⟨prof, products, c⟩ = .ok t → evalPrepared ⟨prof, products, c'⟩ = .ok t' →
    c'.value < c.value → t'.output.value ≤ t.output.value

/-- Definition III.3: the flowback `ω = Σᵢ (trunc_{q'A}(Tᵢ) − trunc_{qA}(Tᵢ))` of the
products between the alignment grids selected by `c` and by `c'`. -/
def flowback (prof : Profile) (products : List (Decoded × Decoded)) (c c' : Decoded) : ℚ :=
  sumQ (products.map fun (a, b) =>
    truncGrid (rawMul a b).value (PreparedBlock.mk prof products c').quantumExponent -
      truncGrid (rawMul a b).value (PreparedBlock.mk prof products c).quantumExponent)

/-- Definition III.3: `ΔA = trunc_{qA}(c) − trunc_{q'A}(c')`. -/
def accumulatorShift (prof : Profile) (products : List (Decoded × Decoded)) (c c' : Decoded) :
    ℚ :=
  truncGrid c.value (PreparedBlock.mk prof products c).quantumExponent -
    truncGrid c'.value (PreparedBlock.mk prof products c').quantumExponent

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

/-- When both accumulator inputs are retained exactly on their grids, `ΔA = c − c'`. -/
theorem accumulatorShift_of_exact (prof : Profile) (products : List (Decoded × Decoded))
    (c c' : Decoded)
    (hc : truncGrid c.value (PreparedBlock.mk prof products c).quantumExponent = c.value)
    (hc' : truncGrid c'.value (PreparedBlock.mk prof products c').quantumExponent = c'.value) :
    accumulatorShift prof products c c' = c.value - c'.value := by
  unfold accumulatorShift
  rw [hc, hc']

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

end TensorCore
