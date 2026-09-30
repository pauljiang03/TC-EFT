# TensorCore.TC.Specification.Composition

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-eaffa3538905399a"></a>

<details>
<summary><code>TensorCore.PaperSpec.runBlocks_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Composition.lean#L10)

```lean
/-- All encoded intermediate outputs, and failures, agree for every finite schedule. -/
theorem runBlocks_eq_paper (p : Profile) (c : F32) (groups : List (List (p.Word × p.Word))) :
    (runBlocks p c groups).toOption.map (fun ts => ts.map fun t => t.output.bits) =
      runGroups (parametersOf p) c groups := by
  induction groups generalizing c with
  | nil => rfl
  | cons group rest ih =>
    have hb := implementation_eq_paper (⟨group, c⟩ : BlockInput p)
    change (evalBlock (⟨group, c⟩ : BlockInput p)).toOption.map (fun t => t.output.bits) =
      bits (parametersOf p) ⟨group, c⟩ at hb
    simp only [runGroups, ← hb]
    cases he : evalBlock (⟨group, c⟩ : BlockInput p) with
    | error e => simp [runBlocks, he, Except.toOption]
    | ok t =>
      have hr := ih t.output.bits
      cases ht : runBlocks p t.output.bits rest with
      | error e => simp [runBlocks, he, ht, Except.toOption] at hr ⊢; rw [← hr]; rfl
      | ok ts => simp [runBlocks, he, ht, Except.toOption] at hr ⊢; rw [← hr]; rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.runBlocks](../Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.schedule_last_eq_paper](Composition.md#decl-551846c5cac8f668)

</details>

</details>

<a id="decl-551846c5cac8f668"></a>

<details>
<summary><code>TensorCore.PaperSpec.schedule_last_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Composition.lean#L29)

```lean
/-- Projection of the preceding stronger theorem to just the final output bits. -/
theorem schedule_last_eq_paper (p : Profile) (c : F32)
    (groups : List (List (p.Word × p.Word))) :
    (runBlocks p c groups).toOption.map (fun ts =>
      (ts.map fun t => t.output.bits).getLast?.getD c) =
      lastBits (parametersOf p) c groups := by
  unfold lastBits
  rw [← runBlocks_eq_paper]
  simp only [Option.map_map]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.lastBits](Schedule.md#decl-3bc0435f1504df60), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.runBlocks](../Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.group_reversal_detected](../../Tests/Specification/NegativeControls.md#decl-34343729ff830b30)

</details>

</details>
