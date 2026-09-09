import TensorCore.IEEE.NativeOperations

namespace TensorCore.IEEE.LeanBridge

/-- An exact midpoint keeps the even low bit and reports inexact. -/
theorem native_add_tie_even :
    addWithLean .binary32 {} 0x3f800000 0x33800000 =
      ⟨0x3f800000, { inexact := true }⟩ := by decide +kernel

theorem native_add_tie_odd :
    addWithLean .binary32 {} 0x3f800001 0x33800000 =
      ⟨0x3f800002, { inexact := true }⟩ := by decide +kernel

theorem native_add_subnormals :
    addWithLean .binary32 {} 1 1 = ⟨2, {}⟩ := by decide +kernel

theorem native_add_normal_boundary :
    addWithLean .binary32 {} 0x007fffff 1 = ⟨0x00800000, {}⟩ := by decide +kernel

theorem native_add_cancellation :
    addWithLean .binary32 {} 0xbf800000 0x3f800000 = ⟨0, {}⟩ := by decide +kernel

theorem native_add_negative :
    addWithLean .binary32 {} 0xbf800000 0xbf800000 = ⟨0xc0000000, {}⟩ := by decide +kernel

/-- Signed-zero and exceptional paths retain the reference's full contract. -/
theorem native_add_negative_zeros :
    addWithLean .binary32 {} 0x80000000 0x80000000 = ⟨0x80000000, {}⟩ := by decide +kernel

theorem native_add_overflow_fallback :
    addWithLean .binary32 {} 0x7f7fffff 0x7f7fffff =
      ⟨0x7f800000, { overflow := true, inexact := true }⟩ := by decide +kernel

theorem native_add_nan_payload_fallback :
    addWithLean .binary32 {} 0x7fc00007 0xff800003 =
      ⟨0xffc00003, { invalid := true }⟩ := by decide +kernel

theorem native_add_directed_fallback :
    addWithLean .binary32 { mode := .towardNegative } 0xbf800000 0x3f800000 =
      ⟨0x80000000, {}⟩ := by decide +kernel

theorem native_sub_cancellation :
    subWithLean .binary32 {} 0xbf800000 0xbf800000 = ⟨0, {}⟩ := by decide +kernel

theorem native_sub_negative :
    subWithLean .binary32 {} 0xbf800000 0x3f800000 = ⟨0xc0000000, {}⟩ := by decide +kernel

theorem native_mul_half_min_subnormal :
    mulWithLean .binary32 {} 1 0x3f000000 =
      ⟨0, { underflow := true, inexact := true }⟩ := by decide +kernel

theorem native_mul_negative_underflow :
    mulWithLean .binary32 {} 0x80000001 0x3f000000 =
      ⟨0x80000000, { underflow := true, inexact := true }⟩ := by decide +kernel

theorem native_mul_subnormal_exact :
    mulWithLean .binary32 {} 1 0x40000000 = ⟨2, {}⟩ := by decide +kernel

theorem native_mul_signed :
    mulWithLean .binary32 {} 0xbf800000 0x40000000 = ⟨0xc0000000, {}⟩ := by decide +kernel

theorem native_mul_invalid_fallback :
    mulWithLean .binary32 {} 0 0x7f800000 =
      ⟨0x7fc00000, { invalid := true }⟩ := by decide +kernel

theorem native64_add_tie_even :
    addWithLean .binary64 {} 0x3ff0000000000000 0x3ca0000000000000 =
      ⟨0x3ff0000000000000, { inexact := true }⟩ := by decide +kernel

theorem native64_add_tie_odd :
    addWithLean .binary64 {} 0x3ff0000000000001 0x3ca0000000000000 =
      ⟨0x3ff0000000000002, { inexact := true }⟩ := by decide +kernel

theorem native64_sub_cancellation :
    subWithLean .binary64 {} 0xbff0000000000000 0xbff0000000000000 =
      ⟨0, {}⟩ := by decide +kernel

theorem native64_mul_half_min_subnormal :
    mulWithLean .binary64 {} 1 0x3fe0000000000000 =
      ⟨0, { underflow := true, inexact := true }⟩ := by decide +kernel

theorem native64_mul_negative_underflow :
    mulWithLean .binary64 {} 0x8000000000000001 0x3fe0000000000000 =
      ⟨0x8000000000000000, { underflow := true, inexact := true }⟩ := by decide +kernel

theorem native64_add_overflow_fallback :
    addWithLean .binary64 {} 0x7fefffffffffffff 0x7fefffffffffffff =
      ⟨0x7ff0000000000000, { overflow := true, inexact := true }⟩ := by decide +kernel

/-- Directly replacing payload-preserving arithmetic by a native value would
change an observable result; the wrapper must keep this reference path. -/
theorem native_nan_payload_differs :
    (Float32.ofBits 0x7fc00007).toBits.toNat ≠
      (add .binary32 {} 0x7fc00007 0).bits.toNat := by decide +kernel

end TensorCore.IEEE.LeanBridge
