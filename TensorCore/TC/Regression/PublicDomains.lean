-- Public Domains for the tensor-core model.

import TensorCore.TC.Canonical
import TensorCore.TC.Program.Partition

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

theorem zero_product_canonical :
    invocationBits (p := fp16Fp32Invocation 0 0 none) ⟨[], 0x3f800000⟩ = some 0x3f800000 ∧
    invocationBits (p := fp16Fp32Invocation 0 2 (some (-133))) ⟨[], 1⟩ = some 1 ∧
    evalInvocation (p := fp16Fp32Invocation 0 0 none) ⟨[], 0x7fc00000⟩ =
      .error .nonfiniteOrInvalidEncoding ∧
    evalInvocation (p := fp16Fp32Invocation 0 0 none) ⟨[(0, 0)], 0⟩ =
      .error .wrongProductCount := by decide +kernel

theorem fused_requires_one_product :
    ¬ ({v100Invocation with products := 0, accumulation := .fused} : InvocationSpec).Valid ∧
    ¬ ({v100Invocation with products := 2, accumulation := .fused} : InvocationSpec).Valid := by
  decide +kernel

theorem empty_dot_finite_policy :
    runCanonicalDot 4 0 none (by decide) [] 0x7fc00000 = .error .nonfiniteInput ∧
    runCanonicalDot 4 0 none (by decide) [] 0x7f800000 = .error .nonfiniteInput ∧
    runCanonicalDot 4 0 none (by decide) [(0, 0)] 0x7fc00000 = .error .nonfiniteInput ∧
    runCanonicalDot 4 0 none (by decide) [] 0x80000000 = .ok [] ∧
    runBlocks v100F16F32 0x7fc00000 [] = .ok [] ∧
    runCanonicalDotMachine 4 0 29 none (by decide) [] 0x7fc00000 = .error .nonfiniteInput := by
  decide +kernel

theorem finite_range_converter_policy :
    round32 .towardZero (maxFinite32 + 1) = none ∧
    round32 .nearestEven (maxFinite32 + 1) = none ∧
    round32Core .towardZero (maxFinite32 + 1) = some 0x7f7fffff := by decide +kernel

end TensorCore.Regression
