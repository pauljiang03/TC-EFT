# TensorCore.TC.StaticBudget

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e94ea19e60b20a46"></a>

<details>
<summary><code>TensorCore.ScaleBounded</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L20)

```lean
/-- Every nonzero term has raw scale at most `E`. -/
def ScaleBounded (ts : List RawProduct) (E : ℤ) : Prop :=
  ∀ t ∈ ts, t.significand ≠ 0 → t.rawScale ≤ E
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4)

<details>
<summary>Used by</summary>

[TensorCore.accumulator_abs_lt](StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.accumulator_lt_pow2](StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.alignment_static_bound](StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.block_local_error](Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.prepared_scaleBounded](StaticBudget.md#decl-ac851e1ac7fbea13), [TensorCore.prepared_static_success](StaticBudget.md#decl-2a79f971d61c16c9), [TensorCore.quantumExponent_le](StaticBudget.md#decl-53da2dc9d7457364), [TensorCore.rawAlignmentBudget_sound](Program/Bounds/Local.md#decl-1e83b17fa3bc236b)

</details>

</details>

<a id="decl-eb7aab7cbcc8d87a"></a>

<details>
<summary><code>TensorCore.term_abs_lt</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L24)

```lean
/-- A bounded term of scale at most `E` has magnitude below `4·2^E`. -/
theorem term_abs_lt (t : RawProduct) (E : ℤ) (hb : t.Bounded)
    (hs : t.significand ≠ 0 → t.rawScale ≤ E) : absQ t.value < 4 * pow2 E := by
  have hE := pow2_pos E
  by_cases hz : t.significand = 0
  · have hv : t.value = 0 := by simp [RawProduct.value, hz]
    rw [hv]
    have : absQ 0 = 0 := by decide +kernel
    rw [this]
    grind
  · have hle := pow2_le_of_le (hs hz)
    unfold RawProduct.Bounded at hb
    grind
```

**Supporting proofs:** [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulator_abs_lt](StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.idealProducts_abs_le_of_scale](Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a)

</details>

</details>

<a id="decl-387c2ed6b8a278d3"></a>

<details>
<summary><code>TensorCore.sumQ_map_abs_truncGrid_le</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L37)

```lean
theorem sumQ_map_abs_truncGrid_le (ts : List RawProduct) (q : ℤ) :
    sumQ (ts.map fun t => absQ (truncGrid t.value q)) ≤ sumQ (ts.map fun t => absQ t.value) := by
  induction ts with
  | nil => simp only [List.map_nil, sumQ]; exact Rat.le_refl
  | cons t ts ih =>
    simp only [List.map_cons, sumQ]
    have := truncGrid_abs_le t.value q
    grind
```

**Supporting proofs:** [TensorCore.truncGrid_abs_le](../Core/Truncation.md#decl-7a0e78c2723e16d6)

**Definitions and types:** [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulator_abs_le_mass](Program/Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.accumulator_abs_lt](StaticBudget.md#decl-a5c9d0f9181e3641)

</details>

</details>

<a id="decl-14900ccb909fe405"></a>

<details>
<summary><code>TensorCore.terms_ne_nil</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L46)

```lean
theorem terms_ne_nil (b : PreparedBlock) : b.terms ≠ [] := by
  simp [PreparedBlock.terms]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulator_abs_lt](StaticBudget.md#decl-a5c9d0f9181e3641)

</details>

</details>

<a id="decl-a5c9d0f9181e3641"></a>

<details>
<summary><code>TensorCore.accumulator_abs_lt</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L50)

```lean
/-- The accumulator of a scale-bounded block is below `n·4·2^E`. -/
theorem accumulator_abs_lt (b : PreparedBlock) (E : ℤ) (hb : ∀ t ∈ b.terms, t.Bounded)
    (hs : ScaleBounded b.terms E) :
    absQ b.accumulator < (b.terms.length : ℚ) * (4 * pow2 E) := by
  rw [accumulator_value]
  have h1 := absQ_sumQ_le (b.terms.map fun t => truncGrid t.value b.quantumExponent)
  have h2 : sumQ ((b.terms.map fun t => truncGrid t.value b.quantumExponent).map absQ) ≤
      sumQ (b.terms.map fun t => absQ t.value) := by
    rw [List.map_map]
    exact sumQ_map_abs_truncGrid_le b.terms b.quantumExponent
  have h3 : sumQ (b.terms.map fun t => absQ t.value) < (b.terms.length : ℚ) * (4 * pow2 E) := by
    apply sumQ_map_lt b.terms (terms_ne_nil b)
    intro t ht
    exact term_abs_lt t E (hb t ht) (hs t ht)
  grind
```

**Supporting proofs:** [TensorCore.absQ_sumQ_le](../Core/Sum.md#decl-9728c1755d91fb0d), [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.sumQ_map_abs_truncGrid_le](StaticBudget.md#decl-387c2ed6b8a278d3), [TensorCore.sumQ_map_lt](../Core/Sum.md#decl-5c0b2e6254ce280d), [TensorCore.term_abs_lt](StaticBudget.md#decl-eb7aab7cbcc8d87a), [TensorCore.terms_ne_nil](StaticBudget.md#decl-14900ccb909fe405)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulator_lt_pow2](StaticBudget.md#decl-690ecb505bab83f2)

</details>

</details>

<a id="decl-53da2dc9d7457364"></a>

<details>
<summary><code>TensorCore.quantumExponent_le</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L67)

```lean
/-- The alignment grid of a scale-bounded block with floor at most `E` is at most `2^(E−F)`
whenever some term is nonzero. -/
theorem quantumExponent_le (b : PreparedBlock) (E : ℤ) (hs : ScaleBounded b.terms E)
    (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E) (t : RawProduct) (ht : t ∈ b.terms)
    (hnz : t.significand ≠ 0) : b.quantumExponent ≤ E - b.profile.alignFraction := by
  obtain ⟨e, he, _⟩ := alignmentScale_term b.terms t ht hnz
  have hup := alignmentScale_upper b.terms E hs e (by rw [he]; simp)
  unfold PreparedBlock.quantumExponent PreparedBlock.eta Profile.applyFloor
  rw [he]
  cases hf : b.profile.alignFloor with
  | none => simp; omega
  | some f =>
    have := hfl f (by rw [hf]; simp)
    simp
    omega
```

**Supporting proofs:** [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6), [TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignment_static_bound](StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.rawAlignmentBudget_sound](Program/Bounds/Local.md#decl-1e83b17fa3bc236b)

</details>

</details>

<a id="decl-dc1f3c9c25d3691b"></a>

<details>
<summary><code>TensorCore.alignment_static_bound</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L82)

```lean
/-- Aggregate alignment loss from the scale bound alone. -/
theorem alignment_static_bound (b : PreparedBlock) (E : ℤ) (hs : ScaleBounded b.terms E)
    (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E) :
    absQ (sumQ b.alignmentResiduals) <
      (b.terms.length : ℚ) * pow2 (E - b.profile.alignFraction) := by
  have hq := pow2_pos (E - b.profile.alignFraction)
  by_cases hall : ∀ t ∈ b.terms, t.significand = 0
  · have hz : b.alignmentResiduals = b.terms.map fun _ => 0 := by
      unfold PreparedBlock.alignmentResiduals
      apply List.map_congr_left
      intro t ht
      have hv : t.value = 0 := by simp [RawProduct.value, hall t ht]
      rw [hv, truncGrid_zero]
      grind
    rw [hz, sumQ_map_zero]
    have h0 : absQ 0 = 0 := by decide +kernel
    rw [h0]
    have hn : (1 : ℚ) ≤ (b.terms.length : ℚ) := by
      have : 1 ≤ b.terms.length := by
        show 1 ≤ (_ :: _).length
        simp
      have := Rat.natCast_le_natCast.mpr this
      simpa using this
    have := Rat.mul_le_mul_of_nonneg_right hn (Rat.le_of_lt hq)
    grind
  · have ⟨t, ht, hnz⟩ : ∃ t ∈ b.terms, t.significand ≠ 0 := by
      apply Classical.byContradiction
      intro h
      apply hall
      intro t ht
      apply Classical.byContradiction
      intro hne
      exact h ⟨t, ht, hne⟩
    have hqe := quantumExponent_le b E hs hfl t ht hnz
    have hle := pow2_le_of_le hqe
    have hbound := block_alignment_bound b
    have hn : (0 : ℚ) ≤ (b.terms.length : ℚ) := Rat.natCast_nonneg
    have := Rat.mul_le_mul_of_nonneg_left hle hn
    grind
```

**Supporting proofs:** [TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.quantumExponent_le](StaticBudget.md#decl-53da2dc9d7457364), [TensorCore.sumQ_map_zero](../Core/Sum.md#decl-181b288c0a867eb6), [TensorCore.truncGrid_zero](../Core/Truncation.md#decl-c8fd94be6ed59920)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_static_error_bound](StaticBudget.md#decl-b5c964df86fc73b4)

</details>

</details>

<a id="decl-2759d010c1c6063d"></a>

<details>
<summary><code>TensorCore.staticBudget</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L124)

```lean
/-- Input-derived error budget for `n` terms on an `F`-bit alignment grid with scale bound
`E` and `n ≤ 2^L`: the alignment loss `n·2^(E−F)` plus the output quantum of a magnitude
below `2^(E+2+L)`. -/
def staticBudget (n : ℕ) (F E : ℤ) (L : ℕ) : ℚ :=
  (n : ℚ) * pow2 (E - F) + pow2 (max (E + 1 + L) (-126) - 23)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_scales](Program/Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.repeat_accurate_of_scales](Program/Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.staticCertificate_sound](Program/CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Program.staticErrorBudget](Program/CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.Regression.static_certificate_accepts](Regression/StaticBudget.md#decl-b37b5c200be6f62d), [TensorCore.Regression.static_certificate_applied](Regression/StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_consistent](Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.block_static_error_bound](StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.boundedDot_budget](Examples/BoundedDot.md#decl-a0a6954ceca26f79), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.familyConditions](../Gemm/Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](../Gemm/Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyError_nonneg](../Gemm/Family.md#decl-810b5bd68276af9d), [TensorCore.gemmCellCheck](../Gemm/Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmStaticError](../Gemm/Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.groupBound_le_static](Program/GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.runBlocks_of_scale_bound](Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_static](StaticBudget.md#decl-31af1b208da9e431), [TensorCore.staticBudget_positive](Program/Bounds/Scales.md#decl-52e870bce380a2a2), [TensorCore.staticCheck](Program/StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.staticCheck_sound](Program/StaticCertificate.md#decl-d9cfd7eeec01ec69), [TensorCore.small_schedule_room](Examples/BoundedDot.md#decl-30fd3ad0d5d57034), [TensorCore.small_schedule_tolerance](Examples/BoundedDot.md#decl-c193d14d0a9b59e9)

</details>

</details>

<a id="decl-690ecb505bab83f2"></a>

<details>
<summary><code>TensorCore.accumulator_lt_pow2</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L127)

```lean
theorem accumulator_lt_pow2 (b : PreparedBlock) (E : ℤ) (L : ℕ)
    (hb : ∀ t ∈ b.terms, t.Bounded) (hs : ScaleBounded b.terms E)
    (hL : b.terms.length ≤ 2 ^ L) : absQ b.accumulator < pow2 (E + 1 + L + 1) := by
  have h := accumulator_abs_lt b E hb hs
  have hE := pow2_pos E
  have hn : (b.terms.length : ℚ) ≤ ((2 ^ L : ℕ) : ℚ) := Rat.natCast_le_natCast.mpr hL
  have h4 : (0 : ℚ) ≤ 4 * pow2 E := by grind
  have := Rat.mul_le_mul_of_nonneg_right hn h4
  have heq : ((2 ^ L : ℕ) : ℚ) * (4 * pow2 E) = pow2 (E + 1 + L + 1) := by
    rw [← pow2_natCast]
    have h4' : (4 : ℚ) = pow2 2 := by decide +kernel
    rw [h4', ← pow2_add, ← pow2_add]
    congr 1
    omega
  rw [heq] at this
  grind
```

**Supporting proofs:** [TensorCore.accumulator_abs_lt](StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_static_error_bound](StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.prepared_static_success](StaticBudget.md#decl-2a79f971d61c16c9)

</details>

</details>

<a id="decl-b5c964df86fc73b4"></a>

<details>
<summary><code>TensorCore.block_static_error_bound</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L145)

```lean
/-- Static two-stage error bound for one block. -/
theorem block_static_error_bound (b : PreparedBlock) (d : Finite32) (E : ℤ) (L : ℕ)
    (hb : ∀ t ∈ b.terms, t.Bounded) (hs : ScaleBounded b.terms E)
    (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E) (hL : b.terms.length ≤ 2 ^ L)
    (hr : absQ b.accumulator ≤ maxFinite32)
    (hout : round32 .towardZero b.accumulator = some d.bits) :
    absQ (b.exactDot - d.value) < staticBudget b.terms.length b.profile.alignFraction E L := by
  have hd : value32 d.bits = some d.value := by simp [value32, d.valid, Finite32.value]
  have halign := alignment_static_bound b E hs hfl
  have hout' := rtz_residual_lt b.accumulator d.bits d.value hr hout hd
  have hacc := accumulator_lt_pow2 b E L hb hs hL
  have hout2 : absQ (b.accumulator - d.value) < pow2 (max (E + 1 + L) (-126) - 23) := by
    by_cases hz : b.accumulator = 0
    · have hdv : d.value = 0 := by
        have hz0 : round32 .towardZero 0 = some 0 := by decide +kernel
        rw [hz, hz0] at hout
        have hb0 : d.bits = 0 := (Option.some.inj hout).symm
        have hv : value32 0 = some 0 := by decide +kernel
        rw [hb0, hv] at hd
        exact (Option.some.inj hd).symm
      rw [hz, hdv]
      have h0 : absQ (0 - 0) = 0 := by decide +kernel
      rw [h0]
      exact pow2_pos _
    · have hpos := absQ_pos_of_ne_zero _ hz
      have hce := convExp_le_of_lt (absQ b.accumulator) hpos (E + 1 + L) hacc
      have := pow2_le_of_le (show convExp (absQ b.accumulator) - 23 ≤
        max (E + 1 + L) (-126) - 23 by omega)
      grind
  have hid := block_residual_identity b d.value
  unfold PreparedBlock.extractReference at hid
  have ht := absQ_add_le (b.accumulator - d.value) (sumQ b.alignmentResiduals)
  have he : b.exactDot - d.value = (b.accumulator - d.value) + sumQ b.alignmentResiduals := by
    grind
  rw [he]
  unfold staticBudget
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_pos_of_ne_zero](../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.accumulator_lt_pow2](StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.alignment_static_bound](StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.convExp_le_of_lt](../Core/Rounding.md#decl-49ec78234aca30b2), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.rtz_residual_lt](../Core/RoundingError.md#decl-ad79fb234a6a8f53)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convExp](../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.staticBudget](StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0)

</details>

</details>

<a id="decl-c065d1805b03afa6"></a>

<details>
<summary><code>TensorCore.maxFinite32_ge_pow2_127</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L182)

```lean
theorem maxFinite32_ge_pow2_127 : pow2 127 ≤ maxFinite32 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepared_static_success](StaticBudget.md#decl-2a79f971d61c16c9)

</details>

</details>

<a id="decl-2a79f971d61c16c9"></a>

<details>
<summary><code>TensorCore.prepared_static_success</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L185)

```lean
/-- A scale-bounded block with `E + 2 + L ≤ 127` is accepted. -/
theorem prepared_static_success (b : PreparedBlock) (E : ℤ) (L : ℕ)
    (hb : ∀ t ∈ b.terms, t.Bounded) (hs : ScaleBounded b.terms E)
    (hL : b.terms.length ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127) :
    absQ b.accumulator ≤ maxFinite32 := by
  have hacc := accumulator_lt_pow2 b E L hb hs hL
  have hle : pow2 (E + 1 + L + 1) ≤ pow2 127 := pow2_le_of_le (by omega)
  have := maxFinite32_ge_pow2_127
  grind
```

**Supporting proofs:** [TensorCore.accumulator_lt_pow2](StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.maxFinite32_ge_pow2_127](StaticBudget.md#decl-c065d1805b03afa6), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0)

</details>

</details>

<a id="decl-cc059aaa303d9b13"></a>

<details>
<summary><code>TensorCore.GroupScaleBounded</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L196)

```lean
/-- Operand-level scale bound for one group of encoded pairs: every pair decodes, and each
nonzero raw product has raw scale at most `E`. -/
def GroupScaleBounded (p : Profile) (g : List (p.Word × p.Word)) (E : ℤ) : Prop :=
  ∀ pair ∈ g, ∃ da db, p.decode pair.1 = some da ∧ p.decode pair.2 = some db ∧
    ((rawMul da db).significand ≠ 0 → (rawMul da db).rawScale ≤ E)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

<details>
<summary>Used by</summary>

[TensorCore.GroupScaleBounded.mono](Program/Bounds/Scales.md#decl-403621a23388d188), [TensorCore.Program.accurate_of_scales](Program/Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.repeat_accurate_of_scales](Program/Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.boundedDot_scales](Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.groupScaleCheck_sound](Program/StaticCertificate.md#decl-5583db47fae0681c), [TensorCore.idealProducts_abs_le_of_scale](Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.prepared_scaleBounded](StaticBudget.md#decl-ac851e1ac7fbea13), [TensorCore.runBlocks_of_scale_bound](Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_static](StaticBudget.md#decl-31af1b208da9e431), [TensorCore.small16_group](Examples/BoundedDot.md#decl-116dda86b04e3b4e), [TensorCore.staticCheck_sound](Program/StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-aae922e6ce3bb7ee"></a>

<details>
<summary><code>TensorCore.prepareProducts_of_decodes</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L200)

```lean
theorem prepareProducts_of_decodes (p : Profile) (g : List (p.Word × p.Word))
    (h : ∀ pair ∈ g, ∃ da db, p.decode pair.1 = some da ∧ p.decode pair.2 = some db) :
    ∃ qs, prepareProducts p g = some qs ∧
      ∀ q ∈ qs, ∃ pair ∈ g, p.decode pair.1 = some q.1 ∧ p.decode pair.2 = some q.2 := by
  induction g with
  | nil => exact ⟨[], rfl, by simp⟩
  | cons pair g ih =>
    rcases pair with ⟨a, b⟩
    obtain ⟨da, db, ha, hb⟩ := h (a, b) (by simp)
    obtain ⟨qs, hqs, hmem⟩ := ih (fun q hq => h q (by simp [hq]))
    have hqs' := hqs
    simp [prepareProducts] at hqs'
    refine ⟨(da, db) :: qs, by simp [prepareProducts, List.mapM_cons, ha, hb, hqs'], ?_⟩
    intro q hq
    simp only [List.mem_cons] at hq
    rcases hq with rfl | hq
    · exact ⟨(a, b), by simp, ha, hb⟩
    · obtain ⟨pair', hpair', h1, h2⟩ := hmem q hq
      exact ⟨pair', by simp [hpair'], h1, h2⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0)

</details>

</details>

<a id="decl-db4a0851b6327dd2"></a>

<details>
<summary><code>TensorCore.prepare_of_decodes</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L220)

```lean
theorem prepare_of_decodes {p : Profile} (g : List (p.Word × p.Word)) (c : Finite32)
    (qs : List (Decoded × Decoded)) (hqs : prepareProducts p g = some qs) :
    prepare (⟨g, c.bits⟩ : BlockInput p) = some ⟨p, qs, c.decoded⟩ := by
  have hcd : decode32 c.bits = some c.decoded := c.valid
  unfold prepare
  simp only [hcd, hqs]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0)

</details>

</details>

<a id="decl-46af87ad95b9feb9"></a>

<details>
<summary><code>TensorCore.idealProducts_of_prepareProducts</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L227)

```lean
theorem idealProducts_of_prepareProducts (p : Profile) (g : List (p.Word × p.Word))
    (qs : List (Decoded × Decoded)) (hqs : prepareProducts p g = some qs) :
    idealProducts p g = some (PreparedBlock.exactProducts ⟨p, qs, ⟨0, 0, 0⟩⟩) := by
  simp [idealProducts, hqs, PreparedBlock.exactProducts]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealProducts](Program/Defs.md#decl-5d908ac035267580), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0)

</details>

</details>

<a id="decl-ac851e1ac7fbea13"></a>

<details>
<summary><code>TensorCore.prepared_scaleBounded</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L234)

```lean
/-- A block built from a scale-bounded accumulator input and a scale-bounded group has
scale-bounded terms. -/
theorem prepared_scaleBounded {p : Profile} (g : List (p.Word × p.Word)) (c : Finite32)
    (qs : List (Decoded × Decoded)) (E : ℤ)
    (hmem : ∀ q ∈ qs, ∃ pair ∈ g, p.decode pair.1 = some q.1 ∧ p.decode pair.2 = some q.2)
    (hc : c.decoded.significand ≠ 0 → c.decoded.rawScale ≤ E) (hg : GroupScaleBounded p g E) :
    ScaleBounded (PreparedBlock.mk p qs c.decoded).terms E := by
  intro t ht
  simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
  rcases ht with rfl | ⟨⟨da, db⟩, hq, rfl⟩
  · exact hc
  · obtain ⟨pair, hpair, h1, h2⟩ := hmem (da, db) hq
    obtain ⟨da', db', h1', h2', hbound⟩ := hg pair hpair
    rw [h1] at h1'
    rw [h2] at h2'
    cases Option.some.inj h1'
    cases Option.some.inj h2'
    exact hbound
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GroupScaleBounded](StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0)

</details>

</details>

<a id="decl-9aa42bb13a9657f0"></a>

<details>
<summary><code>TensorCore.evalBlock_static</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L254)

```lean
/-- Static acceptance and error bound for one encoded block: the block is accepted, its
ideal is the accumulator input plus the group's exact products, and its uncorrected error is
below the input-derived budget. -/
theorem evalBlock_static {p : Profile} (g : List (p.Word × p.Word)) (c : Finite32) (E : ℤ)
    (L : ℕ) (hshape : g.length = p.products) (hfl : ∀ f ∈ p.alignFloor, f ≤ E)
    (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (hc : c.decoded.significand ≠ 0 → c.decoded.rawScale ≤ E) (hg : GroupScaleBounded p g E) :
    ∃ t, evalBlock (⟨g, c.bits⟩ : BlockInput p) = .ok t ∧
      idealProducts p g = some t.block.exactProducts ∧
      t.block.exactDot = c.value + t.block.exactProducts ∧
      absQ (t.block.exactDot - t.output.value) <
        staticBudget (p.products + 1) p.alignFraction E L := by
  obtain ⟨qs, hqs, hmem⟩ := prepareProducts_of_decodes p g
    (fun pair hpair => let ⟨da, db, h1, h2, _⟩ := hg pair hpair; ⟨da, db, h1, h2⟩)
  have hp := prepare_of_decodes g c qs hqs
  have hbounded := prepare_terms_bounded hp
  have hlen : (PreparedBlock.mk p qs c.decoded).terms.length = p.products + 1 := by
    rw [hbounded.1]
    show g.length + 1 = _
    rw [hshape]
  have hs := prepared_scaleBounded g c qs E hmem hc hg
  have hr := prepared_static_success _ E L hbounded.2 hs (by rw [hlen]; exact hL) hrange
  obtain ⟨t, ht⟩ := (evalBlock_success_iff p ⟨g, c.bits⟩).mpr ⟨hshape, _, hp, hr⟩
  have hblock : t.block = ⟨p, qs, c.decoded⟩ := by
    have := evalBlock_prepared ht
    rw [hp] at this
    exact (Option.some.inj this).symm
  have hout := evalPrepared_output (evalBlock_evalPrepared ht)
  rw [hblock] at hout
  refine ⟨t, ht, ?_, ?_, ?_⟩
  · rw [hblock]
    exact idealProducts_of_prepareProducts p g qs hqs
  · rw [hblock]
    rfl
  · rw [hblock]
    have := block_static_error_bound ⟨p, qs, c.decoded⟩ t.output E L hbounded.2 hs hfl
      (by rw [hlen]; exact hL) hr hout
    rw [hlen] at this
    exact this
```

**Supporting proofs:** [TensorCore.block_static_error_bound](StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.idealProducts_of_prepareProducts](StaticBudget.md#decl-46af87ad95b9feb9), [TensorCore.prepareProducts_of_decodes](StaticBudget.md#decl-aae922e6ce3bb7ee), [TensorCore.prepare_of_decodes](StaticBudget.md#decl-db4a0851b6327dd2), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.prepared_scaleBounded](StaticBudget.md#decl-ac851e1ac7fbea13), [TensorCore.prepared_static_success](StaticBudget.md#decl-2a79f971d61c16c9)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupScaleBounded](StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.ScaleBounded](StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.idealProducts](Program/Defs.md#decl-5d908ac035267580), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.staticBudget](StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_static](StaticBudget.md#decl-31af1b208da9e431)

</details>

</details>

<a id="decl-b23246c067dbeca7"></a>

<details>
<summary><code>TensorCore.finite32_scale_le</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L293)

```lean
/-- A finite FP32 value below `2^(E+1)` in magnitude has raw scale at most `E`, for
`E ≥ −126`. -/
theorem finite32_scale_le (c : Finite32) (E : ℤ) (hE : -126 ≤ E)
    (h : absQ c.value < pow2 (E + 1)) : c.decoded.significand ≠ 0 → c.decoded.rawScale ≤ E := by
  intro hnz
  rcases decode32_fields c.bits c.decoded c.valid with ⟨_, _, hd⟩ | ⟨_, _, hd⟩ | ⟨_, _, hd⟩
  · rw [hd] at hnz
    exact absurd rfl hnz
  · rw [hd]
    exact hE
  · have hv : c.value = c.decoded.value := rfl
    rw [hv, hd] at h
    rw [hd]
    show ((c.bits.toNat / 8388608 % 256 : ℕ) : ℤ) - 127 ≤ E
    generalize hr : ((c.bits.toNat / 8388608 % 256 : ℕ) : ℤ) - 127 = r at h
    generalize hm : c.bits.toNat % 8388608 = m at h
    unfold Decoded.value at h
    simp only at h
    have hq := pow2_pos (r - 23)
    rw [absQ_mul_pos _ _ hq] at h
    have hmag : ((8388608 + m : ℕ) : ℚ) ≤
        absQ (((if (c.bits.toNat / 2147483648 != 0) then -((8388608 + m : ℕ) : ℤ)
          else ((8388608 + m : ℕ) : ℤ) : ℤ) : ℚ)) := by
      split
      · rw [Rat.intCast_neg, absQ_neg, Rat.intCast_natCast, absQ_of_nonneg Rat.natCast_nonneg]
        exact Rat.le_refl
      · rw [Rat.intCast_natCast, absQ_of_nonneg Rat.natCast_nonneg]
        exact Rat.le_refl
    have hbase : pow2 r ≤ ((8388608 + m : ℕ) : ℚ) * pow2 (r - 23) := by
      have h1 : ((8388608 : ℕ) : ℚ) ≤ ((8388608 + m : ℕ) : ℚ) :=
        Rat.natCast_le_natCast.mpr (by omega)
      have h2 := Rat.mul_le_mul_of_nonneg_right h1 (Rat.le_of_lt hq)
      have h3 : ((8388608 : ℕ) : ℚ) * pow2 (r - 23) = pow2 r := by
        have : ((8388608 : ℕ) : ℚ) = pow2 23 := by decide +kernel
        rw [this, ← pow2_add]
        congr 1
        omega
      rw [h3] at h2
      exact h2
    have hlt : pow2 r < pow2 (E + 1) := by
      have h4 := Rat.mul_le_mul_of_nonneg_right hmag (Rat.le_of_lt hq)
      grind
    apply Classical.byContradiction
    intro hne
    have := pow2_le_of_le (show E + 1 ≤ r by omega)
    grind
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](../Core/Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.decode32_fields](../Core/RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.runBlocks_static](StaticBudget.md#decl-31af1b208da9e431)

</details>

</details>

<a id="decl-0916105e5f507bb2"></a>

<details>
<summary><code>TensorCore.idealContributions_cons</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L338)

```lean
theorem idealContributions_cons (p : Profile) (q : List (p.Word × p.Word))
    (rest : List (List (p.Word × p.Word))) (a b : ℚ) (ha : idealProducts p q = some a)
    (hb : idealContributions p rest = some b) :
    idealContributions p (q :: rest) = some (a + b) := by
  simp [idealContributions, ha, hb]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealContributions](Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Program/Defs.md#decl-5d908ac035267580)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroups_sound](Program/GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.idealContributions_cons_some](Program/StaticCertificate.md#decl-e1771047163e04a5), [TensorCore.runBlocks_static](StaticBudget.md#decl-31af1b208da9e431)

</details>

</details>

<a id="decl-31af1b208da9e431"></a>

<details>
<summary><code>TensorCore.runBlocks_static</code></summary>

[Lean source](../../../TensorCore/TC/StaticBudget.lean#L348)

```lean
/-- Static acceptance and error bound for a schedule. Every group is scale-bounded by `E`,
and every ideal partial sum stays below `2^(E+1)` with room for the accumulated error, so
every accumulator input keeps scale `E`. The run is then accepted and its final uncorrected
error is at most the number of groups times the per-group budget. No trace is consulted. -/
theorem runBlocks_static (p : Profile) (E : ℤ) (L : ℕ) (hE : -126 ≤ E)
    (hfl : ∀ f ∈ p.alignFloor, f ≤ E) (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (ps : List (List (p.Word × p.Word))) (hshape : ∀ g ∈ ps, g.length = p.products)
    (hscale : ∀ g ∈ ps, GroupScaleBounded p g E) (c : Finite32)
    (hpartial : ∀ n ≤ ps.length, ∀ v, idealContributions p (ps.take n) = some v →
      absQ (c.value + v) + (n : ℚ) * staticBudget (p.products + 1) p.alignFraction E L <
        pow2 (E + 1)) :
    ∃ ts products, runBlocks p c.bits ps = .ok ts ∧ idealContributions p ps = some products ∧
      absQ (c.value + products - (lastOutput c ts).value) ≤
        (ps.length : ℚ) * staticBudget (p.products + 1) p.alignFraction E L := by
  generalize hB : staticBudget (p.products + 1) p.alignFraction E L = B at hpartial
  induction ps generalizing c with
  | nil =>
    refine ⟨[], 0, rfl, rfl, ?_⟩
    simp only [lastOutput, List.length_nil]
    have h0 : absQ (c.value + 0 - c.value) = 0 := by
      rw [Rat.add_zero, Rat.sub_self]
      decide +kernel
    rw [h0]
    grind
  | cons q rest ih =>
    have hc0 : absQ c.value < pow2 (E + 1) := by
      have := hpartial 0 (by simp) 0 rfl
      have h00 : ((0 : ℕ) : ℚ) * B = 0 := by simp
      rw [Rat.add_zero, h00, Rat.add_zero] at this
      exact this
    have hcs := finite32_scale_le c E hE hc0
    obtain ⟨t, ht, hq, hdot, herr⟩ :=
      evalBlock_static q c E L (hshape q (by simp)) hfl hL hrange hcs (hscale q (by simp))
    rw [hB] at herr
    have hpartial' : ∀ n ≤ rest.length, ∀ v, idealContributions p (rest.take n) = some v →
        absQ (t.output.value + v) + (n : ℚ) * B < pow2 (E + 1) := by
      intro n hn v hv
      have h1 := hpartial (n + 1) (by simp; omega) (t.block.exactProducts + v)
        (by rw [List.take_succ_cons]; exact idealContributions_cons p q _ _ _ hq hv)
      have h2 := absQ_add_le (c.value + (t.block.exactProducts + v))
        (t.output.value - t.block.exactDot)
      rw [absQ_sub_comm] at h2
      have hcast : ((n + 1 : ℕ) : ℚ) = (n : ℚ) + 1 := by rw [Rat.natCast_add]; rfl
      rw [hcast] at h1
      rw [hdot] at h2 herr
      have h3 : c.value + (t.block.exactProducts + v) + (t.output.value - (c.value + t.block.exactProducts)) = t.output.value + v := by grind
      rw [h3] at h2
      grind
    obtain ⟨ts, products', hrun, hi', hbound⟩ := ih (fun g hg => hshape g (by simp [hg]))
      (fun g hg => hscale g (by simp [hg])) t.output hpartial'
    refine ⟨t :: ts, t.block.exactProducts + products', ?_, ?_, ?_⟩
    · simp only [runBlocks, ht, hrun]
    · exact idealContributions_cons p q rest _ _ hq hi'
    · simp only [lastOutput, List.length_cons]
      have hcast : ((rest.length + 1 : ℕ) : ℚ) = (rest.length : ℚ) + 1 := by
        rw [Rat.natCast_add]; rfl
      rw [hcast]
      have h2 := absQ_add_le (c.value + t.block.exactProducts - t.output.value)
        (t.output.value + products' - (lastOutput t.output ts).value)
      rw [hdot] at herr
      have h3 : c.value + t.block.exactProducts - t.output.value +
          (t.output.value + products' - (lastOutput t.output ts).value) =
          c.value + (t.block.exactProducts + products') - (lastOutput t.output ts).value := by
        grind
      rw [h3] at h2
      grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_sub_comm](../Core/Exact.md#decl-a632fad01d9c884a), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.finite32_scale_le](StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.idealContributions_cons](StaticBudget.md#decl-0916105e5f507bb2)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GroupScaleBounded](StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.idealContributions](Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_of_scale_bound](Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.staticCheck_sound](Program/StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>
