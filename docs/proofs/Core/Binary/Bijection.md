# TensorCore.Core.Binary.Bijection

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3a2559ae7dd8fec5"></a>

<details>
<summary><code>TensorCore.BinaryRep.encode</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L10)

```lean
def BinaryRep.encode {f : Format} (r : BinaryRep f) : BitVec f.width :=
  encodeBinary f r.negative r.exponent r.significand
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.IEEE.zero](../../IEEE/Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.IEEE.zero_sign](../../IEEE/Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](../../IEEE/Basic.md#decl-42575e26b6696b19), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-d81c625dde1b8c14"></a>

<details>
<summary><code>TensorCore.BinaryRep.encode_value</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L13)

```lean
theorem BinaryRep.encode_value {f : Format} (hf : f.WellFormed) (r : BinaryRep f) :
    binaryValue f r.encode = some r.value := by
  exact encodeBinary_value f hf r.negative r.exponent r.significand
    r.exponent_min r.exponent_max (by omega) (by have := r.significand_lt; omega)
    (by have := r.normalized; omega)
```

**Supporting proofs:** [TensorCore.encodeBinary_value](Encoding.md#decl-4c3ec26630f2de66)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.zero_value](../../IEEE/Basic.md#decl-42575e26b6696b19), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3)

</details>

</details>

<a id="decl-9da98bc2392e0660"></a>

<details>
<summary><code>TensorCore.finiteBinaryWord_exponent</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L19)

```lean
theorem finiteBinaryWord_exponent {f : Format} (b : FiniteBinaryWord f) :
    binaryExponentField f b.val ≠ 2 ^ f.exponentBits - 1 := by
  obtain ⟨d, hd⟩ := b.property
  intro he
  unfold classify classifyNat at hd
  change b.val.toNat / 2 ^ f.fractionBits % 2 ^ f.exponentBits = _ at he
  simp only [he, ↓reduceIte] at hd
  split at hd <;> simp [Classification.finite] at hd
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80)

</details>

</details>

<a id="decl-dd7db11ae1e1ea80"></a>

<details>
<summary><code>TensorCore.decodeBinaryRep</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L28)

```lean
def decodeBinaryRep (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) : BinaryRep f :=
  { negative := binarySign f b.val
    exponent := if binaryExponentField f b.val = 0 then f.emin
      else (binaryExponentField f b.val : ℤ) - f.bias
    significand := if binaryExponentField f b.val = 0 then b.val.toNat % 2 ^ f.fractionBits
      else 2 ^ f.fractionBits + b.val.toNat % 2 ^ f.fractionBits
    exponent_min := by split <;> unfold Format.emin <;> omega
    exponent_max := by
      have ht := finiteBinaryWord_exponent b
      have hb := Nat.mod_lt (b.val.toNat / 2 ^ f.fractionBits) (Nat.two_pow_pos f.exponentBits)
      change binaryExponentField f b.val < 2 ^ f.exponentBits at hb
      split
      · exact f.emin_le_emax hf
      · unfold Format.emax; omega
    significand_lt := by
      have hm := Nat.mod_lt b.val.toNat (Nat.two_pow_pos f.fractionBits)
      rw [Nat.pow_succ]
      split <;> omega
    normalized := by split <;> simp_all }
```

**Supporting proofs:** [TensorCore.Format.emin_le_emax](Encoding.md#decl-f21f4f9c313ac4d5), [TensorCore.finiteBinaryWord_exponent](Bijection.md#decl-9da98bc2392e0660)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.finiteBinaryBijection](Bijection.md#decl-b1a16403ef1ee57a)

</details>

</details>

<a id="decl-abc077f61bbca602"></a>

<details>
<summary><code>TensorCore.encodeBinaryRep</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L48)

```lean
def encodeBinaryRep (f : Format) (hf : f.WellFormed) (r : BinaryRep f) : FiniteBinaryWord f :=
  ⟨r.encode, by
    have h := r.encode_value hf
    unfold binaryValue at h
    cases hd : (classify f r.encode).finite with
    | none => simp [hd] at h
    | some d => exact ⟨d, rfl⟩⟩
```

**Supporting proofs:** [TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](../../IEEE/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.finiteBinaryBijection](Bijection.md#decl-b1a16403ef1ee57a)

</details>

</details>

<a id="decl-bcffec0f99ba4510"></a>

<details>
<summary><code>TensorCore.encodeBinary_fields</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L57)

```lean
/-- Field extraction for the existing generic encoder. -/
theorem encodeBinary_fields (f : Format) (hf : f.WellFormed) (r : BinaryRep f) :
    binarySign f r.encode = r.negative ∧
    binaryExponentField f r.encode =
      (if r.significand < 2 ^ f.fractionBits then 0 else (r.exponent + f.bias).toNat) ∧
    r.encode.toNat % 2 ^ f.fractionBits =
      (if r.significand < 2 ^ f.fractionBits then r.significand
       else r.significand - 2 ^ f.fractionBits) := by
  have hpay := encodeBinary_payload_lt f hf r.exponent r.significand
    (by omega) (by have := r.significand_lt; omega) r.exponent_min r.exponent_max
  have hnat := encodeBinary_toNat f hf r.negative r.exponent r.significand
    (by omega) (by have := r.significand_lt; omega) r.exponent_min r.exponent_max
  have hP := Nat.two_pow_pos f.fractionBits
  have hW := Nat.two_pow_pos f.exponentBits
  have hk := r.significand_lt
  rw [Nat.pow_succ] at hk
  have hE : (r.exponent + f.bias).toNat < 2 ^ f.exponentBits := by
    have := r.exponent_max
    unfold Format.emax at this
    omega
  unfold binarySign binaryExponentField
  rw [show r.encode.toNat = _ from hnat, Nat.pow_add]
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  have hsgn : ∀ pay, pay < P * W →
      ((if r.negative then P * W else 0) + pay) % P = pay % P ∧
      ((if r.negative then P * W else 0) + pay) / P % W = pay / P % W ∧
      (((if r.negative then P * W else 0) + pay) / (P * W) != 0) = r.negative := by
    intro pay hlt
    have hPW := Nat.mul_pos hP hW
    cases r.negative
    · simp [Nat.div_eq_of_lt hlt]
    · have h1 : (P * W + pay) / (P * W) = 1 := by
        rw [show P * W + pay = P * W * 1 + pay by omega,
          Nat.mul_add_div hPW, Nat.div_eq_of_lt hlt]
      simp only [↓reduceIte, Nat.mul_add_mod, Nat.mul_add_div hP, Nat.add_mod_left, h1]
      simp
  by_cases hsub : r.significand < P
  · rw [if_pos (show (r.significand : ℤ) < (P : ℕ) by omega)] at hpay ⊢
    simp only [Int.toNat_natCast]
    obtain ⟨hfrac, hexp, hsign⟩ := hsgn r.significand hpay
    rw [hsign, hexp, hfrac, if_pos hsub, Nat.mod_eq_of_lt hsub, Nat.div_eq_of_lt hsub]
    simp [hsub]
  · rw [if_neg (show ¬(r.significand : ℤ) < (P : ℕ) by omega)] at hpay ⊢
    have hcast : ((r.significand : ℤ) - (P : ℕ)).toNat = r.significand - P := by omega
    rw [hcast] at hpay ⊢
    obtain ⟨hfrac, hexp, hsign⟩ := hsgn _ hpay
    rw [hsign, hexp, hfrac, if_neg hsub, Nat.mul_comm _ P,
      Nat.mul_add_mod, Nat.mul_add_div hP,
      Nat.mod_eq_of_lt (show r.significand - P < P by omega),
      Nat.div_eq_of_lt (show r.significand - P < P by omega), Nat.add_zero,
      Nat.mod_eq_of_lt hE]
    simp [hsub]
```

**Supporting proofs:** [TensorCore.encodeBinary_payload_lt](Encoding.md#decl-60c2bea1c86e8fcf), [TensorCore.encodeBinary_toNat](Encoding.md#decl-0082d54957605cf4)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.zero_sign](../../IEEE/Basic.md#decl-a55f8f28a95986bc), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-2b92b9b7bcfc34f3"></a>

<details>
<summary><code>TensorCore.decode_encodeBinaryRep</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L110)

```lean
theorem decode_encodeBinaryRep (f : Format) (hf : f.WellFormed) (r : BinaryRep f) :
    decodeBinaryRep f hf (encodeBinaryRep f hf r) = r := by
  obtain ⟨hs, he, hk⟩ := encodeBinary_fields f hf r
  have hemin := r.exponent_min
  have hn := r.normalized
  have hP := Nat.two_pow_pos f.fractionBits
  have hE : (r.exponent + f.bias).toNat ≠ 0 := by unfold Format.emin at hemin; omega
  cases r with
  | mk s e k h1 h2 h3 h4 =>
    simp only [decodeBinaryRep, encodeBinaryRep, hs, he, hk]
    congr 1 <;> split <;> simp_all <;> omega
```

**Supporting proofs:** [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.finiteBinaryBijection](Bijection.md#decl-b1a16403ef1ee57a)

</details>

</details>

<a id="decl-0ef3a70fffcc866c"></a>

<details>
<summary><code>TensorCore.encode_decodeBinaryRep</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L123)

```lean
/-- Reassembling sign, exponent and fraction reproduces the original finite word. -/
theorem encode_decodeBinaryRep (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    encodeBinaryRep f hf (decodeBinaryRep f hf b) = b := by
  apply Subtype.ext
  change (decodeBinaryRep f hf b).encode = b.val
  apply BitVec.eq_of_toNat_eq
  let hr := decodeBinaryRep f hf b
  rw [show (decodeBinaryRep f hf b).encode.toNat = _ from
    encodeBinary_toNat f hf hr.negative hr.exponent hr.significand
      (by omega) (by have := hr.significand_lt; omega) hr.exponent_min hr.exponent_max]
  simp only [hr, decodeBinaryRep, binarySign, binaryExponentField, Nat.pow_add]
  dsimp +instances only [hr, decodeBinaryRep, binarySign, binaryExponentField]
  have hn := b.val.isLt
  have hwidth : 2 ^ f.width = 2 ^ (f.fractionBits + f.exponentBits) * 2 := by
    rw [show f.width = f.fractionBits + f.exponentBits + 1 by unfold Format.width; omega,
      Nat.pow_succ]
  rw [hwidth, Nat.pow_add] at hn
  have hP := Nat.two_pow_pos f.fractionBits
  have hW := Nat.two_pow_pos f.exponentBits
  generalize hPv : 2 ^ f.fractionBits = P at *
  generalize hWv : 2 ^ f.exponentBits = W at *
  generalize hnv : b.val.toNat = n at *
  have hPW := Nat.mul_pos hP hW
  have hq : n / (P * W) < 2 := (Nat.div_lt_iff_lt_mul hPW).mpr (by omega)
  have hdecomp : n = (n / (P * W)) * (P * W) + (n / P % W) * P + n % P := by
    have h1 := Nat.div_add_mod n P
    have h2 := Nat.div_add_mod (n / P) W
    have h3 := congrArg (fun z => z * P) h2
    rw [Nat.div_div_eq_div_mul] at h3
    grind
  have hfrac := Nat.mod_lt n hP
  have hsign : (if (n / (P * W) != 0) then P * W else 0) = (n / (P * W) : ℕ) * (P * W) := by
    by_cases hz : n / (P * W) = 0
    · simp [hz]
    · have ho : n / (P * W) = 1 := by
        generalize n / (P * W) = q at *
        omega
      simp [ho]
  rw [hsign]
  by_cases he : n / P % W = 0
  · simp only [he, ↓reduceIte]
    rw [if_pos (show ((n % P : ℕ) : ℤ) < (P : ℕ) by omega)]
    simp only [Int.toNat_natCast]
    simp only [he, Nat.zero_mul, Nat.add_zero] at hdecomp
    omega
  · simp only [he, ↓reduceIte]
    rw [if_neg (show ¬ ((P + n % P : ℕ) : ℤ) < (P : ℕ) by omega)]
    have hE : (((n / P % W : ℕ) : ℤ) - f.bias + f.bias).toNat = n / P % W := by omega
    have hK : (((P + n % P : ℕ) : ℤ) - (P : ℕ)).toNat = n % P := by omega
    rw [hE, hK]
    omega
```

**Supporting proofs:** [TensorCore.encodeBinary_toNat](Encoding.md#decl-0082d54957605cf4)

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryExponentField](Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.finiteBinaryBijection](Bijection.md#decl-b1a16403ef1ee57a)

</details>

</details>

<a id="decl-b1a16403ef1ee57a"></a>

<details>
<summary><code>TensorCore.finiteBinaryBijection</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L174)

```lean
def finiteBinaryBijection (f : Format) (hf : f.WellFormed) :
    BinaryBijection (BinaryRep f) (FiniteBinaryWord f) :=
  ⟨encodeBinaryRep f hf, decodeBinaryRep f hf,
    decode_encodeBinaryRep f hf, encode_decodeBinaryRep f hf⟩
```

**Supporting proofs:** [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c)

**Definitions and types:** [TensorCore.BinaryBijection](../Defs.md#decl-85b8cc75be52e666), [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-35db687909729831"></a>

<details>
<summary><code>TensorCore.decodeBinaryRep_value</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Bijection.lean#L179)

```lean
theorem decodeBinaryRep_value (f : Format) (hf : f.WellFormed) (b : FiniteBinaryWord f) :
    binaryValue f b.val = some (decodeBinaryRep f hf b).value := by
  have h := (decodeBinaryRep f hf b).encode_value hf
  have hb := congrArg Subtype.val (encode_decodeBinaryRep f hf b)
  change (decodeBinaryRep f hf b).encode = b.val at hb
  rwa [hb] at h
```

**Supporting proofs:** [TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c)

**Definitions and types:** [TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba)

</details>

</details>
