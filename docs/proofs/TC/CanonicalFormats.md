# TensorCore.TC.CanonicalFormats

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ccfc8f82aa7974cb"></a>

<details>
<summary><code>TensorCore.profile_contract</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L11)

```lean
/-- Uncorrected output, error, and machine-width contract for any profile. -/
theorem profile_contract (p : Profile) (F carryBits : ℕ) (hF : p.alignFraction = F)
    (hc : p.products + 1 ≤ 2 ^ carryBits) (x : BlockInput p) (t : BlockTrace)
    (h : evalBlock x = .ok t) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.accumulator = some t.output.bits ∧
    absQ (t.block.exactDot - t.output.value) <
      ((p.products + 1 : ℕ) : ℚ) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) ∧
    t.block.machineAccumulator (F + 3 + carryBits) = t.block.accumulator := by
  have hp := evalBlock_prepared h
  have hlen := (prepare_terms_bounded hp).1
  have hshape : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  have herr := evalBlock_error_bound h
  have hw := evalBlock_machineAccumulator h F carryBits hF hc
  refine ⟨by simp [exactDot, hp], evalPrepared_output (evalBlock_evalPrepared h), ?_, ?_⟩
  · simpa [hlen, hshape] using herr
  · have he : F + 2 + carryBits + 1 = F + 3 + carryBits := by omega
    simpa [he] using hw
```

**Supporting proofs:** [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Core/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478)

</details>

</details>

<a id="decl-4621731027a9a137"></a>

<details>
<summary><code>TensorCore.bf16Fp32_contract</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L32)

```lean
theorem bf16Fp32_contract (K extra carryBits : ℕ) (floor : Option ℤ)
    (x : BlockInput (bf16Fp32Profile K extra floor)) (t : BlockTrace)
    (h : evalBlock x = .ok t) (hc : K + 1 ≤ 2 ^ carryBits) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.accumulator = some t.output.bits ∧
    absQ (t.block.exactDot - t.output.value) <
      ((K + 1 : ℕ) : ℚ) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) ∧
    t.block.machineAccumulator (26 + extra + carryBits) = t.block.accumulator := by
  have := profile_contract (bf16Fp32Profile K extra floor) (23 + extra) carryBits rfl hc x t h
  have he : 23 + extra + 3 + carryBits = 26 + extra + carryBits := by omega
  simpa [he, bf16Fp32Profile] using this
```

**Supporting proofs:** [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.bf16](../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.bf16Fp32Profile](CanonicalFormatDefs.md#decl-cca6376296353039), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7fb4e742a5f73478"></a>

<details>
<summary><code>TensorCore.tf19Fp32_contract</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L45)

```lean
theorem tf19Fp32_contract (K extra carryBits : ℕ) (floor : Option ℤ)
    (x : BlockInput (tf19Fp32Profile K extra floor)) (t : BlockTrace)
    (h : evalBlock x = .ok t) (hc : K + 1 ≤ 2 ^ carryBits) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.accumulator = some t.output.bits ∧
    absQ (t.block.exactDot - t.output.value) <
      ((K + 1 : ℕ) : ℚ) * pow2 t.block.quantumExponent +
        pow2 (outputQuantumExponent t.output.bits) ∧
    t.block.machineAccumulator (26 + extra + carryBits) = t.block.accumulator := by
  have := profile_contract (tf19Fp32Profile K extra floor) (23 + extra) carryBits rfl hc x t h
  have he : 23 + extra + 3 + carryBits = 26 + extra + carryBits := by omega
  simpa [he, tf19Fp32Profile] using this
```

**Supporting proofs:** [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.tf19](../Core/Defs.md#decl-1b853137564a343d), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-73423114ec6e4035"></a>

<details>
<summary><code>TensorCore.a100BF16_descriptor</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L59)

```lean
/-- The BF16 descriptors are the BF16 profiles embedded as invocations. -/
theorem a100BF16_descriptor : a100BF16Invocation = a100BF16F32.toInvocation 24 := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.a100BF16F32](CanonicalFormatDefs.md#decl-93f6070f8a03aaee), [TensorCore.a100BF16Invocation](Profiles.md#decl-5acb22a881be62d1)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3b357b72598d1090"></a>

<details>
<summary><code>TensorCore.hopperBF16_descriptor</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L60)

```lean
theorem hopperBF16_descriptor : hopperBF16Invocation = hopperBF16F32.toInvocation 25 := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.hopperBF16F32](CanonicalFormatDefs.md#decl-c021958593ae7dc6), [TensorCore.hopperBF16Invocation](Profiles.md#decl-a5fe9df9d0e60b34)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1dce5cfd225912ec"></a>

<details>
<summary><code>TensorCore.bf16Fp32_invocation_compatible</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L62)

```lean
theorem bf16Fp32_invocation_compatible (K extra : ℕ) (floor : Option ℤ)
    (x : BlockInput (bf16Fp32Profile K extra floor)) :
    invocationBits (x.toInvocation (23 + extra)) =
      (evalBlock x).toOption.map (fun t => t.output.bits) :=
  legacy_invocation_bits x (23 + extra) (by change bf16.WellFormed; decide) rfl
```

**Supporting proofs:** [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.bf16](../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.bf16Fp32Profile](CanonicalFormatDefs.md#decl-cca6376296353039), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a7966016f7fa63bf"></a>

<details>
<summary><code>TensorCore.tf32Register_decode</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L69)

```lean
/-- A padded TF32 register word decodes as its value word under the `tf19` profile. -/
theorem tf32Register_decode (K extra : ℕ) (floor : Option ℤ) (w : tf32Register.Word)
    (hp : tf32Padded w = true) :
    tf32Register.decode w = (tf19Fp32Profile K extra floor).decode (tf32Unpack w) := by
  have hp' : w.toNat % 2 ^ 13 = 0 := by simpa [tf32Padded] using hp
  have hlt : w.toNat < 2 ^ 32 := w.isLt
  have hq : w.toNat / 2 ^ 13 % 2 ^ 19 = w.toNat / 2 ^ 13 := Nat.mod_eq_of_lt (by omega)
  show (if (w.toNat % 2 ^ 13 != 0) = true then none
    else (classifyNat tf19 (w.toNat / 2 ^ 13)).finite) =
    (classifyNat tf19 ((BitVec.ofNat 19 (w.toNat / 2 ^ 13)).toNat)).finite
  rw [BitVec.toNat_ofNat, hq, hp']
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](../Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.classifyNat](../Core/Encoding.md#decl-52d401d7433cac5a), [TensorCore.tf19](../Core/Defs.md#decl-1b853137564a343d), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32Padded](CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32Unpack](CanonicalFormatDefs.md#decl-aefd79d8faed1af7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.tf32_mapM](CanonicalFormats.md#decl-7c0efbed6b476c43)

</details>

</details>

<a id="decl-8289f6bd2846d909"></a>

<details>
<summary><code>TensorCore.tf32Register_decode_unpadded</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L81)

```lean
theorem tf32Register_decode_unpadded (w : tf32Register.Word) (hp : tf32Padded w = false) :
    tf32Register.decode w = none := by
  have hp' : (w.toNat % 2 ^ 13 != 0) = true := by
    unfold tf32Padded at hp
    simpa using hp
  show (if (w.toNat % 2 ^ 13 != 0) = true then none
    else (classifyNat tf19 (w.toNat / 2 ^ 13)).finite) = none
  rw [if_pos hp']
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](../Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.classifyNat](../Core/Encoding.md#decl-52d401d7433cac5a), [TensorCore.tf19](../Core/Defs.md#decl-1b853137564a343d), [TensorCore.tf32Padded](CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7c0efbed6b476c43"></a>

<details>
<summary><code>TensorCore.tf32_mapM</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L90)

```lean
theorem tf32_mapM (K extra : ℕ) (floor : Option ℤ)
    (ps : List (tf32Register.Word × tf32Register.Word))
    (hp : ∀ pair ∈ ps, tf32Padded pair.1 = true ∧ tf32Padded pair.2 = true) :
    ps.mapM (fun (a, b) => do return (← tf32Register.decode a, ← tf32Register.decode b)) =
      (tf32UnpackPairs ps).mapM (fun (a, b) => do
        return (← (tf19Fp32Profile K extra floor).decode a,
          ← (tf19Fp32Profile K extra floor).decode b)) := by
  induction ps with
  | nil => rfl
  | cons pair rest ih =>
    rcases pair with ⟨a, b⟩
    obtain ⟨ha, hb⟩ := hp (a, b) (by simp)
    simp only [tf32UnpackPairs, List.map_cons, List.mapM_cons]
    rw [tf32Register_decode K extra floor a ha, tf32Register_decode K extra floor b hb]
    have ih' := ih (fun q hq => hp q (by simp [hq]))
    simp only [tf32UnpackPairs] at ih'
    rw [ih']
```

**Supporting proofs:** [TensorCore.tf32Register_decode](CanonicalFormats.md#decl-a7966016f7fa63bf)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32Padded](CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32Unpack](CanonicalFormatDefs.md#decl-aefd79d8faed1af7), [TensorCore.tf32UnpackPairs](CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-959c4b9a405d61ab"></a>

<details>
<summary><code>TensorCore.tf32InvocationBits</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L109)

```lean
/-- Descriptor evaluation of a TF32 path on explicit register words. -/
def tf32InvocationBits (K F : ℕ) (floor : Option ℤ)
    (ps : List (tf32Register.Word × tf32Register.Word)) (c : F32) : Option F32 :=
  invocationBits (p := alignedInvocation tf32Register K F floor) ⟨ps, c⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.tf32_published_rows](Regression/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](Regression/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](Regression/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-23c687067612f3ac"></a>

<details>
<summary><code>TensorCore.tf32_prepare</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L113)

```lean
theorem tf32_prepare (K F extra : ℕ) (floor : Option ℤ)
    (ps : List (tf32Register.Word × tf32Register.Word)) (c : F32)
    (hp : ∀ pair ∈ ps, tf32Padded pair.1 = true ∧ tf32Padded pair.2 = true) :
    prepareInvocation (p := alignedInvocation tf32Register K F floor) ⟨ps, c⟩ =
      (prepare (⟨tf32UnpackPairs ps, c⟩ : BlockInput (tf19Fp32Profile K extra floor))).map
        (fun b => (⟨b.products, b.c⟩ : PreparedInvocation (alignedInvocation tf32Register K F floor))) := by
  show (do
    let c ← decode32 c
    let ps ← ps.mapM fun (a, b) => do
      return (← tf32Register.decode a, ← tf32Register.decode b)
    return (⟨ps, c⟩ : PreparedInvocation (alignedInvocation tf32Register K F floor))) = _
  rw [tf32_mapM K extra floor ps hp]
  change (do
    let c ← decode32 c
    let ps ← prepareProducts (tf19Fp32Profile K extra floor) (tf32UnpackPairs ps)
    return (⟨ps, c⟩ : PreparedInvocation (alignedInvocation tf32Register K F floor))) = _
  unfold prepare
  cases decode32 c <;>
    cases prepareProducts (tf19Fp32Profile K extra floor) (tf32UnpackPairs ps) <;> rfl
```

**Supporting proofs:** [TensorCore.tf32_mapM](CanonicalFormats.md#decl-7c0efbed6b476c43)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32Padded](CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32UnpackPairs](CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-a30754227918210e"></a>

<details>
<summary><code>TensorCore.finite32_none&#x27;</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L133)

```lean
private theorem finite32_none' {bits : F32} (hd : decode32 bits = none) : finite32 bits = none := by
  unfold finite32
  split
  · rfl
  · rename_i d h
    rw [hd] at h
    contradiction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-79bbcee75553afa7"></a>

<details>
<summary><code>TensorCore.finite32_some&#x27;</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L141)

```lean
private theorem finite32_some' {bits : F32} {d : Decoded} (hd : decode32 bits = some d) :
    finite32 bits = some ⟨bits, d, hd⟩ := by
  unfold finite32
  split
  · rename_i h
    rw [hd] at h
    contradiction
  · rename_i d' h
    rw [hd] at h
    cases Option.some.inj h
    rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-fd4c999fedb8fba6"></a>

<details>
<summary><code>TensorCore.padded_prepared_bits</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L155)

```lean
/-- A padded-word descriptor and the profile of its value layout compute the same block. -/
theorem padded_prepared_bits (f : Format) (pad K F : ℕ) (floor : Option ℤ)
    (ps : List (Decoded × Decoded)) (c : Decoded) :
    (evalInvocationPrepared (p := alignedInvocation ⟨⟨f, .ieee⟩, pad⟩ K F floor)
      ⟨ps, c⟩).toOption.map (fun t => t.output.bits) =
      (evalPrepared ⟨⟨f, K, F, floor⟩, ps, c⟩).toOption.map (fun t => t.output.bits) := by
  simp only [evalInvocationPrepared, accumulateInvocation, alignedInvocation,
    PreparedInvocation.alignedBlock, runConversions]
  simp only [ConversionStage.convert, evalPrepared, ite_true]
  rw [roundBinary_fp32 .towardZero]
  cases hr : round32 .towardZero (PreparedBlock.mk ⟨f, K, F, floor⟩ ps c).accumulator with
  | none => rfl
  | some bits =>
    cases hd : decode32 bits with
    | none => simp [finite32_none' hd, finiteBinary_none hd]; rfl
    | some d => simp [finite32_some' hd, finiteBinary_some hd]; rfl
```

**Supporting proofs:** [TensorCore.finiteBinary_none](../Core/Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](../Core/Conversion.md#decl-66e4132ec74cac83), [TensorCore.roundBinary_fp32](../Core/Binary/RoundOp.md#decl-11e910ef6ebcee78), [TensorCore.finite32_none'](CanonicalFormats.md#decl-a30754227918210e), [TensorCore.finite32_some'](CanonicalFormats.md#decl-79bbcee75553afa7)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.RoundingMode.toBinary](../Core/Binary/RoundOp.md#decl-812d25a411978fe0), [TensorCore.SpecialEncoding](../Core/Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.finiteBinary](../Core/Conversion.md#decl-4947fce7ecea0c20), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-28f5d0b989fbf9a1"></a>

<details>
<summary><code>TensorCore.tf32_invocation_bits</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L172)

```lean
/-- On padded register words, a TF32 descriptor computes the `tf19` profile's block. -/
theorem tf32_invocation_bits (K extra : ℕ) (floor : Option ℤ)
    (ps : List (tf32Register.Word × tf32Register.Word)) (c : F32)
    (hp : ∀ pair ∈ ps, tf32Padded pair.1 = true ∧ tf32Padded pair.2 = true) :
    tf32InvocationBits K (23 + extra) floor ps c =
      (evalBlock (⟨tf32UnpackPairs ps, c⟩ : BlockInput (tf19Fp32Profile K extra floor))).toOption.map
        (fun t => t.output.bits) := by
  have hv : (alignedInvocation tf32Register K (23 + extra) floor).Valid := by
    refine ⟨?_, ?_, rfl, ?_, trivial⟩
    · change tf19.WellFormed; decide
    · change fp32.WellFormed; decide
    · change fp32.WellFormed; decide
  unfold tf32InvocationBits invocationBits
  rw [evalInvocation, if_neg (by intro hn; exact hn hv)]
  unfold evalBlock
  dsimp only [alignedInvocation]
  have hlen : (tf32UnpackPairs ps).length = ps.length := by simp [tf32UnpackPairs]
  have hK : (tf19Fp32Profile K extra floor).products = K := rfl
  rw [hlen, hK]
  by_cases hs : (ps.length != K) = true
  · rw [if_pos hs, if_pos hs]; rfl
  · rw [if_neg hs, if_neg hs, tf32_prepare K (23 + extra) extra floor ps c hp]
    dsimp only [prepare]
    cases decode32 c with
    | none => rfl
    | some c' =>
      cases prepareProducts (tf19Fp32Profile K extra floor) (tf32UnpackPairs ps) with
      | none => rfl
      | some ps' => exact padded_prepared_bits tf19 13 K (23 + extra) floor ps' c'
```

**Supporting proofs:** [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae), [TensorCore.tf19](../Core/Defs.md#decl-1b853137564a343d), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32InvocationBits](CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32Padded](CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32Unpack](CanonicalFormatDefs.md#decl-aefd79d8faed1af7), [TensorCore.tf32UnpackPairs](CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.tf32_row_compatible](Regression/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159)

</details>

</details>

<a id="decl-7d4def66839cf159"></a>

<details>
<summary><code>TensorCore.tf32_input_bits</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L202)

```lean
/-- The same statement for any descriptor input. -/
theorem tf32_input_bits (K extra : ℕ) (floor : Option ℤ)
    (x : InvocationInput (alignedInvocation tf32Register K (23 + extra) floor))
    (hp : ∀ pair ∈ x.products, tf32Padded pair.1 = true ∧ tf32Padded pair.2 = true) :
    invocationBits x = (evalBlock (tf32Input x extra)).toOption.map (fun t => t.output.bits) :=
  tf32_invocation_bits K extra floor x.products x.c hp
```

**Supporting proofs:** [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32Input](CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32Padded](CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f9243c07ef71dab9"></a>

<details>
<summary><code>TensorCore.a100TF32_descriptor</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L208)

```lean
theorem a100TF32_descriptor :
    a100TF32Invocation = alignedInvocation tf32Register 4 (23 + 1) (some (-132)) := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.a100TF32Invocation](Profiles.md#decl-2cd9d7c36ba4af85), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-86a6a9842f6010da"></a>

<details>
<summary><code>TensorCore.hopperTF32Wmma_descriptor</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L210)

```lean
theorem hopperTF32Wmma_descriptor :
    hopperTF32WmmaInvocation = alignedInvocation tf32Register 4 (23 + 2) (some (-133)) := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.hopperTF32WmmaInvocation](Profiles.md#decl-e17fb3f22506998e), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e22579ddcda1deb8"></a>

<details>
<summary><code>TensorCore.hopperTF32Mma_descriptor</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormats.lean#L212)

```lean
theorem hopperTF32Mma_descriptor :
    hopperTF32MmaInvocation = alignedInvocation tf32Register 8 (23 + 2) (some (-133)) := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.hopperTF32MmaInvocation](Profiles.md#decl-8f7f03eca7f57fa1), [TensorCore.tf32Register](../Core/Format.md#decl-f0af86f5dcba47c8)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
