import TensorCore.Theory.ConversionBounds

namespace TensorCore

def magnitudeRounded (mode : RoundingMode) (m : Rat) : Rat :=
  (convCoeff mode m : Rat) * pow2 (convExp m - 23)

def signedRounded (mode : RoundingMode) (x : Rat) : Rat :=
  if x < 0 then -magnitudeRounded mode (absQ x) else magnitudeRounded mode (absQ x)

theorem rne_grid_nearest (m : Rat) (e : Int) (j : Int) :
    absQ (m - (rneInt (m / pow2 (e - 23)) : Rat) * pow2 (e - 23)) ≤
      absQ (m - (j : Rat) * pow2 (e - 23)) := by
  rw [dist_scale _ _ (pow2_pos _) _, dist_scale _ _ (pow2_pos _) _]
  exact Rat.mul_le_mul_of_nonneg_right (rneInt_nearest _ j) (Rat.le_of_lt (pow2_pos _))

/-- A finer grid below the input's binade cannot supply an equally near competitor.
The exact binade boundary is already a strictly better candidate. -/
theorem rne_lower_binade_strict (m : Rat) (hm : 0 < m) (hr : m ≤ maxFinite32)
    (j f : Int) (hf : -126 ≤ f) (hj : j.natAbs < 2 ^ 24) (he : f < convExp m) :
    absQ (m - magnitudeRounded .nearestEven m) <
      absQ (m - (j : Rat) * pow2 (f - 23)) := by
  obtain ⟨_, _, _, hl⟩ := convExp_bounds m hm hr
  have hl' : pow2 (convExp m) ≤ m := by rcases hl with h | h <;> first | exact h | omega
  have hb := rne_grid_nearest m (convExp m) 8388608
  change absQ (m - magnitudeRounded .nearestEven m) ≤
    absQ (m - 8388608 * pow2 (convExp m - 23)) at hb
  rw [← binade_grid] at hb
  have hsmall := finite_below_binade j f (convExp m) hj he
  have hsmall' := (absQ_le_iff _ _).mp hsmall
  have hq := pow2_pos (convExp m - 24)
  have h1 : 0 ≤ m - pow2 (convExp m) := by grind
  have h2 : 0 ≤ m - (j : Rat) * pow2 (f - 23) := by grind
  rw [absQ_of_nonneg h1] at hb
  rw [absQ_of_nonneg h2]
  grind

theorem rne_magnitude_nearest (m y : Rat) (hm : 0 < m) (hr : m ≤ maxFinite32)
    (hy : FiniteValue32 y) :
    absQ (m - magnitudeRounded .nearestEven m) ≤ absQ (m - y) := by
  obtain ⟨j, f, hf, _, hj, rfl⟩ := hy
  by_cases he : convExp m ≤ f
  · obtain ⟨z, hz⟩ := finite_on_grid j f (convExp m) he
    rw [hz]
    exact rne_grid_nearest m (convExp m) z
  · exact Rat.le_of_lt (rne_lower_binade_strict m hm hr j f hf hj (by omega))

theorem rne_magnitude_tie_even (m y : Rat) (hm : 0 < m) (hr : m ≤ maxFinite32)
    (hy : FiniteValue32 y) (hne : y ≠ magnitudeRounded .nearestEven m)
    (ht : absQ (m - y) = absQ (m - magnitudeRounded .nearestEven m)) :
    convCoeff .nearestEven m % 2 = 0 := by
  obtain ⟨j, f, hf, _, hj, rfl⟩ := hy
  by_cases he : convExp m ≤ f
  · obtain ⟨z, hz⟩ := finite_on_grid j f (convExp m) he
    rw [hz] at hne ht
    have hz' : z ≠ rneInt (m / pow2 (convExp m - 23)) := by
      intro h
      apply hne
      rw [h]; rfl
    unfold magnitudeRounded convCoeff roundCoefficient at ht
    rw [dist_scale _ _ (pow2_pos _) _, dist_scale _ _ (pow2_pos _) _] at ht
    have hcancel := congrArg (fun a : Rat => a / pow2 (convExp m - 23)) ht
    simp only [Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos _))] at hcancel
    exact rneInt_tie_even _ z hcancel hz'
  · have h := rne_lower_binade_strict m hm hr j f hf hj (by omega)
    rw [ht] at h
    exact False.elim (Rat.lt_irrefl h)

theorem finiteValue32_neg {y : Rat} (h : FiniteValue32 y) : FiniteValue32 (-y) := by
  obtain ⟨k, e, he1, he2, hk, rfl⟩ := h
  refine ⟨-k, e, he1, he2, ?_, ?_⟩
  · simpa using hk
  · simp [Rat.intCast_neg, Rat.neg_mul]

theorem absQ_pos_of_ne_zero (x : Rat) (hx : x ≠ 0) : 0 < absQ x := by
  unfold absQ; split <;> grind

theorem signedRounded_nearest (x y : Rat) (hx : x ≠ 0) (hr : absQ x ≤ maxFinite32)
    (hy : FiniteValue32 y) :
    absQ (x - signedRounded .nearestEven x) ≤ absQ (x - y) := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold signedRounded
  split
  · rename_i hn
    have h := rne_magnitude_nearest (absQ x) (-y) hm hr (finiteValue32_neg hy)
    rw [absQ_of_neg hn] at h
    have h1 : -x - magnitudeRounded .nearestEven (-x) =
      -(x - -magnitudeRounded .nearestEven (-x)) := by grind
    have h2 : -x - -y = -(x - y) := by grind
    rw [h1, h2, absQ_neg, absQ_neg] at h
    simpa [absQ_of_neg hn] using h
  · have h := rne_magnitude_nearest (absQ x) y hm hr hy
    have hn : 0 ≤ x := by grind
    simpa [absQ_of_nonneg hn] using h

theorem signedRounded_tie_even (x y : Rat) (hx : x ≠ 0) (hr : absQ x ≤ maxFinite32)
    (hy : FiniteValue32 y) (hne : y ≠ signedRounded .nearestEven x)
    (ht : absQ (x - y) = absQ (x - signedRounded .nearestEven x)) :
    convCoeff .nearestEven (absQ x) % 2 = 0 := by
  have hm := absQ_pos_of_ne_zero x hx
  unfold signedRounded at hne ht
  split at hne
  · rename_i hn
    simp only [hn, ↓reduceIte, absQ_of_neg hn] at ht hne ⊢
    have h1 : -x - -y = -(x - y) := by grind
    have h2 : -x - magnitudeRounded .nearestEven (-x) =
      -(x - -magnitudeRounded .nearestEven (-x)) := by grind
    apply rne_magnitude_tie_even (-x) (-y)
      (by simpa [absQ_of_neg hn] using hm) (by simpa [absQ_of_neg hn] using hr)
      (finiteValue32_neg hy)
    · intro h; apply hne; grind
    · rw [h1, h2, absQ_neg, absQ_neg]; exact ht
  · have hn : 0 ≤ x := by grind
    simp only [show ¬x < 0 by grind, ↓reduceIte, absQ_of_nonneg hn] at ht hne ⊢
    apply rne_magnitude_tie_even x y (by simpa [absQ_of_nonneg hn] using hm)
      (by simpa [absQ_of_nonneg hn] using hr) hy hne ht

/-- The conversion pipeline actually returns the signed selected grid value.
This includes subnormals, both signs, a significand carry, and bit parity. -/
theorem round32_nonzero_spec (mode : RoundingMode) (x : Rat)
    (hx : x ≠ 0) (hr : absQ x ≤ maxFinite32) :
    ∃ b : F32, round32 mode x = some b ∧ value32 b = some (signedRounded mode x) ∧
      (convCoeff mode (absQ x) % 2 = 0 → b.toNat % 2 = 0) ∧
      convExp (absQ x) - 23 ≤ outputQuantumExponent b := by
  have hm := absQ_pos_of_ne_zero x hx
  obtain ⟨he1, he2, _, _⟩ := convExp_bounds (absQ x) hm hr
  obtain ⟨hk0, hk1, hsub, htop⟩ := convCoeff_bounds mode (absQ x) hm hr
  have hs := carry_spec _ _ he1 he2 hk0 hk1 hsub htop
  let e := (carry (convExp (absQ x)) (convCoeff mode (absQ x))).1
  let k := (carry (convExp (absQ x)) (convCoeff mode (absQ x))).2
  let b := encode32 (decide (x < 0)) e k
  refine ⟨b, ?_, ?_, ?_, ?_⟩
  · unfold round32 round32Core
    have hn : ¬absQ x > maxFinite32 := by grind
    simp only [hn, hx, ↓reduceIte]
    have hh : ¬e > 127 := by exact Int.not_lt.mpr hs.2.1
    change (if e > 127 then none else some b) = some b
    rw [if_neg hh]
  · have he := (encode32_value (decide (x < 0)) e k hs.1 hs.2.1 hs.2.2.1
      hs.2.2.2.1 hs.2.2.2.2.1).1
    change value32 b = _ at he
    rw [he]
    unfold signedRounded magnitudeRounded
    have hv := hs.2.2.2.2.2.1
    change (k : Rat) * pow2 (e - 23) = _ at hv
    by_cases hn : x < 0 <;> simp [hn] <;> grind
  · intro h
    have he := (encode32_value (decide (x < 0)) e k hs.1 hs.2.1 hs.2.2.1
      hs.2.2.2.1 hs.2.2.2.2.1).2
    change b.toNat % 2 = k.toNat % 2 at he
    have hk : k % 2 = 0 := hs.2.2.2.2.2.2.2 h
    have hk0 : 0 ≤ k := hs.2.2.1
    omega
  · have he := encode32_quantum (decide (x < 0)) e k hs.1 hs.2.1 hs.2.2.1
      hs.2.2.2.1 hs.2.2.2.2.1
    change outputQuantumExponent b = e - 23 at he
    have hh : convExp (absQ x) ≤ e := hs.2.2.2.2.2.2.1
    omega

/-- Independent mathematical contract: finite result, nearest finite value, and an
even low encoding bit whenever another distinct value is equally near. -/
def NearestEven32 (x : Rat) (b : F32) : Prop :=
  ∃ d : Rat, value32 b = some d ∧
    (∀ y : Rat, FiniteValue32 y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : Rat, FiniteValue32 y → y ≠ d →
      absQ (x - y) = absQ (x - d) → b.toNat % 2 = 0)

/-- Total correctness on the declared finite range, for all rational inputs. -/
theorem round32_nearestEven_correct (x : Rat) (hr : absQ x ≤ maxFinite32) :
    ∃ b : F32, round32 .nearestEven x = some b ∧ NearestEven32 x b := by
  by_cases hx : x = 0
  · subst x
    refine ⟨0, by decide +kernel, 0, by decide +kernel, ?_, ?_⟩
    · intro y _
      have h := absQ_nonneg (0 - y)
      have hz : absQ (0 - 0) = 0 := by decide +kernel
      rw [hz]; exact h
    · intros; decide
  · obtain ⟨b, hb, hv, hp, _⟩ := round32_nonzero_spec .nearestEven x hx hr
    refine ⟨b, hb, signedRounded .nearestEven x, hv, ?_, ?_⟩
    · intro y hy; exact signedRounded_nearest x y hx hr hy
    · intro y hy hne ht
      exact hp (signedRounded_tie_even x y hx hr hy hne ht)

theorem finalRound_correct (x : Rat) (b : F32) (hr : absQ x ≤ maxFinite32)
    (h : round32 .nearestEven x = some b) : NearestEven32 x b := by
  obtain ⟨b', hb', hc⟩ := round32_nearestEven_correct x hr
  rw [h] at hb'
  cases Option.some.inj hb'
  exact hc

end TensorCore
