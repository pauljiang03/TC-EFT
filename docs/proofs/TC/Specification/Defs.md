# TensorCore.TC.Specification.Defs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3651fca160255c9d"></a>

<details>
<summary><code>TensorCore.PaperSpec.Layout</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L27)

```lean
structure Layout where
  fraction : ℕ
  exponent : ℕ
  bias : ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.binary32](Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.layoutOf](Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64)

</details>

</details>

<a id="decl-b7a731aa48165c61"></a>

<details>
<summary><code>TensorCore.PaperSpec.Layout.width</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L33)

```lean
@[implicit_reducible] def Layout.width (f : Layout) : ℕ := 1 + f.exponent + f.fraction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.group_reversal_detected](../../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.lastBits](Schedule.md#decl-3bc0435f1504df60), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-ce9247c05694abaf"></a>

<details>
<summary><code>TensorCore.PaperSpec.binary32</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L35)

```lean
def binary32 : Layout := ⟨23, 8, 127⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-26a9e9dc96610178"></a>

<details>
<summary><code>TensorCore.PaperSpec.Parameters</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L37)

```lean
structure Parameters where
  input : Layout
  products : ℕ
  fraction : ℤ
  floor : Option ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.group_reversal_detected](../../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../../Tests/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.Controls.noFloorBits](../../Tests/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalizedBits](../../Tests/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.exponent](Defs.md#decl-509ef1a10e0bf861), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.lastBits](Schedule.md#decl-3bc0435f1504df60), [TensorCore.PaperSpec.parameters](Profiles.md#decl-ee26be9404546300), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.supported_parameters](Supported.md#decl-3ff58df4e66fac41), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-ed9c358406f498b4"></a>

<details>
<summary><code>TensorCore.PaperSpec.Input</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L44)

```lean
structure Input (p : Parameters) where
  products : List (BitVec p.input.width × BitVec p.input.width)
  c : BitVec 32
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../../Tests/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.Controls.noFloorBits](../../Tests/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalizedBits](../../Tests/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.supportedInput](Supported.md#decl-9a9de8a677d86544), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-707444d6b10bb80c"></a>

<details>
<summary><code>TensorCore.PaperSpec.Term</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L49)

```lean
structure Term where
  value : ℚ
  exponent : ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../../Tests/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.Controls.noFloorBits](../../Tests/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalized](../../Tests/Specification/NegativeControls.md#decl-c655af5e3b62b4a8), [TensorCore.PaperSpec.Controls.normalizedBits](../../Tests/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.exponent](Defs.md#decl-509ef1a10e0bf861), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.largestExponent](Defs.md#decl-d5edbc4859fa8eba), [TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e), [TensorCore.PaperSpec.product](Defs.md#decl-1201e49c68444b0b), [TensorCore.PaperSpec.product_eq](Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.termOf](Stages.md#decl-5d5575e19169b785), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-1951e6871669c329"></a>

<details>
<summary><code>TensorCore.PaperSpec.decode</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L56)

```lean
/-- IEEE fields, including the minimum-normal raw exponent of subnormal inputs.
Zero has no numerical exponent; its sentinel exponent is ignored at selection. -/
def decode (f : Layout) (word : ℕ) : Option Term :=
  let E := word / 2 ^ f.fraction % 2 ^ f.exponent
  let M := word % 2 ^ f.fraction
  if E = 2 ^ f.exponent - 1 then none
  else if E = 0 ∧ M = 0 then some ⟨0, 0⟩
  else
    let e := (if E = 0 then 1 else (E : ℤ)) - f.bias
    let m := if E = 0 then M else 2 ^ f.fraction + M
    let s : ℤ := if word / 2 ^ (f.fraction + f.exponent) = 0 then 1 else -1
    some ⟨(s : ℚ) * (m : ℚ) * (2 : ℚ) ^ (e - f.fraction), e⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-1201e49c68444b0b"></a>

<details>
<summary><code>TensorCore.PaperSpec.product</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L68)

```lean
/-- Raw exponents are added, even when the resulting significand is at least two. -/
def product (a b : Term) : Term := ⟨a.value * b.value, a.exponent + b.exponent⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.product_eq](Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831)

</details>

</details>

<a id="decl-56cdff4895ab7ed6"></a>

<details>
<summary><code>TensorCore.PaperSpec.terms</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L70)

```lean
def terms (p : Parameters) (x : Input p) : Option (List Term) := do
  let c ← decode binary32 x.c.toNat
  let ps ← x.products.mapM fun (a, b) => do
    return product (← decode p.input a.toNat) (← decode p.input b.toNat)
  return c :: ps
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.binary32](Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.product](Defs.md#decl-1201e49c68444b0b)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../../Tests/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.Controls.noFloorBits](../../Tests/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalizedBits](../../Tests/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-9285371dfe76f831"></a>

<details>
<summary><code>TensorCore.PaperSpec.joinExponent</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L76)

```lean
def joinExponent : Option ℤ → Option ℤ → Option ℤ
  | none, b => b
  | a, none => a
  | some a, some b => some (max a b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.largestExponent](Defs.md#decl-d5edbc4859fa8eba), [TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e), [TensorCore.PaperSpec.fold_max](Stages.md#decl-db683c920e12967c), [TensorCore.PaperSpec.join_assoc](Stages.md#decl-0d41e118e10ff7b0), [TensorCore.PaperSpec.join_none](Stages.md#decl-69d207c2cc7f5d46)

</details>

</details>

<a id="decl-d5edbc4859fa8eba"></a>

<details>
<summary><code>TensorCore.PaperSpec.largestExponent</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L82)

```lean
/-- A right fold of nonzero terms; exact zero never selects the alignment grid. -/
def largestExponent (ts : List Term) : Option ℤ :=
  ts.foldr (fun t rest => if t.value = 0 then rest
    else joinExponent (some t.exponent) rest) none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.joinExponent](Defs.md#decl-9285371dfe76f831)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.exponent](Defs.md#decl-509ef1a10e0bf861), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e)

</details>

</details>

<a id="decl-509ef1a10e0bf861"></a>

<details>
<summary><code>TensorCore.PaperSpec.exponent</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L86)

```lean
def exponent (p : Parameters) (ts : List Term) : Option ℤ :=
  match largestExponent ts with
  | none => none
  | some e => some (match p.floor with | none => e | some f => max e f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.largestExponent](Defs.md#decl-d5edbc4859fa8eba)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7)

</details>

</details>

<a id="decl-4528aade7540d418"></a>

<details>
<summary><code>TensorCore.PaperSpec.magnitude</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L91)

```lean
def magnitude (v : ℚ) : ℚ := if v < 0 then -v else v
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.normalized](../../Tests/Specification/NegativeControls.md#decl-c655af5e3b62b4a8), [TensorCore.PaperSpec.Controls.signed_zero_is_required](../../Tests/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.coefficient](Defs.md#decl-a8a11a789f8fa9da), [TensorCore.PaperSpec.coefficient_eq](Stages.md#decl-2eed3165d7f83748), [TensorCore.PaperSpec.magnitude_eq](Rounding.md#decl-324135f1be845e5f), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_iff](Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-a8a11a789f8fa9da"></a>

<details>
<summary><code>TensorCore.PaperSpec.coefficient</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L94)

```lean
/-- Discard magnitude bits on the common grid, then restore the sign. -/
def coefficient (v q : ℚ) : ℤ :=
  (if v < 0 then -1 else 1) * (magnitude v / q).floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.coefficient_eq](Stages.md#decl-2eed3165d7f83748)

</details>

</details>

<a id="decl-255cad7848a74b4e"></a>

<details>
<summary><code>TensorCore.PaperSpec.accumulated</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L97)

```lean
def accumulated (p : Parameters) (ts : List Term) : ℚ :=
  let q := (2 : ℚ) ^ ((exponent p ts).getD 0 - p.fraction)
  ((ts.foldr (fun t z => coefficient t.value q + z) 0 : ℤ) : ℚ) * q
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.coefficient](Defs.md#decl-a8a11a789f8fa9da), [TensorCore.PaperSpec.exponent](Defs.md#decl-509ef1a10e0bf861)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.noFloorBits](../../Tests/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalizedBits](../../Tests/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-c44e0d2d27bec6df"></a>

<details>
<summary><code>TensorCore.PaperSpec.maxFinite</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L101)

```lean
def maxFinite : ℚ := (16777215 : ℚ) * (2 : ℚ) ^ (104 : ℤ)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.maxFinite_eq](Rounding.md#decl-b5e80a12c41db688), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.rounds_iff](Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-a2fc50b4e52fc5f1"></a>

<details>
<summary><code>TensorCore.PaperSpec.Valid</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L104)

```lean
/-- Domain from the paper-side computation, without evaluating the implementation. -/
def Valid (p : Parameters) (x : Input p) : Prop :=
  x.products.length = p.products ∧
    ∃ ts, terms p x = some ts ∧ magnitude (accumulated p ts) ≤ maxFinite
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>

<a id="decl-bb0f9e183270ad3e"></a>

<details>
<summary><code>TensorCore.PaperSpec.value32</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L108)

```lean
def value32 (bits : BitVec 32) : Option ℚ := (decode binary32 bits.toNat).map Term.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.binary32](Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.signed_zero_is_required](../../Tests/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-4a8f7985f3bff078"></a>

<details>
<summary><code>TensorCore.PaperSpec.Between</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L111)

```lean
/-- A finite value lies between zero and the pre-conversion accumulated value. -/
def Between (x y : ℚ) : Prop :=
  (0 ≤ x ∧ 0 ≤ y ∧ y ≤ x) ∨ (x ≤ 0 ∧ x ≤ y ∧ y ≤ 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.signed_zero_is_required](../../Tests/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.between_eq](Rounding.md#decl-f713036600fa453d), [TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20)

</details>

</details>

<a id="decl-7387a708bd8ef682"></a>

<details>
<summary><code>TensorCore.PaperSpec.Rounds</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L116)

```lean
/-- FP32 truncation specified by ordering *all finite encoded values*, plus the
sign bit. In particular, the sign condition distinguishes the two encodings of zero. -/
def Rounds (x : ℚ) (bits : BitVec 32) : Prop :=
  (bits.toNat / 2147483648 != 0) = decide (x < 0) ∧
  ∃ d, value32 bits = some d ∧ Between x d ∧
    ∀ other y, value32 other = some y → Between x y → magnitude y ≤ magnitude d
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Between](Defs.md#decl-4a8f7985f3bff078), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.value32](Defs.md#decl-bb0f9e183270ad3e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.signed_zero_is_required](../../Tests/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d), [TensorCore.PaperSpec.round32_rounds](Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_iff](Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.PaperSpec.rounds_unique](Rounding.md#decl-ca5813743de21e20)

</details>

</details>

<a id="decl-e9f2f5d24e489427"></a>

<details>
<summary><code>TensorCore.PaperSpec.Result</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L121)

```lean
def Result (p : Parameters) (x : Input p) (bits : BitVec 32) : Prop :=
  x.products.length = p.products ∧ ∃ ts,
    terms p x = some ts ∧ magnitude (accumulated p ts) ≤ maxFinite ∧
      Rounds (accumulated p ts) bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Rounds](Defs.md#decl-7387a708bd8ef682), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.bits](Defs.md#decl-7903d07b8ab34f66), [TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.result_unique](Equivalence.md#decl-9080cf4b38ea315d)

</details>

</details>

<a id="decl-7903d07b8ab34f66"></a>

<details>
<summary><code>TensorCore.PaperSpec.bits</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Defs.lean#L128)

```lean
/-- Mathematical output selector. The refinement proves this relation has exactly
one result on Valid inputs and none otherwise; choice does not assert existence. -/
noncomputable def bits (p : Parameters) (x : Input p) : Option (BitVec 32) := by
  classical
  exact if h : ∃ b, Result p x b then some (Classical.choose h) else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Result](Defs.md#decl-e9f2f5d24e489427)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.bits_eq_of_result](Equivalence.md#decl-56c2a78914a106fb), [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.invocation_eq_paper](Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.runGroups](Schedule.md#decl-34d3305155927c9e), [TensorCore.PaperSpec.supported_eq_paper](Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.tf32Bits](Profiles.md#decl-5b4e1025b83eaf3f), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>
