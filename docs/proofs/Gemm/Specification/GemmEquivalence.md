# TensorCore.Gemm.Specification.GemmEquivalence

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-419ac65204c32de1"></a>

<details>
<summary><code>TensorCore.PaperSpec.wmmaModel</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L11)

```lean
abbrev wmmaModel : WmmaGemmModel → WmmaModel
  | .v100 => .v100 | .ampere => .ampere | .hopper => .hopper
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.instructionGroups_eq_paper](GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.PaperSpec.wmma_parameters](GemmEquivalence.md#decl-193ac1310155f18d), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_gemm_empty_and_nonfinite](../Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](../Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](../Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](../Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](../Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.familyCheck_paper](../Family.md#decl-0234d61782492f02), [TensorCore.gemmAnalysisCheck_paper](../Analysis.md#decl-7b3d3dd3b1859d7d)

</details>

</details>

<a id="decl-193ac1310155f18d"></a>

<details>
<summary><code>TensorCore.PaperSpec.wmma_parameters</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L14)

```lean
theorem wmma_parameters (model : WmmaGemmModel) :
    parametersOf model.path.profile = (wmmaModel model).parameters := by
  cases model <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath.profile](../../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.WmmaModel.parameters](Matrix.md#decl-ef4b49759ceb3b29), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](../Defs.md#decl-860954743cbdf9bb)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d259480c970e3a94"></a>

<details>
<summary><code>TensorCore.PaperSpec.chunks_eq_matrixChunks</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L18)

```lean
theorem chunks_eq_matrixChunks (width count : ℕ) (xs : List α) :
    chunks width count xs = matrixChunks width count xs := by
  induction count generalizing xs with
  | zero => rfl
  | succ n ih => simp [chunks, matrixChunks, ih]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a), [TensorCore.chunks](../../TC/Instruction.md#decl-3eda2673db5b65b7)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.instructionGroups_eq_paper](GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe)

</details>

</details>

<a id="decl-2c86a9b78704d3ca"></a>

<details>
<summary><code>TensorCore.PaperSpec.partitionExact_inputs_chunks</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L24)

```lean
theorem partitionExact_inputs_chunks (p : Profile) (count : ℕ)
    (xs : List (p.Word × p.Word)) (h : xs.length = count * p.products) :
    (partitionExact p count xs h).inputs = chunks p.products count xs := by
  induction count generalizing xs with
  | zero => rfl
  | succ n ih =>
    simp only [partitionExact, OrderedPartition.inputs, List.map_cons, chunks]
    exact congrArg (List.cons (xs.take p.products)) (ih _ _)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.OrderedPartition](../../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](../../TC/Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.chunks](../../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.partitionExact](../../TC/Program/Partition.md#decl-4082e3bf596a58d7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5)

</details>

</details>

<a id="decl-41f04782d116be19"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemmInstructions_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L33)

```lean
theorem gemmInstructions_eq_paper (pairs : List (F16 × F16)) :
    gemmInstructions pairs = matrixInstructions pairs := by
  have hc : groupCount 16 pairs.length = (pairs.length + 15) / 16 := by
    unfold groupCount
    split <;> omega
  have hp : tailPadding 16 pairs.length = (16 - pairs.length % 16) % 16 := by
    have := Nat.mod_lt pairs.length (by decide : 0 < 16)
    unfold tailPadding
    split <;> omega
  simp only [gemmInstructions, canonicalPartition, partitionExact_inputs_chunks,
    chunks_eq_matrixChunks, padFp16Pairs, hc, hp, matrixInstructions]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.chunks_eq_matrixChunks](GemmEquivalence.md#decl-d259480c970e3a94), [TensorCore.PaperSpec.partitionExact_inputs_chunks](GemmEquivalence.md#decl-2c86a9b78704d3ca)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](../../TC/Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a), [TensorCore.PaperSpec.matrixInstructions](Matrix.md#decl-41c588bee8af8a91), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.canonicalPartition](../../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.chunks](../../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.gemmInstructions](../Defs.md#decl-20dedfe15b3a55c3), [TensorCore.groupCount](../../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](../../TC/Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.partitionExact](../../TC/Program/Partition.md#decl-4082e3bf596a58d7), [TensorCore.tailPadding](../../TC/Program/Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c)

</details>

</details>

<a id="decl-1dc4cea76ce0c1e5"></a>

<details>
<summary><code>TensorCore.PaperSpec.instructionGroups_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L46)

```lean
theorem instructionGroups_eq_paper (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    model.path.schedule pairs = instructionGroups (wmmaModel model) pairs := by
  cases model <;> exact chunks_eq_matrixChunks _ _ _
```

**Supporting proofs:** [TensorCore.PaperSpec.chunks_eq_matrixChunks](GemmEquivalence.md#decl-d259480c970e3a94)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](../../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](../../TC/Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.profile](../../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.PaperSpec.instructionGroups](Matrix.md#decl-dc882eadd7b8d7ef), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](../Defs.md#decl-860954743cbdf9bb)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.runGemmInstructions_eq_paper](GemmEquivalence.md#decl-f35ca03e91855ea8)

</details>

</details>

<a id="decl-6966179b65962514"></a>

<details>
<summary><code>TensorCore.PaperSpec.mapped_lastOutput</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L50)

```lean
theorem mapped_lastOutput (initial : Finite32) (ts : List BlockTrace) :
    (ts.map fun t => t.output.bits).getLast?.getD initial.bits = (lastOutput initial ts).bits := by
  rw [List.getLast?_map]
  exact lastOutput_bits initial ts
```

**Supporting proofs:** [TensorCore.lastOutput_bits](../../TC/Instruction.md#decl-922f2f0fa043267c)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.lastOutput](../../TC/Program/Composition.md#decl-59a9e0884980f32b)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmCellObservation_output](GemmEquivalence.md#decl-4e01e4b2fe2487ea)

</details>

</details>

<a id="decl-f35ca03e91855ea8"></a>

<details>
<summary><code>TensorCore.PaperSpec.runGemmInstructions_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L55)

```lean
theorem runGemmInstructions_eq_paper (model : WmmaGemmModel) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (hshape : ∀ xs ∈ inputs, xs.length = 16) :
    (runGemmInstructions model.path initial inputs).toOption.map
      (fun ts => ts.map fun gs => gs.map fun t => t.output.bits) =
      runMatrixInstructions (wmmaModel model) initial.bits inputs := by
  induction inputs generalizing initial with
  | nil => rfl
  | cons pairs rest ih =>
    have hb : (runBlocks model.path.profile initial.bits (model.path.schedule pairs)).toOption.map
        (fun ts => ts.map fun t => t.output.bits) =
        runGroups (wmmaModel model).parameters initial.bits (instructionGroups (wmmaModel model) pairs) := by
      rw [← instructionGroups_eq_paper]
      cases model <;> exact runBlocks_eq_paper _ _ _
    have hr : model.path.run initial.bits pairs =
        runBlocks model.path.profile initial.bits (model.path.schedule pairs) := by
      simp [InstructionPath.run, hshape pairs (by simp)]
    rw [← hr] at hb
    simp only [runMatrixInstructions, ← hb]
    cases hg : model.path.run initial.bits pairs with
    | error e => simp [runGemmInstructions, hg, Except.toOption]
    | ok gs =>
      have tail := ih (lastOutput initial gs) (by intro xs hx; exact hshape xs (by simp [hx]))
      cases hd : runGemmInstructions model.path (lastOutput initial gs) rest with
      | error e => simp [runGemmInstructions, hg, hd, Except.toOption, lastOutput_bits] at tail ⊢; rw [← tail]; rfl
      | ok ds => simp [runGemmInstructions, hg, hd, Except.toOption, lastOutput_bits] at tail ⊢; rw [← tail]; rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.instructionGroups_eq_paper](GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runBlocks_eq_paper](../../TC/Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.WmmaGemmModel.k](../Defs.md#decl-d7ce31e450277fbc), [TensorCore.lastOutput_bits](../../TC/Instruction.md#decl-922f2f0fa043267c)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](../../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](../../TC/Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](../../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.WmmaModel.parameters](Matrix.md#decl-ef4b49759ceb3b29), [TensorCore.PaperSpec.instructionGroups](Matrix.md#decl-dc882eadd7b8d7ef), [TensorCore.PaperSpec.runGroups](../../TC/Specification/Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.runMatrixInstructions](Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](../Defs.md#decl-860954743cbdf9bb), [TensorCore.lastOutput](../../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runGemmInstructions](../Defs.md#decl-fa58899497fedd29)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c)

</details>

</details>

<a id="decl-c61a953641cc1967"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemmCellObservation</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L81)

```lean
def gemmCellObservation (cell : GemmCell) : MatrixCell :=
  ⟨cell.initial.bits, cell.instructions.map fun gs => gs.map fun t => t.output.bits⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_check_sound](../Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemmCellObservation_output](GemmEquivalence.md#decl-4e01e4b2fe2487ea), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.Regression.cutlass_fixture_connection](../Regression/CutlassWmma.md#decl-e2a0bcb3a499b023), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>

<a id="decl-4e01e4b2fe2487ea"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemmCellObservation_output</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L84)

```lean
theorem gemmCellObservation_output (cell : GemmCell) :
    (gemmCellObservation cell).output = cell.output.bits := by
  simp only [gemmCellObservation, MatrixCell.output]
  rw [← List.map_flatten]
  exact mapped_lastOutput cell.initial cell.instructions.flatten
```

**Supporting proofs:** [TensorCore.PaperSpec.mapped_lastOutput](GemmEquivalence.md#decl-6966179b65962514)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.PaperSpec.MatrixCell.output](Matrix.md#decl-2e5dc86c7c48029c), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

</details>

</details>

<a id="decl-83c15244052766f4"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrix_value32_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L90)

```lean
theorem matrix_value32_eq (c : F32) : value32 c = TensorCore.value32 c := by
  change (decode (layoutOf fp32) c.toNat).map Term.value = _
  rw [decode_eq]
  simp [TensorCore.value32, decode32_eq, Option.map_map, termOf, Function.comp_def]
```

**Supporting proofs:** [TensorCore.PaperSpec.decode_eq](../../TC/Specification/Stages.md#decl-16342b2304718371)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.decode](../../TC/Specification/Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.termOf](../../TC/Specification/Stages.md#decl-5d5575e19169b785), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.classifyNat](../../Core/Encoding.md#decl-52d401d7433cac5a), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.matrix_value32_finite](GemmEquivalence.md#decl-9ce8d5ea689e94d1), [TensorCore.PaperSpec.scalarValue32_of_finite](ScaledGemmEquivalence.md#decl-4bd57b05007ab0d1)

</details>

</details>

<a id="decl-9ce8d5ea689e94d1"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrix_value32_finite</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L95)

```lean
theorem matrix_value32_finite (c : F32) : value32 c = (finite32 c).map Finite32.value := by
  rw [matrix_value32_eq]
  unfold finite32
  split <;> simp_all [TensorCore.value32, Finite32.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.matrix_value32_eq](GemmEquivalence.md#decl-83c15244052766f4)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.epilogue_contract](GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.scalarValue32_finite](ScaledGemmEquivalence.md#decl-13d680b591b379ba), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c)

</details>

</details>

<a id="decl-62707c4cb8f2dc7c"></a>

<details>
<summary><code>TensorCore.PaperSpec.simulateGemmCell_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L100)

```lean
theorem simulateGemmCell_eq_paper (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) :
    (simulateGemmCell model pairs c).toOption.map gemmCellObservation =
      matrixCell (wmmaModel model) pairs c := by
  unfold simulateGemmCell matrixCell
  rw [matrix_value32_finite]
  cases hf : finite32 c with
  | none => rfl
  | some initial =>
    have hb := finite32_bits hf
    have hr := runGemmInstructions_eq_paper model initial (gemmInstructions pairs)
      (gemmInstructions_shape pairs)
    rw [gemmInstructions_eq_paper, hb] at hr
    simp only [Option.map_some]
    rw [← hr]
    rw [← gemmInstructions_eq_paper]
    cases he : runGemmInstructions model.path initial (gemmInstructions pairs) with
    | error e => rfl
    | ok ts => simp [Except.toOption, gemmCellObservation, hb]
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmInstructions_eq_paper](GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.matrix_value32_finite](GemmEquivalence.md#decl-9ce8d5ea689e94d1), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.finite32_bits](../../TC/Program/Defs.md#decl-08ec57f1c290b572), [TensorCore.gemmInstructions_shape](../Defs.md#decl-863019b6c0164a66)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.matrixInstructions](Matrix.md#decl-41c588bee8af8a91), [TensorCore.PaperSpec.runMatrixInstructions](Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](../Defs.md#decl-860954743cbdf9bb), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.gemmInstructions](../Defs.md#decl-20dedfe15b3a55c3), [TensorCore.runGemmInstructions](../Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](../Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c)

</details>

</details>

<a id="decl-5c9e12476c94c50c"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemm_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L121)

```lean
/-- Universal matrix equality, including dimensions, output cropping, tail padding,
initial C, every encoded group/instruction boundary, and rejection as none. -/
theorem gemm_eq_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemm model A B C).map (fun row => row.map fun cell =>
      cell.toOption.map gemmCellObservation) = wmmaGemm (wmmaModel model) A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [Vector.getElem_map, wmmaGemm, Vector.getElem_ofFn]
  rw [gemm_entry model A B C ⟨i, hi⟩ ⟨j, hj⟩]
  exact simulateGemmCell_eq_paper model (gemmPairs A B ⟨i, hi⟩ ⟨j, hj⟩) C[i][j]
```

**Supporting proofs:** [TensorCore.PaperSpec.simulateGemmCell_eq_paper](GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.gemm_entry](../Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.matrixCell](Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.matrixPairs](Matrix.md#decl-a2b1744a02af852c), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmPairs](../Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.simulateGemmCell](../Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_eq_gemm](../Kernels/CutlassWmma.md#decl-605b9db02c373842), [TensorCore.PaperSpec.gemmBits_eq_paper](GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.Regression.paper_gemm_boundaries](../Regression/GemmSpecification.md#decl-7e99f654c1b12fb7)

</details>

</details>

<a id="decl-e1a406fea7ba091b"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemmBits_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L134)

```lean
/-- Equality of final encoded outputs for every matrix; no execution premise. -/
theorem gemmBits_eq_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemmBits model A B C).map (fun row => row.map Except.toOption) =
      wmmaGemmBits (wmmaModel model) A B C := by
  rw [wmmaGemmBits, ← gemm_eq_paper]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [gemmBits, Vector.getElem_map]
  cases he : (gemm model A B C)[i][j] with
  | error e => rfl
  | ok cell => simp [Except.toOption, Except.map, gemmCellObservation_output]
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmCellObservation_output](GemmEquivalence.md#decl-4e01e4b2fe2487ea), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.MatrixCell.output](Matrix.md#decl-2e5dc86c7c48029c), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaGemmBits](Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_gemm_empty_and_nonfinite](../Regression/GemmSpecification.md#decl-19e69582e00c6cc9), [TensorCore.Regression.paper_gemm_empty_outputs](../Regression/GemmSpecification.md#decl-f27090983a42c796), [TensorCore.Regression.paper_gemm_instruction_order](../Regression/GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.paper_gemm_output_crop](../Regression/GemmSpecification.md#decl-bbeccaa9fc02f1b3), [TensorCore.Regression.paper_gemm_rectangular](../Regression/GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.familyCheck_paper](../Family.md#decl-0234d61782492f02), [TensorCore.gemmAnalysisCheck_paper](../Analysis.md#decl-7b3d3dd3b1859d7d)

</details>

</details>

<a id="decl-c3ea9f4e462f6e60"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemm_entry_eq_paper_iff</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L150)

```lean
/-- Paper-side success yields an executable trace, and conversely. The nested
trace retains every encoded boundary, rather than just the final value. -/
theorem gemm_entry_eq_paper_iff (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) (d : MatrixCell) :
    (wmmaGemm (wmmaModel model) A B C)[i.val][j.val] = some d ↔
      ∃ cell, (gemm model A B C)[i.val][j.val] = .ok cell ∧ gemmCellObservation cell = d := by
  rw [← gemm_eq_paper]
  simp only [Vector.getElem_map]
  cases he : (gemm model A B C)[i.val][j.val] <;> simp [Except.toOption]
```

**Supporting proofs:** [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemm_rejected_iff_paper](GemmEquivalence.md#decl-41f4521a2591b00c), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c)

</details>

</details>

<a id="decl-41f4521a2591b00c"></a>

<details>
<summary><code>TensorCore.PaperSpec.gemm_rejected_iff_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmEquivalence.lean#L158)

```lean
theorem gemm_rejected_iff_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) :
    (wmmaGemm (wmmaModel model) A B C)[i.val][j.val] = none ↔
      ∃ e, (gemm model A B C)[i.val][j.val] = .error e := by
  rw [← gemm_eq_paper]
  simp only [Vector.getElem_map]
  cases he : (gemm model A B C)[i.val][j.val] <;> simp [Except.toOption]
```

**Supporting proofs:** [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
