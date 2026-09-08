import TensorCore.IEEE.Compatibility

namespace TensorCore.IEEE.Regression

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

def rn : Context := ⟨.nearestEven, .afterRounding⟩
def rz : Context := ⟨.towardZero, .afterRounding⟩
def rd : Context := ⟨.towardNegative, .afterRounding⟩
def ru : Context := ⟨.towardPositive, .afterRounding⟩

-- Overflow is determined after rounding with an unbounded exponent range.
theorem near_overflow :
    round .binary16 rn false 65505 = ⟨0x7bff, { inexact := true }⟩ ∧
    round .binary16 rn false 65520 = ⟨0x7c00, { overflow := true, inexact := true }⟩ ∧
    round .binary16 rz false 65535 = ⟨0x7bff, { inexact := true }⟩ ∧
    round .binary16 rz false 65536 = ⟨0x7bff, { overflow := true, inexact := true }⟩ := by
  decide +kernel

theorem directed_overflow :
    round .binary16 rd false (-65505) = ⟨0xfc00, { overflow := true, inexact := true }⟩ ∧
    round .binary16 ru false (-65536) = ⟨0xfbff, { overflow := true, inexact := true }⟩ := by
  decide +kernel

-- A normal delivered result can still have the underflow flag set.
theorem normal_output_underflow :
    round .binary16 rn false (pow2 (-14) - 3 * pow2 (-27)) =
      ⟨0x0400, { underflow := true, inexact := true }⟩ := by decide +kernel

theorem tininess_choice :
    round .binary16 ⟨.nearestEven, .beforeRounding⟩ false (pow2 (-14) - pow2 (-27)) =
      ⟨0x0400, { underflow := true, inexact := true }⟩ ∧
    round .binary16 rn false (pow2 (-14) - pow2 (-27)) =
      ⟨0x0400, { inexact := true }⟩ := by decide +kernel

theorem gradual_underflow :
    round .binary16 rn false (pow2 (-24)) = ⟨1, {}⟩ ∧
    round .binary16 rn false (pow2 (-25)) = ⟨0, { underflow := true, inexact := true }⟩ ∧
    round .binary16 rn false (-pow2 (-25)) = ⟨0x8000, { underflow := true, inexact := true }⟩ ∧
    round .binary16 ru false (pow2 (-25)) = ⟨1, { underflow := true, inexact := true }⟩ := by
  decide +kernel

theorem zero_signs :
    convert .binary64 .binary16 rn 0x8000000000000000 = ⟨0x8000, {}⟩ ∧
    add .binary32 rn 0x80000000 0x80000000 = ⟨0x80000000, {}⟩ ∧
    add .binary32 rd 0 0x80000000 = ⟨0x80000000, {}⟩ ∧
    add .binary32 rn 0 0x80000000 = ⟨0, {}⟩ ∧
    mul .binary32 rn 0x80000000 0xbf800000 = ⟨0, {}⟩ := by decide +kernel

theorem fused_zero_sign :
    fma .binary64 rd 0x3ff0000000000000 0x3ff0000000000000 0xbff0000000000000 =
      ⟨0x8000000000000000, {}⟩ := by decide +kernel

theorem fused_without_intermediate_overflow :
    fma .binary64 rn 0x7fefffffffffffff 0x4000000000000000 0xffefffffffffffff =
      ⟨0x7fefffffffffffff, {}⟩ := by decide +kernel

theorem fused_single_rounding :
    fma .binary32 rn 0x3f800001 0x3f7ffffe 0xbf800000 = ⟨0xa8800000, {}⟩ := by
  decide +kernel

theorem nonfinite_and_payload :
    add .binary32 rn 0x7f800000 0xff800000 = ⟨0x7fc00000, { invalid := true }⟩ ∧
    mul .binary32 rn 0x80000000 0x7f800000 = ⟨0x7fc00000, { invalid := true }⟩ ∧
    add .binary32 rn 0x7fc12345 0xff800007 = ⟨0xffc00007, { invalid := true }⟩ ∧
    add .binary32 rn 0x7fc12345 0x7f800000 = ⟨0x7fc12345, {}⟩ ∧
    fma .binary32 rn 0 0x7f800000 0x7fc12345 = ⟨0x7fc12345, { invalid := true }⟩ := by
  decide +kernel

theorem nan_payload_conversion :
    convert .binary16 .binary64 rn 0xfe01 = ⟨0xfff8040000000000, {}⟩ ∧
    convert .binary16 .binary32 rn 0x7c01 = ⟨0x7fc02000, { invalid := true }⟩ := by
  decide +kernel

theorem sticky_flags :
    (round .binary16 rn false 65505).accumulate { invalid := true, underflow := true } =
      { invalid := true, underflow := true, inexact := true } := by decide +kernel

end TensorCore.IEEE.Regression
