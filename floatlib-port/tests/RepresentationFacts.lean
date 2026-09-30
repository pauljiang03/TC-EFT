import TCFloat

/-! These are counterexamples to a *literal* representation-preserving identification, not counterexamples to the behavior of the checked encoded entry points. -/
namespace TCFloat.Comparison
open FloatLib.Floats.Formats.BinaryInterchange

def project (t : Term) : Int × Int × Int :=
  (t.dyadic.signedSignificand,t.rawScale,t.fractionBits)

def zeroPositive : Term := ⟨⟨false,0,0⟩,0,0⟩
def zeroNegative : Term := ⟨⟨true,0,0⟩,0,0⟩

/-- The original finite decode erases this zero sign; the port retains it. -/
theorem projection_not_injective :
    project zeroPositive = project zeroNegative ∧ zeroPositive ≠ zeroNegative := by
  constructor
  · decide +kernel
  · intro h
    have : false = true := congrArg (fun t : Term => t.dyadic.negative) h
    contradiction

theorem both_zero_forms_reachable :
    decode .binary16 0 = some zeroPositive ∧ decode .binary16 32768 = some zeroNegative := by
  constructor <;> rfl

/-- The extra dyadic exponent is unconstrained in the public raw Term structure. -/
def inconsistentTerm : Term := ⟨⟨false,1,0⟩,0,23⟩

theorem unrestricted_projection_changes_value :
    inconsistentTerm.value = 1 ∧
    (inconsistentTerm.dyadic.signedSignificand : ℚ) *
      pow2 (inconsistentTerm.rawScale-inconsistentTerm.fractionBits) ≠ inconsistentTerm.value := by
  decide +kernel

/-- Original Finite32 enforces this relationship by a proof field; Trace does not. -/
def inconsistentTrace : Trace :=
  ⟨⟨fp16 0 0,zeroPositive,[]⟩,0,1⟩

theorem unrestricted_trace_inconsistent :
    value32 inconsistentTrace.bits = some 0 ∧ inconsistentTrace.output = 1 := by
  decide +kernel

/-- The checked constructor does not construct the inconsistent trace. -/
theorem checked_trace_consistent :
    (trace inconsistentTrace.block 0).map Trace.output = some 0 := by
  decide +kernel

/-- No `extra : Nat` represents the source's permissible raw F=22 profile. -/
theorem profile_subset (extra : Nat) : (23 + extra : Int) ≠ 22 := by omega

end TCFloat.Comparison
