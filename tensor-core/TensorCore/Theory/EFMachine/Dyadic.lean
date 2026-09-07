import TensorCore.Theory.EFMachine.Word
import TensorCore.Theory.Monotonicity

namespace TensorCore.EFMachine

theorem floor_nat_div (m d : Nat) (hd : 0 < d) :
    ((m : Rat) / (d : Rat)).floor = (m / d : Nat) := by
  have hdp : (0 : Rat) < (d : Rat) := Rat.natCast_pos.mpr hd
  have hlo : ((m / d : Nat) : Rat) * (d : Rat) ≤ (m : Rat) := by
    rw [← Rat.natCast_mul]
    exact Rat.natCast_le_natCast.mpr (Nat.div_mul_le_self m d)
  have hhi : (m : Rat) < ((m / d : Nat) + 1 : Rat) * (d : Rat) := by
    have hn : m < (m / d + 1) * d := by
      have := Nat.mod_lt m hd
      have hh := Nat.mod_add_div m d
      rw [Nat.mul_comm] at hh
      rw [Nat.add_mul, Nat.one_mul]
      omega
    exact_mod_cast hn
  have hl : ((m / d : Nat) : Int) ≤ ((m : Rat) / (d : Rat)).floor := by
    apply Rat.le_floor_iff.mpr
    have h := Rat.div_lt_iff (a := (m : Rat)) (c := ((m / d : Nat) : Rat)) hdp
    simp only [Rat.intCast_natCast]
    grind
  have hh : ((m : Rat) / (d : Rat)).floor < ((m / d : Nat) : Int) + 1 := by
    apply Rat.floor_lt_iff.mpr
    simpa only [Rat.intCast_add, Rat.intCast_natCast, Rat.intCast_one] using
      (Rat.div_lt_iff hdp).mpr hhi
  omega

theorem dyadic_div (m : Nat) (scale : Int) (gap : Nat) :
    (m : Rat) * pow2 scale / pow2 (scale + gap) = (m : Rat) / (2 ^ gap : Nat) := by
  have hp := pow2_pos scale
  have hd : (0 : Rat) < ((2 ^ gap : Nat) : Rat) := Rat.natCast_pos.mpr (Nat.two_pow_pos _)
  rw [pow2_add, pow2_natCast, Rat.div_def, Rat.inv_mul_rev]
  have hc := Rat.mul_inv_cancel (pow2 scale) (Rat.ne_of_gt hp)
  rw [Rat.div_def]
  grind

/-- The implemented quotient/remainder split is the paper's magnitude truncation,
including negative terms and gaps beyond a machine limb's width. -/
theorem Word.split_coarse_value (x : Word) (g : Grid) :
    (x.split g).coarse.value = truncGrid x.value ((g.toNat : Int) - 272) := by
  have hs := x.split_sign g
  have hn : (0 : Rat) ≤ (x.magnitude.toNat : Rat) * pow2 (-272) :=
    Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  have hpos : ((x.split g).coarse.magnitude.toNat : Rat) * pow2 (-272) =
      truncGrid ((x.magnitude.toNat : Rat) * pow2 (-272)) ((g.toNat : Int) - 272) := by
    rw [show (g.toNat : Int) - 272 = -272 + g.toNat by omega]
    rw [alignment_value, truncCoeff_nonneg_eq _ _ hn, dyadic_div,
      floor_nat_div _ _ (Nat.two_pow_pos _), x.split_coarse, Rat.natCast_mul,
      pow2_add, pow2_natCast]
    simp only [Rat.intCast_natCast]
    grind
  cases hx : x.negative
  · simpa only [Word.value, Word.coefficient, hs.1, hx, Bool.false_eq_true,
      if_false, Rat.intCast_natCast] using hpos
  · simpa only [Word.value, Word.coefficient, hs.1, hx, if_true, Rat.intCast_neg,
      Rat.intCast_natCast, Rat.neg_mul, truncGrid_neg] using congrArg Neg.neg hpos

theorem Word.split_low_value (x : Word) (g : Grid) :
    (x.split g).low.value = x.value - truncGrid x.value ((g.toNat : Int) - 272) := by
  have h := x.split_reconstruct g
  rw [x.split_coarse_value] at h
  grind

theorem Word.split_low_bound (x : Word) (g : Grid) :
    absQ (x.split g).low.value < pow2 ((g.toNat : Int) - 272) := by
  rw [x.split_low_value]
  exact (alignment_residual _ _).2

theorem rneInt_nat_div (m d : Nat) (hd : 0 < d) :
    rneInt ((m : Rat) / (d : Rat)) =
      if d < 2 * (m % d) ∨ (2 * (m % d) = d ∧ m / d % 2 = 1)
      then ((m / d + 1 : Nat) : Int) else ((m / d : Nat) : Int) := by
  have hp : (0 : Rat) < (d : Rat) := Rat.natCast_pos.mpr hd
  have hn : ((m % d : Nat) : Rat) + (d : Rat) * ((m / d : Nat) : Rat) = m := by
    exact_mod_cast Nat.mod_add_div m d
  have hrem : (m : Rat) / (d : Rat) - ((m / d : Nat) : Rat) = (m % d : Nat) / (d : Rat) := by
    have hc := Rat.div_mul_cancel (a := (m : Rat)) (Rat.ne_of_gt hp)
    have hr := Rat.div_mul_cancel (a := ((m % d : Nat) : Rat)) (Rat.ne_of_gt hp)
    grind
  have he : (1 : Rat) < 2 * ((m % d : Nat) / (d : Rat)) ↔ d < 2 * (m % d) := by
    have hc := Rat.div_mul_cancel (a := ((m % d : Nat) : Rat)) (Rat.ne_of_gt hp)
    have hi := Rat.mul_lt_mul_right (a := (1 : Rat)) (b := 2 * ((m % d : Nat) / (d : Rat))) hp
    have hc' : (2 : Rat) * ((m % d : Nat) / (d : Rat)) * d = ((2 * (m % d) : Nat) : Rat) := by
      simp only [Rat.natCast_mul]; grind
    rw [Rat.one_mul, hc'] at hi
    exact hi.symm.trans Rat.natCast_lt_natCast
  have ht : 2 * ((m % d : Nat) / (d : Rat)) = (1 : Rat) ↔ 2 * (m % d) = d := by
    have hc := Rat.div_mul_cancel (a := ((m % d : Nat) : Rat)) (Rat.ne_of_gt hp)
    have hdne := Rat.ne_of_gt hp
    constructor
    · intro h
      have h' : ((2 * (m % d) : Nat) : Rat) = (d : Rat) := by
        simp only [Rat.natCast_mul]; grind
      exact Rat.natCast_inj.mp h'
    · intro h
      have h' : (2 : Rat) * ((m % d : Nat) : Rat) = (d : Rat) := by exact_mod_cast h
      grind
  unfold rneInt
  rw [floor_nat_div _ _ hd]
  simp only [Rat.intCast_natCast, hrem, he, ht]
  have hp2 : ((m / d : Nat) : Int) % 2 = 1 ↔ m / d % 2 = 1 := by omega
  simp only [hp2, Int.natCast_add, Int.natCast_one]

end TensorCore.EFMachine
