-- Long Dot Product for the executable examples.

import TensorCore.All

open TensorCore

/- A supplied order for 32 original FP16 pairs, split into two Hopper groups.
   This declares arithmetic grouping; it does not infer an instruction schedule. -/
def original32 : List (F16 × F16) := List.replicate 32 (0x3c00, 0x3c00)

def hopperGroup : BlockOperands hopperF16F32 :=
  ⟨List.replicate 16 (0x3c00, 0x3c00), by decide⟩

def hopperPartition : OrderedPartition hopperF16F32 original32 :=
  ⟨[hopperGroup, hopperGroup], by decide⟩

def initialZero : Finite32 := ⟨0, ⟨0, 0, 0⟩, by decide⟩

example : ((hopperPartition.run initialZero.bits).toOption.map fun ts =>
    (lastOutput initialZero ts).bits) = some (BitVec.ofNat 32 0x42000000) := by decide +kernel

/- The error theorem concerns the uncorrected output. No correction algorithm
   or final ideal-sum range hypothesis is needed; every intermediate call succeeds. -/
example (ts : List BlockTrace) (h : hopperPartition.run initialZero.bits = .ok ts) :
    absQ (32 - (lastOutput initialZero ts).value) < sumQ (ts.map BlockTrace.errorBudget) := by
  have hi : idealProducts hopperF16F32 original32 = some 32 := by decide +kernel
  have hb := (hopperPartition.uncorrected_error initialZero ts 32 h hi).2 (by decide)
  have hz : initialZero.value + 32 = 32 := by decide +kernel
  rwa [hz] at hb

/- The modular accumulator preserves the whole schedule result at 33 signed bits,
   including rejection behavior for any initial c encoding. -/
example (c : F32) :
    runBlocksMachine 33 hopperF16F32 c hopperPartition.inputs = hopperPartition.run c :=
  fp16Fp32_schedule_machine_eq 16 2 5 33 (some (-133)) (by decide) (by decide) c
    hopperPartition.inputs

#check OrderedPartition.input_count
#check OrderedPartition.ideal
#check OrderedPartition.uncorrected_error

/- The constructor also handles a partial final group: 17 pairs use two Hopper
   invocations, with 15 zero pairs appended to the final group. -/
example : (canonicalPartition 16 2 (some (-133)) (by decide)
    (List.replicate 17 (0x3c00, 0x3c00))).groups.length = 2 := by decide +kernel

#check runCanonicalDot_uncorrected_error_strict
#check runCanonicalDot_machine_eq
