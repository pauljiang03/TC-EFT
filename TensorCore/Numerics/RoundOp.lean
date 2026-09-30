import TensorCore.Numerics.Encoding

namespace TensorCore

inductive RoundingMode where
  | towardZero
  | nearestEven
  deriving Repr, DecidableEq

def emin32 : ℤ := -126
def maxFinite32 : ℚ := (2 ^ 24 - 1 : ℕ) * pow2 104

/-- Nearest integer with ties to even: floor, then a doubled-remainder comparison. -/
def rneInt (t : ℚ) : ℤ :=
  if 1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1) then t.floor + 1
  else t.floor

/-- Integer coefficient selected on a nonnegative scaled magnitude. -/
def roundCoefficient : RoundingMode → ℚ → ℤ
  | .towardZero, t => t.floor
  | .nearestEven, t => rneInt t

/-- Called on positive magnitudes only; the public converter branches on zero first. -/
def magnitudeExponent (x : ℚ) : ℤ :=
  let e : ℤ := (x.num.natAbs.log2 : ℤ) - (x.den.log2 : ℤ)
  if x < pow2 e then e - 1 else e

/-- Bit pattern for sign, exponent `e`, and coefficient `k` on `2^(e-23)`. -/
def encode32 (negative : Bool) (e k : ℤ) : F32 :=
  BitVec.ofNat 32 ((if negative then 2 ^ 31 else 0) +
    (if k < 2 ^ 23 then k.toNat else (e + 127).toNat * 2 ^ 23 + (k - 2 ^ 23).toNat))

/-- Exponent selected for a positive magnitude, clamped to the subnormal range. -/
def convExp (m : ℚ) : ℤ := max (magnitudeExponent m) emin32

/-- Coefficient selected on the grid `2^(convExp m - 23)`. -/
def convCoeff (mode : RoundingMode) (m : ℚ) : ℤ :=
  roundCoefficient mode (m / pow2 (convExp m - 23))

/-- A coefficient of `2^24` carries into the next binade. -/
def carry (e k : ℤ) : ℤ × ℤ := if k = 2 ^ 24 then (e + 1, k / 2) else (e, k)

/-- Conversion core. -/
def round32Core (mode : RoundingMode) (x : ℚ) : Option F32 :=
  if x = 0 then some 0
  else
    let (e', k') := carry (convExp (absQ x)) (convCoeff mode (absQ x))
    if e' > 127 then none else some (encode32 (decide (x < 0)) e' k')

/-- Finite-range reference conversion. -/
def round32 (mode : RoundingMode) (x : ℚ) : Option F32 :=
  if absQ x > maxFinite32 then none else round32Core mode x

/-- Exponent of the quantum of an encoded output: `E - 150` for a normal encoding with exponent field `E`, and `-149` for a subnormal or zero encoding. -/
def outputQuantumExponent (b : F32) : ℤ :=
  max (((b.toNat / 2 ^ 23 % 2 ^ 8 : ℕ) : ℤ) - 127) emin32 - 23

/-- Success in the public conversion implies the *accumulator* range condition. -/
theorem round32_range {mode : RoundingMode} {x : ℚ} {b : F32}
    (h : round32 mode x = some b) : absQ x ≤ maxFinite32 := by
  unfold round32 at h
  split at h
  · contradiction
  · grind

def magnitudeRounded (mode : RoundingMode) (m : ℚ) : ℚ :=
  (convCoeff mode m : ℚ) * pow2 (convExp m - 23)

def signedRounded (mode : RoundingMode) (x : ℚ) : ℚ :=
  if x < 0 then -magnitudeRounded mode (absQ x) else magnitudeRounded mode (absQ x)

/-- Independent mathematical contract: finite result, nearest finite value, and an even low encoding bit whenever another distinct value is equally near. -/
def NearestEven32 (x : ℚ) (b : F32) : Prop :=
  ∃ d : ℚ, value32 b = some d ∧
    (∀ y : ℚ, FiniteValue32 y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : ℚ, FiniteValue32 y → y ≠ d →
      absQ (x - y) = absQ (x - d) → b.toNat % 2 = 0)

end TensorCore
