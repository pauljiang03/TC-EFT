# TensorCore.TC.Specification.Profiles

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4e0e2e5d21f848a7"></a>

<details>
<summary><code>TensorCore.PaperSpec.Path</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Profiles.lean#L10)

```lean
inductive Path where
  | v100F16
  | ampereF16
  | hopperF16
  | ampereBF16
  | hopperBF16
  | ampereTF32
  | hopperTF32Wmma
  | hopperTF32Mma
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.implementationProfile](Supported.md#decl-3c13ed61a6208d31), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.supportedInput](Supported.md#decl-9a9de8a677d86544), [TensorCore.PaperSpec.supported_eq_paper](Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_parameters](Supported.md#decl-3ff58df4e66fac41), [TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495)

</details>

</details>

<a id="decl-ee26be9404546300"></a>

<details>
<summary><code>TensorCore.PaperSpec.parameters</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Profiles.lean#L21)

```lean
def parameters : Path → Parameters
  | .v100F16 => ⟨⟨10, 5, 15⟩, 4, 23, none⟩
  | .ampereF16 => ⟨⟨10, 5, 15⟩, 8, 24, some (-132)⟩
  | .hopperF16 => ⟨⟨10, 5, 15⟩, 16, 25, some (-133)⟩
  | .ampereBF16 => ⟨⟨7, 8, 127⟩, 8, 24, some (-132)⟩
  | .hopperBF16 => ⟨⟨7, 8, 127⟩, 16, 25, some (-133)⟩
  | .ampereTF32 => ⟨⟨10, 8, 127⟩, 4, 24, some (-132)⟩
  | .hopperTF32Wmma => ⟨⟨10, 8, 127⟩, 4, 25, some (-133)⟩
  | .hopperTF32Mma => ⟨⟨10, 8, 127⟩, 8, 25, some (-133)⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Path](Profiles.md#decl-4e0e2e5d21f848a7)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.supportedInput](Supported.md#decl-9a9de8a677d86544), [TensorCore.PaperSpec.supported_eq_paper](Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_parameters](Supported.md#decl-3ff58df4e66fac41), [TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495)

</details>

</details>

<a id="decl-4387e4b59c282071"></a>

<details>
<summary><code>TensorCore.PaperSpec.paddedTF32</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Profiles.lean#L32)

```lean
/-- TF32 register words have thirteen low padding bits, all zero. -/
def paddedTF32 (ps : List (BitVec 32 × BitVec 32)) : Bool :=
  ps.all fun (a, b) => a.toNat % 8192 == 0 && b.toNat % 8192 == 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.unpackTF32](Profiles.md#decl-f2208ac6c81df2ec)

</details>

</details>

<a id="decl-f2208ac6c81df2ec"></a>

<details>
<summary><code>TensorCore.PaperSpec.unpackTF32</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Profiles.lean#L35)

```lean
def unpackTF32 (ps : List (BitVec 32 × BitVec 32)) : List (BitVec 19 × BitVec 19) :=
  ps.map fun (a, b) => (BitVec.ofNat 19 (a.toNat / 8192), BitVec.ofNat 19 (b.toNat / 8192))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.paddedTF32](Profiles.md#decl-4387e4b59c282071)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64)

</details>

</details>

<a id="decl-5b4e1025b83eaf3f"></a>

<details>
<summary><code>TensorCore.PaperSpec.tf32Bits</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Profiles.lean#L38)

```lean
noncomputable def tf32Bits (K extra : ℕ) (floor : Option ℤ)
    (ps : List (BitVec 32 × BitVec 32)) (c : BitVec 32) : Option (BitVec 32) :=
  if paddedTF32 ps then
    bits ⟨⟨10, 8, 127⟩, K, 23 + extra, floor⟩ ⟨unpackTF32 ps, c⟩
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.paddedTF32](Profiles.md#decl-4387e4b59c282071), [TensorCore.PaperSpec.unpackTF32](Profiles.md#decl-f2208ac6c81df2ec)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64)

</details>

</details>
