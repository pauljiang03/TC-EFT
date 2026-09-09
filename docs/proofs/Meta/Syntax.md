# TensorCore.Meta.Syntax

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-1eef3089dec302ad"></a>

<details>
<summary><code>TensorCore.Meta.sourceTerm</code></summary>

[Lean source](../../../TensorCore/Meta/Syntax.lean#L18)

```lean
private def sourceTerm (stx : Syntax) (label : TSyntax `str) : TermElabM (TSyntax `term) := do
  let pos := (← getFileMap).toPosition (stx.getPos?.getD 0)
  let file := (← readThe Core.Context).fileName
  `(TensorCore.SourceSite.mk $(quote file) $(quote pos.line) $(quote (pos.column + 1)) $label)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Meta.expandStmts](Syntax.md#decl-49cb101cfdd9a391)

</details>

</details>

<a id="decl-49cb101cfdd9a391"></a>

<details>
<summary><code>TensorCore.Meta.expandStmts</code></summary>

[Lean source](../../../TensorCore/Meta/Syntax.lean#L23)

```lean
private partial def expandStmts (stmts : Array (TSyntax `tcStmt)) : TermElabM (TSyntax `term) := do
  let mut body ← `(TensorCore.Program.skip)
  for stmt in stmts.reverse do
    let head ← match stmt with
      | `(tcStmt| block $label:str [$pairs:tcPair,*];) => do
        let site ← sourceTerm stmt label
        let ps ← pairs.getElems.mapM fun pair => do
          match pair with
          | `(tcPair| ($a:num, $b:num)) => `(($a, $b))
          | _ => throwErrorAt pair "Expected a pair of encoded operand literals"
        `(TensorCore.Program.block ⟨$site,
          TensorCore.BlockOperands.ofNats [$ps,*] (by decide +kernel) (by decide +kernel)⟩)
      | `(tcStmt| call $label:str $operands:term;) => do
        let site ← sourceTerm stmt label
        `(TensorCore.Program.block ⟨$site, $operands⟩)
      | `(tcStmt| repeat ($n:term) { $inner:tcStmt* }) => do
        let child ← expandStmts inner
        `(TensorCore.Program.repeat $n $child)
      | _ => throwErrorAt stmt "Unsupported tensor-core program operation"
    body ← `(TensorCore.Program.seq $head $body)
  return body
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Meta.sourceTerm](Syntax.md#decl-1eef3089dec302ad)

<details>
<summary>Used by</summary>

[TensorCore.Meta.elabProgram](Syntax.md#decl-bed497dc00ab9608)

</details>

</details>

<a id="decl-bed497dc00ab9608"></a>

<details>
<summary><code>TensorCore.Meta.elabProgram</code></summary>

[Lean source](../../../TensorCore/Meta/Syntax.lean#L45)

```lean
@[term_elab tcProgram] def elabProgram : TermElab := fun stx expectedType? => do
  match stx with
  | `(tc%{ $stmts:tcStmt* }) =>
    let expanded ← expandStmts stmts
    withMacroExpansion (← getRef) expanded <| elabTerm expanded expectedType?
  | _ => throwUnsupportedSyntax
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Meta.expandStmts](Syntax.md#decl-49cb101cfdd9a391)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e866e68eb9b7f9cc"></a>

<details>
<summary><code>TensorCore.Meta.checkedInitial</code></summary>

[Lean source](../../../TensorCore/Meta/Syntax.lean#L56)

```lean
partial def checkedInitial (initial : TSyntax `term) : CommandElabM (TSyntax `term) := do
  match initial with
  | `(($inner:term)) => checkedInitial inner
  | `($n:num) => `(TensorCore.checkedF32 $n (by decide +kernel))
  | _ => return initial
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Meta.certifyCommand](Certify.md#decl-e41d16c01b8920ab)

</details>

</details>

<a id="decl-19f7ff54eb681f61"></a>

<details>
<summary><code>TensorCore.Meta.verifyCommand</code></summary>

[Lean source](../../../TensorCore/Meta/Syntax.lean#L62)

```lean
private def verifyCommand (name : TSyntax `ident) (program initial proof : TSyntax `term) :
    CommandElabM Unit := do
  let savedEnv ← getEnv
  let before := (← get).messages.toList.length
  elabCommand (← `(set_option Elab.async false in
    theorem $name : TensorCore.Program.Correct $program $initial :=
      TensorCore.Program.vc_sound $program $initial $proof))
  let fresh := (← get).messages.toList.drop before
  if fresh.any (·.severity == MessageSeverity.error) then
    setEnv savedEnv
    logErrorAt name "Verification incomplete; no new verification theorem was registered. Use tc_inspect for numerical diagnostics, or supply a proof of Program.VC with 'using'."
  else
    elabCommand (← `(#check $name))
    elabCommand (← `(#print axioms $name))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
