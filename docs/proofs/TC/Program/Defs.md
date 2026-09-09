# TensorCore.TC.Program.Defs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f76df1e9b7515342"></a>

<details>
<summary><code>TensorCore.BlockOperands</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L8)

```lean
/-- Group size and operand width are checked by the type of each call. -/
structure BlockOperands (p : Profile) where
  values : List (p.Word × p.Word)
  shape : values.length = p.products
  deriving Repr
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.BlockOperands.ofNats](Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.input_count](DotProduct.md#decl-36196a2e48524d8d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.PaperSpec.partitionExact_inputs_chunks](../../Gemm/Specification/GemmEquivalence.md#decl-2c86a9b78704d3ca), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.inputs_ofGroups](../Examples/BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.ofGroups](../Examples/BoundedDot.md#decl-1171c93b23baca97), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Regression.partition_order_changes_output](../Regression/DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.partition_original_order](../Regression/DotProduct.md#decl-3e07931106d2b633), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmBlocks_count](../../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmInstructions_shape](../../Gemm/Defs.md#decl-863019b6c0164a66), [TensorCore.nativeBlocks_shape](../../Gemm/NativeGemm.md#decl-7c945534c2fd32b9), [TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.partitionExact](Partition.md#decl-4082e3bf596a58d7), [TensorCore.partitionExact_count](Partition.md#decl-f23e6df7073e6ba8), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.runLocated](Report.md#decl-df432b3ff1fa37ac), [TensorCore.runLocated_erases](Report.md#decl-8b5841076d4639dc), [TensorCore.simulateGemmCell_count](../../Gemm/Defs.md#decl-fa30d201f6e3a65f), [TensorCore.Regression.negativeGroup](../Regression/DotProduct.md#decl-5e99e7be18050b0d), [TensorCore.Regression.orderedDot](../Regression/DotProduct.md#decl-2d5428af12680101), [TensorCore.Regression.originalPairs](../Regression/DotProduct.md#decl-aab28c957a084cba), [TensorCore.Regression.tinyGroup](../Regression/DotProduct.md#decl-9388f5b4a9ce0d5b)

</details>

</details>

<a id="decl-6720fa7bd1adb1d0"></a>

<details>
<summary><code>TensorCore.BlockOperands.ofNats</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L14)

```lean
/-- Literal construction checks range before converting natural numbers to words. -/
def BlockOperands.ofNats {p : Profile} (values : List (ℕ × ℕ))
    (shape : values.length = p.products)
    (_fits : values.all (fun (a, b) => a < 2 ^ p.input.width && b < 2 ^ p.input.width) = true) :
    BlockOperands p :=
  ⟨values.map (fun (a, b) => (BitVec.ofNat _ a, BitVec.ofNat _ b)), by simpa using shape⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cancellationProgram](../Regression/Programs.md#decl-a1fe1bb6bc11495c), [TensorCore.Regression.cycleBody](../Regression/Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.lossyProgram](../Regression/Certification.md#decl-051cf35b9a4ff28d), [TensorCore.Regression.nestedProgram](../Regression/Programs.md#decl-1a76bee30a7c4624), [TensorCore.Regression.rangeProgram](../Regression/Programs.md#decl-613c4339f6d2f7e4), [TensorCore.Regression.rejectedProgram](../Regression/Programs.md#decl-f11f488210178f17), [TensorCore.Regression.repeatedProgram](../Regression/Programs.md#decl-4b3c8f635166e817), [TensorCore.Regression.smallBody](../Regression/Application.md#decl-816e23b02227fd68), [TensorCore.Regression.symbolicSyntax](../Regression/Programs.md#decl-dcfb59eb2d24ca6e), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.Regression.unexecutedProgram](../Regression/Programs.md#decl-3b55d7944252fd7b)

</details>

</details>

<a id="decl-7b1d24eebe1ce285"></a>

<details>
<summary><code>TensorCore.checkedF32</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L20)

```lean
def checkedF32 (value : ℕ) (_fits : value < 2 ^ 32) : F32 := BitVec.ofNat 32 value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4b38eaa245ee464e"></a>

<details>
<summary><code>TensorCore.SourceSite</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L22)

```lean
structure SourceSite where
  file : String := "<Lean term>"
  line : ℕ := 0
  column : ℕ := 0
  label : String := "block"
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CallFailure](Report.md#decl-bfac1adcea94ebb6), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.Program.inputs_ofGroups](../Examples/BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.Program.ofGroups](../Examples/BoundedDot.md#decl-1171c93b23baca97), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.ProgramReport](Report.md#decl-bed00bf44170d962), [TensorCore.Regression.cancellationProgram](../Regression/Programs.md#decl-a1fe1bb6bc11495c), [TensorCore.Regression.cancellation_program_report](../Regression/Programs.md#decl-8810fd71ca8fd96b), [TensorCore.Regression.cycleBody](../Regression/Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.lossyProgram](../Regression/Certification.md#decl-051cf35b9a4ff28d), [TensorCore.Regression.nestedProgram](../Regression/Programs.md#decl-1a76bee30a7c4624), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rangeProgram](../Regression/Programs.md#decl-613c4339f6d2f7e4), [TensorCore.Regression.rejectedProgram](../Regression/Programs.md#decl-f11f488210178f17), [TensorCore.Regression.rejected_program_location](../Regression/Programs.md#decl-7e373e5951755270), [TensorCore.Regression.repeatedProgram](../Regression/Programs.md#decl-4b3c8f635166e817), [TensorCore.Regression.repeated_program_report](../Regression/Programs.md#decl-1a6cc1692e976cd7), [TensorCore.Regression.smallBody](../Regression/Application.md#decl-816e23b02227fd68), [TensorCore.Regression.symbolicSyntax](../Regression/Programs.md#decl-dcfb59eb2d24ca6e), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.Regression.unexecutedProgram](../Regression/Programs.md#decl-3b55d7944252fd7b)

</details>

</details>

<a id="decl-36cafa797c1bf521"></a>

<details>
<summary><code>TensorCore.LocatedBlock</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L29)

```lean
structure LocatedBlock (p : Profile) where
  site : SourceSite
  operands : BlockOperands p
  deriving Repr
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.SourceSite](Defs.md#decl-4b38eaa245ee464e)

<details>
<summary>Used by</summary>

[TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.inputs_ofGroups](../Examples/BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.ofGroups](../Examples/BoundedDot.md#decl-1171c93b23baca97), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Regression.cancellationProgram](../Regression/Programs.md#decl-a1fe1bb6bc11495c), [TensorCore.Regression.cycleBody](../Regression/Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.lossyProgram](../Regression/Certification.md#decl-051cf35b9a4ff28d), [TensorCore.Regression.nestedProgram](../Regression/Programs.md#decl-1a76bee30a7c4624), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.rangeProgram](../Regression/Programs.md#decl-613c4339f6d2f7e4), [TensorCore.Regression.rejectedProgram](../Regression/Programs.md#decl-f11f488210178f17), [TensorCore.Regression.repeatedProgram](../Regression/Programs.md#decl-4b3c8f635166e817), [TensorCore.Regression.smallBody](../Regression/Application.md#decl-816e23b02227fd68), [TensorCore.Regression.symbolicSyntax](../Regression/Programs.md#decl-dcfb59eb2d24ca6e), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.Regression.unexecutedProgram](../Regression/Programs.md#decl-3b55d7944252fd7b), [TensorCore.runLocated](Report.md#decl-df432b3ff1fa37ac), [TensorCore.runLocated_erases](Report.md#decl-8b5841076d4639dc)

</details>

</details>

<a id="decl-181bc2fc467c7372"></a>

<details>
<summary><code>TensorCore.Program</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L36)

```lean
/-- First program fragment: fixed operands, explicit order, and bounded repetition.
The profile is a type parameter; all calls use its input width and group size. -/
inductive Program (p : Profile) where
  | skip
  | block (call : LocatedBlock p)
  | seq (first second : Program p)
  | repeat (count : ℕ) (body : Program p)
  deriving Repr
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a)

<details>
<summary>Used by</summary>

[TensorCore.Program.Accurate](CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.Correct](Defs.md#decl-e6d61788143fb846), [TensorCore.Program.VC](Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610), [TensorCore.Program.certificateReport](CertifiedProgram.md#decl-6b9db8fb5b4cf559), [TensorCore.Program.certificateReport_passes](CertifiedProgram.md#decl-176831b6bd792310), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.inputs_ofGroups](../Examples/BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.ofGroups](../Examples/BoundedDot.md#decl-1171c93b23baca97), [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.repeat_accurate_of_scales](Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.Program.staticCertificate](CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Program.staticErrorBudget](CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.cancellationProgram](../Regression/Programs.md#decl-a1fe1bb6bc11495c), [TensorCore.Regression.cycleBody](../Regression/Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.empty_nonfinite_certificate_refused](../Regression/Certification.md#decl-a316f83bd5fdce64), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.finite_empty_zero_tolerance](../Regression/Certification.md#decl-523e00be539059c9), [TensorCore.Regression.lossyProgram](../Regression/Certification.md#decl-051cf35b9a4ff28d), [TensorCore.Regression.nestedProgram](../Regression/Programs.md#decl-1a76bee30a7c4624), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rangeProgram](../Regression/Programs.md#decl-613c4339f6d2f7e4), [TensorCore.Regression.rejectedProgram](../Regression/Programs.md#decl-f11f488210178f17), [TensorCore.Regression.rejected_program_vc](../Regression/Programs.md#decl-06af08619320969d), [TensorCore.Regression.repeatedProgram](../Regression/Programs.md#decl-4b3c8f635166e817), [TensorCore.Regression.smallBody](../Regression/Application.md#decl-816e23b02227fd68), [TensorCore.Regression.symbolicSyntax](../Regression/Programs.md#decl-dcfb59eb2d24ca6e), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.Regression.symbolic_cycle_vc](../Regression/Programs.md#decl-5719553e703a7aad), [TensorCore.Regression.unexecutedProgram](../Regression/Programs.md#decl-3b55d7944252fd7b), [TensorCore.boundedDot](../Examples/BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.small_repeat_accurate](../Examples/BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-eb2acff2f837428b"></a>

<details>
<summary><code>TensorCore.repeatList</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L43)

```lean
def repeatList (xs : List α) : ℕ → List α
  | 0 => []
  | n + 1 => xs ++ repeatList xs n
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610), [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.repeat_accurate_of_scales](Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.map_repeatList](Loops.md#decl-df22b932498a9118), [TensorCore.mem_of_mem_repeatList](Bounds/Loops.md#decl-65c47eca9cfd9bef), [TensorCore.repeatList_length](Bounds/Loops.md#decl-24743b1b0c722725), [TensorCore.runBlocks_repeat_invariant](Loops.md#decl-e3ab49fcf2fa1da9), [TensorCore.sumQ_repeatList_zero](Loops.md#decl-1a78835f34f88e04)

</details>

</details>

<a id="decl-e6562fd402604610"></a>

<details>
<summary><code>TensorCore.Program.blocks</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L48)

```lean
/-- The ordered invocation schedule is inspectable independently of syntax. -/
def Program.blocks {p : Profile} : Program p → List (LocatedBlock p)
  | .skip => []
  | .block call => [call]
  | .seq first second => first.blocks ++ second.blocks
  | .repeat n body => repeatList body.blocks n
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.repeatList](Defs.md#decl-eb2acff2f837428b)

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.inputs_ofGroups](../Examples/BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89)

</details>

</details>

<a id="decl-bd3749a183ce7223"></a>

<details>
<summary><code>TensorCore.Program.inputs</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L54)

```lean
def Program.inputs {p : Profile} (pr : Program p) : List (List (p.Word × p.Word)) :=
  pr.blocks.map fun call => call.operands.values
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610)

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.certificateReport](CertifiedProgram.md#decl-6b9db8fb5b4cf559), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.inputs_ofGroups](../Examples/BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.Program.inputs_repeat](Loops.md#decl-7697e13eef655896), [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.repeat_accurate_of_scales](Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.Program.staticCertificate](CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Program.staticErrorBudget](CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Regression.cancellation_program_inputs](../Regression/Programs.md#decl-97fb7b36b1f30fd8), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.Regression.symbolic_syntax_inputs](../Regression/Programs.md#decl-97006754bc720027), [TensorCore.boundedDot_accurate](../Examples/BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_group_limit](../Examples/BoundedDot.md#decl-1753bf8bca4d3679), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_inputs](../Examples/BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.small_repeat_accurate](../Examples/BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-7a1c9df214179ea0"></a>

<details>
<summary><code>TensorCore.Program.run</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L57)

```lean
def Program.run {p : Profile} (pr : Program p) (c : F32) : Except ModelError (List BlockTrace) :=
  runBlocks p c pr.inputs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0)

<details>
<summary>Used by</summary>

[TensorCore.Program.Accurate](CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.Correct](Defs.md#decl-e6d61788143fb846), [TensorCore.Program.VC](Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.changing_loop_has_rounding_error](../Regression/Application.md#decl-3ad8e32bd2a7f1a0), [TensorCore.Regression.cycle_execution](../Regression/Programs.md#decl-6ade3ce34965b8a4), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rejected_program_vc](../Regression/Programs.md#decl-06af08619320969d), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6)

</details>

</details>

<a id="decl-5d908ac035267580"></a>

<details>
<summary><code>TensorCore.idealProducts</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L61)

```lean
/-- Direct input-bit ideal sum. No model output, alignment, or residual is consulted. -/
def idealProducts (p : Profile) (ps : List (p.Word × p.Word)) : Option ℚ :=
  (prepareProducts p ps).map fun qs => sumQ (qs.map fun (a, b) => a.value * b.value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.Regression.partition_error_contract](../Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_order_changes_output](../Regression/DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.analyzeGemm_entry_sound](../../Gemm/Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeNativeGemm_entry_sound](../../Gemm/NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.checkConvertedCell_sound](../../Gemm/ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroup_sound](GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeScaledCell_sound](../../Gemm/NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkScaledCell_sound](../../Gemm/ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.convertGemmInput_products_error](../../Gemm/InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](../../Gemm/TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertedGemmCheck_source_sound](../../Gemm/InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](../../Gemm/TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.entryFamily_cell_sound](../../Gemm/EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.evalBlock_idealProducts](Defs.md#decl-18057f2f716ca715), [TensorCore.evalBlock_static](../StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_sound](../../Gemm/Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmBlocks_ideal](../../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmCellCheck_product_bound](../../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck_sound](../../Gemm/Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmIdeal](../../Gemm/Defs.md#decl-1f55842952d81ccc), [TensorCore.gemm_entry_error](../../Gemm/Defs.md#decl-ca7357044cdac1e9), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealContributions_abs_le](Bounds/Scales.md#decl-d642c7a05f1cb663), [TensorCore.idealContributions_cons](../StaticBudget.md#decl-0916105e5f507bb2), [TensorCore.idealContributions_cons_some](StaticCertificate.md#decl-e1771047163e04a5), [TensorCore.idealContributions_flatten](DotProduct.md#decl-9ddff146f804b161), [TensorCore.idealProducts_abs_le_of_scale](Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.idealProducts_append](DotProduct.md#decl-623f08595b227aca), [TensorCore.idealProducts_of_prepareProducts](../StaticBudget.md#decl-46af87ad95b9feb9), [TensorCore.idealProducts_padFp16Pairs](Partition.md#decl-78a2a3efb15b0ed0), [TensorCore.nativeAnalysisCheck_sound](../../Gemm/NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeBlocks_ideal](../../Gemm/NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativeGemmIdeal](../../Gemm/NativeGemm.md#decl-b9b24fce99a6a8c6), [TensorCore.native_zero_products](../../Gemm/NativeGemm.md#decl-f24f4761f46023ad), [TensorCore.partialSumsCheck](StaticCertificate.md#decl-3830663114f133c4), [TensorCore.partialSumsCheck_sound](StaticCertificate.md#decl-df9e82cd1ad7c2d7), [TensorCore.runBlocks_idealContributions](Defs.md#decl-a06c7915ecf4c91c), [TensorCore.runBlocks_of_scale_bound](Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_static](../StaticBudget.md#decl-31af1b208da9e431), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.scaledGemmCellCheck_sound](../../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCellIdeal](../../Gemm/ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.scaledGemm_entry_error](../../Gemm/ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.sourceGemmProducts_eq_idealProducts](../../Gemm/InputBounds.md#decl-1c676a2d69d32e7d), [TensorCore.gemm_ideal_profile](../../Gemm/Defs.md#decl-d3150262da998973), [TensorCore.ideal_zero_pairs](Partition.md#decl-19d8614714352936)

</details>

</details>

<a id="decl-a2ade4bef59291e3"></a>

<details>
<summary><code>TensorCore.idealContributions</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L64)

```lean
def idealContributions (p : Profile) : List (List (p.Word × p.Word)) → Option ℚ
  | [] => some 0
  | ps :: rest => do return (← idealProducts p ps) + (← idealContributions p rest)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580)

<details>
<summary>Used by</summary>

[TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.OrderedPartition.uncorrected_error](DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Regression.static_certificate_applied](../Regression/StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_consistent](../Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.checkGemmCell_sound](../../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroups_sound](GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell_sound](../../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.conforms_uncorrected_error](../Instruction.md#decl-89203da1fcc0b32e), [TensorCore.gemmBlocks_ideal](../../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmCellCheck_product_bound](../../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.idealContributions_abs_le](Bounds/Scales.md#decl-d642c7a05f1cb663), [TensorCore.idealContributions_cons](../StaticBudget.md#decl-0916105e5f507bb2), [TensorCore.idealContributions_cons_some](StaticCertificate.md#decl-e1771047163e04a5), [TensorCore.idealContributions_flatten](DotProduct.md#decl-9ddff146f804b161), [TensorCore.nativeBlocks_ideal](../../Gemm/NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.partialSumsCheck_sound](StaticCertificate.md#decl-df9e82cd1ad7c2d7), [TensorCore.runBlocks_idealContributions](Defs.md#decl-a06c7915ecf4c91c), [TensorCore.runBlocks_of_scale_bound](Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_static](../StaticBudget.md#decl-31af1b208da9e431), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-1eb3ac3acdd9bcff"></a>

<details>
<summary><code>TensorCore.Program.ideal</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L68)

```lean
def Program.ideal {p : Profile} (pr : Program p) (c : F32) : Option ℚ := do
  return (← value32 c) + (← idealContributions p pr.inputs)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Program.Accurate](CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.Correct](Defs.md#decl-e6d61788143fb846), [TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.changing_loop_has_rounding_error](../Regression/Application.md#decl-3ad8e32bd2a7f1a0), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01)

</details>

</details>

<a id="decl-18057f2f716ca715"></a>

<details>
<summary><code>TensorCore.evalBlock_idealProducts</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L71)

```lean
theorem evalBlock_idealProducts {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : idealProducts p x.products = some t.block.exactProducts := by
  have hp := evalBlock_prepared h
  unfold prepare at hp
  cases hc : decode32 x.c with
  | none => simp [hc] at hp
  | some c =>
    cases hps : prepareProducts p x.products with
    | none => simp [hc, hps] at hp
    | some ps =>
      simp [hc, hps] at hp
      rw [← hp]
      simp [idealProducts, hps, PreparedBlock.exactProducts]
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](../StageResiduals.md#decl-7b1107ad8e7189d9)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.prepare](../Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_idealContributions](Defs.md#decl-a06c7915ecf4c91c)

</details>

</details>

<a id="decl-a06c7915ecf4c91c"></a>

<details>
<summary><code>TensorCore.runBlocks_idealContributions</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L85)

```lean
theorem runBlocks_idealContributions (p : Profile) (c : F32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p c ps = .ok ts) :
    idealContributions p ps = some (sumQ (ts.map fun t => t.block.exactProducts)) := by
  induction ps generalizing c ts with
  | nil => simp [runBlocks] at h; cases h; rfl
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        cases h
        simp [idealContributions, evalBlock_idealProducts he, ih t.output.bits rest hr, sumQ]
```

**Supporting proofs:** [TensorCore.evalBlock_idealProducts](Defs.md#decl-18057f2f716ca715)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da)

</details>

</details>

<a id="decl-c675b351c6aa5e02"></a>

<details>
<summary><code>TensorCore.Program.recovery</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L102)

```lean
theorem Program.recovery {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (h : pr.run initial.bits = .ok ts) :
    pr.ideal initial.bits = some (recoveredSchedule initial ts) := by
  have hc := runBlocks_idealContributions p initial.bits pr.inputs ts h
  have hl := runBlocks_residual_ledger p initial pr.inputs ts h
  simp only [Program.ideal, value32, initial.valid, Option.map_some, hc]
  change some (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) = _
  rw [hl]; rfl
```

**Supporting proofs:** [TensorCore.runBlocks_idealContributions](Defs.md#decl-a06c7915ecf4c91c), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactProducts](../Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.uncorrected_error](ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0)

</details>

</details>

<a id="decl-8bdb929e75d195cf"></a>

<details>
<summary><code>TensorCore.Program.VC</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L113)

```lean
/-- Executable sufficient conditions: finite initial encoding, successful calls,
and an in-range final exact sum. Failure is not a hardware counterexample. -/
def Program.VC {p : Profile} (pr : Program p) (c : F32) : Prop :=
  match finite32 c with
  | none => False
  | some initial => match pr.run c with
    | .error _ => False
    | .ok ts => absQ (recoveredSchedule initial ts) ≤ maxFinite32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51)

<details>
<summary>Used by</summary>

[TensorCore.Program.repeat_vc_of_cycle](Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rejected_program_vc](../Regression/Programs.md#decl-06af08619320969d), [TensorCore.Regression.symbolic_cycle_vc](../Regression/Programs.md#decl-5719553e703a7aad)

</details>

</details>

<a id="decl-e6d61788143fb846"></a>

<details>
<summary><code>TensorCore.Program.Correct</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L127)

```lean
/-- Total correctness of execution and correction against the direct input sum. -/
def Program.Correct {p : Profile} (pr : Program p) (c : F32) : Prop :=
  ∃ (initial : Finite32) (ts : List BlockTrace) (z : ℚ) (b : F32),
    initial.bits = c ∧ pr.run c = .ok ts ∧ pr.ideal c = some z ∧
    recoveredSchedule initial ts = z ∧ correctedSchedule initial ts = some b ∧
    NearestEven32 z b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51)

<details>
<summary>Used by</summary>

[TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0)

</details>

</details>

<a id="decl-08ec57f1c290b572"></a>

<details>
<summary><code>TensorCore.finite32_bits</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L133)

```lean
theorem finite32_bits {c : F32} {initial : Finite32} (h : finite32 c = some initial) :
    initial.bits = c := by
  unfold finite32 at h
  split at h
  · contradiction
  · cases Option.some.inj h; rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeProductCell_eq_independent](../../Gemm/Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.scaledGemm_paper_contract](../../Gemm/Specification/GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.PaperSpec.simulateGemmCell_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-62707c4cb8f2dc7c), [TensorCore.Program.vc_sound](Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.gemm_entry_error](../../Gemm/Defs.md#decl-ca7357044cdac1e9), [TensorCore.zero_products_passthrough](../Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.finite32_value](../../Gemm/ScaledGemm.md#decl-38cc18d9d963e536)

</details>

</details>

<a id="decl-6bd1edcfd2f397a0"></a>

<details>
<summary><code>TensorCore.Program.vc_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Defs.lean#L141)

```lean
/-- Soundness of the first program checking layer. Metaprograms only apply this theorem. -/
theorem Program.vc_sound {p : Profile} (pr : Program p) (c : F32) (h : pr.VC c) :
    pr.Correct c := by
  unfold Program.VC at h
  cases hi : finite32 c with
  | none => simp [hi] at h
  | some initial =>
    cases he : pr.run c with
    | error e => simp [hi, he] at h
    | ok ts =>
      simp only [hi, he] at h
      have hb := finite32_bits hi
      have hr := pr.recovery initial ts (by simpa [hb] using he)
      rw [hb] at hr
      obtain ⟨b, hc, hn⟩ := round32_nearestEven_correct (recoveredSchedule initial ts) h
      exact ⟨initial, ts, recoveredSchedule initial ts, b, hb, he, hr, rfl, hc, hn⟩
```

**Supporting proofs:** [TensorCore.Program.recovery](Defs.md#decl-c675b351c6aa5e02), [TensorCore.finite32_bits](Defs.md#decl-08ec57f1c290b572), [TensorCore.round32_nearestEven_correct](../../Core/CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Correct](Defs.md#decl-e6d61788143fb846), [TensorCore.Program.VC](Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
