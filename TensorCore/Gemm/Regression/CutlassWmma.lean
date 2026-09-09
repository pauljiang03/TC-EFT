-- Cutlass Wmma for GEMM.

import TensorCore.Gemm.Kernels.CutlassWmma

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 16000000

def cutlassWord (index : ℕ) : F16 :=
  match index % 5 with | 0 => 0 | 1 => 0x3c00 | 2 => 0xbc00 | 3 => 0x3800 | _ => 0xb800

def cutlassA : DenseMatrix F16 65 32 := DenseMatrix.ofFn fun i l => cutlassWord (i.val + l.val)
def cutlassB : DenseMatrix F16 32 67 := DenseMatrix.ofFn fun l j => cutlassWord (l.val + 3 * j.val)
def cutlassC : DenseMatrix F32 65 67 := DenseMatrix.ofFn fun _ _ => 0

/-- Both CTA boundaries, all four warp positions, and K iteration coordinates. -/
theorem cutlass_coordinates :
    CutlassWmma.warpOf 32 32 = 3 ∧ CutlassWmma.warpOf 64 66 = 0 ∧
    CutlassWmma.outputRow 1 0 0 = 64 ∧ CutlassWmma.outputCol 1 0 2 = 66 ∧
    CutlassWmma.addressA 32 64 31 = 2079 ∧ CutlassWmma.addressB 32 31 66 = 2143 ∧
    CutlassWmma.addressD 67 64 66 = 4354 := by decide +kernel

/-- The full fixture is compared independently by check_cutlass.py; the kernel
checks the complete matrix connection for the same 65×67, K=32 inputs. -/
theorem cutlass_fixture_connection :
    CutlassWmma.project (tiles := 2) cutlassA cutlassB = (gemm .v100 cutlassA cutlassB cutlassC).map
      (fun row => row.map fun cell => cell.toOption.map PaperSpec.gemmCellObservation) :=
  CutlassWmma.project_eq_gemm (tiles := 2) cutlassA cutlassB

def cutlassPartialPairs : List (F16 × F16) := List.ofFn fun i : Fin 17 =>
  (if i.val = 0 then 0x3c00 else if i.val = 3 then 0xbc00 else if i.val = 4 then 1 else 0, 0x3c00)

/-- Residue-first (one pair, then sixteen) and tail padding change numerical bits.
The extra zeros model unused slots in the first WMMA tile, not extra operands. -/
theorem cutlass_partial_k_differs :
    ((simulateGemmCell .v100 cutlassPartialPairs 0).toOption.map fun t => t.output.bits) =
      some 0x33800000 ∧
    ((simulateGemmCell .v100 (cutlassPartialPairs.take 1 ++ List.replicate 15 (0, 0) ++
      cutlassPartialPairs.drop 1) 0).toOption.map fun t => t.output.bits) = some 0 ∧
    17 % 16 ≠ 0 := by decide +kernel

end TensorCore.Regression
