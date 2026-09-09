# TensorCore.Gemm.Bounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-296b305cc459bad8"></a>

<details>
<summary><code>TensorCore.runBlocks_split</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L10)

```lean
private theorem runBlocks_split (p : Profile) (initial : Finite32)
    (xs ys : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p initial.bits (xs ++ ys) = .ok ts) :
    ∃ us vs, runBlocks p initial.bits xs = .ok us ∧
      runBlocks p (lastOutput initial us).bits ys = .ok vs ∧ ts = us ++ vs := by
  induction xs generalizing initial ts with
  | nil => exact ⟨[], ts, rfl, h, rfl⟩
  | cons g xs ih =>
    cases hg : evalBlock (⟨g, initial.bits⟩ : BlockInput p) with
    | error e => simp [runBlocks, hg] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits (xs ++ ys) with
      | error e => simp [runBlocks, hg, hr] at h
      | ok rest =>
        obtain ⟨us, vs, hu, hv, he⟩ := ih t.output rest hr
        refine ⟨t :: us, vs, ?_, hv, ?_⟩
        · simp [runBlocks, hg, hu]
        · simpa [runBlocks, hg, hr, he] using h.symm
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runGemmInstructions_complete](Bounds.md#decl-5e1cd17f4e8c0bf4)

</details>

</details>

<a id="decl-5e1cd17f4e8c0bf4"></a>

<details>
<summary><code>TensorCore.runGemmInstructions_complete</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L31)

```lean
/-- Acceptance of the flattened arithmetic schedule implies acceptance of the
instruction chain, with the same encoded boundaries. -/
theorem runGemmInstructions_complete (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (ts : List BlockTrace)
    (hs : ∀ g ∈ inputs, g.length = p.k)
    (h : runBlocks p.profile initial.bits (inputs.flatMap p.schedule) = .ok ts) :
    ∃ traces, runGemmInstructions p initial inputs = .ok traces ∧ traces.flatten = ts := by
  induction inputs generalizing initial ts with
  | nil =>
    simp [runBlocks] at h
    subst ts
    exact ⟨[], rfl, rfl⟩
  | cons g rest ih =>
    obtain ⟨us, vs, hu, hv, he⟩ := runBlocks_split p.profile initial _ _ ts h
    have hp : p.run initial.bits g = .ok us := by
      simp [InstructionPath.run, hs g (by simp), hu]
    obtain ⟨tail, ht, hf⟩ := ih (lastOutput initial us) vs
      (fun g hg => hs g (by simp [hg])) hv
    refine ⟨us :: tail, ?_, ?_⟩
    · simp [runGemmInstructions, hp, ht]
    · simp [hf, he]
```

**Supporting proofs:** [TensorCore.runBlocks_split](Bounds.md#decl-296b305cc459bad8)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](../TC/Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-1053388273074842"></a>

<details>
<summary><code>TensorCore.chunks_shape</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L51)

```lean
private theorem chunks_shape (n count : ℕ) (xs : List α)
    (hx : xs.length = count * n) :
    (chunks n count xs).length = count ∧ ∀ g ∈ chunks n count xs, g.length = n := by
  induction count generalizing xs with
  | zero => simp [chunks]
  | succ count ih =>
    have hd : (xs.drop n).length = count * n := by
      simp only [List.length_drop]
      rw [Nat.succ_mul] at hx
      omega
    obtain ⟨hl, hs⟩ := ih (xs.drop n) hd
    constructor
    · simp [chunks, hl]
    · intro g hg
      simp only [chunks, List.mem_cons] at hg
      rcases hg with rfl | hg
      · simp only [List.length_take]
        rw [Nat.succ_mul] at hx
        omega
      · exact hs g hg
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.chunks](../TC/Instruction.md#decl-3eda2673db5b65b7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1)

</details>

</details>

<a id="decl-46e34ca627b0c0a9"></a>

<details>
<summary><code>TensorCore.gemmBlocks</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L72)

```lean
def gemmBlocks (model : WmmaGemmModel) (pairs : List (F16 × F16)) :=
  (gemmInstructions pairs).flatMap model.path.schedule
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3)

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell](Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.checkGemmCell](Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-1d5bfb769b6d463d"></a>

<details>
<summary><code>TensorCore.gemmBlockCount</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L75)

```lean
def gemmBlockCount (model : WmmaGemmModel) (k : ℕ) : ℕ :=
  groupCount 16 k * model.path.groups
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath.groups](../TC/Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355)

<details>
<summary>Used by</summary>

[TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf)

</details>

</details>

<a id="decl-4e35c27fc2ec0cb1"></a>

<details>
<summary><code>TensorCore.gemmBlocks_shape</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L78)

```lean
theorem gemmBlocks_shape (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    ∀ g ∈ gemmBlocks model pairs, g.length = model.path.products := by
  intro g hg
  obtain ⟨instruction, hi, hg⟩ := List.mem_flatMap.mp hg
  apply (chunks_shape model.path.products model.path.groups instruction ?_).2 g hg
  rw [gemmInstructions_shape pairs instruction hi]
  exact (WmmaGemmModel.k model).symm.trans (Nat.div_mul_cancel model.path.kDiv).symm
```

**Supporting proofs:** [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66), [TensorCore.chunks_shape](Bounds.md#decl-1053388273074842)

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](../TC/Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.chunks](../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeGemmCell_complete](Analysis.md#decl-e410d155f5952501), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-d19f053063b09c78"></a>

<details>
<summary><code>TensorCore.gemmBlocks_count</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L86)

```lean
theorem gemmBlocks_count (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    (gemmBlocks model pairs).length = gemmBlockCount model pairs.length := by
  have hc : ∀ instruction ∈ gemmInstructions pairs,
      (model.path.schedule instruction).length = model.path.groups := by
    intro instruction hi
    apply (chunks_shape model.path.products model.path.groups instruction ?_).1
    rw [gemmInstructions_shape pairs instruction hi]
    exact (WmmaGemmModel.k model).symm.trans (Nat.div_mul_cancel model.path.kDiv).symm
  have count : ∀ xs : List (List (F16 × F16)),
      (∀ x ∈ xs, (model.path.schedule x).length = model.path.groups) →
      (xs.flatMap model.path.schedule).length = xs.length * model.path.groups := by
    intro xs h
    induction xs with
    | nil => simp
    | cons x xs ih =>
      simp only [List.flatMap_cons, List.length_append, List.length_cons]
      rw [h x (by simp), ih (fun y hy => h y (by simp [hy])), Nat.succ_mul]
      omega
  rw [gemmBlocks, count _ hc]
  congr 1
  simpa [gemmInstructions, OrderedPartition.inputs] using
    canonicalPartition_count 16 0 none (by decide) pairs
```

**Supporting proofs:** [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.canonicalPartition_count](../TC/Program/Partition.md#decl-1992fedc2c2443e2), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66), [TensorCore.chunks_shape](Bounds.md#decl-1053388273074842)

**Definitions and types:** [TensorCore.BlockOperands](../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](../TC/Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.canonicalPartition](../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.chunks](../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-a31501016f14518c"></a>

<details>
<summary><code>TensorCore.gemmBlocks_ideal</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L109)

```lean
theorem gemmBlocks_ideal (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    idealContributions model.path.profile (gemmBlocks model pairs) =
      idealProducts v100F16F32 pairs := by
  have hf : (gemmBlocks model pairs).flatten = (gemmInstructions pairs).flatten := by
    have aux : ∀ xs : List (List (F16 × F16)),
        (∀ g ∈ xs, g.length = model.path.k) →
        (xs.flatMap model.path.schedule).flatten = xs.flatten := by
      intro xs hs
      induction xs with
      | nil => rfl
      | cons g xs ih =>
        simp only [List.flatMap_cons, List.flatten_append, List.flatten_cons]
        rw [model.path.schedule_flatten g (hs g (by simp)),
          ih (fun x hx => hs x (by simp [hx]))]
    exact aux _ (fun g hg =>
      (gemmInstructions_shape pairs g hg).trans (WmmaGemmModel.k model).symm)
  rw [idealContributions_flatten, hf, gemmInstructions_flatten]
  change idealProducts (fp16Fp32Profile 16 0 none) (padFp16Pairs 16 pairs) =
    idealProducts (fp16Fp32Profile 16 0 none) pairs
  exact idealProducts_padFp16Pairs 16 0 none pairs
```

**Supporting proofs:** [TensorCore.InstructionPath.schedule_flatten](../TC/Instruction.md#decl-2652b6482c26797c), [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.gemmInstructions_flatten](Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66), [TensorCore.idealContributions_flatten](../TC/Program/DotProduct.md#decl-9ddff146f804b161), [TensorCore.idealProducts_padFp16Pairs](../TC/Program/Partition.md#decl-78a2a3efb15b0ed0)

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGemmCell_sound](Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>

<a id="decl-67b679b61e10d595"></a>

<details>
<summary><code>TensorCore.GemmBoundConfig</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L132)

```lean
/-- E bounds the changing accumulator scale; P bounds raw product scales.
L supplies carry headroom, and initialBound bounds every initial accumulator. -/
structure GemmBoundConfig where
  accumulatorScale : ℤ
  productScale : ℤ
  carryBits : ℕ
  initialBound : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.PipelineAnalysis.familyReport](Cli/PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.Cli.PipelineAnalysis.familyWitnessJson](Cli/PipelineAnalysis.md#decl-096a223468dfacfb), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.Regression.empty_family_accuracy](Regression/GemmFamily.md#decl-df50441d5d2cb648), [TensorCore.Regression.family_witness_controls](Regression/GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.gemm_certificate_rejects](Regression/GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.minimalTinyBounds](Regression/GemmAnalysis.md#decl-09d5251e48e6effa), [TensorCore.Regression.smallGemmBounds](Regression/GemmExtensions.md#decl-9f16c29325b246ad), [TensorCore.Regression.sourceGemmBounds](Regression/GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.Regression.unitFamilyWitness](Regression/GemmFamily.md#decl-6f4d7edf02c5d4d3), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyError](Family.md#decl-966b1b857128f203), [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.inferEntryFamily](EntryFamily.md#decl-5e36ba2c223b5587), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848), [TensorCore.inferFamily_valid](Family.md#decl-01c631b0665f69f3)

</details>

</details>

<a id="decl-f2b1a703f1fc6bcf"></a>

<details>
<summary><code>TensorCore.gemmStaticError</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L139)

```lean
def gemmStaticError (model : WmmaGemmModel) (cfg : GemmBoundConfig) (k : ℕ) : ℚ :=
  (gemmBlockCount model k : ℚ) * staticBudget (model.path.products + 1)
    model.path.profile.alignFraction cfg.accumulatorScale cfg.carryBits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.Regression.analysis_improves_existing_certificate](Regression/GemmAnalysis.md#decl-a1392f6a35ba7d56), [TensorCore.Regression.analysis_improves_minimal_static](Regression/GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyError](Family.md#decl-966b1b857128f203), [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf)

</details>

</details>

<a id="decl-a52f6a5d0ea4462e"></a>

<details>
<summary><code>TensorCore.gemmCellCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L143)

```lean
def gemmCellCheck (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (pairs : List (F16 × F16)) (c : F32) : Bool :=
  let p := model.path.profile
  let E := cfg.accumulatorScale
  let P := cfg.productScale
  let L := cfg.carryBits
  decide (-126 ≤ E ∧ P ≤ E ∧ (∀ f ∈ p.alignFloor, f ≤ E) ∧
    p.products + 1 ≤ 2 ^ L ∧ E + 2 + L ≤ 127) &&
  (gemmBlocks model pairs).all (groupScaleCheck p P) &&
  match value32 c with
  | none => false
  | some cv => decide (absQ cv ≤ cfg.initialBound ∧
      cfg.initialBound + (gemmBlockCount model pairs.length : ℚ) *
        ((p.products : ℚ) * (4 * pow2 P) +
          staticBudget (p.products + 1) p.alignFraction E L) < pow2 (E + 1))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.groupScaleCheck](../TC/Program/StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>

<a id="decl-0e3a8c7f2edd1ebd"></a>

<details>
<summary><code>TensorCore.gemmCellCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L159)

```lean
theorem gemmCellCheck_sound (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (pairs : List (F16 × F16)) (c : F32) (h : gemmCellCheck model cfg pairs c = true) :
    ∃ cell products, simulateGemmCell model pairs c = .ok cell ∧
      idealProducts v100F16F32 pairs = some products ∧
      value32 c = some cell.initial.value ∧
      absQ (cell.initial.value + products - cell.output.value) ≤
        gemmStaticError model cfg pairs.length := by
  simp only [gemmCellCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨hE, hPE, hfl, hL, hrange⟩, hs⟩, hc⟩ := h
  cases hv : value32 c with
  | none => simp [hv] at hc
  | some cv =>
    simp only [hv, decide_eq_true_eq] at hc
    obtain ⟨initial, hi, hb, hval⟩ := finite32_of_value32 c cv hv
    obtain ⟨ts, products, hr, hp, he⟩ := runBlocks_of_scale_bound
      model.path.profile cfg.accumulatorScale cfg.productScale cfg.carryBits
      hE hPE hfl hL hrange (gemmBlocks model pairs) (gemmBlocks_shape model pairs)
      (fun g hg => groupScaleCheck_sound _ _ _ (List.all_eq_true.mp hs g hg))
      initial cfg.initialBound (by simpa [hval] using hc.1)
      (by simpa [gemmBlocks_count] using hc.2)
    obtain ⟨traces, ht, hf⟩ := runGemmInstructions_complete model.path initial
      (gemmInstructions pairs) ts
      (fun g hg => (gemmInstructions_shape pairs g hg).trans (WmmaGemmModel.k model).symm) hr
    refine ⟨⟨initial, traces⟩, products, ?_, ?_, ?_, ?_⟩
    · simp [simulateGemmCell, hi, ht]
    · rwa [gemmBlocks_ideal] at hp
    · simp [hval]
    · rw [gemmBlocks_count] at he
      simpa [GemmCell.output, GemmCell.blocks, hf, gemmStaticError,
        InstructionPath.profile, fp16Fp32Profile] using he
```

**Supporting proofs:** [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66), [TensorCore.groupScaleCheck_sound](../TC/Program/StaticCertificate.md#decl-5583db47fae0681c), [TensorCore.runBlocks_of_scale_bound](../TC/Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runGemmInstructions_complete](Bounds.md#decl-5e1cd17f4e8c0bf4)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.blocks](Defs.md#decl-f9fc32c91c796407), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.groupScaleCheck](../TC/Program/StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../TC/Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.runBlocks](../TC/Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521)

</details>

</details>

<a id="decl-6dd15d2054647056"></a>

<details>
<summary><code>TensorCore.gemmCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L191)

```lean
/-- All checks depend only on original operands, dimensions, and the supplied bounds. -/
def gemmCheck (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Bool :=
  decide (∀ i : Fin m, ∀ j : Fin n,
    gemmCellCheck model cfg (gemmPairs A B i j) C[i.val][j.val] = true)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.Regression.analysis_improves_minimal_static](Regression/GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.gemm_certificate_rejects](Regression/GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_certifies_all_profiles](Regression/GemmExtensions.md#decl-04b959ba551a2db5), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed)

</details>

</details>

<a id="decl-3d79dbcc8fc2e521"></a>

<details>
<summary><code>TensorCore.gemmCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L198)

```lean
/-- A successful certificate guarantees every logical output exists and meets a
uniform error bound. Neither model acceptance nor a trace is a premise. -/
theorem gemmCheck_sound (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : gemmCheck model cfg A B C = true) (i : Fin m) (j : Fin n) :
    ∃ cell z, (gemm model A B C)[i.val][j.val] = .ok cell ∧
      (gemmIdeal A B C)[i.val][j.val] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError model cfg k := by
  have hc := of_decide_eq_true h i j
  obtain ⟨cell, products, hr, hp, hv, he⟩ := gemmCellCheck_sound model cfg _ _ hc
  refine ⟨cell, cell.initial.value + products, ?_, ?_, ?_⟩
  · rwa [gemm_entry]
  · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]
  · simpa using he
```

**Supporting proofs:** [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_check_sound](Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.Regression.certified_tiny](Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3)

</details>

</details>

<a id="decl-3500b8a4ffeefc9e"></a>

<details>
<summary><code>TensorCore.matrixAbsSum</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L212)

```lean
/-- Sum of absolute entries, the entrywise 1-norm (not the induced column norm). -/
def matrixAbsSum (A : DenseMatrix ℚ m n) : ℚ :=
  sumQ (List.ofFn fun i : Fin m => sumQ (List.ofFn fun j : Fin n => absQ A[i.val][j.val]))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.report](Cli/Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.ExtendedAnalysis.nativeReport](Cli/ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.report](Cli/NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](Cli/PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed)

</details>

</details>

<a id="decl-485a6ec947a4e04d"></a>

<details>
<summary><code>TensorCore.matrixAbsSum_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L215)

```lean
theorem matrixAbsSum_bound (A : DenseMatrix ℚ m n) (E : ℚ)
    (h : ∀ i : Fin m, ∀ j : Fin n, absQ A[i.val][j.val] ≤ E) :
    matrixAbsSum A ≤ (m : ℚ) * (n : ℚ) * E := by
  have row : ∀ i : Fin m, sumQ (List.ofFn fun j : Fin n => absQ A[i.val][j.val]) ≤ (n : ℚ) * E := by
    intro i
    have hb := sumQ_map_le (List.finRange n) (fun j => absQ A[i.val][j.val]) E
      (fun j _ => h i j)
    simpa [List.finRange, List.map_ofFn, Function.comp_def] using hb
  have hb := sumQ_map_le (List.finRange m)
    (fun i => sumQ (List.ofFn fun j : Fin n => absQ A[i.val][j.val])) ((n : ℚ) * E)
    (fun i _ => row i)
  simpa [matrixAbsSum, List.finRange, List.map_ofFn, Function.comp_def, Rat.mul_assoc] using hb
```

**Supporting proofs:** [TensorCore.sumQ_map_le](../Core/Sum.md#decl-02931053452cdfec)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.gemmAnalysisCheck_matrix_error](Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmCheck_matrix_error](Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed)

</details>

</details>

<a id="decl-fdf1144ac6e97ba3"></a>

<details>
<summary><code>TensorCore.gemmCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/Bounds.lean#L230)

```lean
/-- Any matrix of the actual output values differs from the exact original-input
ideal by at most m*n times the input-derived entry bound in entrywise 1-norm. -/
theorem gemmCheck_matrix_error (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : gemmCheck model cfg A B C = true) (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * gemmStaticError model cfg k := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound model cfg A B C h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he
```

**Supporting proofs:** [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
