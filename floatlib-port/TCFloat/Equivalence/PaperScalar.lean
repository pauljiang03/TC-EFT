import TCFloat.Equivalence.Representations
import TensorCore.Numerics.Binary.ResidualBudget

set_option backward.isDefEq.respectTransparency false
set_option maxRecDepth 4096
namespace TCFloat.Equivalence

private theorem fp32_max : TensorCore.fp32.maxFinite=maxFinite32 := by decide +kernel

/-- IV.8/IV.9 with the paper's separate absolute-range test; no artificial upper grid bound. -/
theorem paper_naiveSum_exact (zs : List Int) (e : Int) (hmin : -149 ≤ e)
    (hbudget : (zs.map Int.natAbs).sum < 2^24)
    (hrange : ((zs.map Int.natAbs).sum:Rat)*pow2 e ≤ maxFinite32) :
    naiveSumFrom 0 (zs.map fun (z : Int) => (z:Rat)*pow2 e)=some ((zs.sum:Rat)*pow2 e) := by
  rw [naiveSum_eq]
  have h := TensorCore.naiveSumBinary_exact TensorCore.fp32 (by decide) e hmin zs
    (by simpa only [magnitudeSum_eq,show TensorCore.fp32.fractionBits=23 from rfl] using hbudget)
    (by simpa only [magnitudeSum_eq,pow2_eq,fp32_max] using hrange)
  simpa only [TensorCore.naiveSumBinary_fp32,TensorCore.naiveSum32,pow2_eq,sumZ_eq] using h

/-- Any ordering in IV.8 and IV.9. -/
theorem paper_naiveSum_any_order (xs ys : List Int) (hp : xs.Perm ys) (e : Int)
    (hmin : -149 ≤ e) (hbudget : (xs.map Int.natAbs).sum < 2^24)
    (hrange : ((xs.map Int.natAbs).sum:Rat)*pow2 e ≤ maxFinite32) :
    naiveSumFrom 0 (ys.map fun (z : Int) => (z:Rat)*pow2 e)=some ((xs.sum:Rat)*pow2 e) := by
  have hm : (xs.map Int.natAbs).sum=(ys.map Int.natAbs).sum := (hp.map _).sum_eq
  rw [paper_naiveSum_exact ys e hmin (by rwa [← hm]) (by rwa [← hm]),hp.sum_eq]

/-- Equation (16), specialized to FP32 but allowing the full paper exponent range. -/
theorem paper_bitSpan_exact (zs : List Int) (alpha e : Int) (hmin : -149 ≤ e)
    (hterm : ∀ z ∈ zs, |(z:Rat)*pow2 e| < pow2 (alpha+1))
    (hspan : alpha-e+(TensorCore.ceilLog2 zs.length:Int)<24)
    (hrange : ((zs.map Int.natAbs).sum:Rat)*pow2 e ≤ maxFinite32) :
    naiveSumFrom 0 (zs.map fun (z : Int) => (z:Rat)*pow2 e)=some ((zs.sum:Rat)*pow2 e) := by
  apply paper_naiveSum_exact zs e hmin _ hrange
  simpa only [magnitudeSum_eq] using TensorCore.bitSpan_coefficient_bound zs alpha e 24
    (by simpa only [abs_eq,pow2_eq] using hterm) (by omega)

private theorem sum_coefficients_at (zs : List Int) (e : Int) :
    (zs.map fun (z : Int) => (z:Rat)*pow2 e).sum=(zs.sum:Rat)*pow2 e := by
  induction zs with
  | nil => simp
  | cons z zs ih => simp [ih,add_mul]

/-- The common input grid in IV.9 also contains every extracted low component. -/
theorem paper_lowParts_on_grid (t : Trace) (e : Int) (he : e ≤ t.extractionExponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : Int, x.value=(z:Rat)*pow2 e) :
    t.lowParts=(t.coefficientsAt e).map fun (z : Int) => (z:Rat)*pow2 e := by
  unfold Trace.coefficientsAt Trace.lowParts
  simp only [List.map_map]
  apply List.map_congr_left
  intro x hx
  obtain ⟨z,hz⟩ := hinput x hx
  have hpow : pow2 t.extractionExponent = (2^(t.extractionExponent-e).toNat:Rat)*pow2 e := by
    have h := TensorCore.pow2_add ((t.extractionExponent-e).toNat:Int) e
    rw [TensorCore.pow2_natCast] at h
    have heq : ((t.extractionExponent-e).toNat:Int)+e=t.extractionExponent := by omega
    simpa only [pow2_eq,Nat.cast_pow,Nat.cast_ofNat,heq] using h
  have hr : x.value-truncGrid x.value t.extractionExponent =
      ((z-truncCoeff x.value t.extractionExponent*(2^(t.extractionExponent-e).toNat:Int):Int):Rat)*pow2 e := by
    unfold truncGrid
    rw [hpow,hz]
    push_cast
    ring
  change x.value-truncGrid x.value t.extractionExponent =
    (((x.value-truncGrid x.value t.extractionExponent)/pow2 e).floor:Rat)*pow2 e
  rw [hr,mul_div_cancel_right₀ _ (show pow2 e ≠ 0 by unfold pow2; positivity),Rat.floor_intCast]

/-- Equation (17) entails the actual residual coefficient budget, including all-zero inputs. -/
theorem paper_input_budget (t : Trace) (e : Int) (he : e ≤ t.extractionExponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : Int, x.value=(z:Rat)*pow2 e)
    (hbudget : t.block.terms.length*(2^(t.extractionExponent-e).toNat-1)<2^24) :
    ((t.coefficientsAt e).map Int.natAbs).sum<2^24 := by
  have hg := paper_lowParts_on_grid t e he hinput
  have hb := TensorCore.extraction_coefficient_bound (t.coefficientsAt e) t.extractionExponent e 24 he
    (by
      intro z hz
      simp only [abs_eq,pow2_eq]
      apply paper_lowPart_bound t
      rw [hg]
      exact List.mem_map.mpr ⟨z,hz,rfl⟩)
    (by simpa [Trace.coefficientsAt,Trace.lowParts] using hbudget)
  simpa only [magnitudeSum_eq] using hb

/-- IV.10: the actual FloatLib FP32 subtraction recovers the retained sum exactly. -/
theorem paper_overlap_subtraction (t : Trace) (hH : representable t.retained=true) :
    add32 t.output (-t.overlap)=some t.retained := by
  have he : t.output + -t.overlap=t.retained := by unfold Trace.overlap; ring
  simpa [he] using representable_add_exact t.output (-t.overlap) (by simpa [he] using hH)

/-- IV.11 under IV.9's full coefficient/range conditions, on any chosen common grid.
This proves the scalar instruction sequence without narrowing it to the executable guard. -/
theorem paper_scalar_on_grid (t : Trace) (e : Int) (hmin : -149 ≤ e)
    (hgrid : t.lowParts=(t.coefficientsAt e).map fun (z : Int) => (z:Rat)*pow2 e)
    (hbudget : ((t.coefficientsAt e).map Int.natAbs).sum<2^24)
    (hrange : (((t.coefficientsAt e).map Int.natAbs).sum:Rat)*pow2 e ≤ maxFinite32)
    (hH : representable t.retained=true) :
    t.scalarUnchecked=round32 .nearestEven t.block.ideal := by
  have hs : naiveSumFrom 0 t.lowParts=some t.lowParts.sum := by
    rw [hgrid,paper_naiveSum_exact _ e hmin hbudget hrange,sum_coefficients_at]
  simp only [Trace.scalarUnchecked,hs,paper_overlap_subtraction t hH,Option.bind_some]
  rw [retained_add_low]

/-- The paper's input-based sufficient condition yields actual FP32 scalar correction. -/
theorem paper_scalar_input_condition (t : Trace) (e : Int) (hmin : -149 ≤ e)
    (he : e ≤ t.extractionExponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : Int, x.value=(z:Rat)*pow2 e)
    (hbudget : t.block.terms.length*(2^(t.extractionExponent-e).toNat-1)<2^24)
    (hrange : (((t.coefficientsAt e).map Int.natAbs).sum:Rat)*pow2 e ≤ maxFinite32)
    (hH : representable t.retained=true) :
    t.scalarUnchecked=round32 .nearestEven t.block.ideal :=
  paper_scalar_on_grid t e hmin (paper_lowParts_on_grid t e he hinput)
    (paper_input_budget t e he hinput hbudget) hrange hH

end TCFloat.Equivalence
