import TensorCore.Programs.Gemm

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 8000000

def gemmA : DenseMatrix F16 2 5 :=
  #v[#v[0x3c00, 0x4000, 0x4200, 0x4400, 0x4500],
     #v[0xbc00, 0xc000, 0xc200, 0xc400, 0xc500]]

def gemmB : DenseMatrix F16 5 3 :=
  #v[#v[0x3c00, 0x3c00, 0xbc00], #v[0x3c00, 0x4000, 0xbc00],
     #v[0x3c00, 0x4200, 0xbc00], #v[0x3c00, 0x4400, 0xbc00],
     #v[0x3c00, 0x4500, 0xbc00]]

def gemmC : DenseMatrix F32 2 3 :=
  #v[#v[0x3f800000, 0x40000000, 0x40400000], #v[0x40800000, 0x40a00000, 0x40c00000]]

/-- Rectangular indexing, signs, nonzero C, and all three edge dimensions need padding.
The exact integer matrix is [[16,57,-12],[-11,-50,21]]. -/
theorem gemm_rectangular :
    gemmBits .v100 gemmA gemmB gemmC =
      #v[#v[.ok 0x41800000, .ok 0x42640000, .ok 0xc1400000],
         #v[.ok 0xc1300000, .ok 0xc2480000, .ok 0x41a80000]] := by decide +kernel

def gemmTinyA : DenseMatrix F16 1 17 := DenseMatrix.ofFn fun _ _ => 0x0c00
def gemmTinyB : DenseMatrix F16 17 1 := DenseMatrix.ofFn fun _ _ => 0x0c00
def gemmOne : DenseMatrix F32 1 1 := #v[#v[0x3f800000]]

/-- Seventeen nonzero products require two whole WMMA instructions. The internal
N_FMA groups remain architecture-specific; this does not replace them by one exact sum. -/
theorem gemm_architecture_rounding :
    gemmBits .v100 gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800000]] ∧
    gemmBits .ampere gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800008]] ∧
    gemmBits .hopper gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800008]] := by decide +kernel

/-- Whole-instruction tail padding retains the extra zero normalization groups. -/
theorem gemm_instruction_boundaries :
    ((gemm .v100 gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = .ok [4, 4] ∧
    ((gemm .ampere gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = .ok [2, 2] ∧
    ((gemm .hopper gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = .ok [1, 1] := by decide +kernel

theorem gemm_empty_k :
    gemmBits .v100 (#v[#v[]] : DenseMatrix F16 1 0) (#v[] : DenseMatrix F16 0 2)
      #v[#v[0x80000000, 0x3f800000]] = #v[#v[.ok 0x80000000, .ok 0x3f800000]] := by decide +kernel

theorem gemm_nonfinite :
    gemmBits .hopper (#v[#v[0x7c00], #v[0x3c00]] : DenseMatrix F16 2 1)
      #v[#v[0x3c00]] #v[#v[0], #v[0]] =
      #v[#v[.error .nonfiniteInput], #v[.ok 0x3f800000]] ∧
    gemmBits .v100 (#v[#v[]] : DenseMatrix F16 1 0) (#v[] : DenseMatrix F16 0 1)
      #v[#v[0x7fc00000]] = #v[#v[.error .nonfiniteInput]] := by decide +kernel

theorem gemm_tile_layout :
    (gemmTileOperands gemmA gemmB 0 0 0).1[1][4] = 0xc500 ∧
    (gemmTileOperands gemmA gemmB 0 0 0).1[2][0] = 0 ∧
    (gemmTileOperands gemmA gemmB 0 0 0).2[4][1] = 0x4500 ∧
    (gemmTileOperands gemmA gemmB 0 0 0).2[0][3] = 0 ∧
    (gemmTileSchedule 17 19 33).length = 12 := by decide +kernel

end TensorCore.Regression
