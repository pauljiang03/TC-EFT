# TensorCoreTests.TC.Composition

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2a94d3f3b7353f49"></a>

<details>
<summary><code>TensorCore.Regression.cancelEightAndHalf</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Composition.lean#L9)

```lean
/-- The second block cancels 17/2, exposing the first block's lost residual. -/
def cancelEightAndHalf : List (v100F16F32.Word × v100F16F32.Word) :=
  [(0xc000, 0x4400), (0xb800, 0x3c00), (0, 0), (0, 0)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.twoBlockCorrection](Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](Composition.md#decl-27d6915f955ce3fa)

</details>

</details>

<a id="decl-27d6915f955ce3fa"></a>

<details>
<summary><code>TensorCore.Regression.twoBlockSummary</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Composition.lean#L12)

```lean
def twoBlockSummary : Except ModelError (List ℕ × ℚ × ℚ) := do
  let ts ← runV100 r3.c [r3.products, cancelEightAndHalf]
  let last := ts.getLast?.map (fun t => t.output.value)
  return (ts.map (fun t => t.output.bits.toNat),
    sumQ (ts.map BlockTrace.residual), last.getD 0 + sumQ (ts.map BlockTrace.residual))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](../../TC/Block.md#decl-29503c8290420b97), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.cancelEightAndHalf](Composition.md#decl-2a94d3f3b7353f49), [TensorCore.Regression.r3](Cases.md#decl-0419be5c38ea4116), [TensorCore.runV100](../../TC/Composition.md#decl-db0ac9bfd91eb790), [TensorCore.sumQ](../../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.two_block_cancellation](Composition.md#decl-5f6a1741627b19bc)

</details>

</details>

<a id="decl-5f6a1741627b19bc"></a>

<details>
<summary><code>TensorCore.Regression.two_block_cancellation</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Composition.lean#L21)

```lean
theorem two_block_cancellation :
    twoBlockSummary = .ok ([0x4107ffff, 0xb5800000],
      15 / 16777216, -1 / 16777216) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.twoBlockSummary](Composition.md#decl-27d6915f955ce3fa)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ce09e036dcdb2b94"></a>

<details>
<summary><code>TensorCore.Regression.twoBlockCorrection</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Composition.lean#L25)

```lean
def twoBlockCorrection : Except ModelError (Option F32) := do
  let ts ← runV100 r3.c [r3.products, cancelEightAndHalf]
  let some initial := finite32 r3.c | .error .nonfiniteInput
  return correctedSchedule initial ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.cancelEightAndHalf](Composition.md#decl-2a94d3f3b7353f49), [TensorCore.Regression.r3](Cases.md#decl-0419be5c38ea4116), [TensorCore.correctedSchedule](../../TC/Correction.md#decl-968ff850f4220ec9), [TensorCore.finite32](../../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.runV100](../../TC/Composition.md#decl-db0ac9bfd91eb790), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.two_block_corrected](Composition.md#decl-ee25e15fcb98163d)

</details>

</details>

<a id="decl-ee25e15fcb98163d"></a>

<details>
<summary><code>TensorCore.Regression.two_block_corrected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Composition.lean#L30)

```lean
theorem two_block_corrected : twoBlockCorrection = .ok (some 0xb3800000) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.twoBlockCorrection](Composition.md#decl-ce09e036dcdb2b94)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7fa1f7d6ed299760"></a>

<details>
<summary><code>TensorCore.Regression.r4_midpoint_distances</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Composition.lean#L34)

```lean
/-- A finite value-level midpoint check independently documents the handoff correction. -/
theorem r4_midpoint_distances :
    absQ ((1 - 3 * pow2 (-25)) - (1 - pow2 (-23))) = pow2 (-25) ∧
    absQ ((1 - 3 * pow2 (-25)) - (1 - pow2 (-24))) = pow2 (-25) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
