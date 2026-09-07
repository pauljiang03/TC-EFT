import TensorCore.Programs.ConvertedGemmAnalysis
import TensorCore.Programs.EntryFamily
import TensorCore.Programs.NativeGemm

namespace TensorCore

structure GemmCandidate where
  model : WmmaGemmModel
  inputMode : BinaryRoundingMode := .nearestEven
  multiplyMode : BinaryRoundingMode := .nearestEven
  addMode : BinaryRoundingMode := .nearestEven
  nativeMma : Bool := false
  deriving Repr, DecidableEq

def GemmCandidate.epilogue (c : GemmCandidate) : GemmEpilogue :=
  ⟨c.multiplyMode, c.addMode, ⟨fp32, .nearestEven⟩⟩

def GemmCandidate.nativeModel (c : GemmCandidate) (p : NativePrecision) : Option (NativeGemmModel p) :=
  match p, c.model, c.nativeMma with
  | _, .ampere, false => some .ampere
  | _, .hopper, false => some .hopper
  | .tf32, .hopper, true => some .hopperMma
  | _, _, _ => none

inductive GemmProblem (m n k : Nat) where
  | raw (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
  | scaled (source : Format) (alpha beta : F32)
      (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
      (C : DenseMatrix F32 m n)
  | family (bounds : GemmFamily)
  | entryFamily (bounds : EntryFamily m n k)
  | native (precision : NativePrecision) (A : DenseMatrix (NativeWord precision) m k)
      (B : DenseMatrix (NativeWord precision) k n) (C : DenseMatrix F32 m n)

def GemmProblem.Accurate (p : GemmProblem m n k) (c : GemmCandidate) (tol : Rat) : Prop :=
  match p with
  | .raw A B C => GemmAccurate c.model A B C tol
  | .scaled source alpha beta A B C =>
    ConvertedGemmAccurate source c.inputMode c.model c.epilogue alpha beta A B C tol
  | .family f => GemmFamilyAccurate c.model f m n k tol
  | .entryFamily f => EntryFamilyAccurate c.model f tol
  | .native precision A B C => ∃ model, c.nativeModel precision = some model ∧ NativeGemmAccurate model A B C tol

def GemmProblem.Witness : GemmProblem m n k → Type
  | .raw .. => DenseMatrix (List GroupWitness) m n
  | .scaled .. => DenseMatrix ScaledWitness m n
  | .family .. => GemmBoundConfig
  | .entryFamily .. => DenseMatrix GemmBoundConfig m n
  | .native .. => DenseMatrix (List GroupWitness) m n

def GemmProblem.infer (p : GemmProblem m n k) (c : GemmCandidate) : Option p.Witness :=
  match p with
  | .raw A B C =>
    let cells := analyzeGemm c.model A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD [])
    else none
  | .scaled source alpha beta A B C => do
    let cells ← analyzeConvertedGemm source c.inputMode c.model c.epilogue alpha beta A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩)
    else none
  | .family f => inferFamily c.model k f
  | .entryFamily f => inferEntryFamily c.model f
  | .native precision A B C => do
    let model ← c.nativeModel precision
    let cells := analyzeNativeGemm model A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD [])
    else none

def GemmProblem.check (p : GemmProblem m n k) (c : GemmCandidate) (w : p.Witness)
    (tol : Rat) : Bool :=
  match p with
  | .raw A B C => gemmAnalysisCheck c.model A B C w tol
  | .scaled source alpha beta A B C =>
    convertedAnalysisCheck source c.inputMode c.model c.epilogue alpha beta A B C w tol
  | .family f => familyCheck c.model k f w tol
  | .entryFamily f => entryFamilyCheck c.model f w tol
  | .native precision A B C =>
    ((c.nativeModel precision).map fun model => nativeAnalysisCheck model A B C w tol).getD false

theorem GemmProblem.check_sound (p : GemmProblem m n k) (c : GemmCandidate) (w : p.Witness)
    (tol : Rat) (h : p.check c w tol = true) : p.Accurate c tol := by
  cases p with
  | raw A B C => exact gemmAnalysisCheck_sound c.model A B C w tol h
  | scaled source alpha beta A B C =>
    exact convertedAnalysisCheck_sound source c.inputMode c.model c.epilogue alpha beta A B C w tol h
  | family f => exact familyCheck_sound c.model f w m n k tol h
  | entryFamily f => exact entryFamilyCheck_sound c.model f w tol h
  | native precision A B C =>
    cases hm : c.nativeModel precision with
    | none => simp [check, hm] at h
    | some model => exact ⟨model, hm, nativeAnalysisCheck_sound model A B C w tol (by simpa [check, hm] using h)⟩

def candidateCertified (p : GemmProblem m n k) (tol : Rat) (c : GemmCandidate) : Bool :=
  ((p.infer c).map fun w => p.check c w tol).getD false

theorem candidateCertified_sound (p : GemmProblem m n k) (tol : Rat) (c : GemmCandidate)
    (h : candidateCertified p tol c = true) : p.Accurate c tol := by
  cases hi : p.infer c with
  | none => simp [candidateCertified, hi] at h
  | some w => exact p.check_sound c w tol (by simpa [candidateCertified, hi] using h)

def selectGemm (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : Rat) : Option Nat :=
  candidates.findIdx? (candidateCertified p tol)

theorem selectGemm_sound (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : Rat)
    (i : Nat) (h : selectGemm p candidates tol = some i) :
    ∃ hi : i < candidates.length, p.Accurate candidates[i] tol ∧
      ∀ j (hj : j < i), candidateCertified p tol candidates[j] = false := by
  obtain ⟨hi, hc, hp⟩ := List.findIdx?_eq_some_iff_getElem.mp h
  exact ⟨hi, candidateCertified_sound p tol candidates[i] hc, fun j hj => by simpa using hp j hj⟩

theorem selectGemm_accuracy (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : Rat)
    (i : Nat) (c : GemmCandidate) (h : selectGemm p candidates tol = some i)
    (hc : candidates[i]? = some c) : p.Accurate c tol := by
  obtain ⟨hi, ha, _⟩ := selectGemm_sound p candidates tol i h
  have he : candidates[i] = c := by simpa only [List.getElem?_eq_getElem hi, Option.some.injEq] using hc
  exact he ▸ ha

theorem selectGemm_none (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : Rat) :
    selectGemm p candidates tol = none ↔ ∀ c ∈ candidates, candidateCertified p tol c = false := by
  exact List.findIdx?_eq_none_iff

end TensorCore
