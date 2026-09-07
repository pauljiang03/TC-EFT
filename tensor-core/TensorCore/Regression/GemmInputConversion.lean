import TensorCore.Regression.GemmExtensions
import TensorCore.Programs.GemmInputBounds

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 12000000

def sourceNearOne : DenseMatrix F32 1 1 := #v[#v[0x3f801000]]
def sourceZero : DenseMatrix F32 1 1 := #v[#v[0]]
def sourceGemmBounds : ScaledGemmBoundConfig := ⟨⟨6, 0, 3, 0⟩, 7, 0, 8, 9⟩

/-- The old post-conversion error budget alone does not bound the source ideal. -/
theorem source_input_loss_matters :
    (convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x3f800000 0 sourceNearOne sourceNearOne sourceZero).isSome = true ∧
    sourceGemmCellIdeal fp32 0x3f800000 0 0 [(0x3f801000, 0x3f801000)] =
      some ((2049 / 2048 : Rat) * (2049 / 2048)) ∧
    (convertedGemm fp32 .nearestEven .v100 {} 0x3f800000 0 sourceNearOne sourceNearOne sourceZero).map
      (fun out => out.map fun row => row.map fun t => t.map (·.output.bits)) = some #v[#v[some 0x3f800000]] ∧
    scaledGemmStaticError .v100 {} sourceGemmBounds 0x3f800000 1 <
      absQ ((2049 / 2048 : Rat) * (2049 / 2048) - 1) := by decide +kernel

theorem input_modes_and_signs :
    gemmInputDatum fp32 .nearestEven 0x3f801800 = some ⟨4099 / 4096, 1025 / 1024⟩ ∧
    gemmInputDatum fp32 .towardZero 0x3f801800 = some ⟨4099 / 4096, 1⟩ ∧
    gemmInputDatum fp32 .towardNegative 0xbf801800 = some ⟨-4099 / 4096, -1025 / 1024⟩ ∧
    gemmInputDatum fp32 .towardPositive 0xbf801800 = some ⟨-4099 / 4096, -1⟩ := by decide +kernel

/-- Upward conversion of two quarter-subnormal operands needs the cross term.
The two first-order contributions alone are strictly smaller than the true loss. -/
theorem subnormal_cross_term :
    gemmInputDatum fp32 .towardPositive 0x32800000 = some ⟨1 / 67108864, 1 / 16777216⟩ ∧
    gemmInputProductError fp32 .towardPositive [(0x32800000, 0x32800000)] =
      some (15 / 4503599627370496) ∧
    (6 / 4503599627370496 : Rat) < absQ ((1 / 67108864 : Rat) * (1 / 67108864) -
      (1 / 16777216) * (1 / 16777216)) := by decide +kernel

theorem exact_conversion_and_zero_loss :
    gemmInputProductError fp32 .nearestEven [(0x3f800000, 0xbf800000), (0x80000000, 0)] = some 0 ∧
    gemmInputProductError fp16 .towardPositive [(1, 0x8001), (0x7bff, 0x8000)] = some 0 ∧
    gemmInputProductError fp64 .nearestEven [(0x3ff0000000000000, 0xbff0000000000000)] = some 0 ∧
    gemmInputProductError bf16 .towardZero [(0x3f80, 0xbf80)] = some 0 := by decide +kernel

theorem input_range_and_special_rejections :
    gemmInputDatum fp32 .towardZero 0x47800000 = none ∧
    gemmInputDatum fp32 .towardNegative 0xc7800000 = none ∧
    gemmInputDatum fp32 .nearestEven 0x7f800000 = none ∧
    gemmInputDatum fp32 .nearestEven 0x7fc00000 = none ∧
    gemmInputDatum fp32 .nearestEven 0x477fe000 = some ⟨65504, 65504⟩ ∧
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0 0 (#v[#v[0x7fc00000]]) sourceZero sourceZero = none := by decide +kernel

theorem source_empty_dimensions :
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x7fc00000 0 (#v[] : DenseMatrix F32 0 1) sourceNearOne #v[] = some #v[] ∧
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x7fc00000 0 sourceNearOne (#v[#v[]] : DenseMatrix F32 1 0) #v[#v[]] = some #v[#v[]] ∧
    gemmInputProductError fp32 .nearestEven [] = some 0 := by decide +kernel

theorem negative_alpha_source_bound :
    convertedGemmCellSourceError fp32 .nearestEven .v100 {} sourceGemmBounds 0xc0000000
      [(0x3f801000, 0x3f801000)] =
    convertedGemmCellSourceError fp32 .nearestEven .v100 {} sourceGemmBounds 0x40000000
      [(0x3f801000, 0x3f801000)] := by decide +kernel

end TensorCore.Regression
