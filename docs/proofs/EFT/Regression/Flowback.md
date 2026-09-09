# TensorCore.EFT.Regression.Flowback

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d132256d0746be26"></a>

<details>
<summary><code>TensorCore.Regression.v100_witness_flowback</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/Flowback.lean#L16)

```lean
/-- The V100 Table III witness in Definition III.3's terms: `c = 1`, `c' = 1 − 2^-24`, four
products `2^-24`. Every product flows back (`ω = 4·2^-24`), the accumulator input loses
`ΔA = 2^-24`, and the output rises from `3f800000` to `3f800001`. -/
theorem v100_witness_flowback :
    flowback v100F16F32 (List.replicate 4 (halfDecoded (-12), halfDecoded (-12)))
      oneDecoded belowOneDecoded = 4 / 16777216 ∧
    accumulatorShift v100F16F32 (List.replicate 4 (halfDecoded (-12), halfDecoded (-12)))
      oneDecoded belowOneDecoded = 1 / 16777216 ∧
    (evalPrepared ⟨v100F16F32, List.replicate 4 (halfDecoded (-12), halfDecoded (-12)),
      oneDecoded⟩).map (fun t => t.output.bits.toNat) = .ok 0x3f800000 ∧
    (evalPrepared ⟨v100F16F32, List.replicate 4 (halfDecoded (-12), halfDecoded (-12)),
      belowOneDecoded⟩).map (fun t => t.output.bits.toNat) = .ok 0x3f800001 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.accumulatorShift](../../TC/Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.belowOneDecoded](../../TC/Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.evalPrepared](../../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.flowback](../../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.halfDecoded](../../TC/Regression/Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.oneDecoded](../../TC/Monotonicity.md#decl-8451c87f719a4189), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a4e884b9b60d7c4f"></a>

<details>
<summary><code>TensorCore.Regression.flowback_without_increase</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/Flowback.lean#L30)

```lean
/-- Necessity is not sufficiency: with two products `ω = 2·2^-24` still exceeds
`ΔA = 2^-24`, but the perturbed accumulator `1 + 2^-24` is not representable and truncates
back to `1`, so the output does not rise. -/
theorem flowback_without_increase :
    flowback (fp16Fp32Profile 2 0 none) (List.replicate 2 (halfDecoded (-12), halfDecoded (-12)))
      oneDecoded belowOneDecoded = 2 / 16777216 ∧
    accumulatorShift (fp16Fp32Profile 2 0 none)
      (List.replicate 2 (halfDecoded (-12), halfDecoded (-12))) oneDecoded belowOneDecoded =
      1 / 16777216 ∧
    (evalPrepared ⟨fp16Fp32Profile 2 0 none,
      List.replicate 2 (halfDecoded (-12), halfDecoded (-12)), belowOneDecoded⟩).map
      (fun t => (t.output.bits.toNat, t.block.accumulator)) =
      .ok (0x3f800000, 16777217 / 16777216) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.accumulatorShift](../../TC/Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.belowOneDecoded](../../TC/Monotonicity.md#decl-7f145f1d885aa020), [TensorCore.evalPrepared](../../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.flowback](../../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](../../TC/Regression/Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.oneDecoded](../../TC/Monotonicity.md#decl-8451c87f719a4189)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-725fd4d619d07b0f"></a>

<details>
<summary><code>TensorCore.Regression.v100_products_not_monotone</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/Flowback.lean#L43)

```lean
/-- Theorem III.4 as a failure of Definition III.2 on the V100 family with `K = 4`. -/
theorem v100_products_not_monotone :
    ¬ MonotoneInAccumulator v100F16F32 (List.replicate 4 (halfDecoded (-12), halfDecoded (-12))) :=
  construction_not_monotone v100F16F32 0 4 (halfDecoded (-12)) (halfDecoded (-12)) rfl
    (by simp [v100F16F32]) (by decide +kernel) (by decide +kernel)
    (by decide) (by decide)
```

**Supporting proofs:** [TensorCore.construction_not_monotone](../../TC/Flowback.md#decl-804334e6bcfbdb8f)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.MonotoneInAccumulator](../../TC/Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.halfDecoded](../../TC/Regression/Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a60fb69ed62b3b2b"></a>

<details>
<summary><code>TensorCore.Regression.algorithm1_cases</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/Flowback.lean#L52)

```lean
/-- Algorithm 1 on the EFT cases: R3 takes the scalar branch, the coefficient-budget and
subnormal-accumulator cases take the exact reference branch. R3's overlap window is
`τ = 3` (extraction grid `2^-20` over alignment grid `2^-23`). -/
theorem algorithm1_cases :
    (evalBlock r3).map (fun t => (t.algorithm1, t.extractionExponent - t.block.quantumExponent)) =
      .ok (.scalar 0x41080000, 3) ∧
    (evalBlock supportOverflow).map (fun t => t.algorithm1) = .ok (.exactReference 0x4e800003) ∧
    (evalBlock subnormalAccumulator).map (fun t => t.algorithm1) =
      .ok (.exactReference 0x3f800001) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](../Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](../Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.extractionExponent](../Defs.md#decl-f4644e4a3c22871b), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.quantumExponent](../../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.Regression.r3](../../TC/Regression/Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.subnormalAccumulator](EFT.md#decl-5abbb5145c17d893), [TensorCore.Regression.supportOverflow](EFT.md#decl-5b2dcd48a837249a), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8f03735e686248e7"></a>

<details>
<summary><code>TensorCore.Regression.table_v_ledger</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/Flowback.lean#L62)

```lean
/-- TC-EFT Table V for `K = 4` (`n = 5` terms), and the implemented scalar
consolidation's `n + 2` operations, including its initial addition to zero. -/
theorem table_v_ledger :
    referenceLedger 4 = ⟨10, 5, 4, 5, 4, 1, 4, 2, 1⟩ ∧ scalarBranchOperations 4 = 7 := by
  decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ReferenceLedger](../Algorithm1.md#decl-1553977cc91cfce7), [TensorCore.referenceLedger](../Algorithm1.md#decl-430a31db84876fd5), [TensorCore.scalarBranchOperations](../Algorithm1.md#decl-f9c4d78cf5b7996a)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
