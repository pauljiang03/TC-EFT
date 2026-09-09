# TensorCore.TC.Program.Bounds.Loops

[Index](../../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-24743b1b0c722725"></a>

<details>
<summary><code>TensorCore.repeatList_length</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Loops.lean#L8)

```lean
theorem repeatList_length (xs : List α) (n : ℕ) : (repeatList xs n).length = n * xs.length := by
  induction n with
  | zero => simp [repeatList]
  | succ n ih => simp [repeatList, ih, Nat.succ_mul, Nat.add_comm]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.repeatList](../Defs.md#decl-eb2acff2f837428b)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_accurate_of_scales](Loops.md#decl-428a5fa42c1f272b)

</details>

</details>

<a id="decl-65c47eca9cfd9bef"></a>

<details>
<summary><code>TensorCore.mem_of_mem_repeatList</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Loops.lean#L13)

```lean
theorem mem_of_mem_repeatList (xs : List α) (n : ℕ) (x : α)
    (h : x ∈ repeatList xs n) : x ∈ xs := by
  induction n with
  | zero => simp [repeatList] at h
  | succ n ih =>
    simp only [repeatList, List.mem_append] at h
    exact h.elim id ih
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.repeatList](../Defs.md#decl-eb2acff2f837428b)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_accurate_of_scales](Loops.md#decl-428a5fa42c1f272b)

</details>

</details>

<a id="decl-1a60f53bc1fc3642"></a>

<details>
<summary><code>TensorCore.Program.accurate_of_scales</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Loops.lean#L22)

```lean
/-- An input-scale certificate for arbitrary programs, without concrete ideal prefixes. -/
theorem Program.accurate_of_scales {p : Profile} (pr : Program p) (E P : ℤ) (L : ℕ)
    (hE : -126 ≤ E) (hPE : P ≤ E) (hfl : ∀ f ∈ p.alignFloor, f ≤ E)
    (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (hscale : ∀ g ∈ pr.inputs, GroupScaleBounded p g P) (initial : Finite32) (C tolerance : ℚ)
    (hC : absQ initial.value ≤ C)
    (hroom : C + (pr.inputs.length : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1))
    (htol : pr.staticErrorBudget E L ≤ tolerance) : pr.Accurate initial.bits tolerance := by
  have hshape : ∀ g ∈ pr.inputs, g.length = p.products := by
    intro g hg
    obtain ⟨call, _, rfl⟩ := List.mem_map.mp hg
    exact call.operands.shape
  obtain ⟨ts, products, hr, hi, he⟩ := runBlocks_of_scale_bound p E P L hE hPE hfl hL hrange
    pr.inputs hshape hscale initial C hC hroom
  exact pr.accurate_of_run initial ts products tolerance hr hi (Rat.le_trans he htol)
```

**Supporting proofs:** [TensorCore.Program.accurate_of_run](../CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.runBlocks_of_scale_bound](Scales.md#decl-c2c004c589ff0bb6)

**Definitions and types:** [TensorCore.BlockOperands](../Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../../Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupScaleBounded](../../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.LocatedBlock](../Defs.md#decl-36cafa797c1bf521), [TensorCore.ModelError](../../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](../Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Accurate](../CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.blocks](../Defs.md#decl-e6562fd402604610), [TensorCore.Program.inputs](../Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.staticErrorBudget](../CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](../Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](../Composition.md#decl-59a9e0884980f32b), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.runBlocks](../Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](../../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_accurate_of_scales](Loops.md#decl-428a5fa42c1f272b), [TensorCore.boundedDot_accurate](../../Examples/BoundedDot.md#decl-5f4a54e532e0f3b9)

</details>

</details>

<a id="decl-428a5fa42c1f272b"></a>

<details>
<summary><code>TensorCore.Program.repeat_accurate_of_scales</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Loops.lean#L41)

```lean
/-- Repetition with a changing rounded accumulator and accumulated error. All iterations
are covered by induction from operand bounds; the body need not restore its initial state. -/
theorem Program.repeat_accurate_of_scales {p : Profile} (body : Program p) (n : ℕ)
    (E P : ℤ) (L : ℕ) (hE : -126 ≤ E) (hPE : P ≤ E)
    (hfl : ∀ f ∈ p.alignFloor, f ≤ E) (hL : p.products + 1 ≤ 2 ^ L)
    (hrange : E + 2 + L ≤ 127) (hscale : ∀ g ∈ body.inputs, GroupScaleBounded p g P)
    (initial : Finite32) (C tolerance : ℚ) (hC : absQ initial.value ≤ C)
    (hroom : C + ((n * body.inputs.length : ℕ) : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1))
    (htol : ((n * body.inputs.length : ℕ) : ℚ) *
      staticBudget (p.products + 1) p.alignFraction E L ≤ tolerance) :
    (Program.repeat n body).Accurate initial.bits tolerance := by
  apply Program.accurate_of_scales _ E P L hE hPE hfl hL hrange
  · intro g hg
    rw [Program.inputs_repeat] at hg
    exact hscale g (mem_of_mem_repeatList body.inputs n g hg)
  · exact hC
  · simpa only [Program.inputs_repeat, repeatList_length] using hroom
  · simpa only [Program.staticErrorBudget, Program.inputs_repeat, repeatList_length] using htol
```

**Supporting proofs:** [TensorCore.Program.accurate_of_scales](Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.inputs_repeat](../Loops.md#decl-7697e13eef655896), [TensorCore.mem_of_mem_repeatList](Loops.md#decl-65c47eca9cfd9bef), [TensorCore.repeatList_length](Loops.md#decl-24743b1b0c722725)

**Definitions and types:** [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupScaleBounded](../../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](../Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Accurate](../CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.inputs](../Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.staticErrorBudget](../CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.repeatList](../Defs.md#decl-eb2acff2f837428b), [TensorCore.staticBudget](../../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.small_repeat_accurate](../../Examples/BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>
