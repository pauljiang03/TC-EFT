# TensorCore.Meta.Instruction

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d70a435941c1c6ef"></a>

<details>
<summary><code>TensorCore.Meta.instructionPaths</code></summary>

[Lean source](../../../TensorCore/Meta/Instruction.lean#L13)

```lean
/-- Pinned instruction paths by short name. -/
def instructionPaths : List (String × Name) :=
  [("v100-wmma-k16", ``TensorCore.v100Wmma16),
   ("ampere-wmma-k16", ``TensorCore.ampereWmma16),
   ("hopper-wmma-k16", ``TensorCore.hopperWmma16)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
