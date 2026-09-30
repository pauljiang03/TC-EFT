# TensorCore.TC.FusedRounding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-818649bb83af8ab6"></a>

<details>
<summary><code>TensorCore.binary64Fma_correct</code></summary>

[Lean source](../../../TensorCore/TC/FusedRounding.lean#L10)

```lean
/-- Accepted FP64 DMMA arithmetic is correctly rounded in each of the four modes,
with the original-input ideal and the output sign made explicit. -/
theorem binary64Fma_correct {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) :
    invocationIdeal x = some t.intermediate.value ∧
    BinaryRoundSpec fp64 mode t.intermediate.value t.output.bits ∧
    binarySign fp64 t.output.bits = decide (t.intermediate.value < 0) := by
  have hout := evalInvocation_output h
  obtain ⟨b, hb, hc⟩ := roundBinary_correct fp64 (by decide) mode t.intermediate.value hout.2
  have heq := Option.some.inj (hb.symm.trans hout.1)
  rw [heq] at hc
  exact ⟨binary64Fma_exact_input h, hc, roundBinary_sign fp64 mode _ _ hout.1⟩
```

**Supporting proofs:** [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.roundBinary_correct](../Numerics/Binary/RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_sign](../Numerics/Binary/RoundingContract.md#decl-89538250b2c31eac)

**Definitions and types:** [TensorCore.BinaryRoundSpec](../Numerics/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.binarySign](../Numerics/Binary/Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b369329edfc5a2cd"></a>

<details>
<summary><code>TensorCore.binary64Fma_success</code></summary>

[Lean source](../../../TensorCore/TC/FusedRounding.lean#L24)

```lean
/-- Finite decoded inputs of the required one-product shape succeed whenever their
exact fused result is in range; no intermediate-product range bound is imposed. -/
theorem binary64Fma_success (mode : BinaryRoundingMode) (x : InvocationInput (binary64Fma mode))
    (b : PreparedInvocation (binary64Fma mode)) (hp : prepareInvocation x = some b)
    (hn : x.products.length = 1) (hr : absQ b.exactDot ≤ fp64.maxFinite) :
    ∃ t, evalInvocation x = .ok t := by
  unfold binary64Fma at *
  obtain ⟨bits, hb, hc⟩ := roundBinary_correct fp64 (by decide) mode b.exactDot hr
  obtain ⟨d, hd⟩ := hc.finite
  have hconv : (ConversionStage.mk fp64 mode).convert b.exactDot =
      some ⟨bits, d, hd⟩ := by
    simp only [ConversionStage.convert, hb]
    exact finiteBinary_some hd
  have hv : (binary64Fma mode).Valid := by cases mode <;> decide +kernel
  unfold evalInvocation
  rw [if_neg (fun h => h hv), if_neg (by simp [hn]), hp]
  simp only [evalInvocationPrepared, accumulateInvocation, runConversions]
  rw [hconv]
  exact ⟨_, rfl⟩
```

**Supporting proofs:** [TensorCore.BinaryRoundSpec.finite](../Numerics/Binary/RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.finiteBinary_some](../Numerics/Conversion.md#decl-66e4132ec74cac83), [TensorCore.roundBinary_correct](../Numerics/Binary/RoundingContract.md#decl-12a22af180d3ad5e)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundSpec](../Numerics/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.Classification.finite](../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionEvent](../Numerics/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.classify](../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.finiteBinary](../Numerics/Conversion.md#decl-4947fce7ecea0c20), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
