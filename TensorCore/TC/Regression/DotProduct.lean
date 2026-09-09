-- Dot Product for the tensor-core model.

import TensorCore.TC.Program.DotProduct
import TensorCore.TC.Program.Partition

namespace TensorCore.Regression

private def negativeGroup : BlockOperands v100F16F32 :=
  ⟨[(0xbc00, 0x3c00), (0, 0), (0, 0), (0, 0)], rfl⟩

private def tinyGroup : BlockOperands v100F16F32 :=
  ⟨[(0xc00, 0xc00), (0, 0), (0, 0), (0, 0)], rfl⟩

private def originalPairs : List (F16 × F16) := negativeGroup.values ++ tinyGroup.values

private def orderedDot : OrderedPartition v100F16F32 originalPairs :=
  ⟨[negativeGroup, tinyGroup], by simp [originalPairs]⟩

private def initialOne : Finite32 := ⟨0x3f800000, ⟨8388608, 0, 23⟩, by decide⟩

theorem partition_original_order : orderedDot.inputs = [negativeGroup.values, tinyGroup.values] ∧
    originalPairs.length = 8 := by decide +kernel

/-- Reordering groups preserves this ideal sum but changes the uncorrected bits.
Cancelling the initial 1 first lets the tiny product survive its own invocation. -/
theorem partition_order_changes_output :
    idealProducts v100F16F32 originalPairs =
      idealProducts v100F16F32 (tinyGroup.values ++ negativeGroup.values) ∧
    ((orderedDot.run initialOne.bits).toOption.map fun ts =>
      (lastOutput initialOne ts).bits) = some (BitVec.ofNat 32 0x33800000) ∧
    ((runV100 initialOne.bits [tinyGroup.values, negativeGroup.values]).toOption.map fun ts =>
      (lastOutput initialOne ts).bits) = some (BitVec.ofNat 32 0) := by decide +kernel

/-- The public theorem applies to the original pair list without a correction step. -/
theorem partition_error_contract (ts : List BlockTrace)
    (h : orderedDot.run initialOne.bits = .ok ts) :
    absQ (pow2 (-24) - (lastOutput initialOne ts).value) <
      sumQ (ts.map BlockTrace.errorBudget) := by
  have hi : idealProducts v100F16F32 originalPairs = some (-1 + pow2 (-24)) := by decide +kernel
  have hb := (orderedDot.uncorrected_error initialOne ts (-1 + pow2 (-24)) h hi).2 (by decide)
  have he : initialOne.value + (-1 + pow2 (-24)) = pow2 (-24) := by
    have hv : initialOne.value = 1 := by decide +kernel
    rw [hv]
    grind
  rwa [he] at hb

private def fivePairs : List (F16 × F16) :=
  [(0x3c00, 0x3c00), (0x4000, 0x3c00), (0x4200, 0x3c00), (0x4400, 0x3c00), (0x4500, 0x3c00)]

theorem constructed_partition_tail :
    (canonicalPartition 4 0 none (by decide) fivePairs).inputs =
      [[(0x3c00, 0x3c00), (0x4000, 0x3c00), (0x4200, 0x3c00), (0x4400, 0x3c00)],
       [(0x4500, 0x3c00), (0, 0), (0, 0), (0, 0)]] ∧
    ((runCanonicalDot 4 0 none (by decide) fivePairs 0).toOption.map fun ts =>
      (lastOutput ⟨0, ⟨0, 0, 0⟩, by decide⟩ ts).bits) =
        some (BitVec.ofNat 32 0x41700000) := by decide +kernel

theorem constructed_partition_boundaries :
    (canonicalPartition 4 0 none (by decide) []).inputs = [] ∧
    runCanonicalDot 4 0 none (by decide) [] 0x3f800000 = .ok [] ∧
    tailPadding 4 8 = 0 ∧ groupCount 4 8 = 2 ∧
    ((runCanonicalDot 16 2 (some (-133)) (by decide)
      (List.replicate 17 (0x3c00, 0x3c00)) 0).toOption.map fun ts =>
        (lastOutput ⟨0, ⟨0, 0, 0⟩, by decide⟩ ts).bits) =
          some (BitVec.ofNat 32 0x41880000) ∧
    runCanonicalDot 4 0 none (by decide) [(0x7c00, 0x3c00)] 0 =
      .error .nonfiniteInput := by decide +kernel

end TensorCore.Regression
