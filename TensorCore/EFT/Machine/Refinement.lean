-- Refinement for TC-EFT.

import TensorCore.EFT.Machine.Cost
import TensorCore.EFT.Encoded

namespace TensorCore.EFMachine

/-- Bit refinement of the paper-interface reference on every accepted finite input.
Branch tags may differ because bounded scalar acceptance additionally checks the
executed intermediate encodings. Exact consolidation uses a fixed workspace. -/
theorem algorithm1_agrees {path : Path} {x : BlockInput path.profile} {D : F32} {t : BlockTrace}
    (ht : prepareEncodedEFT x D = .ok t) :
    (algorithm1 path x D).map Result.bits = .ok t.algorithm1.bits := by
  obtain ⟨hlen, hx, hD⟩ := prepareEncodedEFT_spec ht
  have hs : TensorCore.exactDot x = some t.block.exactDot := by simp [TensorCore.exactDot, hx]
  have hd : TensorCore.value32 D = some t.output.value := by
    unfold finite32 at hD
    split at hD
    · contradiction
    · rename_i d hd
      have hv := congrArg Finite32.value (Option.some.inj hD)
      simpa [TensorCore.value32, hd, Finite32.value] using congrArg some hv
  obtain ⟨r, hr, hb⟩ := algorithm1_correct hlen hs hd
  rw [hr, Except.map, hb, algorithm1_bits_eq_round]

/-- Conforming model outputs are a corollary, rather than an execution dependency. -/
theorem algorithm1_of_evalBlock {path : Path} {x : BlockInput path.profile} {t : BlockTrace}
    (ht : evalBlock x = .ok t) :
    (algorithm1 path x t.output.bits).map Result.bits = .ok t.algorithm1.bits :=
  algorithm1_agrees (prepareEncodedEFT_of_evalBlock ht)

end TensorCore.EFMachine
