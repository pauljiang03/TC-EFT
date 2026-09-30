# TensorCore.TC.Correction

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ee6543cdd6791a37"></a>

<details>
<summary><code>TensorCore.corrected_correct</code></summary>

[Lean source](../../../TensorCore/TC/Correction.lean#L9)

```lean
/-- Exact residual recovery followed by mathematically nearest-even FP32 conversion. -/
theorem corrected_correct (t : BlockTrace) (hr : absQ t.block.exactDot ≤ maxFinite32) :
    ∃ b, t.corrected = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [corrected_eq_round_exactDot]
  exact round32_nearestEven_correct _ hr
```

**Supporting proofs:** [TensorCore.corrected_eq_round_exactDot](StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.round32_nearestEven_correct](../Numerics/CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](Block.md#decl-f68123201009b874), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398)

</details>

</details>

<a id="decl-ef83bbb5f9a12398"></a>

<details>
<summary><code>TensorCore.evalBlock_corrected_correct</code></summary>

[Lean source](../../../TensorCore/TC/Correction.lean#L15)

```lean
/-- Correct rounding of the independently defined ideal encoded-input sum. -/
theorem evalBlock_corrected_correct {p : Profile} {x : BlockInput p} {t : BlockTrace}
    {z : ℚ} (h : evalBlock x = .ok t) (hz : exactDot x = some z)
    (hr : absQ z ≤ maxFinite32) :
    ∃ b, t.corrected = some b ∧ NearestEven32 z b := by
  simp only [exactDot, evalBlock_prepared h, Option.map_some] at hz
  have he := Option.some.inj hz
  rw [← he] at hr ⊢
  exact corrected_correct t hr
```

**Supporting proofs:** [TensorCore.corrected_correct](Correction.md#decl-ee6543cdd6791a37), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](Block.md#decl-f68123201009b874), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-dd85a41a20883c51"></a>

<details>
<summary><code>TensorCore.recoveredSchedule</code></summary>

[Lean source](../../../TensorCore/TC/Correction.lean#L24)

```lean
def recoveredSchedule (initial : Finite32) (ts : List BlockTrace) : ℚ :=
  (lastOutput initial ts).value + sumQ (ts.map BlockTrace.residual)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294)

</details>

</details>

<a id="decl-968ff850f4220ec9"></a>

<details>
<summary><code>TensorCore.correctedSchedule</code></summary>

[Lean source](../../../TensorCore/TC/Correction.lean#L27)

```lean
def correctedSchedule (initial : Finite32) (ts : List BlockTrace) : Option F32 :=
  round32 .nearestEven (recoveredSchedule initial ts)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.twoBlockCorrection](../Tests/TC/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5)

</details>

</details>

<a id="decl-c5490d1a25901294"></a>

<details>
<summary><code>TensorCore.correctedSchedule_correct</code></summary>

[Lean source](../../../TensorCore/TC/Correction.lean#L31)

```lean
/-- The exact ledger is consolidated before the single final conversion. -/
theorem correctedSchedule_correct (initial : Finite32) (ts : List BlockTrace)
    (chain : EncodedChain initial ts)
    (hr : absQ (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) ≤ maxFinite32) :
    ∃ b, correctedSchedule initial ts = some b ∧
      NearestEven32 (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) b := by
  unfold correctedSchedule recoveredSchedule
  rw [← encoded_trace_ledger initial ts chain]
  exact round32_nearestEven_correct _ hr
```

**Supporting proofs:** [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.round32_nearestEven_correct](../Numerics/CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.EncodedChain](Composition.md#decl-ce41b49b9dd434c2), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5)

</details>

</details>

<a id="decl-5c2f929f60e023e5"></a>

<details>
<summary><code>TensorCore.runBlocks_corrected_correct</code></summary>

[Lean source](../../../TensorCore/TC/Correction.lean#L43)

```lean
/-- Every successful executable schedule has a correctly rounded correction when
its exact ideal sum is in the specified finite range. Each intermediate model
call must succeed separately; a finite final sum cannot repair a failed call. -/
theorem runBlocks_corrected_correct (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p initial.bits ps = .ok ts)
    (hr : absQ (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) ≤ maxFinite32) :
    ∃ b, correctedSchedule initial ts = some b ∧
      NearestEven32 (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) b :=
  correctedSchedule_correct initial ts (runBlocks_chain p initial ps ts h) hr
```

**Supporting proofs:** [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
