# TensorCore.Cli.IEEE

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-bed3fc591f28b9f9"></a>

<details>
<summary><code>TensorCore.Cli.IEEE.format</code></summary>

[Lean source](../../../TensorCore/Cli/IEEE.lean#L9)

```lean
def format : String → Except String BinaryFormat
  | "fp16" => .ok .binary16
  | "fp32" => .ok .binary32
  | "fp64" => .ok .binary64
  | _ => .error "Expected IEEE format fp16, fp32, or fp64"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](../IEEE/Basic.md#decl-d560501f21a28c67)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](IEEE.md#decl-33c9f4f09ea726b5)

</details>

</details>

<a id="decl-d1aa24ffb1938cd7"></a>

<details>
<summary><code>TensorCore.Cli.IEEE.mode</code></summary>

[Lean source](../../../TensorCore/Cli/IEEE.lean#L15)

```lean
def mode : String → Except String BinaryRoundingMode
  | "rne" => .ok .nearestEven
  | "rtz" => .ok .towardZero
  | "rdn" => .ok .towardNegative
  | "rup" => .ok .towardPositive
  | _ => .error "Expected rounding mode rne, rtz, rdn, or rup"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](IEEE.md#decl-33c9f4f09ea726b5)

</details>

</details>

<a id="decl-d5178f5c3b0be28a"></a>

<details>
<summary><code>TensorCore.Cli.IEEE.tininess</code></summary>

[Lean source](../../../TensorCore/Cli/IEEE.lean#L22)

```lean
def tininess : String → Except String Tininess
  | "before" => .ok .beforeRounding
  | "after" => .ok .afterRounding
  | _ => .error "Expected tininess before or after"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Tininess](../IEEE/Basic.md#decl-8c2ee485764d7350)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](IEEE.md#decl-33c9f4f09ea726b5)

</details>

</details>

<a id="decl-25ed82ecf72c63cc"></a>

<details>
<summary><code>TensorCore.Cli.IEEE.word</code></summary>

[Lean source](../../../TensorCore/Cli/IEEE.lean#L27)

```lean
def word (f : BinaryFormat) (j : Json) (key : String) : Except String (Word f) := do
  let n ← j.getObjValAs? ℕ key
  if n < 2 ^ f.layout.width then return BitVec.ofNat _ n
  else .error s!"{key}: word exceeds format width"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../IEEE/Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../IEEE/Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](../IEEE/Basic.md#decl-b814ad4fc9e848f5)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](IEEE.md#decl-33c9f4f09ea726b5)

</details>

</details>

<a id="decl-71feae66200bd421"></a>

<details>
<summary><code>TensorCore.Cli.IEEE.flagsJson</code></summary>

[Lean source](../../../TensorCore/Cli/IEEE.lean#L32)

```lean
def flagsJson (f : Flags) : Json := Json.mkObj [
  ("invalid", toJson f.invalid), ("divide_by_zero", toJson f.divideByZero),
  ("overflow", toJson f.overflow), ("underflow", toJson f.underflow), ("inexact", toJson f.inexact)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Flags](../IEEE/Basic.md#decl-7fb0da58f8de59d1)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](IEEE.md#decl-33c9f4f09ea726b5)

</details>

</details>

<a id="decl-33c9f4f09ea726b5"></a>

<details>
<summary><code>TensorCore.Cli.IEEE.evaluate</code></summary>

[Lean source](../../../TensorCore/Cli/IEEE.lean#L36)

```lean
def evaluate (j : Json) : Except String Json := do
  let operation ← j.getObjValAs? String "operation"
  let f ← j.getObjValAs? String "format" >>= format
  let rounding ← j.getObjValAs? String "mode" >>= mode
  let tinyMode ← match j.getObjVal? "tininess" with
    | .error _ => pure Tininess.afterRounding
    | .ok value => value.getStr? >>= tininess
  let cfg : Context := ⟨rounding, tinyMode⟩
  let a ← word f j "a"
  let output ← match operation with
    | "convert" => do
        let target ← j.getObjValAs? String "target" >>= format
        let r := convert f target cfg a
        pure (r.bits.toNat, r.flags)
    | "add" | "sub" | "mul" | "fma" => do
        let b ← word f j "b"
        let r : Result f ← match operation with
          | "add" => pure (addWithLean f cfg a b)
          | "sub" => pure (subWithLean f cfg a b)
          | "mul" => pure (mulWithLean f cfg a b)
          | _ => do
              let c ← word f j "c"
              pure (fma f cfg a b c)
        pure (r.bits.toNat, r.flags)
    | _ => .error "Expected operation convert, add, sub, mul, or fma"
  return Json.mkObj [("bits", toJson output.1), ("flags", flagsJson output.2)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.IEEE.flagsJson](IEEE.md#decl-71feae66200bd421), [TensorCore.Cli.IEEE.format](IEEE.md#decl-bed3fc591f28b9f9), [TensorCore.Cli.IEEE.mode](IEEE.md#decl-d1aa24ffb1938cd7), [TensorCore.Cli.IEEE.tininess](IEEE.md#decl-d5178f5c3b0be28a), [TensorCore.Cli.IEEE.word](IEEE.md#decl-25ed82ecf72c63cc), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](../IEEE/Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](../IEEE/Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](../IEEE/Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](../IEEE/Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](../IEEE/Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](../IEEE/Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.Word](../IEEE/Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](../IEEE/NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.convert](../IEEE/Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.fma](../IEEE/Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.mulWithLean](../IEEE/NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.subWithLean](../IEEE/NativeOperations.md#decl-9d4b383e5cf47f67)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
