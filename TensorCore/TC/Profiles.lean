-- Profiles for the tensor-core model.

import TensorCore.TC.Invocation

namespace TensorCore

/-- Source-backed FP32-output families. These describe one arithmetic group;
profile names do not assert instruction mapping or independent device conformance. -/
@[implicit_reducible] def alignedInvocation (input : OperandEncoding) (K F : ℕ) (floor : Option ℤ) : InvocationSpec :=
  ⟨input, fp32, K, .aligned F floor .inGroup, [], ⟨fp32, .towardZero⟩⟩

def a100F16Invocation : InvocationSpec := alignedInvocation (packedIEEE fp16) 8 24 (some (-132))
def a100BF16Invocation : InvocationSpec := alignedInvocation (packedIEEE bf16) 8 24 (some (-132))
def a100TF32Invocation : InvocationSpec := alignedInvocation tf32Register 4 24 (some (-132))
def hopperF16Invocation : InvocationSpec := alignedInvocation (packedIEEE fp16) 16 25 (some (-133))
def hopperBF16Invocation : InvocationSpec := alignedInvocation (packedIEEE bf16) 16 25 (some (-133))
def hopperTF32MmaInvocation : InvocationSpec := alignedInvocation tf32Register 8 25 (some (-133))
def hopperTF32WmmaInvocation : InvocationSpec := alignedInvocation tf32Register 4 25 (some (-133))

/-- Finite-domain binary64 fused arithmetic, with an explicit rounding direction. -/
def binary64Fma (mode : BinaryRoundingMode) : InvocationSpec :=
  ⟨packedIEEE fp64, fp64, 1, .fused, [], ⟨fp64, mode⟩⟩

end TensorCore
