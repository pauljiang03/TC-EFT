import TensorCore.Programs.Loops
import TensorCore.Programs.ErrorBounds
import TensorCore.Semantics.Canonical
import TensorCore.Theory.MachineRefinement

namespace TensorCore

theorem idealProducts_append (p : Profile) (xs ys : List (p.Word × p.Word)) :
    idealProducts p (xs ++ ys) = (do return (← idealProducts p xs) + (← idealProducts p ys)) := by
  have hp : prepareProducts p (xs ++ ys) =
      (do return (← prepareProducts p xs) ++ (← prepareProducts p ys)) := by
    simp [prepareProducts]
  unfold idealProducts
  rw [hp]
  cases hx : prepareProducts p xs <;> cases hy : prepareProducts p ys <;>
    simp [List.map_append, sumQ_append]

/-- Grouping preserves the original-bit ideal, including rejection of special operands. -/
theorem idealContributions_flatten (p : Profile) (groups : List (List (p.Word × p.Word))) :
    idealContributions p groups = idealProducts p groups.flatten := by
  induction groups with
  | nil => simp [idealContributions, idealProducts, prepareProducts, sumQ]
  | cons xs groups ih =>
    simp only [idealContributions, List.flatten_cons, idealProducts_append, ih]

/-- A supplied contiguous partition of original operand pairs into fixed-size groups.
The coverage equality retains order, factorization, and multiplicity. It carries
no claim that a GPU instruction executes this chosen grouping. -/
structure OrderedPartition (p : Profile) (original : List (p.Word × p.Word)) where
  groups : List (BlockOperands p)
  covers : (groups.map BlockOperands.values).flatten = original

def OrderedPartition.inputs {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) : List (List (p.Word × p.Word)) :=
  partition.groups.map BlockOperands.values

def OrderedPartition.run {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) (c : F32) : Except ModelError (List BlockTrace) :=
  runBlocks p c partition.inputs

theorem OrderedPartition.input_count {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) : original.length = partition.groups.length * p.products := by
  have h (gs : List (BlockOperands p)) :
      (gs.map BlockOperands.values).flatten.length = gs.length * p.products := by
    induction gs with
    | nil => simp
    | cons g gs ih =>
      simp [List.flatten_cons, g.shape, ih, Nat.add_mul, Nat.add_comm]
  exact (congrArg List.length partition.covers).symm.trans (h partition.groups)

theorem OrderedPartition.ideal {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) :
    idealContributions p partition.inputs = idealProducts p original := by
  rw [idealContributions_flatten]
  exact congrArg (idealProducts p) partition.covers

/-- A long dot product's uncorrected output has the composed local error budget,
relative to the separately decoded original pair list. -/
theorem OrderedPartition.uncorrected_error {p : Profile} {original : List (p.Word × p.Word)}
    (partition : OrderedPartition p original) (initial : Finite32) (ts : List BlockTrace)
    (products : Rat) (h : partition.run initial.bits = .ok ts)
    (hi : idealProducts p original = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) ∧
    (partition.inputs ≠ [] →
      absQ (initial.value + products - (lastOutput initial ts).value) <
        sumQ (ts.map BlockTrace.errorBudget)) :=
  runBlocks_uncorrected_error p initial partition.inputs ts products h (by rw [partition.ideal, hi])

/-- Execute the same encoded schedule using the specified signed accumulation width. -/
def runBlocksMachine (w : Nat) (p : Profile) :
    F32 → List (List (p.Word × p.Word)) → Except ModelError (List BlockTrace)
  | _, [] => .ok []
  | c, ps :: rest =>
    match evalBlockMachine w (p := p) ⟨ps, c⟩ with
    | .error e => .error e
    | .ok t => match runBlocksMachine w p t.output.bits rest with
      | .error e => .error e
      | .ok ts => .ok (t :: ts)

/-- Local full-result equivalence composes across all encoded schedule boundaries. -/
theorem runBlocksMachine_eq (p : Profile) (w F carryBits : Nat)
    (hF : p.alignFraction = F) (hc : p.products + 1 ≤ 2 ^ carryBits)
    (hw : F + 2 + carryBits + 1 ≤ w) (c : F32)
    (ps : List (List (p.Word × p.Word))) :
    runBlocksMachine w p c ps = runBlocks p c ps := by
  induction ps generalizing c with
  | nil => rfl
  | cons q ps ih =>
    simp only [runBlocksMachine, evalBlockMachine_eq _ w F carryBits hF hc hw, runBlocks]
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => rfl
    | ok t =>
      dsimp only
      rw [ih]
      rfl

theorem fp16Fp32_schedule_machine_eq (K extra carryBits w : Nat) (floor : Option Int)
    (hc : K + 1 ≤ 2 ^ carryBits) (hw : 26 + extra + carryBits ≤ w) (c : F32)
    (ps : List (List (F16 × F16))) :
    runBlocksMachine w (fp16Fp32Profile K extra floor) c ps =
      runBlocks (fp16Fp32Profile K extra floor) c ps :=
  runBlocksMachine_eq (fp16Fp32Profile K extra floor) w (23 + extra) carryBits rfl hc (by omega) c ps

end TensorCore
