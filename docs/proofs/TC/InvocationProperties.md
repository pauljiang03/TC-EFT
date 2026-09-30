# TensorCore.TC.InvocationProperties

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f6828402db94c42c"></a>

<details>
<summary><code>TensorCore.aligned_recovery</code></summary>

[Lean source](../../../TensorCore/TC/InvocationProperties.lean#L8)

```lean
private theorem aligned_recovery (b : PreparedBlock) :
    b.exactDot = b.accumulator + sumQ b.alignmentResiduals := by
  have h := block_residual_identity b b.accumulator
  unfold PreparedBlock.extractReference at h
  grind
```

**Supporting proofs:** [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502)

</details>

</details>

<a id="decl-42509334ff62e502"></a>

<details>
<summary><code>TensorCore.accumulateInvocation_recovery</code></summary>

[Lean source](../../../TensorCore/TC/InvocationProperties.lean#L14)

```lean
theorem accumulateInvocation_recovery {p : InvocationSpec} (b : PreparedInvocation p)
    (a : LocalAccumulation) (h : accumulateInvocation b = some a) :
    b.exactDot = a.value + a.loss := by
  cases hk : p.accumulation with
  | fused =>
    simp [accumulateInvocation, hk] at h
    subst a
    simp [LocalAccumulation.loss, sumQ]
    grind
  | aligned F floor cp =>
    cases cp with
    | inGroup =>
      simp [accumulateInvocation, hk] at h
      subst a
      have hr := aligned_recovery (b.alignedBlock F floor true)
      change b.exactDot = (b.alignedBlock F floor true).accumulator +
        sumQ (b.alignedBlock F floor true).alignmentResiduals at hr
      simpa [LocalAccumulation.loss, sumQ, Rat.add_zero] using hr
    | afterProducts ss =>
      cases hc : runConversions ss (b.alignedBlock F floor false).accumulator with
      | none => simp [accumulateInvocation, hk, hc] at h
      | some r =>
        simp [accumulateInvocation, hk, hc] at h
        subst a
        have hr := aligned_recovery (b.alignedBlock F floor false)
        have hs := runConversions_recovery ss _ r hc
        have hz : (b.alignedBlock F floor false).exactDot = b.exactProducts := by
          simp [PreparedInvocation.alignedBlock, PreparedBlock.exactDot,
            PreparedBlock.exactProducts, PreparedInvocation.exactProducts, Decoded.value,
            Rat.zero_add]
        rw [hz] at hr
        unfold PreparedInvocation.exactDot LocalAccumulation.loss ConversionRun.loss at *
        grind
```

**Supporting proofs:** [TensorCore.runConversions_recovery](../Numerics/Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionEvent](../Numerics/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](../Numerics/Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](../Numerics/Conversion.md#decl-29f602efd8dc0504), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.LocalAccumulation.loss](Invocation.md#decl-68d84640e3352f8b), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.PreparedInvocation.exactProducts](Invocation.md#decl-f08483de5406c0c5), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-d12d00baae1cb453"></a>

<details>
<summary><code>TensorCore.evalInvocationPrepared_spec</code></summary>

[Lean source](../../../TensorCore/TC/InvocationProperties.lean#L48)

```lean
theorem evalInvocationPrepared_spec {p : InvocationSpec} {b : PreparedInvocation p}
    {t : InvocationTrace p} (h : evalInvocationPrepared b = .ok t) :
    t.prepared = b ∧ accumulateInvocation b = some t.accumulation ∧
    runConversions p.intermediate t.accumulation.value = some t.intermediate ∧
    p.output.convert t.intermediate.value = some t.output := by
  unfold evalInvocationPrepared at h
  cases ha : accumulateInvocation b with
  | none => simp [ha] at h
  | some a =>
    cases hr : runConversions p.intermediate a.value with
    | none => simp [ha, hr] at h
    | some r =>
      cases hd : p.output.convert r.value with
      | none => simp [ha, hr, hd] at h
      | some d =>
        simp [ha, hr, hd] at h
        subst t
        exact ⟨rfl, rfl, hr, hd⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

</details>

</details>

<a id="decl-cf70673e8284a3b5"></a>

<details>
<summary><code>TensorCore.evalInvocation_spec</code></summary>

[Lean source](../../../TensorCore/TC/InvocationProperties.lean#L68)

```lean
/-- Successful encoded evaluation certifies its parameters, shape, decoding, and stages. -/
theorem evalInvocation_spec {p : InvocationSpec} {x : InvocationInput p} {t : InvocationTrace p}
    (h : evalInvocation x = .ok t) :
    p.Valid ∧ x.products.length = p.products ∧ prepareInvocation x = some t.prepared ∧
    accumulateInvocation t.prepared = some t.accumulation ∧
    runConversions p.intermediate t.accumulation.value = some t.intermediate ∧
    p.output.convert t.intermediate.value = some t.output := by
  unfold evalInvocation at h
  split at h
  · simp at h
  · rename_i hv
    split at h
    · simp at h
    · rename_i hs
      cases hp : prepareInvocation x with
      | none => simp [hp] at h
      | some b =>
        simp only [hp] at h
        have ht := evalInvocationPrepared_spec h
        refine ⟨by grind, by simpa using hs, ?_, ?_⟩
        · rw [ht.1]
        · simpa [ht.1] using ht.2
```

**Supporting proofs:** [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.ValueFormat](../Numerics/Format.md#decl-5fda6482ff1a70d2), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-137c91f57a77bdc9"></a>

<details>
<summary><code>TensorCore.evalInvocation_recovery</code></summary>

[Lean source](../../../TensorCore/TC/InvocationProperties.lean#L91)

```lean
/-- Original-bit ideal equals the actual returned value plus all local stage losses. -/
theorem evalInvocation_recovery {p : InvocationSpec} {x : InvocationInput p} {t : InvocationTrace p}
    (h : evalInvocation x = .ok t) :
    invocationIdeal x = some (t.output.value + t.residual) := by
  obtain ⟨_, _, hp, ha, hr, _⟩ := evalInvocation_spec h
  have hl := accumulateInvocation_recovery t.prepared t.accumulation ha
  have hc := runConversions_recovery p.intermediate t.accumulation.value t.intermediate hr
  simp only [invocationIdeal, hp, Option.map_some]
  congr 1
  unfold InvocationTrace.residual
  grind
```

**Supporting proofs:** [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.runConversions_recovery](../Numerics/Conversion.md#decl-9a595a0bbdd2a7fc)

**Definitions and types:** [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](../Numerics/Conversion.md#decl-29f602efd8dc0504), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Numerics/Conversion.md#decl-91103d704c4a7c32), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](Invocation.md#decl-c97ce73fb104bc58), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.LocalAccumulation.loss](Invocation.md#decl-68d84640e3352f8b), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c5356d6db12f1b4d"></a>

<details>
<summary><code>TensorCore.evalInvocation_output</code></summary>

[Lean source](../../../TensorCore/TC/InvocationProperties.lean#L103)

```lean
/-- The final output obeys the specified executable conversion, with its own range guard. -/
theorem evalInvocation_output {p : InvocationSpec} {x : InvocationInput p} {t : InvocationTrace p}
    (h : evalInvocation x = .ok t) :
    roundBinary p.output.format p.output.mode t.intermediate.value = some t.output.bits ∧
    absQ t.intermediate.value ≤ p.output.format.maxFinite := by
  have hs := (evalInvocation_spec h).2.2.2.2.2
  exact ⟨conversionStage_output hs, (conversionStage_range hs).2⟩
```

**Supporting proofs:** [TensorCore.conversionStage_output](../Numerics/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../Numerics/Conversion.md#decl-9878d77fe9422846), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.ConversionRun](../Numerics/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Numerics/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Numerics/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.roundBinary](../Numerics/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.runConversions](../Numerics/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6)

</details>

</details>
