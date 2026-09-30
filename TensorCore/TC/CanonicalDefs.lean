import TensorCore.TC.Invocation

namespace TensorCore

/-- Canonical FP16 products and FP32 c/output, with arbitrary block size and extra alignment bits beyond the baseline 23. -/
@[implicit_reducible] def fp16Fp32Profile (K extraBits : ℕ) (floor : Option ℤ := none) : Profile :=
  ⟨fp16, K, (23 + extraBits : ℕ), floor⟩

@[implicit_reducible] def ampereF16F32 : Profile := fp16Fp32Profile 8 1 (some (-132))
@[implicit_reducible] def hopperF16F32 : Profile := fp16Fp32Profile 16 2 (some (-133))

@[implicit_reducible] def fp16Fp32Invocation (K extraBits : ℕ) (floor : Option ℤ := none) :
    InvocationSpec := (fp16Fp32Profile K extraBits floor).toInvocation (23 + extraBits)

theorem fp16Fp32_v100 : fp16Fp32Profile 4 0 none = v100F16F32 := rfl

end TensorCore
