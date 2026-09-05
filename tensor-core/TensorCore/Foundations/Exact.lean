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

def sumQ : List Rat → Rat
  | [] => 0
  | x :: xs => x + sumQ xs

def sumZ : List Int → Int
  | [] => 0
  | x :: xs => x + sumZ xs

def absQ (x : Rat) : Rat := if x < 0 then -x else x

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
