# TensorCore.EFT.Machine.Cost

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f6d298d25b86c3e3"></a>

<details>
<summary><code>TensorCore.EFMachine.OperationBudget</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L24)

```lean
structure OperationBudget where
  inputDecodes : ℕ
  products : ℕ
  rawScan : ℕ
  splits : ℕ
  extractionAdds : ℕ
  scalarAdds : ℕ
  exactChecks : ℕ
  conversions : ℕ
  guardCoefficientAdds : ℕ
  residualBitScans : ℕ
  scalarDecodes : ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.bitScan_total_budget](Cost.md#decl-a3a9475bba1317cd), [TensorCore.EFMachine.operationBudget](Cost.md#decl-12ce283d4ed8b935), [TensorCore.EFMachine.operationBudget_bounds](Cost.md#decl-767173d29c375b8d)

</details>

</details>

<a id="decl-12ce283d4ed8b935"></a>

<details>
<summary><code>TensorCore.EFMachine.operationBudget</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L38)

```lean
def operationBudget (K : ℕ) : OperationBudget :=
  let N := K + 1
  ⟨2 * K + 2, K, N, N, 2 * N + 3, N + 2, N + 4,
    2 * N + 7, N, N, (N + 4) + 2 * (N + 2) + 2⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.OperationBudget](Cost.md#decl-f6d298d25b86c3e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.bitScan_total_budget](Cost.md#decl-a3a9475bba1317cd), [TensorCore.EFMachine.operationBudget_bounds](Cost.md#decl-767173d29c375b8d)

</details>

</details>

<a id="decl-767173d29c375b8d"></a>

<details>
<summary><code>TensorCore.EFMachine.operationBudget_bounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L44)

```lean
/-- Concrete maxima for every supported normalization group, including failed scalar attempts. -/
theorem operationBudget_bounds (path : Path) :
    let b := operationBudget path.profile.products
    b.inputDecodes ≤ 34 ∧ b.products ≤ 16 ∧ b.rawScan ≤ 17 ∧ b.splits ≤ 17 ∧
    b.extractionAdds ≤ 37 ∧ b.scalarAdds ≤ 19 ∧ b.exactChecks ≤ 21 ∧
    b.conversions ≤ 41 ∧ b.guardCoefficientAdds ≤ 17 ∧ b.residualBitScans ≤ 17 ∧
    b.scalarDecodes ≤ 61 := by cases path <;> decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.OperationBudget](Cost.md#decl-f6d298d25b86c3e3), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.operationBudget](Cost.md#decl-12ce283d4ed8b935), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a3a9475bba1317cd"></a>

<details>
<summary><code>TensorCore.EFMachine.bitScan_total_budget</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L54)

```lean
/-- Each direct conversion needs at most one leading scan; each nonzero residual
needs at most one trailing scan. This includes the failed scalar attempt and exact
fallback. A probe is a bounded shift/prefix operation and comparison, not a CPU cycle. -/
theorem bitScan_total_budget (path : Path) :
    10 * ((operationBudget path.profile.products).conversions +
      (operationBudget path.profile.products).residualBitScans) ≤ 580 := by
  cases path <;> decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.OperationBudget](Cost.md#decl-f6d298d25b86c3e3), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.operationBudget](Cost.md#decl-12ce283d4ed8b935), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1274b05f6f0d58bd"></a>

<details>
<summary><code>TensorCore.EFMachine.extraction_loop_bounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L60)

```lean
/-- The actual decoded and extracted list lengths discharge the loop budgets. -/
theorem extraction_loop_bounds {path : Path} {x : BlockInput path.profile} {D : F32}
    {p : Prepared} {c : Components} (hp : prepare path x D = .ok p) (hc : extract p = some c) :
    p.terms.length ≤ 17 ∧ c.coarse.length = path.profile.products + 1 ∧
      c.low.length = path.profile.products + 1 := by
  have hlen := (prepare_spec hp).2.2.2.1
  have hs := extract_spec hc
  rw [hs.2.1, hs.2.2.1]
  simp only [List.length_map, hlen]
  exact ⟨by have h := path_count path; omega, trivial, trivial⟩
```

**Supporting proofs:** [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.path_count](Preparation.md#decl-5c86c03a8739e02a), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Components](../Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Error](../Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](../Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.extract](../Bounded.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ec1a0c99d64fdbc4"></a>

<details>
<summary><code>TensorCore.EFMachine.sumWordsAdds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L72)

```lean
/-- Under the execution preconditions each sumWords call executes exactly one
checked addition per list element. It starts at zero; no floating additions are hidden. -/
def sumWordsAdds : List Word → ℕ
  | [] => 0
  | _ :: xs => sumWordsAdds xs + 1
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.sumWordsAdds_eq](Cost.md#decl-92bd9b3866278153)

</details>

</details>

<a id="decl-92bd9b3866278153"></a>

<details>
<summary><code>TensorCore.EFMachine.sumWordsAdds_eq</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Cost.lean#L76)

```lean
theorem sumWordsAdds_eq (xs : List Word) : sumWordsAdds xs = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [sumWordsAdds, ih]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.sumWordsAdds](Cost.md#decl-ec1a0c99d64fdbc4)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
