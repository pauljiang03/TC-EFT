# TensorCore.TC.FP8Program

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-8f8d0a2bfbbd03df"></a>

<details>
<summary><code>TensorCore.prepareFP8Products</code></summary>

[Lean source](../../../TensorCore/TC/FP8Program.lean#L8)

```lean
/-- Independently decode original operands, preserving their FP8 raw scales. -/
def prepareFP8Products (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word)) :
    Option (List (Decoded × Decoded)) :=
  ps.mapM fun (a, b) => do return (← f.encoding.decode a, ← f.encoding.decode b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510)

<details>
<summary>Used by</summary>

[TensorCore.fp8Products](FP8Program.md#decl-5a8d724cdc17e186), [TensorCore.fp8Products_append](FP8.md#decl-b8243d18187847d4), [TensorCore.fp8_prepared](FP8.md#decl-00c973e643ed24e8), [TensorCore.fp8_prepared_decoding](FP8.md#decl-43f0b7c463d8816d), [TensorCore.l40sFP8_floor_inactive](FP8.md#decl-6a5e1a3ab5a4a57a), [TensorCore.prepareFP8Products_scale_lower](FP8.md#decl-ffabd823616a9c18)

</details>

</details>

<a id="decl-5a8d724cdc17e186"></a>

<details>
<summary><code>TensorCore.fp8Products</code></summary>

[Lean source](../../../TensorCore/TC/FP8Program.lean#L13)

```lean
/-- Original-input ideal; no alignment or evaluator dependency. -/
def fp8Products (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word)) : Option ℚ :=
  (prepareFP8Products f ps).map
    (fun (ds : List (Decoded × Decoded)) =>
      sumQ (ds.map fun (pair : Decoded × Decoded) => pair.1.value * pair.2.value))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.prepareFP8Products](FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.fp8Products_append](FP8.md#decl-b8243d18187847d4), [TensorCore.fp8_prepared](FP8.md#decl-00c973e643ed24e8), [TensorCore.l40sFP8Ideal](FP8Program.md#decl-2edcb7111d5346e0), [TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350)

</details>

</details>

<a id="decl-2edcb7111d5346e0"></a>

<details>
<summary><code>TensorCore.l40sFP8Ideal</code></summary>

[Lean source](../../../TensorCore/TC/FP8Program.lean#L18)

```lean
def l40sFP8Ideal (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word))
    (c : F32) : Option ℚ := do
  return (← decode32 c).value + (← fp8Products f ps)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp8Products](FP8Program.md#decl-5a8d724cdc17e186)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_normalized_precision_discrepancy](Regression/FP8.md#decl-cb21b0591273445d), [TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350)

</details>

</details>

<a id="decl-d69c3bd866542897"></a>

<details>
<summary><code>TensorCore.L40SFP8Trace</code></summary>

[Lean source](../../../TensorCore/TC/FP8Program.lean#L22)

```lean
structure L40SFP8Trace (f : FP8Format) (reading : FP8Reading) where
  first : InvocationTrace (l40sFP8Invocation f reading)
  second : InvocationTrace (l40sFP8Invocation f reading)
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_first_group_precision_absorbed](Regression/FP8.md#decl-5ab8cf23366a16c9), [TensorCore.Regression.fp8_zero_and_rejections](Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.l40sFP8Bits](FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.runL40SFP8](FP8Program.md#decl-e991942d01778b03), [TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350), [TensorCore.runL40SFP8_spec](FP8.md#decl-2554ef9de5987089)

</details>

</details>

<a id="decl-e991942d01778b03"></a>

<details>
<summary><code>TensorCore.runL40SFP8</code></summary>

[Lean source](../../../TensorCore/TC/FP8Program.lean#L29)

```lean
/-- One published 32-product row, in increasing k: two groups of 16, with the first
encoded FP32 result supplied as the second c. Wrong lengths are rejected, not padded. -/
def runL40SFP8 (f : FP8Format) (reading : FP8Reading)
    (ps : List (f.encoding.Word × f.encoding.Word)) (c : F32) :
    Except InvocationError (L40SFP8Trace f reading) :=
  if ps.length != 32 then .error .wrongProductCount
  else match evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.take 16, c⟩ with
  | .error e => .error e
  | .ok first => match evalInvocation (p := l40sFP8Invocation f reading)
      ⟨ps.drop 16, first.output.bits⟩ with
    | .error e => .error e
    | .ok second => .ok ⟨first, second⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.L40SFP8Trace](FP8Program.md#decl-d69c3bd866542897), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_first_group_precision_absorbed](Regression/FP8.md#decl-5ab8cf23366a16c9), [TensorCore.Regression.fp8_zero_and_rejections](Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.l40sFP8Bits](FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350), [TensorCore.runL40SFP8_spec](FP8.md#decl-2554ef9de5987089)

</details>

</details>

<a id="decl-43b12a8a8cae2536"></a>

<details>
<summary><code>TensorCore.l40sFP8Bits</code></summary>

[Lean source](../../../TensorCore/TC/FP8Program.lean#L40)

```lean
def l40sFP8Bits (f : FP8Format) (reading : FP8Reading)
    (ps : List (f.encoding.Word × f.encoding.Word)) (c : F32) : Option F32 :=
  (runL40SFP8 f reading ps c).toOption.map fun t => t.second.output.bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.L40SFP8Trace](FP8Program.md#decl-d69c3bd866542897), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.runL40SFP8](FP8Program.md#decl-e991942d01778b03)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_e4m3_top_exponent](Regression/FP8.md#decl-8e88f76e54239b4f), [TensorCore.Regression.fp8_normalized_precision_discrepancy](Regression/FP8.md#decl-cb21b0591273445d), [TensorCore.Regression.fp8_subnormal_preserved](Regression/FP8.md#decl-b1bb8f3ca4418b7a), [TensorCore.Regression.fp8_zero_and_rejections](Regression/FP8.md#decl-9799addbb566d2bf), [TensorCore.Regression.l40s_e4m3_group_order](Regression/FP8.md#decl-e82ac8c050018571), [TensorCore.Regression.l40s_e4m3_published_row](Regression/FP8.md#decl-5a82486ca62db36a), [TensorCore.Regression.l40s_e5m2_group_order](Regression/FP8.md#decl-321185f5fa7cfdba), [TensorCore.Regression.l40s_e5m2_published_row](Regression/FP8.md#decl-3f757599746339b2)

</details>

</details>
