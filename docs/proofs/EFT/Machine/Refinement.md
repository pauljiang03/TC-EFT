# TensorCore.EFT.Machine.Refinement

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-98c4f9688b4f1890"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_agrees</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Refinement.lean#L11)

```lean
/-- Bit refinement of the paper-interface reference on every accepted finite input.
Branch tags may differ because bounded scalar acceptance additionally checks the
executed intermediate encodings. Exact consolidation uses a fixed workspace. -/
theorem algorithm1_agrees {path : Path} {x : BlockInput path.profile} {D : F32} {t : BlockTrace}
    (ht : prepareEncodedEFT x D = .ok t) :
    (algorithm1 path x D).map Result.bits = .ok t.algorithm1.bits := by
  obtain ⟨hlen, hx, hD⟩ := prepareEncodedEFT_spec ht
  have hs : TensorCore.exactDot x = some t.block.exactDot := by simp [TensorCore.exactDot, hx]
  have hd : TensorCore.value32 D = some t.output.value := by
    unfold finite32 at hD
    split at hD
    · contradiction
    · rename_i d hd
      have hv := congrArg Finite32.value (Option.some.inj hD)
      simpa [TensorCore.value32, hd, Finite32.value] using congrArg some hv
  obtain ⟨r, hr, hb⟩ := algorithm1_correct hlen hs hd
  rw [hr, Except.map, hb, algorithm1_bits_eq_round]
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.algorithm1_bits_eq_round](../Encoded.md#decl-ff78455708a6f933), [TensorCore.prepareEncodedEFT_spec](../Encoded.md#decl-926dcc55d35ecae9)

**Definitions and types:** [TensorCore.Algorithm1Result.bits](../Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](../Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Error](../Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](../Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](../Bounded.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](../Bounded.md#decl-67eeb0773e124575), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.prepare](../../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](../Encoded.md#decl-aaaf1649ccd95844), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891)

</details>

</details>

<a id="decl-9aa1f0996a70d891"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_of_evalBlock</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Refinement.lean#L27)

```lean
/-- Conforming model outputs are a corollary, rather than an execution dependency. -/
theorem algorithm1_of_evalBlock {path : Path} {x : BlockInput path.profile} {t : BlockTrace}
    (ht : evalBlock x = .ok t) :
    (algorithm1 path x t.output.bits).map Result.bits = .ok t.algorithm1.bits :=
  algorithm1_agrees (prepareEncodedEFT_of_evalBlock ht)
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.prepareEncodedEFT_of_evalBlock](../Encoded.md#decl-fc4f7a305fbbcda5)

**Definitions and types:** [TensorCore.Algorithm1Result.bits](../Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](../Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EFMachine.Error](../Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](../Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](../Bounded.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](../Bounded.md#decl-67eeb0773e124575), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
