# TensorCore.TC.Specification.Equivalence

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-46e00e6d284d09a5"></a>

<details>
<summary><code>TensorCore.PaperSpec.result_of_eval</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L12)

```lean
theorem result_of_eval {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : Result (parametersOf p) (inputOf x) t.output.bits := by
  have hp := evalBlock_prepared h
  have hv := (evalBlock_success_iff p x).mp ⟨t, h⟩
  have hr := evalPrepared_output (evalBlock_evalPrepared h)
  have ha := accumulated_eq t.block
  rw [prepare_profile hp] at ha
  refine ⟨hv.1, t.block.terms.map rawTermOf, ?_, ?_, ?_⟩
  · rw [terms_eq, hp]; rfl
  · rw [ha]; exact round32_range hr
  · rw [ha]; exact round32_rounds _ _ hr
```

**Supporting proofs:** [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.evalBlock_evalPrepared](../StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_prepared](../StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_success_iff](../AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared_output](../ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.prepare_profile](../StageResiduals.md#decl-b234945333f4196c), [TensorCore.round32_range](../../Numerics/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](../Block.md#decl-32c2d7273540d876), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>

<a id="decl-9080cf4b38ea315d"></a>

<details>
<summary><code>TensorCore.PaperSpec.result_unique</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L24)

```lean
theorem result_unique {p : Parameters} {x : Input p} {a b : F32}
    (ha : Result p x a) (hb : Result p x b) : a = b := by
  obtain ⟨_, ta, hta, _, hra⟩ := ha
  obtain ⟨_, tb, htb, _, hrb⟩ := hb
  rw [hta] at htb
  cases Option.some.inj htb
  exact rounds_unique _ _ _ hra hrb
```

**Supporting proofs:** [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20)

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e)

</details>

</details>

<a id="decl-531002177af0522e"></a>

<details>
<summary><code>TensorCore.PaperSpec.result_iff_eval</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L32)

```lean
theorem result_iff_eval {p : Profile} (x : BlockInput p) (b : F32) :
    Result (parametersOf p) (inputOf x) b ↔
      ∃ t, evalBlock x = .ok t ∧ t.output.bits = b := by
  constructor
  · intro h
    have hv : Valid (parametersOf p) (inputOf x) := by
      obtain ⟨hs, ts, ht, hr, _⟩ := h
      exact ⟨hs, ts, ht, hr⟩
    obtain ⟨t, ht⟩ := (valid_iff x).mp hv
    exact ⟨t, ht, result_unique (result_of_eval ht) h⟩
  · rintro ⟨t, ht, rfl⟩
    exact result_of_eval ht
```

**Supporting proofs:** [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849)

</details>

</details>

<a id="decl-56c2a78914a106fb"></a>

<details>
<summary><code>TensorCore.PaperSpec.bits_eq_of_result</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L45)

```lean
theorem bits_eq_of_result {p : Parameters} {x : Input p} {b : F32}
    (h : Result p x b) : bits p x = some b := by
  classical
  unfold bits
  rw [dif_pos ⟨b, h⟩]
  exact congrArg some (result_unique (Classical.choose_spec (show ∃ b, Result p x b from ⟨b, h⟩)) h)
```

**Supporting proofs:** [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d)

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>

<a id="decl-944384931631e849"></a>

<details>
<summary><code>TensorCore.PaperSpec.implementation_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L54)

```lean
/-- Every encoded input: successful output bits and all rejection cases agree.
The generic parameter theorem is stronger than its named paper-profile instances. -/
theorem implementation_eq_paper {p : Profile} (x : BlockInput p) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      bits (parametersOf p) (inputOf x) := by
  classical
  cases he : evalBlock x with
  | ok t => exact (bits_eq_of_result (result_of_eval he)).symm
  | error e =>
    have hn : ¬ ∃ b, Result (parametersOf p) (inputOf x) b := by
      rintro ⟨b, hb⟩
      obtain ⟨t, ht, _⟩ := (result_iff_eval x b).mp hb
      rw [he] at ht
      contradiction
    simp [bits, hn, Except.toOption]
```

**Supporting proofs:** [TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.invocation_eq_paper](Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.supported_eq_paper](Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64)

</details>

</details>

<a id="decl-882143aa8462feae"></a>

<details>
<summary><code>TensorCore.PaperSpec.valid_success</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L69)

```lean
/-- The theorem is nonvacuous on the independently specified valid domain. -/
theorem valid_success {p : Profile} (x : BlockInput p)
    (hv : Valid (parametersOf p) (inputOf x)) :
    ∃ t, evalBlock x = .ok t ∧ bits (parametersOf p) (inputOf x) = some t.output.bits := by
  obtain ⟨t, ht⟩ := (valid_iff x).mp hv
  exact ⟨t, ht, bits_eq_of_result (result_of_eval ht)⟩
```

**Supporting proofs:** [TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495)

</details>

</details>

<a id="decl-a7b3c8171f0fe70d"></a>

<details>
<summary><code>TensorCore.PaperSpec.machine_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Equivalence.lean#L76)

```lean
/-- Adequate modular accumulator widths inherit the independent paper theorem. -/
theorem machine_eq_paper {p : Profile} (x : BlockInput p) (w F carryBits : ℕ)
    (hF : p.alignFraction = F) (hc : p.products + 1 ≤ 2 ^ carryBits)
    (hw : F + 3 + carryBits ≤ w) :
    (evalBlockMachine w x).toOption.map (fun t => t.output.bits) =
      bits (parametersOf p) (inputOf x) := by
  rw [evalBlockMachine_eq x w F carryBits hF hc (by omega)]
  exact implementation_eq_paper x
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.evalBlockMachine_eq](../MachineRefinement.md#decl-d4518ab25c18ea58)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](../Accumulator.md#decl-ab9031f1fdf12cee)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
