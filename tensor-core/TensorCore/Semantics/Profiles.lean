import TensorCore.Semantics.Invocation

namespace TensorCore

/-- Source-backed FP32-output families. These describe one arithmetic group;
profile names do not assert instruction mapping or independent device conformance. -/
def alignedInvocation (input : OperandEncoding) (K F : Nat) (floor : Option Int) : InvocationSpec :=
  ⟨input, fp32, K, .aligned F floor .inGroup, [], ⟨fp32, .towardZero⟩⟩

def a100F16Invocation : InvocationSpec := alignedInvocation (packedIEEE fp16) 8 24 (some (-132))
def a100BF16Invocation : InvocationSpec := alignedInvocation (packedIEEE bf16) 8 24 (some (-132))
def a100TF32Invocation : InvocationSpec := alignedInvocation tf32Register 4 24 (some (-132))
def hopperF16Invocation : InvocationSpec := alignedInvocation (packedIEEE fp16) 16 25 (some (-133))
def hopperBF16Invocation : InvocationSpec := alignedInvocation (packedIEEE bf16) 16 25 (some (-133))
def hopperTF32MmaInvocation : InvocationSpec := alignedInvocation tf32Register 8 25 (some (-133))
def hopperTF32WmmaInvocation : InvocationSpec := alignedInvocation tf32Register 4 25 (some (-133))

/-- Competing interpretations retained for reconciliation; these are not yet device profiles. -/
def v100HalfDirectCandidate : InvocationSpec :=
  { v100Invocation with cFormat := fp16, output := ⟨fp16, .nearestEven⟩ }
def v100HalfStagedCandidate : InvocationSpec :=
  { v100HalfDirectCandidate with intermediate := [⟨fp32, .towardZero⟩] }

/-- Finite-domain binary64 fused arithmetic, with an explicit rounding direction. -/
def binary64Fma (mode : BinaryRoundingMode) : InvocationSpec :=
  ⟨packedIEEE fp64, fp64, 1, .fused, [], ⟨fp64, mode⟩⟩

end TensorCore
