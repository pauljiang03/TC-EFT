import TensorCore.Theory.ScalarSum
import TensorCore.Theory.StageResiduals
import TensorCore.Theory.Alignment
import TensorCore.Programs.Correction

/-! TC-EFT §IV on one block trace: coarse components on the extraction grid, the overlap
form of exact recovery, the scalar-consolidation predicate, and Algorithm 1 with its
scalar branch executed as actual FP32 additions. -/

namespace TensorCore

/-- Extraction grid exponent: `qE = max(qA, qD)` (TC-EFT eq. 11). -/
def BlockTrace.extractionExponent (t : BlockTrace) : Int :=
  max t.block.quantumExponent (outputQuantumExponent t.output.bits)

/-- Coarse retained components `hᵢ = trunc_qE(Tᵢ)` (Lemma IV.1). c is term zero. -/
def BlockTrace.coarse (t : BlockTrace) : List Rat :=
  t.block.terms.map fun x => truncGrid x.value t.extractionExponent

/-- Low components `εᵢ = Tᵢ − hᵢ`. -/
def BlockTrace.lowParts (t : BlockTrace) : List Rat :=
  t.block.terms.map fun x => x.value - truncGrid x.value t.extractionExponent

/-- `H = Σ hᵢ`. -/
def BlockTrace.retainedSum (t : BlockTrace) : Rat := sumQ t.coarse

/-- Signed overlap correction `ε_o = D − H` (Lemma IV.4). -/
def BlockTrace.overlap (t : BlockTrace) : Rat := t.output.value - t.retainedSum

/-- Lemma IV.1: every low component is strictly below the extraction grid. -/
theorem lowPart_bound (t : BlockTrace) :
    ∀ e ∈ t.lowParts, absQ e < pow2 t.extractionExponent := by
  intro e he
  simp only [BlockTrace.lowParts, List.mem_map] at he
  obtain ⟨x, _, rfl⟩ := he
  exact (alignment_residual x.value t.extractionExponent).2

/-- Theorem IV.5, overlap form: `S = D − ε_o + Σ εᵢ`. -/
theorem overlap_recovery (t : BlockTrace) :
    t.block.exactDot = t.output.value - t.overlap + sumQ t.lowParts := by
  have h := sum_stage_residuals (t.block.terms.map RawProduct.value)
    (fun x => truncGrid x t.extractionExponent)
  rw [terms_value] at h
  simp only [List.map_map, Function.comp_def] at h
  change t.block.exactDot = sumQ t.coarse + sumQ t.lowParts at h
  unfold BlockTrace.overlap BlockTrace.retainedSum
  grind

/-- Executable representability: nearest-even conversion returns the value itself. -/
def representable32 (x : Rat) : Bool := (round32 .nearestEven x).bind value32 == some x

theorem representable32_finite {x : Rat} (h : representable32 x = true) : FiniteValue32 x := by
  unfold representable32 at h
  cases hr : round32 .nearestEven x with
  | none => simp [hr] at h
  | some b =>
    simp only [hr, Option.bind_some, beq_iff_eq] at h
    exact value32_finite b x h

/-- Common grid exponent for the low components: the finest term grid, or the extraction
grid if finer. Every `Tᵢ` and `hᵢ` is an integer multiple of `2^ℓ`. -/
def BlockTrace.supportExponent (t : BlockTrace) : Int :=
  (t.block.terms.map fun x => x.rawScale - x.fractionalBits).foldl min t.extractionExponent

/-- Integer coefficients `zᵢ = εᵢ / 2^ℓ`. -/
def BlockTrace.lowCoefficients (t : BlockTrace) : List Int :=
  t.lowParts.map fun e => (e / pow2 t.supportExponent).floor

/-- The hypotheses of Theorem IV.9, Lemma IV.10, and Corollary IV.11, decided on the
actual components: a grid between `2^-149` and `2^104`, exact integer coefficients, an
absolute coefficient sum below `2^24`, representable `D`, `ε_o`, and `H`, and an exact
sum in the finite range. -/
def BlockTrace.scalarPredicate (t : BlockTrace) : Bool :=
  decide (-149 ≤ t.supportExponent) && decide (t.supportExponent ≤ 104) &&
  (t.lowParts == t.lowCoefficients.map fun (z : Int) => (z : Rat) * pow2 t.supportExponent) &&
  decide (magnitudeSum t.lowCoefficients < 2 ^ 24) &&
  representable32 t.output.value && representable32 t.overlap &&
  representable32 t.retainedSum && decide (absQ t.block.exactDot ≤ maxFinite32)

/-- Algorithm 1, scalar branch: naive FP32 summation of the low parts, `D ⊖ ε_o`, and
one final nearest-even addition. Every operation is a correctly rounded FP32 addition. -/
def BlockTrace.scalarCorrected (t : BlockTrace) : Option F32 :=
  (naiveSum32 t.lowParts).bind fun etot =>
    (fp32Add t.output.value (-t.overlap)).bind fun h =>
      round32 .nearestEven (h + etot)

/-- Algorithm 1: the scalar branch under its predicate, the exact-dyadic path otherwise. -/
def BlockTrace.tceft (t : BlockTrace) : Option F32 :=
  if t.scalarPredicate then t.scalarCorrected else t.corrected

/-- Theorem IV.9 and Lemma IV.10 applied: under the predicate, the scalar branch computes
exactly `RN(S)`. -/
theorem scalarCorrected_eq (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrected = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨h1, h2⟩, hgrid⟩, hmag⟩, _⟩, _⟩, hH⟩, _⟩ := h
  have hsum : naiveSum32 t.lowParts = some (sumQ t.lowParts) := by
    rw [hgrid, naiveSum32_exact _ h1 h2 _ hmag, sum_coefficients]
  have hsub : fp32Add t.output.value (-t.overlap) = some (t.output.value + -t.overlap) := by
    apply fp32Add_exact
    have hr : t.output.value + -t.overlap = t.retainedSum := by
      unfold BlockTrace.overlap; grind
    rw [hr]
    exact representable32_finite hH
  unfold BlockTrace.scalarCorrected
  rw [hsum, hsub]
  simp only [Option.bind_some]
  congr 1
  have := overlap_recovery t
  grind

/-- Corollary IV.11: the scalar branch returns the correctly rounded exact dot product. -/
theorem scalarCorrected_correct (t : BlockTrace) (h : t.scalarPredicate = true) :
    ∃ b, t.scalarCorrected = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [scalarCorrected_eq t h]
  apply round32_nearestEven_correct
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  exact h.2

/-- Both branches of Algorithm 1 return the exact-rational reference result. -/
theorem tceft_eq_corrected (t : BlockTrace) : t.tceft = t.corrected := by
  unfold BlockTrace.tceft
  split
  · rename_i h
    rw [scalarCorrected_eq t h, corrected_eq_round_exactDot]
  · rfl

theorem tceft_correct (t : BlockTrace) (hr : absQ t.block.exactDot ≤ maxFinite32) :
    ∃ b, t.tceft = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [tceft_eq_corrected]
  exact corrected_correct t hr

/-- Algorithm 1 on a successful encoded-input evaluation correctly rounds the independent
ideal sum whenever that sum is in range. -/
theorem evalBlock_tceft_correct {p : Profile} {x : BlockInput p} {t : BlockTrace} {z : Rat}
    (h : evalBlock x = .ok t) (hz : exactDot x = some z) (hr : absQ z ≤ maxFinite32) :
    ∃ b, t.tceft = some b ∧ NearestEven32 z b := by
  rw [tceft_eq_corrected]
  exact evalBlock_corrected_correct h hz hr

end TensorCore
