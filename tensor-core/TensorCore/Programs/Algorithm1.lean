import TensorCore.Programs.EFT
import TensorCore.Theory.ErrorBounds

/-! TC-EFT Lemma IV.2 and Algorithm 1 as one named procedure. The exact reference branch
recovers `D − ε_o + Σ εᵢ` in exact dyadic arithmetic and rounds once to nearest even; the
scalar branch replaces the final exact operations by FP32 additions when the predicate of
Theorems IV.8–IV.9 holds. Table V is the paper's operation ledger for the reference branch.
Both branches are the paper's; neither is a fallback added here, and `tceft` remains the
scalar branch alone. -/

namespace TensorCore

/-- Lemma IV.2: the overlap window width `τ = ψ − η + p ≥ 0`, where `qE = 2^(ψ−23)` is the
extraction grid and `qA = 2^(η − 23 − p)` the alignment grid. -/
theorem overlap_window_width (t : BlockTrace) (η : Int) (p : Nat) (hη : t.block.eta = some η)
    (hF : t.block.profile.alignFraction = 23 + p) :
    0 ≤ t.extractionExponent - t.block.quantumExponent ∧
      t.extractionExponent - t.block.quantumExponent =
        max 0 ((outputQuantumExponent t.output.bits + 23) - η + p) := by
  unfold BlockTrace.extractionExponent PreparedBlock.quantumExponent
  rw [hη, hF]
  simp only [Option.getD_some]
  omega

/-- The exact reference branch of Algorithm 1: `RN(D − ε_o + Σ εᵢ)` formed from the
extracted components in exact dyadic arithmetic. -/
def BlockTrace.exactConsolidation (t : BlockTrace) : Option F32 :=
  round32 .nearestEven (t.output.value - t.overlap + sumQ t.lowParts)

/-- The component form recovers the same exact sum as the stage-residual reference. -/
theorem exactConsolidation_eq_corrected (t : BlockTrace) :
    t.exactConsolidation = t.corrected := by
  unfold BlockTrace.exactConsolidation
  rw [← overlap_recovery, corrected_eq_round_exactDot]

/-- Outcome of Algorithm 1: the scalar branch, the exact reference branch, or an exact sum
outside the FP32 range. -/
inductive Algorithm1Result where
  | scalar (bits : F32)
  | exactReference (bits : F32)
  | outOfRange
  deriving Repr, DecidableEq

def Algorithm1Result.bits : Algorithm1Result → Option F32
  | .scalar b => some b
  | .exactReference b => some b
  | .outOfRange => none

/-- Algorithm 1 on a trace: the scalar branch when the predicate holds, otherwise the exact
reference branch. -/
def BlockTrace.algorithm1 (t : BlockTrace) : Algorithm1Result :=
  match t.scalarCorrected with
  | some b => .scalar b
  | none =>
    match t.exactConsolidation with
    | some b => .exactReference b
    | none => .outOfRange

theorem algorithm1_scalar_iff (t : BlockTrace) (b : F32) :
    t.algorithm1 = .scalar b ↔ t.scalarCorrected = some b := by
  unfold BlockTrace.algorithm1
  cases hs : t.scalarCorrected with
  | some b' => simp
  | none =>
    cases t.exactConsolidation <;> simp

theorem algorithm1_exact_iff (t : BlockTrace) (b : F32) :
    t.algorithm1 = .exactReference b ↔
      t.scalarPredicate = false ∧ t.corrected = some b := by
  unfold BlockTrace.algorithm1
  rw [← exactConsolidation_eq_corrected]
  cases hp : t.scalarPredicate with
  | true =>
    obtain ⟨b', hb', _⟩ := scalarCorrected_correct t hp
    rw [hb']
    simp
  | false =>
    rw [scalarCorrected_rejects t hp]
    cases t.exactConsolidation <;> simp

/-- Whichever branch runs, a returned encoding is the correctly rounded exact sum. -/
theorem algorithm1_correct (t : BlockTrace) (b : F32) (h : t.algorithm1.bits = some b) :
    NearestEven32 t.block.exactDot b := by
  unfold BlockTrace.algorithm1 at h
  cases hs : t.scalarCorrected with
  | some b' =>
    rw [hs] at h
    simp only [Algorithm1Result.bits, Option.some.injEq] at h
    subst h
    exact tceft_correct t b' hs
  | none =>
    rw [hs] at h
    cases he : t.exactConsolidation with
    | some b' =>
      rw [he] at h
      simp only [Algorithm1Result.bits, Option.some.injEq] at h
      subst h
      rw [exactConsolidation_eq_corrected, corrected_eq_round_exactDot] at he
      obtain ⟨b'', hb'', hn⟩ := round32_nearestEven_correct _ (round32_range he)
      rw [he] at hb''
      cases Option.some.inj hb''
      exact hn
    | none =>
      rw [he] at h
      simp [Algorithm1Result.bits] at h

/-- Algorithm 1 returns an encoding exactly when the exact sum is in range. -/
theorem algorithm1_bits_isSome_iff (t : BlockTrace) :
    t.algorithm1.bits.isSome = true ↔ absQ t.block.exactDot ≤ maxFinite32 := by
  unfold BlockTrace.algorithm1
  cases hs : t.scalarCorrected with
  | some b =>
    simp only [Algorithm1Result.bits, Option.isSome_some, true_iff]
    have hp : t.scalarPredicate = true := by
      apply Classical.byContradiction
      intro hne
      have hf : t.scalarPredicate = false := by grind
      rw [scalarCorrected_rejects t hf] at hs
      contradiction
    unfold BlockTrace.scalarPredicate at hp
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hp
    rw [← retained_add_low]
    exact hp.2
  | none =>
    rw [exactConsolidation_eq_corrected, corrected_eq_round_exactDot]
    cases hr : round32 .nearestEven t.block.exactDot with
    | some b =>
      simp only [Algorithm1Result.bits, Option.isSome_some, true_iff]
      exact round32_range hr
    | none =>
      simp only [Algorithm1Result.bits, Option.isSome_none, Bool.false_eq_true, false_iff]
      intro hrange
      obtain ⟨b, hb, _⟩ := round32_nearestEven_correct t.block.exactDot hrange
      rw [hr] at hb
      contradiction

/-- TC-EFT Table V: the reference branch's per-cell operation ledger for `K` products
(`n = K + 1` terms), as the paper counts it. It is an operation count, not a timing. -/
structure ReferenceLedger where
  bitDecodes : Nat
  scaleComparisons : Nat
  integerMultiplies : Nat
  quotientRemainders : Nat
  signedIntegerAdditions : Nat
  exactDyadicSubtractions : Nat
  exactResidualAdditions : Nat
  exactFinalOperations : Nat
  integerNearestEvenRoundings : Nat
  deriving Repr, DecidableEq

def referenceLedger (K : Nat) : ReferenceLedger :=
  ⟨2 * K + 2, K + 1, K, K + 1, K, 1, K, 2, 1⟩

/-- The scalar branch performs `n + 1` FP32 operations for `n = K + 1` terms. -/
def scalarBranchOperations (K : Nat) : Nat := K + 2

end TensorCore
