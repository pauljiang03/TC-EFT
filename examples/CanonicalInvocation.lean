import TensorCore

open TensorCore

/- One Hopper arithmetic invocation: sixteen FP16 products and FP32 c. -/
def hopperOnes : BlockInput hopperF16F32 :=
  ⟨List.replicate 16 (0x3c00, 0x3c00), 0⟩

example : ((evalBlock hopperOnes).toOption.map fun t => t.output.bits) =
    some (BitVec.ofNat 32 0x41800000) := by decide +kernel

/- Arbitrary block size and padding use the same definitions and proofs. -/
example (K extra carryBits : ℕ) (x : BlockInput (fp16Fp32Profile K extra))
    (t : BlockTrace) (he : evalBlock x = .ok t) (hc : K + 1 ≤ 2 ^ carryBits) :
    t.block.machineAccumulator (26 + extra + carryBits) = t.block.accumulator :=
  (fp16Fp32_contract K extra carryBits none x t he hc).2.2.2

#check fp16Fp32_contract
#check fp16Fp32_machine_eq
#check evalBlock_success_iff
#check evalBlock_machinePrefix
#check canonical_eta_floor_inactive
#check evalBlock_exact_alignment
#check canonical_padding_exact
#check canonical_padding_success_iff
#check canonical_source_padding_exact
#check canonical_source_padding_success_iff
#check fp16Fp32_invocation_compatible
