-- Scalar Rounding for GEMM.

import TensorCore.Gemm.Specification.Scalar
import TensorCore.TC.Specification.Stages
import TensorCore.Core.Binary.RoundingContract

namespace TensorCore.PaperSpec

def scalarModeOf : BinaryRoundingMode → ScalarMode
  | .towardZero => .towardZero | .nearestEven => .nearestEven
  | .towardNegative => .towardNegative | .towardPositive => .towardPositive

theorem scalarValue_eq (f : Format) (b : BitVec f.width) :
    scalarValue (layoutOf f) b = binaryValue f b := by
  unfold scalarValue
  rw [decode_eq]
  simp only [Option.map_map]
  rfl

theorem scalarSign_eq (f : Format) (b : BitVec f.width) :
    scalarSign (layoutOf f) b = binarySign f b := rfl

theorem scalarCoefficient_eq (mode : BinaryRoundingMode) (negative : Bool) (x : ℚ) :
    scalarCoefficient (scalarModeOf mode) negative x = binaryCoefficient mode negative x := by
  cases mode <;> rfl

theorem scalarExponent_unique (f : Format) (x : ℚ) (a b : ℤ)
    (ha : ScalarExponent (layoutOf f) x a) (hb : ScalarExponent (layoutOf f) x b) : a = b := by
  obtain ⟨hal, _, hau, had⟩ := ha
  obtain ⟨hbl, _, hbu, hbd⟩ := hb
  by_cases hab : a < b
  · have hp := pow2_le_of_le (show a + 1 ≤ b by omega)
    change pow2 b ≤ x ∨ b = _ at hbd
    change x < pow2 (a + 1) at hau
    rcases hbd with h | h <;> grind
  · by_cases hba : b < a
    · have hp := pow2_le_of_le (show b + 1 ≤ a by omega)
      change pow2 a ≤ x ∨ a = _ at had
      change x < pow2 (b + 1) at hbu
      rcases had with h | h <;> grind
    · omega

theorem scalarGridValue_eq (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    scalarGridValue (layoutOf f) (scalarModeOf mode) x (binaryConvExp f (absQ x)) =
      binarySignedRounded f mode x := by
  by_cases hx : x < 0 <;>
    simp [scalarGridValue, scalarCoefficient_eq, binarySignedRounded,
      binaryMagnitudeRounded, hx, layoutOf, magnitude, absQ, pow2]

private theorem word_value_sign_unique (f : Format) (hf : f.WellFormed)
    (a b : BitVec f.width) (v : ℚ) (ha : binaryValue f a = some v)
    (hb : binaryValue f b = some v) (hs : binarySign f a = binarySign f b) : a = b := by
  obtain ⟨da, hda, _⟩ := Option.map_eq_some_iff.mp ha
  obtain ⟨db, hdb, _⟩ := Option.map_eq_some_iff.mp hb
  exact congrArg Subtype.val (binaryValue_sign_injective f hf ⟨a, da, hda⟩ ⟨b, db, hdb⟩ v ha hb hs)

theorem scalarResult_of_roundBinary (f : Format) (mode : BinaryRoundingMode) (x : ℚ)
    (b : BitVec f.width) (h : roundBinary f mode x = some b) :
    ScalarResult (layoutOf f) (scalarModeOf mode) x b := by
  obtain ⟨hf, hr⟩ := roundBinary_range h
  refine ⟨hf, hr, roundBinary_sign f mode x b h, ?_⟩
  by_cases hx : x = 0
  · subst x
    rw [roundBinary_zero f hf mode] at h
    cases Option.some.inj h
    simpa [scalarValue_eq] using binaryValue_zero f hf
  · rw [if_neg hx]
    obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec f hf mode x hx hr
    have heq := Option.some.inj (hb.symm.trans h)
    subst bits
    refine ⟨binaryConvExp f (absQ x), binaryConvExp_bounds f hf _ (absQ_pos_of_ne_zero x hx) hr, ?_⟩
    rw [scalarValue_eq, scalarGridValue_eq]
    exact hv

theorem scalarResult_unique (f : Format) (mode : BinaryRoundingMode) (x : ℚ)
    (a b : BitVec f.width)
    (ha : ScalarResult (layoutOf f) (scalarModeOf mode) x a)
    (hb : ScalarResult (layoutOf f) (scalarModeOf mode) x b) : a = b := by
  obtain ⟨hf, _, hsa, ha⟩ := ha
  obtain ⟨_, _, hsb, hb⟩ := hb
  have hs : binarySign f a = binarySign f b := hsa.trans hsb.symm
  by_cases hx : x = 0
  · simp only [hx, ↓reduceIte, scalarValue_eq] at ha hb
    exact word_value_sign_unique f hf a b 0 ha hb hs
  · rw [if_neg hx] at ha hb
    obtain ⟨ea, hea, hva⟩ := ha
    obtain ⟨eb, heb, hvb⟩ := hb
    have he := scalarExponent_unique f _ ea eb hea heb
    subst eb
    rw [scalarValue_eq] at hva hvb
    exact word_value_sign_unique f hf a b _ hva hvb hs

theorem scalarResult_iff (f : Format) (mode : BinaryRoundingMode) (x : ℚ) (b : BitVec f.width) :
    ScalarResult (layoutOf f) (scalarModeOf mode) x b ↔ roundBinary f mode x = some b := by
  constructor
  · intro h
    obtain ⟨a, ha, _⟩ := roundBinary_correct f h.1 mode x h.2.1
    have he := scalarResult_unique f mode x a b (scalarResult_of_roundBinary f mode x a ha) h
    rwa [he] at ha
  · exact scalarResult_of_roundBinary f mode x b

/-- Unconditional agreement includes ill-formed target formats and finite-range
rejections. The mathematical selector has no implementation dependency. -/
theorem scalarRound_eq (f : Format) (mode : BinaryRoundingMode) (x : ℚ) :
    scalarRound (layoutOf f) (scalarModeOf mode) x = roundBinary f mode x := by
  classical
  unfold scalarRound
  split
  · rename_i h
    exact ((scalarResult_iff f mode x _).mp (Classical.choose_spec h)).symm
  · rename_i h
    cases hr : roundBinary f mode x with
    | none => rfl
    | some b => exact False.elim (h ⟨b, scalarResult_of_roundBinary f mode x b hr⟩)

end TensorCore.PaperSpec
