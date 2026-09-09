# TensorCore.Regression.Specification.Audit

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-63abee277e3b187a"></a>

<details>
<summary><code>TensorCore.PaperSpec.Audit.specificationModules</code></summary>

[Lean source](../../../../TensorCore/Regression/Specification/Audit.lean#L15)

```lean
def specificationModules : List Name :=
  [`TensorCore.TC.Specification.Defs, `TensorCore.TC.Specification.Profiles,
    `TensorCore.TC.Specification.Schedule, `TensorCore.Gemm.Specification.Matrix, `TensorCore.Gemm.Specification.Scalar,
    `TensorCore.Gemm.Specification.NativeMatrix, `TensorCore.Gemm.Specification.NativeScaledMatrix]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Audit.check](Audit.md#decl-779a7ef3ee8b2e5d)

</details>

</details>

<a id="decl-799da0b98c389592"></a>

<details>
<summary><code>TensorCore.PaperSpec.Audit.moduleOf</code></summary>

[Lean source](../../../../TensorCore/Regression/Specification/Audit.lean#L20)

```lean
def moduleOf (env : Environment) (n : Name) : Option Name := do
  let idx ← env.getModuleIdxFor? n
  env.header.moduleNames[idx.toNat]?
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Audit.check](Audit.md#decl-779a7ef3ee8b2e5d), [TensorCore.PaperSpec.Audit.visit](Audit.md#decl-8ffbe61d2ac4bff2)

</details>

</details>

<a id="decl-fb8d3c1055087b5b"></a>

<details>
<summary><code>TensorCore.PaperSpec.Audit.standardModule</code></summary>

[Lean source](../../../../TensorCore/Regression/Specification/Audit.lean#L24)

```lean
def standardModule (name : Name) : Bool :=
  name.getRoot == `Init || name.getRoot == `Std || name.getRoot == `Lean
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Audit.check](Audit.md#decl-779a7ef3ee8b2e5d), [TensorCore.PaperSpec.Audit.visit](Audit.md#decl-8ffbe61d2ac4bff2)

</details>

</details>

<a id="decl-8ffbe61d2ac4bff2"></a>

<details>
<summary><code>TensorCore.PaperSpec.Audit.visit</code></summary>

[Lean source](../../../../TensorCore/Regression/Specification/Audit.lean#L27)

```lean
partial def visit (env : Environment) (n : Name) : StateM NameSet Unit := do
  if (← get).contains n then return
  modify (·.insert n)
  -- Standard-library arithmetic/types are the deliberately shared foundation.
  if (moduleOf env n).any standardModule then return
  match env.find? n with
  | none => pure ()
  | some info =>
    info.type.getUsedConstants.forM (visit env)
    match info with
    | .defnInfo d => d.value.getUsedConstants.forM (visit env)
    | .opaqueInfo d => d.value.getUsedConstants.forM (visit env)
    | .thmInfo d => d.value.getUsedConstants.forM (visit env)
    | _ => pure ()
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Audit.moduleOf](Audit.md#decl-799da0b98c389592), [TensorCore.PaperSpec.Audit.standardModule](Audit.md#decl-fb8d3c1055087b5b)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Audit.check](Audit.md#decl-779a7ef3ee8b2e5d)

</details>

</details>

<a id="decl-779a7ef3ee8b2e5d"></a>

<details>
<summary><code>TensorCore.PaperSpec.Audit.check</code></summary>

[Lean source](../../../../TensorCore/Regression/Specification/Audit.lean#L42)

```lean
def check (root : Name) : CommandElabM Unit := do
  let env ← getEnv
  let deps := ((visit env root).run {}).2
  let mut bad : Array Name := #[]
  for n in deps do
    if n == root then continue
    match moduleOf env n with
    | some m =>
      unless standardModule m || specificationModules.contains m do bad := bad.push n
    | none => bad := bad.push n
  unless bad.isEmpty do
    throwError "Paper specification has forbidden dependencies: {bad}"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Audit.moduleOf](Audit.md#decl-799da0b98c389592), [TensorCore.PaperSpec.Audit.specificationModules](Audit.md#decl-63abee277e3b187a), [TensorCore.PaperSpec.Audit.standardModule](Audit.md#decl-fb8d3c1055087b5b), [TensorCore.PaperSpec.Audit.visit](Audit.md#decl-8ffbe61d2ac4bff2)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
