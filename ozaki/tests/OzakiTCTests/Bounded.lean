import OzakiTCTests.LongFP64
import OzakiTC.Bounded

/-! # Correctly rounded FP64 with bounded registers

The binary64 cases of [`data/correct-reference.json`](../../data/correct-reference.json) through
`tcOzaki1CRBD`, the correctly rounded Ozaki-I whose check, exact path and final rounding run in
integer registers of bounded width, on V100 fp16 blocks with split-K. It returns the exact-fraction
oracle's words with the check settling entries (five, then six slices, `96`-bit window), and with
no check at all (`ss = []`), so that every entry goes through the bounded exact path. -/

open TensorCore Ozaki Ozaki.TC OzakiTCTests.Correct OzakiTCTests.LongFP64

namespace OzakiTCTests.Bounded

example : (do
    let A ← decode64 A_narrow64; let B ← decode64 B_narrow64
    let C ← A.mapM fun x => (transpose B).mapM fun y => tcOzaki1CRBD v100F16F32 11 96 [5, 6] 175 x y
    encode64 C) = some C_narrow64 := by
  decide +kernel

example : (do
    let A ← decode64 A_wide64; let B ← decode64 B_wide64
    let C ← A.mapM fun x => (transpose B).mapM fun y => tcOzaki1CRBD v100F16F32 11 96 [5, 6] 175 x y
    encode64 C) = some C_wide64 := by
  decide +kernel

/-! Every entry through the bounded exact path. -/

example : (do
    let A ← decode64 A_narrow64; let B ← decode64 B_narrow64
    let C ← A.mapM fun x => (transpose B).mapM fun y => tcOzaki1CRBD v100F16F32 11 96 [] 175 x y
    encode64 C) = some C_narrow64 := by
  decide +kernel

example : (do
    let A ← decode64 A_wide64; let B ← decode64 B_wide64
    let C ← A.mapM fun x => (transpose B).mapM fun y => tcOzaki1CRBD v100F16F32 11 96 [] 175 x y
    encode64 C) = some C_wide64 := by
  decide +kernel

end OzakiTCTests.Bounded
