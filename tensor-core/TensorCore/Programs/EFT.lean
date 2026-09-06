import TensorCore.Theory.ScalarSum
import TensorCore.Theory.StageResiduals
import TensorCore.Theory.Alignment
import TensorCore.Programs.Correction

/-! TC-EFT §IV on one block trace: coarse components on the extraction grid, the overlap
identities (Lemmas IV.1–IV.4), the overlap form of exact recovery (Theorem IV.5), the
scalar-consolidation predicate (IV.9–IV.10), and the scalar branch of Algorithm 1 executed
as actual FP32 additions (Corollary IV.11). The scalar procedure reports failure when its
predicate does not hold. The exact-rational reference `BlockTrace.corrected` is a separate
procedure, not a fallback of this one. -/

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

/-- Retained parts of the low components on the alignment grid, `φ(εᵢ) = trunc_qA(εᵢ)`. -/
def BlockTrace.retainedLowParts (t : BlockTrace) : List Rat :=
  t.lowParts.map fun e => truncGrid e t.block.quantumExponent

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

/-! Lemma IV.3 rests on one fact about nested grids: truncating to a fine grid equals
truncating to a coarser grid and then truncating the remainder to the fine grid. -/

theorem floor_sub_intCast (t : Rat) (k : Int) : (t - k).floor = t.floor - k := by
  have h := Rat.floor_add_intCast (x := t) (y := -k)
  rw [Rat.intCast_neg] at h
  have : t - (k : Rat) = t + -(k : Rat) := by grind
  rw [this, h]
  omega

theorem floor_grid_split (m : Rat) (N : Nat) :
    m.floor = (N : Int) * (m / (N : Rat)).floor + (m - (N : Rat) * (m / (N : Rat)).floor).floor := by
  have hq : (N : Rat) * ((m / (N : Rat)).floor : Rat) = (((N : Int) * (m / (N : Rat)).floor : Int) : Rat) := by
    rw [Rat.intCast_mul, Rat.intCast_natCast]
  rw [hq, floor_sub_intCast]
  omega

theorem truncCoeff_nonneg_eq (x : Rat) (e : Int) (hx : 0 ≤ x) :
    truncCoeff x e = (x / pow2 e).floor := by
  unfold truncCoeff
  rw [if_neg (by grind)]

theorem truncGrid_le_self (x : Rat) (e : Int) (hx : 0 ≤ x) : truncGrid x e ≤ x := by
  have hq := pow2_pos e
  unfold truncGrid
  rw [truncCoeff_nonneg_eq x e hx]
  have := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (x / pow2 e)) (Rat.le_of_lt hq)
  rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at this

theorem truncGrid_zero (e : Int) : truncGrid 0 e = 0 := by
  unfold truncGrid truncCoeff
  rw [if_neg (by decide +kernel), Rat.div_def, Rat.zero_mul, ← Rat.intCast_zero,
    Rat.floor_intCast]
  simp

theorem truncGrid_neg (z : Rat) (e : Int) : truncGrid (-z) e = -truncGrid z e := by
  by_cases hz0 : z = 0
  · subst hz0
    rw [Rat.neg_zero, truncGrid_zero]
    simp
  · unfold truncGrid truncCoeff
    by_cases hz : z < 0
    · rw [if_pos hz, if_neg (by grind)]
      rw [Rat.intCast_neg]
      grind
    · rw [if_neg hz, if_pos (by grind)]
      rw [Rat.intCast_neg]
      grind

/-- `trunc_qA(x) = trunc_qE(x) + trunc_qA(x − trunc_qE(x))` for `qE = 2^τ · qA`. -/
theorem truncGrid_split (x : Rat) (a : Int) (τ : Nat) :
    truncGrid x a = truncGrid x (a + τ) + truncGrid (x - truncGrid x (a + τ)) a := by
  have hqa := pow2_pos a
  have hne := Rat.ne_of_gt hqa
  have hN : pow2 (a + τ) = pow2 a * ((2 ^ τ : Nat) : Rat) := by
    rw [pow2_add, pow2_natCast]
  have hNpos : (0 : Rat) < ((2 ^ τ : Nat) : Rat) := Rat.natCast_pos.mpr (Nat.two_pow_pos τ)
  have hNne : ((2 ^ τ : Nat) : Rat) ≠ 0 := Rat.ne_of_gt hNpos
  have hqEne : pow2 a * ((2 ^ τ : Nat) : Rat) ≠ 0 := Rat.ne_of_gt (Rat.mul_pos hqa hNpos)
  have key : ∀ y : Rat, 0 ≤ y →
      truncGrid y a = truncGrid y (a + τ) + truncGrid (y - truncGrid y (a + τ)) a := by
    intro y hy
    have hyq : y / pow2 a * pow2 a = y := Rat.div_mul_cancel hne
    have hmq : 0 ≤ y / pow2 a := by
      have := Rat.div_lt_iff (a := y) (c := 0) hqa
      grind
    generalize y / pow2 a = m at hyq hmq
    subst hyq
    have hfloorN : ((m / ((2 ^ τ : Nat) : Rat)).floor : Rat) ≤ m / ((2 ^ τ : Nat) : Rat) :=
      Rat.floor_le _
    have hdivN : m / ((2 ^ τ : Nat) : Rat) * ((2 ^ τ : Nat) : Rat) = m := Rat.div_mul_cancel hNne
    have h1 : truncGrid (m * pow2 a) a = ((m.floor : Int) : Rat) * pow2 a := by
      rw [alignment_value, truncCoeff_nonneg_eq _ _ hy, Rat.mul_div_cancel hne]
    have hcoarse : m * pow2 a / pow2 (a + τ) = m / ((2 ^ τ : Nat) : Rat) := by
      rw [hN]
      have : m * pow2 a = m / ((2 ^ τ : Nat) : Rat) * (pow2 a * ((2 ^ τ : Nat) : Rat)) := by grind
      rw [this, Rat.mul_div_cancel hqEne]
    have h2 : truncGrid (m * pow2 a) (a + τ) =
        (((m / ((2 ^ τ : Nat) : Rat)).floor : Int) : Rat) * (pow2 a * ((2 ^ τ : Nat) : Rat)) := by
      rw [alignment_value, truncCoeff_nonneg_eq _ _ hy, hcoarse, hN]
    have hrem_eq : m * pow2 a - truncGrid (m * pow2 a) (a + τ) =
        (m - ((2 ^ τ : Nat) : Rat) * (((m / ((2 ^ τ : Nat) : Rat)).floor : Int) : Rat)) * pow2 a := by
      rw [h2]; grind
    have hrem_nonneg :
        0 ≤ m - ((2 ^ τ : Nat) : Rat) * (((m / ((2 ^ τ : Nat) : Rat)).floor : Int) : Rat) := by
      have := Rat.mul_le_mul_of_nonneg_right hfloorN (Rat.le_of_lt hNpos)
      rw [hdivN] at this
      grind
    have h3 : truncGrid (m * pow2 a - truncGrid (m * pow2 a) (a + τ)) a =
        (((m - ((2 ^ τ : Nat) : Rat) * (((m / ((2 ^ τ : Nat) : Rat)).floor : Int) : Rat)).floor : Int) : Rat) *
          pow2 a := by
      rw [hrem_eq, alignment_value,
        truncCoeff_nonneg_eq _ _ (Rat.mul_nonneg hrem_nonneg (Rat.le_of_lt hqa)),
        Rat.mul_div_cancel hne]
    rw [h3, h1, h2, floor_grid_split m (2 ^ τ), Rat.intCast_add, Rat.intCast_mul,
      Rat.intCast_natCast]
    grind
  by_cases hx : 0 ≤ x
  · exact key x hx
  · have h := key (-x) (by grind)
    rw [truncGrid_neg, truncGrid_neg] at h
    have h2 : -x - -truncGrid x (a + τ) = -(x - truncGrid x (a + τ)) := by grind
    rw [h2, truncGrid_neg] at h
    grind

theorem sumQ_map_add (l : List α) (g h : α → Rat) :
    sumQ (l.map fun x => g x + h x) = sumQ (l.map g) + sumQ (l.map h) := by
  induction l with
  | nil => change (0 : Rat) = 0 + 0; grind
  | cons x xs ih => simp only [List.map_cons, sumQ, ih]; grind

/-- Lemma IV.3, summed: the aligned accumulator is `H + Σ φ(εᵢ)`. -/
theorem accumulator_eq_retained (t : BlockTrace) :
    t.block.accumulator = t.retainedSum + sumQ t.retainedLowParts := by
  have hτ : ∃ τ : Nat, t.extractionExponent = t.block.quantumExponent + τ := by
    refine ⟨(t.extractionExponent - t.block.quantumExponent).toNat, ?_⟩
    unfold BlockTrace.extractionExponent
    omega
  obtain ⟨τ, hτ⟩ := hτ
  rw [accumulator_value]
  unfold BlockTrace.retainedSum BlockTrace.retainedLowParts BlockTrace.lowParts BlockTrace.coarse
  rw [List.map_map]
  have hsplit : (fun x : RawProduct => truncGrid x.value t.block.quantumExponent) =
      fun x => truncGrid x.value t.extractionExponent +
        truncGrid (x.value - truncGrid x.value t.extractionExponent) t.block.quantumExponent := by
    funext x
    rw [hτ]
    exact truncGrid_split x.value t.block.quantumExponent τ
  rw [hsplit, sumQ_map_add]
  rfl

/-- Lemma IV.4: `ε_o = Σ φ(εᵢ) − r_out`. -/
theorem overlap_eq_retained_sub_outputResidual (t : BlockTrace) :
    t.overlap = sumQ t.retainedLowParts - t.outputResidual := by
  have h := accumulator_eq_retained t
  unfold BlockTrace.overlap BlockTrace.outputResidual
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
absolute coefficient sum below `2^24`, representable `D`, `ε_o`, and `H`, and a final sum
`H + Σ εᵢ` in the finite range. This remains an exact-reference check:
`retained_add_low` proves that the range expression reconstructs the original ideal. -/
def BlockTrace.scalarPredicate (t : BlockTrace) : Bool :=
  decide (-149 ≤ t.supportExponent) && decide (t.supportExponent ≤ 104) &&
  (t.lowParts == t.lowCoefficients.map fun (z : Int) => (z : Rat) * pow2 t.supportExponent) &&
  decide (magnitudeSum t.lowCoefficients < 2 ^ 24) &&
  representable32 t.output.value && representable32 t.overlap &&
  representable32 t.retainedSum &&
  decide (absQ (t.retainedSum + sumQ t.lowParts) ≤ maxFinite32)

/-- Named diagnostics for the unchanged baseline predicate. These exact-arithmetic
checks are evidence about the specification, not bounded extraction operations. -/
def BlockTrace.scalarChecks (t : BlockTrace) : List (String × Bool) :=
  [("support_min", decide (-149 ≤ t.supportExponent)),
   ("support_max", decide (t.supportExponent ≤ 104)),
   ("integer_grid", t.lowParts == t.lowCoefficients.map fun (z : Int) =>
      (z : Rat) * pow2 t.supportExponent),
   ("coefficient_budget", decide (magnitudeSum t.lowCoefficients < 2 ^ 24)),
   ("output_representable", representable32 t.output.value),
   ("overlap_representable", representable32 t.overlap),
   ("retained_representable", representable32 t.retainedSum),
   ("final_range", decide (absQ (t.retainedSum + sumQ t.lowParts) ≤ maxFinite32))]

/-- Diagnostic conjunction is exactly the public predicate, including every guard. -/
theorem scalarChecks_all (t : BlockTrace) :
    (t.scalarChecks.all fun c => c.2) = t.scalarPredicate := by
  simp [BlockTrace.scalarChecks, BlockTrace.scalarPredicate, Bool.and_assoc]

/-- Unchecked diagnostic implementation of Algorithm 1, scalar branch. This can return
incorrect bits when `scalarPredicate` fails; use `scalarCorrected` or `tceft`. It performs
naive FP32 summation of the low parts, `D ⊖ ε_o`, and one final nearest-even addition. Every operation is a correctly rounded FP32 addition. -/
def BlockTrace.scalarCorrectedUnchecked (t : BlockTrace) : Option F32 :=
  (naiveSum32 t.lowParts).bind fun etot =>
    (fp32Add t.output.value (-t.overlap)).bind fun h =>
      round32 .nearestEven (h + etot)

/-- Safe public scalar correction: reject unless the sufficient predicate holds. -/
def BlockTrace.scalarCorrected (t : BlockTrace) : Option F32 :=
  if t.scalarPredicate then t.scalarCorrectedUnchecked else none

/-- The scalar EFT: the scalar branch when its predicate holds, and `none` otherwise. A
failed predicate is a failure of this procedure, not a signal to compute something else. -/
def BlockTrace.tceft (t : BlockTrace) : Option F32 := t.scalarCorrected

theorem retained_add_low (t : BlockTrace) :
    t.retainedSum + sumQ t.lowParts = t.block.exactDot := by
  have h := overlap_recovery t
  unfold BlockTrace.overlap at h
  grind

/-- Theorem IV.9 and Lemma IV.10 applied: under the predicate, the scalar branch computes
exactly `RN(S)`. -/
theorem scalarCorrectedUnchecked_eq (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrectedUnchecked = round32 .nearestEven t.block.exactDot := by
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
  unfold BlockTrace.scalarCorrectedUnchecked
  rw [hsum, hsub]
  simp only [Option.bind_some]
  congr 1
  have := overlap_recovery t
  grind

/-- The guarded public helper preserves all previously justified successful results. -/
theorem scalarCorrected_eq (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrected = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.scalarCorrected
  rw [if_pos h, scalarCorrectedUnchecked_eq t h]

/-- The public helper refuses the known-unsafe branch when its predicate fails. -/
theorem scalarCorrected_rejects (t : BlockTrace) (h : t.scalarPredicate = false) :
    t.scalarCorrected = none := by simp [BlockTrace.scalarCorrected, h]

/-- Corollary IV.11: the scalar branch returns the correctly rounded exact dot product. -/
theorem scalarCorrected_correct (t : BlockTrace) (h : t.scalarPredicate = true) :
    ∃ b, t.scalarCorrected = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [scalarCorrected_eq t h]
  apply round32_nearestEven_correct
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  rw [← retained_add_low]
  exact h.2

/-- Whenever the scalar EFT returns a result, it is the correctly rounded exact sum. -/
theorem tceft_correct (t : BlockTrace) (b : F32) (h : t.tceft = some b) :
    NearestEven32 t.block.exactDot b := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected at h
  split at h
  · rename_i hp
    obtain ⟨b', hb', hn⟩ := scalarCorrected_correct t hp
    simp only [BlockTrace.scalarCorrected, if_pos hp] at hb'
    rw [hb'] at h
    cases Option.some.inj h
    exact hn
  · contradiction

/-- The scalar EFT succeeds exactly when its predicate holds. -/
theorem tceft_isSome_iff (t : BlockTrace) : (t.tceft).isSome = true ↔ t.scalarPredicate = true := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected
  constructor
  · intro h
    split at h
    · assumption
    · simp at h
  · intro hp
    rw [if_pos hp]
    obtain ⟨b, hb, _⟩ := scalarCorrected_correct t hp
    simp only [BlockTrace.scalarCorrected, if_pos hp] at hb
    rw [hb]
    rfl

/-- Under the predicate, the scalar EFT and the exact-rational reference return the same bits. -/
theorem tceft_eq_corrected (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.tceft = t.corrected := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected
  rw [if_pos h, scalarCorrectedUnchecked_eq t h, corrected_eq_round_exactDot]

/-- On a successful encoded-input evaluation, a scalar EFT result correctly rounds the
independent ideal sum. -/
theorem evalBlock_tceft_correct {p : Profile} {x : BlockInput p} {t : BlockTrace} {z : Rat}
    {b : F32} (h : evalBlock x = .ok t) (hz : exactDot x = some z) (hb : t.tceft = some b) :
    NearestEven32 z b := by
  simp only [exactDot, evalBlock_prepared h, Option.map_some] at hz
  rw [← Option.some.inj hz]
  exact tceft_correct t b hb

end TensorCore
