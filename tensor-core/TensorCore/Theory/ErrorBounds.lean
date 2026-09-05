import TensorCore.Theory.CorrectRounding
import TensorCore.Theory.StageResiduals
import TensorCore.Theory.Alignment

namespace TensorCore

/-- The magnitude truncation loss is strictly smaller than the conversion grid. -/
theorem rtz_magnitude_residual (m : Rat) :
    absQ (m - magnitudeRounded .towardZero m) < pow2 (convExp m - 23) := by
  let q := pow2 (convExp m - 23)
  have hq : 0 < q := pow2_pos _
  have hf := floor_frac_bounds (m / q)
  have he : m - magnitudeRounded .towardZero m = (m / q - (m / q).floor) * q := by
    have h := Rat.div_mul_cancel (a := m) (Rat.ne_of_gt hq)
    unfold magnitudeRounded convCoeff roundCoefficient
    change m - ((m / q).floor : Rat) * q = _
    grind
  rw [he, absQ_mul_pos _ q hq, absQ_of_nonneg hf.1]
  have h := Rat.mul_lt_mul_of_pos_right hf.2 hq
  simpa using h

theorem rtz_signed_residual (x : Rat) :
    absQ (x - signedRounded .towardZero x) < pow2 (convExp (absQ x) - 23) := by
  have h := rtz_magnitude_residual (absQ x)
  unfold signedRounded
  by_cases hn : x < 0
  · simp only [hn, ↓reduceIte, absQ_of_neg hn] at h ⊢
    have he : x - -magnitudeRounded .towardZero (-x) =
      -(-x - magnitudeRounded .towardZero (-x)) := by grind
    rw [he, absQ_neg]; exact h
  · have hn' : 0 ≤ x := by grind
    simpa [hn, absQ_of_nonneg hn'] using h

/-- FP32 truncation's strict output loss bound, with its finite-range hypothesis. -/
theorem output_residual_bound (x : Rat) (b : F32) (d : Rat)
    (hr : absQ x ≤ maxFinite32) (hb : round32 .towardZero x = some b)
    (hd : value32 b = some d) :
    absQ (x - d) < pow2 (outputQuantumExponent b) := by
  by_cases hx : x = 0
  · subst x
    have hz : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [hz] at hb
    cases Option.some.inj hb
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    cases Option.some.inj hd
    have ha : absQ (0 - 0) = 0 := by decide +kernel
    rw [ha]; exact pow2_pos _
  · obtain ⟨b', hb', hd', _, he⟩ := round32_nonzero_spec .towardZero x hx hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    have hvalue := Option.some.inj hd'
    rw [hvalue]
    have hl := rtz_signed_residual x
    have hq := pow2_le_of_le he
    grind

theorem evalPrepared_output {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) : round32 .towardZero b.accumulator = some t.output.bits := by
  unfold evalPrepared at h
  cases hr : round32 .towardZero b.accumulator with
  | none => simp [hr] at h
  | some bits =>
    cases hd : finite32 bits with
    | none => simp [hr, hd] at h
    | some d =>
      simp [hr, hd] at h
      cases h
      unfold finite32 at hd
      split at hd
      · contradiction
      · cases Option.some.inj hd
        rfl

/-- Success in the public conversion implies the *accumulator* range condition. -/
theorem round32_range {mode : RoundingMode} {x : Rat} {b : F32}
    (h : round32 mode x = some b) : absQ x ≤ maxFinite32 := by
  unfold round32 at h
  split at h
  · contradiction
  · grind

theorem absQ_add_le (x y : Rat) : absQ (x + y) ≤ absQ x + absQ y := by
  have hx := (absQ_le_iff x (absQ x)).mp Rat.le_refl
  have hy := (absQ_le_iff y (absQ y)).mp Rat.le_refl
  apply (absQ_le_iff _ _).mpr
  constructor <;> grind

theorem sum_residual_bounds (ts : List Rat) (e : Int) :
    absQ (sumQ (ts.map fun x => x - truncGrid x e)) ≤ (ts.length : Rat) * pow2 e ∧
    (ts ≠ [] → absQ (sumQ (ts.map fun x => x - truncGrid x e)) < (ts.length : Rat) * pow2 e) := by
  induction ts with
  | nil =>
    have h : absQ (sumQ (List.map (fun x => x - truncGrid x e) [])) = 0 := by
      change absQ 0 = 0
      decide +kernel
    simp only [h, List.length_nil]
    constructor
    · grind
    · intro hn; exact False.elim (hn rfl)
  | cons x xs ih =>
    have hx := (alignment_residual x e).2
    have ht := absQ_add_le (x - truncGrid x e)
      (sumQ (xs.map fun t => t - truncGrid t e))
    have hs : ((xs.length + 1 : Nat) : Rat) = (xs.length : Rat) + 1 := by
      rw [Rat.natCast_add]; rfl
    simp only [List.map_cons, sumQ, List.length_cons, hs]
    have hn : absQ ((x - truncGrid x e) + sumQ (xs.map fun t => t - truncGrid t e)) <
        ((xs.length : Rat) + 1) * pow2 e := by grind
    exact ⟨Rat.le_of_lt hn, fun _ => hn⟩

theorem block_alignment_bound (b : PreparedBlock) :
    absQ (sumQ b.alignmentResiduals) < (b.terms.length : Rat) * pow2 b.quantumExponent := by
  have h := (sum_residual_bounds (b.terms.map RawProduct.value) b.quantumExponent).2
    (by simp [PreparedBlock.terms])
  simpa [PreparedBlock.alignmentResiduals, List.map_map, Function.comp_def] using h

/-- Two-stage error bound. Both losses are counted; exact Int arithmetic cannot wrap. -/
theorem block_error_bound (b : PreparedBlock) (d : Finite32)
    (hr : absQ b.accumulator ≤ maxFinite32)
    (hout : round32 .towardZero b.accumulator = some d.bits) :
    absQ (b.exactDot - d.value) <
      (b.terms.length : Rat) * pow2 b.quantumExponent + pow2 (outputQuantumExponent d.bits) := by
  have hd : value32 d.bits = some d.value := by simp [value32, d.valid, Finite32.value]
  have halign := block_alignment_bound b
  have houtput := output_residual_bound b.accumulator d.bits d.value hr hout hd
  have hid := block_residual_identity b d.value
  unfold PreparedBlock.extractReference at hid
  have ht := absQ_add_le (b.accumulator - d.value) (sumQ b.alignmentResiduals)
  have he : b.exactDot - d.value = (b.accumulator - d.value) + sumQ b.alignmentResiduals := by grind
  rw [he]; grind

theorem evalPrepared_error_bound {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) :
    absQ (t.block.exactDot - t.output.value) <
      (t.block.terms.length : Rat) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) := by
  have hb := evalPrepared_block h
  rw [hb]
  have hout := evalPrepared_output h
  exact block_error_bound b t.output (round32_range hout) hout

theorem evalBlock_error_bound {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    absQ (t.block.exactDot - t.output.value) <
      (t.block.terms.length : Rat) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) :=
  evalPrepared_error_bound (evalBlock_evalPrepared h)

end TensorCore
