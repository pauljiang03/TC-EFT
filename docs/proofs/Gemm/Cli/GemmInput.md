# TensorCore.Gemm.Cli.GemmInput

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-28dd181dd1f5acb4"></a>

<details>
<summary><code>TensorCore.Cli.GemmInput.words</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmInput.lean#L11)

```lean
def words (width rows cols : ℕ) (xs : Array ℕ) :
    Except String (DenseMatrix (BitVec width) rows cols) :=
  if xs.size != rows * cols then .error "Matrix shape does not match its word count"
  else if xs.any (· ≥ 2 ^ width) then .error "Operand word exceeds its format width"
  else .ok (DenseMatrix.ofFn fun i j => BitVec.ofNat width xs[i.val * cols + j.val]!)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-dea3790eaa6416ad"></a>

<details>
<summary><code>TensorCore.Cli.GemmInput.scalar</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmInput.lean#L17)

```lean
def scalar (input : Json) (key : String) : Except String F32 := do
  let n ← input.getObjValAs? ℕ key
  if n ≥ 2 ^ 32 then .error "Scalar word exceeds FP32 width" else .ok (BitVec.ofNat 32 n)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-537adc255c27ce81"></a>

<details>
<summary><code>TensorCore.Cli.GemmInput.mode</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmInput.lean#L21)

```lean
def mode : String → Except String BinaryRoundingMode
  | "rne" => .ok .nearestEven | "rtz" => .ok .towardZero
  | "rdn" => .ok .towardNegative | "rup" => .ok .towardPositive
  | _ => .error "Expected rounding mode rne, rtz, rdn, or rup"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.Selection.candidate](GemmSelection.md#decl-0ce6164bf816c3c9), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-de05af7e33d3efef"></a>

<details>
<summary><code>TensorCore.Cli.GemmInput.format</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmInput.lean#L26)

```lean
def format : String → Except String TensorCore.Format
  | "fp16" => .ok fp16 | "fp32" => .ok fp32
  | "bf16" => .ok bf16 | "fp64" => .ok fp64
  | _ => .error "Expected format fp16, fp32, bf16, or fp64"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.sourceFormat](NativePipeline.md#decl-e6098145378277af), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-fc8688802cab1a09"></a>

<details>
<summary><code>TensorCore.Cli.GemmInput.model</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmInput.lean#L31)

```lean
def model : String → Except String WmmaGemmModel
  | "v100" => .ok .v100 | "ampere" => .ok .ampere | "hopper" => .ok .hopper
  | _ => .error "Expected model v100, ampere, or hopper"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Selection.candidate](GemmSelection.md#decl-0ce6164bf816c3c9)

</details>

</details>
