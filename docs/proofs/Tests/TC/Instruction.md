# TensorCoreTests.TC.Instruction

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e07f855fb9f294ac"></a>

<details>
<summary><code>TensorCore.Regression.zeros</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Instruction.lean#L11)

```lean
def zeros (n : ℕ) : List (F16 × F16) := List.replicate n (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ampere_instruction_order_matters](Instruction.md#decl-da07bffcaef55092), [TensorCore.Regression.v100_instruction_single_group](Instruction.md#decl-47a66c36f1e33146)

</details>

</details>

<a id="decl-47a66c36f1e33146"></a>

<details>
<summary><code>TensorCore.Regression.v100_instruction_single_group</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Instruction.lean#L15)

```lean
/-- The published V100 rows fill k positions 0–3 of a k = 16 WMMA: the instruction path
returns the single-group output (R3 here), as `single_group_output` proves in general. -/
theorem v100_instruction_single_group :
    v100Wmma16.output 0x3f7fffff (List.replicate 4 (0x3e00, 0x3d00) ++ zeros 12) = some 0x4107ffff ∧
    outputBits r3 = .ok 0x4107ffff := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath.output](../../TC/Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.r3](Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.zeros](Instruction.md#decl-e07f855fb9f294ac), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.v100Wmma16](../../TC/Instruction.md#decl-4d5414e366b3073f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1435a1f58deeec4d"></a>

<details>
<summary><code>TensorCore.Regression.ampere_instruction_two_groups</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Instruction.lean#L20)

```lean
/-- Two Ampere groups of eight ones each: 8, then 16. -/
theorem ampere_instruction_two_groups :
    ampereWmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00)) = some 0x41800000 ∧
    ampereWmma16.groups = 2 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath.groups](../../TC/Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.output](../../TC/Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.ampereWmma16](../../TC/Instruction.md#decl-b62114cc7439c99c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9eabdf6fc3230629"></a>

<details>
<summary><code>TensorCore.Regression.hopper_instruction_one_group</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Instruction.lean#L25)

```lean
/-- One Hopper group of sixteen ones. -/
theorem hopper_instruction_one_group :
    hopperWmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00)) = some 0x41800000 ∧
    hopperWmma16.groups = 1 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath.groups](../../TC/Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.output](../../TC/Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.hopperWmma16](../../TC/Instruction.md#decl-7464b2b22b93945c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-da07bffcaef55092"></a>

<details>
<summary><code>TensorCore.Regression.ampere_instruction_order_matters</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Instruction.lean#L32)

```lean
/-- Group order inside an Ampere instruction is observable. Cancelling the accumulator `1`
in the first group keeps a later `2^-24` product; placing `2^-24` first loses it at the
group boundary, with the same exact dot product. -/
theorem ampere_instruction_order_matters :
    ampereWmma16.output 0x3f800000
      ((0xbc00, 0x3c00) :: zeros 7 ++ (0x0001, 0x3c00) :: zeros 7) = some 0x33800000 ∧
    ampereWmma16.output 0x3f800000
      ((0x0001, 0x3c00) :: zeros 7 ++ (0xbc00, 0x3c00) :: zeros 7) = some 0 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath.output](../../TC/Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.Regression.zeros](Instruction.md#decl-e07f855fb9f294ac), [TensorCore.ampereWmma16](../../TC/Instruction.md#decl-b62114cc7439c99c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3792d821cd97ac97"></a>

<details>
<summary><code>TensorCore.Regression.instruction_wrong_width</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Instruction.lean#L43)

```lean
/-- Operand counts other than `k` are rejected in either direction: fifteen pairs, seventeen
pairs, and sixteen pairs followed by an infinity are all refused, so no operand is padded or
discarded. Sixteen pairs with an infinity in the last position are refused by the last
group. Exactly sixteen finite pairs are accepted. -/
theorem instruction_wrong_width :
    v100Wmma16.output 0 (List.replicate 15 (0x3c00, 0x3c00)) = none ∧
    v100Wmma16.output 0 (List.replicate 17 (0x3c00, 0x3c00)) = none ∧
    v100Wmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00) ++ [(0x7c00, 0x3c00)]) = none ∧
    v100Wmma16.output 0 (List.replicate 15 (0x3c00, 0x3c00) ++ [(0x7c00, 0x3c00)]) = none ∧
    v100Wmma16.output 0 (List.replicate 16 (0x3c00, 0x3c00)) = some 0x41800000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Numerics/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath.output](../../TC/Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.v100Wmma16](../../TC/Instruction.md#decl-4d5414e366b3073f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
