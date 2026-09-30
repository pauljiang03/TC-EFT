# TensorCoreTests.TC.PublicDomains

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d277804bf4bb3c58"></a>

<details>
<summary><code>TensorCore.Regression.zero_product_canonical</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/PublicDomains.lean#L11)

```lean
theorem zero_product_canonical :
    invocationBits (p := fp16Fp32Invocation 0 0 none) ⟨[], 0x3f800000⟩ = some 0x3f800000 ∧
    invocationBits (p := fp16Fp32Invocation 0 2 (some (-133))) ⟨[], 1⟩ = some 1 ∧
    evalInvocation (p := fp16Fp32Invocation 0 0 none) ⟨[], 0x7fc00000⟩ =
      .error .nonfiniteOrInvalidEncoding ∧
    evalInvocation (p := fp16Fp32Invocation 0 0 none) ⟨[(0, 0)], 0⟩ =
      .error .wrongProductCount := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionEvent](../../Numerics/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](../../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](../../TC/Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](../../TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](../../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](../../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](../../TC/Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](../../Numerics/Format.md#decl-0e24771a882ef6eb), [TensorCore.PreparedInvocation](../../TC/Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalInvocation](../../TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp16Fp32Invocation](../../TC/CanonicalDefs.md#decl-9e7567381e18f7e6), [TensorCore.invocationBits](../../TC/Invocation.md#decl-c68ad16b896f3817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b03cee6d1c37cccb"></a>

<details>
<summary><code>TensorCore.Regression.fused_requires_one_product</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/PublicDomains.lean#L19)

```lean
theorem fused_requires_one_product :
    ¬ ({v100Invocation with products := 0, accumulation := .fused} : InvocationSpec).Valid ∧
    ¬ ({v100Invocation with products := 2, accumulation := .fused} : InvocationSpec).Valid := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](../../TC/Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](../../TC/Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationSpec](../../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](../../TC/Invocation.md#decl-ba647c851a0365a5), [TensorCore.OperandEncoding](../../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.ValueFormat](../../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.stagesValid](../../TC/Invocation.md#decl-e34cdc92870df2ae), [TensorCore.v100Invocation](../../TC/Invocation.md#decl-7a65a9f94124dc03)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bf3a494234874689"></a>

<details>
<summary><code>TensorCore.Regression.finite_range_converter_policy</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/PublicDomains.lean#L24)

```lean
theorem finite_range_converter_policy :
    round32 .towardZero (maxFinite32 + 1) = none ∧
    round32 .nearestEven (maxFinite32 + 1) = none ∧
    round32Core .towardZero (maxFinite32 + 1) = some 0x7f7fffff := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](../../Numerics/RoundOp.md#decl-a47adb12319758c3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
