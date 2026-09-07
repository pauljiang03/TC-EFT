import TensorCore.Programs.ExtractionGrid
import TensorCore.Programs.GemmTightInputBounds
import TensorCore.PaperSpec.ScaledGemmEquivalence
import TensorCore.Regression.ScalarEFT
import TensorCore.Regression.GemmSpecification

namespace TensorCore.Regression

open PaperSpec
set_option maxRecDepth 16384
set_option maxHeartbeats 16000000

/-- Eq.20 includes signed coefficients and the strict count-times-cap budget. -/
theorem eq20_signed_budget : magnitudeSum [7, -7, 7, -7] < 2 ^ 5 := by
  apply extraction_coefficient_bound [7, -7, 7, -7] 3 0 5 (by decide)
  · intro z hz
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hz
    rcases hz with h | h | h | h <;> subst z <;> decide +kernel
  · decide +kernel

def eq20Trace : BlockTrace := (evalBlock r3).toOption.get (by decide +kernel)
def eq20Grid : ExtractionGrid eq20Trace := ⟨-19, by decide +kernel⟩

/-- The public paper corollary proves acceptance for a nondefault extraction grid. -/
theorem eq20_public_accepts : eq20Grid.scalarPredicate fp32 (-24) = true := by
  apply eq20Grid.eq20_scalarPredicate fp32 (by decide) (-24) (by decide) (by decide +kernel)
  · intro x hx
    refine ⟨(x.value / pow2 (-24)).floor, ?_⟩
    have hall : eq20Trace.block.terms.all (fun x => decide
        (x.value = ((x.value / pow2 (-24)).floor : Rat) * pow2 (-24))) = true := by decide +kernel
    exact of_decide_eq_true (List.all_eq_true.mp hall x hx)
  all_goals decide +kernel

theorem eq20_public_corrects :
    eq20Grid.scalarCorrected fp32 (-24) = round32 .nearestEven eq20Trace.block.exactDot :=
  eq20Grid.scalarCorrected_eq fp32 (-24) eq20_public_accepts

theorem extraction_alternative_and_finer_rejection :
    eq20Grid.lowParts = [31 / 16777216, 0, 0, 0, 0] ∧
    eq20Grid.overlap = 1 / 1048576 ∧
    (eq20Grid.scalarCorrected fp32 (-24)).map BitVec.toNat = some 0x41080000 ∧
    (eq20Trace.extractAt (-24)).isSome = false := by decide +kernel

theorem extraction_negative_zero_and_subnormal :
    ((evalBlock (⟨[(0xbc00, 1), (0, 0), (0, 0), (0, 0)], 0⟩ : V100Input)).map fun t =>
      (t.defaultExtraction.lowParts, t.defaultExtraction.scalarCorrected fp32 (-24))) =
      .ok ([0, 0, 0, 0, 0], some 0xb3800000) ∧
    ((evalBlock (⟨[(0, 0), (0, 0), (0, 0), (0, 0)], 0⟩ : V100Input)).map fun t =>
      t.defaultExtraction.scalarCorrected fp32 (-149)) = .ok (some 0) ∧
    ((evalBlock subnormalAccumulator).map fun t =>
      t.defaultExtraction.scalarCorrected fp32 (-149)) = .ok none := by decide +kernel

theorem eq20_range_and_strict_boundary :
    ¬ 4 * (2 ^ (4 : Nat) - 1) < 2 ^ (5 : Nat) ∧
    ¬ magnitudeSum [16, -16] < 2 ^ 5 ∧
    naiveSumBinary fp32 [fp32.maxFinite, fp32.maxFinite, -fp32.maxFinite] = none := by decide +kernel

/-- Scalar specification is mathematical; rewrite by the universal bridge and
kernel-check the resulting encodings, including negative underflow and exact zero. -/
theorem independent_scalar_directions :
    scalarRound (layoutOf fp16) .towardNegative (-pow2 (-25)) = some 0x8001 ∧
    scalarRound (layoutOf fp16) .towardPositive (-pow2 (-25)) = some 0x8000 ∧
    scalarRound (layoutOf fp16) .towardZero (-pow2 (-25)) = some 0x8000 ∧
    scalarRound (layoutOf fp16) .nearestEven (-pow2 (-25)) = some 0x8000 ∧
    scalarRound (layoutOf fp16) .towardNegative 0 = some 0 ∧
    scalarRound (layoutOf fp16) .towardPositive (-65504) = some 0xfbff ∧
    scalarRound (layoutOf fp16) .towardZero 65505 = none ∧
    scalarRound (layoutOf (⟨0, 5, 15⟩ : Format)) .nearestEven 0 = none := by
  change scalarRound (layoutOf fp16) (scalarModeOf .towardNegative) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardPositive) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardZero) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .nearestEven) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardNegative) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardPositive) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardZero) _ = _ ∧
    scalarRound (layoutOf _) (scalarModeOf .nearestEven) _ = _
  simp only [scalarRound_eq]
  decide +kernel

theorem independent_scaled_complete :
    (scaledMatrix .v100 (epilogueOf {multiplyMode := .towardNegative}) 0 0xbf800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]]).map
        (fun row => row.map fun cell => cell.map ScaledMatrixCell.output) = #v[#v[some 0xbf800003]] ∧
    (scaledMatrix .hopper (epilogueOf {output := ⟨fp16, .towardZero⟩}) 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x47800000]]).map
        (fun row => row.map fun cell => cell.map ScaledMatrixCell.output) = #v[#v[none]] := by
  rw [← scaledGemmBits_eq_independent .v100, ← scaledGemmBits_eq_independent .hopper]
  decide +kernel

theorem independent_converted_rejection :
    convertedMatrix (layoutOf fp32) (scalarModeOf .nearestEven) .v100 (epilogueOf {}) 0 0
      (#v[#v[0x7fc00000]] : DenseMatrix F32 1 1) sourceZero sourceZero = none := by
  rw [← convertedGemm_eq_independent fp32 .nearestEven .v100]
  decide +kernel

/-- Both improvements are strict on the same accepted input certificate. -/
theorem tight_source_budget :
    scaledGemmTightScalarBudget {} sourceGemmBounds = 897 / 16777216 ∧
    scaledGemmScalarBudget {} sourceGemmBounds = 897 / 8388608 ∧
    convertedGemmTightSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x3f800000 0 sourceNearOne sourceNearOne sourceZero = some #v[#v[28037 / 16777216]] ∧
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x3f800000 0 sourceNearOne sourceNearOne sourceZero = some #v[#v[14471 / 8388608]] ∧
    (28037 / 16777216 : Rat) < 14471 / 8388608 := by decide +kernel

/-- Subnormal cross effects remain bounded, including upward conversion of both
operands. Exact conversions, signed zero and failed input conversion are preserved. -/
theorem tight_input_edges :
    gemmInputProductTightError fp32 .towardPositive [(0x32800000, 0x32800000)] =
      some (15 / 4503599627370496) ∧
    gemmInputProductTightError fp32 .nearestEven [(0x3f800000, 0xbf800000), (0x80000000, 0)] = some 0 ∧
    gemmInputProductTightError fp32 .nearestEven [(0x7fc00000, 0)] = none ∧
    gemmConversionModeError ⟨fp32, .nearestEven⟩ (-126) = pow2 (-150) ∧
    gemmConversionModeError ⟨fp32, .towardNegative⟩ (-126) = pow2 (-149) := by decide +kernel

end TensorCore.Regression
