import TensorCore.PaperSpec.GemmComposition
import TensorCore.Regression.GemmInputConversion

namespace TensorCore.Regression

open PaperSpec

set_option maxRecDepth 16384
set_option maxHeartbeats 12000000

theorem paper_gemm_rectangular :
    wmmaGemmBits .v100 gemmA gemmB gemmC =
      #v[#v[some 0x41800000, some 0x42640000, some 0xc1400000],
         #v[some 0xc1300000, some 0xc2480000, some 0x41a80000]] := by
  rw [← gemmBits_eq_paper .v100]
  decide +kernel

theorem paper_gemm_boundaries :
    ((wmmaGemm .v100 gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = some [4, 4] ∧
    ((wmmaGemm .ampere gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = some [2, 2] ∧
    ((wmmaGemm .hopper gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = some [1, 1] := by
  rw [← gemm_eq_paper .v100, ← gemm_eq_paper .ampere, ← gemm_eq_paper .hopper]
  decide +kernel

theorem paper_gemm_empty_and_nonfinite :
    wmmaGemmBits .v100 (#v[#v[]] : DenseMatrix F16 1 0) (#v[] : DenseMatrix F16 0 3)
      #v[#v[0x80000000, 0x3f800000, 0x7fc00000]] = #v[#v[some 0x80000000, some 0x3f800000, none]] ∧
    wmmaGemmBits .hopper (#v[#v[0x7c00], #v[0x3c00]] : DenseMatrix F16 2 1)
      #v[#v[0x3c00]] #v[#v[0], #v[0]] = #v[#v[none], #v[some 0x3f800000]] := by
  rw [← gemmBits_eq_paper .v100, ← gemmBits_eq_paper .hopper]
  decide +kernel

theorem paper_gemm_empty_outputs :
    wmmaGemmBits .ampere (#v[] : DenseMatrix F16 0 1) #v[#v[0x7c00]] #v[] = #v[] ∧
    wmmaGemmBits .hopper #v[#v[0x7c00]] (#v[#v[]] : DenseMatrix F16 1 0) #v[#v[]] = #v[#v[]] := by
  rw [← gemmBits_eq_paper .ampere, ← gemmBits_eq_paper .hopper]
  decide +kernel

def paperOrderA (reverse : Bool) : DenseMatrix F16 1 17 := DenseMatrix.ofFn fun _ l =>
  if l.val = 0 then if reverse then 1 else 0xbc00
  else if l.val = 16 then if reverse then 0xbc00 else 1 else 0

def paperOrderB : DenseMatrix F16 17 1 := DenseMatrix.ofFn fun _ _ => 0x3c00

/-- The same exact terms in a different instruction order have different bits. -/
theorem paper_gemm_instruction_order :
    wmmaGemmBits .ampere (paperOrderA false) paperOrderB gemmOne = #v[#v[some 0x33800000]] ∧
    wmmaGemmBits .ampere (paperOrderA true) paperOrderB gemmOne = #v[#v[some 0]] := by
  rw [← gemmBits_eq_paper .ampere, ← gemmBits_eq_paper .ampere]
  decide +kernel

def paperEdgeA : DenseMatrix F16 17 1 := DenseMatrix.ofFn fun i _ => if i.val = 16 then 0xc000 else 0x3c00
def paperEdgeB : DenseMatrix F16 1 17 := DenseMatrix.ofFn fun _ j => if j.val = 16 then 0x4200 else 0x3c00
def paperEdgeC : DenseMatrix F32 17 17 := DenseMatrix.ofFn fun _ _ => 0

/-- Crossing both output-tile boundaries retains the intended row and column. -/
theorem paper_gemm_output_crop :
    (wmmaGemmBits .hopper paperEdgeA paperEdgeB paperEdgeC)[0][16] = some 0x40400000 ∧
    (wmmaGemmBits .hopper paperEdgeA paperEdgeB paperEdgeC)[16][16] = some 0xc0c00000 := by
  rw [← gemmBits_eq_paper .hopper]
  decide +kernel

/-- The combined public contract is obtained solely from input-check acceptance. -/
theorem paper_source_certificate :
    ∃ a b' D, convertGemmInput fp32 .nearestEven sourceNearOne = some a ∧
      convertGemmInput fp32 .nearestEven sourceNearOne = some b' ∧
      InputConversionContract fp32 .nearestEven sourceNearOne a ∧
      InputConversionContract fp32 .nearestEven sourceNearOne b' ∧
      convertedGemm fp32 .nearestEven .v100 {} 0x3f800000 0 sourceNearOne sourceNearOne sourceZero = some D ∧
      ∀ i : Fin 1, ∀ j : Fin 1, ∃ t z E, D[i.val][j.val] = some t ∧
        (sourceGemmIdeal fp32 0x3f800000 0 sourceNearOne sourceNearOne sourceZero)[i.val][j.val] = some z ∧
        (convertedGemmSourceError fp32 .nearestEven .v100 {} sourceGemmBounds
          0x3f800000 sourceNearOne sourceNearOne)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E ∧
        (wmmaGemm .v100 a b' (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] =
          some (gemmCellObservation t.product) ∧
        t.product.initial.bits = 0 ∧ EpilogueContract {} 0x3f800000 0 sourceZero[i.val][j.val] t :=
  convertedGemmCheck_paper_sound fp32 .nearestEven .v100 {} sourceGemmBounds
    0x3f800000 0 sourceNearOne sourceNearOne sourceZero (by decide +kernel)

end TensorCore.Regression
