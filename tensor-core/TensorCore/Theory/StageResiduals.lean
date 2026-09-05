import TensorCore.Semantics.Block

namespace TensorCore

theorem sum_stage_residuals (ts : List Rat) (align : Rat → Rat) :
    sumQ ts = sumQ (ts.map align) + sumQ (ts.map fun x => x - align x) := by
  induction ts with
  | nil => change (0 : Rat) = 0 + 0; grind
  | cons t ts ih =>
    simp only [List.map_cons, sumQ]
    grind

theorem terms_value (b : PreparedBlock) :
    sumQ (b.terms.map RawProduct.value) = b.exactDot := by
  simp only [PreparedBlock.terms, PreparedBlock.exactDot,
    PreparedBlock.exactProducts, List.map_cons, List.map_map, sumQ]
  have h : (fun (p : Decoded × Decoded) => (rawMul p.1 p.2).value) =
      (fun p => p.1.value * p.2.value) := by
    funext p
    exact rawProduct_value p.1 p.2
  simp only [Function.comp_def] at *
  rw [h]
  rfl

theorem accumulator_value (b : PreparedBlock) :
    b.accumulator = sumQ (b.terms.map fun t => truncGrid t.value b.quantumExponent) := by
  unfold PreparedBlock.accumulator PreparedBlock.coefficients
  rw [← sum_coefficients]
  simp [List.map_map, Function.comp_def, truncGrid]

/-- Exact recovery applies to any supplied finite value, independently of model conformance. -/
theorem block_residual_identity (b : PreparedBlock) (d : Rat) :
    b.exactDot = d + b.extractReference d := by
  have h := sum_stage_residuals (b.terms.map RawProduct.value)
    (fun t => truncGrid t b.quantumExponent)
  rw [terms_value] at h
  simp only [List.map_map, Function.comp_def] at h
  rw [← accumulator_value] at h
  change b.exactDot = d + ((b.accumulator - d) + sumQ b.alignmentResiduals)
  change b.exactDot = b.accumulator + sumQ b.alignmentResiduals at h
  grind

theorem returned_residual_identity (t : BlockTrace) :
    t.block.exactDot = t.output.value + t.residual :=
  block_residual_identity t.block t.output.value

theorem recovered_eq_exactDot (t : BlockTrace) : t.recovered = t.block.exactDot :=
  (returned_residual_identity t).symm

/-- This is substitution into the executable converter, not a nearest-value correctness proof. -/
theorem corrected_eq_round_exactDot (t : BlockTrace) :
    t.corrected = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.corrected
  rw [recovered_eq_exactDot]

theorem evalPrepared_block {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) : t.block = b := by
  unfold evalPrepared at h
  cases hr : round32 .towardZero b.accumulator with
  | none => simp [hr] at h
  | some bits =>
    cases hd : finite32 bits with
    | none => simp [hr, hd] at h
    | some d =>
      simp [hr, hd] at h
      cases h
      rfl

theorem evalV100_prepared {x : BlockInput} {t : BlockTrace}
    (h : evalV100 x = .ok t) : prepare x = some t.block := by
  unfold evalV100 at h
  split at h
  · simp at h
  · cases hp : prepare x with
    | none => simp [hp] at h
    | some b =>
      simp [hp] at h
      rw [evalPrepared_block h]

/-- End-to-end local recovery, connected to the executable encoded-input evaluator. -/
theorem evalV100_residual_identity {x : BlockInput} {t : BlockTrace}
    (h : evalV100 x = .ok t) :
    exactDot x = some (t.output.value + t.residual) := by
  simp only [exactDot, evalV100_prepared h, Option.map_some]
  rw [returned_residual_identity]

theorem prepare_c {x : BlockInput} {b : PreparedBlock}
    (h : prepare x = some b) : decode32 x.c = some b.c := by
  unfold prepare at h
  cases hc : decode32 x.c with
  | none => simp [hc] at h
  | some c =>
    cases hp : prepareProducts x.products with
    | none => simp [hc, hp] at h
    | some ps =>
      simp [hc, hp] at h
      cases h
      rfl

theorem evalV100_c {x : BlockInput} {t : BlockTrace}
    (h : evalV100 x = .ok t) : decode32 x.c = some t.block.c :=
  prepare_c (evalV100_prepared h)

end TensorCore
