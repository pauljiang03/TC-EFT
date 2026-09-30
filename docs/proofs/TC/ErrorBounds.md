# TensorCore.TC.ErrorBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-48e730a73a284cc0"></a>

<details>
<summary><code>TensorCore.evalPrepared_output</code></summary>

[Lean source](../../../TensorCore/TC/ErrorBounds.lean#L9)

```lean
theorem evalPrepared_output {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) : round32 .towardZero b.accumulator = some t.output.bits := by
  unfold evalPrepared at h
  cases hr : round32 .towardZero b.accumulator with
  | none => simp [hr] at h
  | some bits =>
    cases hd : finite32 bits with
    | none => simp [hr, hd] at h
    | some d =>
      simp [hr, hd] at h
      cases h
      unfold finite32 at hd
      split at hd
      · contradiction
      · cases Option.some.inj hd
        rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

</details>

</details>

<a id="decl-233a4e25b95c20ca"></a>

<details>
<summary><code>TensorCore.sum_residual_bounds</code></summary>

[Lean source](../../../TensorCore/TC/ErrorBounds.lean#L26)

```lean
theorem sum_residual_bounds (ts : List ℚ) (e : ℤ) :
    absQ (sumQ (ts.map fun x => x - truncGrid x e)) ≤ (ts.length : ℚ) * pow2 e ∧
    (ts ≠ [] → absQ (sumQ (ts.map fun x => x - truncGrid x e)) < (ts.length : ℚ) * pow2 e) := by
  induction ts with
  | nil =>
    have h : absQ (sumQ (List.map (fun x => x - truncGrid x e) [])) = 0 := by
      change absQ 0 = 0
      decide +kernel
    simp only [h, List.length_nil]
    constructor
    · grind
    · intro hn; exact False.elim (hn rfl)
  | cons x xs ih =>
    have hx := (alignment_residual x e).2
    have ht := absQ_add_le (x - truncGrid x e)
      (sumQ (xs.map fun t => t - truncGrid t e))
    have hs : ((xs.length + 1 : ℕ) : ℚ) = (xs.length : ℚ) + 1 := by
      rw [Rat.natCast_add]; rfl
    simp only [List.map_cons, sumQ, List.length_cons, hs]
    have hn : absQ ((x - truncGrid x e) + sumQ (xs.map fun t => t - truncGrid t e)) <
        ((xs.length : ℚ) + 1) * pow2 e := by grind
    exact ⟨Rat.le_of_lt hn, fun _ => hn⟩
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Numerics/Exact.md#decl-5c1117bc0bcece80), [TensorCore.alignment_residual](../Numerics/Truncation.md#decl-8fb54cfc251e7721)

**Definitions and types:** [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982)

</details>

</details>

<a id="decl-6c4703b9700d8982"></a>

<details>
<summary><code>TensorCore.block_alignment_bound</code></summary>

[Lean source](../../../TensorCore/TC/ErrorBounds.lean#L49)

```lean
theorem block_alignment_bound (b : PreparedBlock) :
    absQ (sumQ b.alignmentResiduals) < (b.terms.length : ℚ) * pow2 b.quantumExponent := by
  have h := (sum_residual_bounds (b.terms.map RawProduct.value) b.quantumExponent).2
    (by simp [PreparedBlock.terms])
  simpa [PreparedBlock.alignmentResiduals, List.map_map, Function.comp_def] using h
```

**Supporting proofs:** [TensorCore.sum_residual_bounds](ErrorBounds.md#decl-233a4e25b95c20ca)

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63)

</details>

</details>

<a id="decl-06d7afabcf00fa63"></a>

<details>
<summary><code>TensorCore.block_error_bound</code></summary>

[Lean source](../../../TensorCore/TC/ErrorBounds.lean#L56)

```lean
/-- Two-stage error bound. Both losses are counted; exact Int arithmetic cannot wrap. -/
theorem block_error_bound (b : PreparedBlock) (d : Finite32)
    (hr : absQ b.accumulator ≤ maxFinite32)
    (hout : round32 .towardZero b.accumulator = some d.bits) :
    absQ (b.exactDot - d.value) <
      (b.terms.length : ℚ) * pow2 b.quantumExponent + pow2 (outputQuantumExponent d.bits) := by
  have hd : value32 d.bits = some d.value := by simp [value32, d.valid, Finite32.value]
  have halign := block_alignment_bound b
  have houtput := output_residual_bound b.accumulator d.bits d.value hr hout hd
  have hid := block_residual_identity b d.value
  unfold PreparedBlock.extractReference at hid
  have ht := absQ_add_le (b.accumulator - d.value) (sumQ b.alignmentResiduals)
  have he : b.exactDot - d.value = (b.accumulator - d.value) + sumQ b.alignmentResiduals := by grind
  rw [he]; grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Numerics/Exact.md#decl-5c1117bc0bcece80), [TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.output_residual_bound](../Numerics/RoundingError.md#decl-456564416e37d7c3)

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298)

</details>

</details>

<a id="decl-6a51cec1858cd298"></a>

<details>
<summary><code>TensorCore.evalPrepared_error_bound</code></summary>

[Lean source](../../../TensorCore/TC/ErrorBounds.lean#L70)

```lean
theorem evalPrepared_error_bound {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) :
    absQ (t.block.exactDot - t.output.value) <
      (t.block.terms.length : ℚ) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) := by
  have hb := evalPrepared_block h
  rw [hb]
  have hout := evalPrepared_output h
  exact block_error_bound b t.output (round32_range hout) hout
```

**Supporting proofs:** [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.round32_range](../Numerics/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b)

</details>

</details>

<a id="decl-cd49461242c6068b"></a>

<details>
<summary><code>TensorCore.evalBlock_error_bound</code></summary>

[Lean source](../../../TensorCore/TC/ErrorBounds.lean#L80)

```lean
theorem evalBlock_error_bound {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    absQ (t.block.exactDot - t.output.value) <
      (t.block.terms.length : ℚ) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) :=
  evalPrepared_error_bound (evalBlock_evalPrepared h)
```

**Supporting proofs:** [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

</details>

</details>
