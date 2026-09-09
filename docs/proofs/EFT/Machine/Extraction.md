# TensorCore.EFT.Machine.Extraction

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a3c7a5b9369e689d"></a>

<details>
<summary><code>TensorCore.EFMachine.split_budget</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Extraction.lean#L10)

```lean
/-- Both extracted lists fit within the original absolute coefficient budget. -/
theorem split_budget (ts : List Term) (g : Grid) :
    wordBudget ((ts.map fun t => t.word.split g).map WordSplit.coarse) ≤
      wordBudget (ts.map Term.word) ∧
    wordBudget ((ts.map fun t => t.word.split g).map WordSplit.low) ≤
      wordBudget (ts.map Term.word) := by
  induction ts with
  | nil => simp [wordBudget]
  | cons t ts ih =>
    have hs := t.word.split_magnitude g
    simp only [List.map_cons, wordBudget, List.sum_cons] at *
    omega
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.wordBudget](Word.md#decl-0632d0aa311c3d92)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f)

</details>

</details>

<a id="decl-877b6b47e30b3bf0"></a>

<details>
<summary><code>TensorCore.EFMachine.split_sum</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Extraction.lean#L22)

```lean
theorem split_sum (ts : List Term) (g : Grid) :
    sumQ (((ts.map fun t => t.word.split g).map WordSplit.coarse).map Word.value) +
      sumQ (((ts.map fun t => t.word.split g).map WordSplit.low).map Word.value) =
      sumQ (ts.map fun t => t.word.value) := by
  induction ts with
  | nil => simp [sumQ, Rat.zero_add]
  | cons t ts ih =>
    have hs := t.word.split_reconstruct g
    simp only [List.map_cons, sumQ]
    grind [Rat.add_assoc, Rat.add_comm]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e)

</details>

</details>

<a id="decl-a81bbb5141b0c42f"></a>

<details>
<summary><code>TensorCore.EFMachine.extract_exists</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Extraction.lean#L35)

```lean
/-- Capacity comes from decoded inputs, including cancellation between products
far outside FP32. No representability assumption on an intermediate sum is used. -/
theorem extract_exists {p : Prepared}
    (hp : wordBudget (p.terms.map Term.word) < 2 ^ 555)
    (hd : p.output.magnitude.toNat < 2 ^ 424) : ∃ c, extract p = some c := by
  let hi := (p.terms.map fun t => t.word.split p.grid).map WordSplit.coarse
  let lo := (p.terms.map fun t => t.word.split p.grid).map WordSplit.low
  have hb := split_budget p.terms p.grid
  have hhi : wordBudget hi < 2 ^ 555 := by dsimp [hi]; omega
  have hlo : wordBudget lo < 2 ^ 555 := by dsimp [lo]; omega
  obtain ⟨h, hh, hmh⟩ := sumWords_exists hi (by omega)
  obtain ⟨o, ho⟩ := p.output.add_exists h.neg (by change _ + h.magnitude.toNat < _; omega)
  have hmo := Word.add_magnitude ho
  change o.magnitude.toNat ≤ p.output.magnitude.toNat + h.magnitude.toNat at hmo
  obtain ⟨e, he, hme⟩ := sumWords_exists lo (by omega)
  obtain ⟨d, hdd⟩ := p.output.add_exists o.neg (by change _ + o.magnitude.toNat < _; omega)
  have hmd := Word.add_magnitude hdd
  change d.magnitude.toNat ≤ p.output.magnitude.toNat + o.magnitude.toNat at hmd
  obtain ⟨s, hs⟩ := d.add_exists e (by omega)
  exact ⟨⟨p, hi, lo, h, o, e, s⟩, by
    dsimp only [hi] at hh
    dsimp only [lo] at he
    simp [-List.map_map, extract, hi, lo, Word.sub, hh, ho, he, hdd, hs]⟩
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2), [TensorCore.EFMachine.Word.add_magnitude](Word.md#decl-53b494a56c2c7d9a), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0)

**Definitions and types:** [TensorCore.EFMachine.Components](../Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Prepared](../Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.extract](../Bounded.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.EFMachine.wordBudget](Word.md#decl-0632d0aa311c3d92)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94)

</details>

</details>

<a id="decl-faa78874821acf9e"></a>

<details>
<summary><code>TensorCore.EFMachine.extract_spec</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Extraction.lean#L59)

```lean
/-- The complete signed extraction identity. In particular the overlap is D-H;
its sign includes the output truncation residual when the two grids coincide. -/
theorem extract_spec {p : Prepared} {c : Components} (hc : extract p = some c) :
    c.prepared = p ∧
    c.coarse = (p.terms.map fun t => t.word.split p.grid).map WordSplit.coarse ∧
    c.low = (p.terms.map fun t => t.word.split p.grid).map WordSplit.low ∧
    c.retained.value = sumQ (c.coarse.map Word.value) ∧
    c.overlap.value = p.output.value - c.retained.value ∧
    c.residualSum.value = sumQ (c.low.map Word.value) ∧
    c.recovered.value = c.retained.value + c.residualSum.value ∧
    c.recovered.value = p.ideal := by
  unfold extract at hc
  dsimp only at hc
  cases hh : sumWords ((p.terms.map fun t => t.word.split p.grid).map WordSplit.coarse) with
  | none => simp [-List.map_map, hh] at hc
  | some h =>
    cases ho : p.output.sub h with
    | none => simp [-List.map_map, hh, ho] at hc
    | some o =>
      cases he : sumWords ((p.terms.map fun t => t.word.split p.grid).map WordSplit.low) with
      | none => simp [-List.map_map, hh, he] at hc
      | some e =>
        cases hd : p.output.sub o with
        | none => simp [-List.map_map, hh, ho, he, hd] at hc
        | some d =>
          cases hs : d.add e with
          | none => simp [-List.map_map, hh, ho, he, hd, hs] at hc
          | some s =>
            simp [-List.map_map, hh, ho, he, hd, hs] at hc
            subst c
            have hvh := sumWords_value hh
            have hvo := Word.sub_value ho
            have hve := sumWords_value he
            have hvd := Word.sub_value hd
            have hvs := Word.add_value hs
            have hsum := split_sum p.terms p.grid
            refine ⟨rfl, rfl, rfl, hvh, hvo, hve, ?_, ?_⟩
            · dsimp only; grind [Rat.sub_eq_add_neg]
            · dsimp only [Prepared.ideal]; grind [Rat.sub_eq_add_neg]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4)

**Definitions and types:** [TensorCore.EFMachine.Components](../Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Prepared](../Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.extract](../Bounded.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd)

</details>

</details>

<a id="decl-f7b97097f702b90a"></a>

<details>
<summary><code>TensorCore.EFMachine.extract_component</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Extraction.lean#L98)

```lean
/-- Each high component follows the paper's intended signed-magnitude truncation. -/
theorem extract_component (t : Term) (g : Grid) :
    (t.word.split g).coarse.value = truncGrid t.word.value (g.toNat - 272) ∧
    (t.word.split g).low.value = t.word.value - truncGrid t.word.value (g.toNat - 272) :=
  ⟨t.word.split_coarse_value g, t.word.split_low_value g⟩
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.truncGrid](../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
