import TensorCore.Theory.Canonical

namespace TensorCore

theorem truncGrid_fixed (k e : Int) : truncGrid ((k : Rat) * pow2 e) e = (k : Rat) * pow2 e := by
  have hn : pow2 e ≠ 0 := Rat.ne_of_gt (pow2_pos e)
  unfold truncGrid truncCoeff
  split
  · have he : -((k : Rat) * pow2 e) / pow2 e = ((-k : Int) : Rat) := by
      rw [← Rat.neg_mul, Rat.mul_div_cancel hn, Rat.intCast_neg]
    rw [he, Rat.floor_intCast]
    simp
  · rw [Rat.mul_div_cancel hn, Rat.floor_intCast]

theorem truncGrid_exact_of_grid (k scale grid : Int) (h : grid ≤ scale) :
    truncGrid ((k : Rat) * pow2 scale) grid = (k : Rat) * pow2 scale := by
  obtain ⟨j, hj⟩ := finite_on_grid k (scale + 23) (grid + 23) (by omega)
  have hs : scale + 23 - 23 = scale := by omega
  have hg : grid + 23 - 23 = grid := by omega
  rw [hs, hg] at hj
  rw [hj, truncGrid_fixed]

/-- Sufficient alignment precision for this actual input, retaining raw metadata.
Zero terms place no restriction on the grid. This is not a monotonicity claim. -/
def PreparedBlock.AlignmentExact (b : PreparedBlock) : Prop :=
  ∀ t ∈ b.terms, t.significand ≠ 0 →
    b.quantumExponent ≤ t.rawScale - t.fractionalBits

theorem exact_alignment_accumulator (b : PreparedBlock) (h : b.AlignmentExact) :
    b.accumulator = b.exactDot := by
  rw [accumulator_value, ← terms_value]
  congr 1
  apply List.map_congr_left
  intro t ht
  by_cases hz : t.significand = 0
  · simp [RawProduct.value, hz, truncGrid, truncCoeff, Rat.div_def]
    have hf : (0 : Rat).floor = 0 := rfl
    rw [hf]
    simp
  · exact truncGrid_exact_of_grid t.significand (t.rawScale - t.fractionalBits)
      b.quantumExponent (h t ht hz)

/-- If padding makes every member exactly alignable, the canonical output is a
single FP32 RTZ conversion of the independently decoded ideal sum. -/
theorem evalBlock_exact_alignment {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (he : evalBlock x = .ok t) (ha : t.block.AlignmentExact) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.exactDot = some t.output.bits := by
  have hout := evalPrepared_output (evalBlock_evalPrepared he)
  rw [exact_alignment_accumulator t.block ha] at hout
  exact ⟨by simp [exactDot, evalBlock_prepared he], hout⟩

end TensorCore
