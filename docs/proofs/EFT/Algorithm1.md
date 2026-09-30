# TensorCore.EFT.Algorithm1

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b8a661b7258cdacc"></a>

<details>
<summary><code>TensorCore.overlap_window_width</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L15)

```lean
/-- Lemma IV.2: the overlap window width `τ = ψ − η + p ≥ 0`, where `qE = 2^(ψ−23)` is the
extraction grid and `qA = 2^(η − 23 − p)` the alignment grid. -/
theorem overlap_window_width (t : BlockTrace) (η : ℤ) (p : ℕ) (hη : t.block.eta = some η)
    (hF : t.block.profile.alignFraction = 23 + p) :
    0 ≤ t.extractionExponent - t.block.quantumExponent ∧
      t.extractionExponent - t.block.quantumExponent =
        max 0 ((outputQuantumExponent t.output.bits + 23) - η + p) := by
  unfold BlockTrace.extractionExponent PreparedBlock.quantumExponent
  rw [hη, hF]
  simp only [Option.getD_some]
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](../TC/Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2c3184ccfe7b5745"></a>

<details>
<summary><code>TensorCore.BlockTrace.exactConsolidation</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L27)

```lean
/-- The exact reference branch of Algorithm 1: `RN(D − ε_o + Σ εᵢ)` formed from the
extracted components in exact dyadic arithmetic. -/
def BlockTrace.exactConsolidation (t : BlockTrace) : Option F32 :=
  round32 .nearestEven (t.output.value - t.overlap + sumQ t.lowParts)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.algorithm1_scalar_iff](Algorithm1.md#decl-035c260a0676f872), [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695)

</details>

</details>

<a id="decl-c3b8d88d2995c695"></a>

<details>
<summary><code>TensorCore.exactConsolidation_eq_corrected</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L31)

```lean
/-- The component form recovers the same exact sum as the stage-residual reference. -/
theorem exactConsolidation_eq_corrected (t : BlockTrace) :
    t.exactConsolidation = t.corrected := by
  unfold BlockTrace.exactConsolidation
  rw [← overlap_recovery, corrected_eq_round_exactDot]
```

**Supporting proofs:** [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29)

</details>

</details>

<a id="decl-f55fbf06a011ce23"></a>

<details>
<summary><code>TensorCore.Algorithm1Result</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L38)

```lean
/-- Outcome of Algorithm 1: the scalar branch, the exact reference branch, or an exact sum
outside the FP32 range. -/
inductive Algorithm1Result where
  | scalar (bits : F32)
  | exactReference (bits : F32)
  | outOfRange
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.Regression.algorithm1_cases](../Tests/EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.encoded_eft_all_zero](../Tests/EFT/EncodedEFT.md#decl-84a376d9133b92c7), [TensorCore.Regression.encoded_eft_branches](../Tests/EFT/EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.encoded_eft_cancellation](../Tests/EFT/EncodedEFT.md#decl-277a69997e7c7a84), [TensorCore.Regression.encoded_eft_nonzero_c](../Tests/EFT/EncodedEFT.md#decl-3c8a2a316485713c), [TensorCore.Regression.encoded_eft_rejections](../Tests/EFT/EncodedEFT.md#decl-95e3c5cfb683c2bf), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.algorithm1_scalar_iff](Algorithm1.md#decl-035c260a0676f872)

</details>

</details>

<a id="decl-813f0f3b4334e3b7"></a>

<details>
<summary><code>TensorCore.Algorithm1Result.bits</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L44)

```lean
def Algorithm1Result.bits : Algorithm1Result → Option F32
  | .scalar b => some b
  | .exactReference b => some b
  | .outOfRange => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8)

</details>

</details>

<a id="decl-01de1ae42b7279f3"></a>

<details>
<summary><code>TensorCore.BlockTrace.algorithm1</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L51)

```lean
/-- Algorithm 1 on a trace: the scalar branch when the predicate holds, otherwise the exact
reference branch. -/
def BlockTrace.algorithm1 (t : BlockTrace) : Algorithm1Result :=
  match t.scalarCorrected with
  | some b => .scalar b
  | none =>
    match t.exactConsolidation with
    | some b => .exactReference b
    | none => .outOfRange
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.Regression.algorithm1_cases](../Tests/EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](Encoded.md#decl-81edff15e18bd6d1), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.algorithm1_scalar_iff](Algorithm1.md#decl-035c260a0676f872)

</details>

</details>

<a id="decl-035c260a0676f872"></a>

<details>
<summary><code>TensorCore.algorithm1_scalar_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L59)

```lean
theorem algorithm1_scalar_iff (t : BlockTrace) (b : F32) :
    t.algorithm1 = .scalar b ↔ t.scalarCorrected = some b := by
  unfold BlockTrace.algorithm1
  cases hs : t.scalarCorrected with
  | some b' => simp
  | none =>
    cases t.exactConsolidation <;> simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b5fbc137128bfc29"></a>

<details>
<summary><code>TensorCore.algorithm1_exact_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L67)

```lean
theorem algorithm1_exact_iff (t : BlockTrace) (b : F32) :
    t.algorithm1 = .exactReference b ↔
      t.scalarPredicate = false ∧ t.corrected = some b := by
  unfold BlockTrace.algorithm1
  rw [← exactConsolidation_eq_corrected]
  cases hp : t.scalarPredicate with
  | true =>
    obtain ⟨b', hb', _⟩ := scalarCorrected_correct t hp
    rw [hb']
    simp
  | false =>
    rw [scalarCorrected_rejects t hp]
    cases t.exactConsolidation <;> simp
```

**Supporting proofs:** [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_rejects](Extraction.md#decl-2009b13f7b61d30c)

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7c971273335df3a8"></a>

<details>
<summary><code>TensorCore.algorithm1_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L82)

```lean
/-- Whichever branch runs, a returned encoding is the correctly rounded exact sum. -/
theorem algorithm1_correct (t : BlockTrace) (b : F32) (h : t.algorithm1.bits = some b) :
    NearestEven32 t.block.exactDot b := by
  unfold BlockTrace.algorithm1 at h
  cases hs : t.scalarCorrected with
  | some b' =>
    rw [hs] at h
    simp only [Algorithm1Result.bits, Option.some.injEq] at h
    subst h
    exact tceft_correct t b' hs
  | none =>
    rw [hs] at h
    cases he : t.exactConsolidation with
    | some b' =>
      rw [he] at h
      simp only [Algorithm1Result.bits, Option.some.injEq] at h
      subst h
      rw [exactConsolidation_eq_corrected, corrected_eq_round_exactDot] at he
      obtain ⟨b'', hb'', hn⟩ := round32_nearestEven_correct _ (round32_range he)
      rw [he] at hb''
      cases Option.some.inj hb''
      exact hn
    | none =>
      rw [he] at h
      simp [Algorithm1Result.bits] at h
```

**Supporting proofs:** [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.round32_nearestEven_correct](../Numerics/CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_range](../Numerics/RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464)

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc)

</details>

</details>

<a id="decl-d32d1a35b91d3f50"></a>

<details>
<summary><code>TensorCore.algorithm1_bits_isSome_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L108)

```lean
/-- Algorithm 1 returns an encoding exactly when the exact sum is in range. -/
theorem algorithm1_bits_isSome_iff (t : BlockTrace) :
    t.algorithm1.bits.isSome = true ↔ absQ t.block.exactDot ≤ maxFinite32 := by
  unfold BlockTrace.algorithm1
  cases hs : t.scalarCorrected with
  | some b =>
    simp only [Algorithm1Result.bits, Option.isSome_some, true_iff]
    have hp : t.scalarPredicate = true := by
      apply Classical.byContradiction
      intro hne
      have hf : t.scalarPredicate = false := by grind
      rw [scalarCorrected_rejects t hf] at hs
      contradiction
    unfold BlockTrace.scalarPredicate at hp
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hp
    rw [← retained_add_low]
    exact hp.2
  | none =>
    rw [exactConsolidation_eq_corrected, corrected_eq_round_exactDot]
    cases hr : round32 .nearestEven t.block.exactDot with
    | some b =>
      simp only [Algorithm1Result.bits, Option.isSome_some, true_iff]
      exact round32_range hr
    | none =>
      simp only [Algorithm1Result.bits, Option.isSome_none, Bool.false_eq_true, false_iff]
      intro hrange
      obtain ⟨b, hb, _⟩ := round32_nearestEven_correct t.block.exactDot hrange
      rw [hr] at hb
      contradiction
```

**Supporting proofs:** [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.round32_nearestEven_correct](../Numerics/CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_range](../Numerics/RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.scalarCorrected_rejects](Extraction.md#decl-2009b13f7b61d30c)

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Numerics/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8)

</details>

</details>

<a id="decl-1553977cc91cfce7"></a>

<details>
<summary><code>TensorCore.ReferenceLedger</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L139)

```lean
/-- TC-EFT Table V: the reference branch's per-cell operation ledger for `K` products
(`n = K + 1` terms), as the paper counts it. It is an operation count, not a timing. -/
structure ReferenceLedger where
  bitDecodes : ℕ
  scaleComparisons : ℕ
  integerMultiplies : ℕ
  quotientRemainders : ℕ
  signedIntegerAdditions : ℕ
  exactDyadicSubtractions : ℕ
  exactResidualAdditions : ℕ
  exactFinalOperations : ℕ
  integerNearestEvenRoundings : ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.table_v_ledger](../Tests/EFT/Flowback.md#decl-8f03735e686248e7), [TensorCore.referenceLedger](Algorithm1.md#decl-430a31db84876fd5)

</details>

</details>

<a id="decl-430a31db84876fd5"></a>

<details>
<summary><code>TensorCore.referenceLedger</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L151)

```lean
def referenceLedger (K : ℕ) : ReferenceLedger :=
  ⟨2 * K + 2, K + 1, K, K + 1, K, 1, K, 2, 1⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ReferenceLedger](Algorithm1.md#decl-1553977cc91cfce7)

<details>
<summary>Used by</summary>

[TensorCore.Regression.table_v_ledger](../Tests/EFT/Flowback.md#decl-8f03735e686248e7)

</details>

</details>

<a id="decl-f9c4d78cf5b7996a"></a>

<details>
<summary><code>TensorCore.scalarBranchOperations</code></summary>

[Lean source](../../../TensorCore/EFT/Algorithm1.lean#L158)

```lean
/-- Successful scalar consolidation uses `n + 2` rounded FP32 operations for
`n = K + 1` terms: `naiveSum32` adds all `n` residuals starting from zero, followed
by the overlap subtraction and final addition. The paper's `n + 1` count instead
initializes its sum with the first residual. Extraction and guard work are excluded. -/
def scalarBranchOperations (K : ℕ) : ℕ := K + 3
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.table_v_ledger](../Tests/EFT/Flowback.md#decl-8f03735e686248e7)

</details>

</details>
