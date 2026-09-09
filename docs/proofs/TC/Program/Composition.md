# TensorCore.TC.Program.Composition

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-127eff85c273b0b9"></a>

<details>
<summary><code>TensorCore.foldState</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L8)

```lean
/-- Execute a fixed-input schedule; the state type can be encoded floating-point values. -/
def foldState (step : σ → α → σ) : σ → List α → σ
  | s, [] => s
  | s, a :: as => foldState step (step s a) as
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.foldLoss](Composition.md#decl-402eb1a88edf9b27), [TensorCore.fold_residual_ledger](Composition.md#decl-ff8ab9a0bbbddfad)

</details>

</details>

<a id="decl-402eb1a88edf9b27"></a>

<details>
<summary><code>TensorCore.foldLoss</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L12)

```lean
def foldLoss (step : σ → α → σ) (loss : σ → α → ℚ) : σ → List α → ℚ
  | _, [] => 0
  | s, a :: as => loss s a + foldLoss step loss (step s a) as
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.foldState](Composition.md#decl-127eff85c273b0b9)

<details>
<summary>Used by</summary>

[TensorCore.fold_residual_ledger](Composition.md#decl-ff8ab9a0bbbddfad)

</details>

</details>

<a id="decl-ff8ab9a0bbbddfad"></a>

<details>
<summary><code>TensorCore.fold_residual_ledger</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L17)

```lean
/-- Induction for arbitrary finite lists, with an explicit local contract. -/
theorem fold_residual_ledger
    (value : σ → ℚ) (step : σ → α → σ) (loss : σ → α → ℚ)
    (contribution : α → ℚ)
    (localLaw : ∀ s a, value s + contribution a = value (step s a) + loss s a)
    (s : σ) (as : List α) :
    value s + sumQ (as.map contribution) =
      value (foldState step s as) + foldLoss step loss s as := by
  induction as generalizing s with
  | nil => rfl
  | cons a as ih =>
    simp only [List.map_cons, sumQ, foldState, foldLoss]
    have h := localLaw s a
    have h' := ih (step s a)
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.foldLoss](Composition.md#decl-402eb1a88edf9b27), [TensorCore.foldState](Composition.md#decl-127eff85c273b0b9), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ce41b49b9dd434c2"></a>

<details>
<summary><code>TensorCore.EncodedChain</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L33)

```lean
/-- Every later c must be the decoded *encoded* output of the previous call. -/
def EncodedChain : Finite32 → List BlockTrace → Prop
  | _, [] => True
  | d, t :: ts => t.block.c = d.decoded ∧ EncodedChain t.output ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883)

<details>
<summary>Used by</summary>

[TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b)

</details>

</details>

<a id="decl-59a9e0884980f32b"></a>

<details>
<summary><code>TensorCore.lastOutput</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L37)

```lean
def lastOutput : Finite32 → List BlockTrace → Finite32
  | d, [] => d
  | _, t :: ts => lastOutput t.output ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.EncodedChain](Composition.md#decl-ce41b49b9dd434c2), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b)

<details>
<summary>Used by</summary>

[TensorCore.GemmCell.output](../../Gemm/Defs.md#decl-d8688321b8d2ae7f), [TensorCore.NativeGemmCell.output](../../Gemm/NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.PaperSpec.mapped_lastOutput](../../Gemm/Specification/GemmEquivalence.md#decl-6966179b65962514), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.Program.Accurate](CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Regression.changing_loop_has_rounding_error](../Regression/Application.md#decl-3ad8e32bd2a7f1a0), [TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.Regression.constructed_partition_tail](../Regression/DotProduct.md#decl-571ad9339f4b196c), [TensorCore.Regression.partition_error_contract](../Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_order_changes_output](../Regression/DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.static_certificate_applied](../Regression/StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_consistent](../Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.Regression.symbolic_cycle_vc](../Regression/Programs.md#decl-5719553e703a7aad), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.gemmCellCheck_sound](../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.lastOutput_append](Loops.md#decl-38277dabea23ed23), [TensorCore.lastOutput_bits](../Instruction.md#decl-922f2f0fa043267c), [TensorCore.nativeProductTrace_output](../../Gemm/NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.runBlocks_append](Loops.md#decl-2442f227fffe5cf3), [TensorCore.runBlocks_of_scale_bound](Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_repeat_invariant](Loops.md#decl-e3ab49fcf2fa1da9), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886), [TensorCore.runBlocks_static](../StaticBudget.md#decl-31af1b208da9e431), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.runGemmInstructions](../../Gemm/Defs.md#decl-fa58899497fedd29), [TensorCore.runGemmInstructions_blocks](../../Gemm/Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](../../Gemm/Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runGemmInstructions_count](../../Gemm/Defs.md#decl-f9db8f5ae7e28a9c), [TensorCore.runGemmInstructions_coverage](../../Gemm/Defs.md#decl-ebd5f42a485ed596), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69), [TensorCore.runBlocks_split](../../Gemm/Bounds.md#decl-296b305cc459bad8)

</details>

</details>

<a id="decl-775280e15ad44086"></a>

<details>
<summary><code>TensorCore.encoded_trace_ledger</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L42)

```lean
/-- Block-trace specialization of the ledger, with a checked encoded-boundary premise. -/
theorem encoded_trace_ledger (initial : Finite32) (ts : List BlockTrace)
    (chain : EncodedChain initial ts) :
    initial.value + sumQ (ts.map fun t => t.block.exactProducts) =
      (lastOutput initial ts).value + sumQ (ts.map BlockTrace.residual) := by
  induction ts generalizing initial with
  | nil => rfl
  | cons t ts ih =>
    obtain ⟨hc, ht⟩ := chain
    have h := returned_residual_identity t
    change t.block.c.value + t.block.exactProducts = t.output.value + t.residual at h
    rw [hc] at h
    have h' := ih t.output ht
    simp only [List.map_cons, sumQ, lastOutput]
    change initial.decoded.value + (t.block.exactProducts + _) = _
    change t.output.value + _ = _ at h'
    grind
```

**Supporting proofs:** [TensorCore.returned_residual_identity](../StageResiduals.md#decl-51c1f1398611023e)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.EncodedChain](Composition.md#decl-ce41b49b9dd434c2), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886)

</details>

</details>

<a id="decl-d4b070b6697e01f0"></a>

<details>
<summary><code>TensorCore.runBlocks</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L61)

```lean
/-- Runnable schedule under one profile. Each call receives the bits returned by its
predecessor. -/
def runBlocks (p : Profile) :
    F32 → List (List (p.Word × p.Word)) → Except ModelError (List BlockTrace)
  | _, [] => .ok []
  | c, ps :: rest =>
    match evalBlock (p := p) ⟨ps, c⟩ with
    | .error e => .error e
    | .ok t => match runBlocks p t.output.bits rest with
      | .error e => .error e
      | .ok ts => .ok (t :: ts)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.run](../Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.run_blocks](../Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](../Instruction.md#decl-812320a0c4dc3b22), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.PaperSpec.Controls.group_reversal_detected](../../Regression/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](../../Gemm/Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeProductCell_eq_independent](../../Gemm/Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.runBlocks_eq_paper](../Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.schedule_last_eq_paper](../Specification/Composition.md#decl-551846c5cac8f668), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Regression.empty_dot_finite_policy](../Regression/PublicDomains.md#decl-65fac3dfdaf0d584), [TensorCore.Regression.static_certificate_applied](../Regression/StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_consistent](../Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.fp16Fp32_schedule_machine_eq](DotProduct.md#decl-1fc40acc7fd9825c), [TensorCore.gemmCellCheck_sound](../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.nativeGemmCell](../../Gemm/NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.runBlocksMachine_eq](DotProduct.md#decl-69afa0bf303103ec), [TensorCore.runBlocks_append](Loops.md#decl-2442f227fffe5cf3), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b), [TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_idealContributions](Defs.md#decl-a06c7915ecf4c91c), [TensorCore.runBlocks_length](ErrorBounds.md#decl-60cd89558816c4b8), [TensorCore.runBlocks_of_scale_bound](Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_repeat_invariant](Loops.md#decl-e3ab49fcf2fa1da9), [TensorCore.runBlocks_residual_budget](ErrorBounds.md#decl-cc967a2bb9a08415), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886), [TensorCore.runBlocks_static](../StaticBudget.md#decl-31af1b208da9e431), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runBlocks_zero_groups](../Instruction.md#decl-90841dab8cd37139), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runGemmInstructions_blocks](../../Gemm/Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](../../Gemm/Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runLocated_erases](Report.md#decl-8b5841076d4639dc), [TensorCore.runV100](Composition.md#decl-db0ac9bfd91eb790), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.single_group_output](../Instruction.md#decl-7737e9081be84095), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69), [TensorCore.runBlocks_split](../../Gemm/Bounds.md#decl-296b305cc459bad8)

</details>

</details>

<a id="decl-db0ac9bfd91eb790"></a>

<details>
<summary><code>TensorCore.runV100</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L71)

```lean
abbrev runV100 := runBlocks v100F16F32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_order_changes_output](../Regression/DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.twoBlockCorrection](../Regression/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](../Regression/Composition.md#decl-27d6915f955ce3fa)

</details>

</details>

<a id="decl-4a9736f9c5dc068b"></a>

<details>
<summary><code>TensorCore.runBlocks_chain</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L73)

```lean
theorem runBlocks_chain (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word)))
    (ts : List BlockTrace) (h : runBlocks p initial.bits ps = .ok ts) :
    EncodedChain initial ts := by
  induction ps generalizing initial ts with
  | nil => simp [runBlocks] at h; cases h; trivial
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, initial.bits⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        cases h
        constructor
        · have hc := evalBlock_c he
          change decode32 initial.bits = some t.block.c at hc
          rw [initial.valid] at hc
          exact (Option.some.inj hc).symm
        · exact ih t.output rest hr
```

**Supporting proofs:** [TensorCore.evalBlock_c](../StageResiduals.md#decl-02be11fb27fe1a11)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EncodedChain](Composition.md#decl-ce41b49b9dd434c2), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886)

</details>

</details>

<a id="decl-c73efd4921810886"></a>

<details>
<summary><code>TensorCore.runBlocks_residual_ledger</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Composition.lean#L96)

```lean
/-- Every successful executable schedule inherits the encoded-boundary ledger. -/
theorem runBlocks_residual_ledger (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p initial.bits ps = .ok ts) :
    initial.value + sumQ (ts.map fun t => t.block.exactProducts) =
      (lastOutput initial ts).value + sumQ (ts.map BlockTrace.residual) :=
  encoded_trace_ledger initial ts (runBlocks_chain p initial ps ts h)
```

**Supporting proofs:** [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da)

</details>

</details>
