# TensorCore.IEEE.Compatibility

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-78bff244af6cfb2c"></a>

<details>
<summary><code>TensorCore.IEEE.convert_self_finite</code></summary>

[Lean source](../../../TensorCore/IEEE/Compatibility.lean#L9)

```lean
/-- Same-format IEEE conversion fixes every finite encoding, including both
zero encodings, and raises no exception in any rounding direction. -/
theorem convert_self_finite (f : BinaryFormat) (cfg : Context) (a : Word f)
    (s : Bool) (x : ℚ) (hd : decode f a = .finite s x) :
    convert f f cfg a = ⟨a, {}⟩ := by
  obtain ⟨hv, hs⟩ := (decode_finite_iff f a s x).mp hd
  by_cases hx : x = 0
  · have ha : ∃ d, (classify f.layout a).finite = some d := by
      unfold binaryValue at hv
      cases hc : (classify f.layout a).finite with
      | none => simp [hc] at hv
      | some d => exact ⟨d, rfl⟩
    let za := encodeBinaryRep f.layout f.valid (BinaryRep.zero f.layout f.valid s)
    have he := binaryValue_sign_injective f.layout f.valid za ⟨a, ha⟩ 0
      (zero_value f s) (by simpa [hx] using hv) (by
        change sign f (zero f s) = sign f a
        rw [zero_sign]; exact hs.symm)
    have heq : zero f s = a := congrArg Subtype.val he
    simp [convert, convertDatum, hd, round, hx, heq]
  · have hrb := binaryValue_roundBinary f.layout f.valid cfg.mode a x hv hx
    have hr := (roundBinary_range hrb).2
    have he : finiteBits f cfg.mode x hr = a :=
      Option.some.inj ((finiteBits_eq f cfg.mode x hr).symm.trans hrb)
    simp [convert, convertDatum, hd, round, hx, hr, he, hv]
```

**Supporting proofs:** [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.zero_sign](Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](Basic.md#decl-42575e26b6696b19), [TensorCore.binaryValue_roundBinary](../Core/Binary/RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign_injective](../Core/Binary/SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.roundBinary_range](../Core/Binary/RoundOp.md#decl-0877ce0e6eb40a61)

**Definitions and types:** [TensorCore.BinaryRep.zero](../Core/Binary/SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinaryWord](../Core/Binary/Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binarySign](../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.encodeBinaryRep](../Core/Binary/Bijection.md#decl-abc077f61bbca602), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-78bff6c53f7ce3d2"></a>

<details>
<summary><code>TensorCore.IEEE.convertPayload_bounded</code></summary>

[Lean source](../../../TensorCore/IEEE/Compatibility.lean#L32)

```lean
theorem convertPayload_bounded (source target : BinaryFormat) (p : ℕ)
    (hp : p < quietBit source) : convertPayload source target p < quietBit target := by
  cases source <;> cases target <;>
    simp [convertPayload, quietBit, BinaryFormat.layout, fp16, fp32, fp64] at hp ⊢ <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2)

</details>

</details>

<a id="decl-9386b7dd0de650fe"></a>

<details>
<summary><code>TensorCore.IEEE.convertPayload_roundtrip</code></summary>

[Lean source](../../../TensorCore/IEEE/Compatibility.lean#L37)

```lean
theorem convertPayload_roundtrip (source target : BinaryFormat) (p : ℕ)
    (hw : source.layout.fractionBits ≤ target.layout.fractionBits) :
    convertPayload target source (convertPayload source target p) = p := by
  cases source <;> cases target <;>
    simp [convertPayload, BinaryFormat.layout, fp16, fp32, fp64] at hw ⊢ <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2)

</details>

</details>

<a id="decl-11ef56fd93e042f2"></a>

<details>
<summary><code>TensorCore.IEEE.convert_quietNaN_roundtrip</code></summary>

[Lean source](../../../TensorCore/IEEE/Compatibility.lean#L44)

```lean
/-- Widening then narrowing a quiet NaN preserves sign and payload. -/
theorem convert_quietNaN_roundtrip (source target : BinaryFormat) (cfg : Context)
    (s : Bool) (p : ℕ) (hp : p < quietBit source)
    (hw : source.layout.fractionBits ≤ target.layout.fractionBits) :
    convert target source cfg (convert source target cfg (nan source s p)).bits =
      ⟨nan source s p, {}⟩ := by
  have hpt := convertPayload_bounded source target p hp
  simp [convert, convertDatum, decode_nan, Nat.mod_eq_of_lt hp, Nat.mod_eq_of_lt hpt,
    convertPayload_roundtrip source target p hw]
```

**Supporting proofs:** [TensorCore.IEEE.convertPayload_bounded](Compatibility.md#decl-78bff6c53f7ce3d2), [TensorCore.IEEE.convertPayload_roundtrip](Compatibility.md#decl-9386b7dd0de650fe), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7)

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bf169c1fd8f96954"></a>

<details>
<summary><code>TensorCore.IEEE.fma_finite_contract</code></summary>

[Lean source](../../../TensorCore/IEEE/Compatibility.lean#L55)

```lean
/-- Finite FMA uses only a final range condition: its exact product is not rounded
or required to fit the destination before adding the original accumulator. -/
theorem fma_finite_contract (f : BinaryFormat) (cfg : Context) (a b c : Word f)
    (sa sb sc : Bool) (x y z : ℚ)
    (ha : decode f a = .finite sa x) (hb : decode f b = .finite sb y)
    (hc : decode f c = .finite sc z) :
    RoundSpec f cfg (sumZeroSign cfg.mode (xor sa sb) sc) (x * y + z) (fma f cfg a b c) := by
  have h := fma_correct f cfg a b c
  simpa [FmaSpec, ha, hb, hc, Datum.isNaN] using h
```

**Supporting proofs:** [TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isInfinite](Basic.md#decl-850c48dc8c3c08ec), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negative](Basic.md#decl-75faab7c3bc85104), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
