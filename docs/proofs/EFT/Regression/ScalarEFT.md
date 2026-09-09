# TensorCore.EFT.Regression.ScalarEFT

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-cb03ef10bf4e4cbd"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_subnormal_sum</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L12)

```lean
theorem scalar64_subnormal_sum :
    naiveSumBinary fp64 [pow2 (-1074), -pow2 (-1074), 2 * pow2 (-1074)] =
      some (2 * pow2 (-1074)) ∧
    naiveSumBinary fp64 [] = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.naiveSumBinary](../../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-04af8db10d4464ca"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_preserves_low_component</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L18)

```lean
/-- The 53-bit format preserves a residual that 24-bit additions lose under cancellation. -/
theorem scalar64_preserves_low_component :
    naiveSumBinary fp64 [1, pow2 (-51), -1] = some (pow2 (-51)) ∧
    naiveSum32 [1, pow2 (-51), -1] = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.naiveSum32](../../Core/ScalarSum.md#decl-928516c1237c62d4), [TensorCore.naiveSumBinary](../../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-71ebab7703c3a1c5"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_coarse_grid</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L23)

```lean
/-- Coarser than emax−52 is allowed when the actual coefficient fits the finite range. -/
theorem scalar64_coarse_grid : naiveSumBinary fp64 [pow2 1023] = some (pow2 1023) := by
  have h := naiveSum64_exact 1023 (by decide) [1] (by decide)
    (by decide +kernel)
  simpa [magnitudeSum, sumZ] using h
```

**Supporting proofs:** [TensorCore.naiveSum64_exact](../../Core/Binary/ScalarSum.md#decl-d74afdeb99860469)

**Definitions and types:** [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.magnitudeSum](../../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](../../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-07c0da524b066707"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_prefix_overflow</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L29)

```lean
/-- Final cancellation does not justify overflowing an earlier prefix. -/
theorem scalar64_prefix_overflow :
    naiveSumBinary fp64 [fp64.maxFinite, fp64.maxFinite, -fp64.maxFinite] = none := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.naiveSumBinary](../../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2400fe596e80a925"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_finite_boundary</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L33)

```lean
theorem scalar64_finite_boundary :
    binaryAdd fp64 fp64.maxFinite 0 = some fp64.maxFinite ∧
    binaryAdd fp64 fp64.maxFinite (pow2 971) = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.binaryAdd](../../Core/Binary/ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-486a5f125177b3ef"></a>

<details>
<summary><code>TensorCore.Regression.scalar_coefficient_boundary</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L38)

```lean
/-- A budget can fail even though the signed final sum fits. -/
theorem scalar_coefficient_boundary :
    magnitudeSum [2 ^ 52 - 1, 2 ^ 52] < 2 ^ 53 ∧
    ¬ magnitudeSum [2 ^ 52, -(2 ^ 52)] < 2 ^ 53 ∧
    ceilLog2 0 = 0 ∧ ceilLog2 1 = 0 ∧ ceilLog2 8 = 3 ∧ ceilLog2 9 = 4 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ceilLog2](../../Core/Sum.md#decl-19c2da9023bf4c87), [TensorCore.magnitudeSum](../../Core/Sum.md#decl-87fa253b5e1d3c24)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4f8ed7cf41298ebe"></a>

<details>
<summary><code>TensorCore.Regression.scalar_bitSpan_budget</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L45)

```lean
/-- Exercise the paper's bit-span theorem at equality, with a signed list. -/
theorem scalar_bitSpan_budget : magnitudeSum [7, -7, 7, -7] < 2 ^ 5 := by
  apply bitSpan_coefficient_bound [7, -7, 7, -7] 2 0 5
  · intro z hz
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hz
    rcases hz with h | h | h | h <;> subst z <;> decide +kernel
  · decide +kernel
```

**Supporting proofs:** [TensorCore.bitSpan_coefficient_bound](../../Core/Sum.md#decl-dd359e6ccc782af7)

**Definitions and types:** [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.ceilLog2](../../Core/Sum.md#decl-19c2da9023bf4c87), [TensorCore.magnitudeSum](../../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-80912967825ad7ba"></a>

<details>
<summary><code>TensorCore.Regression.scalar64DoubleRound</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L54)

```lean
/-- D = 1 and S = 1 + 2^-24 + 2^-53. The FP64 residual budget fits, but rounding S
to FP64 first lands on the FP32 midpoint and then rounds the wrong way. -/
def scalar64DoubleRound : V100Input :=
  ⟨[(0x3c00, 0x3c00), (0x0001, 0x3c00), (0, 0), (0, 0)], 0x25000000⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](../../TC/Regression/Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scalar64_corrects_midpoint](ScalarEFT.md#decl-18ee9a4ee42888ea)

</details>

</details>

<a id="decl-18ee9a4ee42888ea"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_corrects_midpoint</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L57)

```lean
theorem scalar64_corrects_midpoint :
    ((evalBlock scalar64DoubleRound).map fun t =>
      (t.output.bits.toNat, t.scalarPredicate, t.scalarPredicateIn fp64,
        t.scalarCorrectedIn fp64 |>.map BitVec.toNat)) =
      .ok (0x3f800000, false, true, some 0x3f800001) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](../Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarPredicate](../Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../Scalar.md#decl-41be156bbdd880fc), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.scalar64DoubleRound](ScalarEFT.md#decl-80912967825ad7ba), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-75316677317adbed"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_double_rounding_incorrect</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L63)

```lean
theorem scalar64_double_rounding_incorrect :
    (round32 .nearestEven (1 + pow2 (-24) + pow2 (-53))).map BitVec.toNat = some 0x3f800001 ∧
    (((roundBinary fp64 .nearestEven (1 + pow2 (-24) + pow2 (-53))).bind (binaryValue fp64)).bind
      (round32 .nearestEven)).map BitVec.toNat = some 0x3f800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6132856fad76f2bb"></a>

<details>
<summary><code>TensorCore.Regression.scalar64_subnormal_guard_rejects</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L69)

```lean
/-- More precision still does not authorize unsafe summation on the subnormal witness. -/
theorem scalar64_subnormal_guard_rejects :
    ((evalBlock subnormalAccumulator).map fun t =>
      (t.scalarPredicateIn fp64, t.scalarCorrectedIn fp64)) = .ok (false, none) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](../Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarPredicateIn](../Scalar.md#decl-41be156bbdd880fc), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.subnormalAccumulator](EFT.md#decl-5abbb5145c17d893), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f7a094e3217d8fda"></a>

<details>
<summary><code>TensorCore.Regression.scalar_generic_invalid_format_rejects</code></summary>

[Lean source](../../../../TensorCore/EFT/Regression/ScalarEFT.lean#L74)

```lean
theorem scalar_generic_invalid_format_rejects :
    ((evalBlock r3).map fun t => t.scalarCorrectedIn ⟨0, 8, 127⟩) = .ok none := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](../Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.r3](../../TC/Regression/Cases.md#decl-0419be5c38ea4116), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
