-- Native Scaled Gemm for GEMM.

import TensorCore.Gemm.CostSelection

namespace TensorCore.Regression.NativeScaled

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

def cfg (mode : BinaryRoundingMode) : GemmEpilogue := ⟨mode, mode, ⟨fp32, mode⟩⟩

theorem exact_scaled (model : NativeGemmModel p) (mode : BinaryRoundingMode) :
    (nativeConvertedGemm fp32 mode model (cfg mode) 0x40000000 0xbf800000
      #v[#v[0x3f800000]] #v[#v[0x40400000]] #v[#v[0x3f800000]]).bind
      (fun D => D[0][0].map fun t => (t.product.output.bits, t.scaledProduct.bits, t.scaledC.bits, t.output.bits)) =
      some (0x40400000, 0x40c00000, 0xbf800000, 0x40a00000) := by
  cases p <;> cases model <;> cases mode <;> decide +kernel

theorem native_range_exceeds_fp16 (model : NativeGemmModel p) :
    (nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0x3f800000 0
      #v[#v[0x47800000]] #v[#v[0x3f800000]] #v[#v[0]]).bind
      (fun D => D[0][0].map fun t => t.output.value) = some 65536 ∧
    convertGemmWord fp32 fp16 .nearestEven 0x47800000 = none := by
  cases p <;> cases model <;> decide +kernel

theorem directed_input_conversion (mode : BinaryRoundingMode) :
    convertGemmWord fp32 bf16 mode 0xbf808000 =
      some (if mode = .towardNegative then 0xbf81 else 0xbf80) ∧
    convertGemmWord fp32 tf19 mode 0xbf801000 =
      some (if mode = .towardNegative then 0x5fc01 else 0x5fc00) ∧
    convertGemmWord fp32 bf16 mode 0x3f808000 =
      some (if mode = .towardPositive then 0x3f81 else 0x3f80) ∧
    convertGemmWord fp32 tf19 mode 0x3f801000 =
      some (if mode = .towardPositive then 0x1fc01 else 0x1fc00) := by
  cases mode <;> decide +kernel

theorem subnormal_zero_boundaries (mode : BinaryRoundingMode) :
    convertGemmWord fp32 bf16 mode 0x80000001 =
      some (if mode = .towardNegative then 0x8001 else 0x8000) ∧
    convertGemmWord fp32 tf19 mode 0x80000001 =
      some (if mode = .towardNegative then 0x40001 else 0x40000) ∧
    convertGemmWord fp32 bf16 mode 0x80000000 = some 0 ∧
    convertGemmWord fp32 tf19 mode 0x80000000 = some 0 ∧
    convertGemmWord fp32 bf16 mode 0x7f7f0000 = some 0x7f7f ∧
    convertGemmWord fp32 bf16 mode 0x7f7f0001 = none ∧
    convertGemmWord fp32 tf19 mode 0x7f7fe000 = some 0x3fbff ∧
    convertGemmWord fp32 tf19 mode 0x7f7fe001 = none := by
  cases mode <;> decide +kernel

def tiny (p : NativePrecision) : NativeWord p :=
  match p with | .bf16 => 0x3980 | .tf32 => 0x1cc00

theorem raw_scaled_order_differs (model : NativeGemmModel p) :
    (nativeGemmCell model (List.replicate 15 (tiny p, tiny p)) 0x3f800000).map
      (fun t => t.output.bits) = some 0x3f800007 ∧
    (nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0x3f800000 0x3f800000
      #v[Vector.replicate 15 0x39800000] (Vector.replicate 15 #v[0x39800000]) #v[#v[0x3f800000]]).bind
      (fun D => D[0][0].map fun t => t.output.bits) = some 0x3f800008 := by
  cases p <;> cases model <;> decide +kernel

theorem intermediate_overflow_rejected (model : NativeGemmModel p) (mode : BinaryRoundingMode) :
    (nativeConvertedGemm fp32 mode model (cfg mode) 0x7f7fffff 0xbf800000
      #v[#v[0x40000000]] #v[#v[0x3f800000]] #v[#v[0x7f7fffff]]).bind (fun D => D[0][0]) = none := by
  cases p <;> cases model <;> cases mode <;> decide +kernel

theorem empty_and_rejected_inputs (model : NativeGemmModel p) :
    (nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0x3f800000 0x40000000
      (#v[#v[]] : DenseMatrix F32 1 0) (#v[] : DenseMatrix F32 0 1) #v[#v[0x3f800000]]).bind
      (fun D => D[0][0].map fun t => t.output.bits) = some 0x40000000 ∧
    nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0 0
      (#v[] : DenseMatrix F32 0 1) #v[#v[0x7f800000]] (#v[] : DenseMatrix F32 0 1) = none := by
  cases p <;> cases model <;> decide +kernel

def sourceProblem (p : NativePrecision) : GemmProblem 1 1 1 :=
  .nativeScaled p fp32 .nearestEven 0x3f800000 0 #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]

def candidates : List CostedCandidate :=
  [⟨{model := .ampere, inputMode := .towardPositive}, 0, 0⟩,
   ⟨{model := .hopper}, 1, 1⟩]

theorem source_loss_changes_selection (p : NativePrecision) :
    selectGemmCost (sourceProblem p) candidates (1 / 1000000) = some ⟨{model := .hopper}, 1, 1⟩ ∧
    (analyzeNativeConvertedGemm fp32 .nearestEven (NativeGemmModel.hopper (p := p))
      (cfg .nearestEven) 0x3f800000 0 #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]).bind
      (fun D => D[0][0].map fun a => a.bound.inputConversion) = some (1 / 8388608) := by
  cases p <;> decide +kernel

theorem selected_accuracy (p : NativePrecision) : (sourceProblem p).Accurate {model := .hopper} (1 / 1000000) :=
  (selectGemmCost_sound (sourceProblem p) candidates (1 / 1000000) _ (source_loss_changes_selection p).1).2.1

end TensorCore.Regression.NativeScaled
