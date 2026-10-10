import OzakiMCTests.LongFP64
import OzakiMC.Bounded

/-! # Correctly rounded FP64 with bounded registers

`mcOzaki1CRBD` on CDNA 3 fp16 blocks with split-K returns the exact-fraction oracle's words on both
binary64 cases, with the check settling entries (five, then six slices, `96`-bit window) and with
every entry through the bounded exact path (`ss = []`). -/

open MatrixCore Ozaki Ozaki.MC OzakiMCTests.LongFP64

namespace OzakiMCTests.Bounded

/-- Correctly rounded FP64 with bounded registers equals the oracle on both cases. -/
def agreesB (P : Profile) (ss : List ℕ) : Bool :=
  [(A_narrow64, B_narrow64, C_narrow64), (A_wide64, B_wide64, C_wide64)].all fun (A, B, C) =>
    let Aq := A.map (·.map val64)
    let Bq := transpose (B.map (·.map val64))
    (Aq.zip (C.map (·.map val64))).all fun (x, crow) =>
      (Bq.zip crow).all fun (y, c) => mcOzaki1CRBD P 11 96 ss 175 x y == some c

example : agreesB cdna3F16 [5, 6] = true := by decide +kernel

example : agreesB cdna3F16 [] = true := by decide +kernel

end OzakiMCTests.Bounded
