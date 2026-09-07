import TensorCore.Theory.Binary.ScalarSum
import TensorCore.Semantics.Conversion

/-! Finite IEEE encodings and canonical signed representations. Unlike `Decoded`,
this representation retains the zero sign. Its exponent is `emin` for zero and
subnormals; normal significands include the implicit leading bit. -/

namespace TensorCore

/-- Canonical arithmetic data, including a sign for either zero. -/
structure BinaryRep (f : Format) where
  negative : Bool
  exponent : Int
  significand : Nat
  exponent_min : f.emin ≤ exponent
  exponent_max : exponent ≤ f.emax
  significand_lt : significand < 2 ^ (f.fractionBits + 1)
  normalized : 2 ^ f.fractionBits ≤ significand ∨ exponent = f.emin
  deriving DecidableEq

theorem BinaryRep.ext {f : Format} {a b : BinaryRep f}
    (hs : a.negative = b.negative) (he : a.exponent = b.exponent)
    (hk : a.significand = b.significand) : a = b := by
  cases a
  cases b
  simp_all

def BinaryRep.value {f : Format} (r : BinaryRep f) : Rat :=
  (if r.negative then -(r.significand : Rat) else r.significand) *
    pow2 (r.exponent - f.fractionBits)

def BinaryRep.encode {f : Format} (r : BinaryRep f) : BitVec f.width :=
  encodeBinary f r.negative r.exponent r.significand

theorem BinaryRep.encode_value {f : Format} (hf : f.WellFormed) (r : BinaryRep f) :
    binaryValue f r.encode = some r.value := by
  exact encodeBinary_value f hf r.negative r.exponent r.significand
    r.exponent_min r.exponent_max (by omega) (by have := r.significand_lt; omega)
    (by have := r.normalized; omega)

/-- Domain: exactly words whose IEEE classification is finite, with both zero words. -/
abbrev FiniteBinaryWord (f : Format) := { bits : BitVec f.width // ∃ d, (classify f bits).finite = some d }

def binarySign (f : Format) (bits : BitVec f.width) : Bool :=
  bits.toNat / 2 ^ (f.fractionBits + f.exponentBits) != 0

def binaryExponentField (f : Format) (bits : BitVec f.width) : Nat :=
  bits.toNat / 2 ^ f.fractionBits % 2 ^ f.exponentBits

theorem finiteBinaryWord_exponent {f : Format} (b : FiniteBinaryWord f) :
    binaryExponentField f b.val ≠ 2 ^ f.exponentBits - 1 := by
  obtain ⟨d, hd⟩ := b.property
  intro he
  unfold classify classifyNat at hd
  change b.val.toNat / 2 ^ f.fractionBits % 2 ^ f.exponentBits = _ at he
  simp only [he, ↓reduceIte] at hd
  split at hd <;> simp [Classification.finite] at hd

def decodeBinaryRep (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) : BinaryRep f :=
  { negative := binarySign f b.val
    exponent := if binaryExponentField f b.val = 0 then f.emin
      else (binaryExponentField f b.val : Int) - f.bias
    significand := if binaryExponentField f b.val = 0 then b.val.toNat % 2 ^ f.fractionBits
      else 2 ^ f.fractionBits + b.val.toNat % 2 ^ f.fractionBits
    exponent_min := by split <;> unfold Format.emin <;> omega
    exponent_max := by
      have ht := finiteBinaryWord_exponent b
      have hb := Nat.mod_lt (b.val.toNat / 2 ^ f.fractionBits) (Nat.two_pow_pos f.exponentBits)
      change binaryExponentField f b.val < 2 ^ f.exponentBits at hb
      split
      · exact f.emin_le_emax hf
      · unfold Format.emax; omega
    significand_lt := by
      have hm := Nat.mod_lt b.val.toNat (Nat.two_pow_pos f.fractionBits)
      rw [Nat.pow_succ]
      split <;> omega
    normalized := by split <;> simp_all }

def encodeBinaryRep (f : Format) (hf : f.WellFormed) (r : BinaryRep f) : FiniteBinaryWord f :=
  ⟨r.encode, by
    have h := r.encode_value hf
    unfold binaryValue at h
    cases hd : (classify f r.encode).finite with
    | none => simp [hd] at h
    | some d => exact ⟨d, rfl⟩⟩

/-- Field extraction for the existing generic encoder. -/
theorem encodeBinary_fields (f : Format) (hf : f.WellFormed) (r : BinaryRep f) :
    binarySign f r.encode = r.negative ∧
    binaryExponentField f r.encode =
      (if r.significand < 2 ^ f.fractionBits then 0 else (r.exponent + f.bias).toNat) ∧
    r.encode.toNat % 2 ^ f.fractionBits =
      (if r.significand < 2 ^ f.fractionBits then r.significand
       else r.significand - 2 ^ f.fractionBits) := by
  have hpay := encodeBinary_payload_lt f hf r.exponent r.significand
    (by omega) (by have := r.significand_lt; omega) r.exponent_min r.exponent_max
  have hnat := encodeBinary_toNat f hf r.negative r.exponent r.significand
    (by omega) (by have := r.significand_lt; omega) r.exponent_min r.exponent_max
  have hP := Nat.two_pow_pos f.fractionBits
  have hW := Nat.two_pow_pos f.exponentBits
  have hk := r.significand_lt
  rw [Nat.pow_succ] at hk
  have hE : (r.exponent + f.bias).toNat < 2 ^ f.exponentBits := by
    have := r.exponent_max
    unfold Format.emax at this
    omega
  unfold binarySign binaryExponentField
  rw [show r.encode.toNat = _ from hnat, Nat.pow_add]
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  have hsgn : ∀ pay, pay < P * W →
      ((if r.negative then P * W else 0) + pay) % P = pay % P ∧
      ((if r.negative then P * W else 0) + pay) / P % W = pay / P % W ∧
      (((if r.negative then P * W else 0) + pay) / (P * W) != 0) = r.negative := by
    intro pay hlt
    have hPW := Nat.mul_pos hP hW
    cases r.negative
    · simp [Nat.div_eq_of_lt hlt]
    · have h1 : (P * W + pay) / (P * W) = 1 := by
        rw [show P * W + pay = P * W * 1 + pay by omega,
          Nat.mul_add_div hPW, Nat.div_eq_of_lt hlt]
      simp only [↓reduceIte, Nat.mul_add_mod, Nat.mul_add_div hP, Nat.add_mod_left, h1]
      simp
  by_cases hsub : r.significand < P
  · rw [if_pos (show (r.significand : Int) < (P : Nat) by omega)] at hpay ⊢
    simp only [Int.toNat_natCast]
    obtain ⟨hfrac, hexp, hsign⟩ := hsgn r.significand hpay
    rw [hsign, hexp, hfrac, if_pos hsub, Nat.mod_eq_of_lt hsub, Nat.div_eq_of_lt hsub]
    simp [hsub]
  · rw [if_neg (show ¬(r.significand : Int) < (P : Nat) by omega)] at hpay ⊢
    have hcast : ((r.significand : Int) - (P : Nat)).toNat = r.significand - P := by omega
    rw [hcast] at hpay ⊢
    obtain ⟨hfrac, hexp, hsign⟩ := hsgn _ hpay
    rw [hsign, hexp, hfrac, if_neg hsub, Nat.mul_comm _ P,
      Nat.mul_add_mod, Nat.mul_add_div hP,
      Nat.mod_eq_of_lt (show r.significand - P < P by omega),
      Nat.div_eq_of_lt (show r.significand - P < P by omega), Nat.add_zero,
      Nat.mod_eq_of_lt hE]
    simp [hsub]

theorem decode_encodeBinaryRep (f : Format) (hf : f.WellFormed) (r : BinaryRep f) :
    decodeBinaryRep f hf (encodeBinaryRep f hf r) = r := by
  obtain ⟨hs, he, hk⟩ := encodeBinary_fields f hf r
  have hemin := r.exponent_min
  have hn := r.normalized
  have hP := Nat.two_pow_pos f.fractionBits
  have hE : (r.exponent + f.bias).toNat ≠ 0 := by unfold Format.emin at hemin; omega
  cases r with
  | mk s e k h1 h2 h3 h4 =>
    simp only [decodeBinaryRep, encodeBinaryRep, hs, he, hk]
    congr 1 <;> split <;> simp_all <;> omega

/-- Reassembling sign, exponent and fraction reproduces the original finite word. -/
theorem encode_decodeBinaryRep (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    encodeBinaryRep f hf (decodeBinaryRep f hf b) = b := by
  apply Subtype.ext
  change (decodeBinaryRep f hf b).encode = b.val
  apply BitVec.eq_of_toNat_eq
  let hr := decodeBinaryRep f hf b
  rw [show (decodeBinaryRep f hf b).encode.toNat = _ from
    encodeBinary_toNat f hf hr.negative hr.exponent hr.significand
      (by omega) (by have := hr.significand_lt; omega) hr.exponent_min hr.exponent_max]
  simp only [hr, decodeBinaryRep, binarySign, binaryExponentField, Nat.pow_add]
  dsimp +instances only [hr, decodeBinaryRep, binarySign, binaryExponentField]
  have hn := b.val.isLt
  have hwidth : 2 ^ f.width = 2 ^ (f.fractionBits + f.exponentBits) * 2 := by
    rw [show f.width = f.fractionBits + f.exponentBits + 1 by unfold Format.width; omega,
      Nat.pow_succ]
  rw [hwidth, Nat.pow_add] at hn
  have hP := Nat.two_pow_pos f.fractionBits
  have hW := Nat.two_pow_pos f.exponentBits
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  generalize hnv : b.val.toNat = n at *
  have hPW := Nat.mul_pos hP hW
  have hq : n / (P * W) < 2 := (Nat.div_lt_iff_lt_mul hPW).mpr (by omega)
  have hdecomp : n = (n / (P * W)) * (P * W) + (n / P % W) * P + n % P := by
    have h1 := Nat.div_add_mod n P
    have h2 := Nat.div_add_mod (n / P) W
    have h3 := congrArg (fun z => z * P) h2
    rw [Nat.div_div_eq_div_mul] at h3
    grind
  have hfrac := Nat.mod_lt n hP
  have hsign : (if (n / (P * W) != 0) then P * W else 0) = (n / (P * W) : Nat) * (P * W) := by
    by_cases hz : n / (P * W) = 0
    · simp [hz]
    · have ho : n / (P * W) = 1 := by
        generalize n / (P * W) = q at *
        omega
      simp [ho]
  rw [hsign]
  by_cases he : n / P % W = 0
  · simp only [he, ↓reduceIte]
    rw [if_pos (show ((n % P : Nat) : Int) < (P : Nat) by omega)]
    simp only [Int.toNat_natCast]
    simp only [he, Nat.zero_mul, Nat.add_zero] at hdecomp
    omega
  · simp only [he, ↓reduceIte]
    rw [if_neg (show ¬ ((P + n % P : Nat) : Int) < (P : Nat) by omega)]
    have hE : (((n / P % W : Nat) : Int) - f.bias + f.bias).toNat = n / P % W := by omega
    have hK : (((P + n % P : Nat) : Int) - (P : Nat)).toNat = n % P := by omega
    rw [hE, hK]
    omega

/-- An explicit bijection package, with executable functions and both inverse laws.
Lean core has no general-purpose `Equiv` structure. -/
structure BinaryBijection (α β : Type) where
  encode : α → β
  decode : β → α
  decode_encode : ∀ a, decode (encode a) = a
  encode_decode : ∀ b, encode (decode b) = b

def finiteBinaryBijection (f : Format) (hf : f.WellFormed) :
    BinaryBijection (BinaryRep f) (FiniteBinaryWord f) :=
  ⟨encodeBinaryRep f hf, decodeBinaryRep f hf,
    decode_encodeBinaryRep f hf, encode_decodeBinaryRep f hf⟩

theorem decodeBinaryRep_value (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    binaryValue f b.val = some (decodeBinaryRep f hf b).value := by
  have h := (decodeBinaryRep f hf b).encode_value hf
  have hb := congrArg Subtype.val (encode_decodeBinaryRep f hf b)
  change (decodeBinaryRep f hf b).encode = b.val at hb
  rwa [hb] at h

end TensorCore
