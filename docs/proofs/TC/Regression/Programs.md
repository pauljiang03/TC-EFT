# TensorCore.TC.Regression.Programs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a1fe1bb6bc11495c"></a>

<details>
<summary><code>TensorCore.Regression.cancellationProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L12)

```lean
def cancellationProgram : Program v100F16F32 := tc%{
  block "R3" [(0x3e00, 0x3d00), (0x3e00, 0x3d00),
    (0x3e00, 0x3d00), (0x3e00, 0x3d00)];
  block "subtract 8.5" [(0xc000, 0x4400), (0xb800, 0x3c00), (0, 0), (0, 0)];
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cancellation_program_inputs](Programs.md#decl-97fb7b36b1f30fd8), [TensorCore.Regression.cancellation_program_report](Programs.md#decl-8810fd71ca8fd96b)

</details>

</details>

<a id="decl-97fb7b36b1f30fd8"></a>

<details>
<summary><code>TensorCore.Regression.cancellation_program_inputs</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L19)

```lean
/-- Inspect the elaborated operand order as well as checking the generated theorem. -/
theorem cancellation_program_inputs : cancellationProgram.inputs =
    [r3.products, cancelEightAndHalf] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.Regression.cancelEightAndHalf](Composition.md#decl-2a94d3f3b7353f49), [TensorCore.Regression.cancellationProgram](Programs.md#decl-a1fe1bb6bc11495c), [TensorCore.Regression.r3](Cases.md#decl-0419be5c38ea4116), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8810fd71ca8fd96b"></a>

<details>
<summary><code>TensorCore.Regression.cancellation_program_report</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L24)

```lean
theorem cancellation_program_report :
    (cancellationProgram.report 0x3f7fffff).map (fun r =>
      (r.outputBits, r.ideal, r.recovered, r.correctedBits)) =
    .ok ([0x4107ffff, 0xb5800000], some (-1 / 16777216), -1 / 16777216, some 0xb3800000) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CallFailure](../Program/Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Program.report](../Program/Report.md#decl-153a1a264738ed2c), [TensorCore.ProgramFailure](../Program/Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](../Program/Report.md#decl-bed00bf44170d962), [TensorCore.Regression.cancellationProgram](Programs.md#decl-a1fe1bb6bc11495c), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4b3c8f635166e817"></a>

<details>
<summary><code>TensorCore.Regression.repeatedProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L30)

```lean
def repeatedProgram : Program v100F16F32 := tc%{
  repeat (3) {
    block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cycleBody](Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.nestedProgram](Programs.md#decl-1a76bee30a7c4624), [TensorCore.Regression.rangeProgram](Programs.md#decl-613c4339f6d2f7e4), [TensorCore.Regression.repeated_program_report](Programs.md#decl-1a6cc1692e976cd7), [TensorCore.Regression.symbolicSyntax](Programs.md#decl-dcfb59eb2d24ca6e)

</details>

</details>

<a id="decl-1a6cc1692e976cd7"></a>

<details>
<summary><code>TensorCore.Regression.repeated_program_report</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L38)

```lean
theorem repeated_program_report :
    (repeatedProgram.report 0).map (fun r => (r.outputBits, r.ideal, r.correctedBits)) =
    .ok ([0x3f800000, 0x40000000, 0x40400000], some 3, some 0x40400000) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CallFailure](../Program/Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Program.report](../Program/Report.md#decl-153a1a264738ed2c), [TensorCore.ProgramFailure](../Program/Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](../Program/Report.md#decl-bed00bf44170d962), [TensorCore.Regression.repeatedProgram](Programs.md#decl-4b3c8f635166e817), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1a76bee30a7c4624"></a>

<details>
<summary><code>TensorCore.Regression.nestedProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L43)

```lean
def nestedProgram : Program v100F16F32 := tc%{
  repeat (2) {
    repeat (2) {
      block "inner add" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
    }
    block "outer subtract" [(0xbc00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Regression.repeatedProgram](Programs.md#decl-4b3c8f635166e817), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cycleBody](Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.nested_program_order](Programs.md#decl-f9d0e3f87f9f071f)

</details>

</details>

<a id="decl-f9d0e3f87f9f071f"></a>

<details>
<summary><code>TensorCore.Regression.nested_program_order</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L52)

```lean
theorem nested_program_order :
    nestedProgram.blocks.map (fun c => c.site.label) =
      ["inner add", "inner add", "outer subtract", "inner add", "inner add", "outer subtract"] ∧
    (nestedProgram.report 0).map (fun r => (r.outputBits, r.ideal, r.correctedBits)) =
      .ok ([0x3f800000, 0x40000000, 0x3f800000, 0x40000000, 0x40400000, 0x40000000],
        some 2, some 0x40000000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CallFailure](../Program/Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Program.blocks](../Program/Defs.md#decl-e6562fd402604610), [TensorCore.Program.report](../Program/Report.md#decl-153a1a264738ed2c), [TensorCore.ProgramFailure](../Program/Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](../Program/Report.md#decl-bed00bf44170d962), [TensorCore.Regression.nestedProgram](Programs.md#decl-1a76bee30a7c4624), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f11f488210178f17"></a>

<details>
<summary><code>TensorCore.Regression.rejectedProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L59)

```lean
def rejectedProgram : Program v100F16F32 := tc%{
  block "finite call" [(0, 0), (0, 0), (0, 0), (0, 0)];
  repeat (2) {
    block "nonfinite operand" [(0x7c00, 0), (0, 0), (0, 0), (0, 0)];
  }
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.rejected_program_location](Programs.md#decl-7e373e5951755270), [TensorCore.Regression.rejected_program_vc](Programs.md#decl-06af08619320969d)

</details>

</details>

<a id="decl-06af08619320969d"></a>

<details>
<summary><code>TensorCore.Regression.rejected_program_vc</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L66)

```lean
theorem rejected_program_vc : ¬rejectedProgram.VC 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.VC](../Program/Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.run](../Program/Defs.md#decl-7a1c9df214179ea0), [TensorCore.Regression.rejectedProgram](Programs.md#decl-f11f488210178f17), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](../Program/Correction.md#decl-dd85a41a20883c51), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7e373e5951755270"></a>

<details>
<summary><code>TensorCore.Regression.rejected_program_location</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L68)

```lean
theorem rejected_program_location :
    (match rejectedProgram.report 0 with
      | .error (.call e) => some (e.site.label, e.invocation, e.reason)
      | _ => none) = some ("nonfinite operand", 1, .nonfiniteInput) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CallFailure](../Program/Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Program.report](../Program/Report.md#decl-153a1a264738ed2c), [TensorCore.ProgramFailure](../Program/Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](../Program/Report.md#decl-bed00bf44170d962), [TensorCore.Regression.rejectedProgram](Programs.md#decl-f11f488210178f17), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-613c4339f6d2f7e4"></a>

<details>
<summary><code>TensorCore.Regression.rangeProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L73)

```lean
def rangeProgram : Program v100F16F32 := tc%{
  block "add 1 at maximum" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Regression.repeatedProgram](Programs.md#decl-4b3c8f635166e817), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.final_range_rejected](Programs.md#decl-b957b5671d3ec1f7)

</details>

</details>

<a id="decl-b957b5671d3ec1f7"></a>

<details>
<summary><code>TensorCore.Regression.final_range_rejected</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L78)

```lean
/-- The model call succeeds, but its ideal sum is outside the correction domain. -/
theorem final_range_rejected :
    (rangeProgram.run 0x7f7fffff).isOk = true ∧
    ¬rangeProgram.VC 0x7f7fffff ∧
    rangeProgram.report 0x7f7fffff = .error (.finalSumOutOfRange (maxFinite32 + 1)) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.CallFailure](../Program/Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.VC](../Program/Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.report](../Program/Report.md#decl-153a1a264738ed2c), [TensorCore.Program.run](../Program/Defs.md#decl-7a1c9df214179ea0), [TensorCore.ProgramFailure](../Program/Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](../Program/Report.md#decl-bed00bf44170d962), [TensorCore.Regression.rangeProgram](Programs.md#decl-613c4339f6d2f7e4), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](../Program/Correction.md#decl-dd85a41a20883c51), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3b55d7944252fd7b"></a>

<details>
<summary><code>TensorCore.Regression.unexecutedProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L84)

```lean
def unexecutedProgram : Program v100F16F32 := tc%{
  repeat (0) {
    block "unexecuted NaN" [(0x7e00, 0), (0, 0), (0, 0), (0, 0)];
  }
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.nonfinite_initial_rejected](Programs.md#decl-e3e1420815ec77d6)

</details>

</details>

<a id="decl-e3e1420815ec77d6"></a>

<details>
<summary><code>TensorCore.Regression.nonfinite_initial_rejected</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L92)

```lean
theorem nonfinite_initial_rejected :
    ¬unexecutedProgram.VC 0x7f800000 ∧
    unexecutedProgram.report 0x7f800000 = .error .initialNonfinite := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.CallFailure](../Program/Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.VC](../Program/Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.report](../Program/Report.md#decl-153a1a264738ed2c), [TensorCore.Program.run](../Program/Defs.md#decl-7a1c9df214179ea0), [TensorCore.ProgramFailure](../Program/Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](../Program/Report.md#decl-bed00bf44170d962), [TensorCore.Regression.unexecutedProgram](Programs.md#decl-3b55d7944252fd7b), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](../Program/Correction.md#decl-dd85a41a20883c51), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-beab2369a0ebbc6e"></a>

<details>
<summary><code>TensorCore.Regression.cycleBody</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L96)

```lean
def cycleBody : Program v100F16F32 := tc%{
  block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  block "subtract 1" [(0xbc00, 0x3c00), (0, 0), (0, 0), (0, 0)];
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Regression.nestedProgram](Programs.md#decl-1a76bee30a7c4624), [TensorCore.Regression.repeatedProgram](Programs.md#decl-4b3c8f635166e817), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cycle_execution](Programs.md#decl-6ade3ce34965b8a4), [TensorCore.Regression.symbolic_cycle_vc](Programs.md#decl-5719553e703a7aad)

</details>

</details>

<a id="decl-52e46c456d929e94"></a>

<details>
<summary><code>TensorCore.Regression.zeroFinite</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L101)

```lean
def zeroFinite : Finite32 := ⟨0, ⟨0, 0, 0⟩, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cycleTraces](Programs.md#decl-cbf6099dd8fc5073), [TensorCore.Regression.cycle_execution](Programs.md#decl-6ade3ce34965b8a4), [TensorCore.Regression.symbolic_cycle_vc](Programs.md#decl-5719553e703a7aad)

</details>

</details>

<a id="decl-ff1daa28204b8726"></a>

<details>
<summary><code>TensorCore.Regression.oneFinite</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L102)

```lean
def oneFinite : Finite32 := ⟨0x3f800000, ⟨8388608, 0, 23⟩, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cycleTraces](Programs.md#decl-cbf6099dd8fc5073)

</details>

</details>

<a id="decl-cbf6099dd8fc5073"></a>

<details>
<summary><code>TensorCore.Regression.cycleTraces</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L104)

```lean
def cycleTraces : List BlockTrace :=
  [⟨⟨v100F16F32,
      (⟨1024, 0, 10⟩, ⟨1024, 0, 10⟩) :: List.replicate 3 (⟨0, 0, 0⟩, ⟨0, 0, 0⟩),
      zeroFinite.decoded⟩, oneFinite⟩,
   ⟨⟨v100F16F32,
      (⟨-1024, 0, 10⟩, ⟨1024, 0, 10⟩) :: List.replicate 3 (⟨0, 0, 0⟩, ⟨0, 0, 0⟩),
      oneFinite.decoded⟩, zeroFinite⟩]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.Regression.oneFinite](Programs.md#decl-ff1daa28204b8726), [TensorCore.Regression.zeroFinite](Programs.md#decl-52e46c456d929e94), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cycle_execution](Programs.md#decl-6ade3ce34965b8a4), [TensorCore.Regression.symbolic_cycle_vc](Programs.md#decl-5719553e703a7aad)

</details>

</details>

<a id="decl-6ade3ce34965b8a4"></a>

<details>
<summary><code>TensorCore.Regression.cycle_execution</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L112)

```lean
theorem cycle_execution : cycleBody.run zeroFinite.bits = .ok cycleTraces := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program.run](../Program/Defs.md#decl-7a1c9df214179ea0), [TensorCore.Regression.cycleBody](Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.cycleTraces](Programs.md#decl-cbf6099dd8fc5073), [TensorCore.Regression.zeroFinite](Programs.md#decl-52e46c456d929e94), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.symbolic_cycle_vc](Programs.md#decl-5719553e703a7aad)

</details>

</details>

<a id="decl-5719553e703a7aad"></a>

<details>
<summary><code>TensorCore.Regression.symbolic_cycle_vc</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L115)

```lean
/-- This VC is proved for a symbolic iteration count by the encoded-state invariant. -/
theorem symbolic_cycle_vc (n : ℕ) : (Program.repeat n cycleBody).VC 0 := by
  apply Program.repeat_vc_of_cycle cycleBody zeroFinite cycleTraces
  · rfl
  · exact cycle_execution
  · rfl
  · decide +kernel
  · decide +kernel
```

**Supporting proofs:** [TensorCore.Program.repeat_vc_of_cycle](../Program/Loops.md#decl-4f3792d4e823ab22), [TensorCore.Regression.cycle_execution](Programs.md#decl-6ade3ce34965b8a4)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.VC](../Program/Defs.md#decl-8bdb929e75d195cf), [TensorCore.Regression.cycleBody](Programs.md#decl-beab2369a0ebbc6e), [TensorCore.Regression.cycleTraces](Programs.md#decl-cbf6099dd8fc5073), [TensorCore.Regression.zeroFinite](Programs.md#decl-52e46c456d929e94), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-dcfb59eb2d24ca6e"></a>

<details>
<summary><code>TensorCore.Regression.symbolicSyntax</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L128)

```lean
def symbolicSyntax (n : ℕ) : Program v100F16F32 := tc%{
  repeat (n) {
    call "typed call" (BlockOperands.ofNats [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)]
      (by decide) (by decide));
  }
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Regression.repeatedProgram](Programs.md#decl-4b3c8f635166e817), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.symbolic_syntax_inputs](Programs.md#decl-97006754bc720027)

</details>

</details>

<a id="decl-97006754bc720027"></a>

<details>
<summary><code>TensorCore.Regression.symbolic_syntax_inputs</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Programs.lean#L135)

```lean
theorem symbolic_syntax_inputs (n : ℕ) : (symbolicSyntax n).inputs =
    List.replicate n [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)] := by
  induction n with
  | zero => rfl
  | succ n ih =>
    change ([(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)] :: (symbolicSyntax n).inputs) = _
    rw [ih]; rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.Regression.symbolicSyntax](Programs.md#decl-dcfb59eb2d24ca6e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
