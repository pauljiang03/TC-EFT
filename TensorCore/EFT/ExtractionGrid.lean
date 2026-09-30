import TensorCore.EFT.Scalar
import TensorCore.Numerics.Binary.ResidualBudget

/-! An explicit extraction-grid interface for TC-EFT IV.1–IV.11. -/

namespace TensorCore

structure ExtractionGrid (t : BlockTrace) where
  exponent : ℤ
  coarser : t.block.quantumExponent ≤ exponent

def BlockTrace.defaultExtraction (t : BlockTrace) : ExtractionGrid t :=
  ⟨t.extractionExponent, Int.le_max_left _ _⟩

/-- Reject a grid finer than alignment, without changing the existing extractor. -/
def BlockTrace.extractAt (t : BlockTrace) (b : ℤ) : Option (ExtractionGrid t) :=
  if h : t.block.quantumExponent ≤ b then some ⟨b, h⟩ else none

theorem extractAt_isSome_iff (t : BlockTrace) (b : ℤ) :
    (t.extractAt b).isSome = true ↔ t.block.quantumExponent ≤ b := by
  simp [BlockTrace.extractAt]

namespace ExtractionGrid

def coarse (g : ExtractionGrid t) : List ℚ :=
  t.block.terms.map fun x => truncGrid x.value g.exponent
def lowParts (g : ExtractionGrid t) : List ℚ :=
  t.block.terms.map fun x => x.value - truncGrid x.value g.exponent
def retainedSum (g : ExtractionGrid t) : ℚ := sumQ g.coarse
def overlap (g : ExtractionGrid t) : ℚ := t.output.value - g.retainedSum
def retainedLowParts (g : ExtractionGrid t) : List ℚ :=
  g.lowParts.map fun e => truncGrid e t.block.quantumExponent

theorem lowPart_bound (g : ExtractionGrid t) :
    ∀ e ∈ g.lowParts, absQ e < pow2 g.exponent := by
  intro e he
  obtain ⟨x, _, rfl⟩ := List.mem_map.mp he
  exact (alignment_residual x.value g.exponent).2

theorem retained_add_low (g : ExtractionGrid t) :
    g.retainedSum + sumQ g.lowParts = t.block.exactDot := by
  have h := sum_stage_residuals (t.block.terms.map RawProduct.value)
    (fun x => truncGrid x g.exponent)
  rw [terms_value] at h
  simpa [retainedSum, coarse, lowParts, List.map_map, Function.comp_def] using h.symm

theorem recovery (g : ExtractionGrid t) :
    t.block.exactDot = t.output.value - g.overlap + sumQ g.lowParts := by
  have := g.retained_add_low
  unfold overlap
  grind

theorem accumulator_eq_retained (g : ExtractionGrid t) :
    t.block.accumulator = g.retainedSum + sumQ g.retainedLowParts := by
  have hτ : g.exponent = t.block.quantumExponent + (g.exponent - t.block.quantumExponent).toNat := by
    have := g.coarser
    omega
  rw [accumulator_value]
  unfold retainedSum retainedLowParts lowParts coarse
  rw [List.map_map]
  have hsplit : (fun x : RawProduct => truncGrid x.value t.block.quantumExponent) =
      fun x => truncGrid x.value g.exponent +
        truncGrid (x.value - truncGrid x.value g.exponent) t.block.quantumExponent := by
    funext x
    rw [hτ]
    exact truncGrid_split _ _ _
  rw [hsplit, sumQ_map_add]
  rfl

theorem overlap_eq_retained_sub_outputResidual (g : ExtractionGrid t) :
    g.overlap = sumQ g.retainedLowParts - t.outputResidual := by
  have := g.accumulator_eq_retained
  unfold overlap BlockTrace.outputResidual
  grind

def coefficients (g : ExtractionGrid t) (ℓ : ℤ) : List ℤ :=
  g.lowParts.map fun e => (e / pow2 ℓ).floor

/-- Original terms on a common grid yield exact residual coefficients on it. -/
theorem lowParts_on_grid (g : ExtractionGrid t) (ℓ : ℤ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ) :
    g.lowParts = (g.coefficients ℓ).map fun (z : ℤ) => (z : ℚ) * pow2 ℓ := by
  unfold coefficients lowParts
  rw [List.map_map, List.map_map]
  apply List.map_congr_left
  intro x hx
  obtain ⟨z, hz⟩ := hinput x hx
  have he : pow2 g.exponent = ((2 ^ (g.exponent - ℓ).toNat : ℕ) : ℚ) * pow2 ℓ := by
    rw [← pow2_natCast, ← pow2_add]
    congr 1
    omega
  have hr : x.value - truncGrid x.value g.exponent =
      ((z - truncCoeff x.value g.exponent * (2 ^ (g.exponent - ℓ).toNat : ℕ) : ℤ) : ℚ) * pow2 ℓ := by
    rw [alignment_value, he, Rat.intCast_sub, Rat.intCast_mul, Rat.intCast_natCast]
    grind
  dsimp only [Function.comp_def]
  rw [hr, Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos ℓ)), Rat.floor_intCast]

/-- Equation 20 derives the actual coefficient budget from the original input grid, component count (including C), and chosen extraction exponent. -/
theorem eq20_coefficients (g : ExtractionGrid t) (ℓ : ℤ) (P : ℕ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ P) :
    magnitudeSum (g.coefficients ℓ) < 2 ^ P := by
  have hg := g.lowParts_on_grid ℓ hℓ hinput
  apply extraction_coefficient_bound _ g.exponent ℓ P hℓ
  · intro z hz
    apply g.lowPart_bound
    rw [hg]
    exact List.mem_map.mpr ⟨z, hz, rfl⟩
  · simpa [coefficients, lowParts] using hbudget

theorem eq20_exact_sum (g : ExtractionGrid t) (f : Format) (hf : f.WellFormed)
    (ℓ : ℤ) (hmin : f.emin - f.fractionBits ≤ ℓ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum (g.coefficients ℓ) : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f g.lowParts = some (sumQ g.lowParts) := by
  rw [g.lowParts_on_grid ℓ hℓ hinput,
    naiveSumBinary_exact f hf ℓ hmin _ (g.eq20_coefficients ℓ _ hℓ hinput hbudget) hrange,
    sum_coefficients]

def scalarPredicate (g : ExtractionGrid t) (f : Format) (ℓ : ℤ) : Bool :=
  decide f.WellFormed && decide (f.emin - f.fractionBits ≤ ℓ) &&
  (g.lowParts == (g.coefficients ℓ).map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) &&
  decide (magnitudeSum (g.coefficients ℓ) < 2 ^ (f.fractionBits + 1)) &&
  decide ((magnitudeSum (g.coefficients ℓ) : ℚ) * pow2 ℓ ≤ f.maxFinite) &&
  representableBinary f t.output.value && representableBinary f g.overlap &&
  representableBinary f g.retainedSum &&
  decide (absQ (g.retainedSum + sumQ g.lowParts) ≤ maxFinite32)

def scalarCorrectedUnchecked (g : ExtractionGrid t) (f : Format) : Option F32 := do
  let low ← naiveSumBinary f g.lowParts
  let high ← binaryAdd f t.output.value (-g.overlap)
  round32 .nearestEven (high + low)

def scalarCorrected (g : ExtractionGrid t) (f : Format) (ℓ : ℤ) : Option F32 :=
  if g.scalarPredicate f ℓ then g.scalarCorrectedUnchecked f else none

theorem scalarCorrected_eq (g : ExtractionGrid t) (f : Format) (ℓ : ℤ)
    (h : g.scalarPredicate f ℓ = true) :
    g.scalarCorrected f ℓ = round32 .nearestEven t.block.exactDot := by
  have hp := h
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨⟨hf, hmin⟩, hgrid⟩, hbudget⟩, hrange⟩, _⟩, _⟩, hH⟩, _⟩ := h
  have hs : naiveSumBinary f g.lowParts = some (sumQ g.lowParts) := by
    rw [hgrid, naiveSumBinary_exact f hf ℓ hmin _ hbudget hrange, sum_coefficients]
  have he : t.output.value + -g.overlap = g.retainedSum := by unfold overlap; grind
  have hh := binaryAdd_exact f hf t.output.value (-g.overlap)
    (by rw [he]; exact representableBinary_finite f hf hH)
  simp only [scalarCorrected, hp, ↓reduceIte, scalarCorrectedUnchecked, bind, hs, Option.bind_some,
    hh, he, retained_add_low]

theorem scalarCorrected_correct (g : ExtractionGrid t) (f : Format) (ℓ : ℤ)
    (h : g.scalarPredicate f ℓ = true) :
    ∃ bits, g.scalarCorrected f ℓ = some bits ∧ NearestEven32 t.block.exactDot bits := by
  rw [g.scalarCorrected_eq f ℓ h]
  apply round32_nearestEven_correct
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq] at h
  simpa [retained_add_low] using h.2

theorem scalarCorrected_isSome_iff (g : ExtractionGrid t) (f : Format) (ℓ : ℤ) :
    (g.scalarCorrected f ℓ).isSome = true ↔ g.scalarPredicate f ℓ = true := by
  constructor
  · intro h
    unfold scalarCorrected at h
    split at h
    · assumption
    · contradiction
  · intro h
    obtain ⟨bits, hb, _⟩ := g.scalarCorrected_correct f ℓ h
    simp [hb]

/-- Eq.20 is a sufficient precision condition for the actual scalar correction. -/
theorem eq20_scalarPredicate (g : ExtractionGrid t) (f : Format) (hf : f.WellFormed)
    (ℓ : ℤ) (hmin : f.emin - f.fractionBits ≤ ℓ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum (g.coefficients ℓ) : ℚ) * pow2 ℓ ≤ f.maxFinite)
    (hD : representableBinary f t.output.value = true)
    (hO : representableBinary f g.overlap = true)
    (hH : representableBinary f g.retainedSum = true)
    (hfinal : absQ t.block.exactDot ≤ maxFinite32) :
    g.scalarPredicate f ℓ = true := by
  have hgrid := g.lowParts_on_grid ℓ hℓ hinput
  have hcoeff := g.eq20_coefficients ℓ _ hℓ hinput hbudget
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨hf, hmin⟩, hgrid⟩, hcoeff⟩, hrange⟩, hD⟩, hO⟩, hH⟩,
    by simpa [g.retained_add_low] using hfinal⟩


end ExtractionGrid

theorem defaultExtraction_components (t : BlockTrace) :
    t.defaultExtraction.lowParts = t.lowParts ∧ t.defaultExtraction.overlap = t.overlap ∧
      t.defaultExtraction.retainedSum = t.retainedSum := ⟨rfl, rfl, rfl⟩

theorem defaultExtraction_scalar (t : BlockTrace) (f : Format) :
    t.defaultExtraction.scalarPredicate f t.supportExponent = t.scalarPredicateIn f ∧
      t.defaultExtraction.scalarCorrected f t.supportExponent = t.scalarCorrectedIn f := ⟨rfl, rfl⟩

end TensorCore
