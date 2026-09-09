-- Review Claims for GEMM.

import TensorCore.Gemm.Regression.DecisionExtensions

namespace TensorCore.Regression.ReviewClaims

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

def tinyA : DenseMatrix F16 1 17 := #v[Vector.replicate 17 0x0c00]
def tinyB : DenseMatrix F16 17 1 := Vector.replicate 17 #v[0x0c00]
def unitC : DenseMatrix F32 1 1 := #v[#v[0x3f800000]]

theorem tiny_ideal : (gemmIdeal tinyA tinyB unitC)[0][0] = some (1 + 17 / 16777216) := by
  decide +kernel

theorem tiny_outputs :
    ((gemm .v100 tinyA tinyB unitC)[0][0]).toOption.map (fun c => c.output.value) = some 1 ∧
    ((gemm .ampere tinyA tinyB unitC)[0][0]).toOption.map (fun c => c.output.value) = some (1 + 1 / 1048576) ∧
    ((gemm .hopper tinyA tinyB unitC)[0][0]).toOption.map (fun c => c.output.value) = some (1 + 1 / 1048576) := by
  decide +kernel

theorem positive_error_separates_models :
    absQ ((1 + 17 / 16777216) - (1 + 1 / 1048576)) = 1 / 16777216 ∧
    (0 : ℚ) < 1 / 16777216 ∧ (1 / 16777216 : ℚ) ≤ 1 / 1000000 ∧
    (1 / 1000000 : ℚ) < absQ ((1 + 17 / 16777216) - 1) := by
  decide +kernel

theorem cheaper_model_is_inaccurate : ¬ GemmAccurate .v100 tinyA tinyB unitC (1 / 1000000) := by
  intro h
  obtain ⟨cell, z, hc, hz, he⟩ := h 0 0
  change (gemm .v100 tinyA tinyB unitC)[0][0] = .ok cell at hc
  change (gemmIdeal tinyA tinyB unitC)[0][0] = some z at hz
  have ho := tiny_outputs.1
  rw [hc] at ho
  have hv : cell.output.value = 1 := Option.some.inj ho
  have hi : z = 1 + 17 / 16777216 := Option.some.inj (hz.symm.trans tiny_ideal)
  rw [hv, hi] at he
  exact (Rat.not_le.mpr positive_error_separates_models.2.2.2) he

def chosen : CostedCandidate := ⟨{model := .hopper}, 2, 2⟩

theorem chosen_decision : selectGemmCost costProblem pricedModels (1 / 1000000) = some chosen := by
  decide +kernel

theorem chosen_accuracy_and_minimum : chosen ∈ pricedModels ∧
    GemmAccurate .hopper tinyA tinyB unitC (1 / 1000000) ∧
    ∀ c ∈ pricedModels, candidateCertified costProblem (1 / 1000000) c.configuration = true → chosen.cost ≤ c.cost :=
  selectGemmCost_sound costProblem pricedModels (1 / 1000000) chosen chosen_decision

def nativeTiny : (p : NativePrecision) → NativeWord p
  | .bf16 => 0x3980
  | .tf32 => 0x1cc00

def nativeA (p : NativePrecision) : DenseMatrix (NativeWord p) 1 9 :=
  #v[Vector.replicate 9 (nativeTiny p)]
def nativeB (p : NativePrecision) : DenseMatrix (NativeWord p) 9 1 :=
  Vector.replicate 9 #v[nativeTiny p]

theorem native_positive_error (model : NativeGemmModel p) :
    let A := nativeA p
    let B := nativeB p
    (nativeGemmIdeal model A B unitC)[0][0] = some (1 + 9 / 16777216) ∧
    ((nativeGemm model A B unitC)[0][0]).map (fun c => c.output.value) = some (1 + 1 / 2097152) ∧
    nativeAnalysisCheck model A B unitC
      ((analyzeNativeGemm model A B unitC).map fun row => row.map fun a => (a.map (·.witness)).getD [])
      (1 / 1000000) = true := by
  cases p <;> cases model <;> decide +kernel

theorem native_error_value :
    absQ ((1 + 9 / 16777216) - (1 + 1 / 2097152)) = 1 / 16777216 ∧
    (0 : ℚ) < 1 / 16777216 := by decide +kernel

theorem native_accuracy (model : NativeGemmModel p) :
    NativeGemmAccurate model (nativeA p) (nativeB p) unitC (1 / 1000000) :=
  nativeAnalysisCheck_sound model _ _ _ _ _ (native_positive_error model).2.2

def familyA : DenseMatrix F16 2 1 := #v[#v[0x3c00], #v[0x8c00]]
def secondFamilyA : DenseMatrix F16 2 1 := #v[#v[0xbc00], #v[0x0c00]]
def familyB : DenseMatrix F16 1 2 := #v[#v[0x3c00, 0x0c00]]
def familyC : DenseMatrix F32 2 2 := #v[#v[0x3f800000, 0], #v[0x80000000, 0]]

private theorem within_of_checks (fmt : Format) (caps : DenseMatrix ℚ m n)
    (A : DenseMatrix (BitVec fmt.width) m n)
    (h : ∀ i : Fin m, ∀ j : Fin n,
      let d := ((classify fmt A[i.val][j.val]).finite).getD ⟨0, 0, 0⟩
      (classify fmt A[i.val][j.val]).finite = some d ∧ absQ d.value ≤ caps[i.val][j.val]) :
    EntryWithin fmt caps A := fun i j => ⟨_, h i j⟩

theorem family_member : variedFamily.Contains familyA familyB familyC := by
  exact ⟨within_of_checks _ _ _ (by decide +kernel),
    within_of_checks _ _ _ (by decide +kernel), within_of_checks _ _ _ (by decide +kernel)⟩

theorem second_family_member : variedFamily.Contains secondFamilyA familyB familyC := by
  exact ⟨within_of_checks _ _ _ (by decide +kernel),
    within_of_checks _ _ _ (by decide +kernel), within_of_checks _ _ _ (by decide +kernel)⟩

theorem family_members_distinct : familyA ≠ secondFamilyA := by decide +kernel

theorem family_members_accurate :
    GemmAccurate .hopper familyA familyB familyC (1 / 1000) ∧
    GemmAccurate .hopper secondFamilyA familyB familyC (1 / 1000) :=
  ⟨varied_family_universal _ _ _ family_member, varied_family_universal _ _ _ second_family_member⟩

end TensorCore.Regression.ReviewClaims
