import Std
import Init.Data.Rat
import Init.GrindInstances.Ring.Rat

deriving instance DecidableEq for Except

/-! Exact rational arithmetic over integer/dyadic inputs. No native `Float` operations. -/
namespace TensorCore

def pow2 (e : Int) : Rat := (2 : Rat) ^ e

theorem pow2_add (e f : Int) : pow2 (e + f) = pow2 e * pow2 f :=
  Rat.zpow_add (by decide) e f

theorem pow2_pos (e : Int) : 0 < pow2 e := Rat.zpow_pos (by decide)

theorem pow2_natCast (n : Nat) : pow2 (n : Int) = ((2 ^ n : Nat) : Rat) := by
  unfold pow2; rw [Rat.zpow_natCast]; simp

theorem pow2_one : pow2 1 = 2 := Rat.zpow_one 2

theorem pow2_succ (e : Int) : pow2 (e + 1) = pow2 e * 2 := by rw [pow2_add, pow2_one]

theorem pow2_lt_succ (e : Int) : pow2 e < pow2 (e + 1) := by
  rw [pow2_succ]; have := pow2_pos e; grind

/-- Monotonicity of the binary grid in its exponent. -/
theorem pow2_le_of_le {e f : Int} (h : e ≤ f) : pow2 e ≤ pow2 f := by
  have hd : (f - e).toNat = (f - e) := by omega
  have : pow2 f = pow2 e * pow2 ((f - e).toNat : Int) := by
    rw [← pow2_add]; congr 1; omega
  rw [this, pow2_natCast]
  have hp := pow2_pos e
  have h1 : (1 : Rat) ≤ ((2 ^ (f - e).toNat : Nat) : Rat) :=
    Rat.natCast_le_natCast.mpr (Nat.one_le_two_pow)
  have := Rat.mul_le_mul_of_nonneg_left h1 (Rat.le_of_lt hp)
  grind

def sumQ : List Rat → Rat
  | [] => 0
  | x :: xs => x + sumQ xs

def sumZ : List Int → Int
  | [] => 0
  | x :: xs => x + sumZ xs

def absQ (x : Rat) : Rat := if x < 0 then -x else x

theorem absQ_nonneg (x : Rat) : 0 ≤ absQ x := by unfold absQ; split <;> grind
theorem absQ_le_iff (x c : Rat) : absQ x ≤ c ↔ -c ≤ x ∧ x ≤ c := by unfold absQ; split <;> grind
theorem absQ_lt_iff (x c : Rat) : absQ x < c ↔ -c < x ∧ x < c := by unfold absQ; split <;> grind
theorem absQ_neg (x : Rat) : absQ (-x) = absQ x := by unfold absQ; split <;> split <;> grind
theorem absQ_sub_comm (x y : Rat) : absQ (x - y) = absQ (y - x) := by
  unfold absQ; split <;> split <;> grind
theorem absQ_mul_pos (x q : Rat) (hq : 0 < q) : absQ (x * q) = absQ x * q := by
  unfold absQ
  by_cases hx : x < 0
  · have : x * q < 0 := by
      have := Rat.mul_lt_mul_of_pos_right hx hq; simpa using this
    simp [hx, this]; grind
  · have hx' : 0 ≤ x := by grind
    have : ¬ (x * q < 0) := by
      have := Rat.mul_nonneg hx' (Rat.le_of_lt hq); grind
    simp [hx, this]
theorem absQ_of_nonneg {x : Rat} (h : 0 ≤ x) : absQ x = x := by unfold absQ; split <;> grind
theorem absQ_of_neg {x : Rat} (h : x < 0) : absQ x = -x := by unfold absQ; split <;> grind

/-- Signed magnitude truncation. Division is applied to a nonnegative magnitude. -/
def truncCoeff (x : Rat) (e : Int) : Int :=
  if x < 0 then -((-x / pow2 e).floor) else (x / pow2 e).floor

def truncGrid (x : Rat) (e : Int) : Rat := (truncCoeff x e : Rat) * pow2 e

theorem sum_coefficients (zs : List Int) (q : Rat) :
    sumQ (zs.map fun (z : Int) => (z : Rat) * q) = (sumZ zs : Rat) * q := by
  induction zs with
  | nil => simp [sumQ, sumZ]
  | cons z zs ih => simp [sumQ, sumZ, ih, Rat.add_mul]

end TensorCore
