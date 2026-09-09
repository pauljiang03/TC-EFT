-- Report for the tensor-core model.

import TensorCore.TC.Program.Defs

namespace TensorCore

structure CallFailure where
  site : SourceSite
  invocation : ℕ
  reason : ModelError
  deriving Repr, DecidableEq

/-- Diagnostic evaluation follows the same block evaluator and encoded boundaries. -/
def runLocated (p : Profile) (c : F32) (index : ℕ) :
    List (LocatedBlock p) → Except CallFailure (List BlockTrace)
  | [] => .ok []
  | call :: rest =>
    match evalBlock (p := p) ⟨call.operands.values, c⟩ with
    | .error e => .error ⟨call.site, index, e⟩
    | .ok t => match runLocated p t.output.bits (index + 1) rest with
      | .error e => .error e
      | .ok ts => .ok (t :: ts)

/-- Locations cannot change numerical execution, including on failing paths. -/
theorem runLocated_erases (p : Profile) (c : F32) (index : ℕ) (calls : List (LocatedBlock p)) :
    (runLocated p c index calls).mapError CallFailure.reason =
      runBlocks p c (calls.map fun call => call.operands.values) := by
  induction calls generalizing c index with
  | nil => rfl
  | cons call calls ih =>
    cases he : evalBlock (p := p) ⟨call.operands.values, c⟩ with
    | error e => simp [runLocated, runBlocks, he, Except.mapError]
    | ok t =>
      have h := ih t.output.bits (index + 1)
      cases hr : runLocated p t.output.bits (index + 1) calls with
      | error e => simp [hr, Except.mapError] at h; simp [runLocated, runBlocks, he, hr, ← h, Except.mapError]
      | ok ts => simp [hr, Except.mapError] at h; simp [runLocated, runBlocks, he, hr, ← h, Except.mapError]

inductive ProgramFailure where
  | initialNonfinite
  | call (failure : CallFailure)
  | finalSumOutOfRange (exactSum : ℚ)
  deriving Repr, DecidableEq

structure ProgramReport where
  profile : Profile
  sites : List SourceSite
  outputBits : List ℕ
  modelFinalBits : ℕ
  residual : ℚ
  recovered : ℚ
  ideal : Option ℚ
  correctedBits : Option ℕ
  deriving Repr, DecidableEq

/-- A numerical diagnostic, never used as an unchecked proof certificate. -/
def Program.report {p : Profile} (pr : Program p) (c : F32) : Except ProgramFailure ProgramReport := do
  let some initial := finite32 c | .error .initialNonfinite
  let ts ← (runLocated p c 0 pr.blocks).mapError ProgramFailure.call
  let recovered := recoveredSchedule initial ts
  if absQ recovered > maxFinite32 then .error (.finalSumOutOfRange recovered)
  else return ⟨p, pr.blocks.map LocatedBlock.site, ts.map (fun t => t.output.bits.toNat),
    (lastOutput initial ts).bits.toNat, sumQ (ts.map BlockTrace.residual), recovered,
    pr.ideal c, (correctedSchedule initial ts).map BitVec.toNat⟩

theorem Program.report_accepts_iff {p : Profile} (pr : Program p) (c : F32) :
    (pr.report c).isOk = true ↔ pr.VC c := by
  have hrun := runLocated_erases p c 0 pr.blocks
  change (runLocated p c 0 pr.blocks).mapError CallFailure.reason = pr.run c at hrun
  cases hi : finite32 c with
  | none => simp [Program.report, Program.VC, hi, Except.isOk, Except.toBool]
  | some initial =>
    cases he : runLocated p c 0 pr.blocks with
    | error e =>
      simp [he, Except.mapError] at hrun
      simp [Program.report, Program.VC, hi, he, ← hrun, Except.mapError,
        Bind.bind, Except.bind, Except.isOk, Except.toBool]
    | ok ts =>
      simp [he, Except.mapError] at hrun
      simp [Program.report, Program.VC, hi, he, ← hrun, Except.mapError,
        Bind.bind, Except.bind, Pure.pure, Except.pure]
      split <;> simp_all [Except.isOk, Except.toBool] <;> grind


end TensorCore
