# TensorCore.Kernels.EFT.Scalar

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-9875615749ec7179"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.sameValue_value</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Scalar.lean#L9)

```lean
theorem Word.sameValue_value {x y : Word} (h : x.sameValue y = true) : x.value = y.value := by
  simp only [Word.sameValue, Bool.and_eq_true, beq_iff_eq, Bool.or_eq_true] at h
  obtain ⟨hm, hs⟩ := h
  rcases hs with hz | hs
  · have hy : y.magnitude = 0 := hm.symm.trans hz
    simp [Word.value, Word.coefficient, hz, hy, Rat.zero_mul]
  · simp [Word.value, Word.coefficient, hm, hs]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c)

</details>

</details>

<a id="decl-dc352e235249ad4c"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.exact32_value</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Scalar.lean#L17)

```lean
theorem Word.exact32_value {x : Word} {b : F32} (h : x.exact32 = some b) :
    TensorCore.value32 b = some x.value := by
  unfold Word.exact32 at h
  cases hb : x.round32 with
  | none => simp [hb] at h
  | some r =>
    cases hd : decode32Word r with
    | none => simp [hb, hd] at h
    | some y =>
      simp [hb, hd] at h
      obtain ⟨he, rfl⟩ := h
      rw [← decode32Word_value, hd, Option.map_some, Word.sameValue_value he]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-098284e6074ca890"></a>

<details>
<summary><code>TensorCore.EFMachine.add32_eq</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Scalar.lean#L32)

```lean
/-- The executable scalar primitive is exactly one finite-range nearest-even FP32
addition. Its wide workspace always accommodates two finite FP32 inputs. -/
theorem add32_eq (a b : F32) :
    add32 a b = (do
      let x ← TensorCore.value32 a
      let y ← TensorCore.value32 b
      TensorCore.round32 .nearestEven (x + y)) := by
  rw [← decode32Word_value, ← decode32Word_value]
  cases ha : decode32Word a with
  | none => simp [add32, ha]
  | some x =>
    cases hb : decode32Word b with
    | none => simp [add32, ha, hb]
    | some y =>
      have hx := decode32Word_magnitude ha
      have hy := decode32Word_magnitude hb
      obtain ⟨z, hz⟩ := x.add_exists y (by omega)
      simp [add32, ha, hb, hz, Word.round32_eq, Word.add_value hz]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2), [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b)

</details>

</details>

<a id="decl-210c33f6f4d2a66b"></a>

<details>
<summary><code>TensorCore.EFMachine.Components.scalar_correct</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Scalar.lean#L51)

```lean
/-- Exact-intermediate checks make scalar acceptance sound even when a sufficient
support predicate is conservative. No assumption about scalarSum accuracy is hidden. -/
theorem Components.scalar_correct {c : Components} {b : F32} (hc : c.scalar = some b) :
    TensorCore.round32 .nearestEven (c.retained.value + c.residualSum.value) = some b := by
  unfold Components.scalar at hc
  split at hc
  · contradiction
  · cases he : scalarSum c.low with
    | none => simp [he] at hc
    | some eb =>
      cases hed : decode32Word eb with
      | none => simp [he, hed] at hc
      | some e =>
        simp [he, hed] at hc
        obtain ⟨hev, hc⟩ := hc
        have hev' : e.value = c.residualSum.value := Word.sameValue_value (by simpa using hev)
        cases hd : c.prepared.output.exact32 with
        | none => simp [hd] at hc
        | some db =>
          cases ho : c.overlap.neg.exact32 with
          | none => simp [hd, ho] at hc
          | some ob =>
            cases hh : add32 db ob with
            | none => simp [hd, ho, hh] at hc
            | some hb =>
              cases hhd : decode32Word hb with
              | none => simp [hd, ho, hh, hhd] at hc
              | some h =>
                simp [hd, ho, hh, hhd] at hc
                obtain ⟨hhv, hc⟩ := hc
                have hhv' : h.value = c.retained.value := Word.sameValue_value (by simpa using hhv)
                rw [add32_eq, ← decode32Word_value, ← decode32Word_value, hhd, hed] at hc
                simpa [hhv', hev'] using hc
```

**Supporting proofs:** [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

**Definitions and types:** [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.scalarSum](Defs.md#decl-e15921640df89f0b), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94)

</details>

</details>
