import TensorCore.Theory.Canonical

namespace TensorCore.Regression

private def paddingInput (extra : Nat) : BlockInput (fp16Fp32Profile 4 extra) :=
  ⟨[(0x3c00, 0x3c00), (0xc00, 0xc00), (0xc00, 0xc00), (0, 0)], 0⟩

/-- Two individually discarded half-ULP products survive one extra alignment bit. -/
theorem extra_alignment_bit_matters :
    ((evalBlock (paddingInput 0)).toOption.map fun t => t.output.bits) = some (BitVec.ofNat 32 0x3f800000) ∧
    ((evalBlock (paddingInput 1)).toOption.map fun t => t.output.bits) = some (BitVec.ofNat 32 0x3f800001) :=
  by decide +kernel

private def onesBlock (K extra : Nat) (floor : Option Int) :
    BlockInput (fp16Fp32Profile K extra floor) := ⟨List.replicate K (0x3c00, 0x3c00), 0⟩

theorem canonical_profile_results :
    ((evalBlock (onesBlock 8 1 (some (-132)))).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x41000000) ∧
    ((evalBlock (onesBlock 16 2 (some (-133)))).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x41800000) ∧
    ((evalBlock (onesBlock 37 9 none)).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x42140000) := by decide +kernel

theorem signed_capacity_prefix :
    (machineAccumulate 8 0 [127, 1, -1]).toInt = 127 ∧
    (machineAccumulate 8 0 [127, 1]).toInt = -128 ∧
    (machineAccumulate 9 0 [127, 1]).toInt = 128 := by decide +kernel

end TensorCore.Regression
