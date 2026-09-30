import TensorCore.TC.Specification.Equivalence
import TensorCore.TC.Specification.Profiles

namespace TensorCore.PaperSpec

def implementationProfile : Path → Profile
  | .v100F16 => v100F16F32
  | .ampereF16 => ampereF16F32
  | .hopperF16 => hopperF16F32
  | .ampereBF16 => a100BF16F32
  | .hopperBF16 => hopperBF16F32
  | .ampereTF32 => a100TF32F32
  | .hopperTF32Wmma => hopperTF32WmmaF32
  | .hopperTF32Mma => hopperTF32MmaF32

def supportedInput (path : Path) (x : BlockInput (implementationProfile path)) :
    Input (parameters path) := by
  cases path <;> exact ⟨x.products, x.c⟩

/-- Independent parameter transcription matches each implementation descriptor. -/
theorem supported_parameters (path : Path) :
    parametersOf (implementationProfile path) = parameters path := by cases path <;> rfl

/-- Every supported paper path and every input, with failures observed as none. -/
theorem supported_eq_paper (path : Path) (x : BlockInput (implementationProfile path)) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      bits (parameters path) (supportedInput path x) := by
  cases path <;> exact implementation_eq_paper x

/-- Every paper-valid input of every supported path produces the specified bits. -/
theorem supported_valid_success (path : Path) (x : BlockInput (implementationProfile path))
    (hv : Valid (parameters path) (supportedInput path x)) :
    ∃ t, evalBlock x = .ok t ∧
      bits (parameters path) (supportedInput path x) = some t.output.bits := by
  cases path <;> exact valid_success x hv

/-- The compatibility layer transfers the result to the public aligned invocation API. -/
theorem invocation_eq_paper {p : Profile} (x : BlockInput p) (F : ℕ)
    (hf : p.input.WellFormed) (hF : p.alignFraction = F) :
    invocationBits (x.toInvocation F) = bits (parametersOf p) (inputOf x) := by
  rw [legacy_invocation_bits x F hf hF]
  exact implementation_eq_paper x

/-- Register-level TF32 agreement on every correctly padded input. -/
theorem tf32_eq_paper (K extra : ℕ) (floor : Option ℤ)
    (ps : List (tf32Register.Word × tf32Register.Word)) (c : F32)
    (hp : ∀ pair ∈ ps, tf32Padded pair.1 = true ∧ tf32Padded pair.2 = true) :
    tf32InvocationBits K (23 + extra) floor ps c = tf32Bits K extra floor ps c := by
  have hpad : paddedTF32 ps = true := by
    apply List.all_eq_true.mpr
    intro pair hpair
    obtain ⟨ha, hb⟩ := hp pair hpair
    change (pair.1.toNat % 8192 == 0 && pair.2.toNat % 8192 == 0) = true
    change (pair.1.toNat % 8192 == 0) = true at ha
    change (pair.2.toNat % 8192 == 0) = true at hb
    rw [ha, hb]
    rfl
  rw [tf32_invocation_bits K extra floor ps c hp, implementation_eq_paper]
  simp only [tf32Bits, hpad, ↓reduceIte]
  rfl

end TensorCore.PaperSpec
