import TensorCore.Core.Exact

-- Binary formats and their exact decoded values.

namespace TensorCore

structure Format where
  fractionBits : ℕ
  exponentBits : ℕ
  bias : ℤ
  deriving Repr, DecidableEq

@[implicit_reducible] def fp16 : Format := ⟨10, 5, 15⟩
@[implicit_reducible] def fp32 : Format := ⟨23, 8, 127⟩
@[implicit_reducible] def Format.width (f : Format) : ℕ := 1 + f.exponentBits + f.fractionBits
abbrev F16 := BitVec 16
abbrev F32 := BitVec 32

/-- The integer significand is signed; scale remains the unnormalized input scale. -/
structure Decoded where
  significand : ℤ
  rawScale : ℤ
  fractionalBits : ℤ
  deriving Repr, DecidableEq

def Decoded.value (x : Decoded) : ℚ :=
  (x.significand : ℚ) * pow2 (x.rawScale - x.fractionalBits)

inductive Classification where
  | zero (negative : Bool)
  | subnormal (value : Decoded)
  | normal (value : Decoded)
  | infinity (negative : Bool)
  | nan
  deriving Repr, DecidableEq

/-- A nonempty normal range and at least one stored fraction bit. Bias is explicit. -/
def Format.WellFormed (f : Format) : Prop := 0 < f.fractionBits ∧ 1 < f.exponentBits

instance (f : Format) : Decidable f.WellFormed := inferInstanceAs (Decidable (_ ∧ _))

@[implicit_reducible] def bf16 : Format := ⟨7, 8, 127⟩
/-- Packed mathematical TF32 value format; register storage is defined separately. -/
@[implicit_reducible] def tf19 : Format := ⟨10, 8, 127⟩
@[implicit_reducible] def fp64 : Format := ⟨52, 11, 1023⟩
def e5m2 : Format := ⟨2, 5, 15⟩

def Format.emin (f : Format) : ℤ := 1 - f.bias
def Format.emax (f : Format) : ℤ := ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) - f.bias
def Format.maxFinite (f : Format) : ℚ :=
  ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) * pow2 (f.emax - f.fractionBits)

/-- A decoded significand, including a subnormal, has magnitude below two. -/
def Decoded.Bounded (d : Decoded) : Prop := absQ d.value < 2 * pow2 d.rawScale

/-- Arithmetic form of every finite FP32 value: an integer coefficient of magnitude below
`2^24` on the quantum `2^(e-23)` with `-126 ≤ e ≤ 127`. -/
def FiniteValue32 (z : ℚ) : Prop :=
  ∃ k e : ℤ, -126 ≤ e ∧ e ≤ 127 ∧ k.natAbs < 2 ^ 24 ∧ z = (k : ℚ) * pow2 (e - 23)

/-- Finite values of a format in arithmetic form. -/
def Format.FiniteValue (f : Format) (z : ℚ) : Prop :=
  ∃ k e : ℤ, f.emin ≤ e ∧ e ≤ f.emax ∧ k.natAbs < 2 ^ (f.fractionBits + 1) ∧
    z = (k : ℚ) * pow2 (e - f.fractionBits)

/-- An explicit bijection package, with executable functions and both inverse laws.
Lean core has no general-purpose `Equiv` structure. -/
structure BinaryBijection (α β : Type) where
  encode : α → β
  decode : β → α
  decode_encode : ∀ a, decode (encode a) = a
  encode_decode : ∀ b, encode (decode b) = b

end TensorCore
