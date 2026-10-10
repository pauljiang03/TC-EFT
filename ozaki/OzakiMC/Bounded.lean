import OzakiMC.LongDot
import Ozaki.BoundedOzaki

/-! # Correctly rounded Ozaki-I with bounded registers on the matrix-core model

`Ozaki.ozaki1CRB` on matrix-core blocks with split-K: every slice product on the hardware model,
the check, the exact path and the final rounding in integer registers whose width does not depend
on the inputs' exponents, for binary32 and FP64 inputs of any length. -/

open MatrixCore

namespace Ozaki.MC

def mcOzaki1CRBL (P : Profile) (b W : ℕ) (ss : List ℕ) (smax : ℕ) (x y : List ℚ) : Option ℚ :=
  ozaki1CRB (mcSplitK P b) 24 (-126) 127 b W ss smax x y

def mcOzaki1CRBD (P : Profile) (b W : ℕ) (ss : List ℕ) (smax : ℕ) (x y : List ℚ) : Option ℚ :=
  ozaki1CRB (mcSplitK P b) 53 (-1022) 1023 b W ss smax x y

theorem mcOzaki1CRBL_eq {P : Profile} {b : ℕ} (hP : ExactEngine P b) (hb : 2 * b ≤ 24) (W : ℕ)
    (ss : List ℕ) {smax : ℕ} (hsmax : 277 < smax * (b + 1)) {x y : List ℚ}
    (hx : ∀ a ∈ x, Binary32Value a) (hy : ∀ a ∈ y, Binary32Value a) (hlen : x.length = y.length) :
    mcOzaki1CRBL P b W ss smax x y = rne32Q (dot x y) :=
  ozaki1CRB32_eq (mcSplitK_exactOn hP hb _) W ss (by omega) hsmax hlen (Nat.le_refl _) hx hy

/-- **Correctly rounded FP64 GEMM on AMD matrix cores with bounded registers.** -/
theorem mcOzaki1CRBD_eq {P : Profile} {b : ℕ} (hP : ExactEngine P b) (hb : 2 * b ≤ 24) (W : ℕ)
    (ss : List ℕ) {smax : ℕ} (hsmax : 2098 < smax * (b + 1)) {x y : List ℚ}
    (hx : ∀ a ∈ x, Binary64Value a) (hy : ∀ a ∈ y, Binary64Value a) (hlen : x.length = y.length) :
    mcOzaki1CRBD P b W ss smax x y = rne64 (dot x y) :=
  ozaki1CRB64_eq (mcSplitK_exactOn hP hb _) W ss (by omega) hsmax hlen (Nat.le_refl _) hx hy

end Ozaki.MC
