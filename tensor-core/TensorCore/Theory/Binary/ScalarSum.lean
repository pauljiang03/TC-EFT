import TensorCore.Theory.Binary.CorrectRounding
import TensorCore.Theory.AccumulatorWidth
import TensorCore.Theory.ScalarSum

/-! TC-EFT Lemma IV.7 and Theorem IV.8 for every well-formed IEEE-style format.
The coefficient budget controls cancellation in every prefix; the separate absolute
range budget permits grids above the largest binade's quantum when the coefficients fit. -/

namespace TensorCore

theorem Format.finiteValue_abs_le (f : Format) {z : Rat} (h : f.FiniteValue z) :
    absQ z ≤ f.maxFinite := by
  obtain ⟨k, e, _, he, hk, rfl⟩ := h
  rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast]
  have hk' : ((k.natAbs : Int) : Rat) ≤ ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) := by
    rw [Rat.intCast_natCast]
    exact Rat.natCast_le_natCast.mpr (by omega)
  exact Rat.le_trans
    (Rat.mul_le_mul_of_nonneg_left (pow2_le_of_le (by omega))
      (Rat.intCast_nonneg.mpr (by omega)))
    (Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _)))

/-- Correct rounding fixes a representable exact result (Lemma IV.7). -/
theorem roundBinary_exact_of_finite (f : Format) (hf : f.WellFormed) {s : Rat}
    (h : f.FiniteValue s) :
    ∃ b, roundBinary f .nearestEven s = some b ∧ binaryValue f b = some s := by
  obtain ⟨b, hb, d, hd, hn, _⟩ := roundBinary_nearestEven_correct f hf s (f.finiteValue_abs_le h)
  have hz := hn s h
  have h0 : absQ (s - s) = 0 := by
    rw [show s - s = 0 by grind]; simp [absQ]
  rw [h0] at hz
  have hle := (absQ_le_iff _ _).mp hz
  have hds : d = s := by grind
  subst hds
  exact ⟨b, hb, hd⟩

/-- Scalar nearest-even addition on values, rejecting exact sums outside the finite range. -/
def binaryAdd (f : Format) (x y : Rat) : Option Rat :=
  (roundBinary f .nearestEven (x + y)).bind (binaryValue f)

theorem binaryAdd_exact (f : Format) (hf : f.WellFormed) (x y : Rat)
    (h : f.FiniteValue (x + y)) : binaryAdd f x y = some (x + y) := by
  obtain ⟨b, hb, hv⟩ := roundBinary_exact_of_finite f hf h
  unfold binaryAdd
  rw [hb]
  exact hv

theorem grid_finiteValue (f : Format) (k ℓ : Int)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (h2 : ℓ ≤ f.emax - f.fractionBits)
    (hk : k.natAbs < 2 ^ (f.fractionBits + 1)) : f.FiniteValue ((k : Rat) * pow2 ℓ) := by
  refine ⟨k, ℓ + f.fractionBits, by omega, by omega, hk, ?_⟩
  rw [show ℓ + f.fractionBits - f.fractionBits = ℓ by omega]

/-- The full grid/range condition of Theorem IV.8; no artificial upper bound on ℓ. -/
theorem grid_finiteValue_of_range (f : Format) (hf : f.WellFormed) (k ℓ : Int)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (hk : k.natAbs < 2 ^ (f.fractionBits + 1))
    (hr : absQ ((k : Rat) * pow2 ℓ) ≤ f.maxFinite) : f.FiniteValue ((k : Rat) * pow2 ℓ) := by
  by_cases h2 : ℓ ≤ f.emax - f.fractionBits
  · exact grid_finiteValue f k ℓ h1 h2 hk
  · let g := f.emax - f.fractionBits
    let n := (ℓ - g).toNat
    have hn : ℓ = g + (n : Int) := by dsimp [n, g]; omega
    have hv : (k : Rat) * pow2 ℓ = ((k * (2 ^ n : Nat) : Int) : Rat) * pow2 g := by
      rw [hn, pow2_add, pow2_natCast, Rat.intCast_mul, Rat.intCast_natCast]
      grind
    rw [hv, absQ_mul_pos _ _ (pow2_pos _), absQ_intCast] at hr
    change (((k * (2 ^ n : Nat)).natAbs : Int) : Rat) * pow2 g ≤
      ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) * pow2 g at hr
    have hcoeff := Rat.le_of_mul_le_mul_right hr (pow2_pos g)
    rw [Rat.intCast_natCast] at hcoeff
    have hcoeff' := Rat.natCast_le_natCast.mp hcoeff
    rw [hv]
    exact grid_finiteValue f _ g (by have := f.emin_le_emax hf; dsimp [g]; omega)
      (Int.le_refl _) (by omega)

def naiveSumBinaryFrom (f : Format) : Rat → List Rat → Option Rat
  | acc, [] => some acc
  | acc, t :: ts => (binaryAdd f acc t).bind fun s => naiveSumBinaryFrom f s ts

def naiveSumBinary (f : Format) (ts : List Rat) : Option Rat := naiveSumBinaryFrom f 0 ts

/-- Every prefix remains representable, including under cancellation and gradual underflow. -/
theorem naiveSumBinaryFrom_exact (f : Format) (hf : f.WellFormed) (ℓ : Int)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (a : Int) (zs : List Int)
    (hbound : a.natAbs + magnitudeSum zs < 2 ^ (f.fractionBits + 1))
    (hrange : ((a.natAbs + magnitudeSum zs : Nat) : Rat) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinaryFrom f ((a : Rat) * pow2 ℓ) (zs.map fun (z : Int) => (z : Rat) * pow2 ℓ) =
      some (((a + sumZ zs : Int) : Rat) * pow2 ℓ) := by
  induction zs generalizing a with
  | nil => simp [naiveSumBinaryFrom, sumZ]
  | cons z zs ih =>
    have hsum : (a : Rat) * pow2 ℓ + (z : Rat) * pow2 ℓ = ((a + z : Int) : Rat) * pow2 ℓ := by
      rw [Rat.intCast_add]; grind
    have habs := Int.natAbs_add_le a z
    have hnext : (a + z).natAbs + magnitudeSum zs ≤ a.natAbs + magnitudeSum (z :: zs) := by
      simp only [magnitudeSum]; omega
    have hrnext : (((a + z).natAbs + magnitudeSum zs : Nat) : Rat) * pow2 ℓ ≤ f.maxFinite :=
      Rat.le_trans (Rat.mul_le_mul_of_nonneg_right (Rat.natCast_le_natCast.mpr hnext)
        (Rat.le_of_lt (pow2_pos _))) hrange
    have hrstep : absQ (((a + z : Int) : Rat) * pow2 ℓ) ≤ f.maxFinite := by
      rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast]
      exact Rat.le_trans (Rat.mul_le_mul_of_nonneg_right
        (Rat.natCast_le_natCast.mpr (Nat.le_add_right _ _)) (Rat.le_of_lt (pow2_pos _))) hrnext
    have hstep : binaryAdd f ((a : Rat) * pow2 ℓ) ((z : Rat) * pow2 ℓ) =
        some (((a + z : Int) : Rat) * pow2 ℓ) := by
      rw [← hsum]
      apply binaryAdd_exact f hf
      rw [hsum]
      exact grid_finiteValue_of_range f hf _ ℓ h1 (by omega) hrstep
    have ih' := ih (a + z) (by omega) hrnext
    simp only [List.map_cons, naiveSumBinaryFrom, hstep, Option.bind_some, ih']
    rw [show a + z + sumZ zs = a + sumZ (z :: zs) by simp only [sumZ]; omega]

/-- Theorem IV.8 with exactly the paper's minimum-grid, coefficient, and absolute-range
conditions. Applied to any ordering of the coefficient list, this proves exact naive sum. -/
theorem naiveSumBinary_exact (f : Format) (hf : f.WellFormed) (ℓ : Int)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (zs : List Int)
    (hbound : magnitudeSum zs < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum zs : Rat) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (zs.map fun (z : Int) => (z : Rat) * pow2 ℓ) = some ((sumZ zs : Rat) * pow2 ℓ) := by
  simpa [naiveSumBinary] using naiveSumBinaryFrom_exact f hf ℓ h1 0 zs
    (by simpa using hbound) (by simpa using hrange)

/-- A convenient grid upper bound discharges the separate absolute-range obligation. -/
theorem coefficient_range_of_grid (f : Format) (ℓ : Int) (L : Nat)
    (h2 : ℓ ≤ f.emax - f.fractionBits) (hL : L < 2 ^ (f.fractionBits + 1)) :
    (L : Rat) * pow2 ℓ ≤ f.maxFinite := by
  have hL' : (L : Rat) ≤ ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) :=
    Rat.natCast_le_natCast.mpr (by omega)
  exact Rat.le_trans (Rat.mul_le_mul_of_nonneg_left (pow2_le_of_le h2) Rat.natCast_nonneg)
    (Rat.mul_le_mul_of_nonneg_right hL' (Rat.le_of_lt (pow2_pos _)))

/-- Table IV, FP64 instance: precision 53 and minimum grid `2^-1074`. -/
theorem naiveSum64_exact (ℓ : Int) (h1 : -1074 ≤ ℓ) (zs : List Int)
    (hbound : magnitudeSum zs < 2 ^ 53)
    (hrange : (magnitudeSum zs : Rat) * pow2 ℓ ≤ fp64.maxFinite) :
    naiveSumBinary fp64 (zs.map fun (z : Int) => (z : Rat) * pow2 ℓ) =
      some ((sumZ zs : Rat) * pow2 ℓ) :=
  naiveSumBinary_exact fp64 (by decide) ℓ h1 zs hbound hrange

set_option maxRecDepth 4096 in
/-- The generic executor specializes to the existing FP32 API, including failures.
These bridges live here because generic rounding already depends on FP32 scalar theory. -/
theorem binaryAdd_fp32 (x y : Rat) : binaryAdd fp32 x y = fp32Add x y := rfl

theorem naiveSumBinaryFrom_fp32 (a : Rat) (ts : List Rat) :
    naiveSumBinaryFrom fp32 a ts = naiveSum32From a ts := by
  induction ts generalizing a with
  | nil => rfl
  | cons t ts ih =>
    simp only [naiveSumBinaryFrom, naiveSum32From, binaryAdd_fp32]
    congr 1
    funext s
    exact ih s

theorem naiveSumBinary_fp32 (ts : List Rat) : naiveSumBinary fp32 ts = naiveSum32 ts :=
  naiveSumBinaryFrom_fp32 0 ts

theorem magnitudeSum_perm {xs ys : List Int} (h : xs.Perm ys) : magnitudeSum xs = magnitudeSum ys := by
  induction h with
  | nil => rfl
  | cons x _ ih => simp only [magnitudeSum, ih]
  | swap x y zs => simp only [magnitudeSum]; omega
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem sumZ_perm {xs ys : List Int} (h : xs.Perm ys) : sumZ xs = sumZ ys := by
  induction h with
  | nil => rfl
  | cons x _ ih => simp only [sumZ, ih]
  | swap x y zs => simp only [sumZ]; omega
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

/-- Explicit any-order form of Theorem IV.8, relative to the original coefficient sum. -/
theorem naiveSumBinary_exact_perm (f : Format) (hf : f.WellFormed) (ℓ : Int)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (xs ys : List Int) (hperm : xs.Perm ys)
    (hbound : magnitudeSum xs < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum xs : Rat) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (ys.map fun (z : Int) => (z : Rat) * pow2 ℓ) =
      some ((sumZ xs : Rat) * pow2 ℓ) := by
  rw [magnitudeSum_perm hperm] at hbound hrange
  rw [naiveSumBinary_exact f hf ℓ h1 ys hbound hrange, sumZ_perm hperm]

/-- Ceiling of log₂ n for positive n, extended by zero at n = 0. -/
def ceilLog2 (n : Nat) : Nat := if n ≤ 1 then 0 else (n - 1).log2 + 1

theorem ceilLog2_le_iff (n c : Nat) : ceilLog2 n ≤ c ↔ n ≤ 2 ^ c := by
  by_cases hn : n ≤ 1
  · simp only [ceilLog2, if_pos hn, Nat.zero_le, true_iff]
    have := Nat.two_pow_pos c
    omega
  · have hlog := Nat.log2_lt (n := n - 1) (k := c) (by omega)
    simp only [ceilLog2, if_neg hn]
    omega

theorem le_two_pow_ceilLog2 (n : Nat) : n ≤ 2 ^ ceilLog2 n :=
  (ceilLog2_le_iff n _).mp (Nat.le_refl _)

/-- The bit-width form of Theorem IV.8's stronger sufficient coefficient budget. -/
theorem coefficient_bitSpan_sufficient (zs : List Int) (B P : Nat)
    (hterm : ∀ z ∈ zs, z.natAbs < 2 ^ B) (hspan : B + ceilLog2 zs.length ≤ P) :
    magnitudeSum zs < 2 ^ P := by
  have h := coefficient_width_sufficient zs B (ceilLog2 zs.length) hterm
    (le_two_pow_ceilLog2 _)
  have hp := Nat.pow_le_pow_right (show 0 < 2 by decide) hspan
  have he : (B + ceilLog2 zs.length + 1) - 1 = B + ceilLog2 zs.length := by omega
  rw [he] at h
  omega

/-- The paper's signed-exponent form: |Tᵢ| < 2^(b+1), Tᵢ = zᵢ 2^ℓ, and
`b − ℓ + 1 + ⌈log₂ n⌉ ≤ P` imply the predicate's strict coefficient budget.
If the term bound lies below the common grid, every coefficient must be zero. -/
theorem bitSpan_coefficient_bound (zs : List Int) (b ℓ : Int) (P : Nat)
    (hterm : ∀ z ∈ zs, absQ ((z : Rat) * pow2 ℓ) < pow2 (b + 1))
    (hspan : b - ℓ + 1 + (ceilLog2 zs.length : Int) ≤ P) : magnitudeSum zs < 2 ^ P := by
  by_cases hB : ℓ ≤ b + 1
  · let B := (b - ℓ + 1).toNat
    have hBe : (B : Int) = b - ℓ + 1 := by dsimp [B]; omega
    apply coefficient_bitSpan_sufficient zs B P
    · intro z hz
      have h := hterm z hz
      rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast] at h
      have he : b + 1 = (B : Int) + ℓ := by omega
      rw [he, pow2_add, pow2_natCast] at h
      exact Rat.natCast_lt_natCast.mp (Rat.lt_of_mul_lt_mul_right h (Rat.le_of_lt (pow2_pos _)))
    · omega
  · have hzero : ∀ z ∈ zs, z.natAbs ≤ 0 := by
      intro z hz
      have h := hterm z hz
      have hgrid := pow2_le_of_le (show b + 1 ≤ ℓ by omega)
      rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast] at h
      have hz1 : (z.natAbs : Rat) * pow2 ℓ < 1 * pow2 ℓ := by grind
      have hz2 : z.natAbs < 1 :=
        Rat.natCast_lt_natCast.mp (Rat.lt_of_mul_lt_mul_right hz1 (Rat.le_of_lt (pow2_pos _)))
      omega
    have := magnitudeSum_le_length_mul zs 0 hzero
    have := Nat.two_pow_pos P
    omega

theorem naiveSumBinary_exact_of_bitSpan (f : Format) (hf : f.WellFormed) (b ℓ : Int)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (zs : List Int)
    (hterm : ∀ z ∈ zs, absQ ((z : Rat) * pow2 ℓ) < pow2 (b + 1))
    (hspan : b - ℓ + 1 + (ceilLog2 zs.length : Int) ≤ f.fractionBits + 1)
    (hrange : (magnitudeSum zs : Rat) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (zs.map fun (z : Int) => (z : Rat) * pow2 ℓ) =
      some ((sumZ zs : Rat) * pow2 ℓ) :=
  naiveSumBinary_exact f hf ℓ h1 zs (bitSpan_coefficient_bound zs b ℓ _ hterm hspan) hrange

end TensorCore
