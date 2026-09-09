# TensorCore.TC.Program.CertifiedProgram

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5a5f6971912cfb9a"></a>

<details>
<summary><code>TensorCore.Program.Accurate</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L8)

```lean
/-- Successful execution and an absolute error bound for the uncorrected final output. -/
def Program.Accurate {p : Profile} (pr : Program p) (c : F32) (tolerance : ℚ) : Prop :=
  ∃ (initial : Finite32) (ts : List BlockTrace) (ideal : ℚ),
    initial.bits = c ∧ pr.run c = .ok ts ∧ pr.ideal c = some ideal ∧
    absQ (ideal - (lastOutput initial ts).value) ≤ tolerance
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b)

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.repeat_accurate_of_scales](Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.boundedDotCheck_sound](../Examples/BoundedDot.md#decl-bee6a2a1f0c3f285), [TensorCore.boundedDot_accurate](../Examples/BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.boundedDot_accurate_of_bits](../Examples/BoundedDot.md#decl-feec6cddd4e6942c), [TensorCore.small_repeat_accurate](../Examples/BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-488ed7ab54b8d5ab"></a>

<details>
<summary><code>TensorCore.Program.staticErrorBudget</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L14)

```lean
/-- Budget from the program's inspectable invocation schedule. -/
def Program.staticErrorBudget {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ) : ℚ :=
  (pr.inputs.length : ℚ) * staticBudget (p.products + 1) p.alignFraction E L
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d)

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.certificateReport](CertifiedProgram.md#decl-6b9db8fb5b4cf559), [TensorCore.Program.repeat_accurate_of_scales](Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.staticCertificate](CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a)

</details>

</details>

<a id="decl-9124c9a8c902618b"></a>

<details>
<summary><code>TensorCore.Program.staticCertificate</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L18)

```lean
/-- Concrete input certificate: exact ideal prefixes are checked, without executing blocks. -/
def Program.staticCertificate {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) : Bool :=
  staticCheck p E L c pr.inputs && decide (pr.staticErrorBudget E L ≤ tolerance)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.staticErrorBudget](CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.staticCheck](StaticCertificate.md#decl-5a0420f6f22f2397)

<details>
<summary>Used by</summary>

[TensorCore.Program.certificateReport_passes](CertifiedProgram.md#decl-176831b6bd792310), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Regression.empty_nonfinite_certificate_refused](../Regression/Certification.md#decl-a316f83bd5fdce64), [TensorCore.Regression.finite_empty_zero_tolerance](../Regression/Certification.md#decl-523e00be539059c9), [TensorCore.Regression.insufficient_carry_refused](../Regression/Certification.md#decl-7a4ace0301967203), [TensorCore.Regression.tight_tolerance_refused](../Regression/Certification.md#decl-902af476ec5869b2)

</details>

</details>

<a id="decl-77e10634842ecb7f"></a>

<details>
<summary><code>TensorCore.Program.accurate_of_run</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L22)

```lean
theorem Program.accurate_of_run {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (products tolerance : ℚ)
    (hrun : pr.run initial.bits = .ok ts)
    (hi : idealContributions p pr.inputs = some products)
    (herr : absQ (initial.value + products - (lastOutput initial ts).value) ≤ tolerance) :
    pr.Accurate initial.bits tolerance := by
  refine ⟨initial, ts, initial.value + products, rfl, hrun, ?_, herr⟩
  simp only [Program.ideal, value32, initial.valid, Option.map_some, hi]
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Accurate](CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.ideal](Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_scales](Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.staticCertificate_sound](CertifiedProgram.md#decl-c46da972b4dd783a)

</details>

</details>

<a id="decl-c46da972b4dd783a"></a>

<details>
<summary><code>TensorCore.Program.staticCertificate_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L33)

```lean
/-- The static certificate gives a successful run and the requested uncorrected accuracy. -/
theorem Program.staticCertificate_sound {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) (h : pr.staticCertificate E L c tolerance = true) :
    pr.Accurate c tolerance := by
  simp only [Program.staticCertificate, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨initial, hbits, ts, products, hrun, hi, herr⟩ := staticCheck_sound p E L c pr.inputs h.1
  have ht : absQ (initial.value + products - (lastOutput initial ts).value) ≤ tolerance :=
    Rat.le_trans herr h.2
  have hr : pr.run initial.bits = .ok ts := by simpa [Program.run, hbits] using hrun
  have result := pr.accurate_of_run initial ts products tolerance hr hi ht
  simpa [hbits] using result
```

**Supporting proofs:** [TensorCore.Program.accurate_of_run](CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.staticCheck_sound](StaticCertificate.md#decl-d9cfd7eeec01ec69)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Accurate](CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.run](Defs.md#decl-7a1c9df214179ea0), [TensorCore.Program.staticCertificate](CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Program.staticErrorBudget](CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.staticCheck](StaticCertificate.md#decl-5a0420f6f22f2397)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c968401fb4b6b09d"></a>

<details>
<summary><code>TensorCore.CertificateReport</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L44)

```lean
structure CertificateReport where
  groups : ℕ
  scale : ℤ
  carryBits : ℕ
  budget : ℚ
  tolerance : ℚ
  inputConditionsPass : Bool
  tolerancePass : Bool
  deriving Repr
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Program.certificateReport](CertifiedProgram.md#decl-6b9db8fb5b4cf559), [TensorCore.Program.certificateReport_passes](CertifiedProgram.md#decl-176831b6bd792310)

</details>

</details>

<a id="decl-6b9db8fb5b4cf559"></a>

<details>
<summary><code>TensorCore.Program.certificateReport</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L55)

```lean
/-- Diagnostics use only the input certificate and budget, with no residual or model run. -/
def Program.certificateReport {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) : CertificateReport :=
  ⟨pr.inputs.length, E, L, pr.staticErrorBudget E L, tolerance,
    staticCheck p E L c pr.inputs, decide (pr.staticErrorBudget E L ≤ tolerance)⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CertificateReport](CertifiedProgram.md#decl-c968401fb4b6b09d), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.inputs](Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.staticErrorBudget](CertifiedProgram.md#decl-488ed7ab54b8d5ab), [TensorCore.staticCheck](StaticCertificate.md#decl-5a0420f6f22f2397)

<details>
<summary>Used by</summary>

[TensorCore.Program.certificateReport_passes](CertifiedProgram.md#decl-176831b6bd792310)

</details>

</details>

<a id="decl-176831b6bd792310"></a>

<details>
<summary><code>TensorCore.Program.certificateReport_passes</code></summary>

[Lean source](../../../../TensorCore/TC/Program/CertifiedProgram.lean#L60)

```lean
theorem Program.certificateReport_passes {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) :
    ((pr.certificateReport E L c tolerance).inputConditionsPass &&
      (pr.certificateReport E L c tolerance).tolerancePass) =
      pr.staticCertificate E L c tolerance := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CertificateReport](CertifiedProgram.md#decl-c968401fb4b6b09d), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.certificateReport](CertifiedProgram.md#decl-6b9db8fb5b4cf559), [TensorCore.Program.staticCertificate](CertifiedProgram.md#decl-9124c9a8c902618b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
