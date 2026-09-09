# TensorCore.TC.Specification.Supported

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3c13ed61a6208d31"></a>

<details>
<summary><code>TensorCore.PaperSpec.implementationProfile</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L8)

```lean
def implementationProfile : Path → Profile
  | .v100F16 => v100F16F32
  | .ampereF16 => ampereF16F32
  | .hopperF16 => hopperF16F32
  | .ampereBF16 => a100BF16F32
  | .hopperBF16 => hopperBF16F32
  | .ampereTF32 => a100TF32F32
  | .hopperTF32Wmma => hopperTF32WmmaF32
  | .hopperTF32Mma => hopperTF32MmaF32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Path](Profiles.md#decl-4e0e2e5d21f848a7), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.a100BF16F32](../CanonicalFormatDefs.md#decl-93f6070f8a03aaee), [TensorCore.a100TF32F32](../CanonicalFormatDefs.md#decl-d2e41a9c0176d61b), [TensorCore.ampereF16F32](../CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.hopperBF16F32](../CanonicalFormatDefs.md#decl-c021958593ae7dc6), [TensorCore.hopperF16F32](../CanonicalDefs.md#decl-3d43fc64b9e4a784), [TensorCore.hopperTF32MmaF32](../CanonicalFormatDefs.md#decl-bda067835b02f97d), [TensorCore.hopperTF32WmmaF32](../CanonicalFormatDefs.md#decl-a012d676a51f02f1), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.supportedInput](Supported.md#decl-9a9de8a677d86544), [TensorCore.PaperSpec.supported_eq_paper](Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_parameters](Supported.md#decl-3ff58df4e66fac41), [TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495)

</details>

</details>

<a id="decl-9a9de8a677d86544"></a>

<details>
<summary><code>TensorCore.PaperSpec.supportedInput</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L18)

```lean
def supportedInput (path : Path) (x : BlockInput (implementationProfile path)) :
    Input (parameters path) := by
  cases path <;> exact ⟨x.products, x.c⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Path](Profiles.md#decl-4e0e2e5d21f848a7), [TensorCore.PaperSpec.implementationProfile](Supported.md#decl-3c13ed61a6208d31), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.supported_eq_paper](Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495)

</details>

</details>

<a id="decl-3ff58df4e66fac41"></a>

<details>
<summary><code>TensorCore.PaperSpec.supported_parameters</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L23)

```lean
/-- Independent parameter transcription matches each implementation descriptor. -/
theorem supported_parameters (path : Path) :
    parametersOf (implementationProfile path) = parameters path := by cases path <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Path](Profiles.md#decl-4e0e2e5d21f848a7), [TensorCore.PaperSpec.implementationProfile](Supported.md#decl-3c13ed61a6208d31), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-13a8bbc2350f91f1"></a>

<details>
<summary><code>TensorCore.PaperSpec.supported_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L27)

```lean
/-- Every supported paper path and every input, with failures observed as none. -/
theorem supported_eq_paper (path : Path) (x : BlockInput (implementationProfile path)) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      bits (parameters path) (supportedInput path x) := by
  cases path <;> exact implementation_eq_paper x
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Path](Profiles.md#decl-4e0e2e5d21f848a7), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.implementationProfile](Supported.md#decl-3c13ed61a6208d31), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.supportedInput](Supported.md#decl-9a9de8a677d86544), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5894ca01e6458495"></a>

<details>
<summary><code>TensorCore.PaperSpec.supported_valid_success</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L33)

```lean
/-- Every paper-valid input of every supported path produces the specified bits. -/
theorem supported_valid_success (path : Path) (x : BlockInput (implementationProfile path))
    (hv : Valid (parameters path) (supportedInput path x)) :
    ∃ t, evalBlock x = .ok t ∧
      bits (parameters path) (supportedInput path x) = some t.output.bits := by
  cases path <;> exact valid_success x hv
```

**Supporting proofs:** [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Path](Profiles.md#decl-4e0e2e5d21f848a7), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.implementationProfile](Supported.md#decl-3c13ed61a6208d31), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.supportedInput](Supported.md#decl-9a9de8a677d86544), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b626b90584f7679d"></a>

<details>
<summary><code>TensorCore.PaperSpec.invocation_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L40)

```lean
/-- The compatibility layer transfers the result to the public aligned invocation API. -/
theorem invocation_eq_paper {p : Profile} (x : BlockInput p) (F : ℕ)
    (hf : p.input.WellFormed) (hF : p.alignFraction = F) :
    invocationBits (x.toInvocation F) = bits (parametersOf p) (inputOf x) := by
  rw [legacy_invocation_bits x F hf hF]
  exact implementation_eq_paper x
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.legacy_invocation_bits](../Compatibility.md#decl-c491cc679cfdf68a)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockInput.toInvocation](../Compatibility.md#decl-93b10149fa8f3535), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationSpec](../Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.toInvocation](../Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.invocationBits](../Invocation.md#decl-c68ad16b896f3817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-89ffefd02d518c64"></a>

<details>
<summary><code>TensorCore.PaperSpec.tf32_eq_paper</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Supported.lean#L48)

```lean
/-- Register-level TF32 agreement on every correctly padded input. The padding
condition is on input bits; it does not assume execution success or an output. -/
theorem tf32_eq_paper (K extra : ℕ) (floor : Option ℤ)
    (ps : List (tf32Register.Word × tf32Register.Word)) (c : F32)
    (hp : ∀ pair ∈ ps, tf32Padded pair.1 = true ∧ tf32Padded pair.2 = true) :
    tf32InvocationBits K (23 + extra) floor ps c = tf32Bits K extra floor ps c := by
  have hpad : paddedTF32 ps = true := by
    apply List.all_eq_true.mpr
    intro pair hpair
    obtain ⟨ha, hb⟩ := hp pair hpair
    change (pair.1.toNat % 8192 == 0 && pair.2.toNat % 8192 == 0) = true
    change (pair.1.toNat % 8192 == 0) = true at ha
    change (pair.2.toNat % 8192 == 0) = true at hb
    rw [ha, hb]
    rfl
  rw [tf32_invocation_bits K extra floor ps c hp, implementation_eq_paper]
  simp only [tf32Bits, hpad, ↓reduceIte]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.tf32_invocation_bits](../CanonicalFormats.md#decl-28f5d0b989fbf9a1)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding.Word](../../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.paddedTF32](Profiles.md#decl-4387e4b59c282071), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.unpackTF32](Profiles.md#decl-f2208ac6c81df2ec), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.tf19Fp32Profile](../CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32InvocationBits](../CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32Padded](../CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../../Core/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32UnpackPairs](../CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
