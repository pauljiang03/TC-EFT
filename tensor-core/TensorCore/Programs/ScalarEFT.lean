import TensorCore.Programs.EFT
import TensorCore.Theory.Binary.ScalarSum

/-! Format-generic scalar consolidation of an FP32-output block (TC-EFT IV.9–IV.11).
The correction format governs residual addition and overlap subtraction. The final exact
dyadic sum is rounded directly to FP32: an intermediate rounded addition in a wider format
would require a separate double-rounding proof. Extraction and guards remain exact Rat work. -/

namespace TensorCore

def representableBinary (f : Format) (x : Rat) : Bool :=
  (roundBinary f .nearestEven x).bind (binaryValue f) == some x

theorem representableBinary_finite (f : Format) (hf : f.WellFormed) {x : Rat}
    (h : representableBinary f x = true) : f.FiniteValue x := by
  unfold representableBinary at h
  cases hr : roundBinary f .nearestEven x with
  | none => simp [hr] at h
  | some b =>
    simp only [hr, Option.bind_some, beq_iff_eq] at h
    unfold binaryValue at h
    cases hd : (classify f b).finite with
    | none => simp [hd] at h
    | some d =>
      simp only [hd, Option.map_some, Option.some.injEq] at h
      rw [← h]
      exact classifyNat_finiteValue f hf b.toNat d hd

/-- The paper's component predicate with separate minimum-grid, coefficient, and absolute
range budgets. This is a separately named general predicate; the FP32 baseline is unchanged.
The final range is FP32, even when the correction format is FP64. -/
def BlockTrace.scalarPredicateIn (t : BlockTrace) (f : Format) : Bool :=
  decide f.WellFormed && decide (f.emin - f.fractionBits ≤ t.supportExponent) &&
  (t.lowParts == t.lowCoefficients.map fun (z : Int) => (z : Rat) * pow2 t.supportExponent) &&
  decide (magnitudeSum t.lowCoefficients < 2 ^ (f.fractionBits + 1)) &&
  decide ((magnitudeSum t.lowCoefficients : Rat) * pow2 t.supportExponent ≤ f.maxFinite) &&
  representableBinary f t.output.value && representableBinary f t.overlap &&
  representableBinary f t.retainedSum &&
  decide (absQ (t.retainedSum + sumQ t.lowParts) ≤ maxFinite32)

/-- Scalar residual additions and overlap subtraction in f, then direct nearest-even FP32
rounding of the exact final sum. No rounded addition in f occurs at the final boundary. -/
def BlockTrace.scalarCorrectedInUnchecked (t : BlockTrace) (f : Format) : Option F32 :=
  (naiveSumBinary f t.lowParts).bind fun etot =>
    (binaryAdd f t.output.value (-t.overlap)).bind fun h =>
      round32 .nearestEven (h + etot)

def BlockTrace.scalarCorrectedIn (t : BlockTrace) (f : Format) : Option F32 :=
  if t.scalarPredicateIn f then t.scalarCorrectedInUnchecked f else none

/-- Lemma IV.10 in any well-formed correction format. -/
theorem scalarOverlap_exact (t : BlockTrace) (f : Format) (hf : f.WellFormed)
    (hH : f.FiniteValue t.retainedSum) :
    binaryAdd f t.output.value (-t.overlap) = some t.retainedSum := by
  have hr : t.output.value + -t.overlap = t.retainedSum := by
    unfold BlockTrace.overlap; grind
  rw [binaryAdd_exact f hf _ _ (by rw [hr]; exact hH), hr]

theorem scalarCorrectedInUnchecked_eq (t : BlockTrace) (f : Format)
    (h : t.scalarPredicateIn f = true) :
    t.scalarCorrectedInUnchecked f = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.scalarPredicateIn at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨⟨hf, h1⟩, hgrid⟩, hmag⟩, hrange⟩, _⟩, _⟩, hH⟩, _⟩ := h
  have hsum : naiveSumBinary f t.lowParts = some (sumQ t.lowParts) := by
    rw [hgrid, naiveSumBinary_exact f hf _ h1 _ hmag hrange, sum_coefficients]
  unfold BlockTrace.scalarCorrectedInUnchecked
  rw [hsum, Option.bind_some, scalarOverlap_exact t f hf (representableBinary_finite f hf hH),
    Option.bind_some, retained_add_low]

theorem scalarCorrectedIn_eq (t : BlockTrace) (f : Format) (h : t.scalarPredicateIn f = true) :
    t.scalarCorrectedIn f = round32 .nearestEven t.block.exactDot := by
  simp only [BlockTrace.scalarCorrectedIn, h, ↓reduceIte, scalarCorrectedInUnchecked_eq t f h]

theorem scalarCorrectedIn_rejects (t : BlockTrace) (f : Format)
    (h : t.scalarPredicateIn f = false) : t.scalarCorrectedIn f = none := by
  simp [BlockTrace.scalarCorrectedIn, h]

/-- Corollary IV.11: any accepted correction format yields nearest-even FP32 bits of S. -/
theorem scalarCorrectedIn_correct (t : BlockTrace) (f : Format) (h : t.scalarPredicateIn f = true) :
    ∃ b, t.scalarCorrectedIn f = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [scalarCorrectedIn_eq t f h]
  apply round32_nearestEven_correct
  unfold BlockTrace.scalarPredicateIn at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  rw [← retained_add_low]
  exact h.2

theorem scalarCorrectedIn_isSome_iff (t : BlockTrace) (f : Format) :
    (t.scalarCorrectedIn f).isSome = true ↔ t.scalarPredicateIn f = true := by
  constructor
  · intro h
    unfold BlockTrace.scalarCorrectedIn at h
    split at h
    · assumption
    · simp at h
  · intro hp
    obtain ⟨b, hb, _⟩ := scalarCorrectedIn_correct t f hp
    rw [hb]; rfl

/-- A returned correction rounds the independent original-input ideal. -/
theorem evalBlock_scalarCorrectedIn_correct {p : Profile} {x : BlockInput p} {t : BlockTrace}
    {z : Rat} {b : F32} (f : Format) (h : evalBlock x = .ok t) (hz : exactDot x = some z)
    (hb : t.scalarCorrectedIn f = some b) : NearestEven32 z b := by
  have hp : t.scalarPredicateIn f = true :=
    (scalarCorrectedIn_isSome_iff t f).mp (by rw [hb]; rfl)
  obtain ⟨b', hb', hn⟩ := scalarCorrectedIn_correct t f hp
  rw [hb] at hb'
  cases Option.some.inj hb'
  simp only [exactDot, evalBlock_prepared h, Option.map_some] at hz
  rw [← Option.some.inj hz]
  exact hn

/-- The FP32 executor retains exactly the existing operation sequence. The generic
predicate is separate because its absolute-range test covers more possible grids. -/
theorem scalarCorrectedInUnchecked_fp32 (t : BlockTrace) :
    t.scalarCorrectedInUnchecked fp32 = t.scalarCorrectedUnchecked := by
  simp only [BlockTrace.scalarCorrectedInUnchecked, BlockTrace.scalarCorrectedUnchecked,
    naiveSumBinary_fp32, binaryAdd_fp32]

set_option maxRecDepth 4096 in
theorem representableBinary_fp32 (x : Rat) : representableBinary fp32 x = representable32 x := rfl

set_option maxRecDepth 4096 in
/-- Every accepted baseline FP32 case also satisfies the paper's generic range predicate. -/
theorem scalarPredicate_implies_in_fp32 (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarPredicateIn fp32 = true := by
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨h1, h2⟩, hgrid⟩, hmag⟩, hD⟩, ho⟩, hH⟩, hr⟩ := h
  unfold BlockTrace.scalarPredicateIn
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, representableBinary_fp32]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨by decide, h1⟩, hgrid⟩, hmag⟩,
    coefficient_range_of_grid fp32 _ _ h2 hmag⟩, hD⟩, ho⟩, hH⟩, hr⟩

theorem scalarCorrectedIn_fp32_of_predicate (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrectedIn fp32 = t.scalarCorrected := by
  rw [scalarCorrectedIn_eq t fp32 (scalarPredicate_implies_in_fp32 t h), scalarCorrected_eq t h]

end TensorCore
