# TensorCore.Numerics.Binary.Encoding

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ef3be5b34ec052c1"></a>

<details>
<summary><code>TensorCore.fp32_finiteValue</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L16)

```lean
theorem fp32_finiteValue (z : ℚ) : fp32.FiniteValue z ↔ FiniteValue32 z := Iff.rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FiniteValue32](../Defs.md#decl-916e7e459d399e32), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f21f4f9c313ac4d5"></a>

<details>
<summary><code>TensorCore.Format.emin_le_emax</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L18)

```lean
theorem Format.emin_le_emax (f : Format) (hf : f.WellFormed) : f.emin ≤ f.emax := by
  obtain ⟨_, hE⟩ := hf
  have h4 : 4 ≤ 2 ^ f.exponentBits := by
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) hE
    simpa using this
  unfold Format.emin Format.emax
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.zero](SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.IEEE.maxFiniteWord_value](../../Scalar/Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.zero_value](../../Scalar/Basic.md#decl-42575e26b6696b19), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.classifyNat_finiteValue](Encoding.md#decl-1caf128b0fdea826), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.grid_finiteValue_of_range](ScalarSum.md#decl-e550bdcb926669d5)

</details>

</details>

<a id="decl-1caf128b0fdea826"></a>

<details>
<summary><code>TensorCore.classifyNat_finiteValue</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L27)

```lean
/-- Every finite decoded value of a well-formed format has the arithmetic form. -/
theorem classifyNat_finiteValue (f : Format) (hf : f.WellFormed) (n : ℕ) (d : Decoded)
    (h : (classifyNat f n).finite = some d) : f.FiniteValue d.value := by
  have hemin := f.emin_le_emax hf
  have hfrac := Nat.mod_lt n (Nat.two_pow_pos f.fractionBits)
  have hexp := Nat.mod_lt (n / 2 ^ f.fractionBits) (Nat.two_pow_pos f.exponentBits)
  have hpow : 2 ^ (f.fractionBits + 1) = 2 ^ f.fractionBits * 2 := Nat.pow_succ 2 _
  unfold classifyNat at h
  dsimp only at h
  unfold Format.FiniteValue
  generalize hP : 2 ^ f.fractionBits = P at *
  generalize hP1 : 2 ^ (f.fractionBits + 1) = P1 at *
  generalize hW : 2 ^ f.exponentBits = W at *
  split at h
  · split at h <;> simp [Classification.finite] at h
  · split at h
    · split at h
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        refine ⟨0, f.emin, Int.le_refl _, hemin, by simp; omega, ?_⟩
        simp [Decoded.value]
      · simp only [Classification.finite, Option.some.injEq] at h
        subst d
        refine ⟨if (n / 2 ^ (f.fractionBits + f.exponentBits) != 0) then
          -((n % P : ℕ) : ℤ) else ((n % P : ℕ) : ℤ),
          1 - f.bias, Int.le_refl _, hemin, ?_, ?_⟩
        · split
          · rw [Int.natAbs_neg, Int.natAbs_natCast]; omega
          · rw [Int.natAbs_natCast]; omega
        · simp [Decoded.value]
    · simp only [Classification.finite, Option.some.injEq] at h
      subst d
      rename_i htop hzero
      refine ⟨if (n / 2 ^ (f.fractionBits + f.exponentBits) != 0) then
        -((P + n % P : ℕ) : ℤ) else ((P + n % P : ℕ) : ℤ),
        ((n / P % W : ℕ) : ℤ) - f.bias, ?_, ?_, ?_, ?_⟩
      · unfold Format.emin
        omega
      · unfold Format.emax
        rw [hW]
        omega
      · split
        · rw [Int.natAbs_neg, Int.natAbs_natCast]; omega
        · rw [Int.natAbs_natCast]; omega
      · simp [Decoded.value]
```

**Supporting proofs:** [TensorCore.Format.emin_le_emax](Encoding.md#decl-f21f4f9c313ac4d5)

**Definitions and types:** [TensorCore.Classification](../Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.classifyNat](../Encoding.md#decl-52d401d7433cac5a), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.representableBinary_finite](ScalarSum.md#decl-d4d92bf55b290375)

</details>

</details>

<a id="decl-0082d54957605cf4"></a>

<details>
<summary><code>TensorCore.encodeBinary_toNat</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L73)

```lean
/-- The constructed encoding fits the word and has the stated fields. -/
theorem encodeBinary_toNat (f : Format) (hf : f.WellFormed) (negative : Bool) (e k : ℤ)
    (hk0 : 0 ≤ k) (hk1 : k < ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ)) (_he1 : f.emin ≤ e)
    (he2 : e ≤ f.emax) :
    (encodeBinary f negative e k).toNat =
      (if negative then 2 ^ (f.fractionBits + f.exponentBits) else 0) +
        (if k < (2 ^ f.fractionBits : ℕ) then k.toNat
         else (e + f.bias).toNat * 2 ^ f.fractionBits + (k - (2 ^ f.fractionBits : ℕ)).toNat) := by
  obtain ⟨hp, hE⟩ := hf
  unfold encodeBinary
  rw [BitVec.toNat_ofNat]
  apply Nat.mod_eq_of_lt
  have hwidth : 2 ^ f.width = 2 * 2 ^ (f.fractionBits + f.exponentBits) := by
    unfold Format.width
    rw [show 1 + f.exponentBits + f.fractionBits = (f.fractionBits + f.exponentBits) + 1 by omega,
      Nat.pow_succ]
    omega
  have hPW : 2 ^ (f.fractionBits + f.exponentBits) = 2 ^ f.fractionBits * 2 ^ f.exponentBits :=
    Nat.pow_add 2 _ _
  have hpow : 2 ^ (f.fractionBits + 1) = 2 ^ f.fractionBits * 2 := Nat.pow_succ 2 _
  have hP := Nat.two_pow_pos f.fractionBits
  have hW : 4 ≤ 2 ^ f.exponentBits := by
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) hE
    simpa using this
  have hemax : e + f.bias ≤ ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) := by
    unfold Format.emax at he2
    omega
  rw [hwidth, hPW]
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  generalize hP1 : 2 ^ (f.fractionBits + 1) = P1 at *
  have hpay : (if k < (P : ℕ) then k.toNat
      else (e + f.bias).toNat * P + (k - (P : ℕ)).toNat) < P * W := by
    split
    · rename_i hk
      have h1 : P ≤ P * W := Nat.le_mul_of_pos_right _ (by omega)
      omega
    · rename_i hk
      have hle : (e + f.bias).toNat ≤ W - 2 := by omega
      have hmul : (e + f.bias).toNat * P ≤ (W - 2) * P := Nat.mul_le_mul_right _ hle
      have hr : (k - (P : ℕ)).toNat < P := by
        omega
      have hsplit : (W - 2) * P + 2 * P = W * P := by
        rw [← Nat.add_mul, Nat.sub_add_cancel (by omega)]
      rw [Nat.mul_comm P W]
      omega
  generalize hpayv : (if k < (P : ℕ) then k.toNat
      else (e + f.bias).toNat * P + (k - (P : ℕ)).toNat) = pay at *
  cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte] <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeBinary_parity](Encoding.md#decl-9ed3eec562cea40c), [TensorCore.encodeBinary_value](Encoding.md#decl-4c3ec26630f2de66), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c)

</details>

</details>

<a id="decl-9ed3eec562cea40c"></a>

<details>
<summary><code>TensorCore.encodeBinary_parity</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L122)

```lean
theorem encodeBinary_parity (f : Format) (hf : f.WellFormed) (negative : Bool) (e k : ℤ)
    (hk0 : 0 ≤ k) (hk1 : k < ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ)) (he1 : f.emin ≤ e)
    (he2 : e ≤ f.emax) :
    (encodeBinary f negative e k).toNat % 2 = k.toNat % 2 := by
  rw [encodeBinary_toNat f hf negative e k hk0 hk1 he1 he2]
  obtain ⟨hp, _⟩ := hf
  have hPeven : 2 ^ f.fractionBits % 2 = 0 := by
    obtain ⟨m, hm⟩ : ∃ m, f.fractionBits = m + 1 := ⟨f.fractionBits - 1, by omega⟩
    rw [hm, Nat.pow_succ]
    simp
  have hPW : 2 ^ (f.fractionBits + f.exponentBits) % 2 = 0 := by
    rw [Nat.pow_add, Nat.mul_mod, hPeven]
    simp
  have hmul : (e + f.bias).toNat * 2 ^ f.fractionBits % 2 = 0 := by
    rw [Nat.mul_mod, hPeven]
    simp
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hPWv : 2 ^ (f.fractionBits + f.exponentBits) = PW at *
  generalize hP1 : 2 ^ (f.fractionBits + 1) = P1 at *
  generalize hmv : (e + f.bias).toNat * P = M at *
  cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte] <;> split <;> omega
```

**Supporting proofs:** [TensorCore.encodeBinary_toNat](Encoding.md#decl-0082d54957605cf4)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be)

</details>

</details>

<a id="decl-60c2bea1c86e8fcf"></a>

<details>
<summary><code>TensorCore.encodeBinary_payload_lt</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L145)

```lean
/-- The payload of a constructed encoding is below `2^(p+E)`. -/
theorem encodeBinary_payload_lt (f : Format) (hf : f.WellFormed) (e k : ℤ)
    (_hk0 : 0 ≤ k) (hk1 : k < ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ)) (_he1 : f.emin ≤ e)
    (he2 : e ≤ f.emax) :
    (if k < (2 ^ f.fractionBits : ℕ) then k.toNat
      else (e + f.bias).toNat * 2 ^ f.fractionBits + (k - (2 ^ f.fractionBits : ℕ)).toNat) <
      2 ^ f.fractionBits * 2 ^ f.exponentBits := by
  obtain ⟨hp, hE⟩ := hf
  have hpow : 2 ^ (f.fractionBits + 1) = 2 ^ f.fractionBits * 2 := Nat.pow_succ 2 _
  have hP := Nat.two_pow_pos f.fractionBits
  have hW : 4 ≤ 2 ^ f.exponentBits := by
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) hE
    simpa using this
  have hemax : e + f.bias ≤ ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) := by
    unfold Format.emax at he2
    omega
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  generalize hP1 : 2 ^ (f.fractionBits + 1) = P1 at *
  split
  · rename_i hk
    have h1 : P ≤ P * W := Nat.le_mul_of_pos_right _ (by omega)
    omega
  · rename_i hk
    have hle : (e + f.bias).toNat ≤ W - 2 := by omega
    have hmul : (e + f.bias).toNat * P ≤ (W - 2) * P := Nat.mul_le_mul_right _ hle
    have hr : (k - (P : ℕ)).toNat < P := by omega
    have hsplit : (W - 2) * P + 2 * P = W * P := by
      rw [← Nat.add_mul, Nat.sub_add_cancel (by omega)]
    rw [Nat.mul_comm P W]
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeBinary_value](Encoding.md#decl-4c3ec26630f2de66)

</details>

</details>

<a id="decl-4c3ec26630f2de66"></a>

<details>
<summary><code>TensorCore.encodeBinary_value</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L177)

```lean
/-- The constructed encoding decodes to the value it was built from. -/
theorem encodeBinary_value (f : Format) (hf : f.WellFormed) (negative : Bool) (e k : ℤ)
    (he1 : f.emin ≤ e) (he2 : e ≤ f.emax) (hk0 : 0 ≤ k)
    (hk1 : k < ((2 ^ (f.fractionBits + 1) : ℕ) : ℤ))
    (hsub : ((2 ^ f.fractionBits : ℕ) : ℤ) ≤ k ∨ e = f.emin) :
    binaryValue f (encodeBinary f negative e k) =
      some ((if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - f.fractionBits)) := by
  have hpaylt := encodeBinary_payload_lt f hf e k hk0 hk1 he1 he2
  obtain ⟨hp, hE⟩ := hf
  have hPW : 2 ^ (f.fractionBits + f.exponentBits) = 2 ^ f.fractionBits * 2 ^ f.exponentBits :=
    Nat.pow_add 2 _ _
  have hpow : 2 ^ (f.fractionBits + 1) = 2 ^ f.fractionBits * 2 := Nat.pow_succ 2 _
  have hP := Nat.two_pow_pos f.fractionBits
  have hW : 4 ≤ 2 ^ f.exponentBits := by
    have := Nat.pow_le_pow_right (show 0 < 2 by decide) hE
    simpa using this
  have hemax : e + f.bias ≤ ((2 ^ f.exponentBits - 2 : ℕ) : ℤ) := by
    unfold Format.emax at he2
    omega
  have hemin : 1 - f.bias ≤ e := he1
  unfold binaryValue classify
  rw [encodeBinary_toNat f ⟨hp, hE⟩ negative e k hk0 hk1 he1 he2]
  unfold classifyNat
  dsimp only
  rw [hPW]
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  generalize hP1 : 2 ^ (f.fractionBits + 1) = P1 at *
  have hPWpos : 0 < P * W := Nat.mul_pos hP (by omega)
  -- The three fields of the word, for either sign.
  have hsgn : ∀ pay, pay < P * W →
      ((if negative then P * W else 0) + pay) % P = pay % P ∧
      ((if negative then P * W else 0) + pay) / P % W = pay / P % W ∧
      (((if negative then P * W else 0) + pay) / (P * W) != 0) = negative := by
    intro pay hlt
    cases negative
    · show (0 + pay) % P = pay % P ∧ (0 + pay) / P % W = pay / P % W ∧
        ((0 + pay) / (P * W) != 0) = false
      rw [Nat.zero_add, Nat.div_eq_of_lt hlt]
      exact ⟨rfl, rfl, rfl⟩
    · show (P * W + pay) % P = pay % P ∧ (P * W + pay) / P % W = pay / P % W ∧
        ((P * W + pay) / (P * W) != 0) = true
      have h1 : (P * W + pay) / (P * W) = 1 := by
        rw [show P * W + pay = P * W * 1 + pay by omega, Nat.mul_add_div hPWpos,
          Nat.div_eq_of_lt hlt]
      rw [Nat.mul_add_mod, Nat.mul_add_div hP, Nat.add_mod_left, h1]
      exact ⟨rfl, rfl, rfl⟩
  by_cases hk : k < (P : ℤ)
  · rw [if_pos hk] at hpaylt ⊢
    obtain ⟨hfrac, hexpf, hneg⟩ := hsgn k.toNat hpaylt
    have hkP : k.toNat < P := by omega
    rw [hfrac, hexpf, hneg, Nat.mod_eq_of_lt hkP, Nat.div_eq_of_lt hkP, Nat.zero_mod]
    have he : e = f.emin := by
      rcases hsub with h | h
      · exfalso; omega
      · exact h
    subst he
    simp only [show (0 : ℕ) ≠ W - 1 by omega, ↓reduceIte]
    by_cases hz : k.toNat = 0
    · have hk0' : k = 0 := by omega
      subst hk0'
      simp [hz, Classification.finite, Decoded.value] <;> cases negative <;> simp
    · have hk' : ((k.toNat : ℕ) : ℤ) = k := Int.toNat_of_nonneg hk0
      simp only [hz, ↓reduceIte, Classification.finite, hk']
      unfold Format.emin
      cases negative <;> simp [Decoded.value]
  · rw [if_neg hk] at hpaylt ⊢
    have hP' : (P : ℤ) ≤ k := by omega
    obtain ⟨hfrac, hexpf, hneg⟩ := hsgn _ hpaylt
    have hr : (k - (P : ℕ)).toNat < P := by omega
    have hfield : (e + f.bias).toNat < W := by omega
    have hfield1 : (e + f.bias).toNat ≠ 0 := by omega
    have hfieldtop : (e + f.bias).toNat ≠ W - 1 := by omega
    rw [hfrac, hexpf, hneg, Nat.mul_comm _ P, Nat.mul_add_mod, Nat.mul_add_div hP,
      Nat.div_eq_of_lt hr, Nat.add_zero, Nat.mod_eq_of_lt hr, Nat.mod_eq_of_lt hfield]
    have hsig : ((P + (k - (P : ℕ)).toNat : ℕ) : ℤ) = k := by omega
    have hexp : (((e + f.bias).toNat : ℕ) : ℤ) - f.bias = e := by omega
    simp only [hfieldtop, hfield1, ↓reduceIte, Classification.finite, hsig, hexp]
    cases negative <;> simp [Decoded.value]
```

**Supporting proofs:** [TensorCore.encodeBinary_payload_lt](Encoding.md#decl-60c2bea1c86e8fcf), [TensorCore.encodeBinary_toNat](Encoding.md#decl-0082d54957605cf4)

**Definitions and types:** [TensorCore.Classification](../Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.classifyNat](../Encoding.md#decl-52d401d7433cac5a), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.IEEE.maxFiniteWord_value](../../Scalar/Basic.md#decl-798b937fdff5abb2), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be)

</details>

</details>

<a id="decl-a5de0a69a17e78c5"></a>

<details>
<summary><code>TensorCore.binarySign</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L256)

```lean
def binarySign (f : Format) (bits : BitVec f.width) : Bool :=
  bits.toNat / 2 ^ (f.fractionBits + f.exponentBits) != 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](../../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.round_correct](../../Scalar/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.sign](../../Scalar/Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.zero_sign](../../Scalar/Basic.md#decl-a55f8f28a95986bc), [TensorCore.binary64Fma_correct](../../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-c12aa273bd1bbbb3"></a>

<details>
<summary><code>TensorCore.binaryExponentField</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/Encoding.lean#L259)

```lean
def binaryExponentField (f : Format) (bits : BitVec f.width) : ℕ :=
  bits.toNat / 2 ^ f.fractionBits % 2 ^ f.exponentBits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.zero_sign](../../Scalar/Basic.md#decl-a55f8f28a95986bc), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.finiteBinaryWord_exponent](Bijection.md#decl-9da98bc2392e0660), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>
