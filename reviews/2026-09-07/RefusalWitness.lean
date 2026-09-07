-- Independent proof that the tighter accuracy check is false.
import TensorCore.Programs.ConvertedGemmAnalysis
import TensorCore.Programs.GemmFamily
import TensorCore.Programs.CostSelection

namespace TensorCore.Certificate

set_option maxRecDepth 32768
set_option maxHeartbeats 64000000

def tolerance0 : Rat := (1 / 1000000000)
def a0 : DenseMatrix F16 1 19 := #v[#v[3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072, 3072]]
def b0 : DenseMatrix F16 19 1 := #v[#v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072], #v[3072]]
def c0 : DenseMatrix F32 1 1 := #v[#v[1065353217]]
def w0 : DenseMatrix (List GroupWitness) 1 1 := #v[#v[[⟨0, 0⟩, ⟨0, 0⟩]]]

theorem checked0 : gemmAnalysisCheck .hopper a0 b0 c0
    w0 tolerance0 = false := by decide +kernel


end TensorCore.Certificate
