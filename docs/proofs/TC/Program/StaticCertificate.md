# TensorCore.TC.Program.StaticCertificate

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-66820a4a9870af93"></a>

<details>
<summary><code>TensorCore.groupScaleCheck</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L11)

```lean
/-- Every pair decodes and every nonzero raw product has raw scale at most `E`. -/
def groupScaleCheck (p : Profile) (E : ℤ) (g : List (p.Word × p.Word)) : Bool :=
  g.all fun (a, b) =>
    match p.decode a, p.decode b with
    | some da, some db => (rawMul da db).significand == 0 || decide ((rawMul da db).rawScale ≤ E)
    | _, _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

<details>
<summary>Used by</summary>

[TensorCore.familyConditions_gemmCheck](../../Gemm/Family.md#decl-56c849a6d64aa7bf), [TensorCore.gemmCellCheck](../../Gemm/Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](../../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.groupScaleCheck_sound](StaticCertificate.md#decl-5583db47fae0681c), [TensorCore.staticCheck](StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-5583db47fae0681c"></a>

<details>
<summary><code>TensorCore.groupScaleCheck_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L17)

```lean
theorem groupScaleCheck_sound (p : Profile) (E : ℤ) (g : List (p.Word × p.Word))
    (h : groupScaleCheck p E g = true) : GroupScaleBounded p g E := by
  intro pair hpair
  rcases pair with ⟨a, b⟩
  have hp := List.all_eq_true.mp h (a, b) hpair
  simp only at hp
  cases ha : p.decode a with
  | none => simp [ha] at hp
  | some da =>
    cases hb : p.decode b with
    | none => simp [ha, hb] at hp
    | some db =>
      refine ⟨da, db, rfl, rfl, ?_⟩
      intro hnz
      rw [ha, hb] at hp
      simp only [Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at hp
      rcases hp with hp | hp
      · exact absurd hp hnz
      · exact hp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupScaleBounded](../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.groupScaleCheck](StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmCellCheck_product_bound](../../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-3830663114f133c4"></a>

<details>
<summary><code>TensorCore.partialSumsCheck</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L38)

```lean
/-- Every ideal partial sum, offset by the accumulated budget, stays below `2^(E+1)`. -/
def partialSumsCheck (p : Profile) (E : ℤ) (B c : ℚ) :
    List (List (p.Word × p.Word)) → ℕ → ℚ → Bool
  | [], n, acc => decide (absQ (c + acc) + (n : ℚ) * B < pow2 (E + 1))
  | g :: rest, n, acc =>
    decide (absQ (c + acc) + (n : ℚ) * B < pow2 (E + 1)) &&
      match idealProducts p g with
      | some v => partialSumsCheck p E B c rest (n + 1) (acc + v)
      | none => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.partialSumsCheck_sound](StaticCertificate.md#decl-df9e82cd1ad7c2d7), [TensorCore.staticCheck](StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-e1771047163e04a5"></a>

<details>
<summary><code>TensorCore.idealContributions_cons_some</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L47)

```lean
theorem idealContributions_cons_some (p : Profile) (g : List (p.Word × p.Word))
    (rest : List (List (p.Word × p.Word))) (v : ℚ)
    (h : idealContributions p (g :: rest) = some v) :
    ∃ a b, idealProducts p g = some a ∧ idealContributions p rest = some b ∧ v = a + b := by
  cases ha : idealProducts p g with
  | none => simp [idealContributions, ha] at h
  | some a =>
    cases hb : idealContributions p rest with
    | none => simp [idealContributions, ha, hb] at h
    | some b =>
      refine ⟨a, b, rfl, rfl, ?_⟩
      rw [idealContributions_cons p g rest a b ha hb] at h
      exact (Option.some.inj h).symm
```

**Supporting proofs:** [TensorCore.idealContributions_cons](../StaticBudget.md#decl-0916105e5f507bb2)

**Definitions and types:** [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.idealContributions_abs_le](Bounds/Scales.md#decl-d642c7a05f1cb663), [TensorCore.partialSumsCheck_sound](StaticCertificate.md#decl-df9e82cd1ad7c2d7)

</details>

</details>

<a id="decl-df9e82cd1ad7c2d7"></a>

<details>
<summary><code>TensorCore.partialSumsCheck_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L61)

```lean
theorem partialSumsCheck_sound (p : Profile) (E : ℤ) (B c : ℚ)
    (ps : List (List (p.Word × p.Word))) (k : ℕ) (acc : ℚ)
    (h : partialSumsCheck p E B c ps k acc = true) :
    ∀ n ≤ ps.length, ∀ v, idealContributions p (ps.take n) = some v →
      absQ (c + (acc + v)) + ((k + n : ℕ) : ℚ) * B < pow2 (E + 1) := by
  induction ps generalizing k acc with
  | nil =>
    intro n hn v hv
    have hn0 : n = 0 := by simpa using hn
    subst hn0
    simp only [List.take_nil, idealContributions, Option.some.injEq] at hv
    subst hv
    simp only [partialSumsCheck, decide_eq_true_eq] at h
    simp only [Nat.add_zero, Rat.add_zero]
    exact h
  | cons g rest ih =>
    intro n hn v hv
    simp only [partialSumsCheck, Bool.and_eq_true, decide_eq_true_eq] at h
    obtain ⟨h0, hrest⟩ := h
    cases n with
    | zero =>
      simp only [List.take_zero, idealContributions, Option.some.injEq] at hv
      subst hv
      simp only [Nat.add_zero, Rat.add_zero]
      exact h0
    | succ n =>
      cases hg : idealProducts p g with
      | none => simp [hg] at hrest
      | some vg =>
        rw [hg] at hrest
        rw [List.take_succ_cons] at hv
        obtain ⟨a, v', ha, hr, rfl⟩ := idealContributions_cons_some p g _ v hv
        rw [hg] at ha
        cases Option.some.inj ha
        have := ih (k + 1) (acc + vg) hrest n (by simpa using hn) v' hr
        have hk : ((k + 1 + n : ℕ) : ℚ) = ((k + (n + 1) : ℕ) : ℚ) := by
          congr 1
          omega
        rw [hk] at this
        have he : c + (acc + vg + v') = c + (acc + (vg + v')) := by grind
        rw [he] at this
        exact this
```

**Supporting proofs:** [TensorCore.idealContributions_cons_some](StaticCertificate.md#decl-e1771047163e04a5)

**Definitions and types:** [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.partialSumsCheck](StaticCertificate.md#decl-3830663114f133c4), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-5a0420f6f22f2397"></a>

<details>
<summary><code>TensorCore.staticCheck</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L107)

```lean
/-- The decidable certificate: `E ≥ −126`, the floor at most `E`, `n ≤ 2^L`,
`E + 2 + L ≤ 127`, every group of the right width and scale-bounded, a finite accumulator
input, and bounded ideal partial sums. -/
def staticCheck (p : Profile) (E : ℤ) (L : ℕ) (c : F32)
    (ps : List (List (p.Word × p.Word))) : Bool :=
  decide (-126 ≤ E) &&
  (match p.alignFloor with | none => true | some f => decide (f ≤ E)) &&
  decide (p.products + 1 ≤ 2 ^ L) && decide (E + 2 + L ≤ 127) &&
  ps.all (fun g => g.length == p.products && groupScaleCheck p E g) &&
  match value32 c with
  | some cv => partialSumsCheck p E (staticBudget (p.products + 1) p.alignFraction E L) cv ps 0 0
  | none => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.groupScaleCheck](StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.partialSumsCheck](StaticCertificate.md#decl-3830663114f133c4), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Program.certificateReport](CertifiedProgram.md#decl-6b9db8fb5b4cf559), [TensorCore.Program.staticCertificate](CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Regression.static_certificate_accepts](../Regression/StaticBudget.md#decl-b37b5c200be6f62d), [TensorCore.Regression.static_certificate_applied](../Regression/StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_rejects](../Regression/StaticBudget.md#decl-075a5b6492d2e25b), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

</details>

</details>

<a id="decl-d9cfd7eeec01ec69"></a>

<details>
<summary><code>TensorCore.staticCheck_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/StaticCertificate.lean#L118)

```lean
/-- A passing certificate gives acceptance of the run and the input-derived error bound. -/
theorem staticCheck_sound (p : Profile) (E : ℤ) (L : ℕ) (c : F32)
    (ps : List (List (p.Word × p.Word))) (h : staticCheck p E L c ps = true) :
    ∃ f : Finite32, f.bits = c ∧ ∃ ts products, runBlocks p c ps = .ok ts ∧
      idealContributions p ps = some products ∧
      absQ (f.value + products - (lastOutput f ts).value) ≤
        (ps.length : ℚ) * staticBudget (p.products + 1) p.alignFraction E L := by
  unfold staticCheck at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨⟨hE, hfl⟩, hL⟩, hrange⟩, hgroups⟩, hpartial⟩ := h
  cases hc : value32 c with
  | none => simp [hc] at hpartial
  | some cv =>
    rw [hc] at hpartial
    simp only at hpartial
    obtain ⟨f, _, hfb, hfv⟩ := finite32_of_value32 c cv hc
    have hfl' : ∀ x ∈ p.alignFloor, x ≤ E := by
      intro x hx
      cases hf : p.alignFloor with
      | none => rw [hf] at hx; simp at hx
      | some y =>
        rw [hf] at hx hfl
        simp only [Option.mem_def, Option.some.injEq] at hx
        subst hx
        simpa using hfl
    have hshape : ∀ g ∈ ps, g.length = p.products := by
      intro g hg
      have := List.all_eq_true.mp hgroups g hg
      simp only [Bool.and_eq_true, beq_iff_eq] at this
      exact this.1
    have hscale : ∀ g ∈ ps, GroupScaleBounded p g E := by
      intro g hg
      have := List.all_eq_true.mp hgroups g hg
      simp only [Bool.and_eq_true, beq_iff_eq] at this
      exact groupScaleCheck_sound p E g this.2
    have hps := partialSumsCheck_sound p E _ cv ps 0 0 hpartial
    have hpartial' : ∀ n ≤ ps.length, ∀ v, idealContributions p (ps.take n) = some v →
        absQ (f.value + v) + (n : ℚ) * staticBudget (p.products + 1) p.alignFraction E L <
          pow2 (E + 1) := by
      intro n hn v hv
      have := hps n hn v hv
      rw [Rat.zero_add, Nat.zero_add] at this
      rw [hfv]
      exact this
    obtain ⟨ts, products, hrun, hi, hbound⟩ :=
      runBlocks_static p E L hE hfl' hL hrange ps hshape hscale f hpartial'
    rw [hfb] at hrun
    exact ⟨f, hfb, ts, products, hrun, hi, hbound⟩
```

**Supporting proofs:** [TensorCore.finite32_of_value32](../../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.groupScaleCheck_sound](StaticCertificate.md#decl-5583db47fae0681c), [TensorCore.partialSumsCheck_sound](StaticCertificate.md#decl-df9e82cd1ad7c2d7), [TensorCore.runBlocks_static](../StaticBudget.md#decl-31af1b208da9e431)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupScaleBounded](../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.groupScaleCheck](StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.partialSumsCheck](StaticCertificate.md#decl-3830663114f133c4), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.staticCheck](StaticCertificate.md#decl-5a0420f6f22f2397), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Regression.static_certificate_applied](../Regression/StaticBudget.md#decl-0a3d92d955e4909d)

</details>

</details>
