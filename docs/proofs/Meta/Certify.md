# TensorCore.Meta.Certify

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e41d16c01b8920ab"></a>

<details>
<summary><code>TensorCore.Meta.certifyCommand</code></summary>

[Lean source](../../../TensorCore/Meta/Certify.lean#L14)

```lean
private def certifyCommand (name : TSyntax `ident) (program initial E L tolerance proof : TSyntax `term) :
    CommandElabM Unit := do
  let initial ← checkedInitial initial
  let savedEnv ← getEnv
  let before := (← get).messages.toList.length
  elabCommand (← `(set_option Elab.async false in
    theorem $name : TensorCore.Program.Accurate $program $initial $tolerance :=
      TensorCore.Program.staticCertificate_sound $program $E $L $initial $tolerance $proof))
  let fresh := (← get).messages.toList.drop before
  if fresh.any (·.severity == MessageSeverity.error) then
    setEnv savedEnv
    logErrorAt name "Not certified; no new accuracy theorem was registered. The concrete certificate checks ideal prefixes and an uncorrected error budget. Use tc_certificate to inspect inputConditionsPass and tolerancePass."
  else
    elabCommand (← `(#check $name))
    elabCommand (← `(#print axioms $name))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Meta.checkedInitial](Syntax.md#decl-e866e68eb9b7f9cc)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
