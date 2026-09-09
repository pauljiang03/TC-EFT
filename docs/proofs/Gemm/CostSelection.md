# TensorCore.Gemm.CostSelection

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5de9fb85f5a10c26"></a>

<details>
<summary><code>TensorCore.selectMinimumCost</code></summary>

[Lean source](../../../TensorCore/Gemm/CostSelection.lean#L8)

```lean
def selectMinimumCost (check : α → Bool) (cost : α → ℚ) (candidates : List α) : Option α :=
  (candidates.filter check).minOn? cost
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.selectGemmCost](CostSelection.md#decl-11498eca158bf117), [TensorCore.selectMinimumCost_sound](CostSelection.md#decl-99ecb013d7634ef8)

</details>

</details>

<a id="decl-99ecb013d7634ef8"></a>

<details>
<summary><code>TensorCore.selectMinimumCost_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/CostSelection.lean#L11)

```lean
theorem selectMinimumCost_sound (check : α → Bool) (cost : α → ℚ) (candidates : List α)
    (chosen : α) (h : selectMinimumCost check cost candidates = some chosen) :
    chosen ∈ candidates ∧ check chosen = true ∧
      ∀ c ∈ candidates, check c = true → cost chosen ≤ cost c := by
  have hm := List.minOn?_mem h
  have hc := List.mem_filter.mp hm
  refine ⟨hc.1, hc.2, ?_⟩
  intro c hmem hcheck
  have hh := List.apply_get_minOn?_le_of_mem (f := cost) (List.mem_filter.mpr ⟨hmem, hcheck⟩)
  change (candidates.filter check).minOn? cost = some chosen at h
  simpa [h] using hh
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.selectMinimumCost](CostSelection.md#decl-5de9fb85f5a10c26)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e)

</details>

</details>

<a id="decl-9ac085fec2b9defd"></a>

<details>
<summary><code>TensorCore.CostedCandidate</code></summary>

[Lean source](../../../TensorCore/Gemm/CostSelection.lean#L23)

```lean
structure CostedCandidate where
  configuration : GemmCandidate
  cost : ℚ
  index : ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Regression.NativeScaled.candidates](Regression/NativeScaledGemm.md#decl-bc91542b4d9b5ae6), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.ReviewClaims.chosen](Regression/ReviewClaims.md#decl-faca76b37ee54430), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](Regression/ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.chosen_decision](Regression/ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.Regression.minimum_cost_skips_uncertified](Regression/DecisionExtensions.md#decl-b69d2d7611c1550d), [TensorCore.Regression.minimum_cost_ties](Regression/DecisionExtensions.md#decl-8dfd56f09e57d26a), [TensorCore.Regression.pricedModels](Regression/DecisionExtensions.md#decl-bc632cc65faf1783), [TensorCore.selectGemmCost](CostSelection.md#decl-11498eca158bf117), [TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e)

</details>

</details>

<a id="decl-11498eca158bf117"></a>

<details>
<summary><code>TensorCore.selectGemmCost</code></summary>

[Lean source](../../../TensorCore/Gemm/CostSelection.lean#L29)

```lean
def selectGemmCost (p : GemmProblem m n k) (candidates : List CostedCandidate) (tol : ℚ) :
    Option CostedCandidate :=
  selectMinimumCost (fun c => candidateCertified p tol c.configuration) (·.cost) candidates
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CostedCandidate](CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.selectMinimumCost](CostSelection.md#decl-5de9fb85f5a10c26)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.ReviewClaims.chosen_decision](Regression/ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.Regression.minimum_cost_skips_uncertified](Regression/DecisionExtensions.md#decl-b69d2d7611c1550d), [TensorCore.Regression.minimum_cost_ties](Regression/DecisionExtensions.md#decl-8dfd56f09e57d26a), [TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e)

</details>

</details>

<a id="decl-aa59b068120a3e6e"></a>

<details>
<summary><code>TensorCore.selectGemmCost_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/CostSelection.lean#L33)

```lean
theorem selectGemmCost_sound (p : GemmProblem m n k) (candidates : List CostedCandidate)
    (tol : ℚ) (chosen : CostedCandidate) (h : selectGemmCost p candidates tol = some chosen) :
    chosen ∈ candidates ∧ p.Accurate chosen.configuration tol ∧
      ∀ c ∈ candidates, candidateCertified p tol c.configuration = true → chosen.cost ≤ c.cost := by
  obtain ⟨hm, hc, hmin⟩ := selectMinimumCost_sound _ _ candidates chosen h
  exact ⟨hm, candidateCertified_sound p tol chosen.configuration hc, hmin⟩
```

**Supporting proofs:** [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b), [TensorCore.selectMinimumCost_sound](CostSelection.md#decl-99ecb013d7634ef8)

**Definitions and types:** [TensorCore.CostedCandidate](CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.selectGemmCost](CostSelection.md#decl-11498eca158bf117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](Regression/ReviewClaims.md#decl-48d32b8ae011d0c9)

</details>

</details>
