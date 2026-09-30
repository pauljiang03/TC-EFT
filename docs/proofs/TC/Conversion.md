# TensorCore.TC.Conversion

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4ce2a113c3a79271"></a>

<details>
<summary><code>TensorCore.conversionStage_nearestEven_correct</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L13)

```lean
theorem conversionStage_nearestEven_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .nearestEven) (x : ℚ) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : NearestEven s.format x d.bits := by
  have hout := conversionStage_output h
  have hr := (conversionStage_range h).2
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_nearestEven_correct s.format hf x hr
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc
```

**Supporting proofs:** [TensorCore.conversionStage_output](../Numerics/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Numerics/Conversion.md#decl-9878d77fe9422846), [TensorCore.roundBinary_nearestEven_correct](../Numerics/Binary/CorrectRounding.md#decl-56aa49cf9819c893)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../Numerics/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a)

</details>

</details>

<a id="decl-21132c7fe11d05ea"></a>

<details>
<summary><code>TensorCore.conversionStage_towardZero_correct</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L24)

```lean
theorem conversionStage_towardZero_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .towardZero) (x : ℚ) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : TowardZero s.format x d.bits := by
  have hout := conversionStage_output h
  have hr := (conversionStage_range h).2
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardZero_correct s.format hf x hr
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc
```

**Supporting proofs:** [TensorCore.conversionStage_output](../Numerics/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Numerics/Conversion.md#decl-9878d77fe9422846), [TensorCore.roundBinary_towardZero_correct](../Numerics/Binary/CorrectRounding.md#decl-7cd93a19048f4025)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.TowardZero](../Numerics/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2)

</details>

</details>

<a id="decl-ba61a0c4e133bd9a"></a>

<details>
<summary><code>TensorCore.evalInvocation_output_nearestEven</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L37)

```lean
/-- The output of any accepted invocation with a nearest-even output stage is the nearest
value of the output format to the intermediate value, ties to even. -/
theorem evalInvocation_output_nearestEven {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .nearestEven) :
    NearestEven p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_nearestEven_correct p.output hv.2.2.2.1 hmode _ _ hout
```

**Supporting proofs:** [TensorCore.conversionStage_nearestEven_correct](Conversion.md#decl-4ce2a113c3a79271), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.NearestEven](../Numerics/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283)

</details>

</details>

<a id="decl-91e16db9cb9f47c2"></a>

<details>
<summary><code>TensorCore.evalInvocation_output_towardZero</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L43)

```lean
theorem evalInvocation_output_towardZero {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .towardZero) :
    TowardZero p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_towardZero_correct p.output hv.2.2.2.1 hmode _ _ hout
```

**Supporting proofs:** [TensorCore.conversionStage_towardZero_correct](Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.TowardZero](../Numerics/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e)

</details>

</details>

<a id="decl-d04a4eaaeb5ab283"></a>

<details>
<summary><code>TensorCore.binary64Fma_nearestEven</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L50)

```lean
/-- FP64 fused specification: one correctly rounded result in the stated direction. -/
theorem binary64Fma_nearestEven {x : InvocationInput (binary64Fma .nearestEven)}
    {t : InvocationTrace (binary64Fma .nearestEven)} (h : evalInvocation x = .ok t) :
    NearestEven fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_nearestEven h rfl
```

**Supporting proofs:** [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.NearestEven](../Numerics/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-73cb656a116a886e"></a>

<details>
<summary><code>TensorCore.binary64Fma_towardZero</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L55)

```lean
theorem binary64Fma_towardZero {x : InvocationInput (binary64Fma .towardZero)}
    {t : InvocationTrace (binary64Fma .towardZero)} (h : evalInvocation x = .ok t) :
    TowardZero fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardZero h rfl
```

**Supporting proofs:** [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.TowardZero](../Numerics/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-906d159df48d6e65"></a>

<details>
<summary><code>TensorCore.conversionStage_towardNegative_correct</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L60)

```lean
theorem conversionStage_towardNegative_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .towardNegative) (x : ℚ) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : TowardNegative s.format x d.bits := by
  have hout := conversionStage_output h
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardNegative_correct s.format hf x
    (conversionStage_range h).2
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc
```

**Supporting proofs:** [TensorCore.conversionStage_output](../Numerics/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Numerics/Conversion.md#decl-9878d77fe9422846), [TensorCore.roundBinary_towardNegative_correct](../Numerics/Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.TowardNegative](../Numerics/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247)

</details>

</details>

<a id="decl-e9bb1af6a9107993"></a>

<details>
<summary><code>TensorCore.conversionStage_towardPositive_correct</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L71)

```lean
theorem conversionStage_towardPositive_correct (s : ConversionStage) (hf : s.format.WellFormed)
    (hmode : s.mode = .towardPositive) (x : ℚ) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : TowardPositive s.format x d.bits := by
  have hout := conversionStage_output h
  rw [hmode] at hout
  obtain ⟨bits, hb, hc⟩ := roundBinary_towardPositive_correct s.format hf x
    (conversionStage_range h).2
  rw [hout] at hb
  cases Option.some.inj hb
  exact hc
```

**Supporting proofs:** [TensorCore.conversionStage_output](../Numerics/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Numerics/Conversion.md#decl-9878d77fe9422846), [TensorCore.roundBinary_towardPositive_correct](../Numerics/Binary/DirectedRounding.md#decl-a0d617c51646227e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.TowardPositive](../Numerics/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6)

</details>

</details>

<a id="decl-e2792a3384716247"></a>

<details>
<summary><code>TensorCore.evalInvocation_output_towardNegative</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L82)

```lean
theorem evalInvocation_output_towardNegative {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .towardNegative) :
    TowardNegative p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_towardNegative_correct p.output hv.2.2.2.1 hmode _ _ hout
```

**Supporting proofs:** [TensorCore.conversionStage_towardNegative_correct](Conversion.md#decl-906d159df48d6e65), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.TowardNegative](../Numerics/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975)

</details>

</details>

<a id="decl-4ddbb479bc9e21d6"></a>

<details>
<summary><code>TensorCore.evalInvocation_output_towardPositive</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L88)

```lean
theorem evalInvocation_output_towardPositive {p : InvocationSpec} {x : InvocationInput p}
    {t : InvocationTrace p} (h : evalInvocation x = .ok t) (hmode : p.output.mode = .towardPositive) :
    TowardPositive p.output.format t.intermediate.value t.output.bits := by
  obtain ⟨hv, _, _, _, _, hout⟩ := evalInvocation_spec h
  exact conversionStage_towardPositive_correct p.output hv.2.2.2.1 hmode _ _ hout
```

**Supporting proofs:** [TensorCore.conversionStage_towardPositive_correct](Conversion.md#decl-e9bb1af6a9107993), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.TowardPositive](../Numerics/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8)

</details>

</details>

<a id="decl-14d955da110e6975"></a>

<details>
<summary><code>TensorCore.binary64Fma_towardNegative</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L94)

```lean
theorem binary64Fma_towardNegative {x : InvocationInput (binary64Fma .towardNegative)}
    {t : InvocationTrace (binary64Fma .towardNegative)} (h : evalInvocation x = .ok t) :
    TowardNegative fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardNegative h rfl
```

**Supporting proofs:** [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.TowardNegative](../Numerics/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0c17a7e9421cc1e8"></a>

<details>
<summary><code>TensorCore.binary64Fma_towardPositive</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L99)

```lean
theorem binary64Fma_towardPositive {x : InvocationInput (binary64Fma .towardPositive)}
    {t : InvocationTrace (binary64Fma .towardPositive)} (h : evalInvocation x = .ok t) :
    TowardPositive fp64 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardPositive h rfl
```

**Supporting proofs:** [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.TowardPositive](../Numerics/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e9ea2eb0949990ef"></a>

<details>
<summary><code>TensorCore.binary64Fma_exact_input</code></summary>

[Lean source](../../../TensorCore/TC/Conversion.lean#L106)

```lean
/-- Fused FP64 rounds the independently decoded exact product plus accumulator;
there is no intermediate rounding. -/
theorem binary64Fma_exact_input {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) : invocationIdeal x = some t.intermediate.value := by
  obtain ⟨_, _, hp, ha, hr, _⟩ := evalInvocation_spec h
  simp only [accumulateInvocation, binary64Fma, Option.some.injEq] at ha
  simp only [binary64Fma, runConversions, Option.some.injEq] at hr
  simp only [invocationIdeal, hp, Option.map_some]
  rw [← hr, ← ha]
  rfl
```

**Supporting proofs:** [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionEvent](../Numerics/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6)

</details>

</details>
