# TensorCore.Core.Binary.SignedBijection

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0d2ca3e13f7ea63f"></a>

<details>
<summary><code>TensorCore.BinaryRep.sign_of_nonzero</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L9)

```lean
theorem BinaryRep.sign_of_nonzero {f : Format} (r : BinaryRep f) (hn : r.value ≠ 0) :
    r.negative = decide (r.value < 0) := by
  have hk : r.significand ≠ 0 := by intro h; exact hn (r.value_eq_zero_iff.mpr h)
  have hp := Rat.mul_pos (Rat.natCast_pos.mpr (show 0 < r.significand by omega))
    (pow2_pos (r.exponent - f.fractionBits))
  symm
  unfold BinaryRep.value
  cases r.negative <;> simp only [Bool.false_eq_true, ↓reduceIte,
    decide_eq_true_eq, decide_eq_false_iff_not]
  · exact Rat.not_lt.mpr (Rat.le_of_lt hp)
  · rw [Rat.neg_mul]; grind
```

**Supporting proofs:** [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37)

</details>

</details>

<a id="decl-4764d57fcda6ba1e"></a>

<details>
<summary><code>TensorCore.binaryValue_sign</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L21)

```lean
theorem binaryValue_sign (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f)
    (v : ℚ) (hv : binaryValue f b.val = some v) (hn : v ≠ 0) :
    binarySign f b.val = decide (v < 0) := by
  have he : (decodeBinaryRep f hf b).value = v :=
    Option.some.inj ((decodeBinaryRep_value f hf b).symm.trans hv)
  have hs := (decodeBinaryRep f hf b).sign_of_nonzero (by rwa [he])
  rwa [he] at hs
```

**Supporting proofs:** [TensorCore.BinaryRep.sign_of_nonzero](SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498)

</details>

</details>

<a id="decl-9cff42a1aec63f03"></a>

<details>
<summary><code>TensorCore.binaryValue_sign_injective</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L30)

```lean
/-- Equal rational values and equal sign bits identify finite words, including zero. -/
theorem binaryValue_sign_injective (f : Format) (hf : f.WellFormed)
    (b₁ b₂ : FiniteBinaryWord f) (v : ℚ) (h₁ : binaryValue f b₁.val = some v)
    (h₂ : binaryValue f b₂.val = some v) (hs : binarySign f b₁.val = binarySign f b₂.val) :
    b₁ = b₂ := by
  by_cases hn : v = 0
  · have hv₁ : (decodeBinaryRep f hf b₁).value = 0 :=
      (Option.some.inj ((decodeBinaryRep_value f hf b₁).symm.trans h₁)).trans hn
    have hv₂ : (decodeBinaryRep f hf b₂).value = 0 :=
      (Option.some.inj ((decodeBinaryRep_value f hf b₂).symm.trans h₂)).trans hn
    have hk₁ := (decodeBinaryRep f hf b₁).value_eq_zero_iff.mp hv₁
    have hk₂ := (decodeBinaryRep f hf b₂).value_eq_zero_iff.mp hv₂
    have heq : decodeBinaryRep f hf b₁ = decodeBinaryRep f hf b₂ := by
      have he₁ := (decodeBinaryRep f hf b₁).normalized
      have he₂ := (decodeBinaryRep f hf b₂).normalized
      have hp := Nat.two_pow_pos f.fractionBits
      have he : (decodeBinaryRep f hf b₁).exponent = (decodeBinaryRep f hf b₂).exponent := by omega
      have hs' : (decodeBinaryRep f hf b₁).negative = (decodeBinaryRep f hf b₂).negative := hs
      exact BinaryRep.ext hs' he (hk₁.trans hk₂.symm)
    rw [← encode_decodeBinaryRep f hf b₁, heq, encode_decodeBinaryRep]
  · apply Subtype.ext
    exact binaryValue_injective_nonzero f hf b₁.val b₂.val v h₁ h₂ hn
```

**Supporting proofs:** [TensorCore.BinaryRep.ext](Defs.md#decl-f2ead0cc316f23f7), [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.binaryValue_injective_nonzero](RoundTrip.md#decl-0ab63ba315dd3cca), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](../../IEEE/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba), [TensorCore.PaperSpec.word_value_sign_unique](../../Gemm/Specification/ScalarRounding.md#decl-50e39e663380ba0c)

</details>

</details>

<a id="decl-cb2fcf99d19b6a37"></a>

<details>
<summary><code>TensorCore.decodeSignedBinary</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L52)

```lean
def decodeSignedBinary (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    SignedFiniteValue f :=
  ⟨(decodeBinaryRep f hf b).value, binarySign f b.val,
    (decodeBinaryRep f hf b).finiteValue, (decodeBinaryRep f hf b).sign_of_nonzero⟩
```

**Supporting proofs:** [TensorCore.BinaryRep.finiteValue](RoundTrip.md#decl-8ccfd6c43d66f303), [TensorCore.BinaryRep.sign_of_nonzero](SignedBijection.md#decl-0d2ca3e13f7ea63f)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80)

<details>
<summary>Used by</summary>

[TensorCore.Regression.finite_bijection_signed_zeros](../../TC/Regression/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba), [TensorCore.signedFiniteBinaryBijection](SignedBijection.md#decl-52799c5e93137e77)

</details>

</details>

<a id="decl-6b99b2e3d470fe06"></a>

<details>
<summary><code>TensorCore.exactFiniteWord</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L59)

```lean
/-- Exact encoding of an arithmetic finite value, using the existing converter.
Zero here follows the converter's positive-zero convention. -/
def exactFiniteWord (f : Format) (hf : f.WellFormed) (v : ℚ) (hv : f.FiniteValue v) :
    FiniteBinaryWord f :=
  match h : roundBinary f .nearestEven v with
  | none => by
    exfalso
    obtain ⟨b, hb, _⟩ := roundBinary_exact_of_finite f hf hv
    simp [h] at hb
  | some bits => ⟨bits, by
    obtain ⟨b, hb, hbv⟩ := roundBinary_exact_of_finite f hf hv
    rw [h] at hb
    cases Option.some.inj hb
    unfold binaryValue at hbv
    cases hd : (classify f bits).finite with
    | none => simp [hd] at hbv
    | some d => exact ⟨d, rfl⟩⟩
```

**Supporting proofs:** [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

<details>
<summary>Used by</summary>

[TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c)

</details>

</details>

<a id="decl-25318fd4bd410e4c"></a>

<details>
<summary><code>TensorCore.exactFiniteWord_value</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L75)

```lean
theorem exactFiniteWord_value (f : Format) (hf : f.WellFormed) (v : ℚ) (hv : f.FiniteValue v) :
    binaryValue f (exactFiniteWord f hf v hv).val = some v := by
  obtain ⟨b, hb, hbv⟩ := roundBinary_exact_of_finite f hf hv
  unfold exactFiniteWord
  split
  · rename_i h
    rw [h] at hb
    contradiction
  · rename_i bits h
    rw [h] at hb
    cases Option.some.inj hb
    exact hbv
```

**Supporting proofs:** [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3)

</details>

</details>

<a id="decl-88b6b09937a229a9"></a>

<details>
<summary><code>TensorCore.BinaryRep.zero</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L88)

```lean
def BinaryRep.zero (f : Format) (hf : f.WellFormed) (negative : Bool) : BinaryRep f :=
  ⟨negative, f.emin, 0, Int.le_refl _, f.emin_le_emax hf, Nat.two_pow_pos _, Or.inr rfl⟩
```

**Supporting proofs:** [TensorCore.Format.emin_le_emax](Encoding.md#decl-f21f4f9c313ac4d5)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](../../IEEE/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.zero](../../IEEE/Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.IEEE.zero_sign](../../IEEE/Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](../../IEEE/Basic.md#decl-42575e26b6696b19), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3)

</details>

</details>

<a id="decl-1ab7a3966bec465c"></a>

<details>
<summary><code>TensorCore.encodeSignedBinary</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L92)

```lean
/-- Encoding a signed value preserves its zero sign, separately from arithmetic rounding. -/
def encodeSignedBinary (f : Format) (hf : f.WellFormed) (v : SignedFiniteValue f) :
    FiniteBinaryWord f :=
  if v.value = 0 then encodeBinaryRep f hf (BinaryRep.zero f hf v.negative)
  else exactFiniteWord f hf v.value v.finite
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRep.zero](SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06)

<details>
<summary>Used by</summary>

[TensorCore.Regression.finite_bijection_signed_zeros](../../TC/Regression/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba), [TensorCore.signedFiniteBinaryBijection](SignedBijection.md#decl-52799c5e93137e77)

</details>

</details>

<a id="decl-7432a4a377dff8e3"></a>

<details>
<summary><code>TensorCore.encodeSignedBinary_value</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L97)

```lean
theorem encodeSignedBinary_value (f : Format) (hf : f.WellFormed) (v : SignedFiniteValue f) :
    binaryValue f (encodeSignedBinary f hf v).val = some v.value := by
  unfold encodeSignedBinary
  split
  · rename_i hz
    have h := (BinaryRep.zero f hf v.negative).encode_value hf
    have hzero := (BinaryRep.zero f hf v.negative).value_eq_zero_iff.mpr rfl
    change binaryValue f (BinaryRep.zero f hf v.negative).encode = some v.value
    rw [h, hzero, hz]
  · exact exactFiniteWord_value f hf v.value v.finite
```

**Supporting proofs:** [TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRep.zero](SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba)

</details>

</details>

<a id="decl-a3ba45d9a3c47498"></a>

<details>
<summary><code>TensorCore.encodeSignedBinary_sign</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L108)

```lean
theorem encodeSignedBinary_sign (f : Format) (hf : f.WellFormed) (v : SignedFiniteValue f) :
    binarySign f (encodeSignedBinary f hf v).val = v.negative := by
  by_cases hz : v.value = 0
  · simp only [encodeSignedBinary, hz, ↓reduceIte, encodeBinaryRep]
    exact (encodeBinary_fields f hf (BinaryRep.zero f hf v.negative)).1
  · rw [binaryValue_sign f hf _ v.value (encodeSignedBinary_value f hf v) hz]
    exact (v.sign_nonzero hz).symm
```

**Supporting proofs:** [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.zero](SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba)

</details>

</details>

<a id="decl-2c11097025d8ee97"></a>

<details>
<summary><code>TensorCore.decode_encodeSignedBinary</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L116)

```lean
theorem decode_encodeSignedBinary (f : Format) (hf : f.WellFormed) (v : SignedFiniteValue f) :
    decodeSignedBinary f hf (encodeSignedBinary f hf v) = v := by
  have hv := Option.some.inj ((decodeBinaryRep_value f hf (encodeSignedBinary f hf v)).symm.trans
    (encodeSignedBinary_value f hf v))
  have hs := encodeSignedBinary_sign f hf v
  cases v
  simp only [decodeSignedBinary]
  congr
```

**Supporting proofs:** [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3)

**Definitions and types:** [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.signedFiniteBinaryBijection](SignedBijection.md#decl-52799c5e93137e77)

</details>

</details>

<a id="decl-c65020fe3f9595ba"></a>

<details>
<summary><code>TensorCore.encode_decodeSignedBinary</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L125)

```lean
theorem encode_decodeSignedBinary (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    encodeSignedBinary f hf (decodeSignedBinary f hf b) = b := by
  apply binaryValue_sign_injective f hf _ _ (decodeSignedBinary f hf b).value
  · exact encodeSignedBinary_value f hf _
  · exact decodeBinaryRep_value f hf b
  · exact encodeSignedBinary_sign f hf _
```

**Supporting proofs:** [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3)

**Definitions and types:** [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.finite_bijection_signed_zeros](../../TC/Regression/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.signedFiniteBinaryBijection](SignedBijection.md#decl-52799c5e93137e77)

</details>

</details>

<a id="decl-52799c5e93137e77"></a>

<details>
<summary><code>TensorCore.signedFiniteBinaryBijection</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/SignedBijection.lean#L134)

```lean
/-- Finite IEEE words correspond bijectively to representable rationals with two zeros.
For nonzero values the sign is determined, so there is exactly one representation. -/
def signedFiniteBinaryBijection (f : Format) (hf : f.WellFormed) :
    BinaryBijection (SignedFiniteValue f) (FiniteBinaryWord f) :=
  ⟨encodeSignedBinary f hf, decodeSignedBinary f hf,
    decode_encodeSignedBinary f hf, encode_decodeSignedBinary f hf⟩
```

**Supporting proofs:** [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba)

**Definitions and types:** [TensorCore.BinaryBijection](../Defs.md#decl-85b8cc75be52e666), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.SignedFiniteValue](Defs.md#decl-86fdea2e792bf344), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
