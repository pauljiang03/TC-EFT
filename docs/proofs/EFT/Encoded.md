# TensorCore.EFT.Encoded

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-aaaf1649ccd95844"></a>

<details>
<summary><code>TensorCore.prepareEncodedEFT</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L11)

```lean
/-- Lines 3–6: decode operands and supplied D, preserving raw-product metadata. -/
def prepareEncodedEFT {p : Profile} (x : BlockInput p) (D : F32) : Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => match finite32 D with
      | none => .error .nonfiniteOutput
      | some d => .ok ⟨b, d⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](Encoded.md#decl-81edff15e18bd6d1), [TensorCore.prepareEncodedEFT_of_evalBlock](Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](Encoded.md#decl-a3cbd61f8702b171)

</details>

</details>

<a id="decl-43c5cf7090b5e17e"></a>

<details>
<summary><code>TensorCore.EncodedEFTResult</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L20)

```lean
/-- The paper's zero shortcut is distinct from the two consolidation branches. -/
inductive EncodedEFTResult where
  | allZero
  | consolidated (result : Algorithm1Result)
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23)

<details>
<summary>Used by</summary>

[TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.Regression.encoded_eft_all_zero](../Tests/EFT/EncodedEFT.md#decl-84a376d9133b92c7), [TensorCore.Regression.encoded_eft_branches](../Tests/EFT/EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.encoded_eft_cancellation](../Tests/EFT/EncodedEFT.md#decl-277a69997e7c7a84), [TensorCore.Regression.encoded_eft_nonzero_c](../Tests/EFT/EncodedEFT.md#decl-3c8a2a316485713c), [TensorCore.Regression.encoded_eft_rejections](../Tests/EFT/EncodedEFT.md#decl-95e3c5cfb683c2bf), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](Encoded.md#decl-81edff15e18bd6d1), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb)

</details>

</details>

<a id="decl-6b8e900329461f5a"></a>

<details>
<summary><code>TensorCore.EncodedEFTResult.bits</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L25)

```lean
def EncodedEFTResult.bits : EncodedEFTResult → Option F32
  | .allZero => some 0
  | .consolidated r => r.bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.encoded_eft_all_zero](../Tests/EFT/EncodedEFT.md#decl-84a376d9133b92c7), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb)

</details>

</details>

<a id="decl-12dcaf3961e33ea9"></a>

<details>
<summary><code>TensorCore.PreparedBlock.allZeroTerms</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L29)

```lean
def PreparedBlock.allZeroTerms (b : PreparedBlock) : Bool :=
  b.terms.all fun t => t.significand == 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4)

<details>
<summary>Used by</summary>

[TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](Encoded.md#decl-81edff15e18bd6d1), [TensorCore.allZeroTerms_exactDot](Encoded.md#decl-44b53cd75ce37005)

</details>

</details>

<a id="decl-8017eca136315bcf"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L35)

```lean
/-- Algorithm 1: check the finite encoded interface, return +0 for all-zero terms,
otherwise reconstruct the grids and overlap components and execute the two-branch reference.
The range failure is retained as `.consolidated .outOfRange`. -/
def algorithm1Encoded {p : Profile} (x : BlockInput p) (D : F32) :
    Except ModelError EncodedEFTResult :=
  match prepareEncodedEFT x D with
  | .error e => .error e
  | .ok t => .ok (if t.block.allZeroTerms then .allZero else .consolidated t.algorithm1)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.allZeroTerms](Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

<details>
<summary>Used by</summary>

[TensorCore.Regression.encoded_eft_all_zero](../Tests/EFT/EncodedEFT.md#decl-84a376d9133b92c7), [TensorCore.Regression.encoded_eft_branches](../Tests/EFT/EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.encoded_eft_cancellation](../Tests/EFT/EncodedEFT.md#decl-277a69997e7c7a84), [TensorCore.Regression.encoded_eft_nonzero_c](../Tests/EFT/EncodedEFT.md#decl-3c8a2a316485713c), [TensorCore.Regression.encoded_eft_rejections](../Tests/EFT/EncodedEFT.md#decl-95e3c5cfb683c2bf), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](Encoded.md#decl-81edff15e18bd6d1), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb)

</details>

</details>

<a id="decl-926dcc55d35ecae9"></a>

<details>
<summary><code>TensorCore.prepareEncodedEFT_spec</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L41)

```lean
theorem prepareEncodedEFT_spec {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) :
    x.products.length = p.products ∧ prepare x = some t.block ∧ finite32 D = some t.output := by
  unfold prepareEncodedEFT at h
  split at h
  · contradiction
  · rename_i hs
    cases hp : prepare x with
    | none => simp [hp] at h
    | some b =>
      cases hd : finite32 D with
      | none => simp [hp, hd] at h
      | some d =>
        simp only [hp, hd, Except.ok.injEq] at h
        subst t
        exact ⟨by simpa using hs, rfl, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.prepareEncodedEFT_success_iff](Encoded.md#decl-a3cbd61f8702b171)

</details>

</details>

<a id="decl-a3cbd61f8702b171"></a>

<details>
<summary><code>TensorCore.prepareEncodedEFT_success_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L58)

```lean
theorem prepareEncodedEFT_success_iff (p : Profile) (x : BlockInput p) (D : F32) :
    (∃ t, prepareEncodedEFT x D = .ok t) ↔
      x.products.length = p.products ∧ (∃ b, prepare x = some b) ∧ (∃ d, finite32 D = some d) := by
  constructor
  · rintro ⟨t, ht⟩
    obtain ⟨hs, hp, hd⟩ := prepareEncodedEFT_spec ht
    exact ⟨hs, ⟨t.block, hp⟩, ⟨t.output, hd⟩⟩
  · rintro ⟨hs, ⟨b, hp⟩, ⟨d, hd⟩⟩
    exact ⟨⟨b, d⟩, by simp [prepareEncodedEFT, hs, hp, hd]⟩
```

**Supporting proofs:** [TensorCore.prepareEncodedEFT_spec](Encoded.md#decl-926dcc55d35ecae9)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-44b53cd75ce37005"></a>

<details>
<summary><code>TensorCore.allZeroTerms_exactDot</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L68)

```lean
theorem allZeroTerms_exactDot {b : PreparedBlock} (h : b.allZeroTerms = true) : b.exactDot = 0 := by
  rw [← terms_value]
  have hz : ∀ t ∈ b.terms, t.value = 0 := by
    intro t ht
    have hs := (List.all_eq_true.mp h) t ht
    have hs' : t.significand = 0 := by simpa using hs
    simp [RawProduct.value, hs']
  generalize b.terms = ts at *
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    simp only [List.map_cons, sumQ, hz t (by simp), Rat.zero_add]
    exact ih (by intro u hu; exact hz u (by simp [hu]))
```

**Supporting proofs:** [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90)

**Definitions and types:** [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.allZeroTerms](Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9)

</details>

</details>

<a id="decl-ff78455708a6f933"></a>

<details>
<summary><code>TensorCore.algorithm1_bits_eq_round</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L83)

```lean
/-- Bit equality for the trace algorithm, including rejection outside the finite ideal range. -/
theorem algorithm1_bits_eq_round (t : BlockTrace) :
    t.algorithm1.bits = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.algorithm1
  cases hs : t.scalarCorrected with
  | some b =>
    have hp : t.scalarPredicate = true := (tceft_isSome_iff t).mp (by
      change t.scalarCorrected.isSome = true
      rw [hs]; rfl)
    exact (hs.symm.trans (scalarCorrected_eq t hp))
  | none =>
    rw [exactConsolidation_eq_corrected, corrected_eq_round_exactDot]
    cases round32 .nearestEven t.block.exactDot <;> rfl
```

**Supporting proofs:** [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b), [TensorCore.tceft_isSome_iff](Extraction.md#decl-bf4ac7118d2101bc)

**Definitions and types:** [TensorCore.Algorithm1Result](Algorithm1.md#decl-f55fbf06a011ce23), [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.tceft](Extraction.md#decl-7b07b124468a5e26), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9)

</details>

</details>

<a id="decl-7c68f1eaf0403ab9"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded_agrees</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L97)

```lean
/-- The all-zero shortcut agrees in bits with Algorithm 1 on the reconstructed trace. -/
theorem algorithm1Encoded_agrees {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) :
    (algorithm1Encoded x D).map EncodedEFTResult.bits = .ok t.algorithm1.bits := by
  simp only [algorithm1Encoded, h, Except.map]
  split
  · rename_i hz
    rw [algorithm1_bits_eq_round, allZeroTerms_exactDot hz]
    rw [show round32 .nearestEven 0 = some 0 by decide +kernel]
    rfl
  · rfl
```

**Supporting proofs:** [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.allZeroTerms_exactDot](Encoded.md#decl-44b53cd75ce37005)

**Definitions and types:** [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.allZeroTerms](Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1Encoded_bits_isSome_iff](Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb)

</details>

</details>

<a id="decl-81edff15e18bd6d1"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded_nonzero</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L109)

```lean
/-- Nonzero inputs preserve the trace algorithm's branch as well as its bits. -/
theorem algorithm1Encoded_nonzero {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) (hz : t.block.allZeroTerms = false) :
    algorithm1Encoded x D = .ok (.consolidated t.algorithm1) := by
  simp [algorithm1Encoded, h, hz]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.allZeroTerms](Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-29b7b451e1ee0a65"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded_allZero</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L114)

```lean
theorem algorithm1Encoded_allZero {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) (hz : t.block.allZeroTerms = true) :
    algorithm1Encoded x D = .ok .allZero := by simp [algorithm1Encoded, h, hz]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.allZeroTerms](Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1519bb799ab513bc"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L119)

```lean
/-- Returned bits round the independent decoded original-input ideal, for any finite D. -/
theorem algorithm1Encoded_correct {p : Profile} {x : BlockInput p} {D b : F32}
    {r : EncodedEFTResult} (h : algorithm1Encoded x D = .ok r) (hb : r.bits = some b) :
    ∃ z, exactDot x = some z ∧ NearestEven32 z b := by
  cases ht : prepareEncodedEFT x D with
  | error e => simp [algorithm1Encoded, ht] at h
  | ok t =>
    have he := algorithm1Encoded_agrees ht
    rw [h] at he
    simp only [Except.map, Except.ok.injEq] at he
    have ha : t.algorithm1.bits = some b := he.symm.trans hb
    exact ⟨t.block.exactDot, by simp [exactDot, (prepareEncodedEFT_spec ht).2.1],
      algorithm1_correct t b ha⟩
```

**Supporting proofs:** [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.prepareEncodedEFT_spec](Encoded.md#decl-926dcc55d35ecae9)

**Definitions and types:** [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.allZeroTerms](Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c1f2e040881102c8"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded_bits_isSome_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L133)

```lean
/-- After finite input decoding, an encoding exists exactly when the independent ideal fits. -/
theorem algorithm1Encoded_bits_isSome_iff {p : Profile} {x : BlockInput p} {D : F32}
    {t : BlockTrace} (h : prepareEncodedEFT x D = .ok t) :
    (algorithm1Encoded x D).map (fun r => r.bits.isSome) = .ok true ↔
      ∃ z, exactDot x = some z ∧ absQ z ≤ maxFinite32 := by
  have he := algorithm1Encoded_agrees h
  have hm : (algorithm1Encoded x D).map (fun r => r.bits.isSome) = .ok t.algorithm1.bits.isSome := by
    cases hr : algorithm1Encoded x D with
    | error e => simp [hr, Except.map] at he
    | ok r =>
      simp only [hr, Except.map, Except.ok.injEq] at he
      simp only [Except.map, he]
  rw [hm]
  simpa [exactDot, (prepareEncodedEFT_spec h).2.1] using algorithm1_bits_isSome_iff t
```

**Supporting proofs:** [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.prepareEncodedEFT_spec](Encoded.md#decl-926dcc55d35ecae9)

**Definitions and types:** [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-fc4f7a305fbbcda5"></a>

<details>
<summary><code>TensorCore.prepareEncodedEFT_of_evalBlock</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L148)

```lean
/-- A model evaluation supplies exactly the same decoded trace at this public interface. -/
theorem prepareEncodedEFT_of_evalBlock {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : prepareEncodedEFT x t.output.bits = .ok t := by
  have hs : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  have hd : finite32 t.output.bits = some t.output := by
    unfold finite32
    split
    · rename_i hd
      rw [t.output.valid] at hd
      contradiction
    · rename_i d hd
      rw [t.output.valid] at hd
      cases Option.some.inj hd
      rfl
  simp only [prepareEncodedEFT, hs, bne_self_eq_false, Bool.false_eq_true, ↓reduceIte,
    evalBlock_prepared h, hd]
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](../TC/StageResiduals.md#decl-7b1107ad8e7189d9)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](Encoded.md#decl-aaaf1649ccd95844)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.algorithm1Encoded_of_evalBlock](Encoded.md#decl-a76734b92f5db6bb)

</details>

</details>

<a id="decl-a76734b92f5db6bb"></a>

<details>
<summary><code>TensorCore.algorithm1Encoded_of_evalBlock</code></summary>

[Lean source](../../../TensorCore/EFT/Encoded.lean#L166)

```lean
theorem algorithm1Encoded_of_evalBlock {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    (algorithm1Encoded x t.output.bits).map EncodedEFTResult.bits = .ok t.algorithm1.bits :=
  algorithm1Encoded_agrees (prepareEncodedEFT_of_evalBlock h)
```

**Supporting proofs:** [TensorCore.algorithm1Encoded_agrees](Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.prepareEncodedEFT_of_evalBlock](Encoded.md#decl-fc4f7a305fbbcda5)

**Definitions and types:** [TensorCore.Algorithm1Result.bits](Algorithm1.md#decl-813f0f3b4334e3b7), [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.EncodedEFTResult](Encoded.md#decl-43c5cf7090b5e17e), [TensorCore.EncodedEFTResult.bits](Encoded.md#decl-6b8e900329461f5a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.algorithm1Encoded](Encoded.md#decl-8017eca136315bcf), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
