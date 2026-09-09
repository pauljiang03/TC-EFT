# TensorCore.TC.Regression.StaticBudget

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-7b734d0759824c42"></a>

<details>
<summary><code>TensorCore.Regression.staticSchedule</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/StaticBudget.lean#L13)

```lean
/-- Eight V100 groups of four products `(1 − 2^-11)(1 + 2^-10)` from `c = 1`. Every raw
product has scale `0`, and the ideal partial sums stay below `2^6`. -/
def staticSchedule : List (List (F16 × F16)) :=
  List.replicate 8 (List.replicate 4 (0x3bff, 0x3c01))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.static_certificate_accepts](StaticBudget.md#decl-b37b5c200be6f62d), [TensorCore.Regression.static_certificate_applied](StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_consistent](StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.Regression.static_certificate_rejects](StaticBudget.md#decl-075a5b6492d2e25b)

</details>

</details>

<a id="decl-b37b5c200be6f62d"></a>

<details>
<summary><code>TensorCore.Regression.static_certificate_accepts</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/StaticBudget.lean#L18)

```lean
/-- The certificate passes at scale `E = 5` with `L = 3` (five terms `≤ 2^3`), and the
per-group budget is `5·2^-18 + 2^-14 = 21·2^-18`. -/
theorem static_certificate_accepts :
    staticCheck v100F16F32 5 3 0x3f800000 staticSchedule = true ∧
    staticBudget 5 23 5 3 = 21 / 262144 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Regression.staticSchedule](StaticBudget.md#decl-7b734d0759824c42), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.staticCheck](../Program/StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0a3d92d955e4909d"></a>

<details>
<summary><code>TensorCore.Regression.static_certificate_applied</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/StaticBudget.lean#L23)

```lean
/-- Acceptance and the error bound `8 · 21·2^-18` follow from the certificate alone. -/
theorem static_certificate_applied :
    ∃ f : Finite32, f.bits = 0x3f800000 ∧ ∃ ts products,
      runBlocks v100F16F32 0x3f800000 staticSchedule = .ok ts ∧
      idealContributions v100F16F32 staticSchedule = some products ∧
      absQ (f.value + products - (lastOutput f ts).value) ≤
        (staticSchedule.length : ℚ) * staticBudget (v100F16F32.products + 1)
          v100F16F32.alignFraction 5 3 :=
  staticCheck_sound v100F16F32 5 3 0x3f800000 staticSchedule (by decide +kernel)
```

**Supporting proofs:** [TensorCore.staticCheck_sound](../Program/StaticCertificate.md#decl-d9cfd7eeec01ec69)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Regression.staticSchedule](StaticBudget.md#decl-7b734d0759824c42), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](../Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.staticCheck](../Program/StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-00b62b8ddc7d4024"></a>

<details>
<summary><code>TensorCore.Regression.static_certificate_consistent</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/StaticBudget.lean#L34)

```lean
/-- The executed run agrees: the outputs, the ideal `1 + 32·2098175·2^-21`, the final error
`7·2^-18`, the trace budget `541·2^-23`, and the static bound `168·2^-18`. -/
theorem static_certificate_consistent :
    (runBlocks v100F16F32 0x3f800000 staticSchedule).map
      (fun ts => ts.map fun t => t.output.bits.toNat) =
      .ok [0x40a00ffc, 0x41100ffc, 0x415017f8, 0x41880ffa, 0x41a813f6, 0x41c817f2, 0x41e81bee,
        0x42040ff5] ∧
    idealContributions v100F16F32 staticSchedule = some (2098175 / 65536) ∧
    (runBlocks v100F16F32 0x3f800000 staticSchedule).map
      (fun ts => absQ (1 + 2098175 / 65536 - (lastOutput ⟨0x3f800000, ⟨8388608, 0, 23⟩,
        by decide⟩ ts).value)) = .ok (7 / 262144) ∧
    (runBlocks v100F16F32 0x3f800000 staticSchedule).map
      (fun ts => sumQ (ts.map BlockTrace.errorBudget)) = .ok (541 / 8388608) ∧
    (8 : ℚ) * staticBudget 5 23 5 3 = 168 / 262144 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](../Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.staticSchedule](StaticBudget.md#decl-7b734d0759824c42), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.idealContributions](../Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](../Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-075a5b6492d2e25b"></a>

<details>
<summary><code>TensorCore.Regression.static_certificate_rejects</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/StaticBudget.lean#L49)

```lean
/-- The certificate refuses a scale the partial sums exceed (`2^5 < 33`) and a group with an
infinite operand. -/
theorem static_certificate_rejects :
    staticCheck v100F16F32 4 3 0x3f800000 staticSchedule = false ∧
    staticCheck v100F16F32 5 3 0x3f800000 [[(0x7c00, 0x3c00), (0, 0), (0, 0), (0, 0)]] = false := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.staticSchedule](StaticBudget.md#decl-7b734d0759824c42), [TensorCore.staticCheck](../Program/StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
