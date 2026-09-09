-- Static Budget for the tensor-core model.

import TensorCore.TC.Program.StaticCertificate
import TensorCore.TC.Regression.Cases

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

/-- Eight V100 groups of four products `(1 − 2^-11)(1 + 2^-10)` from `c = 1`. Every raw
product has scale `0`, and the ideal partial sums stay below `2^6`. -/
def staticSchedule : List (List (F16 × F16)) :=
  List.replicate 8 (List.replicate 4 (0x3bff, 0x3c01))

/-- The certificate passes at scale `E = 5` with `L = 3` (five terms `≤ 2^3`), and the
per-group budget is `5·2^-18 + 2^-14 = 21·2^-18`. -/
theorem static_certificate_accepts :
    staticCheck v100F16F32 5 3 0x3f800000 staticSchedule = true ∧
    staticBudget 5 23 5 3 = 21 / 262144 := by decide +kernel

/-- Acceptance and the error bound `8 · 21·2^-18` follow from the certificate alone. -/
theorem static_certificate_applied :
    ∃ f : Finite32, f.bits = 0x3f800000 ∧ ∃ ts products,
      runBlocks v100F16F32 0x3f800000 staticSchedule = .ok ts ∧
      idealContributions v100F16F32 staticSchedule = some products ∧
      absQ (f.value + products - (lastOutput f ts).value) ≤
        (staticSchedule.length : ℚ) * staticBudget (v100F16F32.products + 1)
          v100F16F32.alignFraction 5 3 :=
  staticCheck_sound v100F16F32 5 3 0x3f800000 staticSchedule (by decide +kernel)

/-- The executed run agrees: the outputs, the ideal `1 + 32·2098175·2^-21`, the final error
`7·2^-18`, the trace budget `541·2^-23`, and the static bound `168·2^-18`. -/
theorem static_certificate_consistent :
    (runBlocks v100F16F32 0x3f800000 staticSchedule).map
      (fun ts => ts.map fun t => t.output.bits.toNat) =
      .ok [0x40a00ffc, 0x41100ffc, 0x415017f8, 0x41880ffa, 0x41a813f6, 0x41c817f2, 0x41e81bee,
        0x42040ff5] ∧
    idealContributions v100F16F32 staticSchedule = some (2098175 / 65536) ∧
    (runBlocks v100F16F32 0x3f800000 staticSchedule).map
      (fun ts => absQ (1 + 2098175 / 65536 - (lastOutput ⟨0x3f800000, ⟨8388608, 0, 23⟩,
        by decide⟩ ts).value)) = .ok (7 / 262144) ∧
    (runBlocks v100F16F32 0x3f800000 staticSchedule).map
      (fun ts => sumQ (ts.map BlockTrace.errorBudget)) = .ok (541 / 8388608) ∧
    (8 : ℚ) * staticBudget 5 23 5 3 = 168 / 262144 := by decide +kernel

/-- The certificate refuses a scale the partial sums exceed (`2^5 < 33`) and a group with an
infinite operand. -/
theorem static_certificate_rejects :
    staticCheck v100F16F32 4 3 0x3f800000 staticSchedule = false ∧
    staticCheck v100F16F32 5 3 0x3f800000 [[(0x7c00, 0x3c00), (0, 0), (0, 0), (0, 0)]] = false := by
  decide +kernel

end TensorCore.Regression
