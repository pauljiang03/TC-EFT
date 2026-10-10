import OzakiTC.LongDot
import Ozaki.BoundedOzaki

/-! # Correctly rounded Ozaki-I with bounded registers on the Tensor Core model

`Ozaki.ozaki1CRB` is the correctly rounded Ozaki-I of `Ozaki.ozaki1CRW` with every step after the
engine in integer registers whose width depends on the format, the slice width and the number of
slice products, never on the inputs' exponents: the check on a window sum, the exact path by a
top-down descent over windows with a sign oracle, and the final round to nearest even by a few
integer comparisons. Here its engine is Tensor Core blocks with split-K, so every slice product
runs on the hardware model and the rest in bounded integer arithmetic, for binary32 and FP64
inputs of any length. -/

open TensorCore

namespace Ozaki.TC

/-- Correctly rounded binary32 Ozaki-I of any inner dimension: slice products on Tensor Core
blocks, the check and the exact path in bounded integer registers. -/
def tcOzaki1CRBL (p : Profile) (b W : ℕ) (ss : List ℕ) (smax : ℕ) (x y : List ℚ) : Option ℚ :=
  ozaki1CRB (tcSplitK p b) 24 (-126) 127 b W ss smax x y

/-- Correctly rounded FP64 by Ozaki-I: slice products on Tensor Core blocks, the check and the
exact path in bounded integer registers. -/
def tcOzaki1CRBD (p : Profile) (b W : ℕ) (ss : List ℕ) (smax : ℕ) (x y : List ℚ) : Option ℚ :=
  ozaki1CRB (tcSplitK p b) 53 (-1022) 1023 b W ss smax x y

theorem tcOzaki1CRBL_eq {p : Profile} {b : ℕ} (heng : (tcEngine p).ExactOn b (2 ^ 24))
    (hb : 2 * b ≤ 24) (W : ℕ) (ss : List ℕ) {smax : ℕ} (hsmax : 277 < smax * (b + 1))
    {x y : List ℚ} (hx : ∀ a ∈ x, Binary32Value a) (hy : ∀ a ∈ y, Binary32Value a)
    (hlen : x.length = y.length) :
    tcOzaki1CRBL p b W ss smax x y = rne32Q (dot x y) :=
  ozaki1CRB32_eq (tcSplitK_exactOn heng hb _) W ss (by omega) hsmax hlen (Nat.le_refl _) hx hy

/-- **Correctly rounded FP64 GEMM on Tensor Cores with bounded registers**, for binary64 inputs of
any length. -/
theorem tcOzaki1CRBD_eq {p : Profile} {b : ℕ} (heng : (tcEngine p).ExactOn b (2 ^ 24))
    (hb : 2 * b ≤ 24) (W : ℕ) (ss : List ℕ) {smax : ℕ} (hsmax : 2098 < smax * (b + 1))
    {x y : List ℚ} (hx : ∀ a ∈ x, Binary64Value a) (hy : ∀ a ∈ y, Binary64Value a)
    (hlen : x.length = y.length) :
    tcOzaki1CRBD p b W ss smax x y = rne64 (dot x y) :=
  ozaki1CRB64_eq (tcSplitK_exactOn heng hb _) W ss (by omega) hsmax hlen (Nat.le_refl _) hx hy

/-- FP64 on V100 fp16 with bounded registers: correctly rounded for every length. -/
theorem v100_fp64CRB (W : ℕ) (ss : List ℕ) {x y : List ℚ} (hx : ∀ a ∈ x, Binary64Value a)
    (hy : ∀ a ∈ y, Binary64Value a) (hlen : x.length = y.length) :
    tcOzaki1CRBD v100F16F32 11 W ss 175 x y = rne64 (dot x y) :=
  tcOzaki1CRBD_eq v100_exactOn (by decide) W ss (by decide) hx hy hlen

end Ozaki.TC
