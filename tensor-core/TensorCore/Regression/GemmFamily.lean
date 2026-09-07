import TensorCore.Programs.GemmFamily

namespace TensorCore.Regression

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

def unitFamily : GemmFamily := ⟨1, 1, 1⟩
def unitFamilyWitness (model : WmmaGemmModel) : GemmBoundConfig :=
  (inferFamily model 17 unitFamily).getD ⟨0, 0, 0, 0⟩

theorem unit_family_accuracy (model : WmmaGemmModel) :
    GemmFamilyAccurate model unitFamily 2 3 17 (1 / 100) := by
  apply familyCheck_sound model unitFamily (unitFamilyWitness model)
  cases model <;> decide +kernel

theorem family_membership_signed_subnormal :
    unitFamily.Contains (#v[#v[0x8001, 0xbc00, 0x8000]] : DenseMatrix F16 1 3)
      (#v[#v[1], #v[0x3c00], #v[0]] : DenseMatrix F16 3 1)
      (#v[#v[0x80000000]] : DenseMatrix F32 1 1) := by
  refine ⟨?_, ?_, ?_⟩
  · intro i j
    refine ⟨((classify fp16 (#v[#v[0x8001, 0xbc00, 0x8000]] : DenseMatrix F16 1 3)[i.val][j.val]).finite).getD ⟨0, 0, 0⟩, ?_⟩
    revert i j
    decide +kernel
  · intro i j
    refine ⟨((classify fp16 (#v[#v[1], #v[0x3c00], #v[0]] : DenseMatrix F16 3 1)[i.val][j.val]).finite).getD ⟨0, 0, 0⟩, ?_⟩
    revert i j
    decide +kernel
  · intro i j
    refine ⟨⟨0, 0, 0⟩, ?_⟩
    revert i j
    decide +kernel

theorem family_witness_controls :
    familyCheck .v100 17 unitFamily ⟨-126, 0, 3, 1⟩ 1 = false ∧
    familyCheck .v100 17 unitFamily ⟨7, -1, 3, 1⟩ 1 = false ∧
    familyCheck .v100 17 unitFamily ⟨7, 0, 0, 1⟩ 1 = false ∧
    familyCheck .v100 17 unitFamily (unitFamilyWitness .v100) 0 = false ∧
    (inferFamily .v100 17 ⟨65504, 65504, fp32.maxFinite⟩).isSome = false := by decide +kernel

theorem empty_family_accuracy :
    GemmFamilyAccurate .hopper ⟨0, 0, fp32.maxFinite⟩ 2 2 0 0 := by
  apply familyCheck_sound .hopper _ ⟨0, 0, 0, 0⟩
  decide +kernel

theorem family_subnormal_scales :
    familyOperandScale (pow2 (-24)) = -14 ∧
    familyOperandScale 1 = 0 ∧ familyOperandScale 65504 = 15 := by decide +kernel

end TensorCore.Regression
