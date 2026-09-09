# TensorCore.EFT.Machine.DecodeDefs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-9498861c9dad175b"></a>

<details>
<summary><code>TensorCore.EFMachine.InputKind</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L9)

```lean
inductive InputKind where
  | fp16 | bf16 | tf32
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.InputKind.format](DecodeDefs.md#decl-d36240df515f4d1e), [TensorCore.EFMachine.Path.kind](DecodeDefs.md#decl-7f4877f7cab1b675), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc)

</details>

</details>

<a id="decl-d36240df515f4d1e"></a>

<details>
<summary><code>TensorCore.EFMachine.InputKind.format</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L13)

```lean
def InputKind.format : InputKind → Format
  | .fp16 => TensorCore.fp16
  | .bf16 => TensorCore.bf16
  | .tf32 => TensorCore.tf19
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.InputKind](DecodeDefs.md#decl-9498861c9dad175b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5)

</details>

</details>

<a id="decl-a7fb4111affbc435"></a>

<details>
<summary><code>TensorCore.EFMachine.Factor</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L18)

```lean
structure Factor where
  negative : Bool
  magnitude : BitVec 11
  /-- Raw exponent biased by 256, with zero's conventional raw exponent 0. -/
  raw : Grid
  fraction : Grid
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Factor.decoded](Decode.md#decl-ecc0485e43e051ac), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.EFMachine.product_grid](Decode.md#decl-d5e8311dc2c362b6), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d)

</details>

</details>

<a id="decl-0667ade36b139bc7"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeFactor</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L28)

```lean
/-- Finite IEEE-style input decoding, including subnormal fractions and zero.
The input has already been checked for its encoded format width by the typed API. -/
def decodeFactor (kind : InputKind) (bits : F32) : Option Factor :=
  let f := kind.format
  let e := ((bits >>> f.fractionBits) &&& (((1 : F32) <<< f.exponentBits) - 1)).setWidth 10
  let m := (bits &&& (((1 : F32) <<< f.fractionBits) - 1)).setWidth 11
  let negative := (bits >>> (f.fractionBits + f.exponentBits)) != 0
  let bias : Grid := match kind with | .fp16 => 241 | _ => 129
  let top : Grid := match kind with | .fp16 => 31 | _ => 255
  let frac : Grid := match kind with | .bf16 => 7 | _ => 10
  if e == top then none
  else if e == 0 then
    if m == 0 then some ⟨negative, 0, 256, 0⟩
    else some ⟨negative, m, bias + 1, frac⟩
  else some ⟨negative, ((1 : BitVec 11) <<< f.fractionBits) + m, e + bias, frac⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.InputKind](DecodeDefs.md#decl-9498861c9dad175b), [TensorCore.EFMachine.InputKind.format](DecodeDefs.md#decl-d36240df515f4d1e), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4)

</details>

</details>

<a id="decl-fa1797d418dbd302"></a>

<details>
<summary><code>TensorCore.EFMachine.Term</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L42)

```lean
structure Term where
  word : Word
  /-- Raw exponent biased by 512. Do not normalize this metadata. -/
  raw : Grid
  /-- Coefficient grid, biased by 272; this may differ for equal real products. -/
  support : Grid
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Accumulator.term_grid](Decode.md#decl-95f7733aa20f6632), [TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Prepared](../Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.algorithm1](../Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](../Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](../Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.extract](../Bounded.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.EFMachine.product_grid](Decode.md#decl-d5e8311dc2c362b6), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.rawMaximum](Grid.md#decl-3faa58580e24b52d), [TensorCore.EFMachine.rawMaximum_eq](Grid.md#decl-97a05462cd1ee144), [TensorCore.EFMachine.selectedGrid](../Bounded.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0)

</details>

</details>

<a id="decl-0ddb52306171dbe9"></a>

<details>
<summary><code>TensorCore.EFMachine.product</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L52)

```lean
/-- Exact 11-by-11-bit multiplication; conversion to the common dyadic grid
uses a ten-bit shift, which includes the full BF16/TF32 exponent span. -/
def product (a b : Factor) : Term :=
  let raw := a.raw + b.raw
  let grid := raw - (a.fraction + b.fraction) - 240
  let m := (multiplySignificands a.magnitude b.magnitude).zeroExtend 576 <<< grid
  ⟨⟨a.negative != b.negative, m⟩, raw, grid⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.multiplySignificands](SplitDefs.md#decl-fa9d1dd91a2047b7)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.product_grid](Decode.md#decl-d5e8311dc2c362b6), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d)

</details>

</details>

<a id="decl-976ce481e6dcd532"></a>

<details>
<summary><code>TensorCore.EFMachine.Accumulator</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L58)

```lean
structure Accumulator where
  negative : Bool
  magnitude : BitVec 24
  raw : Grid
  fraction : Grid
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.decoded](Decode.md#decl-00c9a9a947e59df6), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Accumulator.term_grid](Decode.md#decl-95f7733aa20f6632), [TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decode32Fields_bounds](Decode.md#decl-b184c06b3493779e), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-715bf8a9ec915fb2"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Fields</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L65)

```lean
def decode32Fields (bits : F32) : Option Accumulator :=
  let e := ((bits >>> 23).setWidth 8).zeroExtend 10
  let m := (bits &&& 0x007fffff).setWidth 24
  let negative := bits.msb
  if e == 255 then none
  else if e == 0 then
    if m == 0 then some ⟨negative, 0, 256, 0⟩
    else some ⟨negative, m, 130, 23⟩
  else some ⟨negative, 8388608 + m, e + 129, 23⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decode32Fields_bounds](Decode.md#decl-b184c06b3493779e), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-33ffb7ad2d432805"></a>

<details>
<summary><code>TensorCore.EFMachine.Accumulator.term</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L75)

```lean
def Accumulator.term (a : Accumulator) : Term :=
  let grid := a.raw + 16 - a.fraction
  ⟨⟨a.negative, a.magnitude.zeroExtend 576 <<< grid⟩, a.raw + 256, grid⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_grid](Decode.md#decl-95f7733aa20f6632), [TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-d6ff3b52c79bc67f"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Term</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L80)

```lean
/-- FP32 decoding directly into the common grid, without a rational conversion. -/
def decode32Term (bits : F32) : Option Term := (decode32Fields bits).map Accumulator.term
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-811ace041b8ae4f8"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Word</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L82)

```lean
def decode32Word (bits : F32) : Option Word := (decode32Term bits).map Term.word
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](../Bounded.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean](../Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](../Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.exact32](../Bounded.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean](../Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.add32WithLean_eq](../Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-2506d95eda2deaf1"></a>

<details>
<summary><code>TensorCore.EFMachine.Path</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L84)

```lean
inductive Path where
  | v100F16 | ampereF16 | hopperF16 | ampereBF16 | hopperBF16
  | ampereTF32 | hopperTF32Wmma | hopperTF32Mma
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.alignmentBits](DecodeDefs.md#decl-409758bc0f53f8d1), [TensorCore.EFMachine.Path.floor](DecodeDefs.md#decl-cb3a933d840dd12f), [TensorCore.EFMachine.Path.kind](DecodeDefs.md#decl-7f4877f7cab1b675), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.algorithm1](../Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](../Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_correct](../Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](../Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.bitScan_total_budget](Cost.md#decl-a3a9475bba1317cd), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.operationBudget_bounds](Cost.md#decl-767173d29c375b8d), [TensorCore.EFMachine.path_count](Preparation.md#decl-5c86c03a8739e02a), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.selectedGrid](../Bounded.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769), [TensorCore.Regression.BoundedEFT.consolidation_branches](../Regression/BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.BoundedEFT.tiny_products](../Regression/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../Regression/BoundedEFT.md#decl-7b1c5dfc5773a1d1), [TensorCore.Regression.BoundedEFT.zero_and_rejections](../Regression/BoundedEFT.md#decl-7cd9ddb4bc8c279c), [TensorCore.Regression.NativeEFT.single_v100_corrected](../Regression/NativeEFT.md#decl-8bc682481480e65b)

</details>

</details>

<a id="decl-7f4877f7cab1b675"></a>

<details>
<summary><code>TensorCore.EFMachine.Path.kind</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L89)

```lean
def Path.kind : Path → InputKind
  | .v100F16 | .ampereF16 | .hopperF16 => .fp16
  | .ampereBF16 | .hopperBF16 => .bf16
  | .ampereTF32 | .hopperTF32Wmma | .hopperTF32Mma => .tf32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.InputKind](DecodeDefs.md#decl-9498861c9dad175b), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4)

</details>

</details>

<a id="decl-ccec848a9e7609d0"></a>

<details>
<summary><code>TensorCore.EFMachine.Path.profile</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L94)

```lean
def Path.profile : Path → Profile
  | .v100F16 => v100F16F32
  | .ampereF16 => ampereF16F32
  | .hopperF16 => hopperF16F32
  | .ampereBF16 => a100BF16F32
  | .hopperBF16 => hopperBF16F32
  | .ampereTF32 => a100TF32F32
  | .hopperTF32Wmma => hopperTF32WmmaF32
  | .hopperTF32Mma => hopperTF32MmaF32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.a100BF16F32](../../TC/CanonicalFormatDefs.md#decl-93f6070f8a03aaee), [TensorCore.a100TF32F32](../../TC/CanonicalFormatDefs.md#decl-d2e41a9c0176d61b), [TensorCore.ampereF16F32](../../TC/CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.hopperBF16F32](../../TC/CanonicalFormatDefs.md#decl-c021958593ae7dc6), [TensorCore.hopperF16F32](../../TC/CanonicalDefs.md#decl-3d43fc64b9e4a784), [TensorCore.hopperTF32MmaF32](../../TC/CanonicalFormatDefs.md#decl-bda067835b02f97d), [TensorCore.hopperTF32WmmaF32](../../TC/CanonicalFormatDefs.md#decl-a012d676a51f02f1), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1](../Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](../Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_correct](../Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](../Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.bitScan_total_budget](Cost.md#decl-a3a9475bba1317cd), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.operationBudget_bounds](Cost.md#decl-767173d29c375b8d), [TensorCore.EFMachine.path_count](Preparation.md#decl-5c86c03a8739e02a), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769), [TensorCore.Regression.BoundedEFT.tiny_products](../Regression/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../Regression/BoundedEFT.md#decl-7b1c5dfc5773a1d1), [TensorCore.Regression.BoundedEFT.zero_and_rejections](../Regression/BoundedEFT.md#decl-7cd9ddb4bc8c279c), [TensorCore.Regression.NativeEFT.single_v100_corrected](../Regression/NativeEFT.md#decl-8bc682481480e65b)

</details>

</details>

<a id="decl-409758bc0f53f8d1"></a>

<details>
<summary><code>TensorCore.EFMachine.Path.alignmentBits</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L104)

```lean
def Path.alignmentBits : Path → Grid
  | .v100F16 => 23
  | .ampereF16 | .ampereBF16 | .ampereTF32 => 24
  | _ => 25
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.floor](DecodeDefs.md#decl-cb3a933d840dd12f), [TensorCore.EFMachine.selectedGrid](../Bounded.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-cb3a933d840dd12f"></a>

<details>
<summary><code>TensorCore.EFMachine.Path.floor</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L109)

```lean
def Path.floor : Path → Grid
  | .v100F16 => 0
  | .ampereF16 | .ampereBF16 | .ampereTF32 => 380
  | _ => 379
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.alignmentBits](DecodeDefs.md#decl-409758bc0f53f8d1)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.selectedGrid](../Bounded.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-393a0d8562dca5f4"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeProduct</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L114)

```lean
def decodeProduct (path : Path) (pair : path.profile.Word × path.profile.Word) : Option Term := do
  let a ← decodeFactor path.kind (pair.1.zeroExtend 32)
  let b ← decodeFactor path.kind (pair.2.zeroExtend 32)
  return product a b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.kind](DecodeDefs.md#decl-7f4877f7cab1b675), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.prepare](../Bounded.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-7ed3fa6d2b144ea7"></a>

<details>
<summary><code>TensorCore.EFMachine.add32</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/DecodeDefs.lean#L120)

```lean
/-- Finite-range FP32 scalar addition using the same bounded integer converter. -/
def add32 (a b : F32) : Option F32 := do
  let x ← decode32Word a
  let y ← decode32Word b
  let s ← x.add y
  s.round32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](../Bounded.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean_eq](../Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.add32WithLean_eq](../Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.naiveSum32WithLeanFrom_eq](../Native.md#decl-0301e5d588c478f8), [TensorCore.EFMachine.scalarSum](../Bounded.md#decl-e15921640df89f0b), [TensorCore.EFMachine.scalarSumWithLean_eq](../Native.md#decl-068a2eb7a865b141)

</details>

</details>
