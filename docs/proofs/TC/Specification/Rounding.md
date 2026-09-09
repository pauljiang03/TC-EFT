# TensorCore.TC.Specification.Rounding

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4158336941743c50"></a>

<details>
<summary><code>TensorCore.PaperSpec.value32_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L12)

```lean
theorem value32_eq (b : BitVec 32) : value32 b = TensorCore.value32 b := by
  unfold value32
  change (decode (layoutOf fp32) b.toNat).map Term.value = _
  rw [decode_eq]
  simp only [Option.map_map]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.binary32](Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.layoutOf](Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.termOf](Stages.md#decl-5d5575e19169b785), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e), [TensorCore.classifyNat](../../Core/Encoding.md#decl-52d401d7433cac5a), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20)

</details>

</details>

<a id="decl-324135f1be845e5f"></a>

<details>
<summary><code>TensorCore.PaperSpec.magnitude_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L19)

```lean
theorem magnitude_eq (x : ℚ) : magnitude x = absQ x := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b5e80a12c41db688"></a>

<details>
<summary><code>TensorCore.PaperSpec.maxFinite_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L20)

```lean
theorem maxFinite_eq : maxFinite = maxFinite32 := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f713036600fa453d"></a>

<details>
<summary><code>TensorCore.PaperSpec.between_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L21)

```lean
theorem between_eq (x y : ℚ) : Between x y ↔ Between0 x y := Iff.rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Between0](../../Core/Binary/CorrectRounding.md#decl-e53091bc8dd24dfe), [TensorCore.PaperSpec.Between](Defs.md#decl-4a8f7985f3bff078)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b87aa592b2f7ce0a"></a>

<details>
<summary><code>TensorCore.PaperSpec.encode32_sign</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L23)

```lean
private theorem encode32_sign (negative : Bool) (e k : ℤ)
    (he1 : -126 ≤ e) (he2 : e ≤ 127) (hk0 : 0 ≤ k) (hk1 : k < 2 ^ 24) :
    ((encode32 negative e k).toNat / 2147483648 != 0) = negative := by
  rw [encode32_toNat negative e k hk0 hk1 he1 he2]
  cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte, Nat.reducePow]
  all_goals split <;> simp <;> omega
```

**Supporting proofs:** [TensorCore.encode32_toNat](../../Core/EncodingProperties.md#decl-69d2d972fbf20b0d)

**Definitions and types:** [TensorCore.encode32](../../Core/RoundOp.md#decl-2d041a1e685373ec)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.round32_sign](Rounding.md#decl-f93b23e259cce9bf)

</details>

</details>

<a id="decl-f93b23e259cce9bf"></a>

<details>
<summary><code>TensorCore.PaperSpec.round32_sign</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L30)

```lean
theorem round32_sign (x : ℚ) (b : F32) (h : round32 .towardZero x = some b) :
    (b.toNat / 2147483648 != 0) = decide (x < 0) := by
  by_cases hz : x = 0
  · subst x
    have hzero : round32 .towardZero 0 = some 0 := by decide +kernel
    have hb : b = 0 := by simpa only [hzero, Option.some.injEq] using h.symm
    subst b
    decide
  have hr := round32_range h
  have hm := absQ_pos_of_ne_zero x hz
  obtain ⟨he1, he2, _, _⟩ := convExp_bounds (absQ x) hm hr
  obtain ⟨hk0, hk1, hsub, htop⟩ := convCoeff_bounds .towardZero (absQ x) hm hr
  have hs := carry_spec _ _ he1 he2 hk0 hk1 hsub htop
  unfold round32 round32Core at h
  rw [if_neg (Rat.not_lt.mpr hr), if_neg hz] at h
  generalize hp : carry (convExp (absQ x)) (convCoeff .towardZero (absQ x)) = pair at h hs
  rcases pair with ⟨e, k⟩
  dsimp only at h hs
  rw [if_neg (by omega)] at h
  cases Option.some.inj h
  exact encode32_sign _ _ _ hs.1 hs.2.1 hs.2.2.1 hs.2.2.2.1
```

**Supporting proofs:** [TensorCore.absQ_pos_of_ne_zero](../../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.carry_spec](../../Core/ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.convCoeff_bounds](../../Core/ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](../../Core/ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.round32_range](../../Core/RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.PaperSpec.encode32_sign](Rounding.md#decl-b87aa592b2f7ce0a)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.carry](../../Core/RoundOp.md#decl-e870a105595fff5f), [TensorCore.convCoeff](../../Core/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.encode32](../../Core/RoundOp.md#decl-2d041a1e685373ec), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](../../Core/RoundOp.md#decl-a47adb12319758c3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826)

</details>

</details>

<a id="decl-04c2440f27285826"></a>

<details>
<summary><code>TensorCore.PaperSpec.round32_rounds</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L52)

```lean
theorem round32_rounds (x : ℚ) (b : F32) (h : round32 .towardZero x = some b) :
    Rounds x b := by
  have hr := round32_range h
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardZero_correct fp32 (by decide) x hr
  change round32 .towardZero x = some bits at hb
  rw [h] at hb
  cases Option.some.inj hb
  obtain ⟨d, hd, hbetween, hmax⟩ := hc
  refine ⟨round32_sign x b h, d, ?_, hbetween, ?_⟩
  · rw [value32_eq]; exact hd
  · intro other y hy hxy
    rw [value32_eq] at hy
    exact hmax y (value32_finite other y hy) hxy
```

**Supporting proofs:** [TensorCore.PaperSpec.round32_sign](Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50), [TensorCore.round32_range](../../Core/RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.roundBinary_towardZero_correct](../../Core/Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.value32_finite](../../Core/EncodingProperties.md#decl-a66b8320dd17a2c9)

**Definitions and types:** [TensorCore.Between0](../../Core/Binary/CorrectRounding.md#decl-e53091bc8dd24dfe), [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Between](Defs.md#decl-4a8f7985f3bff078), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.TowardZero](../../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.signed_zero_is_required](../../Regression/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.rounds_iff](Rounding.md#decl-aec56cebf6fd4fd1)

</details>

</details>

<a id="decl-6c7995fb8803ab3c"></a>

<details>
<summary><code>TensorCore.PaperSpec.zero_bits</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L66)

```lean
private theorem zero_bits (b : F32) (h : TensorCore.value32 b = some 0) :
    b.toNat = 0 ∨ b.toNat = 2147483648 := by
  cases hd : decode32 b with
  | none => simp [TensorCore.value32, hd] at h
  | some d =>
    have hv : d.value = 0 := by simpa [TensorCore.value32, hd] using h
    have hs : d.significand = 0 := by
      have hp := pow2_pos (d.rawScale - d.fractionalBits)
      unfold Decoded.value at hv
      have hc : (d.significand : ℚ) = 0 := by grind
      exact Rat.intCast_inj.mp (by simpa using hc)
    have hlt := b.isLt
    rcases decode32_fields b d hd with ⟨_, _, rfl⟩ | ⟨_, hm, rfl⟩ | ⟨_, _, rfl⟩
    · omega
    · dsimp only at hs
      split at hs <;> omega
    · dsimp only at hs
      split at hs <;> omega
```

**Supporting proofs:** [TensorCore.decode32_fields](../../Core/RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20)

</details>

</details>

<a id="decl-ca5813743de21e20"></a>

<details>
<summary><code>TensorCore.PaperSpec.rounds_unique</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L85)

```lean
theorem rounds_unique (x : ℚ) (a b : F32) (ha : Rounds x a) (hb : Rounds x b) : a = b := by
  obtain ⟨hsa, va, hva, hba, hma⟩ := ha
  obtain ⟨hsb, vb, hvb, hbb, hmb⟩ := hb
  have hle := hma b vb hvb hbb
  have hge := hmb a va hva hba
  have hv : va = vb := by
    unfold Between magnitude at *
    grind
  subst vb
  rw [value32_eq] at hva hvb
  by_cases hz : va = 0
  · subst va
    have za := zero_bits a hva
    have zb := zero_bits b hvb
    have hsign := hsa.trans hsb.symm
    apply BitVec.eq_of_toNat_eq
    rcases za with za | za <;> rcases zb with zb | zb <;> simp_all
  · exact value32_injective a b va hva hvb hz
```

**Supporting proofs:** [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50), [TensorCore.value32_injective](../../Core/RoundTrip.md#decl-c92b8ed7f76cc40c), [TensorCore.PaperSpec.zero_bits](Rounding.md#decl-6c7995fb8803ab3c)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Between](Defs.md#decl-4a8f7985f3bff078), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.rounds_iff](Rounding.md#decl-aec56cebf6fd4fd1)

</details>

</details>

<a id="decl-aec56cebf6fd4fd1"></a>

<details>
<summary><code>TensorCore.PaperSpec.rounds_iff</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Rounding.lean#L104)

```lean
theorem rounds_iff (x : ℚ) (b : F32) (hr : magnitude x ≤ maxFinite) :
    Rounds x b ↔ round32 .towardZero x = some b := by
  constructor
  · intro h
    obtain ⟨a, _, ha, _⟩ := round32_finite_exists .towardZero x hr
    have hab := rounds_unique x a b (round32_rounds x a ha) h
    rwa [hab] at ha
  · exact round32_rounds x b
```

**Supporting proofs:** [TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20), [TensorCore.round32_finite_exists](../AcceptedDomain.md#decl-13c6e80f5f7e2f5a)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
