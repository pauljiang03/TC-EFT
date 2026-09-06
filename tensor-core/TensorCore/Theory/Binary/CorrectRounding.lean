import TensorCore.Theory.Binary.ConversionBounds
import TensorCore.Theory.CorrectRounding
import TensorCore.Theory.Flowback

/-! Correctness of `roundBinary` for every well-formed IEEE-style `Format` (TC-EFT
Definition II.2 for FP16, BF16, tf19, FP32, FP64, and E5M2). E4M3 is a `ValueFormat` whose
top exponent is finite except for its NaN pattern; its maximum `448` exceeds the `240` of the
IEEE-style layout `⟨3, 4, 7⟩`, so it is outside this theorem. The converter returns an
encoding whose value is
the signed selected grid value; in nearest-even mode that value is nearest among the
format's finite values with ties broken to an even low bit; in toward-zero mode it is the
finite value of largest magnitude between zero and the input. The FP32 statements of
`Theory/CorrectRounding.lean` are the `fp32` instances. -/

namespace TensorCore

def binaryMagnitudeRounded (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m : Rat) : Rat :=
  (binaryCoefficient mode negative (m / pow2 (binaryConvExp f m - f.fractionBits)) : Rat) *
    pow2 (binaryConvExp f m - f.fractionBits)

def binarySignedRounded (f : Format) (mode : BinaryRoundingMode) (x : Rat) : Rat :=
  if x < 0 then -binaryMagnitudeRounded f mode true (absQ x)
  else binaryMagnitudeRounded f mode false (absQ x)

/-! Grid geometry parametric in the fraction width. -/

theorem rne_grid_nearest_q (m q : Rat) (hq : 0 < q) (j : Int) :
    absQ (m - (rneInt (m / q) : Rat) * q) ≤ absQ (m - (j : Rat) * q) := by
  rw [dist_scale _ _ hq _, dist_scale _ _ hq _]
  exact Rat.mul_le_mul_of_nonneg_right (rneInt_nearest _ j) (Rat.le_of_lt hq)

theorem Format.finite_on_grid (f : Format) (k e2 e : Int) (h : e ≤ e2) :
    ∃ j : Int, (k : Rat) * pow2 (e2 - f.fractionBits) = j * pow2 (e - f.fractionBits) := by
  refine ⟨k * 2 ^ (e2 - e).toNat, ?_⟩
  have : pow2 (e2 - f.fractionBits) = pow2 (e - f.fractionBits) * pow2 ((e2 - e).toNat : Int) := by
    rw [← pow2_add]; congr 1; omega
  rw [this, pow2_natCast, Rat.intCast_mul, Rat.intCast_pow]
  simp only [Rat.intCast_ofNat, Rat.natCast_pow, Rat.natCast_ofNat]
  grind

/-- A finite value with exponent below `e` is at most `2^e − 2^(e−p−1)` in magnitude. -/
theorem Format.finite_below_binade (f : Format) (k e2 e : Int)
    (hk : k.natAbs < 2 ^ (f.fractionBits + 1)) (h : e2 < e) :
    absQ ((k : Rat) * pow2 (e2 - f.fractionBits)) ≤ pow2 e - pow2 (e - f.fractionBits - 1) := by
  have hq := pow2_pos (e2 - f.fractionBits)
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have hk' : ((k.natAbs : Int) : Rat) ≤ ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) := by
    have h1 : (k.natAbs : Int) ≤ ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Int) := by omega
    have h2 := Rat.intCast_le_intCast.mpr h1
    simpa [Rat.intCast_natCast] using h2
  have hgrid : pow2 (e2 - f.fractionBits) ≤ pow2 (e - f.fractionBits - 1) :=
    pow2_le_of_le (by omega)
  have hnn : (0 : Rat) ≤ ((k.natAbs : Int) : Rat) := Rat.intCast_nonneg.mpr (by omega)
  have step1 : ((k.natAbs : Int) : Rat) * pow2 (e2 - f.fractionBits) ≤
      ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) * pow2 (e - f.fractionBits - 1) :=
    calc ((k.natAbs : Int) : Rat) * pow2 (e2 - f.fractionBits)
        ≤ ((k.natAbs : Int) : Rat) * pow2 (e - f.fractionBits - 1) :=
          Rat.mul_le_mul_of_nonneg_left hgrid hnn
      _ ≤ ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) * pow2 (e - f.fractionBits - 1) :=
          Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _))
  have step2 : ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) * pow2 (e - f.fractionBits - 1) =
      pow2 e - pow2 (e - f.fractionBits - 1) := by
    have hp1 : pow2 e = ((2 ^ (f.fractionBits + 1) : Nat) : Rat) * pow2 (e - f.fractionBits - 1) := by
      rw [← pow2_natCast, ← pow2_add]; congr 1; omega
    have hsub : ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) + 1 =
        ((2 ^ (f.fractionBits + 1) : Nat) : Rat) := by
      rw [show (1 : Rat) = ((1 : Nat) : Rat) from rfl, ← Rat.natCast_add,
        Nat.sub_add_cancel (Nat.two_pow_pos _)]
    rw [hp1]
    grind
  rw [← step2]
  exact step1

/-- The nearest-even coefficient ignores the sign flag. -/
theorem binaryCoefficient_nearestEven (negative : Bool) (t : Rat) :
    binaryCoefficient .nearestEven negative t = rneInt t := rfl

theorem binaryMagnitudeRounded_lower (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) (hm : 0 < m) (hr : m ≤ f.maxFinite)
    (he : f.emin < binaryConvExp f m) :
    pow2 (binaryConvExp f m) ≤ binaryMagnitudeRounded f mode negative m := by
  obtain ⟨_, _, _, hl⟩ := binaryConvExp_bounds f hf m hm hr
  have hl' : pow2 (binaryConvExp f m) ≤ m := by
    rcases hl with h | h
    · exact h
    · exfalso; omega
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  have hs : (((2 ^ f.fractionBits : Nat) : Int) : Rat) ≤
      m / pow2 (binaryConvExp f m - f.fractionBits) := by
    apply le_div_of_mul_le _ _ _ hq
    rw [Rat.intCast_natCast, ← f.binade_grid]
    exact hl'
  have hfl : ((2 ^ f.fractionBits : Nat) : Int) ≤
      (m / pow2 (binaryConvExp f m - f.fractionBits)).floor := Rat.le_floor_iff.mpr hs
  have hb := binaryCoefficient_bounds mode negative (m / pow2 (binaryConvExp f m - f.fractionBits))
    (2 ^ (f.fractionBits + 1)) (Rat.le_of_lt ((Rat.lt_div_iff hq).mpr (by simpa using hm)))
    (by
      apply (Rat.div_lt_iff hq).mpr
      obtain ⟨_, _, hupper, _⟩ := binaryConvExp_bounds f hf m hm hr
      rwa [f.next_binade_grid] at hupper)
  have hk : ((2 ^ f.fractionBits : Nat) : Int) ≤
      binaryCoefficient mode negative (m / pow2 (binaryConvExp f m - f.fractionBits)) := by
    have := hb.2.2.1
    omega
  unfold binaryMagnitudeRounded
  rw [f.binade_grid (binaryConvExp f m), ← Rat.intCast_natCast]
  exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hk) (Rat.le_of_lt hq)

/-- A finer grid below the input's binade cannot supply an equally near competitor. -/
theorem binary_rne_lower_binade_strict (f : Format) (hf : f.WellFormed) (negative : Bool) (m : Rat)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) (j fe : Int) (hfe : f.emin ≤ fe)
    (hj : j.natAbs < 2 ^ (f.fractionBits + 1)) (he : fe < binaryConvExp f m) :
    absQ (m - binaryMagnitudeRounded f .nearestEven negative m) <
      absQ (m - (j : Rat) * pow2 (fe - f.fractionBits)) := by
  obtain ⟨_, _, _, hl⟩ := binaryConvExp_bounds f hf m hm hr
  have hl' : pow2 (binaryConvExp f m) ≤ m := by
    rcases hl with h | h
    · exact h
    · exfalso; omega
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  have hb := rne_grid_nearest_q m _ hq ((2 ^ f.fractionBits : Nat) : Int)
  change absQ (m - binaryMagnitudeRounded f .nearestEven negative m) ≤
    absQ (m - (((2 ^ f.fractionBits : Nat) : Int) : Rat) * pow2 (binaryConvExp f m - f.fractionBits)) at hb
  rw [Rat.intCast_natCast, ← f.binade_grid] at hb
  have hsmall := f.finite_below_binade j fe (binaryConvExp f m) hj he
  have hsmall' := (absQ_le_iff _ _).mp hsmall
  have hq' := pow2_pos (binaryConvExp f m - f.fractionBits - 1)
  have h1 : 0 ≤ m - pow2 (binaryConvExp f m) := by grind
  have h2 : 0 ≤ m - (j : Rat) * pow2 (fe - f.fractionBits) := by grind
  rw [absQ_of_nonneg h1] at hb
  rw [absQ_of_nonneg h2]
  grind

theorem binary_rne_magnitude_nearest (f : Format) (hf : f.WellFormed) (negative : Bool) (m y : Rat)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) (hy : f.FiniteValue y) :
    absQ (m - binaryMagnitudeRounded f .nearestEven negative m) ≤ absQ (m - y) := by
  obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
  by_cases he : binaryConvExp f m ≤ fe
  · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
    rw [hz]
    exact rne_grid_nearest_q m _ (pow2_pos _) z
  · exact Rat.le_of_lt (binary_rne_lower_binade_strict f hf negative m hm hr j fe hfe hj (by omega))

theorem binary_rne_magnitude_tie_even (f : Format) (hf : f.WellFormed) (negative : Bool) (m y : Rat)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) (hy : f.FiniteValue y)
    (hne : y ≠ binaryMagnitudeRounded f .nearestEven negative m)
    (ht : absQ (m - y) = absQ (m - binaryMagnitudeRounded f .nearestEven negative m)) :
    binaryCoefficient .nearestEven negative (m / pow2 (binaryConvExp f m - f.fractionBits)) % 2 = 0 := by
  obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
  by_cases he : binaryConvExp f m ≤ fe
  · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
    rw [hz] at hne ht
    have hz' : z ≠ rneInt (m / pow2 (binaryConvExp f m - f.fractionBits)) := by
      intro h
      apply hne
      rw [h]; rfl
    unfold binaryMagnitudeRounded at ht
    rw [binaryCoefficient_nearestEven] at ht ⊢
    rw [dist_scale _ _ (pow2_pos _) _, dist_scale _ _ (pow2_pos _) _] at ht
    have hcancel := congrArg (fun a : Rat => a / pow2 (binaryConvExp f m - f.fractionBits)) ht
    simp only [Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos _))] at hcancel
    exact rneInt_tie_even _ z hcancel hz'
  · have h := binary_rne_lower_binade_strict f hf negative m hm hr j fe hfe hj (by omega)
    rw [ht] at h
    exact False.elim (Rat.lt_irrefl h)

theorem Format.finiteValue_neg (f : Format) {y : Rat} (h : f.FiniteValue y) :
    f.FiniteValue (-y) := by
  obtain ⟨k, e, he1, he2, hk, rfl⟩ := h
  refine ⟨-k, e, he1, he2, ?_, ?_⟩
  · simpa using hk
  · simp [Rat.intCast_neg, Rat.neg_mul]

theorem binarySignedRounded_nearest (f : Format) (hf : f.WellFormed) (x y : Rat) (hx : x ≠ 0)
    (hr : absQ x ≤ f.maxFinite) (hy : f.FiniteValue y) :
    absQ (x - binarySignedRounded f .nearestEven x) ≤ absQ (x - y) := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold binarySignedRounded
  split
  · rename_i hn
    have h := binary_rne_magnitude_nearest f hf true (absQ x) (-y) hm hr (f.finiteValue_neg hy)
    rw [absQ_of_neg hn] at h
    have h1 : -x - binaryMagnitudeRounded f .nearestEven true (-x) =
      -(x - -binaryMagnitudeRounded f .nearestEven true (-x)) := by grind
    have h2 : -x - -y = -(x - y) := by grind
    rw [h1, h2, absQ_neg, absQ_neg] at h
    simpa [absQ_of_neg hn] using h
  · have h := binary_rne_magnitude_nearest f hf false (absQ x) y hm hr hy
    have hn : 0 ≤ x := by grind
    simpa [absQ_of_nonneg hn] using h

theorem binarySignedRounded_tie_even (f : Format) (hf : f.WellFormed) (x y : Rat) (hx : x ≠ 0)
    (hr : absQ x ≤ f.maxFinite) (hy : f.FiniteValue y)
    (hne : y ≠ binarySignedRounded f .nearestEven x)
    (ht : absQ (x - y) = absQ (x - binarySignedRounded f .nearestEven x)) :
    binaryCoefficient .nearestEven (decide (x < 0))
      (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)) % 2 = 0 := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold binarySignedRounded at hne ht
  split at hne
  · rename_i hn
    simp only [hn, ↓reduceIte, absQ_of_neg hn, decide_true] at ht hne ⊢
    have h1 : -x - -y = -(x - y) := by grind
    have h2 : -x - binaryMagnitudeRounded f .nearestEven true (-x) =
      -(x - -binaryMagnitudeRounded f .nearestEven true (-x)) := by grind
    apply binary_rne_magnitude_tie_even f hf true (-x) (-y)
      (by simpa [absQ_of_neg hn] using hm) (by simpa [absQ_of_neg hn] using hr)
      (f.finiteValue_neg hy)
    · intro h; apply hne; grind
    · rw [h1, h2, absQ_neg, absQ_neg]; exact ht
  · have hn : 0 ≤ x := by grind
    simp only [show ¬x < 0 by grind, ↓reduceIte, absQ_of_nonneg hn, decide_false] at ht hne ⊢
    apply binary_rne_magnitude_tie_even f hf false x y (by simpa [absQ_of_nonneg hn] using hm)
      (by simpa [absQ_of_nonneg hn] using hr) hy hne ht

/-- The converter returns the signed selected grid value, with the coefficient's parity in
the low bit. -/
theorem roundBinary_nonzero_spec (f : Format) (hf : f.WellFormed) (mode : BinaryRoundingMode)
    (x : Rat) (hx : x ≠ 0) (hr : absQ x ≤ f.maxFinite) :
    ∃ bits : BitVec f.width, roundBinary f mode x = some bits ∧
      binaryValue f bits = some (binarySignedRounded f mode x) ∧
      (binaryCoefficient mode (decide (x < 0))
        (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)) % 2 = 0 →
        bits.toNat % 2 = 0) := by
  have hm := absQ_pos_of_ne_zero x hx
  obtain ⟨he1, he2, _, _⟩ := binaryConvExp_bounds f hf (absQ x) hm hr
  obtain ⟨hk0, hk1, hsub, htop⟩ := binaryConvCoeff_bounds f hf mode (decide (x < 0)) (absQ x) hm hr
  have hs := binaryCarry_spec f hf _ _ he1 he2 hk0 hk1 hsub htop
  let e := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
    (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).1
  let k := (binaryCarry f (binaryConvExp f (absQ x)) (binaryCoefficient mode (decide (x < 0))
    (absQ x / pow2 (binaryConvExp f (absQ x) - f.fractionBits)))).2
  let bits := encodeBinary f (decide (x < 0)) e k
  refine ⟨bits, ?_, ?_, ?_⟩
  · unfold roundBinary
    have hn : ¬absQ x > f.maxFinite := by grind
    rw [if_neg (by intro h; exact h hf), if_neg hn, if_neg hx]
    have hh : ¬e > f.emax := Int.not_lt.mpr hs.2.1
    change (if e > f.emax then none else some bits) = some bits
    rw [if_neg hh]
  · have he := encodeBinary_value f hf (decide (x < 0)) e k hs.1 hs.2.1 hs.2.2.1
      hs.2.2.2.1 hs.2.2.2.2.1
    change binaryValue f bits = _ at he
    rw [he]
    unfold binarySignedRounded binaryMagnitudeRounded
    have hv := hs.2.2.2.2.2.1
    change (k : Rat) * pow2 (e - f.fractionBits) = _ at hv
    by_cases hn : x < 0 <;> simp [hn] <;> grind
  · intro h
    have he := encodeBinary_parity f hf (decide (x < 0)) e k hs.2.2.1 hs.2.2.2.1 hs.1 hs.2.1
    change bits.toNat % 2 = k.toNat % 2 at he
    have hk : k % 2 = 0 := hs.2.2.2.2.2.2.2 h
    have hk0 : 0 ≤ k := hs.2.2.1
    omega

theorem binaryValue_zero (f : Format) (hf : f.WellFormed) : binaryValue f 0 = some 0 := by
  obtain ⟨_, hE⟩ := hf
  have hW : 4 ≤ 2 ^ f.exponentBits := by
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) hE
    simpa using this
  have h0 : (0 : BitVec f.width).toNat = 0 := by simp
  unfold binaryValue classify classifyNat
  dsimp only
  rw [h0, Nat.zero_mod, Nat.zero_div, Nat.zero_mod, Nat.zero_div]
  rw [if_neg (by omega), if_pos rfl, if_pos rfl]
  simp [Classification.finite, Decoded.value]

/-- Nearest finite value of the format, ties to an even low bit. -/
def NearestEven (f : Format) (x : Rat) (bits : BitVec f.width) : Prop :=
  ∃ d : Rat, binaryValue f bits = some d ∧
    (∀ y : Rat, f.FiniteValue y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : Rat, f.FiniteValue y → y ≠ d → absQ (x - y) = absQ (x - d) → bits.toNat % 2 = 0)

theorem fp32_nearestEven (x : Rat) (bits : F32) : NearestEven fp32 x bits ↔ NearestEven32 x bits :=
  Iff.rfl

/-- Total correctness of nearest-even conversion on the finite range of any format. -/
theorem roundBinary_nearestEven_correct (f : Format) (hf : f.WellFormed) (x : Rat)
    (hr : absQ x ≤ f.maxFinite) :
    ∃ bits : BitVec f.width, roundBinary f .nearestEven x = some bits ∧ NearestEven f x bits := by
  by_cases hx : x = 0
  · subst x
    have hz : roundBinary f .nearestEven 0 = some 0 := by
      unfold roundBinary
      rw [if_neg (by intro h; exact h hf), if_neg (by have := absQ_nonneg (0 : Rat); grind),
        if_pos rfl]
    refine ⟨0, hz, 0, binaryValue_zero f hf, ?_, ?_⟩
    · intro y _
      have h := absQ_nonneg (0 - y)
      have hz0 : absQ (0 - 0) = 0 := by decide +kernel
      rw [hz0]; exact h
    · intros; simp
  · obtain ⟨bits, hb, hv, hp⟩ := roundBinary_nonzero_spec f hf .nearestEven x hx hr
    refine ⟨bits, hb, binarySignedRounded f .nearestEven x, hv, ?_, ?_⟩
    · intro y hy; exact binarySignedRounded_nearest f hf x y hx hr hy
    · intro y hy hne ht
      exact hp (binarySignedRounded_tie_even f hf x y hx hr hy hne ht)

/-! Truncation toward zero. -/

/-- `y` lies between zero and `x`, inclusive. -/
def Between0 (x y : Rat) : Prop := (0 ≤ x ∧ 0 ≤ y ∧ y ≤ x) ∨ (x ≤ 0 ∧ x ≤ y ∧ y ≤ 0)

theorem binary_rtz_magnitude_spec (f : Format) (hf : f.WellFormed) (negative : Bool) (m : Rat)
    (hm : 0 < m) (hr : m ≤ f.maxFinite) :
    0 ≤ binaryMagnitudeRounded f .towardZero negative m ∧
    binaryMagnitudeRounded f .towardZero negative m ≤ m ∧
    (∀ y : Rat, f.FiniteValue y → y ≤ m → y ≤ binaryMagnitudeRounded f .towardZero negative m) := by
  have hq := pow2_pos (binaryConvExp f m - f.fractionBits)
  have hfl : (0 : Int) ≤ (m / pow2 (binaryConvExp f m - f.fractionBits)).floor := by
    apply Rat.le_floor_iff.mpr
    have := div_nonneg_of_pos _ _ (Rat.le_of_lt hm) hq
    simpa using this
  refine ⟨?_, ?_, ?_⟩
  · unfold binaryMagnitudeRounded
    have : (0 : Rat) ≤ (((m / pow2 (binaryConvExp f m - f.fractionBits)).floor : Int) : Rat) := by
      have := Rat.intCast_le_intCast.mpr hfl
      simpa using this
    exact Rat.mul_nonneg this (Rat.le_of_lt hq)
  · unfold binaryMagnitudeRounded
    change (((m / pow2 (binaryConvExp f m - f.fractionBits)).floor : Int) : Rat) *
      pow2 (binaryConvExp f m - f.fractionBits) ≤ m
    have := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (m / pow2 (binaryConvExp f m - f.fractionBits)))
      (Rat.le_of_lt hq)
    rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at this
  · intro y hy hym
    obtain ⟨j, fe, hfe, _, hj, rfl⟩ := hy
    by_cases he : binaryConvExp f m ≤ fe
    · obtain ⟨z, hz⟩ := f.finite_on_grid j fe (binaryConvExp f m) he
      rw [hz] at hym ⊢
      unfold binaryMagnitudeRounded
      change (z : Rat) * pow2 (binaryConvExp f m - f.fractionBits) ≤
        (((m / pow2 (binaryConvExp f m - f.fractionBits)).floor : Int) : Rat) *
          pow2 (binaryConvExp f m - f.fractionBits)
      apply Rat.mul_le_mul_of_nonneg_right _ (Rat.le_of_lt hq)
      apply Rat.intCast_le_intCast.mpr
      apply Rat.le_floor_iff.mpr
      exact le_div_of_mul_le _ _ _ hq hym
    · have hlow := binaryMagnitudeRounded_lower f hf .towardZero negative m hm hr (by omega)
      have hsmall := f.finite_below_binade j fe (binaryConvExp f m) hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have := pow2_pos (binaryConvExp f m - f.fractionBits - 1)
      grind

/-- Toward-zero result: between zero and the input, of largest magnitude among the format's
finite values there. -/
def TowardZero (f : Format) (x : Rat) (bits : BitVec f.width) : Prop :=
  ∃ d : Rat, binaryValue f bits = some d ∧ Between0 x d ∧
    ∀ y : Rat, f.FiniteValue y → Between0 x y → absQ y ≤ absQ d

theorem roundBinary_towardZero_correct (f : Format) (hf : f.WellFormed) (x : Rat)
    (hr : absQ x ≤ f.maxFinite) :
    ∃ bits : BitVec f.width, roundBinary f .towardZero x = some bits ∧ TowardZero f x bits := by
  by_cases hx : x = 0
  · subst x
    have hz : roundBinary f .towardZero 0 = some 0 := by
      unfold roundBinary
      rw [if_neg (by intro h; exact h hf), if_neg (by have := absQ_nonneg (0 : Rat); grind),
        if_pos rfl]
    refine ⟨0, hz, 0, binaryValue_zero f hf, Or.inl ⟨Rat.le_refl, Rat.le_refl, Rat.le_refl⟩, ?_⟩
    intro y _ hy
    have : y = 0 := by unfold Between0 at hy; grind
    rw [this]
    exact Rat.le_refl
  · obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec f hf .towardZero x hx hr
    refine ⟨bits, hb, binarySignedRounded f .towardZero x, hv, ?_, ?_⟩
    · unfold binarySignedRounded
      split
      · rename_i hn
        have hm := absQ_pos_of_ne_zero x hx
        obtain ⟨h0, hle, _⟩ := binary_rtz_magnitude_spec f hf true (absQ x) hm hr
        have hax := absQ_of_neg hn
        right
        exact ⟨Rat.le_of_lt hn, by grind, by grind⟩
      · rename_i hn
        have hm := absQ_pos_of_ne_zero x hx
        obtain ⟨h0, hle, _⟩ := binary_rtz_magnitude_spec f hf false (absQ x) hm hr
        have hn' : 0 ≤ x := by grind
        have hax := absQ_of_nonneg hn'
        left
        exact ⟨hn', h0, by grind⟩
    · intro y hy hb0
      have hm := absQ_pos_of_ne_zero x hx
      unfold binarySignedRounded
      split
      · rename_i hn
        obtain ⟨h0, _, hmax⟩ := binary_rtz_magnitude_spec f hf true (absQ x) hm hr
        have hyx : -y ≤ absQ x := by
          rw [absQ_of_neg hn]
          unfold Between0 at hb0
          grind
        have hle := hmax (-y) (f.finiteValue_neg hy) hyx
        have hy0 : y ≤ 0 := by unfold Between0 at hb0; grind
        rw [absQ_neg, absQ_of_nonneg h0]
        apply (absQ_le_iff _ _).mpr
        constructor <;> grind
      · rename_i hn
        obtain ⟨h0, _, hmax⟩ := binary_rtz_magnitude_spec f hf false (absQ x) hm hr
        have hn' : 0 ≤ x := by grind
        have hyx : y ≤ absQ x := by
          rw [absQ_of_nonneg hn']
          unfold Between0 at hb0
          grind
        have hle := hmax y hy hyx
        have hy0 : 0 ≤ y := by unfold Between0 at hb0; grind
        rw [absQ_of_nonneg h0]
        apply (absQ_le_iff _ _).mpr
        constructor <;> grind

end TensorCore
