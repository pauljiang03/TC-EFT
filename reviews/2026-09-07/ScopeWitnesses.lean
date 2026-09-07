import TensorCore

open TensorCore
namespace IndependentReview

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

-- Both finite-domain restrictions are executable behavior, not missing proofs.
theorem rejects_near_maximum : roundBinary fp16 .nearestEven 65505 = none := by
  decide +kernel

theorem rejects_directed_overflow : roundBinary fp16 .towardZero 65536 = none := by
  decide +kernel

-- Encoding supports two zeros, but scalar conversion deliberately forgets the
-- sign when the exact value is zero, including a same-format conversion.
theorem negative_zero_conversion :
    convertGemmWord fp32 fp32 .nearestEven 0x80000000 = some 0 := by
  decide +kernel

def cancellation : InvocationInput (binary64Fma .towardNegative) :=
  ⟨[(0x3ff0000000000000, 0x3ff0000000000000)], 0xbff0000000000000⟩

theorem downward_fma_zero : invocationBits cancellation = some 0 := by
  decide +kernel

-- The E4M3 decoder and generic IEEE-style encoder cover different finite sets.
theorem e4m3_top_value :
    ((e4m3.decode (BitVec.ofNat _ 0x7e)).map Decoded.value) = some 448 ∧
    roundBinary e4m3.layout .nearestEven 448 = none := by
  decide +kernel

def fourOnes : PreparedBlock :=
  ⟨v100F16F32, List.replicate 4 (⟨1024, 0, 10⟩, ⟨1024, 0, 10⟩), ⟨0, 0, 0⟩⟩

-- Recovery alone does not constrain a supplied output at all.
theorem arbitrary_output_recovery :
    fourOnes.exactDot = 4 ∧ fourOnes.extractReference 123 = -119 ∧
    123 + fourOnes.extractReference 123 = fourOnes.exactDot := by
  decide +kernel

-- A concrete finite, nonempty family where tensor-core behavior is neither
-- exact arithmetic nor a single correctly rounded dot product.
def a : DenseMatrix F16 1 17 := #v[Vector.replicate 17 0x0c00]
def b : DenseMatrix F16 17 1 := Vector.replicate 17 #v[0x0c00]
def c : DenseMatrix F32 1 1 := #v[#v[0x3f800000]]

theorem model_difference :
    (gemmIdeal a b c)[0][0] = some (1 + 17 / 16777216) ∧
    ((gemm .v100 a b c)[0][0]).toOption.map (fun x => x.output.bits) = some 0x3f800000 ∧
    ((gemm .hopper a b c)[0][0]).toOption.map (fun x => x.output.bits) = some 0x3f800008 ∧
    roundBinary fp32 .nearestEven (1 + 17 / 16777216) = some 0x3f800008 := by
  decide +kernel

-- Ordinary increasing sums can produce a decreasing tensor-core output.
def lowered : BlockInput v100F16F32 :=
  ⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f7fffff⟩
def raised : BlockInput v100F16F32 :=
  ⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f800000⟩

theorem nonmonotonicity :
    exactDot lowered = some (1 + 3 / 16777216) ∧
    exactDot raised = some (1 + 4 / 16777216) ∧
    (evalBlock lowered).toOption.map (fun x => x.output.bits) = some 0x3f800001 ∧
    (evalBlock raised).toOption.map (fun x => x.output.bits) = some 0x3f800000 := by
  decide +kernel

#print axioms rejects_near_maximum
#print axioms negative_zero_conversion
#print axioms downward_fma_zero
#print axioms arbitrary_output_recovery
#print axioms model_difference
#print axioms nonmonotonicity

end IndependentReview
