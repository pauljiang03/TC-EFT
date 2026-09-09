# TensorCore.TC.Regression.Certification

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-051cf35b9a4ff28d"></a>

<details>
<summary><code>TensorCore.Regression.lossyProgram</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Certification.lean#L10)

```lean
def lossyProgram : Program v100F16F32 := tc%{
  repeat (8) {
    block "small products" [(0x2bff, 0x2bff), (0x2bff, 0x2bff),
      (0x2bff, 0x2bff), (0x2bff, 0x2bff)];
  }
}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands.ofNats](../Program/Defs.md#decl-6720fa7bd1adb1d0), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.changing_loop_has_rounding_error](Application.md#decl-3ad8e32bd2a7f1a0), [TensorCore.Regression.insufficient_carry_refused](Certification.md#decl-7a4ace0301967203), [TensorCore.Regression.tight_tolerance_refused](Certification.md#decl-902af476ec5869b2)

</details>

</details>

<a id="decl-902af476ec5869b2"></a>

<details>
<summary><code>TensorCore.Regression.tight_tolerance_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Certification.lean#L19)

```lean
theorem tight_tolerance_refused :
    lossyProgram.staticCertificate 1 3 0x3f800000 (1 / 1000000) = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Program.staticCertificate](../Program/CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Regression.lossyProgram](Certification.md#decl-051cf35b9a4ff28d), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7a4ace0301967203"></a>

<details>
<summary><code>TensorCore.Regression.insufficient_carry_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Certification.lean#L22)

```lean
theorem insufficient_carry_refused :
    lossyProgram.staticCertificate 1 2 0x3f800000 1 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Program.staticCertificate](../Program/CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.Regression.lossyProgram](Certification.md#decl-051cf35b9a4ff28d), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a316f83bd5fdce64"></a>

<details>
<summary><code>TensorCore.Regression.empty_nonfinite_certificate_refused</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Certification.lean#L25)

```lean
theorem empty_nonfinite_certificate_refused :
    (Program.skip : Program v100F16F32).staticCertificate 1 3 0x7fc00000 1 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.staticCertificate](../Program/CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-523e00be539059c9"></a>

<details>
<summary><code>TensorCore.Regression.finite_empty_zero_tolerance</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Certification.lean#L28)

```lean
theorem finite_empty_zero_tolerance :
    (Program.skip : Program v100F16F32).staticCertificate 1 3 0 0 = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.staticCertificate](../Program/CertifiedProgram.md#decl-9124c9a8c902618b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
