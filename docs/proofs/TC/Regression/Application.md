# TensorCore.TC.Regression.Application

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0d97c0b15dd8cf45"></a>

<details>
<summary><code>TensorCore.Regression.one32</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L11)

```lean
def one32 : Finite32 := ⟨0x3f800000, ⟨8388608, 0, 23⟩, by decide +kernel⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.changing_loop_has_rounding_error](Application.md#decl-3ad8e32bd2a7f1a0), [TensorCore.Regression.partial_tail_signed_accepted](Application.md#decl-a4d99b23e0557695), [TensorCore.Regression.symbolic_changing_loop](Application.md#decl-d4a47d36d3054d89)

</details>

</details>

<a id="decl-816e23b02227fd68"></a>

<details>
<summary><code>TensorCore.Regression.smallBody</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L13)

```lean
def smallBody : Program v100F16F32 := tc%{
  block "changing state" [(0x2bff, 0x2bff), (0x2bff, 0x2bff),
    (0x2bff, 0x2bff), (0x2bff, 0x2bff)];
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.symbolic_changing_loop](Application.md#decl-d4a47d36d3054d89)

</details>

</details>

<a id="decl-d4a47d36d3054d89"></a>

<details>
<summary><code>TensorCore.Regression.symbolic_changing_loop</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L18)

```lean
theorem symbolic_changing_loop (n : ℕ) (hn : n ≤ 64) :
    (Program.repeat n smallBody).Accurate one32.bits (1 / 2048) := by
  apply small_repeat_accurate smallBody n one32
  · simpa [smallBody, Program.inputs, Program.blocks] using hn
  · intro g hg pair hp
    have hg' : g = [(0x2bff, 0x2bff), (0x2bff, 0x2bff), (0x2bff, 0x2bff), (0x2bff, 0x2bff)] := by
      simpa [smallBody, Program.inputs, Program.blocks, BlockOperands.ofNats] using hg
    rw [hg'] at hp
    have hp' : pair = (0x2bff, 0x2bff) := by simpa using hp
    rw [hp']
    decide +kernel
  · decide +kernel
```

**Supporting proofs:** [TensorCore.small_repeat_accurate](../Examples/BoundedDot.md#decl-13ea2e2e9f51acd8)

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Accurate](../Program/CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.blocks](../Program/Defs.md#decl-e6562fd402604610), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.Regression.one32](Application.md#decl-0d97c0b15dd8cf45), [TensorCore.Regression.smallBody](Application.md#decl-816e23b02227fd68), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.small16](../Examples/BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3ad8e32bd2a7f1a0"></a>

<details>
<summary><code>TensorCore.Regression.changing_loop_has_rounding_error</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L31)

```lean
theorem changing_loop_has_rounding_error :
    (match lossyProgram.run one32.bits with
      | .error _ => false
      | .ok ts => (lastOutput one32 ts).bits != one32.bits &&
          decide ((lossyProgram.ideal one32.bits).getD 0 ≠ (lastOutput one32 ts).value)) = true := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Program.ideal](../Program/Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.run](../Program/Defs.md#decl-7a1c9df214179ea0), [TensorCore.Regression.lossyProgram](Certification.md#decl-051cf35b9a4ff28d), [TensorCore.Regression.one32](Application.md#decl-0d97c0b15dd8cf45), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a4d99b23e0557695"></a>

<details>
<summary><code>TensorCore.Regression.partial_tail_signed_accepted</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L38)

```lean
theorem partial_tail_signed_accepted :
    boundedDotCheck [(0x2bff, 0x2bff), (0xabff, 0x2bff), (0x0001, 0x8001)] one32.bits = true := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Regression.one32](Application.md#decl-0d97c0b15dd8cf45), [TensorCore.boundedDotCheck](../Examples/BoundedDot.md#decl-ec759e24e02a72b7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b1aee65536843a4f"></a>

<details>
<summary><code>TensorCore.Regression.at_operand_boundary_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L42)

```lean
theorem at_operand_boundary_refused : small16 0x2c00 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.small16](../Examples/BoundedDot.md#decl-af4a8584ae650d2f)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c6a6f90552528041"></a>

<details>
<summary><code>TensorCore.Regression.nan_operand_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L43)

```lean
theorem nan_operand_refused : small16 0x7e00 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.small16](../Examples/BoundedDot.md#decl-af4a8584ae650d2f)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-21e2b5150c115b82"></a>

<details>
<summary><code>TensorCore.Regression.signed_zero_allowed</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L44)

```lean
theorem signed_zero_allowed : small16 0x8000 = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.small16](../Examples/BoundedDot.md#decl-af4a8584ae650d2f)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-75eec7aac97709f8"></a>

<details>
<summary><code>TensorCore.Regression.too_long_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L45)

```lean
theorem too_long_refused : boundedDotCheck (List.replicate 257 (0, 0)) 0 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.boundedDotCheck](../Examples/BoundedDot.md#decl-ec759e24e02a72b7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1bef74ebd70979a1"></a>

<details>
<summary><code>TensorCore.Regression.initial_outside_family_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Application.lean#L46)

```lean
theorem initial_outside_family_refused : boundedDotCheck [] 0x40000000 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.boundedDotCheck](../Examples/BoundedDot.md#decl-ec759e24e02a72b7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
