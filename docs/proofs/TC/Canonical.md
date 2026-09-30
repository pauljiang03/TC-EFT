# TensorCore.TC.Canonical

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-77d448deb0e063d7"></a>

<details>
<summary><code>TensorCore.fp16Fp32_invocation_compatible</code></summary>

[Lean source](../../../TensorCore/TC/Canonical.lean#L9)

```lean
theorem fp16Fp32_invocation_compatible (K extra : ℕ) (floor : Option ℤ)
    (x : BlockInput (fp16Fp32Profile K extra floor)) :
    invocationBits (x.toInvocation (23 + extra)) =
      (evalBlock x).toOption.map (fun t => t.output.bits) :=
  legacy_invocation_bits x (23 + extra) (by change fp16.WellFormed; decide) rfl
```

**Supporting proofs:** [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-cf62ece4228e9418"></a>

<details>
<summary><code>TensorCore.fp16Fp32_contract</code></summary>

[Lean source](../../../TensorCore/TC/Canonical.lean#L18)

```lean
/-- One public contract for arbitrary canonical block size and extra alignment bits.
It states uncorrected output/error behavior and a machine-width refinement. It does
not require EFT, a final correction, or any architecture-conformance premise. -/
theorem fp16Fp32_contract (K extra carryBits : ℕ) (floor : Option ℤ)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (t : BlockTrace)
    (h : evalBlock x = .ok t) (hc : K + 1 ≤ 2 ^ carryBits) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.accumulator = some t.output.bits ∧
    absQ (t.block.exactDot - t.output.value) <
      ((K + 1 : ℕ) : ℚ) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) ∧
    t.block.machineAccumulator (26 + extra + carryBits) = t.block.accumulator := by
  have hp := evalBlock_prepared h
  have hlen := (prepare_terms_bounded hp).1
  have hshape : x.products.length = K := by
    unfold evalBlock at h
    split at h <;> simp_all [fp16Fp32Profile]
  have herr := evalBlock_error_bound h
  have hw := evalBlock_machineAccumulator h (23 + extra) carryBits rfl hc
  refine ⟨by simp [exactDot, hp], evalPrepared_output (evalBlock_evalPrepared h), ?_, ?_⟩
  · simpa [hlen, hshape] using herr
  · have he : 23 + extra + 2 + carryBits + 1 = 26 + extra + carryBits := by omega
    simpa [he] using hw
```

**Supporting proofs:** [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Numerics/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16](../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df)

</details>

</details>

<a id="decl-4e3007238613f1c9"></a>

<details>
<summary><code>TensorCore.ampere_machineAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/Canonical.lean#L39)

```lean
theorem ampere_machineAccumulator {x : BlockInput ampereF16F32} {t : BlockTrace}
    (h : evalBlock x = .ok t) : t.block.machineAccumulator 31 = t.block.accumulator :=
  (fp16Fp32_contract 8 1 4 (some (-132)) x t h (by decide)).2.2.2
```

**Supporting proofs:** [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.ampereF16F32](CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-06a8e4120caf10df"></a>

<details>
<summary><code>TensorCore.hopper_machineAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/Canonical.lean#L43)

```lean
theorem hopper_machineAccumulator {x : BlockInput hopperF16F32} {t : BlockTrace}
    (h : evalBlock x = .ok t) : t.block.machineAccumulator 33 = t.block.accumulator :=
  (fp16Fp32_contract 16 2 5 (some (-133)) x t h (by decide)).2.2.2
```

**Supporting proofs:** [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.hopperF16F32](CanonicalDefs.md#decl-3d43fc64b9e4a784), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
