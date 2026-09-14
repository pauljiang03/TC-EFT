# TensorCore.TC.Program.Loops

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-38277dabea23ed23"></a>

<details>
<summary><code>TensorCore.lastOutput_append</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L7)

```lean
theorem lastOutput_append (initial : Finite32) (xs ys : List BlockTrace) :
    lastOutput initial (xs ++ ys) = lastOutput (lastOutput initial xs) ys := by
  induction xs generalizing initial with
  | nil => rfl
  | cons t ts ih => exact ih t.output
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_repeat_invariant](Loops.md#decl-e3ab49fcf2fa1da9)

</details>

</details>

<a id="decl-2442f227fffe5cf3"></a>

<details>
<summary><code>TensorCore.runBlocks_append</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L13)

```lean
theorem runBlocks_append (p : Profile) (initial : Finite32)
    (xs ys : List (List (p.Word × p.Word))) (ts us : List BlockTrace)
    (hx : runBlocks p initial.bits xs = .ok ts)
    (hy : runBlocks p (lastOutput initial ts).bits ys = .ok us) :
    runBlocks p initial.bits (xs ++ ys) = .ok (ts ++ us) := by
  induction xs generalizing initial ts with
  | nil => simp [runBlocks] at hx; cases hx; exact hy
  | cons x xs ih =>
    cases he : evalBlock (p := p) ⟨x, initial.bits⟩ with
    | error e => simp [runBlocks, he] at hx
    | ok t =>
      cases hr : runBlocks p t.output.bits xs with
      | error e => simp [runBlocks, he, hr] at hx
      | ok rest =>
        simp [runBlocks, he, hr] at hx
        cases hx
        have hi := ih t.output rest hr hy
        simp [runBlocks, he, hi]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_repeat_invariant](Loops.md#decl-e3ab49fcf2fa1da9), [TensorCore.runGemmInstructions_blocks](../../Gemm/Defs.md#decl-eb60bf287a9ae3b9)

</details>

</details>

<a id="decl-df22b932498a9118"></a>

<details>
<summary><code>TensorCore.map_repeatList</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L32)

```lean
theorem map_repeatList (f : α → β) (xs : List α) (n : ℕ) :
    (repeatList xs n).map f = repeatList (xs.map f) n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [repeatList, ih]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.repeatList](Defs.md#decl-eb2acff2f837428b)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22)

</details>

</details>

<a id="decl-7697e13eef655896"></a>

<details>
<summary><code>TensorCore.Program.inputs_repeat</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L38)

```lean
theorem Program.inputs_repeat {p : Profile} (body : Program p) (n : ℕ) :
    (Program.repeat n body).inputs = repeatList body.inputs n :=
  map_repeatList _ _ n
```

**Supporting proofs:** [TensorCore.map_repeatList](Loops.md#decl-df22b932498a9118)

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.repeatList](Defs.md#decl-eb2acff2f837428b)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_accurate_of_scales](Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22)

</details>

</details>

<a id="decl-e3ab49fcf2fa1da9"></a>

<details>
<summary><code>TensorCore.runBlocks_repeat_invariant</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L44)

```lean
/-- A reusable loop invariant: one body returns the exact same encoded state.
Induction handles arbitrary n; the theorem does not enumerate a chosen bound. -/
theorem runBlocks_repeat_invariant (p : Profile) (initial : Finite32)
    (body : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (hbody : runBlocks p initial.bits body = .ok ts)
    (hstate : lastOutput initial ts = initial) (n : ℕ) :
    runBlocks p initial.bits (repeatList body n) = .ok (repeatList ts n) ∧
    lastOutput initial (repeatList ts n) = initial := by
  induction n with
  | zero => exact ⟨rfl, rfl⟩
  | succ n ih =>
    constructor
    · exact runBlocks_append p initial body (repeatList body n) ts (repeatList ts n)
        hbody (by simpa [hstate] using ih.1)
    · change lastOutput initial (ts ++ repeatList ts n) = initial
      rw [lastOutput_append, hstate]; exact ih.2
```

**Supporting proofs:** [TensorCore.lastOutput_append](Loops.md#decl-38277dabea23ed23), [TensorCore.runBlocks_append](Loops.md#decl-2442f227fffe5cf3)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.repeatList](Defs.md#decl-eb2acff2f837428b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22)

</details>

</details>

<a id="decl-474827c336526185"></a>

<details>
<summary><code>TensorCore.sumQ_append</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L59)

```lean
theorem sumQ_append (xs ys : List ℚ) : sumQ (xs ++ ys) = sumQ xs + sumQ ys := by
  induction xs with
  | nil => simp only [List.nil_append, sumQ]; grind
  | cons x xs ih => simp only [List.cons_append, sumQ, ih]; grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.idealProducts_append](DotProduct.md#decl-623f08595b227aca), [TensorCore.sumQ_repeatList_zero](Loops.md#decl-1a78835f34f88e04)

</details>

</details>

<a id="decl-1a78835f34f88e04"></a>

<details>
<summary><code>TensorCore.sumQ_repeatList_zero</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L64)

```lean
theorem sumQ_repeatList_zero (xs : List ℚ) (hx : sumQ xs = 0) (n : ℕ) :
    sumQ (repeatList xs n) = 0 := by
  induction n with
  | zero => rfl
  | succ n ih => rw [repeatList, sumQ_append, hx, ih]; grind
```

**Supporting proofs:** [TensorCore.sumQ_append](Loops.md#decl-474827c336526185)

**Definitions and types:** [TensorCore.repeatList](Defs.md#decl-eb2acff2f837428b), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22)

</details>

</details>

<a id="decl-4f3792d4e823ab22"></a>

<details>
<summary><code>TensorCore.Program.repeat_vc_of_cycle</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Loops.lean#L72)

```lean
/-- A checked body with a zero ledger and an unchanged encoded state can be
repeated any finite number of times without new scalar or range assumptions. -/
theorem Program.repeat_vc_of_cycle {p : Profile} (body : Program p) (initial : Finite32)
    (ts : List BlockTrace) (hfinite : finite32 initial.bits = some initial)
    (hbody : body.run initial.bits = .ok ts) (hstate : lastOutput initial ts = initial)
    (hloss : sumQ (ts.map BlockTrace.residual) = 0)
    (hrange : absQ initial.value ≤ maxFinite32) (n : ℕ) :
    (Program.repeat n body).VC initial.bits := by
  have hi := runBlocks_repeat_invariant p initial body.inputs ts hbody hstate n
  have he : (Program.repeat n body).run initial.bits = .ok (repeatList ts n) := by
    simpa [Program.run, Program.inputs_repeat] using hi.1
  have hl : sumQ ((repeatList ts n).map BlockTrace.residual) = 0 := by
    rw [map_repeatList]; exact sumQ_repeatList_zero _ hloss n
  unfold Program.VC
  rw [hfinite, he]
  change absQ ((lastOutput initial (repeatList ts n)).value +
    sumQ ((repeatList ts n).map BlockTrace.residual)) ≤ maxFinite32
  rw [hi.2, hl]
  have hz : initial.value + 0 = initial.value := by grind
  rw [hz]; exact hrange
```

**Supporting proofs:** [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.map_repeatList](Loops.md#decl-df22b932498a9118), [TensorCore.runBlocks_repeat_invariant](Loops.md#decl-e3ab49fcf2fa1da9), [TensorCore.sumQ_repeatList_zero](Loops.md#decl-1a78835f34f88e04)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.VC](Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.repeatList](Defs.md#decl-eb2acff2f837428b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.symbolic_cycle_vc](../Regression/Programs.md#decl-5719553e703a7aad)

</details>

</details>
