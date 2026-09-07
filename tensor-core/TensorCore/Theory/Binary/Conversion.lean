import TensorCore.Theory.Binary.DirectedRounding
import TensorCore.Theory.Invocation
import TensorCore.Semantics.Profiles

/-! Conversion stages and invocation outputs inherit the format-generic rounding
correctness: a nearest-even stage returns the nearest finite value of its format with ties
to even, and a toward-zero stage returns the largest finite value between zero and its
input. Directed stages select the greatest finite lower bound or least finite upper
bound. The FP16-output candidates, all four FP64 fused directions, and every
FP32-output descriptor are instances. -/

namespace TensorCore

theorem conversionStage_nearestEven_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .nearestEven) (x : Rat) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : NearestEven s.format x d.bits := by
  have hout := conversionStage_output h
  have hr := (conversionStage_range h).2
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_nearestEven_correct s.format hf x hr
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc

theorem conversionStage_towardZero_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .towardZero) (x : Rat) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : TowardZero s.format x d.bits := by
  have hout := conversionStage_output h
  have hr := (conversionStage_range h).2
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardZero_correct s.format hf x hr
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc

/-- The output of any accepted invocation with a nearest-even output stage is the nearest
value of the output format to the intermediate value, ties to even. -/
theorem evalInvocation_output_nearestEven {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .nearestEven) :
    NearestEven p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_nearestEven_correct p.output hv.2.2.2.1 hmode _ _ hout

theorem evalInvocation_output_towardZero {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .towardZero) :
    TowardZero p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_towardZero_correct p.output hv.2.2.2.1 hmode _ _ hout

/-- FP16-output candidates: the final FP16 word is the nearest-even FP16 value of the value
entering the output stage, whichever candidate stage order is chosen. -/
theorem halfDirect_output_nearestEven {x : InvocationInput v100HalfDirectCandidate}
    {t : InvocationTrace v100HalfDirectCandidate} (h : evalInvocation x = .ok t) :
    NearestEven fp16 t.intermediate.value t.output.bits :=
  evalInvocation_output_nearestEven h rfl

theorem halfStaged_output_nearestEven {x : InvocationInput v100HalfStagedCandidate}
    {t : InvocationTrace v100HalfStagedCandidate} (h : evalInvocation x = .ok t) :
    NearestEven fp16 t.intermediate.value t.output.bits :=
  evalInvocation_output_nearestEven h rfl

/-- FP64 fused specification: one correctly rounded result in the stated direction. -/
theorem binary64Fma_nearestEven {x : InvocationInput (binary64Fma .nearestEven)}
    {t : InvocationTrace (binary64Fma .nearestEven)} (h : evalInvocation x = .ok t) :
    NearestEven fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_nearestEven h rfl

theorem binary64Fma_towardZero {x : InvocationInput (binary64Fma .towardZero)}
    {t : InvocationTrace (binary64Fma .towardZero)} (h : evalInvocation x = .ok t) :
    TowardZero fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardZero h rfl

theorem conversionStage_towardNegative_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .towardNegative) (x : Rat) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : TowardNegative s.format x d.bits := by
  have hout := conversionStage_output h
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardNegative_correct s.format hf x
    (conversionStage_range h).2
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc

theorem conversionStage_towardPositive_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .towardPositive) (x : Rat) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : TowardPositive s.format x d.bits := by
  have hout := conversionStage_output h
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardPositive_correct s.format hf x
    (conversionStage_range h).2
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc

theorem evalInvocation_output_towardNegative {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .towardNegative) :
    TowardNegative p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_towardNegative_correct p.output hv.2.2.2.1 hmode _ _ hout

theorem evalInvocation_output_towardPositive {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .towardPositive) :
    TowardPositive p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_towardPositive_correct p.output hv.2.2.2.1 hmode _ _ hout

theorem binary64Fma_towardNegative {x : InvocationInput (binary64Fma .towardNegative)}
    {t : InvocationTrace (binary64Fma .towardNegative)} (h : evalInvocation x = .ok t) :
    TowardNegative fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardNegative h rfl

theorem binary64Fma_towardPositive {x : InvocationInput (binary64Fma .towardPositive)}
    {t : InvocationTrace (binary64Fma .towardPositive)} (h : evalInvocation x = .ok t) :
    TowardPositive fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardPositive h rfl

/-- Fused FP64 rounds the independently decoded exact product plus accumulator;
there is no intermediate rounding. -/
theorem binary64Fma_exact_input {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) : invocationIdeal x = some t.intermediate.value := by
  obtain ⟨_, _, hp, ha, hr, _⟩ := evalInvocation_spec h
  simp only [accumulateInvocation, binary64Fma, Option.some.injEq] at ha
  simp only [binary64Fma, runConversions, Option.some.injEq] at hr
  simp only [invocationIdeal, hp, Option.map_some]
  rw [← hr, ← ha]
  rfl

end TensorCore
