import TensorCore.IEEE.Basic

/-! Rounding with unbounded exponent range. The specification uses binade
inequalities and optimality against integer competitors, not exponent search,
floor/ceiling selection, or encoded output. This is used for IEEE status flags. -/

namespace TensorCore.IEEE

/-- A rounding direction applied to a nonnegative magnitude. -/
def IntegerRound (mode : BinaryRoundingMode) (negative : Bool) (t : Rat) (k : Int) : Prop :=
  match mode with
  | .nearestEven =>
      (∀ j : Int, absQ (t - k) ≤ absQ (t - j)) ∧
      (∀ j : Int, j ≠ k → absQ (t - j) = absQ (t - k) → k % 2 = 0)
  | .towardZero => (k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k
  | .towardNegative => if negative then
      t ≤ (k : Rat) ∧ ∀ j : Int, t ≤ (j : Rat) → k ≤ j
    else (k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k
  | .towardPositive => if negative then
      (k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k
    else t ≤ (k : Rat) ∧ ∀ j : Int, t ≤ (j : Rat) → k ≤ j

theorem coefficient_correct (mode : BinaryRoundingMode) (negative : Bool) (t : Rat) :
    IntegerRound mode negative t (binaryCoefficient mode negative t) := by
  have hf : (t.floor : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ t.floor :=
    ⟨Rat.floor_le t, fun _ h => Rat.le_floor_iff.mpr h⟩
  have hc : t ≤ (t.ceil : Rat) ∧ ∀ j : Int, t ≤ (j : Rat) → t.ceil ≤ j :=
    ⟨Rat.le_ceil, fun _ h => Rat.ceil_le_iff.mpr h⟩
  cases mode with
  | nearestEven => exact ⟨rneInt_nearest t, fun j hn ht => rneInt_tie_even t j ht hn⟩
  | towardZero => exact hf
  | towardNegative => cases negative <;> first | exact hf | exact hc
  | towardPositive => cases negative <;> first | exact hf | exact hc

/-- Optimality plus even tie breaking determines one integer, not a set of
convenient witnesses that could alter exception behavior. -/
theorem integerRound_unique (mode : BinaryRoundingMode) (negative : Bool) (t : Rat)
    (k : Int) (h : IntegerRound mode negative t k) :
    k = binaryCoefficient mode negative t := by
  have hf : ((k : Rat) ≤ t ∧ ∀ j : Int, (j : Rat) ≤ t → j ≤ k) → k = t.floor := by
    intro h
    exact Int.le_antisymm (Rat.le_floor_iff.mpr h.1) (h.2 _ (Rat.floor_le t))
  have hc : (t ≤ (k : Rat) ∧ ∀ j : Int, t ≤ (j : Rat) → k ≤ j) → k = t.ceil := by
    intro h
    exact Int.le_antisymm (h.2 _ Rat.le_ceil) (Rat.ceil_le_iff.mpr h.1)
  cases mode with
  | towardZero => exact hf h
  | towardNegative => cases negative <;> first | exact hf h | exact hc h
  | towardPositive => cases negative <;> first | exact hf h | exact hc h
  | nearestEven =>
    change k = rneInt t
    apply Classical.byContradiction
    intro hn
    have he := Rat.le_antisymm (h.1 (rneInt t)) (rneInt_nearest t k)
    have hkEven := h.2 (rneInt t) (Ne.symm hn) he.symm
    have hrEven := rneInt_tie_even t k he hn
    have hd := rneInt_dist_le_half t
    have hk : absQ (t - (k : Rat)) ≤ (1 / 2 : Rat) := by grind
    have hr : absQ (t - (rneInt t : Rat)) ≤ (1 / 2 : Rat) := by grind
    have bk := (absQ_le_iff _ _).mp hk
    have br := (absQ_le_iff _ _).mp hr
    have hkl : k ≤ rneInt t + 1 := by
      apply Rat.intCast_le_intCast.mp
      simp only [Rat.intCast_add, Rat.intCast_one]
      grind
    have hlk : rneInt t ≤ k + 1 := by
      apply Rat.intCast_le_intCast.mp
      simp only [Rat.intCast_add, Rat.intCast_one]
      grind
    omega

/-- Positive magnitude rounded to the destination precision with no exponent limits. -/
def precisionMagnitude (f : Format) (mode : BinaryRoundingMode) (negative : Bool) (m : Rat) : Rat :=
  if m = 0 then 0 else
    let q := pow2 (magnitudeExponent m - f.fractionBits)
    (binaryCoefficient mode negative (m / q) : Rat) * q

def PrecisionRound (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m u : Rat) : Prop :=
  (m = 0 ∧ u = 0) ∨
  ∃ e : Int, ∃ k : Int, pow2 e ≤ m ∧ m < pow2 (e + 1) ∧
    IntegerRound mode negative (m / pow2 (e - f.fractionBits)) k ∧
    u = (k : Rat) * pow2 (e - f.fractionBits)

theorem precisionMagnitude_correct (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) (hm : 0 ≤ m) :
    PrecisionRound f mode negative m (precisionMagnitude f mode negative m) := by
  by_cases hz : m = 0
  · exact Or.inl ⟨hz, by simp [precisionMagnitude, hz]⟩
  · have hs := magnitudeExponent_spec m (show 0 < m by grind)
    exact Or.inr ⟨magnitudeExponent m, _, hs.1, hs.2, coefficient_correct _ _ _,
      by simp [precisionMagnitude, hz]⟩

/-- The relational precision specification has exactly the computed magnitude. -/
theorem precisionRound_unique (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m u : Rat) (h : PrecisionRound f mode negative m u) :
    u = precisionMagnitude f mode negative m := by
  rcases h with ⟨hm, hu⟩ | ⟨e, k, hl, hh, hk, hu⟩
  · simp [precisionMagnitude, hm, hu]
  · have hm : 0 < m := by have := pow2_pos e; grind
    have he := magnitudeExponent_eq_of_bounds m e hl hh
    have hc := integerRound_unique mode negative _ k hk
    simp [precisionMagnitude, Rat.ne_of_gt hm, he, ← hc, hu]

theorem precisionMagnitude_lower (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) (hm : 0 < m) :
    pow2 (magnitudeExponent m) ≤ precisionMagnitude f mode negative m := by
  let e := magnitudeExponent m
  let q := pow2 (e - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  have hs := magnitudeExponent_spec m hm
  have hl : ((2 ^ f.fractionBits : Nat) : Rat) ≤ m / q := by
    apply le_div_of_mul_le _ _ _ hq
    change ((2 ^ f.fractionBits : Nat) : Rat) * pow2 (e - f.fractionBits) ≤ m
    rw [← f.binade_grid]; exact hs.1
  have hu : m / q < ((2 ^ (f.fractionBits + 1) : Nat) : Rat) := by
    apply (Rat.div_lt_iff hq).mpr
    change m < ((2 ^ (f.fractionBits + 1) : Nat) : Rat) * pow2 (e - f.fractionBits)
    rw [← f.next_binade_grid]; exact hs.2
  have hb := binaryCoefficient_bounds mode negative (m / q) (2 ^ (f.fractionBits + 1))
    (Rat.le_trans Rat.natCast_nonneg hl) hu
  have hfl : (2 ^ f.fractionBits : Nat) ≤ (m / q).floor := Rat.le_floor_iff.mpr hl
  have hk : ((2 ^ f.fractionBits : Nat) : Int) ≤ binaryCoefficient mode negative (m / q) := by omega
  rw [precisionMagnitude, if_neg (Rat.ne_of_gt hm), f.binade_grid]
  exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hk) (Rat.le_of_lt hq)

theorem precisionMagnitude_positive (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) (hm : 0 < m) :
    0 < precisionMagnitude f mode negative m := by
  have := pow2_pos (magnitudeExponent m)
  have := precisionMagnitude_lower f mode negative m hm
  grind

/-- Rounding a magnitude already inside the finite range cannot signal overflow. -/
theorem precisionMagnitude_le_max (f : Format) (hf : f.WellFormed)
    (mode : BinaryRoundingMode) (negative : Bool) (m : Rat)
    (hm : 0 ≤ m) (hr : m ≤ f.maxFinite) :
    precisionMagnitude f mode negative m ≤ f.maxFinite := by
  by_cases hz : m = 0
  · simp [precisionMagnitude, hz]
    exact Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  have hp : 0 < m := by grind
  let e := magnitudeExponent m
  have he : e ≤ f.emax := by
    have hb := binaryConvExp_bounds f hf m hp hr
    unfold binaryConvExp at hb
    dsimp [e]; omega
  obtain ⟨j, hj⟩ := f.finite_on_grid
    ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Int) f.emax e he
  have hmj : f.maxFinite = (j : Rat) * pow2 (e - f.fractionBits) := hj
  have hq := pow2_pos (e - f.fractionBits)
  have ht : m / pow2 (e - f.fractionBits) ≤ (j : Rat) := by
    apply Rat.le_of_mul_le_mul_right (c := pow2 (e - f.fractionBits)) _ hq
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq), ← hmj]
    exact hr
  have hc := binaryCoefficient_le_integer mode negative (m / pow2 (e - f.fractionBits)) j ht
  rw [precisionMagnitude, if_neg hz, hmj]
  exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)

/-- The normal-precision result is nearest among all bounded-significand dyadics,
even when a competitor uses a different exponent. -/
theorem precision_nearest_all (f : Format) (m : Rat) (hm : 0 < m)
    (j e : Int) (hj : j.natAbs < 2 ^ (f.fractionBits + 1)) :
    absQ (m - precisionMagnitude f .nearestEven false m) ≤
      absQ (m - (j : Rat) * pow2 (e - f.fractionBits)) := by
  let b := magnitudeExponent m
  have hs := magnitudeExponent_spec m hm
  by_cases he : b ≤ e
  · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
    rw [hz, precisionMagnitude, if_neg (Rat.ne_of_gt hm)]
    exact rne_grid_nearest_q m _ (pow2_pos _) z
  · have hsmall := f.finite_below_binade j e b hj (by omega)
    have hsmall' := (absQ_le_iff _ _).mp hsmall
    have hq := pow2_pos (b - f.fractionBits - 1)
    have hn := rne_grid_nearest_q m (pow2 (b - f.fractionBits)) (pow2_pos _)
      ((2 ^ f.fractionBits : Nat) : Int)
    rw [Rat.intCast_natCast, ← f.binade_grid] at hn
    change absQ (m - (rneInt (m / pow2 (b - f.fractionBits)) : Rat) *
      pow2 (b - f.fractionBits)) ≤ absQ (m - pow2 b) at hn
    rw [precisionMagnitude, if_neg (Rat.ne_of_gt hm)]
    change absQ (m - (rneInt (m / pow2 (b - f.fractionBits)) : Rat) *
      pow2 (b - f.fractionBits)) ≤ _
    have h1 : 0 ≤ m - pow2 b := by grind
    have h2 : 0 ≤ m - (j : Rat) * pow2 (e - f.fractionBits) := by grind
    rw [absQ_of_nonneg h1] at hn
    rw [absQ_of_nonneg h2]
    grind

/-- Directed precision rounding is a greatest lower bound over every bounded-
significand dyadic, rather than only competitors on the selected grid. -/
theorem precision_floor_all (f : Format) (m : Rat) (hm : 0 < m) :
    precisionMagnitude f .towardZero false m ≤ m ∧
    ∀ j e : Int, j.natAbs < 2 ^ (f.fractionBits + 1) →
      (j : Rat) * pow2 (e - f.fractionBits) ≤ m →
      (j : Rat) * pow2 (e - f.fractionBits) ≤ precisionMagnitude f .towardZero false m := by
  let b := magnitudeExponent m
  let q := pow2 (b - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (m / q)) (Rat.le_of_lt hq)
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
    simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
  · intro j e hj hjm
    by_cases he : b ≤ e
    · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
      rw [hz] at hjm ⊢
      have hc : z ≤ (m / q).floor := Rat.le_floor_iff.mpr
        (le_div_of_mul_le _ _ _ hq hjm)
      have h := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
      simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
    · have hsmall := f.finite_below_binade j e b hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have hl := precisionMagnitude_lower f .towardZero false m hm
      have hp := pow2_pos (b - f.fractionBits - 1)
      grind

/-- The corresponding least-upper-bound characterization, with unrestricted exponents. -/
theorem precision_ceil_all (f : Format) (m : Rat) (hm : 0 < m) :
    m ≤ precisionMagnitude f .towardPositive false m ∧
    ∀ j e : Int, j.natAbs < 2 ^ (f.fractionBits + 1) →
      m ≤ (j : Rat) * pow2 (e - f.fractionBits) →
      precisionMagnitude f .towardPositive false m ≤ (j : Rat) * pow2 (e - f.fractionBits) := by
  let b := magnitudeExponent m
  let q := pow2 (b - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right (Rat.le_ceil (x := m / q)) (Rat.le_of_lt hq)
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
    simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
  · intro j e hj hmj
    by_cases he : b ≤ e
    · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
      rw [hz] at hmj ⊢
      have hdiv : m / q ≤ (z : Rat) := by
        apply Rat.le_of_mul_le_mul_right (c := q) _ hq
        rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)]
        exact hmj
      have hc : (m / q).ceil ≤ z := Rat.ceil_le_iff.mpr hdiv
      have h := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
      simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
    · have hsmall := f.finite_below_binade j e b hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have hl := (magnitudeExponent_spec m hm).1
      have hp := pow2_pos (b - f.fractionBits - 1)
      grind

end TensorCore.IEEE
