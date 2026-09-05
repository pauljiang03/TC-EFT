import TensorCore.Semantics.Block

namespace TensorCore

/-- Total magnitude support. Unlike the final signed sum, it controls every prefix. -/
def magnitudeSum : List Int → Nat
  | [] => 0
  | z :: zs => z.natAbs + magnitudeSum zs

theorem sumZ_natAbs_le (zs : List Int) : (sumZ zs).natAbs ≤ magnitudeSum zs := by
  induction zs with
  | nil => simp [sumZ, magnitudeSum]
  | cons z zs ih =>
    have := Int.natAbs_add_le z (sumZ zs)
    simp only [sumZ, magnitudeSum]
    omega

theorem magnitudeSum_append (xs ys : List Int) :
    magnitudeSum (xs ++ ys) = magnitudeSum xs + magnitudeSum ys := by
  induction xs with
  | nil => simp [magnitudeSum]
  | cons x xs ih => simp [magnitudeSum, ih, Nat.add_assoc]

theorem magnitudeSum_le_length_mul (zs : List Int) (B : Nat)
    (h : ∀ z ∈ zs, z.natAbs ≤ B) : magnitudeSum zs ≤ zs.length * B := by
  induction zs with
  | nil => simp [magnitudeSum]
  | cons z zs ih =>
    have hz := h z (by simp)
    have ht := ih (by intro t ht; exact h t (by simp [ht]))
    simp only [magnitudeSum, List.length_cons, Nat.add_mul, Nat.one_mul]
    omega

/-- Actual modular signed-word additions, starting from a supplied register. -/
def machineAccumulate (w : Nat) (acc : BitVec w) : List Int → BitVec w
  | [] => acc
  | z :: zs => machineAccumulate w (acc + BitVec.ofInt w z) zs

theorem machineAccumulate_eq (w : Nat) (initial : Int) (zs : List Int) :
    machineAccumulate w (BitVec.ofInt w initial) zs = BitVec.ofInt w (initial + sumZ zs) := by
  induction zs generalizing initial with
  | nil => simp [machineAccumulate, sumZ]
  | cons z zs ih =>
    simp only [machineAccumulate, ← BitVec.ofInt_add, ih, sumZ]
    congr 1
    omega

/-- Final signed value is exact whenever total absolute support fits the positive range. -/
theorem machineAccumulate_exact (w : Nat) (zs : List Int) (hw : 0 < w)
    (h : magnitudeSum zs < 2 ^ (w - 1)) :
    (machineAccumulate w 0 zs).toInt = sumZ zs := by
  have hs := sumZ_natAbs_le zs
  have hp : ((2 ^ (w - 1) : Nat) : Int) = (2 : Int) ^ (w - 1) := by simp
  have hb : (machineAccumulate w 0 zs) = BitVec.ofInt w (sumZ zs) := by
    simpa using machineAccumulate_eq w 0 zs
  rw [hb]
  apply BitVec.toInt_ofInt_eq_self hw <;> omega

/-- Every prefix is exact under the same support condition, even with cancellation. -/
theorem machineAccumulate_prefix_exact (w : Nat) (xs ys : List Int) (hw : 0 < w)
    (h : magnitudeSum (xs ++ ys) < 2 ^ (w - 1)) :
    (machineAccumulate w 0 xs).toInt = sumZ xs := by
  apply machineAccumulate_exact w xs hw
  rw [magnitudeSum_append] at h
  omega

/-- A usable conservative signed width: B coefficient bits, carry bits c for the
term count, and a separate sign bit. The bound uses at most `2^B - 1` per term. -/
theorem coefficient_width_sufficient (zs : List Int) (B c : Nat)
    (hterm : ∀ z ∈ zs, z.natAbs < 2 ^ B) (hcount : zs.length ≤ 2 ^ c) :
    magnitudeSum zs < 2 ^ ((B + c + 1) - 1) := by
  have hp := Nat.two_pow_pos B
  have hc := Nat.two_pow_pos c
  have hs := magnitudeSum_le_length_mul zs (2 ^ B - 1) (by
    intro z hz; have := hterm z hz; omega)
  have hm := Nat.mul_le_mul_right (2 ^ B - 1) hcount
  have he : (B + c + 1) - 1 = B + c := by omega
  rw [he, Nat.pow_add, Nat.mul_comm]
  have hd : 2 ^ c * (2 ^ B - 1) < 2 ^ c * 2 ^ B :=
    Nat.mul_lt_mul_of_pos_left (by omega) hc
  omega

theorem machineAccumulate_of_coefficient_bound (zs : List Int) (B c : Nat)
    (hterm : ∀ z ∈ zs, z.natAbs < 2 ^ B) (hcount : zs.length ≤ 2 ^ c) :
    (machineAccumulate (B + c + 1) 0 zs).toInt = sumZ zs :=
  machineAccumulate_exact _ zs (by omega) (coefficient_width_sufficient zs B c hterm hcount)

/-- Signed machine accumulation refines the reference at its actual alignment quantum. -/
def PreparedBlock.machineAccumulator (b : PreparedBlock) (w : Nat) : Rat :=
  ((machineAccumulate w 0 b.coefficients).toInt : Rat) * pow2 b.quantumExponent

theorem machineAccumulator_eq (b : PreparedBlock) (w : Nat) (hw : 0 < w)
    (h : magnitudeSum b.coefficients < 2 ^ (w - 1)) :
    b.machineAccumulator w = b.accumulator := by
  unfold PreparedBlock.machineAccumulator PreparedBlock.accumulator
  rw [machineAccumulate_exact w b.coefficients hw h]

end TensorCore
