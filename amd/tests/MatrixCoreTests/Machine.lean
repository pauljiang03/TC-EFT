import MatrixCore

/-! # Fixed-width accumulation

`evalBlockMachine w` accumulates the CDNA 3 products in `w`-bit registers. The proved widths
are enough for every input; these cases show that they are needed. Eight fp16 products
`0x3FFF · 0x3FFF = (2 − 2^-10)^2`, just below 4, align to `4190209 · 2^4` steps of `2^-24`
each, so their sum `536346752` needs 29 magnitude bits and a sign bit. -/

open MatrixCore

namespace MatrixCoreTests.Machine

def nearFour : BlockInput cdna3F16 := ⟨List.replicate 8 0x3FFF, List.replicate 8 0x3FFF, 0⟩

/-- The aligned products as integers. -/
example : (prepare nearFour).map (fun px => alignedBits 1 0 px.p) =
    some (List.replicate 8 67043344) := by decide +kernel

/-- 30 bits give the model's output, `fl{31.96…}`. -/
example : (evalBlockMachine 30 nearFour).map BlockTrace.d = .ok 0x41FFC004 := by decide +kernel

example : evalBlockMachine 30 nearFour = evalBlock nearFour := cdna3F16_machine_eq nearFour

/-- A 29-bit register wraps: the sum becomes `536346752 − 2^29 = −524160` steps. -/
example : (evalBlockMachine 29 nearFour).map BlockTrace.d = .ok 0xBCFFF000 := by decide +kernel

/-! Odd/even grouping: sixteen fp8 E4M3 FNUZ products `0x3F · 0x3F` (significand `1.875`, so a
product significand of `3.515625`) align to `58982400` steps each. Each group of eight sums to
`471859200 < 2^29` and fits 30 bits; their combination needs 31. -/
def fp8Max : BlockInput (cdna3FP8 e4m3fnuz e4m3fnuz) :=
  ⟨List.replicate 16 0x3F, List.replicate 16 0x3F, 0⟩

example : evalBlockMachine 31 fp8Max = evalBlock fp8Max := cdna3FP8_machine_eq _ _ fp8Max

/-- `fl{14.0625}`. -/
example : (evalBlockMachine 31 fp8Max).map BlockTrace.d = .ok 0x41610000 := by decide +kernel

/-- 30 bits wrap in the combination. -/
example : (evalBlockMachine 30 fp8Max).map BlockTrace.d = .ok 0xBFF80000 := by decide +kernel

end MatrixCoreTests.Machine
