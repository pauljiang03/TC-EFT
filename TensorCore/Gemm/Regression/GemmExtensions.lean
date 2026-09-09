-- Gemm Extensions for GEMM.

import TensorCore.Gemm.Regression.Gemm
import TensorCore.Gemm.ScaledGemmBounds

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 12000000

def smallGemmBounds : GemmBoundConfig := ⟨1, -10, 5, 1⟩

def smallScaledGemmBounds : ScaledGemmBoundConfig := ⟨smallGemmBounds, 0, 0, 2, 3⟩

theorem scaled_certifies_all_profiles :
    scaledGemmCheck .v100 {} smallScaledGemmBounds 0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = true ∧
    scaledGemmCheck .ampere {} smallScaledGemmBounds 0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = true ∧
    scaledGemmCheck .hopper {} smallScaledGemmBounds 0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = true := by decide +kernel

theorem scaled_certificate_rejects_stages :
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with alphaScale := -10}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false ∧
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with betaScale := -2}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false ∧
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with sumScale := 1}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false ∧
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with outputScale := 2}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false := by decide +kernel

theorem gemm_certifies_all_profiles :
    gemmCheck .v100 smallGemmBounds gemmTinyA gemmTinyB gemmOne = true ∧
    gemmCheck .ampere smallGemmBounds gemmTinyA gemmTinyB gemmOne = true ∧
    gemmCheck .hopper smallGemmBounds gemmTinyA gemmTinyB gemmOne = true := by decide +kernel

/-- The certificate proves execution and accuracy without a supplied output trace. -/
theorem certified_tiny (model : WmmaGemmModel) :
    ∃ cell z, (gemm model gemmTinyA gemmTinyB gemmOne)[0][0] = .ok cell ∧
      (gemmIdeal gemmTinyA gemmTinyB gemmOne)[0][0] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError model smallGemmBounds 17 := by
  apply gemmCheck_sound model smallGemmBounds gemmTinyA gemmTinyB gemmOne _ ⟨0, by decide⟩ ⟨0, by decide⟩
  cases model <;> decide +kernel

theorem gemm_certificate_rejects :
    gemmCheck .v100 smallGemmBounds gemmA gemmB gemmC = false ∧
    gemmCheck .hopper {smallGemmBounds with carryBits := 4} gemmTinyA gemmTinyB gemmOne = false ∧
    gemmCheck .ampere {smallGemmBounds with initialBound := 4} gemmTinyA gemmTinyB gemmOne = false ∧
    gemmCheck .v100 smallGemmBounds
      (#v[#v[0x7c00]] : DenseMatrix F16 1 1) #v[#v[0]] #v[#v[0]] = false := by decide +kernel

theorem scaled_rectangular :
    ((scaledGemm .ampere {} 0x40000000 0xbf000000 gemmA gemmB gemmC).map
      fun row => row.map fun t => t.map (·.output.value)) =
      #v[#v[some (59 / 2), some 109, some (-63 / 2)],
         #v[some (-32), some (-225 / 2), some 27]] := by decide +kernel

/-- The C-initialized path and the scalar-epilogue path intentionally differ. -/
theorem scaled_c_placement :
    scaledGemmBits .v100 {} 0x3f800000 0x3f800000 gemmTinyA gemmTinyB gemmOne =
      #v[#v[some 0x3f800008]] ∧
    gemmBits .v100 gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800000]] := by decide +kernel

def emptyGemmA : DenseMatrix F16 1 0 := #v[#v[]]
def emptyGemmB : DenseMatrix F16 0 1 := #v[]

theorem scaled_multiply_rounding :
    scaledGemmBits .v100 {} 0 0x3f800001 emptyGemmA emptyGemmB #v[#v[0x3f800001]] =
      #v[#v[some 0x3f800002]] ∧
    scaledGemmBits .v100 {multiplyMode := .towardPositive} 0 0x3f800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]] = #v[#v[some 0x3f800003]] ∧
    scaledGemmBits .v100 {multiplyMode := .towardNegative} 0 0xbf800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]] = #v[#v[some 0xbf800003]] ∧
    scaledGemmBits .v100 {multiplyMode := .towardZero} 0 0xbf800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]] = #v[#v[some 0xbf800002]] := by decide +kernel

theorem scaled_conversion :
    scaledGemmBits .hopper {output := ⟨fp16, .nearestEven⟩} 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x3f801000]] = #v[#v[some 0x3c00]] ∧
    scaledGemmBits .hopper {output := ⟨fp16, .towardPositive⟩} 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x3f801000]] = #v[#v[some 0x3c01]] ∧
    convertGemmInput fp32 .nearestEven (#v[#v[0x3f801000]] : DenseMatrix F32 1 1) =
      some #v[#v[0x3c00]] ∧
    convertGemmInput fp32 .towardPositive (#v[#v[0x3f801000]] : DenseMatrix F32 1 1) =
      some #v[#v[0x3c01]] := by decide +kernel

theorem scaled_rejections_and_zero :
    scaledGemmBits .v100 {} 0 0x7f800000 emptyGemmA emptyGemmB gemmOne = #v[#v[none]] ∧
    scaledGemmBits .v100 {} 0 0x40000000 emptyGemmA emptyGemmB #v[#v[0x7f7fffff]] = #v[#v[none]] ∧
    scaledGemmBits .v100 {output := ⟨fp16, .towardZero⟩} 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x47800000]] = #v[#v[none]] ∧
    convertGemmInput fp32 .nearestEven (#v[#v[0x7fc00000]] : DenseMatrix F32 1 1) = none ∧
    scaledGemmBits .v100 {} 0x80000000 0x3f800000 emptyGemmA emptyGemmB #v[#v[0x80000000]] =
      #v[#v[some 0]] := by decide +kernel

end TensorCore.Regression
