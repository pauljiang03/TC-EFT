# TensorCore.Kernels.EFT.Correctness

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-437297c158395ecd"></a>

<details>
<summary><code>TensorCore.EFMachine.prepare_exists</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Correctness.lean#L10)

```lean
/-- A shape-correct block with finite inputs and finite supplied D always prepares. -/
theorem prepare_exists {path : Path} {x : BlockInput path.profile} {D : F32} {s d : ℚ}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    ∃ p, prepare path x D = .ok p := by
  cases hc : decode32Term x.c with
  | none =>
    have hz : TensorCore.value32 x.c = none := by rw [← decode32Word_value]; simp [decode32Word, hc]
    cases hd : decode32 x.c with
    | none => simp [TensorCore.exactDot, TensorCore.prepare, hd] at hx
    | some a => simp [TensorCore.value32, hd] at hz
  | some c =>
    cases hps : x.products.mapM (decodeProduct path) with
    | none =>
      have hp := decodeProducts_values path x.products
      rw [hps] at hp
      cases hr : TensorCore.prepareProducts path.profile x.products with
      | none => simp [TensorCore.exactDot, TensorCore.prepare, hr] at hx
      | some ps => simp [hr] at hp
    | some ps =>
      cases hd : decode32Word D with
      | none => rw [← decode32Word_value, hd] at hD; contradiction
      | some d =>
        unfold prepare
        simp only [hlen, bne_self_eq_false, Bool.false_eq_true, ↓reduceIte, hc, hps, hd]
        exact ⟨_, rfl⟩
```

**Supporting proofs:** [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.prepare](../../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](../../TC/Block.md#decl-90abac48864edcd2), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4)

</details>

</details>

<a id="decl-7f72f2542f0b2f93"></a>

<details>
<summary><code>TensorCore.EFMachine.Prepared.ideal_allZero</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Correctness.lean#L36)

```lean
theorem Prepared.ideal_allZero {p : Prepared}
    (h : p.terms.all (fun t => t.word.magnitude == 0) = true) : p.ideal = 0 := by
  have ht : ∀ t ∈ p.terms, t.word.value = 0 := by
    intro t ht
    have hz := List.all_eq_true.mp h t ht
    simp only [beq_iff_eq] at hz
    simp [Word.value, Word.coefficient, hz, Rat.zero_mul]
  unfold Prepared.ideal
  suffices ∀ ts : List Term, (∀ t ∈ ts, t.word.value = 0) →
      sumQ (ts.map fun t => t.word.value) = 0 from this _ ht
  intro ts ht
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    have hv := ht t (by simp)
    have hs := ih (by intro u hu; exact ht u (by simp [hu]))
    simp [sumQ, hv, hs, Rat.zero_add]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94)

</details>

</details>

<a id="decl-be5fb7d967856d94"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_prepared</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Correctness.lean#L56)

```lean
/-- Full bounded execution terminates without workspace overflow. Both branches
return the directly rounded original-input ideal; range rejection is preserved. -/
theorem algorithm1_prepared {path : Path} {x : BlockInput path.profile} {D : F32} {p : Prepared}
    (hp : prepare path x D = .ok p) :
    ∃ r, algorithm1 path x D = .ok r ∧
      r.bits = TensorCore.round32 .nearestEven p.ideal := by
  have hcap := prepare_capacity hp
  obtain ⟨c, hc⟩ := extract_exists hcap.1 hcap.2
  have hs := extract_spec hc
  unfold algorithm1
  simp only [hp, Bind.bind, Except.bind]
  by_cases hz : p.terms.all (fun t => t.word.magnitude == 0) = true
  · refine ⟨.allZero, ?_, ?_⟩
    · rw [if_pos hz]; rfl
    · rw [Prepared.ideal_allZero hz]; decide +kernel
  · cases hb : c.scalar with
    | some b =>
      refine ⟨.scalar b, by rw [if_neg hz, hc]; dsimp +instances only; rw [hb]; rfl, ?_⟩
      have hv := Components.scalar_correct hb
      rw [← hs.2.2.2.2.2.2.1, hs.2.2.2.2.2.2.2] at hv
      exact hv.symm
    | none =>
      have hr := c.recovered.round32_eq
      rw [hs.2.2.2.2.2.2.2] at hr
      cases hf : c.recovered.round32 with
      | none => exact ⟨.outOfRange, by rw [if_neg hz, hc]; dsimp +instances only; rw [hb, hf]; rfl, hf.symm.trans hr⟩
      | some b => exact ⟨.boundedExact b, by rw [if_neg hz, hc]; dsimp +instances only; rw [hb, hf]; rfl, hf.symm.trans hr⟩
```

**Supporting proofs:** [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.wordBudget](Word.md#decl-0632d0aa311c3d92), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4)

</details>

</details>

<a id="decl-ec47f9869483c5f4"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_correct</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Correctness.lean#L84)

```lean
/-- Universal finite-input theorem for all eight paths and any finite supplied D.
There is no premise asserting an extraction, overlap, or exact-sum identity. -/
theorem algorithm1_correct {path : Path} {x : BlockInput path.profile} {D : F32} {s d : ℚ}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    ∃ r, algorithm1 path x D = .ok r ∧ r.bits = TensorCore.round32 .nearestEven s := by
  obtain ⟨p, hp⟩ := prepare_exists hlen hx hD
  have hi := (prepare_spec hp).2.1
  have hv : p.ideal = s := Option.some.inj (hi.symm.trans hx)
  obtain ⟨r, hr, hb⟩ := algorithm1_prepared hp
  exact ⟨r, hr, by simpa [hv] using hb⟩
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1_agrees](Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea)

</details>

</details>

<a id="decl-56c6ead02b649bea"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_success</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Correctness.lean#L96)

```lean
/-- Useful success family: every shape-correct finite block whose *independent*
ideal is within the finite FP32 interval. This includes arbitrary cancellation. -/
theorem algorithm1_success {path : Path} {x : BlockInput path.profile} {D : F32} {s d : ℚ}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d)
    (hrange : absQ s ≤ maxFinite32) :
    ∃ r b, algorithm1 path x D = .ok r ∧ r.bits = some b ∧ NearestEven32 s b := by
  obtain ⟨r, hr, hb⟩ := algorithm1_correct hlen hx hD
  obtain ⟨b, hround, hn⟩ := round32_nearestEven_correct s hrange
  exact ⟨r, b, hr, hb.trans hround, hn⟩
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.round32_nearestEven_correct](../../Numerics/CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_range_iff](Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848)

</details>

</details>

<a id="decl-c9a066d91dcbea2c"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_range_iff</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Correctness.lean#L106)

```lean
/-- After valid decoding, range acceptance is both necessary and sufficient. -/
theorem algorithm1_range_iff {path : Path} {x : BlockInput path.profile} {D : F32} {s d : ℚ}
    (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    (∃ r b, algorithm1 path x D = .ok r ∧ r.bits = some b) ↔ absQ s ≤ maxFinite32 := by
  constructor
  · rintro ⟨r, b, hr, hb⟩
    obtain ⟨r', hr', hb'⟩ := algorithm1_correct hlen hx hD
    have he : r' = r := Except.ok.inj (hr'.symm.trans hr)
    subst r'
    exact TensorCore.round32_range (hb'.symm.trans hb)
  · intro h
    obtain ⟨r, b, hr, hb, _⟩ := algorithm1_success hlen hx hD h
    exact ⟨r, b, hr, hb⟩
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.round32_range](../../Numerics/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65)

</details>

</details>
