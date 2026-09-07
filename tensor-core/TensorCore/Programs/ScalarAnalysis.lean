import TensorCore.Programs.GemmRoundingBudget
import TensorCore.Theory.Binary.ScalarSum
import TensorCore.Theory.Binary.RoundingContract

namespace TensorCore

theorem conversion_exact_value (s : ConversionStage) (hf : s.format.WellFormed)
    (x : Rat) (hx : s.format.FiniteValue x) :
    ∃ d, s.convert x = some d ∧ d.value = x := by
  obtain ⟨d, hd⟩ := gemmConversion_total s hf x (s.format.finiteValue_abs_le hx)
  have hc := gemmConversion_correct s x d hd
  have hv : binaryValue s.format d.bits = some d.value := by
    simp [binaryValue, d.valid, FiniteBinary.value]
  refine ⟨d, hd, ?_⟩
  cases hm : s.mode with
  | nearestEven =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hn, _⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have hh := hn x hx
    rw [Rat.sub_self] at hh
    have := (absQ_le_iff _ _).mp hh
    change -0 ≤ x - d.value ∧ x - d.value ≤ 0 at this
    grind
  | towardZero =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hb, hn⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have hs : Between0 x x := by unfold Between0; grind
    have hh := hn x hx hs
    unfold Between0 at hb
    rcases hb with ⟨hx0, hd0, hdx⟩ | ⟨hx0, hxd, hd0⟩
    · rw [absQ_of_nonneg hx0, absQ_of_nonneg hd0] at hh
      grind
    · have ha : absQ x = -x := by unfold absQ; split <;> grind
      have hb : absQ d.value = -d.value := by unfold absQ; split <;> grind
      rw [ha, hb] at hh
      grind
  | towardNegative =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hb, hn⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have := hn x hx Rat.le_refl
    grind
  | towardPositive =>
    simp only [GemmRounded, hm] at hc
    obtain ⟨v, hv', hb, hn⟩ := hc
    rw [hv] at hv'
    cases Option.some.inj hv'
    have := hn x hx Rat.le_refl
    grind

structure ScalarBound where
  magnitude : Rat
  error : Rat
  deriving Repr, DecidableEq

def scalarScale (f : Format) (M : Rat) : Int :=
  if M = 0 then f.emin else max f.emin (magnitudeExponent M + 1)

theorem scalarScale_spec (f : Format) (M : Rat) (hM : 0 ≤ M) :
    f.emin ≤ scalarScale f M ∧ M ≤ pow2 (scalarScale f M) := by
  by_cases hz : M = 0
  · simp only [scalarScale, hz, ↓reduceIte]
    exact ⟨Int.le_refl _, Rat.le_of_lt (pow2_pos _)⟩
  · have hm := (magnitudeExponent_spec M (show 0 < M by grind)).2
    have he : magnitudeExponent M + 1 ≤ max f.emin (magnitudeExponent M + 1) := by omega
    have hp := pow2_le_of_le he
    simp only [scalarScale, hz, ↓reduceIte]
    exact ⟨by omega, by grind⟩

def scalarBound (s : ConversionStage) (M : Rat) (E : Int) : ScalarBound :=
  let error := if M = 0 then 0 else gemmConversionModeError s E
  ⟨min (M + error) s.format.maxFinite, error⟩

def checkScalar (s : ConversionStage) (M : Rat) (E : Int) : Option ScalarBound :=
  if s.format.WellFormed ∧ 0 ≤ M ∧ M ≤ s.format.maxFinite ∧
      s.format.emin ≤ E ∧ M ≤ pow2 E then some (scalarBound s M E) else none

theorem checkScalar_sound (s : ConversionStage) (M : Rat) (E : Int) (b : ScalarBound)
    (h : checkScalar s M E = some b) (x : Rat) (hx : absQ x ≤ M) :
    ∃ d, s.convert x = some d ∧ absQ d.value ≤ b.magnitude ∧ absQ (x - d.value) ≤ b.error := by
  unfold checkScalar at h
  split at h
  next hh =>
    obtain ⟨hf, _, hr, he, hm⟩ := hh
    cases Option.some.inj h
    obtain ⟨d, hd⟩ := gemmConversion_total s hf x (Rat.le_trans hx hr)
    have herr : absQ (x - d.value) ≤ (scalarBound s M E).error := by
      by_cases hz : M = 0
      · have hzero : x = 0 := by have := (absQ_le_iff x M).mp hx; grind
        have hv := conversionStage_output hd
        rw [hzero, roundBinary_zero s.format hf s.mode] at hv
        have hval : binaryValue s.format d.bits = some d.value := by
          simp [binaryValue, d.valid, FiniteBinary.value]
        rw [← Option.some.inj hv, binaryValue_zero s.format hf] at hval
        simp [scalarBound, hz, hzero, ← Option.some.inj hval, Rat.sub_self, absQ]
      · simpa [scalarBound, hz] using gemmConversion_mode_error s E he x (Rat.le_trans hx hm) d hd
    refine ⟨d, hd, ?_, herr⟩
    have ht := absQ_add_le x (d.value - x)
    rw [absQ_sub_comm d.value x] at ht
    have hid : x + (d.value - x) = d.value := by grind
    rw [hid] at ht
    have hfval := classifyNat_finiteValue s.format hf d.bits.toNat d.decoded d.valid
    have hmax := s.format.finiteValue_abs_le hfval
    change absQ d.value ≤ s.format.maxFinite at hmax
    change absQ d.value ≤ min (M + (scalarBound s M E).error) s.format.maxFinite
    rw [Rat.min_def]
    split <;> grind
  next _ => contradiction

theorem checkScalar_inferred (s : ConversionStage) (M : Rat)
    (hf : s.format.WellFormed) (hM : 0 ≤ M) (hr : M ≤ s.format.maxFinite) :
    checkScalar s M (scalarScale s.format M) = some (scalarBound s M (scalarScale s.format M)) := by
  have hs := scalarScale_spec s.format M hM
  simp [checkScalar, hf, hM, hr, hs]

def checkOutput (s : ConversionStage) (M : Rat) (E : Int) : Option ScalarBound :=
  if s.format = fp32 then some ⟨M, 0⟩ else checkScalar s M E

theorem checkOutput_sound (s : ConversionStage) (M : Rat) (E : Int) (b : ScalarBound)
    (h : checkOutput s M E = some b) (x : FiniteBinary fp32) (hx : absQ x.value ≤ M) :
    ∃ d, s.convert x.value = some d ∧ absQ d.value ≤ b.magnitude ∧
      absQ (x.value - d.value) ≤ b.error := by
  unfold checkOutput at h
  split at h
  next hf =>
    cases Option.some.inj h
    have hfinite : s.format.FiniteValue x.value := by
      rw [hf]
      exact classifyNat_finiteValue fp32 (by decide) x.bits.toNat x.decoded x.valid
    obtain ⟨d, hd, hv⟩ := conversion_exact_value s (by rw [hf]; decide) x.value hfinite
    exact ⟨d, hd, by simpa [hv] using hx, by simp [hv, Rat.sub_self, absQ]⟩
  next _ => exact checkScalar_sound s M E b h x.value hx

end TensorCore
