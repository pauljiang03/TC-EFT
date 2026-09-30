import TensorCore.TC.Instruction
import TensorCoreTests.TC.Cases

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

def zeros (n : ℕ) : List (F16 × F16) := List.replicate n (0, 0)

/-- The published V100 rows fill k positions 0–3 of a k = 16 WMMA: the instruction path returns the single-group output (R3 here), as `single_group_output` proves in general. -/
theorem v100_instruction_single_group :
    v100Wmma16.output 0x3f7fffff (List.replicate 4 (0x3e00, 0x3d00) ++ zeros 12) = some 0x4107ffff ∧
    outputBits r3 = .ok 0x4107ffff := by decide +kernel

/-- Two Ampere groups of eight ones each: 8, then 16. -/
theorem ampere_instruction_two_groups :
    ampereWmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00)) = some 0x41800000 ∧
    ampereWmma16.groups = 2 := by decide +kernel

/-- One Hopper group of sixteen ones. -/
theorem hopper_instruction_one_group :
    hopperWmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00)) = some 0x41800000 ∧
    hopperWmma16.groups = 1 := by decide +kernel

/-- Group order inside an Ampere instruction is observable. -/
theorem ampere_instruction_order_matters :
    ampereWmma16.output 0x3f800000
      ((0xbc00, 0x3c00) :: zeros 7 ++ (0x0001, 0x3c00) :: zeros 7) = some 0x33800000 ∧
    ampereWmma16.output 0x3f800000
      ((0x0001, 0x3c00) :: zeros 7 ++ (0xbc00, 0x3c00) :: zeros 7) = some 0 := by
  decide +kernel


theorem instruction_wrong_width :
    v100Wmma16.output 0 (List.replicate 15 (0x3c00, 0x3c00)) = none ∧
    v100Wmma16.output 0 (List.replicate 17 (0x3c00, 0x3c00)) = none ∧
    v100Wmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00) ++ [(0x7c00, 0x3c00)]) = none ∧
    v100Wmma16.output 0 (List.replicate 15 (0x3c00, 0x3c00) ++ [(0x7c00, 0x3c00)]) = none ∧
    v100Wmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00)) = some 0x41800000 := by
  decide +kernel

end TensorCore.Regression
