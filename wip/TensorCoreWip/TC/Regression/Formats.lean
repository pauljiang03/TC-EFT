import TensorCore.TC.Conversion
import TensorCoreWip.Formats

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

/-- E4M3 is not an IEEE-style `Format`: its decoder accepts `448` (word `7e`) and `256`
(`78`), while the IEEE-style layout `⟨3, 4, 7⟩` has maximum `240` and `roundBinary` on it
rejects `448`. The generic rounding theorems do not cover E4M3. -/
theorem e4m3_outside_generic_rounding :
    (packedE4M3.decode 0x7e).map Decoded.value = some 448 ∧
    (packedE4M3.decode 0x78).map Decoded.value = some 256 ∧
    e4m3.layout.maxFinite = 240 ∧
    roundBinary e4m3.layout .nearestEven 448 = none ∧
    (roundBinary e4m3.layout .nearestEven 240).map BitVec.toNat = some 0x77 := by
  decide +kernel

theorem e5m2_directed_binary :
    (roundBinary e5m2 .towardNegative (-1 / 3)).map BitVec.toNat = some 0xb6 ∧
    (roundBinary e5m2 .towardPositive (-1 / 3)).map BitVec.toNat = some 0xb5 := by
  decide +kernel

end TensorCore.Regression
