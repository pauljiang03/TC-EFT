import OzakiTC.Schemes
import OzakiTC.Int8
import OzakiTC.ADP
import Ozaki.Correct

/-! # Correct rounding on the Tensor Core model

The enclosure test of `Ozaki.Correct` needs a rounding that returns a nearest representable value
and succeeds on intervals. TensorCore's binary32 and binary64 round to nearest do both
(`round32Value_nearest`, `fp64Round_nearest`, from `round32_nearestEven_correct` and
`roundBinary_correct`). With them:

* `tcOzaki1CR`, `tcOzaki2CR`: Ozaki-I and Ozaki-II on Tensor Core blocks, correctly rounded to
  binary32 for every input on every path where the engine is exact (`tcOzaki1CR_eq`,
  `tcOzaki2CR_eq`);
* `adpCR`: fixed-point Ozaki-I as in ADP on the INT8 engine (fixed point of width `W`, `s` remapped byte slices, exact
  recombination), correctly rounded to binary64 for every input (`adpCR_eq`).

The check runs on the exact values, never on a Tensor Core: a Tensor Core's output is not monotone
in its inputs (TC-EFT's non-monotonicity theorems), and the test relies on monotone rounding. -/

open TensorCore

namespace Ozaki.TC

/-! ## Binary32 round to nearest -/

theorem round32Value_some {q v : ℚ} (h : round32Value q = some v) :
    absQ q ≤ maxFinite32 ∧ ∃ b, round32 .nearestEven q = some b ∧ value32 b = some v := by
  unfold round32Value at h
  cases hb : round32 .nearestEven q with
  | none => simp [hb] at h
  | some b =>
    rw [hb] at h
    refine ⟨?_, b, rfl, h⟩
    unfold round32 at hb
    split at hb
    · cases hb
    · rename_i hgt; exact Rat.not_lt.mp hgt

theorem round32Value_of_le {q : ℚ} (hq : absQ q ≤ maxFinite32) :
    ∃ v, round32Value q = some v ∧ ∀ y, FiniteValue32 y → Rat.abs (q - v) ≤ Rat.abs (q - y) := by
  obtain ⟨b, hb, d, hd, hnear, _⟩ := round32_nearestEven_correct q hq
  refine ⟨d, by simp only [round32Value, hb, Option.bind_some, hd], fun y hy => ?_⟩
  have := hnear y hy
  rwa [absQ_eq, absQ_eq] at this

/-- Binary32 round to nearest returns a nearest binary32 value. -/
theorem round32Value_nearest : RoundsToNearest FiniteValue32 round32Value := by
  intro q v h
  obtain ⟨hr, b, _, hv⟩ := round32Value_some h
  obtain ⟨d, hd, hnear⟩ := round32Value_of_le hr
  rw [h] at hd
  cases hd
  exact ⟨value32_finite b v hv, hnear⟩

theorem abs_le_of_between {a b q c : ℚ} (h1 : a ≤ q) (h2 : q ≤ b) (ha : Rat.abs a ≤ c)
    (hb : Rat.abs b ≤ c) : Rat.abs q ≤ c := by
  rw [abs_le_iff] at *; grind

/-- Binary32 round to nearest succeeds on intervals (it fails only beyond the largest finite
value). -/
theorem round32Value_intervals : RoundsOnIntervals round32Value := by
  intro a b q h1 h2 ha hb
  obtain ⟨va, hva⟩ := Option.isSome_iff_exists.mp ha
  obtain ⟨vb, hvb⟩ := Option.isSome_iff_exists.mp hb
  have ra := (round32Value_some hva).1
  have rb := (round32Value_some hvb).1
  rw [absQ_eq] at ra rb
  have hq := abs_le_of_between h1 h2 ra rb
  rw [← absQ_eq] at hq
  obtain ⟨v, hv, _⟩ := round32Value_of_le hq
  simp [hv]

/-! ## Binary64 round to nearest

`fp64Round` (from `OzakiTC.ADP`) is TensorCore's binary64 round to nearest even, as a value. -/

theorem binaryValue_finiteValue {f : Format} (hf : f.WellFormed) {bits : BitVec f.width} {v : ℚ}
    (h : binaryValue f bits = some v) : f.FiniteValue v := by
  unfold binaryValue at h
  cases hc : (classify f bits).finite with
  | none => simp [hc] at h
  | some d =>
    simp only [hc, Option.map_some, Option.some.injEq] at h
    subst h
    exact classifyNat_finiteValue f hf bits.toNat d hc

theorem fp64Round_some {q v : ℚ} (h : fp64Round q = some v) :
    absQ q ≤ fp64.maxFinite ∧
      ∃ bits, roundBinary fp64 .nearestEven q = some bits ∧ binaryValue fp64 bits = some v := by
  unfold fp64Round at h
  cases hb : roundBinary fp64 .nearestEven q with
  | none => simp [hb] at h
  | some bits =>
    rw [hb] at h
    have hs : (roundBinary fp64 .nearestEven q).isSome = true := by simp [hb]
    exact ⟨((roundBinary_isSome_iff fp64 .nearestEven q).mp hs).2, bits, rfl, h⟩

theorem fp64Round_of_le {q : ℚ} (hq : absQ q ≤ fp64.maxFinite) :
    ∃ v, fp64Round q = some v ∧
      ∀ y, fp64.FiniteValue y → Rat.abs (q - v) ≤ Rat.abs (q - y) := by
  obtain ⟨bits, hb, hspec⟩ := roundBinary_correct fp64 fp64_wellFormed .nearestEven q hq
  obtain ⟨d, hd, hnear, _⟩ : NearestEven fp64 q bits := hspec
  refine ⟨d, by simp only [fp64Round, hb, Option.bind_some, hd], fun y hy => ?_⟩
  have := hnear y hy
  rwa [absQ_eq, absQ_eq] at this

/-- Binary64 round to nearest returns a nearest binary64 value. -/
theorem fp64Round_nearest : RoundsToNearest fp64.FiniteValue fp64Round := by
  intro q v h
  obtain ⟨hr, bits, _, hv⟩ := fp64Round_some h
  obtain ⟨d, hd, hnear⟩ := fp64Round_of_le hr
  rw [h] at hd
  cases hd
  exact ⟨binaryValue_finiteValue fp64_wellFormed hv, hnear⟩

theorem fp64Round_intervals : RoundsOnIntervals fp64Round := by
  intro a b q h1 h2 ha hb
  obtain ⟨va, hva⟩ := Option.isSome_iff_exists.mp ha
  obtain ⟨vb, hvb⟩ := Option.isSome_iff_exists.mp hb
  have ra := (fp64Round_some hva).1
  have rb := (fp64Round_some hvb).1
  rw [absQ_eq] at ra rb
  have hq := abs_le_of_between h1 h2 ra rb
  rw [← absQ_eq] at hq
  obtain ⟨v, hv, _⟩ := fp64Round_of_le hq
  simp [hv]

/-! ## Ozaki-I and Ozaki-II, correctly rounded to binary32 -/

/-- Correctly rounded Ozaki-I on Tensor Core blocks: slice counts `ss` in turn, then the exact
product. -/
def tcOzaki1CR (p : Profile) (b : ℕ) (ss : List ℕ) (x y : List ℚ) : Option ℚ :=
  ozaki1CR (tcEngine p) round32Value b ss x y

/-- Correctly rounded Ozaki-II on Tensor Core blocks: configurations `(basis, P)` in turn, then
the exact product. -/
def tcOzaki2CR (p : Profile) (cfgs : List (CRTBasis × ℕ)) (x y : List ℚ) : Option ℚ :=
  ozaki2CR (tcEngine p) round32Value cfgs x y

def tcOzaki1CRGemm (p : Profile) (b : ℕ) (ss : List ℕ) (A B : List (List ℚ)) :
    Option (List (List ℚ)) :=
  A.mapM fun x => (transpose B).mapM fun y => tcOzaki1CR p b ss x y

def tcOzaki2CRGemm (p : Profile) (cfgs : List (CRTBasis × ℕ)) (A B : List (List ℚ)) :
    Option (List (List ℚ)) :=
  A.mapM fun x => (transpose B).mapM fun y => tcOzaki2CR p cfgs x y

/-- **Ozaki-I on the Tensor Core, correctly rounded.** On any path where the engine is exact on
`b`-bit slices, the result is the binary32 round to nearest of `x · y`, for every input. -/
theorem tcOzaki1CR_eq {p : Profile} {b : ℕ} (hp : IntExact p b) (hh : HoldsInts p b)
    (hK : 0 < p.products) (ss : List ℕ) {x y : List ℚ} (hlen : x.length = y.length)
    (hk : x.length * (2 ^ b * 2 ^ b) ≤ 2 ^ 24) :
    tcOzaki1CR p b ss x y = round32Value (dot x y) :=
  ozaki1CR_eq round32Value_nearest round32Value_intervals (tcEngine_exactOn hp hh hK) ss hlen hk

/-- **Ozaki-II on the Tensor Core, correctly rounded.** -/
theorem tcOzaki2CR_eq {p : Profile} {b : ℕ} (hp : IntExact p b) (hh : HoldsInts p b)
    (hK : 0 < p.products) {cfgs : List (CRTBasis × ℕ)} {x y : List ℚ}
    (hcfg : ∀ c ∈ cfgs, c.1.Valid ∧ (∀ m ∈ c.1.moduli, m ≤ 2 ^ (b + 1)) ∧
      2 * x.length * (2 ^ c.2 * 2 ^ c.2) < c.1.modulus)
    (hlen : x.length = y.length) (hk : x.length * (2 ^ b * 2 ^ b) ≤ 2 ^ 24) :
    tcOzaki2CR p cfgs x y = round32Value (dot x y) :=
  ozaki2CR_eq round32Value_nearest round32Value_intervals (tcEngine_exactOn hp hh hK) hcfg hlen hk

/-- The Z3 models' configuration on V100, correctly rounded: any slice counts. -/
theorem v100_ozaki1CR_z3 (ss : List ℕ) {x y : List ℚ} (hlen : x.length = y.length)
    (hk : x.length = z3K) : tcOzaki1CR v100F16F32 11 ss x y = round32Value (dot x y) :=
  tcOzaki1CR_eq v100_intExact v100_holdsInts (by decide) ss hlen (by rw [hk]; decide)

/-! ## Entirely on the Tensor Core

Binary32 values are multiples of `2^-149` with exponent at most `128`, so `smax` slices of `b` bits
with `smax (b + 1) > 277` leave nothing over, and the exact path runs on Tensor Core blocks too
(`24` slices of `11` bits). -/

theorem finiteValue32_gridMultiple {a : ℚ} (h : FiniteValue32 a) : GridMultiple (-149) a := by
  obtain ⟨k, e, he1, _, _, rfl⟩ := h
  refine ⟨k * ((2 ^ (e + 126).toNat : ℕ) : ℤ), ?_⟩
  rw [pow2_eq, Rat.intCast_mul, Rat.intCast_natCast, ← two_pow_natCast, Rat.mul_assoc,
    ← two_pow_add]
  congr 2; omega

theorem splitExp_le_128 {b : ℕ} (hb : b ≤ 129) {x : List ℚ} (hx : ∀ a ∈ x, FiniteValue32 a) :
    splitExp b x ≤ 128 := by
  by_cases hM : maxAbs x = 0
  · unfold splitExp sliceGrid; rw [if_pos hM]; omega
  · have hpos : 0 < maxAbs x := by have := maxAbs_nonneg x; grind
    rw [(splitExp_spec b hM).1]
    apply (ceilLog2_le_iff hpos 128).mpr
    have hmax : maxFinite32 < (2 : ℚ) ^ (128 : ℤ) := maxFinite32_lt_pow128
    refine maxAbs_le (Rat.le_of_lt (two_pow_pos _)) fun a ha => ?_
    have := finiteValue32_abs_le (hx a ha)
    rw [absQ_eq] at this
    exact Rat.le_of_lt (lt_of_le_of_lt' this hmax)

/-- Correctly rounded Ozaki-I with the exact path on Tensor Core blocks as well. -/
def tcOzaki1CRE (p : Profile) (b : ℕ) (ss : List ℕ) (smax : ℕ) (x y : List ℚ) : Option ℚ :=
  ozaki1CRE (tcEngine p) round32Value b ss smax x y

/-- **Ozaki-I on the Tensor Core, correctly rounded, with every engine product on Tensor Core
blocks.** For binary32 inputs, every result, whether the check settles it or the exact path does,
is the binary32 round to nearest of `x · y`; all slice products, including the exact path's, run on
Tensor Core blocks, while the slicing, their exact sum and the check are exact arithmetic. -/
theorem tcOzaki1CRE_eq {p : Profile} {b : ℕ} (hp : IntExact p b) (hh : HoldsInts p b)
    (hK : 0 < p.products) (ss : List ℕ) {smax : ℕ} (hsmax : 277 < smax * (b + 1)) (hb : b ≤ 129)
    {x y : List ℚ} (hx : ∀ a ∈ x, FiniteValue32 a) (hy : ∀ a ∈ y, FiniteValue32 a)
    (hlen : x.length = y.length) (hk : x.length * (2 ^ b * 2 ^ b) ≤ 2 ^ 24) :
    tcOzaki1CRE p b ss smax x y = round32Value (dot x y) := by
  have hc : ((smax * (b + 1) : ℕ) : ℤ) = (smax : ℤ) * ((b : ℤ) + 1) := by simp
  have h277 : (277 : ℤ) < (smax : ℤ) * ((b : ℤ) + 1) := by rw [← hc]; omega
  have hpos : 0 < smax := by
    rcases Nat.eq_zero_or_pos smax with h | h
    · subst h; simp at hsmax
    · exact h
  have hex := splitExp_le_128 hb hx
  have hey := splitExp_le_128 hb hy
  exact ozaki1CRE_eq round32Value_nearest round32Value_intervals (tcEngine_exactOn hp hh hK) ss
    hlen hk (residualsVanish_of_gridMultiple hpos (fun a ha => finiteValue32_gridMultiple (hx a ha))
      (fun a ha => finiteValue32_gridMultiple (hy a ha)) (by omega) (by omega))

/-- The Z3 configuration on V100 with its exact path on V100 blocks: `11`-bit slices, the exact path at up
to `24` slices. -/
theorem v100_ozaki1CRE (ss : List ℕ) {x y : List ℚ} (hx : ∀ a ∈ x, FiniteValue32 a)
    (hy : ∀ a ∈ y, FiniteValue32 a) (hlen : x.length = y.length) (hk : x.length = z3K) :
    tcOzaki1CRE v100F16F32 11 ss 24 x y = round32Value (dot x y) :=
  tcOzaki1CRE_eq v100_intExact v100_holdsInts (by decide) ss (by decide) (by decide) hx hy hlen
    (by rw [hk]; decide)

/-! ## ADP, correctly rounded to binary64 -/

/-- ADP's fixed-point shift for width `W`: `W − 1 − ⌊log₂ max|x|⌋`, so that `|x 2^shift| < 2^W`. -/
def fixedShift (W : ℕ) (x : List ℚ) : ℤ := (W : ℤ) - 1 - floorLog2 (maxAbs x)

/-- `x` in fixed point of width `W`, as values `Nᵢ 2^(−shift)`. -/
def fixedVals (W : ℕ) (x : List ℚ) : List ℚ :=
  (toFixed (fixedShift W x) x).map fun z : ℤ => (z : ℚ) * 2 ^ (-fixedShift W x)

theorem fixedVals_length (W : ℕ) (x : List ℚ) : (fixedVals W x).length = x.length := by
  simp [fixedVals, toFixed]

/-- The fixed-point bound `max|x − x̃| Σ|y| + max|y − ỹ| Σ|x̃|` (`dot_approx_error`). -/
def adpBound (W : ℕ) (x y : List ℚ) : ℚ :=
  maxAbs (List.zipWith (· - ·) x (fixedVals W x)) * absSum y +
    maxAbs (List.zipWith (· - ·) y (fixedVals W y)) * absSum (fixedVals W x)

/-- The enclosure from `s` slices of width `W`: the exactly recombined INT8 slice products,
rescaled, and the fixed-point bound. -/
def adpEnclosure (s W : ℕ) (x y : List ℚ) : ℚ × ℚ :=
  ((int8Recombine s (toFixed (fixedShift W x) x) (toFixed (fixedShift W y) y) : ℚ) *
      2 ^ (-(fixedShift W x + fixedShift W y)), adpBound W x y)

/-- **Correctly rounded fixed-point Ozaki-I, as in ADP**, for one output entry: configurations `(s, W)`
in turn (not ADP's ESC-driven choice or its guardrails), then the exact
product. -/
def adpCR (cfgs : List (ℕ × ℕ)) (x y : List ℚ) : Option ℚ :=
  certify fp64Round (cfgs.map fun c => some (adpEnclosure c.1 c.2 x y)) (some (dot x y))

def adpCRGemm (cfgs : List (ℕ × ℕ)) (A B : List (List ℚ)) : Option (List (List ℚ)) :=
  A.mapM fun x => (transpose B).mapM fun y => adpCR cfgs x y

/-- Fixed point of width `W` stays in `[−2^W, 2^W − 1]`. -/
theorem toFixed_range (W : ℕ) (x : List ℚ) :
    ∀ z ∈ toFixed (fixedShift W x) x, -((2 ^ W : ℕ) : ℤ) ≤ z ∧ z ≤ ((2 ^ W : ℕ) : ℤ) - 1 := by
  intro z hz
  obtain ⟨a, ha, rfl⟩ := List.mem_map.mp hz
  have hlt : Rat.abs (a * 2 ^ fixedShift W x) < ((2 ^ W : ℕ) : ℚ) := by
    rw [← two_pow_natCast]
    by_cases hM : maxAbs x = 0
    · have h0 := eq_zero_of_maxAbs hM a ha
      subst h0
      rw [Rat.zero_mul, abs_zero]
      exact two_pow_pos _
    · have hpos : 0 < maxAbs x := by have := maxAbs_nonneg x; grind
      obtain ⟨_, hlt⟩ := floorLog2_spec hpos
      have haM := abs_le_maxAbs ha
      have hsh := two_pow_pos (fixedShift W x)
      rw [abs_mul_two_pow]
      have e1 : Rat.abs a * 2 ^ fixedShift W x ≤ maxAbs x * 2 ^ fixedShift W x :=
        Rat.mul_le_mul_of_nonneg_right haM (Rat.le_of_lt hsh)
      have e2 : maxAbs x * 2 ^ fixedShift W x < 2 ^ (floorLog2 (maxAbs x) + 1) * 2 ^ fixedShift W x :=
        Rat.mul_lt_mul_of_pos_right hlt hsh
      have e3 : (2 : ℚ) ^ (floorLog2 (maxAbs x) + 1) * 2 ^ fixedShift W x = 2 ^ (W : ℤ) := by
        rw [← two_pow_add]; congr 1; unfold fixedShift; omega
      grind
  rw [abs_lt_iff] at hlt
  obtain ⟨h1, h2⟩ := hlt
  generalize a * 2 ^ fixedShift W x = t at h1 h2
  constructor
  · apply Rat.le_floor_iff.mpr
    rw [Rat.intCast_neg, Rat.intCast_natCast]
    grind
  · have hf := Rat.floor_le t
    have hlt' : (t.floor : ℚ) < ((((2 ^ W : ℕ) : ℤ)) : ℚ) := by
      rw [Rat.intCast_natCast]; grind
    have := Rat.intCast_lt_intCast.mp hlt'
    omega

/-- On the remap range the INT8 slice products are exact and recombine to the fixed-point product
(the core of `int8Ozaki_eq`). -/
theorem int8Recombine_eq {s : ℕ} (hs : 0 < s) {Na Nb : List ℤ}
    (hx : ∀ z ∈ Na, ADP.remapLo s ≤ z ∧ z ≤ ADP.remapHi s)
    (hy : ∀ z ∈ Nb, ADP.remapLo s ≤ z ∧ z ≤ ADP.remapHi s)
    (hk : Na.length * (128 * 128) < 2 ^ 31) : int8Recombine s Na Nb = dotZ Na Nb := by
  unfold int8Recombine
  rw [← ADP.slice_recombination hs]
  congr 1; apply List.map_congr_left; intro t _
  congr 1; apply List.map_congr_left; intro u _
  congr 1
  apply int8Dot_exact (by decide)
  refine Nat.lt_of_le_of_lt (dotAbs_le _ _ 128 128 (sliceVec_s8 hs hx t) (sliceVec_s8 hs hy u)) ?_
  simpa [ADP.sliceVec] using hk

/-- If `W` bits fit `s` remapped slices, every fixed-point integer lies in the remap range. -/
theorem toFixed_remap {s W : ℕ} (hfit : ADP.remapFits W s = true) (x : List ℚ) :
    ∀ z ∈ toFixed (fixedShift W x) x, ADP.remapLo s ≤ z ∧ z ≤ ADP.remapHi s := by
  intro z hz
  have ⟨hlo, hhi⟩ := of_decide_eq_true hfit
  have hr := toFixed_range W x z hz
  have hc : ((2 ^ W : ℕ) : ℤ) = (2 : ℤ) ^ W := by simp
  rw [hc] at hr
  omega

/-- On an INT8 engine without wraparound, the enclosure from `s` slices of width `W` contains
`x · y`. -/
theorem adpEnclosure_sound {s W : ℕ} (hs : 0 < s) (hfit : ADP.remapFits W s = true)
    {x y : List ℚ} (hk : x.length * (128 * 128) < 2 ^ 31) :
    Rat.abs (dot x y - (adpEnclosure s W x y).1) ≤ (adpEnclosure s W x y).2 := by
  unfold adpEnclosure
  dsimp only
  rw [int8Recombine_eq hs (toFixed_remap hfit x) (toFixed_remap hfit y)
    (by simpa [toFixed] using hk)]
  rw [← dot_scaledInts]
  exact dot_approx_error x (fixedVals W x) y (fixedVals W y) (fixedVals_length W x).symm
    (fixedVals_length W y).symm

/-- **ADP's slicing, correctly rounded.** On the INT8 engine, with configurations whose widths fit
their slice counts and dot products short enough that INT32 cannot wrap (`k · 2^14 < 2^31`),
`adpCR` returns the binary64 round to nearest of `x · y` for every input. -/
theorem adpCR_eq {cfgs : List (ℕ × ℕ)} (hcfg : ∀ c ∈ cfgs, 0 < c.1 ∧ ADP.remapFits c.2 c.1 = true)
    {x y : List ℚ} (hk : x.length * (128 * 128) < 2 ^ 31) :
    adpCR cfgs x y = fp64Round (dot x y) := by
  apply certify_eq fp64Round_nearest fp64Round_intervals _ _ _ rfl
  intro c hc H B hcB
  obtain ⟨cfg, hmem, rfl⟩ := List.mem_map.mp hc
  obtain ⟨hs, hfit⟩ := hcfg cfg hmem
  cases hcB
  exact adpEnclosure_sound hs hfit hk

end Ozaki.TC
