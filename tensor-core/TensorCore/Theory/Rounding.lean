import TensorCore.Theory.Encoding

/-! Specification and correctness of the FP32 converter.

`rneInt` is characterised on the integer grid, `magnitudeExponent` is proved to select the
binary exponent, and both are later combined into the nearest-value theorem. -/

namespace TensorCore

theorem floor_frac_bounds (t : Rat) : 0 ≤ t - t.floor ∧ t - t.floor < 1 := by
  have h1 := Rat.floor_le t
  have h2 := Rat.lt_floor_add_one t
  simp only [Rat.intCast_add, Rat.intCast_one] at h2
  grind

theorem rneInt_cases (t : Rat) :
    (rneInt t = t.floor + 1 ∧
      (1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1))) ∨
    (rneInt t = t.floor ∧
      ¬(1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1))) := by
  unfold rneInt; split <;> simp [*]

/-- Integers are at least one apart, stated over the rationals. -/
theorem intCast_le_or_succ_le (j k : Int) : (j : Rat) ≤ k ∨ (k : Rat) + 1 ≤ j := by
  by_cases h : j ≤ k
  · exact Or.inl (Rat.intCast_le_intCast.mpr h)
  · right
    have : k + 1 ≤ j := by omega
    have h' := Rat.intCast_le_intCast.mpr this
    simpa [Rat.intCast_add, Rat.intCast_one] using h'

theorem rneInt_dist_le_half (t : Rat) : 2 * absQ (t - rneInt t) ≤ 1 := by
  have h := floor_frac_bounds t
  rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩ <;> rw [hk] <;>
    (try simp only [Rat.intCast_add, Rat.intCast_one]) <;> unfold absQ <;> split <;> grind

/-- The selected integer is at least as close as every integer. -/
theorem rneInt_nearest (t : Rat) (j : Int) : absQ (t - rneInt t) ≤ absQ (t - j) := by
  have h := floor_frac_bounds t
  have hj := intCast_le_or_succ_le j t.floor
  rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩ <;> rw [hk] <;>
    (try simp only [Rat.intCast_add, Rat.intCast_one]) <;> unfold absQ <;> split <;> split <;>
    grind

/-- An equally close different integer forces a tie, and the selection is then even. -/
theorem rneInt_tie_even (t : Rat) (j : Int) (htie : absQ (t - j) = absQ (t - rneInt t))
    (hne : j ≠ rneInt t) : rneInt t % 2 = 0 := by
  have h := floor_frac_bounds t
  have hj := intCast_le_or_succ_le j t.floor
  have hj2 := intCast_le_or_succ_le (t.floor + 1) j
  simp only [Rat.intCast_add, Rat.intCast_one] at hj2
  rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩ <;> rw [hk] at htie hne ⊢
  · have hne' : (j : Rat) ≠ (t.floor : Rat) + 1 := by
      intro he
      apply hne
      have : (j : Rat) = ((t.floor + 1 : Int) : Rat) := by
        simpa [Rat.intCast_add, Rat.intCast_one] using he
      exact Rat.intCast_inj.mp this
    simp only [Rat.intCast_add, Rat.intCast_one] at htie
    have hf : 2 * (t - t.floor) = 1 := by
      unfold absQ at htie; split at htie <;> split at htie <;> grind
    rcases hc with hc | ⟨_, hodd⟩
    · exfalso; rw [hf] at hc; exact Rat.lt_irrefl hc
    · omega
  · have hne' : (j : Rat) ≠ (t.floor : Rat) := fun he => hne (Rat.intCast_inj.mp he)
    have hf : 2 * (t - t.floor) = 1 := by
      unfold absQ at htie; split at htie <;> split at htie <;> grind
    have : ¬ (t.floor % 2 = 1) := fun hodd => hc (Or.inr ⟨hf, hodd⟩)
    omega

theorem floor_nonneg_of_nonneg (t : Rat) (h : 0 ≤ t) : 0 ≤ t.floor := by
  have := Rat.lt_floor_add_one t
  simp only [Rat.intCast_add, Rat.intCast_one] at this
  have h2 : (-1 : Rat) < t.floor := by grind
  have h3 : (-1 : Int) < t.floor := by
    have := Rat.intCast_lt_intCast (a := -1) (b := t.floor)
    simp only [Rat.intCast_neg, Rat.intCast_one] at this
    exact this.mp h2
  omega

theorem rneInt_nonneg (t : Rat) (h : 0 ≤ t) : 0 ≤ rneInt t := by
  have := floor_nonneg_of_nonneg t h
  rcases rneInt_cases t with ⟨hk, _⟩ | ⟨hk, _⟩ <;> omega

/-- For positive x, `magnitudeExponent x` is the binary exponent: `2^e ≤ x < 2^(e+1)`. -/
theorem magnitudeExponent_spec (x : Rat) (hx : 0 < x) :
    pow2 (magnitudeExponent x) ≤ x ∧ x < pow2 (magnitudeExponent x + 1) := by
  have hden : (0 : Rat) < x.den := Rat.natCast_pos.mpr x.den_pos
  have hnum0 : x.num ≠ 0 := fun h => by
    have := Rat.num_eq_zero.mp h; subst this; exact Rat.lt_irrefl hx
  have hnumnn : 0 ≤ x.num := Rat.num_nonneg.mpr (Rat.le_of_lt hx)
  have hxd : x * x.den = x.num := by
    have h := Rat.num_divInt_den x
    rw [Rat.divInt_eq_div, Rat.intCast_natCast] at h
    calc x * x.den = (x.num / (x.den : Rat)) * x.den := by rw [h]
      _ = x.num := Rat.div_mul_cancel (Rat.ne_of_gt hden)
  have hnR : ((x.num.natAbs : Nat) : Rat) = (x.num : Rat) := by
    rw [← Rat.intCast_natCast, Int.natAbs_of_nonneg hnumnn]
  have hn0 : x.num.natAbs ≠ 0 := fun h => hnum0 (Int.natAbs_eq_zero.mp h)
  have hd0 : x.den ≠ 0 := Nat.pos_iff_ne_zero.mp x.den_pos
  have h1 : ((2 ^ x.num.natAbs.log2 : Nat) : Rat) ≤ x.num.natAbs :=
    Rat.natCast_le_natCast.mpr (Nat.log2_self_le hn0)
  have h2 : (x.num.natAbs : Rat) < ((2 ^ (x.num.natAbs.log2 + 1) : Nat) : Rat) :=
    Rat.natCast_lt_natCast.mpr Nat.lt_log2_self
  have h3 : ((2 ^ x.den.log2 : Nat) : Rat) ≤ x.den :=
    Rat.natCast_le_natCast.mpr (Nat.log2_self_le hd0)
  have h4 : (x.den : Rat) < ((2 ^ (x.den.log2 + 1) : Nat) : Rat) :=
    Rat.natCast_lt_natCast.mpr Nat.lt_log2_self
  rw [← pow2_natCast] at h1 h2 h3 h4
  rw [hnR] at h1 h2
  generalize hA : (x.num.natAbs.log2 : Int) = a at *
  generalize hB : (x.den.log2 : Int) = b at *
  have hcast1 : ((x.num.natAbs.log2 + 1 : Nat) : Int) = a + 1 := by omega
  have hcast2 : ((x.den.log2 + 1 : Nat) : Int) = b + 1 := by omega
  rw [hcast1] at h2; rw [hcast2] at h4
  have lo : pow2 (a - b - 1) < x := by
    have hq := pow2_pos (a - b - 1)
    have e1 : pow2 (a - b - 1) * pow2 (b + 1) = pow2 a := by
      rw [← pow2_add]; congr 1; omega
    have e2 : pow2 (a - b - 1) * x.den < pow2 (a - b - 1) * pow2 (b + 1) :=
      (Rat.mul_lt_mul_left hq).mpr h4
    rw [e1] at e2
    have e3 : pow2 (a - b - 1) * x.den < x * x.den := by rw [hxd]; grind
    exact Rat.lt_of_mul_lt_mul_right e3 (Rat.le_of_lt hden)
  have hi : x < pow2 (a - b + 1) := by
    have hq := pow2_pos (a - b + 1)
    have e1 : pow2 (a - b + 1) * pow2 b = pow2 (a + 1) := by
      rw [← pow2_add]; congr 1; omega
    have e2 : pow2 (a - b + 1) * pow2 b ≤ pow2 (a - b + 1) * x.den :=
      Rat.mul_le_mul_of_nonneg_left h3 (Rat.le_of_lt hq)
    rw [e1] at e2
    have e3 : x * x.den < pow2 (a - b + 1) * x.den := by rw [hxd]; grind
    exact Rat.lt_of_mul_lt_mul_right e3 (Rat.le_of_lt hden)
  have hdef : magnitudeExponent x = if x < pow2 (a - b) then a - b - 1 else a - b := by
    unfold magnitudeExponent; rw [hA, hB]
  rw [hdef]
  split
  · have : a - b - 1 + 1 = a - b := by omega
    rw [this]; exact ⟨Rat.le_of_lt lo, by assumption⟩
  · exact ⟨by grind, hi⟩

/-! Grid geometry used by the nearest-value proof. -/

/-- Scaling a grid distance by the quantum. -/
theorem dist_scale (m : Rat) (q : Rat) (hq : 0 < q) (j : Int) :
    absQ (m - j * q) = absQ (m / q - j) * q := by
  rw [← absQ_mul_pos _ q hq]
  have := Rat.div_mul_cancel (a := m) (Rat.ne_of_gt hq)
  congr 1
  grind

/-- Every finite value with exponent at least `e` is an integer multiple of `2^(e-23)`. -/
theorem finite_on_grid (k e2 e : Int) (h : e ≤ e2) :
    ∃ j : Int, (k : Rat) * pow2 (e2 - 23) = j * pow2 (e - 23) := by
  refine ⟨k * 2 ^ (e2 - e).toNat, ?_⟩
  have : pow2 (e2 - 23) = pow2 (e - 23) * pow2 ((e2 - e).toNat : Int) := by
    rw [← pow2_add]; congr 1; omega
  rw [this, pow2_natCast, Rat.intCast_mul, Rat.intCast_pow]
  simp only [Rat.intCast_ofNat, Rat.natCast_pow, Rat.natCast_ofNat]
  grind

theorem absQ_intCast (k : Int) : absQ (k : Rat) = ((k.natAbs : Int) : Rat) := by
  unfold absQ
  split
  · have hk : k < 0 := by
      have := Rat.intCast_lt_intCast (a := k) (b := 0); simp at this; grind
    rw [← Int.natAbs_neg, Int.natAbs_of_nonneg (by omega), Rat.intCast_neg]
  · have hk : 0 ≤ k := by
      have := Rat.intCast_le_intCast (a := 0) (b := k); simp at this; grind
    rw [Int.natAbs_of_nonneg hk]

theorem pow2_24 : pow2 24 = 16777216 := by decide

/-- A finite value with exponent below `e` is at most `2^e - 2^(e-24)` in magnitude. -/
theorem finite_below_binade (k e2 e : Int) (hk : k.natAbs < 2 ^ 24) (h : e2 < e) :
    absQ ((k : Rat) * pow2 (e2 - 23)) ≤ pow2 e - pow2 (e - 24) := by
  have hq := pow2_pos (e2 - 23)
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have hk' : ((k.natAbs : Int) : Rat) ≤ (16777215 : Rat) := by
    have h1 : (k.natAbs : Int) ≤ 16777215 := by omega
    have h2 := Rat.intCast_le_intCast.mpr h1
    simpa using h2
  have hgrid : pow2 (e2 - 23) ≤ pow2 (e - 24) := pow2_le_of_le (by omega)
  have hnn : (0 : Rat) ≤ ((k.natAbs : Int) : Rat) := Rat.intCast_nonneg.mpr (by omega)
  have step1 : ((k.natAbs : Int) : Rat) * pow2 (e2 - 23) ≤ 16777215 * pow2 (e - 24) :=
    calc ((k.natAbs : Int) : Rat) * pow2 (e2 - 23)
        ≤ ((k.natAbs : Int) : Rat) * pow2 (e - 24) := Rat.mul_le_mul_of_nonneg_left hgrid hnn
      _ ≤ 16777215 * pow2 (e - 24) :=
          Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _))
  have step2 : (16777215 : Rat) * pow2 (e - 24) = pow2 e - pow2 (e - 24) := by
    have : pow2 e = pow2 (e - 24) * pow2 24 := by rw [← pow2_add]; congr 1; omega
    rw [this, pow2_24]
    grind
  rw [← step2]; exact step1

end TensorCore
