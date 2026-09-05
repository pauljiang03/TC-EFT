import TensorCore.Theory.StageResiduals

namespace TensorCore

/-- Execute a fixed-input schedule; the state type can be encoded floating-point values. -/
def foldState (step : σ → α → σ) : σ → List α → σ
  | s, [] => s
  | s, a :: as => foldState step (step s a) as

def foldLoss (step : σ → α → σ) (loss : σ → α → Rat) : σ → List α → Rat
  | _, [] => 0
  | s, a :: as => loss s a + foldLoss step loss (step s a) as

/-- Induction for arbitrary finite lists, with an explicit local contract. -/
theorem fold_residual_ledger
    (value : σ → Rat) (step : σ → α → σ) (loss : σ → α → Rat)
    (contribution : α → Rat)
    (localLaw : ∀ s a, value s + contribution a = value (step s a) + loss s a)
    (s : σ) (as : List α) :
    value s + sumQ (as.map contribution) =
      value (foldState step s as) + foldLoss step loss s as := by
  induction as generalizing s with
  | nil => rfl
  | cons a as ih =>
    simp only [List.map_cons, sumQ, foldState, foldLoss]
    have h := localLaw s a
    have h' := ih (step s a)
    grind

/-- Every later c must be the decoded *encoded* output of the previous call. -/
def EncodedChain : Finite32 → List BlockTrace → Prop
  | _, [] => True
  | d, t :: ts => t.block.c = d.decoded ∧ EncodedChain t.output ts

def lastOutput : Finite32 → List BlockTrace → Finite32
  | d, [] => d
  | _, t :: ts => lastOutput t.output ts

/-- V100 trace specialization of the ledger, with a checked encoded-boundary premise. -/
theorem encoded_trace_ledger (initial : Finite32) (ts : List BlockTrace)
    (chain : EncodedChain initial ts) :
    initial.value + sumQ (ts.map fun t => t.block.exactProducts) =
      (lastOutput initial ts).value + sumQ (ts.map BlockTrace.residual) := by
  induction ts generalizing initial with
  | nil => rfl
  | cons t ts ih =>
    obtain ⟨hc, ht⟩ := chain
    have h := returned_residual_identity t
    change t.block.c.value + t.block.exactProducts = t.output.value + t.residual at h
    rw [hc] at h
    have h' := ih t.output ht
    simp only [List.map_cons, sumQ, lastOutput]
    change initial.decoded.value + (t.block.exactProducts + _) = _
    change t.output.value + _ = _ at h'
    grind

/-- Runnable schedule. Each call receives the bits returned by its predecessor. -/
def runV100 : F32 → List (List (F16 × F16)) → Except ModelError (List BlockTrace)
  | _, [] => .ok []
  | c, ps :: rest =>
    match evalV100 ⟨ps, c⟩ with
    | .error e => .error e
    | .ok t => match runV100 t.output.bits rest with
      | .error e => .error e
      | .ok ts => .ok (t :: ts)

theorem runV100_chain (initial : Finite32) (ps : List (List (F16 × F16)))
    (ts : List BlockTrace) (h : runV100 initial.bits ps = .ok ts) :
    EncodedChain initial ts := by
  induction ps generalizing initial ts with
  | nil => simp [runV100] at h; cases h; trivial
  | cons p ps ih =>
    cases he : evalV100 ⟨p, initial.bits⟩ with
    | error e => simp [runV100, he] at h
    | ok t =>
      cases hr : runV100 t.output.bits ps with
      | error e => simp [runV100, he, hr] at h
      | ok rest =>
        simp [runV100, he, hr] at h
        cases h
        constructor
        · have hc := evalV100_c he
          change decode32 initial.bits = some t.block.c at hc
          rw [initial.valid] at hc
          exact (Option.some.inj hc).symm
        · exact ih t.output rest hr

/-- Every successful executable schedule inherits the encoded-boundary ledger. -/
theorem runV100_residual_ledger (initial : Finite32)
    (ps : List (List (F16 × F16))) (ts : List BlockTrace)
    (h : runV100 initial.bits ps = .ok ts) :
    initial.value + sumQ (ts.map fun t => t.block.exactProducts) =
      (lastOutput initial ts).value + sumQ (ts.map BlockTrace.residual) :=
  encoded_trace_ledger initial ts (runV100_chain initial ps ts h)

end TensorCore
