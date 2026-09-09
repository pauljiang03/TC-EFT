import TensorCore.TC.Conversion
import TensorCore.TC.Regression.Cases

/-! The format-generic converter on FP16, BF16, TF32 (`tf19`), and FP64: ties to even,
truncation, the finite-range guard, and the underflow boundary, kernel-checked; and the
correctness theorems instantiated on those four formats. -/

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

/-- Midpoints round to even in every format; truncation keeps the lower neighbor. -/
theorem binary_rounding_ties :
    (roundBinary fp16 .nearestEven (1 + 1 / 2048)).map BitVec.toNat = some 0x3c00 ∧
    (roundBinary fp16 .nearestEven (1 + 3 / 2048)).map BitVec.toNat = some 0x3c02 ∧
    (roundBinary fp16 .towardZero (1 + 3 / 2048)).map BitVec.toNat = some 0x3c01 ∧
    (roundBinary bf16 .nearestEven (1 + 1 / 256)).map BitVec.toNat = some 0x3f80 ∧
    (roundBinary bf16 .nearestEven (1 + 3 / 256)).map BitVec.toNat = some 0x3f82 ∧
    (roundBinary tf19 .nearestEven (1 + 1 / 2048)).map BitVec.toNat = some 0x1fc00 ∧
    (roundBinary tf19 .towardZero (-(1 + 3 / 2048))).map BitVec.toNat = some 0x5fc01 ∧
    (roundBinary fp64 .nearestEven (1 / 3)).map BitVec.toNat = some 0x3fd5555555555555 := by
  decide +kernel

/-- The finite-range guard rejects `65520`, which IEEE FP16 would round to infinity, and
accepts the largest finite value; `2^-25` is a tie below the smallest subnormal and rounds
to zero in both modes. -/
theorem binary_rounding_boundaries :
    roundBinary fp16 .nearestEven 65520 = none ∧
    (roundBinary fp16 .nearestEven 65504).map BitVec.toNat = some 0x7bff ∧
    fp16.maxFinite = 65504 ∧
    (roundBinary fp16 .nearestEven (1 / 33554432)).map BitVec.toNat = some 0 ∧
    (roundBinary fp16 .towardZero (1 / 33554432)).map BitVec.toNat = some 0 := by
  decide +kernel

theorem formats_wellFormed : fp16.WellFormed ∧ bf16.WellFormed ∧ tf19.WellFormed ∧ fp64.WellFormed := by
  decide

/-- Nearest-even and toward-zero correctness on the four formats of the source paths. -/
theorem fp16_rounding_correct (x : ℚ) (hr : absQ x ≤ fp16.maxFinite) :
    (∃ b, roundBinary fp16 .nearestEven x = some b ∧ NearestEven fp16 x b) ∧
    (∃ b, roundBinary fp16 .towardZero x = some b ∧ TowardZero fp16 x b) :=
  ⟨roundBinary_nearestEven_correct fp16 (by decide) x hr,
    roundBinary_towardZero_correct fp16 (by decide) x hr⟩

theorem bf16_rounding_correct (x : ℚ) (hr : absQ x ≤ bf16.maxFinite) :
    (∃ b, roundBinary bf16 .nearestEven x = some b ∧ NearestEven bf16 x b) ∧
    (∃ b, roundBinary bf16 .towardZero x = some b ∧ TowardZero bf16 x b) :=
  ⟨roundBinary_nearestEven_correct bf16 (by decide) x hr,
    roundBinary_towardZero_correct bf16 (by decide) x hr⟩

theorem tf19_rounding_correct (x : ℚ) (hr : absQ x ≤ tf19.maxFinite) :
    (∃ b, roundBinary tf19 .nearestEven x = some b ∧ NearestEven tf19 x b) ∧
    (∃ b, roundBinary tf19 .towardZero x = some b ∧ TowardZero tf19 x b) :=
  ⟨roundBinary_nearestEven_correct tf19 (by decide) x hr,
    roundBinary_towardZero_correct tf19 (by decide) x hr⟩

theorem fp64_rounding_correct (x : ℚ) (hr : absQ x ≤ fp64.maxFinite) :
    (∃ b, roundBinary fp64 .nearestEven x = some b ∧ NearestEven fp64 x b) ∧
    (∃ b, roundBinary fp64 .towardZero x = some b ∧ TowardZero fp64 x b) :=
  ⟨roundBinary_nearestEven_correct fp64 (by decide) x hr,
    roundBinary_towardZero_correct fp64 (by decide) x hr⟩

/-- E4M3 is not an IEEE-style `Format`: its decoder accepts `448` (word `7e`) and `256`
(`78`), while the IEEE-style layout `⟨3, 4, 7⟩` has maximum `240` and `roundBinary` on it
rejects `448`. The generic rounding theorems do not cover E4M3. -/
theorem e4m3_outside_generic_rounding :
    (packedE4M3.decode 0x7e).map Decoded.value = some 448 ∧
    (packedE4M3.decode 0x78).map Decoded.value = some 256 ∧
    e4m3.layout.maxFinite = 240 ∧
    roundBinary e4m3.layout .nearestEven 448 = none ∧
    (roundBinary e4m3.layout .nearestEven 240).map BitVec.toNat = some 0x77 := by
  decide +kernel

/-- The FP32 instance of the generic theorem is the original FP32 theorem's statement. -/
theorem fp32_generic_agrees (x : ℚ) (hr : absQ x ≤ maxFinite32) :
    ∃ b, round32 .nearestEven x = some b ∧ NearestEven32 x b := by
  have h := roundBinary_nearestEven_correct fp32 (by decide) x hr
  obtain ⟨b, hb, hc⟩ := h
  refine ⟨b, ?_, hc⟩
  rw [← roundBinary_fp32 .nearestEven]
  exact hb

end TensorCore.Regression
