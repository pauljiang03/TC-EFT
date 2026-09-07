-- INTENTIONALLY INVALID: negative control with a tightened theorem tolerance.
-- tc-certificate-v2: {"cases":[{"a":[3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072],"b":[3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072,3072],"c":[1065353217],"k":19,"m":1,"model":"hopper","n":1,"tolerance":"1/1000000","witness":[[[{"output_scale":0,"scale":0},{"output_scale":0,"scale":0}]]]}],"theory_sha256":"2e3d7845b170bc6e68eb899d3ab329698cd25fc41a8a73c758dbbbc47bc4ae27"}
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
    w0 tolerance0 = true := by decide +kernel

theorem accuracy0 : GemmAccurate .hopper a0 b0 c0 tolerance0 :=
  gemmAnalysisCheck_sound .hopper a0 b0 c0 w0 tolerance0 checked0

end TensorCore.Certificate
