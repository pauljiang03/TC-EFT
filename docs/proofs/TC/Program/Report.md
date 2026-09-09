# TensorCore.TC.Program.Report

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-bfac1adcea94ebb6"></a>

<details>
<summary><code>TensorCore.CallFailure</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L7)

```lean
structure CallFailure where
  site : SourceSite
  invocation : ℕ
  reason : ModelError
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.SourceSite](Defs.md#decl-4b38eaa245ee464e)

<details>
<summary>Used by</summary>

[TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.ProgramFailure](Report.md#decl-2eeb60d7bb34d949), [TensorCore.Regression.cancellation_program_report](../Regression/Programs.md#decl-8810fd71ca8fd96b), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rejected_program_location](../Regression/Programs.md#decl-7e373e5951755270), [TensorCore.Regression.repeated_program_report](../Regression/Programs.md#decl-1a6cc1692e976cd7), [TensorCore.runLocated](Report.md#decl-df432b3ff1fa37ac), [TensorCore.runLocated_erases](Report.md#decl-8b5841076d4639dc)

</details>

</details>

<a id="decl-df432b3ff1fa37ac"></a>

<details>
<summary><code>TensorCore.runLocated</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L14)

```lean
/-- Diagnostic evaluation follows the same block evaluator and encoded boundaries. -/
def runLocated (p : Profile) (c : F32) (index : ℕ) :
    List (LocatedBlock p) → Except CallFailure (List BlockTrace)
  | [] => .ok []
  | call :: rest =>
    match evalBlock (p := p) ⟨call.operands.values, c⟩ with
    | .error e => .error ⟨call.site, index, e⟩
    | .ok t => match runLocated p t.output.bits (index + 1) rest with
      | .error e => .error e
      | .ok ts => .ok (t :: ts)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.CallFailure](Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

<details>
<summary>Used by</summary>

[TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.runLocated_erases](Report.md#decl-8b5841076d4639dc)

</details>

</details>

<a id="decl-8b5841076d4639dc"></a>

<details>
<summary><code>TensorCore.runLocated_erases</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L25)

```lean
/-- Locations cannot change numerical execution, including on failing paths. -/
theorem runLocated_erases (p : Profile) (c : F32) (index : ℕ) (calls : List (LocatedBlock p)) :
    (runLocated p c index calls).mapError CallFailure.reason =
      runBlocks p c (calls.map fun call => call.operands.values) := by
  induction calls generalizing c index with
  | nil => rfl
  | cons call calls ih =>
    cases he : evalBlock (p := p) ⟨call.operands.values, c⟩ with
    | error e => simp [runLocated, runBlocks, he, Except.mapError]
    | ok t =>
      have h := ih t.output.bits (index + 1)
      cases hr : runLocated p t.output.bits (index + 1) calls with
      | error e => simp [hr, Except.mapError] at h; simp [runLocated, runBlocks, he, hr, ← h, Except.mapError]
      | ok ts => simp [hr, Except.mapError] at h; simp [runLocated, runBlocks, he, hr, ← h, Except.mapError]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.CallFailure](Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runLocated](Report.md#decl-df432b3ff1fa37ac)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044)

</details>

</details>

<a id="decl-2eeb60d7bb34d949"></a>

<details>
<summary><code>TensorCore.ProgramFailure</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L39)

```lean
inductive ProgramFailure where
  | initialNonfinite
  | call (failure : CallFailure)
  | finalSumOutOfRange (exactSum : ℚ)
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CallFailure](Report.md#decl-bfac1adcea94ebb6)

<details>
<summary>Used by</summary>

[TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Regression.cancellation_program_report](../Regression/Programs.md#decl-8810fd71ca8fd96b), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rejected_program_location](../Regression/Programs.md#decl-7e373e5951755270), [TensorCore.Regression.repeated_program_report](../Regression/Programs.md#decl-1a6cc1692e976cd7)

</details>

</details>

<a id="decl-bed00bf44170d962"></a>

<details>
<summary><code>TensorCore.ProgramReport</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L45)

```lean
structure ProgramReport where
  profile : Profile
  sites : List SourceSite
  outputBits : List ℕ
  modelFinalBits : ℕ
  residual : ℚ
  recovered : ℚ
  ideal : Option ℚ
  correctedBits : Option ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.SourceSite](Defs.md#decl-4b38eaa245ee464e)

<details>
<summary>Used by</summary>

[TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Regression.cancellation_program_report](../Regression/Programs.md#decl-8810fd71ca8fd96b), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rejected_program_location](../Regression/Programs.md#decl-7e373e5951755270), [TensorCore.Regression.repeated_program_report](../Regression/Programs.md#decl-1a6cc1692e976cd7)

</details>

</details>

<a id="decl-153a1a264738ed2c"></a>

<details>
<summary><code>TensorCore.Program.report</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L57)

```lean
/-- A numerical diagnostic, never used as an unchecked proof certificate. -/
def Program.report {p : Profile} (pr : Program p) (c : F32) : Except ProgramFailure ProgramReport := do
  let some initial := finite32 c | .error .initialNonfinite
  let ts ← (runLocated p c 0 pr.blocks).mapError ProgramFailure.call
  let recovered := recoveredSchedule initial ts
  if absQ recovered > maxFinite32 then .error (.finalSumOutOfRange recovered)
  else return ⟨p, pr.blocks.map LocatedBlock.site, ts.map (fun t => t.output.bits.toNat),
    (lastOutput initial ts).bits.toNat, sumQ (ts.map BlockTrace.residual), recovered,
    pr.ideal c, (correctedSchedule initial ts).map BitVec.toNat⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.CallFailure](Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.ProgramFailure](Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](Report.md#decl-bed00bf44170d962), [TensorCore.SourceSite](Defs.md#decl-4b38eaa245ee464e), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.runLocated](Report.md#decl-df432b3ff1fa37ac), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.Program.report_accepts_iff](Report.md#decl-cb9f58bb2a973044), [TensorCore.Regression.cancellation_program_report](../Regression/Programs.md#decl-8810fd71ca8fd96b), [TensorCore.Regression.final_range_rejected](../Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.nested_program_order](../Regression/Programs.md#decl-f9d0e3f87f9f071f), [TensorCore.Regression.nonfinite_initial_rejected](../Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.rejected_program_location](../Regression/Programs.md#decl-7e373e5951755270), [TensorCore.Regression.repeated_program_report](../Regression/Programs.md#decl-1a6cc1692e976cd7)

</details>

</details>

<a id="decl-cb9f58bb2a973044"></a>

<details>
<summary><code>TensorCore.Program.report_accepts_iff</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Report.lean#L66)

```lean
theorem Program.report_accepts_iff {p : Profile} (pr : Program p) (c : F32) :
    (pr.report c).isOk = true ↔ pr.VC c := by
  have hrun := runLocated_erases p c 0 pr.blocks
  change (runLocated p c 0 pr.blocks).mapError CallFailure.reason = pr.run c at hrun
  cases hi : finite32 c with
  | none => simp [Program.report, Program.VC, hi, Except.isOk, Except.toBool]
  | some initial =>
    cases he : runLocated p c 0 pr.blocks with
    | error e =>
      simp [he, Except.mapError] at hrun
      simp [Program.report, Program.VC, hi, he, ← hrun, Except.mapError,
        Bind.bind, Except.bind, Except.isOk, Except.toBool]
    | ok ts =>
      simp [he, Except.mapError] at hrun
      simp [Program.report, Program.VC, hi, he, ← hrun, Except.mapError,
        Bind.bind, Except.bind, Pure.pure, Except.pure]
      split <;> simp_all [Except.isOk, Except.toBool] <;> grind
```

**Supporting proofs:** [TensorCore.runLocated_erases](Report.md#decl-8b5841076d4639dc)

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../Block.md#decl-29503c8290420b97), [TensorCore.CallFailure](Report.md#decl-bfac1adcea94ebb6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.LocatedBlock](Defs.md#decl-36cafa797c1bf521), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.VC](Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.blocks](Defs.md#decl-e6562fd402604610), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.report](Report.md#decl-153a1a264738ed2c), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.ProgramFailure](Report.md#decl-2eeb60d7bb34d949), [TensorCore.ProgramReport](Report.md#decl-bed00bf44170d962), [TensorCore.SourceSite](Defs.md#decl-4b38eaa245ee464e), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runLocated](Report.md#decl-df432b3ff1fa37ac), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
