# TensorCore.TC.Compatibility

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-93b10149fa8f3535"></a>

<details>
<summary><code>TensorCore.BlockInput.toInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L8)

```lean
def BlockInput.toInvocation {p : Profile} (x : BlockInput p) (F : ℕ) :
    InvocationInput (p.toInvocation F) := ⟨x.products, x.c⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-be944aa91243ce64"></a>

<details>
<summary><code>TensorCore.prepareInvocation_legacy</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L11)

```lean
theorem prepareInvocation_legacy {p : Profile} (x : BlockInput p) (F : ℕ) :
    prepareInvocation (x.toInvocation F) =
      (prepare x).map (fun b => (⟨b.products, b.c⟩ : PreparedInvocation (p.toInvocation F))) := by
  simp only [prepareInvocation, BlockInput.toInvocation, Profile.toInvocation,
    packedIEEE, OperandEncoding.decode, ValueFormat.classifyNat, OperandEncoding.width,
    Nat.add_zero, Nat.pow_zero, Nat.mod_one, Nat.div_one, bne_self_eq_false,
    Bool.false_eq_true, ↓reduceIte]
  change (do
    let c ← decode32 x.c
    let ps ← prepareProducts p x.products
    return (⟨ps, c⟩ : PreparedInvocation (p.toInvocation F))) = _
  unfold prepare
  cases decode32 x.c <;> cases prepareProducts p x.products <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](../Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.SpecialEncoding](../Core/Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.ValueFormat.classifyNat](../Core/Format.md#decl-dfd30a62134c847e), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.classifyNat](../Core/Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a)

</details>

</details>

<a id="decl-0abe5f1171cc70cb"></a>

<details>
<summary><code>TensorCore.finite32_none</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L25)

```lean
private theorem finite32_none {bits : F32} (hd : decode32 bits = none) : finite32 bits = none := by
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

[TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e)

</details>

</details>

<a id="decl-1818e0508a685ca4"></a>

<details>
<summary><code>TensorCore.finite32_some</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L33)

```lean
private theorem finite32_some {bits : F32} {d : Decoded} (hd : decode32 bits = some d) :
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

[TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e)

</details>

</details>

<a id="decl-50d76905479abf5e"></a>

<details>
<summary><code>TensorCore.legacy_prepared_bits</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L46)

```lean
theorem legacy_prepared_bits (p : Profile) (ps : List (Decoded × Decoded)) (c : Decoded)
    (F : ℕ) (hF : p.alignFraction = F) :
    (evalInvocationPrepared (p := p.toInvocation F) ⟨ps, c⟩).toOption.map (fun t => t.output.bits) =
      (evalPrepared ⟨p, ps, c⟩).toOption.map (fun t => t.output.bits) := by
  rcases p with ⟨f, K, af, floor⟩
  simp only at hF
  subst af
  simp only [evalInvocationPrepared, accumulateInvocation, Profile.toInvocation,
    PreparedInvocation.alignedBlock, runConversions]
  simp only [ConversionStage.convert, evalPrepared]
  simp only [packedIEEE, ite_true]
  rw [roundBinary_fp32 .towardZero]
  cases hr : round32 .towardZero (PreparedBlock.mk ⟨f, K, F, floor⟩ ps c).accumulator with
  | none => rfl
  | some bits =>
    cases hd : decode32 bits with
    | none => simp [finite32_none hd, finiteBinary_none hd]; rfl
    | some d => simp [finite32_some hd, finiteBinary_some hd]; rfl
```

**Supporting proofs:** [TensorCore.finiteBinary_none](../Core/Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](../Core/Conversion.md#decl-66e4132ec74cac83), [TensorCore.roundBinary_fp32](../Core/Binary/RoundOp.md#decl-11e910ef6ebcee78), [TensorCore.finite32_none](Compatibility.md#decl-0abe5f1171cc70cb), [TensorCore.finite32_some](Compatibility.md#decl-1818e0508a685ca4)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.RoundingMode.toBinary](../Core/Binary/RoundOp.md#decl-812d25a411978fe0), [TensorCore.SpecialEncoding](../Core/Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.finiteBinary](../Core/Conversion.md#decl-4947fce7ecea0c20), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.packedIEEE](../Core/Format.md#decl-1c87313094e2d4c0), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a)

</details>

</details>

<a id="decl-c491cc679cfdf68a"></a>

<details>
<summary><code>TensorCore.legacy_invocation_bits</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L66)

```lean
theorem legacy_invocation_bits {p : Profile} (x : BlockInput p) (F : ℕ)
    (hinput : p.input.WellFormed) (hF : p.alignFraction = F) :
    invocationBits (x.toInvocation F) = (evalBlock x).toOption.map (fun t => t.output.bits) := by
  have hv : (p.toInvocation F).Valid := by
    refine ⟨hinput, ?_, rfl, ?_, trivial⟩ <;> change fp32.WellFormed <;> decide
  unfold invocationBits
  rw [evalInvocation, if_neg (by intro hn; exact hn hv)]
  simp only [BlockInput.toInvocation, Profile.toInvocation]
  unfold evalBlock
  by_cases hs : x.products.length != p.products
  · simp [hs]; rfl
  · simp only [hs]
    have hp := prepareInvocation_legacy x F
    dsimp only [BlockInput.toInvocation, Profile.toInvocation] at hp
    rw [hp]
    unfold prepare
    cases hc : decode32 x.c with
    | none => rfl
    | some c =>
      cases hp : prepareProducts p x.products with
      | none => rfl
      | some ps => exact legacy_prepared_bits p ps c F hF
```

**Supporting proofs:** [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.packedIEEE](../Core/Format.md#decl-1c87313094e2d4c0), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-eb86b04e40aea23d"></a>

<details>
<summary><code>TensorCore.v100_invocation_bits</code></summary>

[Lean source](../../../TensorCore/TC/Compatibility.lean#L89)

```lean
theorem v100_invocation_bits (x : BlockInput v100F16F32) :
    invocationBits (x.toInvocation 23) = (evalV100 x).toOption.map (fun t => t.output.bits) :=
  legacy_invocation_bits x 23 (by decide) rfl
```

**Supporting proofs:** [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.evalV100](Block.md#decl-9844fa72eb15e59b), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.v100F16F32](Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
