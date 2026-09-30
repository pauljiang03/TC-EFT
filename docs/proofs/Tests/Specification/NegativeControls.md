# TensorCoreTests.Specification.NegativeControls

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c655af5e3b62b4a8"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.normalized</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L13)

```lean
def normalized (t : Term) : Term :=
  if magnitude t.value ≥ (2 : ℚ) ^ (t.exponent + 1) then
    ⟨t.value, t.exponent + 1⟩ else t
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.normalizedBits](NegativeControls.md#decl-e19ba3c5a394b16f)

</details>

</details>

<a id="decl-e19ba3c5a394b16f"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.normalizedBits</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L17)

```lean
def normalizedBits (p : Parameters) (x : Input p) : Option F32 := do
  let ts ← terms p x
  round32 .towardZero (accumulated p (ts.map normalized))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Controls.normalized](NegativeControls.md#decl-c655af5e3b62b4a8), [TensorCore.PaperSpec.Input](../../TC/Specification/Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](../../TC/Specification/Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.terms](../../TC/Specification/Defs.md#decl-56cdff4895ab7ed6), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.premature_normalization_detected](NegativeControls.md#decl-6075ac4e18b56d7d)

</details>

</details>

<a id="decl-617af7d5092e241f"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.noFloorBits</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L21)

```lean
def noFloorBits (p : Parameters) (x : Input p) : Option F32 := do
  let ts ← terms p x
  round32 .towardZero (accumulated { p with floor := none } ts)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Input](../../TC/Specification/Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](../../TC/Specification/Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.terms](../../TC/Specification/Defs.md#decl-56cdff4895ab7ed6), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](NegativeControls.md#decl-5431b897ba61c21e)

</details>

</details>

<a id="decl-823e646d044e757f"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.ieeeAlignmentBits</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L26)

```lean
/-- Incorrectly replace common-grid alignment by IEEE-style RTZ of each term. -/
def ieeeAlignmentBits (p : Parameters) (x : Input p) : Option F32 := do
  let ts ← terms p x
  let rounded ← ts.mapM fun t => do
    let b ← round32 .towardZero t.value
    TensorCore.value32 b
  round32 .towardZero (rounded.foldr (· + ·) 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Input](../../TC/Specification/Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.terms](../../TC/Specification/Defs.md#decl-56cdff4895ab7ed6), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ieee_alignment_detected](NegativeControls.md#decl-767d09c4aacc0efe)

</details>

</details>

<a id="decl-6075ac4e18b56d7d"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.premature_normalization_detected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L33)

```lean
theorem premature_normalization_detected :
    normalizedBits (parametersOf v100F16F32) (inputOf Regression.r1a) = some 0x40100000 ∧
    bits (parametersOf v100F16F32) (inputOf Regression.r1a) = some 0x40100001 := by
  constructor
  · decide +kernel
  · rw [← implementation_eq_paper]
    decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](../../TC/Specification/Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Controls.normalizedBits](NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.bits](../../TC/Specification/Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](../../TC/Specification/Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.Regression.r1a](../TC/Cases.md#decl-e1107d0ad35081f3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-767d09c4aacc0efe"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.ieee_alignment_detected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L41)

```lean
theorem ieee_alignment_detected :
    ieeeAlignmentBits (parametersOf v100F16F32) (inputOf Regression.r1b) = some 0x40100001 ∧
    bits (parametersOf v100F16F32) (inputOf Regression.r1b) = some 0x40100000 := by
  constructor
  · decide +kernel
  · rw [← implementation_eq_paper]
    decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](../../TC/Specification/Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Controls.ieeeAlignmentBits](NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.bits](../../TC/Specification/Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](../../TC/Specification/Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.Regression.r1b](../TC/Cases.md#decl-5f69a6e568d8f739), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a20e96d306f650cf"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.ampereFloorInput</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L51)

```lean
/-- A100: p1 = sum_{j=150..155} 2^-j, p2 = 2^-156, p3 = p4 = 2^-157.
The floor discards p3/p4; removing it spuriously produces the minimum subnormal. -/
def ampereFloorInput : BlockInput a100BF16F32 :=
  ⟨[(0x1a7c, 0x1a00), (0x1880, 0x1880), (0x1880, 0x1800), (0x1880, 0x1800)] ++
    List.replicate 4 (0, 0), 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.a100BF16F32](../../TC/CanonicalFormatDefs.md#decl-93f6070f8a03aaee)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](NegativeControls.md#decl-570be3c40e93b1c2)

</details>

</details>

<a id="decl-686fb49328f7f769"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.hopperFloorInput</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L56)

```lean
/-- Hopper's finer grid needs a separate witness at its own floor. -/
def hopperFloorInput : BlockInput hopperBF16F32 :=
  ⟨[(0x1a7f, 0x1a00), (0x1800, 0x1800), (0x1800, 0x1780), (0x1800, 0x1780)] ++
    List.replicate 12 (0, 0), 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.hopperBF16F32](../../TC/CanonicalFormatDefs.md#decl-c021958593ae7dc6)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](NegativeControls.md#decl-5431b897ba61c21e)

</details>

</details>

<a id="decl-570be3c40e93b1c2"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.ampere_floor_removal_detected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L60)

```lean
theorem ampere_floor_removal_detected :
    noFloorBits (parametersOf a100BF16F32) (inputOf ampereFloorInput) = some 1 ∧
    bits (parametersOf a100BF16F32) (inputOf ampereFloorInput) = some 0 := by
  constructor
  · decide +kernel
  · rw [← implementation_eq_paper]
    decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](../../TC/Specification/Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Controls.ampereFloorInput](NegativeControls.md#decl-a20e96d306f650cf), [TensorCore.PaperSpec.Controls.noFloorBits](NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.bits](../../TC/Specification/Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](../../TC/Specification/Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.a100BF16F32](../../TC/CanonicalFormatDefs.md#decl-93f6070f8a03aaee), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5431b897ba61c21e"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.hopper_floor_removal_detected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L68)

```lean
theorem hopper_floor_removal_detected :
    noFloorBits (parametersOf hopperBF16F32) (inputOf hopperFloorInput) = some 1 ∧
    bits (parametersOf hopperBF16F32) (inputOf hopperFloorInput) = some 0 := by
  constructor
  · decide +kernel
  · rw [← implementation_eq_paper]
    decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](../../TC/Specification/Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Controls.hopperFloorInput](NegativeControls.md#decl-686fb49328f7f769), [TensorCore.PaperSpec.Controls.noFloorBits](NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.bits](../../TC/Specification/Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](../../TC/Specification/Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.hopperBF16F32](../../TC/CanonicalFormatDefs.md#decl-c021958593ae7dc6)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8e4915334c72f77b"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.cancelGroup</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L76)

```lean
def cancelGroup : List (F16 × F16) := (0xbc00, 0x3c00) :: List.replicate 7 (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.group_reversal_detected](NegativeControls.md#decl-34343729ff830b30)

</details>

</details>

<a id="decl-bc3fd5a4553789a6"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.tinyGroup</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L77)

```lean
def tinyGroup : List (F16 × F16) := (1, 0x3c00) :: List.replicate 7 (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.group_reversal_detected](NegativeControls.md#decl-34343729ff830b30)

</details>

</details>

<a id="decl-34343729ff830b30"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.group_reversal_detected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L79)

```lean
theorem group_reversal_detected :
    lastBits (parametersOf ampereF16F32) 0x3f800000 [cancelGroup, tinyGroup] = some 0x33800000 ∧
    lastBits (parametersOf ampereF16F32) 0x3f800000 [tinyGroup, cancelGroup] = some 0 := by
  constructor
  · exact (schedule_last_eq_paper ampereF16F32 0x3f800000 [cancelGroup, tinyGroup]).symm.trans
      (by decide +kernel)
  · exact (schedule_last_eq_paper ampereF16F32 0x3f800000 [tinyGroup, cancelGroup]).symm.trans
      (by decide +kernel)
```

**Supporting proofs:** [TensorCore.PaperSpec.schedule_last_eq_paper](../../TC/Specification/Composition.md#decl-551846c5cac8f668)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Controls.cancelGroup](NegativeControls.md#decl-8e4915334c72f77b), [TensorCore.PaperSpec.Controls.tinyGroup](NegativeControls.md#decl-bc3fd5a4553789a6), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.lastBits](../../TC/Specification/Schedule.md#decl-3bc0435f1504df60), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.ampereF16F32](../../TC/CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.runBlocks](../../TC/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1c0835dee2595631"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.signed_zero_is_required</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L89)

```lean
/-- Value equality alone cannot distinguish these two encodings; the sign clause can. -/
theorem signed_zero_is_required :
    Rounds (-(2 : ℚ) ^ (-150 : ℤ)) 0x80000000 ∧
    ¬ Rounds (-(2 : ℚ) ^ (-150 : ℤ)) 0 := by
  constructor
  · apply round32_rounds
    decide +kernel
  · intro h
    have hs := h.1
    have hx : (-(2 : ℚ) ^ (-150 : ℤ)) < 0 := by decide +kernel
    simp [hx] at hs
```

**Supporting proofs:** [TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826)

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PaperSpec.Between](../../TC/Specification/Defs.md#decl-4a8f7985f3bff078), [TensorCore.PaperSpec.Rounds](../../TC/Specification/Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-927ca5066fffe4ae"></a>

<details>
<summary><code>TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries</code></summary>

[Lean source](../../../../tests/TensorCoreTests/Specification/NegativeControls.lean#L100)

```lean
theorem all_zero_and_nonfinite_boundaries :
    bits (parametersOf v100F16F32)
      (inputOf (⟨List.replicate 4 (0x8000, 0), 0x80000000⟩ : BlockInput v100F16F32)) = some 0 ∧
    bits (parametersOf v100F16F32)
      (inputOf (⟨List.replicate 4 (0x7c00, 0), 0⟩ : BlockInput v100F16F32)) = none := by
  constructor <;> rw [← implementation_eq_paper] <;> decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](../../TC/Specification/Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.bits](../../TC/Specification/Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](../../TC/Specification/Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
