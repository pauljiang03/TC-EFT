# TensorCore.Core.CorrectRounding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2e1bab62ec0b2b78"></a>

<details>
<summary><code>TensorCore.rne_grid_nearest</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L7)

```lean
theorem rne_grid_nearest (m : ℚ) (e : ℤ) (j : ℤ) :
    absQ (m - (rneInt (m / pow2 (e - 23)) : ℚ) * pow2 (e - 23)) ≤
      absQ (m - (j : ℚ) * pow2 (e - 23)) := by
  rw [dist_scale _ _ (pow2_pos _) _, dist_scale _ _ (pow2_pos _) _]
  exact Rat.mul_le_mul_of_nonneg_right (rneInt_nearest _ j) (Rat.le_of_lt (pow2_pos _))
```

**Supporting proofs:** [TensorCore.dist_scale](Rounding.md#decl-b773da87e31ab58f), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb)

</details>

</details>

<a id="decl-8a3cc46b2fb434de"></a>

<details>
<summary><code>TensorCore.rne_lower_binade_strict</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L15)

```lean
/-- A finer grid below the input's binade cannot supply an equally near competitor.
The exact binade boundary is already a strictly better candidate. -/
theorem rne_lower_binade_strict (m : ℚ) (hm : 0 < m) (hr : m ≤ maxFinite32)
    (j f : ℤ) (hf : -126 ≤ f) (hj : j.natAbs < 2 ^ 24) (he : f < convExp m) :
    absQ (m - magnitudeRounded .nearestEven m) <
      absQ (m - (j : ℚ) * pow2 (f - 23)) := by
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
  have h2 : 0 ≤ m - (j : ℚ) * pow2 (f - 23) := by grind
  rw [absQ_of_nonneg h1] at hb
  rw [absQ_of_nonneg h2]
  grind
```

**Supporting proofs:** [TensorCore.absQ_le_iff](Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78)

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165)

</details>

</details>

<a id="decl-530f2f5b5e7938cb"></a>

<details>
<summary><code>TensorCore.rne_magnitude_nearest</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L34)

```lean
theorem rne_magnitude_nearest (m y : ℚ) (hm : 0 < m) (hr : m ≤ maxFinite32)
    (hy : FiniteValue32 y) :
    absQ (m - magnitudeRounded .nearestEven m) ≤ absQ (m - y) := by
  obtain ⟨j, f, hf, _, hj, rfl⟩ := hy
  by_cases he : convExp m ≤ f
  · obtain ⟨z, hz⟩ := finite_on_grid j f (convExp m) he
    rw [hz]
    exact rne_grid_nearest m (convExp m) z
  · exact Rat.le_of_lt (rne_lower_binade_strict m hm hr j f hf hj (by omega))
```

**Supporting proofs:** [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de)

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d)

</details>

</details>

<a id="decl-9a2b59ee0932b165"></a>

<details>
<summary><code>TensorCore.rne_magnitude_tie_even</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L44)

```lean
theorem rne_magnitude_tie_even (m y : ℚ) (hm : 0 < m) (hr : m ≤ maxFinite32)
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
    have hcancel := congrArg (fun a : ℚ => a / pow2 (convExp m - 23)) ht
    simp only [Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos _))] at hcancel
    exact rneInt_tie_even _ z hcancel hz'
  · have h := rne_lower_binade_strict m hm hr j f hf hj (by omega)
    rw [ht] at h
    exact False.elim (Rat.lt_irrefl h)
```

**Supporting proofs:** [TensorCore.dist_scale](Rounding.md#decl-b773da87e31ab58f), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de)

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-e82bec275802f6d0"></a>

<details>
<summary><code>TensorCore.finiteValue32_neg</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L65)

```lean
theorem finiteValue32_neg {y : ℚ} (h : FiniteValue32 y) : FiniteValue32 (-y) := by
  obtain ⟨k, e, he1, he2, hk, rfl⟩ := h
  refine ⟨-k, e, he1, he2, ?_, ?_⟩
  · simpa using hk
  · simp [Rat.intCast_neg, Rat.neg_mul]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-0de5c16329b2da35"></a>

<details>
<summary><code>TensorCore.absQ_pos_of_ne_zero</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L71)

```lean
theorem absQ_pos_of_ne_zero (x : ℚ) (hx : x ≠ 0) : 0 < absQ x := by
  unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.scalarResult_of_roundBinary](../Gemm/Specification/ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.roundBinary_nonzero_spec](Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_sign](Binary/RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-9faaf61526f9495d"></a>

<details>
<summary><code>TensorCore.signedRounded_nearest</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L74)

```lean
theorem signedRounded_nearest (x y : ℚ) (hx : x ≠ 0) (hr : absQ x ≤ maxFinite32)
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
```

**Supporting proofs:** [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.finiteValue32_neg](CorrectRounding.md#decl-e82bec275802f6d0), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb)

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312)

</details>

</details>

<a id="decl-9ff415905688cc20"></a>

<details>
<summary><code>TensorCore.signedRounded_tie_even</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L92)

```lean
theorem signedRounded_tie_even (x y : ℚ) (hx : x ≠ 0) (hr : absQ x ≤ maxFinite32)
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
```

**Supporting proofs:** [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.finiteValue32_neg](CorrectRounding.md#decl-e82bec275802f6d0), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165)

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312)

</details>

</details>

<a id="decl-8b6b01a970bf7f64"></a>

<details>
<summary><code>TensorCore.round32_nonzero_spec</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L116)

```lean
/-- The conversion pipeline actually returns the signed selected grid value.
This includes subnormals, both signs, a significand carry, and bit parity. -/
theorem round32_nonzero_spec (mode : RoundingMode) (x : ℚ)
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
    change (k : ℚ) * pow2 (e - 23) = _ at hv
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
```

**Supporting proofs:** [TensorCore.absQ_pos_of_ne_zero](CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.carry_spec](ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.encode32_quantum](EncodingProperties.md#decl-6f10a9a038e29fd3), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.carry](RoundOp.md#decl-e870a105595fff5f), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda)

</details>

</details>

<a id="decl-213324c196c49312"></a>

<details>
<summary><code>TensorCore.round32_nearestEven_correct</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L157)

```lean
/-- Total correctness on the declared finite range, for all rational inputs. -/
theorem round32_nearestEven_correct (x : ℚ) (hr : absQ x ≤ maxFinite32) :
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
```

**Supporting proofs:** [TensorCore.absQ_nonneg](Exact.md#decl-137ea017d6c4d0cd), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.NearestEven32](RoundOp.md#decl-e8aa71a6813779de), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](RoundOp.md#decl-70bb2de461b51682), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.algorithm1_success](../EFT/Machine/Correctness.md#decl-56c6ead02b649bea), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.Program.vc_sound](../TC/Program/Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de)

</details>

</details>

<a id="decl-e7b5aad6590aeae4"></a>

<details>
<summary><code>TensorCore.finalRound_correct</code></summary>

[Lean source](../../../TensorCore/Core/CorrectRounding.lean#L173)

```lean
theorem finalRound_correct (x : ℚ) (b : F32) (hr : absQ x ≤ maxFinite32)
    (h : round32 .nearestEven x = some b) : NearestEven32 x b := by
  obtain ⟨b', hb', hc⟩ := round32_nearestEven_correct x hr
  rw [h] at hb'
  cases Option.some.inj hb'
  exact hc
```

**Supporting proofs:** [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](RoundOp.md#decl-e8aa71a6813779de), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_correct](../EFT/Machine/Round.md#decl-84e75c815794c328)

</details>

</details>
