import TensorCore.IEEE.LeanBridge
import TensorCore.IEEE.LeanRounding64

/-! Binary64 representation and operation bridges to Lean Float. The exact
references are retained; generic rounding and alignment proofs are reused. -/

namespace TensorCore.IEEE.LeanBridge

set_option maxRecDepth 4096
open Float.Model.UnpackedFloat
abbrev F64 := BitVec 64

abbrev Native64Valid (bits : F64) : Prop := Float.Model.Format.binary64.Valid bits

def toNative64 (bits : F64) (h : Native64Valid bits) : Float :=
  .ofModel ⟨UInt64.ofBitVec bits, h⟩

def fromNative64 (x : Float) : F64 := x.toBits.toBitVec

theorem from_toNative64 (bits : F64) (h : Native64Valid bits) :
    fromNative64 (toNative64 bits h) = bits := rfl

theorem to_fromNative64 (x : Float) :
    toNative64 (fromNative64 x) x.toModel.valid = x := rfl

def sign64 (a : F64) : Bool := a.toNat / 9223372036854775808 != 0

theorem unpackExponent64_toNat (a : F64) :
    (unpackExponent (spec := Float.Model.Format.binary64) a).toNat = a.toNat / 4503599627370496 % 2048 := by
  simp only [unpackExponent, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]

theorem unpackMantissa64_toNat (a : F64) :
    (unpackMantissa (spec := Float.Model.Format.binary64) a).toNat = a.toNat % 4503599627370496 := by
  simp only [unpackMantissa, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  simp

theorem unpackSign64_eq (a : F64) :
    Sign.ofBitVec (unpackSign (spec := Float.Model.Format.binary64) a) = nativeSign (sign64 a) := by
  have hs : (unpackSign (spec := Float.Model.Format.binary64) a).toNat = a.toNat / 9223372036854775808 := by
    simp only [unpackSign, BitVec.toNat_cast, BitVec.extractLsb, BitVec.extractLsb', BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
    have ha := a.isLt
    change a.toNat / 9223372036854775808 % 2 = a.toNat / 9223372036854775808
    omega
  have hz : unpackSign (spec := Float.Model.Format.binary64) a = 0 ↔ a.toNat / 9223372036854775808 = 0 := by
    constructor
    · intro h
      have h' := congrArg BitVec.toNat h
      rw [hs] at h'
      exact h'
    · intro h
      apply BitVec.eq_of_toNat_eq
      rw [hs, h]
      rfl
  unfold Sign.ofBitVec nativeSign
  change (if _ = 0 then Sign.positive else Sign.negative) =
    (if (a.toNat / 9223372036854775808 != 0) = true then Sign.negative else Sign.positive)
  by_cases h : a.toNat / 9223372036854775808 = 0
  · rw [if_pos (hz.mpr h)]
    simp [h]
  · rw [if_neg (fun h' => h (hz.mp h'))]
    simp [h]

theorem native64Valid_finite (a : F64) (h : a.toNat / 4503599627370496 % 2048 < 2047) : Native64Valid a := by
  constructor
  intro he _
  have hnat := congrArg BitVec.toNat he
  rw [unpackExponent64_toNat] at hnat
  change a.toNat / 4503599627370496 % 2048 = 2047 at hnat
  omega

def mantissa64 (a : F64) : Nat :=
  if a.toNat / 4503599627370496 % 2048 = 0 then a.toNat % 4503599627370496 else 4503599627370496 + a.toNat % 4503599627370496

def exponent64 (a : F64) : Int :=
  if a.toNat / 4503599627370496 % 2048 = 0 then -1074 else (a.toNat / 4503599627370496 % 2048 : Int) - 1075

def NonzeroFinite64 (a : F64) : Prop := a.toNat / 4503599627370496 % 2048 < 2047 ∧ 0 < mantissa64 a

instance (a : F64) : Decidable (NonzeroFinite64 a) := inferInstanceAs (Decidable (_ ∧ _))

theorem unpack64_nonzero (a : F64) (h : NonzeroFinite64 a) :
    unpack Float.Model.Format.binary64 a =
      .finite (nativeSign (sign64 a)) (mantissa64 a) (exponent64 a) h.2 := by
  have heMax : unpackExponent (spec := Float.Model.Format.binary64) a ≠ -1#11 := by
    intro he
    have hn := congrArg BitVec.toNat he
    rw [unpackExponent64_toNat] at hn
    change a.toNat / 4503599627370496 % 2048 = 2047 at hn
    have := h.1
    omega
  have heZero : unpackExponent (spec := Float.Model.Format.binary64) a = 0#11 ↔
      a.toNat / 4503599627370496 % 2048 = 0 := by
    constructor
    · intro he
      have hn := congrArg BitVec.toNat he
      rw [unpackExponent64_toNat] at hn
      exact hn
    · intro he
      apply BitVec.eq_of_toNat_eq
      rw [unpackExponent64_toNat, he]
      rfl
  have hcat : (1#1 ++ unpackMantissa (spec := Float.Model.Format.binary64) a).toNat =
      4503599627370496 + a.toNat % 4503599627370496 := by
    rw [BitVec.toNat_append,
      ← Nat.shiftLeft_add_eq_or_of_lt (unpackMantissa (spec := Float.Model.Format.binary64) a).isLt,
      unpackMantissa64_toNat, Nat.shiftLeft_eq]
    rfl
  unfold unpack
  dsimp only
  rw [if_neg heMax]
  by_cases hz : a.toNat / 4503599627370496 % 2048 = 0
  · have hmZero : unpackMantissa (spec := Float.Model.Format.binary64) a ≠ 0#52 := by
      intro he
      have hn := congrArg BitVec.toNat he
      rw [unpackMantissa64_toNat] at hn
      have hm := h.2
      simp only [mantissa64, hz, ↓reduceIte] at hm
      change a.toNat % 4503599627370496 = 0 at hn
      omega
    rw [if_pos (heZero.mpr hz), dif_neg hmZero]
    simp only [unpackSign64_eq, unpackMantissa64_toNat, unpackExponent64_toNat,
      mantissa64, exponent64, hz, ↓reduceIte]
    rfl
  · rw [if_neg (fun he => hz (heZero.mp he))]
    simp only [unpackSign64_eq, unpackExponent64_toNat, hcat,
      mantissa64, exponent64, hz, ↓reduceIte]
    rfl

theorem decode64_nonzero (a : F64) (h : NonzeroFinite64 a) :
    decode .binary64 a = .finite (sign64 a)
      ((nativeSign (sign64 a) |>.apply (mantissa64 a) : Int) * pow2 (exponent64 a)) := by
  have heMax : a.toNat / 4503599627370496 % 2048 ≠ 2047 := by have := h.1; omega
  by_cases he : a.toNat / 4503599627370496 % 2048 = 0
  · have hm : a.toNat % 4503599627370496 ≠ 0 := by
      have := h.2
      simp only [mantissa64, he, ↓reduceIte] at this
      omega
    simp [decode, classify, classifyNat, BinaryFormat.layout, fp64, he, hm,
      mantissa64, exponent64, sign, binarySign, sign64, nativeSign, Sign.apply, Decoded.value]
    split <;> rfl
  · simp [decode, classify, classifyNat, BinaryFormat.layout, fp64, heMax, he,
      mantissa64, exponent64, sign, binarySign, sign64, nativeSign, Sign.apply, Decoded.value]
    by_cases hs : 9223372036854775808 ≤ a.toNat <;> simp only [hs, ↓reduceIte]
    all_goals congr 2 <;> omega

theorem packComponents64_eq (negative : Bool) (e : BitVec 11) (m : BitVec 52) :
    packComponents Float.Model.Format.binary64 (nativeSign negative) e m =
      BitVec.ofNat 64 ((if negative then 2 ^ 63 else 0) + e.toNat * 2 ^ 52 + m.toNat) := by
  have appendNat {n k : Nat} (a : BitVec n) (b : BitVec k) :
      (a ++ b).toNat = a.toNat * 2 ^ k + b.toNat := by
    rw [BitVec.toNat_append, ← Nat.shiftLeft_add_eq_or_of_lt b.isLt, Nat.shiftLeft_eq]
  change (nativeSign negative).toBitVec ++ e ++ m = BitVec.ofNat 64 _
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ofNat]
  cases negative <;>
    simp only [nativeSign, Bool.false_eq_true, ↓reduceIte,
      Sign.toBitVec, appendNat, BitVec.toNat_ofNat]
  all_goals omega

theorem packZero64_eq (negative : Bool) :
    pack Float.Model.Format.binary64 (.zero (nativeSign negative)) = zero .binary64 negative := by
  rw [pack, packedZero, packComponents64_eq]
  cases negative <;> rfl

theorem encodeZero64_eq (negative : Bool) (e : Int) :
    encodeBinary fp64 negative e 0 = zero .binary64 negative := by
  change BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) + 0) = _
  cases negative <;> rfl

theorem packFinite64_eq (negative : Bool) (e : Int) (k : Nat)
    (hk : 0 < k) (hu : k < 2 ^ 53) (he : -1022 ≤ e) (he' : e ≤ 1023) :
    pack Float.Model.Format.binary64 (.finite (nativeSign negative) k (e - 52) hk) =
      encodeBinary fp64 negative e (k : Int) := by
  have hb : e - 52 + 1023 + 52 = e + 1023 := by omega
  have hlo : (e + 1023).toNat ≤ 2046 := by omega
  have hn : k.log2 + 1 = 53 ↔ 2 ^ 52 ≤ k := by
    have hlog := Nat.log2_eq_iff (show k ≠ 0 by omega) (k := 52)
    omega
  change (if 2048 ≤ (e - 52 + 1023 + 52).toNat + 1 then
    packedInfinity Float.Model.Format.binary64 (nativeSign negative)
    else if k.log2 + 1 = 53 then
      packComponents Float.Model.Format.binary64 (nativeSign negative)
        (BitVec.ofNat 11 (e - 52 + 1023 + 52).toNat) (BitVec.ofNat 52 k)
    else packComponents Float.Model.Format.binary64 (nativeSign negative)
        0 (BitVec.ofNat 52 k)) = _
  rw [hb]
  rw [if_neg (by omega)]
  by_cases hnormal : 2 ^ 52 ≤ k
  · rw [if_pos (hn.mpr hnormal), packComponents64_eq]
    change BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
      ((e + 1023).toNat % 2048) * 4503599627370496 + k % 4503599627370496) =
      BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
        (if (k : Int) < 4503599627370496 then k else
          (e + 1023).toNat * 4503599627370496 + ((k : Int) - 4503599627370496).toNat))
    rw [if_neg (show ¬ (k : Int) < 4503599627370496 from by omega)]
    congr 1
    omega
  · rw [if_neg (fun h => hnormal (hn.mp h)), packComponents64_eq]
    change BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
      0 * 4503599627370496 + k % 4503599627370496) =
      BitVec.ofNat 64 ((if negative then 9223372036854775808 else 0) +
        (if (k : Int) < 4503599627370496 then k else
          (e + 1023).toNat * 4503599627370496 + ((k : Int) - 4503599627370496).toNat))
    rw [if_pos (show (k : Int) < 4503599627370496 from by omega)]
    congr 1
    omega

theorem packRound64_eq (negative : Bool) (m : Nat) (e : Int) (hm : 0 < m)
    (hr : (m : Rat) * pow2 e ≤ fp64.maxFinite) :
    let x := (m : Rat) * pow2 e
    let E := binaryConvExp fp64 x
    let K := rneInt (x / pow2 (E - 52))
    pack Float.Model.Format.binary64
      (Float.Model.UnpackedFloat.round Float.Model.Format.binary64 (nativeSign negative) m e) =
        encodeBinary fp64 negative (binaryCarry fp64 E K).1 (binaryCarry fp64 E K).2 := by
  intro x E K
  let q := Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)
  let d := decreaseExponent m e q
  let first := shiftToTargetExponent Float.Model.Format.binary64 d.1 d.2 .exact
  let k := first.1.roundedMantissa
  have hf : first.2 = q ∧ (k : Int) = rneInt (x / pow2 q) := firstPass64 m e hm
  have hq : q = E - 52 := targetExponent64_eq m e hm
  have hk : (k : Int) = K := by simpa only [hq] using hf.2
  have hx : 0 < x := Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
  have he := binaryConvExp_bounds fp64 (by decide) x hx hr
  have hb := binaryConvCoeff_bounds fp64 (by decide) .nearestEven negative x hx hr
  change 0 ≤ K ∧ K ≤ 9007199254740992 ∧ (4503599627370496 ≤ K ∨ E = -1022) ∧
    (E = 1023 → K ≤ 9007199254740991) at hb
  have hEl : -1022 ≤ E := he.1
  have hEu : E ≤ 1023 := he.2.1
  have hku : k ≤ 2 ^ 53 := by omega
  have hql : -1074 ≤ q := by omega
  change pack Float.Model.Format.binary64
    (if h : (shiftToTargetExponent Float.Model.Format.binary64 k first.2 .exact).1.mantissa = 0 then
      .zero (nativeSign negative)
    else .finite (nativeSign negative)
      (shiftToTargetExponent Float.Model.Format.binary64 k first.2 .exact).1.mantissa
      (shiftToTargetExponent Float.Model.Format.binary64 k first.2 .exact).2
      (Nat.pos_of_ne_zero h)) = _
  rw [hf.1, secondPass64 k q hku hql]
  by_cases hc : k = 2 ^ 53
  · have hK : K = 9007199254740992 := by omega
    have hE : E + 1 ≤ 1023 := by omega
    rw [if_pos hc]
    simp only [show (2 ^ 52 : Nat) ≠ 0 from by decide, ↓reduceDIte]
    rw [show q + 1 = (E + 1) - 52 from by omega]
    rw [packFinite64_eq negative (E + 1) (2 ^ 52) (by decide) (by decide) (by omega) hE]
    simp only [binaryCarry, fp64, hK]
    rfl
  · rw [if_neg hc]
    have hK : K ≠ 9007199254740992 := by omega
    have hcarry : binaryCarry fp64 E K = (E, K) := by
      change (if K = 9007199254740992 then _ else _) = _
      rw [if_neg hK]
    rw [hcarry]
    by_cases hz : k = 0
    · rw [dif_pos hz, packZero64_eq]
      have hK0 : K = 0 := by omega
      rw [hK0]
      exact (encodeZero64_eq negative E).symm
    · rw [dif_neg hz, hq]
      rw [packFinite64_eq negative E k (by omega) (by omega) hEl hEu, hk]

theorem finiteBits64_encode (x : Rat) (hx : x ≠ 0) (hr : absQ x ≤ fp64.maxFinite) :
    finiteBits .binary64 .nearestEven x hr =
      let E := binaryConvExp fp64 (absQ x)
      let K := rneInt (absQ x / pow2 (E - 52))
      encodeBinary fp64 (decide (x < 0)) (binaryCarry fp64 E K).1 (binaryCarry fp64 E K).2 := by
  have h := finiteBits_eq .binary64 .nearestEven x hr
  change roundBinary fp64 .nearestEven x = some _ at h
  unfold roundBinary at h
  rw [if_neg (by decide : ¬ ¬ fp64.WellFormed), if_neg (Rat.not_lt.mpr hr), if_neg hx] at h
  dsimp only at h ⊢
  simp only [binaryCoefficient, show fp64.fractionBits = 52 from rfl] at h
  generalize hc : binaryCarry fp64 (binaryConvExp fp64 (absQ x))
    (rneInt (absQ x / pow2 (binaryConvExp fp64 (absQ x) - 52))) = c at h ⊢
  rcases c with ⟨E, K⟩
  change (if E > fp64.emax then none else some (encodeBinary fp64 (decide (x < 0)) E K)) = some _ at h
  split at h
  · contradiction
  · exact (Option.some.inj h).symm

theorem packRound64_reference (negative : Bool) (m : Nat) (e : Int) (hm : 0 < m)
    (tinyMode : Tininess) (hr : (m : Rat) * pow2 e ≤ fp64.maxFinite) :
    pack Float.Model.Format.binary64
      (Float.Model.UnpackedFloat.round Float.Model.Format.binary64 (nativeSign negative) m e) =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ negative
        (if negative then -((m : Rat) * pow2 e) else (m : Rat) * pow2 e)).bits := by
  have hx : 0 < (m : Rat) * pow2 e := Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
  have habs : absQ ((m : Rat) * pow2 e) = (m : Rat) * pow2 e := absQ_of_nonneg (Rat.le_of_lt hx)
  have hnabs : absQ (-((m : Rat) * pow2 e)) = (m : Rat) * pow2 e := by rw [absQ_neg, habs]
  have hne : (m : Rat) * pow2 e ≠ 0 := Rat.ne_of_gt hx
  have hnne : -((m : Rat) * pow2 e) ≠ 0 := by grind
  have hneg : -((m : Rat) * pow2 e) < 0 := by grind
  have hnneg : ¬ (m : Rat) * pow2 e < 0 := by grind
  rw [packRound64_eq negative m e hm hr]
  cases negative <;>
    simp only [Bool.false_eq_true, ↓reduceIte, TensorCore.IEEE.round,
      BinaryFormat.layout, hne, hnne, habs, hnabs, hr, ↓reduceDIte] <;>
    rw [finiteBits64_encode _ (by assumption) (by simpa only [habs, hnabs] using hr)] <;>
    simp only [habs, hnabs, hneg, hnneg, decide_true, decide_false]

theorem packNormalize64_reference (m : Int) (e : Int) (tinyMode : Tininess)
    (hr : absQ ((m : Rat) * pow2 e) ≤ fp64.maxFinite) :
    pack Float.Model.Format.binary64
      (normalize Float.Model.Format.binary64 m e .positive) =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
        ((m : Rat) * pow2 e)).bits := by
  by_cases hz : m = 0
  · subst m
    rw [show (normalize Float.Model.Format.binary64 0 e .positive) = .zero .positive from rfl]
    simp only [Rat.intCast_zero, Rat.zero_mul, round_zero]
    exact packZero64_eq false
  by_cases hn : m < 0
  · have hm : 0 < (-m).toNat := by omega
    have hcast : (((-m).toNat : Nat) : Rat) = -(m : Rat) := by
      rw [← Rat.intCast_natCast, Int.toNat_of_nonneg (by omega), Rat.intCast_neg]
    have hvalue : ((m : Rat) * pow2 e) = -((((-m).toNat : Nat) : Rat) * pow2 e) := by
      rw [hcast]; grind
    have hp : 0 < (((-m).toNat : Nat) : Rat) * pow2 e :=
      Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
    have hrange : (((-m).toNat : Nat) : Rat) * pow2 e ≤ fp64.maxFinite := by
      simpa only [hvalue, absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
    have h := packRound64_reference true (-m).toNat e hm tinyMode hrange
    simp only [nativeSign, ↓reduceIte] at h
    rw [normalize, Int.compare_eq_lt.mpr hn]
    rw [h]
    rw [hvalue]
    have hne : -((((-m).toNat : Nat) : Rat) * pow2 e) ≠ 0 := by grind
    simp only [TensorCore.IEEE.round, hne, ↓reduceIte]
    rfl
  · have hm : 0 < m.toNat := by omega
    have hcast : ((m.toNat : Nat) : Rat) = (m : Rat) := by
      rw [← Rat.intCast_natCast, Int.toNat_of_nonneg (by omega)]
    have hp : 0 < (m : Rat) * pow2 e := by
      rw [← hcast]
      exact Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos e)
    have hrange : ((m.toNat : Nat) : Rat) * pow2 e ≤ fp64.maxFinite := by
      simpa only [hcast, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
    have h := packRound64_reference false m.toNat e hm tinyMode hrange
    simp only [nativeSign, Bool.false_eq_true, ↓reduceIte, hcast] at h
    rw [normalize, Int.compare_eq_gt.mpr (by omega)]
    exact h

def finiteValue64 (a : F64) : Rat :=
  (nativeSign (sign64 a) |>.apply (mantissa64 a) : Int) * pow2 (exponent64 a)

def nativeAdd64 (a b : F64) (ha : Native64Valid a) (hb : Native64Valid b) : F64 :=
  fromNative64 (toNative64 a ha + toNative64 b hb)

theorem nativeAdd64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a + finiteValue64 b) ≤ fp64.maxFinite) :
    nativeAdd64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.add .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.add Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.add]
  have hv := aligned_add_value (nativeSign (sign64 a)) (nativeSign (sign64 b))
    (mantissa64 a) (mantissa64 b) (exponent64 a) (exponent64 b)
  have hround := packNormalize64_reference
    ((nativeSign (sign64 a)).apply
      (decreaseExponent (mantissa64 a) (exponent64 a) (min (exponent64 a) (exponent64 b))).1 +
     (nativeSign (sign64 b)).apply
      (decreaseExponent (mantissa64 b) (exponent64 b) (min (exponent64 a) (exponent64 b))).1)
    (min (exponent64 a) (exponent64 b)) tinyMode (by simpa only [hv, finiteValue64] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue64 a + finiteValue64 b)).bits =
    (addDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b)).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue64 a + finiteValue64 b)).bits =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign64 a) (sign64 b))
        (finiteValue64 a + finiteValue64 b)).bits
  cases sa : sign64 a <;> cases sb : sign64 b
  all_goals try rfl
  have hpa : 0 < (mantissa64 a : Rat) * pow2 (exponent64 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa64 b : Rat) * pow2 (exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue64 a + finiteValue64 b ≠ 0 := by
    simp only [finiteValue64, sa, sb, nativeSign, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]

def nativeSub64 (a b : F64) (ha : Native64Valid a) (hb : Native64Valid b) : F64 :=
  fromNative64 (toNative64 a ha - toNative64 b hb)

theorem nativeSub64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a - finiteValue64 b) ≤ fp64.maxFinite) :
    nativeSub64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.sub .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.sub Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.sub]
  have hv := aligned_sub_value (nativeSign (sign64 a)) (nativeSign (sign64 b))
    (mantissa64 a) (mantissa64 b) (exponent64 a) (exponent64 b)
  have hround := packNormalize64_reference
    ((nativeSign (sign64 a)).apply
      (decreaseExponent (mantissa64 a) (exponent64 a) (min (exponent64 a) (exponent64 b))).1 -
     (nativeSign (sign64 b)).apply
      (decreaseExponent (mantissa64 b) (exponent64 b) (min (exponent64 a) (exponent64 b))).1)
    (min (exponent64 a) (exponent64 b)) tinyMode (by simpa only [hv, finiteValue64] using hr)
  rw [hround, hv]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
      (finiteValue64 a - finiteValue64 b)).bits =
    (addDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b).negate).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
  rw [← Rat.sub_eq_add_neg]
  change (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩ false
    (finiteValue64 a - finiteValue64 b)).bits =
      (TensorCore.IEEE.round .binary64 ⟨.nearestEven, tinyMode⟩
        (sumZeroSign .nearestEven (sign64 a) (!(sign64 b)))
        (finiteValue64 a - finiteValue64 b)).bits
  cases sa : sign64 a <;> cases sb : sign64 b
  all_goals try rfl
  have hpa : 0 < (mantissa64 a : Rat) * pow2 (exponent64 a) :=
    Rat.mul_pos (Rat.natCast_pos.mpr ha.2) (pow2_pos _)
  have hpb : 0 < (mantissa64 b : Rat) * pow2 (exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hb.2) (pow2_pos _)
  have hne : finiteValue64 a - finiteValue64 b ≠ 0 := by
    simp only [finiteValue64, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte, Sign.apply,
      Rat.intCast_neg, Rat.intCast_natCast]
    grind
  simp only [TensorCore.IEEE.round, hne, ↓reduceIte]

theorem mantissa64_normal_or_min (a : F64) :
    2 ^ 52 ≤ mantissa64 a ∨ exponent64 a = -1074 := by
  by_cases h : a.toNat / 4503599627370496 % 2048 = 0
  · exact Or.inr (by simp [exponent64, h])
  · left
    simp only [mantissa64, h, ↓reduceIte]
    omega

theorem product64_no_leftshift (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) :
    exponent64 a + exponent64 b ≤ Float.Model.Format.binary64.targetExponent
      (Float.Model.totalExponent (mantissa64 a * mantissa64 b) (exponent64 a + exponent64 b)) := by
  have hp : 0 < mantissa64 a * mantissa64 b := Nat.mul_pos ha.2 hb.2
  have hma : mantissa64 a ≤ mantissa64 a * mantissa64 b := by
    have hh := Nat.mul_le_mul_left (mantissa64 a) (show 1 ≤ mantissa64 b by have := hb.2; omega)
    simpa using hh
  have hmb : mantissa64 b ≤ mantissa64 a * mantissa64 b := by
    have hh := Nat.mul_le_mul_right (mantissa64 b) (show 1 ≤ mantissa64 a by have := ha.2; omega)
    simpa using hh
  change exponent64 a + exponent64 b ≤
    max ((mantissa64 a * mantissa64 b).log2 + 1 + (exponent64 a + exponent64 b) - 53) (-1074 : Int)
  rcases mantissa64_normal_or_min a with h | h
  · have hl := (Nat.le_log2 (show mantissa64 a * mantissa64 b ≠ 0 by omega)).mpr (Nat.le_trans h hma)
    omega
  · rcases mantissa64_normal_or_min b with h' | h'
    · have hl := (Nat.le_log2 (show mantissa64 a * mantissa64 b ≠ 0 by omega)).mpr (Nat.le_trans h' hmb)
      omega
    · omega

theorem roundWithAccuracy_eq_round64 (s : Sign) (m : Nat) (e : Int)
    (h : e ≤ Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)) :
    roundWithAccuracy Float.Model.Format.binary64 s m e .exact =
      Float.Model.UnpackedFloat.round Float.Model.Format.binary64 s m e := by
  have hn : (e - Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)).toNat = 0 := by omega
  simp [Float.Model.UnpackedFloat.round, decreaseExponent, hn]

theorem finiteValue64_mul (a b : F64) :
    finiteValue64 a * finiteValue64 b =
      if xor (sign64 a) (sign64 b) then
        -(((mantissa64 a * mantissa64 b : Nat) : Rat) * pow2 (exponent64 a + exponent64 b))
      else ((mantissa64 a * mantissa64 b : Nat) : Rat) * pow2 (exponent64 a + exponent64 b) := by
  cases sa : sign64 a <;> cases sb : sign64 b <;>
    simp only [finiteValue64, sa, sb, nativeSign, Bool.false_eq_true, ↓reduceIte,
      Sign.apply, Rat.intCast_neg, Rat.intCast_natCast, Rat.natCast_mul, pow2_add,
      Bool.false_xor, Bool.true_xor, Bool.not_false, Bool.not_true] <;> grind

def nativeMul64 (a b : F64) (ha : Native64Valid a) (hb : Native64Valid b) : F64 :=
  fromNative64 (toNative64 a ha * toNative64 b hb)

theorem nativeMul64_reference (a b : F64) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (tinyMode : Tininess) (hr : absQ (finiteValue64 a * finiteValue64 b) ≤ fp64.maxFinite) :
    nativeMul64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1) =
      (TensorCore.IEEE.mul .binary64 ⟨.nearestEven, tinyMode⟩ a b).bits := by
  have hm := Nat.mul_pos ha.2 hb.2
  have hp : 0 < ((mantissa64 a * mantissa64 b : Nat) : Rat) * pow2 (exponent64 a + exponent64 b) :=
    Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos _)
  have hrange : ((mantissa64 a * mantissa64 b : Nat) : Rat) *
      pow2 (exponent64 a + exponent64 b) ≤ fp64.maxFinite := by
    rw [finiteValue64_mul] at hr
    split at hr <;> simpa only [absQ_neg, absQ_of_nonneg (Rat.le_of_lt hp)] using hr
  change pack Float.Model.Format.binary64
    (Float.Model.UnpackedFloat.mul Float.Model.Format.binary64
      (unpack Float.Model.Format.binary64 a) (unpack Float.Model.Format.binary64 b)) = _
  rw [unpack64_nonzero a ha, unpack64_nonzero b hb]
  simp only [Float.Model.UnpackedFloat.mul]
  rw [nativeSign_mul, roundWithAccuracy_eq_round64 _ _ _ (product64_no_leftshift a b ha hb),
    packRound64_reference _ _ _ hm tinyMode hrange, ← finiteValue64_mul]
  change (round .binary64 ⟨.nearestEven, tinyMode⟩ (xor (sign64 a) (sign64 b))
    (finiteValue64 a * finiteValue64 b)).bits =
      (mulDatum .binary64 ⟨.nearestEven, tinyMode⟩ (decode .binary64 a) (decode .binary64 b)).bits
  rw [decode64_nonzero a ha, decode64_nonzero b hb]
  rfl

end TensorCore.IEEE.LeanBridge
