import TensorCore.Programs.Correction

namespace TensorCore

/-- Group size and operand width are checked by the type of each call. -/
structure BlockOperands (p : Profile) where
  values : List (p.Word × p.Word)
  shape : values.length = p.products
  deriving Repr

/-- Literal construction checks range before converting natural numbers to words. -/
def BlockOperands.ofNats {p : Profile} (values : List (Nat × Nat))
    (shape : values.length = p.products)
    (_fits : values.all (fun (a, b) => a < 2 ^ p.input.width && b < 2 ^ p.input.width) = true) :
    BlockOperands p :=
  ⟨values.map (fun (a, b) => (BitVec.ofNat _ a, BitVec.ofNat _ b)), by simpa using shape⟩

def checkedF32 (value : Nat) (_fits : value < 2 ^ 32) : F32 := BitVec.ofNat 32 value

structure SourceSite where
  file : String := "<Lean term>"
  line : Nat := 0
  column : Nat := 0
  label : String := "block"
  deriving Repr, DecidableEq

structure LocatedBlock (p : Profile) where
  site : SourceSite
  operands : BlockOperands p
  deriving Repr

/-- First program fragment: fixed operands, explicit order, and bounded repetition.
The profile is a type parameter; all calls use its input width and group size. -/
inductive Program (p : Profile) where
  | skip
  | block (call : LocatedBlock p)
  | seq (first second : Program p)
  | repeat (count : Nat) (body : Program p)
  deriving Repr

def repeatList (xs : List α) : Nat → List α
  | 0 => []
  | n + 1 => xs ++ repeatList xs n

/-- The ordered invocation schedule is inspectable independently of syntax. -/
def Program.blocks {p : Profile} : Program p → List (LocatedBlock p)
  | .skip => []
  | .block call => [call]
  | .seq first second => first.blocks ++ second.blocks
  | .repeat n body => repeatList body.blocks n

def Program.inputs {p : Profile} (pr : Program p) : List (List (p.Word × p.Word)) :=
  pr.blocks.map fun call => call.operands.values

def Program.run {p : Profile} (pr : Program p) (c : F32) : Except ModelError (List BlockTrace) :=
  runBlocks p c pr.inputs

/-- Direct input-bit ideal sum. No model output, alignment, or residual is consulted. -/
def idealProducts (p : Profile) (ps : List (p.Word × p.Word)) : Option Rat :=
  (prepareProducts p ps).map fun qs => sumQ (qs.map fun (a, b) => a.value * b.value)

def idealContributions (p : Profile) : List (List (p.Word × p.Word)) → Option Rat
  | [] => some 0
  | ps :: rest => do return (← idealProducts p ps) + (← idealContributions p rest)

def Program.ideal {p : Profile} (pr : Program p) (c : F32) : Option Rat := do
  return (← value32 c) + (← idealContributions p pr.inputs)

theorem evalBlock_idealProducts {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : idealProducts p x.products = some t.block.exactProducts := by
  have hp := evalBlock_prepared h
  unfold prepare at hp
  cases hc : decode32 x.c with
  | none => simp [hc] at hp
  | some c =>
    cases hps : prepareProducts p x.products with
    | none => simp [hc, hps] at hp
    | some ps =>
      simp [hc, hps] at hp
      rw [← hp]
      simp [idealProducts, hps, PreparedBlock.exactProducts]

theorem runBlocks_idealContributions (p : Profile) (c : F32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p c ps = .ok ts) :
    idealContributions p ps = some (sumQ (ts.map fun t => t.block.exactProducts)) := by
  induction ps generalizing c ts with
  | nil => simp [runBlocks] at h; cases h; rfl
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        cases h
        simp [idealContributions, evalBlock_idealProducts he, ih t.output.bits rest hr, sumQ]

theorem Program.recovery {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (h : pr.run initial.bits = .ok ts) :
    pr.ideal initial.bits = some (recoveredSchedule initial ts) := by
  have hc := runBlocks_idealContributions p initial.bits pr.inputs ts h
  have hl := runBlocks_residual_ledger p initial pr.inputs ts h
  simp only [Program.ideal, value32, initial.valid, Option.map_some, hc]
  change some (initial.value + sumQ (ts.map fun t => t.block.exactProducts)) = _
  rw [hl]; rfl

/-- Executable sufficient conditions: finite initial encoding, successful calls,
and an in-range final exact sum. Failure is not a hardware counterexample. -/
def Program.VC {p : Profile} (pr : Program p) (c : F32) : Prop :=
  match finite32 c with
  | none => False
  | some initial => match pr.run c with
    | .error _ => False
    | .ok ts => absQ (recoveredSchedule initial ts) ≤ maxFinite32

instance {p : Profile} (pr : Program p) (c : F32) : Decidable (pr.VC c) := by
  unfold Program.VC
  split
  · infer_instance
  · split <;> infer_instance

/-- Total correctness of execution and correction against the direct input sum. -/
def Program.Correct {p : Profile} (pr : Program p) (c : F32) : Prop :=
  ∃ (initial : Finite32) (ts : List BlockTrace) (z : Rat) (b : F32),
    initial.bits = c ∧ pr.run c = .ok ts ∧ pr.ideal c = some z ∧
    recoveredSchedule initial ts = z ∧ correctedSchedule initial ts = some b ∧
    NearestEven32 z b

theorem finite32_bits {c : F32} {initial : Finite32} (h : finite32 c = some initial) :
    initial.bits = c := by
  unfold finite32 at h
  split at h
  · contradiction
  · cases Option.some.inj h; rfl

/-- Soundness of the first program checking layer. Metaprograms only apply this theorem. -/
theorem Program.vc_sound {p : Profile} (pr : Program p) (c : F32) (h : pr.VC c) :
    pr.Correct c := by
  unfold Program.VC at h
  cases hi : finite32 c with
  | none => simp [hi] at h
  | some initial =>
    cases he : pr.run c with
    | error e => simp [hi, he] at h
    | ok ts =>
      simp only [hi, he] at h
      have hb := finite32_bits hi
      have hr := pr.recovery initial ts (by simpa [hb] using he)
      rw [hb] at hr
      obtain ⟨b, hc, hn⟩ := round32_nearestEven_correct (recoveredSchedule initial ts) h
      exact ⟨initial, ts, recoveredSchedule initial ts, b, hb, he, hr, rfl, hc, hn⟩

end TensorCore
