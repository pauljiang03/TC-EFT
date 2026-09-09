-- Certified Program for the tensor-core model.

import TensorCore.TC.Program.StaticCertificate

namespace TensorCore

/-- Successful execution and an absolute error bound for the uncorrected final output. -/
def Program.Accurate {p : Profile} (pr : Program p) (c : F32) (tolerance : ℚ) : Prop :=
  ∃ (initial : Finite32) (ts : List BlockTrace) (ideal : ℚ),
    initial.bits = c ∧ pr.run c = .ok ts ∧ pr.ideal c = some ideal ∧
    absQ (ideal - (lastOutput initial ts).value) ≤ tolerance

/-- Budget from the program's inspectable invocation schedule. -/
def Program.staticErrorBudget {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ) : ℚ :=
  (pr.inputs.length : ℚ) * staticBudget (p.products + 1) p.alignFraction E L

/-- Concrete input certificate: exact ideal prefixes are checked, without executing blocks. -/
def Program.staticCertificate {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) : Bool :=
  staticCheck p E L c pr.inputs && decide (pr.staticErrorBudget E L ≤ tolerance)

theorem Program.accurate_of_run {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (products tolerance : ℚ)
    (hrun : pr.run initial.bits = .ok ts)
    (hi : idealContributions p pr.inputs = some products)
    (herr : absQ (initial.value + products - (lastOutput initial ts).value) ≤ tolerance) :
    pr.Accurate initial.bits tolerance := by
  refine ⟨initial, ts, initial.value + products, rfl, hrun, ?_, herr⟩
  simp only [Program.ideal, value32, initial.valid, Option.map_some, hi]
  rfl

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

structure CertificateReport where
  groups : ℕ
  scale : ℤ
  carryBits : ℕ
  budget : ℚ
  tolerance : ℚ
  inputConditionsPass : Bool
  tolerancePass : Bool
  deriving Repr

/-- Diagnostics use only the input certificate and budget, with no residual or model run. -/
def Program.certificateReport {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) : CertificateReport :=
  ⟨pr.inputs.length, E, L, pr.staticErrorBudget E L, tolerance,
    staticCheck p E L c pr.inputs, decide (pr.staticErrorBudget E L ≤ tolerance)⟩

theorem Program.certificateReport_passes {p : Profile} (pr : Program p) (E : ℤ) (L : ℕ)
    (c : F32) (tolerance : ℚ) :
    ((pr.certificateReport E L c tolerance).inputConditionsPass &&
      (pr.certificateReport E L c tolerance).tolerancePass) =
      pr.staticCertificate E L c tolerance := rfl

end TensorCore
