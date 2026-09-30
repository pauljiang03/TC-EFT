# TensorCoreTests.EFT.EFT

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-835977275143abfa"></a>

<details>
<summary><code>TensorCore.Regression.EftSnapshot</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L12)

```lean
/-- Components of the scalar EFT on one trace: extraction exponent, low parts (c first),
overlap correction, scalar predicate, scalar-branch bits computed unconditionally, and the
bits the scalar EFT returns (`none` when the predicate fails). -/
structure EftSnapshot where
  extractionExponent : ℤ
  lowParts : List ℚ
  overlap : ℚ
  scalarPredicate : Bool
  scalarBits : Option ℕ
  tceftBits : Option ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.cancellation_eft](EFT.md#decl-6b77eba48adde1d2), [TensorCore.Regression.eftSnapshot](EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.predicate_rejected](EFT.md#decl-bf8ce5f4bd10756f), [TensorCore.Regression.r2_eft](EFT.md#decl-d690dacbfcf7c018), [TensorCore.Regression.r3_eft](EFT.md#decl-1bb37a5fcad699a9), [TensorCore.Regression.subnormal_accumulator_rejected](EFT.md#decl-4c5672a5730106f4)

</details>

</details>

<a id="decl-3c783b17ffee5336"></a>

<details>
<summary><code>TensorCore.Regression.eftSnapshot</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L21)

```lean
def eftSnapshot {p : Profile} (x : BlockInput p) : Except ModelError EftSnapshot := do
  let t ← evalBlock x
  return ⟨t.extractionExponent, t.lowParts, t.overlap, t.scalarPredicate,
    t.scalarCorrectedUnchecked.map BitVec.toNat, t.tceft.map BitVec.toNat⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](../../EFT/Defs.md#decl-f4644e4a3c22871b), [TensorCore.BlockTrace.lowParts](../../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](../../EFT/Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.scalarCorrectedUnchecked](../../EFT/Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](../../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.tceft](../../EFT/Extraction.md#decl-7b07b124468a5e26), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Regression.EftSnapshot](EFT.md#decl-835977275143abfa), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cancellation_eft](EFT.md#decl-6b77eba48adde1d2), [TensorCore.Regression.predicate_rejected](EFT.md#decl-bf8ce5f4bd10756f), [TensorCore.Regression.r2_eft](EFT.md#decl-d690dacbfcf7c018), [TensorCore.Regression.r3_eft](EFT.md#decl-1bb37a5fcad699a9), [TensorCore.Regression.subnormal_accumulator_rejected](EFT.md#decl-4c5672a5730106f4)

</details>

</details>

<a id="decl-d690dacbfcf7c018"></a>

<details>
<summary><code>TensorCore.Regression.r2_eft</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L32)

```lean
/-- R2: nonzero coarse overlap with zero total residual (TC-EFT IV-A). The two small
products leave `2^-23` each below the `2^-22` extraction grid, `ε_o = 2^-22`, and the
scalar branch returns the unchanged output. -/
theorem r2_eft : eftSnapshot r2 = .ok
    ⟨-22, [0, 0, 1 / 8388608, 1 / 8388608, 0], 1 / 4194304, true,
      some 0x40300801, some 0x40300801⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.EftSnapshot](EFT.md#decl-835977275143abfa), [TensorCore.Regression.eftSnapshot](EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.r2](../TC/Cases.md#decl-35d8f7ec1d3b4b93), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1bb37a5fcad699a9"></a>

<details>
<summary><code>TensorCore.Regression.r3_eft</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L38)

```lean
/-- R3: the only low part is c's `15·2^-24`; the scalar branch corrects `4107ffff` to
`41080000`. -/
theorem r3_eft : eftSnapshot r3 = .ok
    ⟨-20, [15 / 16777216, 0, 0, 0, 0], 0, true, some 0x41080000, some 0x41080000⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.EftSnapshot](EFT.md#decl-835977275143abfa), [TensorCore.Regression.eftSnapshot](EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.r3](../TC/Cases.md#decl-0419be5c38ea4116), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b223f0d33aab3dd5"></a>

<details>
<summary><code>TensorCore.Regression.cancellationExample</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L44)

```lean
/-- The TC-EFT §V-D cancellation example: output `449fbe50`, low parts `5/16384` and
`15/8192`, no overlap, and the tie resolved to `449fbe62` by the scalar branch. -/
def cancellationExample : V100Input :=
  ⟨[(0xd83d, 0x5a03), (0x5061, 0x5722), (0x444c, 0x49d5), (0x5810, 0x5976)], 0x4416cfe5⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](../TC/Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.cancellation_eft](EFT.md#decl-6b77eba48adde1d2)

</details>

</details>

<a id="decl-6b77eba48adde1d2"></a>

<details>
<summary><code>TensorCore.Regression.cancellation_eft</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L47)

```lean
theorem cancellation_eft :
    outputBits cancellationExample = .ok 0x449fbe50 ∧
    eftSnapshot cancellationExample = .ok
      ⟨-9, [5 / 16384, 0, 0, 15 / 8192, 0], 0, true, some 0x449fbe62, some 0x449fbe62⟩ := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.EftSnapshot](EFT.md#decl-835977275143abfa), [TensorCore.Regression.cancellationExample](EFT.md#decl-b223f0d33aab3dd5), [TensorCore.Regression.eftSnapshot](EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.outputBits](../TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5b2dcd48a837249a"></a>

<details>
<summary><code>TensorCore.Regression.supportOverflow</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L56)

```lean
/-- Three products near `128` on a `2^-15` grid next to a `2^-48` product exceed the
24-bit coefficient budget on the common grid. The predicate fails, the scalar EFT returns
nothing, and only the exact-rational reference gives `4e800003`. -/
def supportOverflow : V100Input :=
  ⟨[(0x5bff, 0x37ff), (0x5bff, 0x37ff), (0x5bff, 0x37ff), (1, 1)], 0x4e800000⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](../TC/Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.BoundedEFT.consolidation_branches](BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.algorithm1_cases](Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.encoded_eft_branches](EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.predicate_rejected](EFT.md#decl-bf8ce5f4bd10756f)

</details>

</details>

<a id="decl-bf8ce5f4bd10756f"></a>

<details>
<summary><code>TensorCore.Regression.predicate_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L59)

```lean
theorem predicate_rejected :
    outputBits supportOverflow = .ok 0x4e800000 ∧
    ((eftSnapshot supportOverflow).map fun s => (s.scalarPredicate, s.tceftBits)) =
      .ok (false, none) ∧
    ((snapshot supportOverflow).map fun s => s.correctedBits) = .ok (some 0x4e800003) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.EftSnapshot](EFT.md#decl-835977275143abfa), [TensorCore.Regression.Snapshot](../TC/Cases.md#decl-cbc8908708a1e1bf), [TensorCore.Regression.eftSnapshot](EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.outputBits](../TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.snapshot](../TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.supportOverflow](EFT.md#decl-5b2dcd48a837249a), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5abbb5145c17d893"></a>

<details>
<summary><code>TensorCore.Regression.subnormalAccumulator</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L71)

```lean
/-- A subnormal accumulator `2^-149` with products `1` and `2^-24`: the output is `1`, the
exact sum `1 + 2^-24 + 2^-149` rounds up to `3f800001`, but naive FP32 summation of the low
parts loses `2^-149` and the scalar branch would return the tie-rounded `3f800000`. The
support grid `2^-149` puts the coefficient sum far above `2^24`, so the predicate rejects
the case and the scalar EFT returns nothing. -/
def subnormalAccumulator : V100Input :=
  ⟨[(0x3c00, 0x3c00), (0x0001, 0x3c00), (0, 0), (0, 0)], 0x00000001⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](../TC/Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.BoundedEFT.consolidation_branches](BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.algorithm1_cases](Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.encoded_eft_branches](EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.scalar64_subnormal_guard_rejects](ScalarEFT.md#decl-6132856fad76f2bb), [TensorCore.Regression.scalar_public_subnormal_rejected](EFT.md#decl-15c9e1f2ec694c3a), [TensorCore.Regression.subnormal_accumulator_rejected](EFT.md#decl-4c5672a5730106f4)

</details>

</details>

<a id="decl-4c5672a5730106f4"></a>

<details>
<summary><code>TensorCore.Regression.subnormal_accumulator_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L74)

```lean
theorem subnormal_accumulator_rejected :
    outputBits subnormalAccumulator = .ok 0x3f800000 ∧
    ((eftSnapshot subnormalAccumulator).map fun s =>
      (s.extractionExponent, s.scalarPredicate, s.scalarBits, s.tceftBits)) =
      .ok (-23, false, some 0x3f800000, none) ∧
    ((snapshot subnormalAccumulator).map fun s => s.correctedBits) = .ok (some 0x3f800001) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.EftSnapshot](EFT.md#decl-835977275143abfa), [TensorCore.Regression.Snapshot](../TC/Cases.md#decl-cbc8908708a1e1bf), [TensorCore.Regression.eftSnapshot](EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.outputBits](../TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.snapshot](../TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.subnormalAccumulator](EFT.md#decl-5abbb5145c17d893), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-15c9e1f2ec694c3a"></a>

<details>
<summary><code>TensorCore.Regression.scalar_public_subnormal_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L83)

```lean
/-- Both public names enforce the guard on the subnormal counterexample. -/
theorem scalar_public_subnormal_rejected :
    ((evalBlock subnormalAccumulator).map fun t =>
      (t.scalarCorrected, t.tceft)) = .ok (none, none) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](../../EFT/Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.tceft](../../EFT/Extraction.md#decl-7b07b124468a5e26), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.subnormalAccumulator](EFT.md#decl-5abbb5145c17d893), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-deb2ed8170b801e3"></a>

<details>
<summary><code>TensorCore.Regression.scalar_public_r3</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L88)

```lean
/-- A correction that changes the output remains available through the safe helper. -/
theorem scalar_public_r3 :
    ((evalBlock r3).map fun t => t.scalarCorrected.map BitVec.toNat) =
      .ok (some 0x41080000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](../../EFT/Extraction.md#decl-d043d5f94dfed74a), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.r3](../TC/Cases.md#decl-0419be5c38ea4116), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-80f4870bbf3f2f51"></a>

<details>
<summary><code>TensorCore.Regression.broadFiniteCounterexample</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L94)

```lean
/-- Seed 20260906, finite-bit V100 sample 250: the unchecked branch changes an
already correctly rounded model output to its neighbor. The guard must reject. -/
def broadFiniteCounterexample : V100Input :=
  ⟨[(0x210f, 0x4553), (0x5a5b, 0x9753), (0x9a0b, 0xd06e), (0xd68c, 0x1eb6)],
    0x238ac5ec⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](../TC/Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.broad_finite_unchecked_incorrect](EFT.md#decl-cb45e79b5c259faf)

</details>

</details>

<a id="decl-cb45e79b5c259faf"></a>

<details>
<summary><code>TensorCore.Regression.broad_finite_unchecked_incorrect</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/EFT.lean#L98)

```lean
theorem broad_finite_unchecked_incorrect :
    ((evalBlock broadFiniteCounterexample).map fun t =>
      (t.output.bits.toNat, t.scalarCorrectedUnchecked.map BitVec.toNat,
        t.corrected.map BitVec.toNat, t.scalarCorrected)) =
      .ok (3211041529, some 3211041530, some 3211041529, none) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](../../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.scalarCorrected](../../EFT/Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](../../EFT/Extraction.md#decl-b298427558415577), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.broadFiniteCounterexample](EFT.md#decl-80f4870bbf3f2f51), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
