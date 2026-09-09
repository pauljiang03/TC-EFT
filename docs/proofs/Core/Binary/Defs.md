# TensorCore.Core.Binary.Defs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-895d436fd0a35170"></a>

<details>
<summary><code>TensorCore.BinaryRep</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Defs.lean#L8)

```lean
/-- Canonical arithmetic data, including a sign for either zero. -/
structure BinaryRep (f : Format) where
  negative : Bool
  exponent : ℤ
  significand : ℕ
  exponent_min : f.emin ≤ exponent
  exponent_max : exponent ≤ f.emax
  significand_lt : significand < 2 ^ (f.fractionBits + 1)
  normalized : 2 ^ f.fractionBits ≤ significand ∨ exponent = f.emin
  deriving DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.BinaryRep.ext](Defs.md#decl-f2ead0cc316f23f7), [TensorCore.BinaryRep.finiteValue](RoundTrip.md#decl-8ccfd6c43d66f303), [TensorCore.BinaryRep.sign_of_nonzero](SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.BinaryRep.value](Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.BinaryRep.zero](SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.IEEE.zero_sign](../../IEEE/Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](../../IEEE/Basic.md#decl-42575e26b6696b19), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeBinaryRep](Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.finiteBinaryBijection](Bijection.md#decl-b1a16403ef1ee57a), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>

<a id="decl-f2ead0cc316f23f7"></a>

<details>
<summary><code>TensorCore.BinaryRep.ext</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Defs.lean#L18)

```lean
theorem BinaryRep.ext {f : Format} {a b : BinaryRep f}
    (hs : a.negative = b.negative) (he : a.exponent = b.exponent)
    (hk : a.significand = b.significand) : a = b := by
  cases a
  cases b
  simp_all
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03)

</details>

</details>

<a id="decl-cc6dcf5c8ebfaa31"></a>

<details>
<summary><code>TensorCore.BinaryRep.value</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Defs.lean#L25)

```lean
def BinaryRep.value {f : Format} (r : BinaryRep f) : ℚ :=
  (if r.negative then -(r.significand : ℚ) else r.significand) *
    pow2 (r.exponent - f.fractionBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRep](Defs.md#decl-895d436fd0a35170), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.BinaryRep.finiteValue](RoundTrip.md#decl-8ccfd6c43d66f303), [TensorCore.BinaryRep.sign_of_nonzero](SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.BinaryRep.value_eq_zero_iff](RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.IEEE.zero_value](../../IEEE/Basic.md#decl-42575e26b6696b19), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-b1ebef5bf580ea01"></a>

<details>
<summary><code>TensorCore.FiniteBinaryWord</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Defs.lean#L30)

```lean
/-- Domain: exactly words whose IEEE classification is finite, with both zero words. -/
abbrev FiniteBinaryWord (f : Format) := { bits : BitVec f.width // ∃ d, (classify f bits).finite = some d }
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](../../IEEE/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.Regression.finite_bijection_signed_zeros](../../TC/Regression/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.Regression.negativeZero16](../../TC/Regression/DirectedBinary.md#decl-886728ef6cdfd42e), [TensorCore.Regression.positiveZero16](../../TC/Regression/DirectedBinary.md#decl-7640a0640949b17b), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.decodeBinaryRep](Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeBinaryRep](Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c), [TensorCore.finiteBinaryBijection](Bijection.md#decl-b1a16403ef1ee57a), [TensorCore.finiteBinaryWord_exponent](Bijection.md#decl-9da98bc2392e0660), [TensorCore.signedFiniteBinaryBijection](SignedBijection.md#decl-52799c5e93137e77)

</details>

</details>

<a id="decl-86fdea2e792bf344"></a>

<details>
<summary><code>TensorCore.SignedFiniteValue</code></summary>

[Lean source](../../../../TensorCore/Core/Binary/Defs.lean#L32)

```lean
structure SignedFiniteValue (f : Format) where
  value : ℚ
  negative : Bool
  finite : f.FiniteValue value
  sign_nonzero : value ≠ 0 → negative = decide (value < 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99)

<details>
<summary>Used by</summary>

[TensorCore.Regression.finite_bijection_signed_zeros](../../TC/Regression/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.decodeSignedBinary](SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeSignedBinary](SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.encodeSignedBinary_sign](SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeSignedBinary](SignedBijection.md#decl-c65020fe3f9595ba), [TensorCore.signedFiniteBinaryBijection](SignedBijection.md#decl-52799c5e93137e77)

</details>

</details>
