# TensorCore.TC.Program.ErrorBounds

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-64924d5a9a13575c"></a>

<details>
<summary><code>TensorCore.BlockTrace.errorBudget</code></summary>

[Lean source](../../../../TensorCore/TC/Program/ErrorBounds.lean#L9)

```lean
/-- The local two-stage bound at the grids of an actual returned invocation. -/
def BlockTrace.errorBudget (t : BlockTrace) : ℚ :=
  (t.block.terms.length : ℚ) * pow2 t.block.quantumExponent +
    pow2 (outputQuantumExponent t.output.bits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock.quantumExponent](../Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.outputQuantumExponent](../../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.GemmCell.errorBudget](../../Gemm/Defs.md#decl-77bf8f0088e678b8), [TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Regression.partition_error_contract](../Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.static_certificate_consistent](../Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.evalBlock_residual_bound](ErrorBounds.md#decl-74198f50c769d497), [TensorCore.runBlocks_residual_budget](ErrorBounds.md#decl-cc967a2bb9a08415), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-74198f50c769d497"></a>

<details>
<summary><code>TensorCore.evalBlock_residual_bound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/ErrorBounds.lean#L13)

```lean
theorem evalBlock_residual_bound {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : absQ t.residual < t.errorBudget := by
  have hid := returned_residual_identity t
  have he : t.residual = t.block.exactDot - t.output.value := by grind
  rw [he]
  exact evalBlock_error_bound h
```

**Supporting proofs:** [TensorCore.evalBlock_error_bound](../ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.returned_residual_identity](../StageResiduals.md#decl-51c1f1398611023e)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactDot](../Block.md#decl-32d061749cae163e), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_residual_budget](ErrorBounds.md#decl-cc967a2bb9a08415)

</details>

</details>

<a id="decl-60cd89558816c4b8"></a>

<details>
<summary><code>TensorCore.runBlocks_length</code></summary>

[Lean source](../../../../TensorCore/TC/Program/ErrorBounds.lean#L20)

```lean
theorem runBlocks_length (p : Profile) (c : F32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p c ps = .ok ts) : ts.length = ps.length := by
  induction ps generalizing c ts with
  | nil => simp [runBlocks] at h; subst ts; rfl
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        subst ts
        simpa using ih t.output.bits rest hr
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d)

</details>

</details>

<a id="decl-cc967a2bb9a08415"></a>

<details>
<summary><code>TensorCore.runBlocks_residual_budget</code></summary>

[Lean source](../../../../TensorCore/TC/Program/ErrorBounds.lean#L37)

```lean
/-- Losses may cancel, but the sum of the local budgets always bounds their ledger. -/
theorem runBlocks_residual_budget (p : Profile) (c : F32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p c ps = .ok ts) :
    absQ (sumQ (ts.map BlockTrace.residual)) ≤ sumQ (ts.map BlockTrace.errorBudget) ∧
    (ts ≠ [] → absQ (sumQ (ts.map BlockTrace.residual)) < sumQ (ts.map BlockTrace.errorBudget)) := by
  induction ps generalizing c ts with
  | nil =>
    simp [runBlocks] at h
    subst ts
    constructor
    · change absQ 0 ≤ 0
      decide
    · intro hn
      exact False.elim (hn rfl)
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        subst ts
        have hx := evalBlock_residual_bound he
        have ht := (ih t.output.bits rest hr).1
        have hadd := absQ_add_le t.residual (sumQ (rest.map BlockTrace.residual))
        simp only [List.map_cons, sumQ]
        constructor <;> grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.evalBlock_residual_bound](ErrorBounds.md#decl-74198f50c769d497)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da)

</details>

</details>

<a id="decl-dc5609ec5819f2da"></a>

<details>
<summary><code>TensorCore.runBlocks_uncorrected_error</code></summary>

[Lean source](../../../../TensorCore/TC/Program/ErrorBounds.lean#L69)

```lean
/-- Uncorrected output error against original encoded operands, across every FP32
boundary. Only the actual intermediate calls must succeed; no final ideal-range
or correction/extraction condition is needed. -/
theorem runBlocks_uncorrected_error (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace) (products : ℚ)
    (h : runBlocks p initial.bits ps = .ok ts)
    (hi : idealContributions p ps = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) ∧
    (ps ≠ [] → absQ (initial.value + products - (lastOutput initial ts).value) <
      sumQ (ts.map BlockTrace.errorBudget)) := by
  have hid := runBlocks_idealContributions p initial.bits ps ts h
  rw [hi] at hid
  have hproducts := Option.some.inj hid
  have hledger := runBlocks_residual_ledger p initial ps ts h
  have he : initial.value + products - (lastOutput initial ts).value =
      sumQ (ts.map BlockTrace.residual) := by grind
  rw [he]
  have hb := runBlocks_residual_budget p initial.bits ps ts h
  refine ⟨hb.1, ?_⟩
  intro hps
  apply hb.2
  have hlen := runBlocks_length p initial.bits ps ts h
  intro hts
  subst ts
  have hp : ps = [] := List.length_eq_zero_iff.mp hlen.symm
  exact hps hp
```

**Supporting proofs:** [TensorCore.runBlocks_idealContributions](Defs.md#decl-a06c7915ecf4c91c), [TensorCore.runBlocks_length](ErrorBounds.md#decl-60cd89558816c4b8), [TensorCore.runBlocks_residual_budget](ErrorBounds.md#decl-cc967a2bb9a08415), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-eb2ba0b8cf65050e"></a>

<details>
<summary><code>TensorCore.Program.uncorrected_error</code></summary>

[Lean source](../../../../TensorCore/TC/Program/ErrorBounds.lean#L94)

```lean
theorem Program.uncorrected_error {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (ideal : ℚ) (h : pr.run initial.bits = .ok ts)
    (hi : pr.ideal initial.bits = some ideal) :
    absQ (ideal - (lastOutput initial ts).value) ≤ sumQ (ts.map BlockTrace.errorBudget) := by
  have hid := pr.recovery initial ts h
  rw [hi] at hid
  have hv := Option.some.inj hid
  have he : ideal - (lastOutput initial ts).value = sumQ (ts.map BlockTrace.residual) := by
    unfold recoveredSchedule at hv
    grind
  rw [he]
  exact (runBlocks_residual_budget p initial.bits pr.inputs ts h).1
```

**Supporting proofs:** [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.runBlocks_residual_budget](ErrorBounds.md#decl-cc967a2bb9a08415)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
