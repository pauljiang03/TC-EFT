# TensorCore.Kernels.EFT.Defs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ae7458916e66d6a4"></a>

<details>
<summary><code>TensorCore.EFMachine.Error</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L12)

```lean
inductive Error where
  | wrongProductCount | nonfiniteInput | nonfiniteOutput | arithmeticOverflow
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.Regression.BoundedEFT.consolidation_branches](../../Tests/EFT/BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.BoundedEFT.tiny_products](../../Tests/EFT/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../../Tests/EFT/BoundedEFT.md#decl-7b1c5dfc5773a1d1), [TensorCore.Regression.BoundedEFT.zero_and_rejections](../../Tests/EFT/BoundedEFT.md#decl-7cd9ddb4bc8c279c), [TensorCore.Regression.NativeEFT.single_v100_corrected](../../Tests/EFT/NativeEFT.md#decl-8bc682481480e65b)

</details>

</details>

<a id="decl-60336b9775817f9a"></a>

<details>
<summary><code>TensorCore.EFMachine.Prepared</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L16)

```lean
structure Prepared where
  terms : List Term
  output : Word
  grid : Grid
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-026f0e297cb0d39a"></a>

<details>
<summary><code>TensorCore.EFMachine.selectedGrid</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L24)

```lean
/-- Select the common extraction grid from unnormalized raw exponents. Saturate
below the common workspace grid; qD is at least 123, so this cannot alter qE. -/
def selectedGrid (path : Path) (ts : List Term) (D : F32) : Grid :=
  let eta := ts.foldl (fun e t => if t.word.magnitude == 0 then e
    else if e ≤ t.raw then t.raw else e) path.floor
  let offset := path.alignmentBits + 240
  let qa := if eta < offset then 0 else eta - offset
  if qa ≤ outputGrid D then outputGrid D else qa
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.alignmentBits](DecodeDefs.md#decl-409758bc0f53f8d1), [TensorCore.EFMachine.Path.floor](DecodeDefs.md#decl-cb3a933d840dd12f), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.outputGrid](WordDefs.md#decl-060f999f83e9c7c6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-795b364db94203eb"></a>

<details>
<summary><code>TensorCore.EFMachine.prepare</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L31)

```lean
def prepare (path : Path) (x : BlockInput path.profile) (D : F32) : Except Error Prepared := do
  if x.products.length != path.profile.products then throw .wrongProductCount
  let some c := decode32Term x.c | throw .nonfiniteInput
  let some ps := x.products.mapM (decodeProduct path) | throw .nonfiniteInput
  let some d := decode32Word D | throw .nonfiniteOutput
  let ts := c :: ps
  return ⟨ts, d, selectedGrid path ts D⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-cbab83ff033f2778"></a>

<details>
<summary><code>TensorCore.EFMachine.Components</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L39)

```lean
structure Components where
  prepared : Prepared
  coarse : List Word
  low : List Word
  retained : Word
  overlap : Word
  residualSum : Word
  recovered : Word
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd)

</details>

</details>

<a id="decl-1edcf1bb479bb8a3"></a>

<details>
<summary><code>TensorCore.EFMachine.extract</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L51)

```lean
/-- Lines 13–17 and exact consolidation: preserve the signed identity
S = D - overlap + sum(low). Every integer addition checks its word capacity. -/
def extract (p : Prepared) : Option Components := do
  let splits := p.terms.map fun t => t.word.split p.grid
  let hi := splits.map WordSplit.coarse
  let lo := splits.map WordSplit.low
  let h ← sumWords hi
  let overlap ← p.output.sub h
  let e ← sumWords lo
  let d0 ← p.output.sub overlap
  let s ← d0.add e
  return ⟨p, hi, lo, h, overlap, e, s⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd)

</details>

</details>

<a id="decl-6e80ed513eb0dad8"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.sameValue</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L62)

```lean
def Word.sameValue (x y : Word) : Bool :=
  x.magnitude == y.magnitude && (x.magnitude == 0 || x.negative == y.negative)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179)

</details>

</details>

<a id="decl-fb01ec61248a5cab"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.exact32</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L66)

```lean
/-- A representability guard constructed solely with bounded conversion/decoding. -/
def Word.exact32 (x : Word) : Option F32 := do
  let b ← x.round32
  let y ← decode32Word b
  if x.sameValue y then some b else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.scalarSum](Defs.md#decl-e15921640df89f0b), [TensorCore.EFMachine.scalarSumWithLean](Native.md#decl-e4ccd3078c932ff1), [TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141)

</details>

</details>

<a id="decl-5320305128099272"></a>

<details>
<summary><code>TensorCore.EFMachine.magnitudeSumWords</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L71)

```lean
def magnitudeSumWords : List Magnitude → Option Magnitude
  | [] => some 0
  | x :: xs => do
    let y ← magnitudeSumWords xs
    let s := x + y
    if s < x then none else some s
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c)

</details>

</details>

<a id="decl-ea76eecb4d404d2c"></a>

<details>
<summary><code>TensorCore.EFMachine.Components.scalarGuard</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L82)

```lean
/-- Sufficient scalar support/range predicate. The grid is obtained from the
actual nonzero residuals (the paper generator's convention), not from normalized
products. Grid lower bounds, the strict 24-bit coefficient budget, representability
of the overlap/retained sum, and the final FP32 range are distinct checks. -/
def Components.scalarGuard (c : Components) : Bool :=
  let ell := c.low.foldl (fun e x =>
    if x.magnitude == 0 then e else
      let trailing := trailingZeros x.magnitude
      if e ≤ trailing then e else trailing)
      (c.prepared.grid.zeroExtend 576)
  (ell ≥ 123) && (ell ≤ 376) &&
  c.low.all (fun x => ((x.magnitude >>> ell) <<< ell) == x.magnitude) &&
  ((magnitudeSumWords (c.low.map fun x => x.magnitude >>> ell)).any (· < 16777216)) &&
  c.overlap.exact32.isSome && c.retained.exact32.isSome &&
  (c.recovered.magnitude ≤ maxMagnitude32)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.magnitudeSumWords](Defs.md#decl-5320305128099272), [TensorCore.EFMachine.maxMagnitude32](WordDefs.md#decl-e1240926dd0c8785), [TensorCore.EFMachine.trailingZeros](BitScanDefs.md#decl-f7c3937192f344ad), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b)

</details>

</details>

<a id="decl-e15921640df89f0b"></a>

<details>
<summary><code>TensorCore.EFMachine.scalarSum</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L96)

```lean
/-- Naive summation in the specified left-to-right ordering, including encoded
FP32 boundaries. A nonrepresentable component is refused before scalar execution. -/
def scalarSum (xs : List Word) : Option F32 := do
  let bs ← xs.mapM Word.exact32
  bs.foldlM add32 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141)

</details>

</details>

<a id="decl-6c67918db14780c9"></a>

<details>
<summary><code>TensorCore.EFMachine.Components.scalar</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L103)

```lean
/-- The scalar branch checks the exact intermediate values as well as the support
guard. These checks are bounded and make the branch sound independently of how
conservative the sufficient support predicate is. -/
def Components.scalar (c : Components) : Option F32 := do
  if !c.scalarGuard then none else do
    let eBits ← scalarSum c.low
    let e ← decode32Word eBits
    if !e.sameValue c.residualSum then none else do
      let dBits ← c.prepared.output.exact32
      let oBits ← c.overlap.neg.exact32
      let hBits ← add32 dBits oBits
      let h ← decode32Word hBits
      if !h.sameValue c.retained then none else add32 hBits eBits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.scalarSum](Defs.md#decl-e15921640df89f0b), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94)

</details>

</details>

<a id="decl-dbcfe8dff7f13123"></a>

<details>
<summary><code>TensorCore.EFMachine.Result</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L114)

```lean
inductive Result where
  | allZero
  | scalar (bits : F32)
  | boundedExact (bits : F32)
  | outOfRange
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Result.bits](Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.Regression.BoundedEFT.consolidation_branches](../../Tests/EFT/BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.BoundedEFT.tiny_products](../../Tests/EFT/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../../Tests/EFT/BoundedEFT.md#decl-7b1c5dfc5773a1d1), [TensorCore.Regression.BoundedEFT.zero_and_rejections](../../Tests/EFT/BoundedEFT.md#decl-7cd9ddb4bc8c279c), [TensorCore.Regression.NativeEFT.single_v100_corrected](../../Tests/EFT/NativeEFT.md#decl-8bc682481480e65b)

</details>

</details>

<a id="decl-5da5d1a0f8426a7b"></a>

<details>
<summary><code>TensorCore.EFMachine.Result.bits</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L121)

```lean
def Result.bits : Result → Option F32
  | .allZero => some 0
  | .scalar b | .boundedExact b => some b
  | .outOfRange => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.Regression.BoundedEFT.tiny_products](../../Tests/EFT/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../../Tests/EFT/BoundedEFT.md#decl-7b1c5dfc5773a1d1)

</details>

</details>

<a id="decl-67eeb0773e124575"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Defs.lean#L128)

```lean
/-- Full bounded Algorithm 1, on each of the eight supported encoded input paths.
The supplied finite D need not be a conforming model result for exact recovery. -/
def algorithm1 (path : Path) (x : BlockInput path.profile) (D : F32) : Except Error Result := do
  let p ← prepare path x D
  if p.terms.all (fun t => t.word.magnitude == 0) then return .allZero
  let some c := extract p | throw .arithmeticOverflow
  match c.scalar with
  | some b => return .scalar b
  | none =>
    match c.recovered.round32 with
    | some b => return .boundedExact b
    | none => return .outOfRange
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.Regression.BoundedEFT.consolidation_branches](../../Tests/EFT/BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.BoundedEFT.tiny_products](../../Tests/EFT/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../../Tests/EFT/BoundedEFT.md#decl-7b1c5dfc5773a1d1), [TensorCore.Regression.BoundedEFT.zero_and_rejections](../../Tests/EFT/BoundedEFT.md#decl-7cd9ddb4bc8c279c)

</details>

</details>
