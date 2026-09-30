# TensorCore.TC.AcceptedDomain

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-13c6e80f5f7e2f5a"></a>

<details>
<summary><code>TensorCore.round32_finite_exists</code></summary>

[Lean source](../../../TensorCore/TC/AcceptedDomain.lean#L8)

```lean
/-- Both existing FP32 conversion modes return a decodable finite encoding in range. -/
theorem round32_finite_exists (mode : RoundingMode) (x : ℚ) (hr : absQ x ≤ maxFinite32) :
    ∃ bits d, round32 mode x = some bits ∧ decode32 bits = some d := by
  by_cases hz : x = 0
  · subst x
    refine ⟨0, ⟨0, 0, 0⟩, ?_, by decide⟩
    cases mode <;> decide +kernel
  · obtain ⟨bits, hb, hv, _, _⟩ := round32_nonzero_spec mode x hz hr
    cases hd : decode32 bits with
    | none => simp [value32, hd] at hv
    | some d => exact ⟨bits, d, hb, hd⟩
```

**Supporting proofs:** [TensorCore.round32_nonzero_spec](../Numerics/CorrectRounding.md#decl-8b6b01a970bf7f64)

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](../Numerics/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../Numerics/RoundOp.md#decl-712564d4fa452350), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.signedRounded](../Numerics/RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.rounds_iff](Specification/Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c)

</details>

</details>

<a id="decl-23e3d05f63684e0c"></a>

<details>
<summary><code>TensorCore.evalPrepared_total</code></summary>

[Lean source](../../../TensorCore/TC/AcceptedDomain.lean#L19)

```lean
theorem evalPrepared_total (b : PreparedBlock) (hr : absQ b.accumulator ≤ maxFinite32) :
    ∃ t, evalPrepared b = .ok t := by
  obtain ⟨bits, d, hb, hd⟩ := round32_finite_exists .towardZero b.accumulator hr
  have hf : finite32 bits = some ⟨bits, d, hd⟩ := by
    unfold finite32
    split
    · rename_i he
      rw [hd] at he
      contradiction
    · rename_i d' he
      rw [hd] at he
      cases Option.some.inj he
      rfl
  exact ⟨⟨b, ⟨bits, d, hd⟩⟩, by simp [evalPrepared, hb, hf]⟩
```

**Supporting proofs:** [TensorCore.round32_finite_exists](AcceptedDomain.md#decl-13c6e80f5f7e2f5a)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d)

</details>

</details>

<a id="decl-67304506aa3d182d"></a>

<details>
<summary><code>TensorCore.evalBlock_success_iff</code></summary>

[Lean source](../../../TensorCore/TC/AcceptedDomain.lean#L36)

```lean
/-- Exact accepted domain: correct shape, finite decoded operands, and in-range
aligned accumulator. No additional output-decoding failure is possible in this domain. -/
theorem evalBlock_success_iff (p : Profile) (x : BlockInput p) :
    (∃ t, evalBlock x = .ok t) ↔
      x.products.length = p.products ∧
        ∃ b, prepare x = some b ∧ absQ b.accumulator ≤ maxFinite32 := by
  constructor
  · rintro ⟨t, ht⟩
    have hp := evalBlock_prepared ht
    have hr := round32_range (evalPrepared_output (evalBlock_evalPrepared ht))
    refine ⟨?_, t.block, hp, hr⟩
    unfold evalBlock at ht
    split at ht <;> simp_all
  · rintro ⟨hshape, b, hp, hr⟩
    obtain ⟨t, ht⟩ := evalPrepared_total b hr
    exact ⟨t, by simpa [evalBlock, hshape, hp] using ht⟩
```

**Supporting proofs:** [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.round32_range](../Numerics/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2)

</details>

</details>
