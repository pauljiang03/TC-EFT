# TensorCore.TC.Program.DotProduct

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-623f08595b227aca"></a>

<details>
<summary><code>TensorCore.idealProducts_append</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L10)

```lean
theorem idealProducts_append (p : Profile) (xs ys : List (p.Word × p.Word)) :
    idealProducts p (xs ++ ys) = (do return (← idealProducts p xs) + (← idealProducts p ys)) := by
  have hp : prepareProducts p (xs ++ ys) =
      (do return (← prepareProducts p xs) ++ (← prepareProducts p ys)) := by
    simp [prepareProducts]
  unfold idealProducts
  rw [hp]
  cases hx : prepareProducts p xs <;> cases hy : prepareProducts p ys <;>
    simp [List.map_append, sumQ_append]
```

**Supporting proofs:** [TensorCore.sumQ_append](Loops.md#decl-474827c336526185)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../Defs.md#decl-178599198b2d538e), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.idealContributions_flatten](DotProduct.md#decl-9ddff146f804b161), [TensorCore.idealProducts_padFp16Pairs](Partition.md#decl-78a2a3efb15b0ed0), [TensorCore.nativeBlocks_ideal](../../Gemm/NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.sourceGemmProducts_eq_idealProducts](../../Gemm/InputBounds.md#decl-1c676a2d69d32e7d)

</details>

</details>

<a id="decl-9ddff146f804b161"></a>

<details>
<summary><code>TensorCore.idealContributions_flatten</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L21)

```lean
/-- Grouping preserves the original-bit ideal, including rejection of special operands. -/
theorem idealContributions_flatten (p : Profile) (groups : List (List (p.Word × p.Word))) :
    idealContributions p groups = idealProducts p groups.flatten := by
  induction groups with
  | nil => simp [idealContributions, idealProducts, prepareProducts, sumQ]
  | cons xs groups ih =>
    simp only [idealContributions, List.flatten_cons, idealProducts_append, ih]
```

**Supporting proofs:** [TensorCore.idealProducts_append](DotProduct.md#decl-623f08595b227aca)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.gemmBlocks_ideal](../../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-282172656fc8b089"></a>

<details>
<summary><code>TensorCore.OrderedPartition</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L31)

```lean
/-- A supplied contiguous partition of original operand pairs into fixed-size groups.
The coverage equality retains order, factorization, and multiplicity. It carries
no claim that a GPU instruction executes this chosen grouping. -/
structure OrderedPartition (p : Profile) (original : List (p.Word × p.Word)) where
  groups : List (BlockOperands p)
  covers : (groups.map BlockOperands.values).flatten = original
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.OrderedPartition.input_count](DotProduct.md#decl-36196a2e48524d8d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.partitionExact_inputs_chunks](../../Gemm/Specification/GemmEquivalence.md#decl-2c86a9b78704d3ca), [TensorCore.boundedDot](../Examples/BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_inputs](../Examples/BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmBlocks_count](../../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmInstructions_flatten](../../Gemm/Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](../../Gemm/Defs.md#decl-863019b6c0164a66), [TensorCore.nativeBlocks_shape](../../Gemm/NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativePartition](../../Gemm/NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.partitionExact](Partition.md#decl-4082e3bf596a58d7), [TensorCore.partitionExact_count](Partition.md#decl-f23e6df7073e6ba8), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_count](../../Gemm/Defs.md#decl-fa30d201f6e3a65f), [TensorCore.Regression.orderedDot](../Regression/DotProduct.md#decl-2d5428af12680101)

</details>

</details>

<a id="decl-a64d8423ef8287d8"></a>

<details>
<summary><code>TensorCore.OrderedPartition.inputs</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L35)

```lean
def OrderedPartition.inputs {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) : List (List (p.Word × p.Word)) :=
  partition.groups.map BlockOperands.values
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](../../Gemm/Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.partitionExact_inputs_chunks](../../Gemm/Specification/GemmEquivalence.md#decl-2c86a9b78704d3ca), [TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.Regression.constructed_partition_tail](../Regression/DotProduct.md#decl-571ad9339f4b196c), [TensorCore.Regression.partition_error_contract](../Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_original_order](../Regression/DotProduct.md#decl-3e07931106d2b633), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_inputs](../Examples/BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.gemmInstructions](../../Gemm/Defs.md#decl-20dedfe15b3a55c3), [TensorCore.nativeBlocks](../../Gemm/NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeBlocks_ideal](../../Gemm/NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.runCanonicalDotMachine](Partition.md#decl-17379ac1513b54b1), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0)

</details>

</details>

<a id="decl-f44f6497dde77681"></a>

<details>
<summary><code>TensorCore.OrderedPartition.run</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L39)

```lean
def OrderedPartition.run {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) (c : F32) : Except ModelError (List BlockTrace) :=
  runBlocks p c partition.inputs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.Regression.partition_error_contract](../Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_order_changes_output](../Regression/DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runCanonicalDot_finite](Partition.md#decl-70d7bcd0619569bf), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029)

</details>

</details>

<a id="decl-36196a2e48524d8d"></a>

<details>
<summary><code>TensorCore.OrderedPartition.input_count</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L43)

```lean
theorem OrderedPartition.input_count {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) : original.length = partition.groups.length * p.products := by
  have h (gs : List (BlockOperands p)) :
      (gs.map BlockOperands.values).flatten.length = gs.length * p.products := by
    induction gs with
    | nil => simp
    | cons g gs ih =>
      simp [List.flatten_cons, g.shape, ih, Nat.add_mul, Nat.add_comm]
  exact (congrArg List.length partition.covers).symm.trans (h partition.groups)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b269022d73a4c27d"></a>

<details>
<summary><code>TensorCore.OrderedPartition.ideal</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L53)

```lean
theorem OrderedPartition.ideal {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) :
    idealContributions p partition.inputs = idealProducts p original := by
  rw [idealContributions_flatten]
  exact congrArg (idealProducts p) partition.covers
```

**Supporting proofs:** [TensorCore.idealContributions_flatten](DotProduct.md#decl-9ddff146f804b161)

**Definitions and types:** [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.nativeBlocks_ideal](../../Gemm/NativeGemm.md#decl-0c5bde18a7b3d55b)

</details>

</details>

<a id="decl-ad212c5eb40bffac"></a>

<details>
<summary><code>TensorCore.OrderedPartition.uncorrected_error</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L61)

```lean
/-- A long dot product's uncorrected output has the composed local error budget,
relative to the separately decoded original pair list. -/
theorem OrderedPartition.uncorrected_error {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) (initial : Finite32) (ts : List BlockTrace)
    (products : ℚ) (h : partition.run initial.bits = .ok ts)
    (hi : idealProducts p original = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) ∧
    (partition.inputs ≠ [] →
      absQ (initial.value + products - (lastOutput initial ts).value) <
        sumQ (ts.map BlockTrace.errorBudget)) :=
  runBlocks_uncorrected_error p initial partition.inputs ts products h (by rw [partition.ideal, hi])
```

**Supporting proofs:** [TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_error_contract](../Regression/DotProduct.md#decl-ab9940b7024825ae)

</details>

</details>

<a id="decl-c7ff918b61ba39eb"></a>

<details>
<summary><code>TensorCore.runBlocksMachine</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L73)

```lean
/-- Execute the same encoded schedule using the specified signed accumulation width. -/
def runBlocksMachine (w : ℕ) (p : Profile) :
    F32 → List (List (p.Word × p.Word)) → Except ModelError (List BlockTrace)
  | _, [] => .ok []
  | c, ps :: rest =>
    match evalBlockMachine w (p := p) ⟨ps, c⟩ with
    | .error e => .error e
    | .ok t => match runBlocksMachine w p t.output.bits rest with
      | .error e => .error e
      | .ok ts => .ok (t :: ts)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlockMachine](../Accumulator.md#decl-ab9031f1fdf12cee)

<details>
<summary>Used by</summary>

[TensorCore.fp16Fp32_schedule_machine_eq](DotProduct.md#decl-1fc40acc7fd9825c), [TensorCore.runBlocksMachine_eq](DotProduct.md#decl-69afa0bf303103ec), [TensorCore.runCanonicalDotMachine](Partition.md#decl-17379ac1513b54b1), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029)

</details>

</details>

<a id="decl-69afa0bf303103ec"></a>

<details>
<summary><code>TensorCore.runBlocksMachine_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L84)

```lean
/-- Local full-result equivalence composes across all encoded schedule boundaries. -/
theorem runBlocksMachine_eq (p : Profile) (w F carryBits : ℕ)
    (hF : p.alignFraction = F) (hc : p.products + 1 ≤ 2 ^ carryBits)
    (hw : F + 2 + carryBits + 1 ≤ w) (c : F32)
    (ps : List (List (p.Word × p.Word))) :
    runBlocksMachine w p c ps = runBlocks p c ps := by
  induction ps generalizing c with
  | nil => rfl
  | cons q ps ih =>
    simp only [runBlocksMachine, evalBlockMachine_eq _ w F carryBits hF hc hw, runBlocks]
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => rfl
    | ok t =>
      dsimp only
      rw [ih]
      rfl
```

**Supporting proofs:** [TensorCore.evalBlockMachine_eq](../MachineRefinement.md#decl-d4518ab25c18ea58)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](../Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocksMachine](DotProduct.md#decl-c7ff918b61ba39eb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.fp16Fp32_schedule_machine_eq](DotProduct.md#decl-1fc40acc7fd9825c)

</details>

</details>

<a id="decl-1fc40acc7fd9825c"></a>

<details>
<summary><code>TensorCore.fp16Fp32_schedule_machine_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Program/DotProduct.lean#L100)

```lean
theorem fp16Fp32_schedule_machine_eq (K extra carryBits w : ℕ) (floor : Option ℤ)
    (hc : K + 1 ≤ 2 ^ carryBits) (hw : 26 + extra + carryBits ≤ w) (c : F32)
    (ps : List (List (F16 × F16))) :
    runBlocksMachine w (fp16Fp32Profile K extra floor) c ps =
      runBlocks (fp16Fp32Profile K extra floor) c ps :=
  runBlocksMachine_eq (fp16Fp32Profile K extra floor) w (23 + extra) carryBits rfl hc (by omega) c ps
```

**Supporting proofs:** [TensorCore.runBlocksMachine_eq](DotProduct.md#decl-69afa0bf303103ec)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocksMachine](DotProduct.md#decl-c7ff918b61ba39eb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029)

</details>

</details>
