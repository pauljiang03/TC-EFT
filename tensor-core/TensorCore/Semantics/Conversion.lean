import TensorCore.Foundations.BinaryRounding

namespace TensorCore

structure FiniteBinary (f : Format) where
  bits : BitVec f.width
  decoded : Decoded
  valid : (classify f bits).finite = some decoded
  deriving Repr, DecidableEq

def FiniteBinary.value {f : Format} (d : FiniteBinary f) : Rat := d.decoded.value

def finiteBinary (f : Format) (bits : BitVec f.width) : Option (FiniteBinary f) :=
  match h : (classify f bits).finite with
  | none => none
  | some d => some ⟨bits, d, h⟩

theorem finiteBinary_none {f : Format} {bits : BitVec f.width}
    (hd : (classify f bits).finite = none) : finiteBinary f bits = none := by
  unfold finiteBinary
  split
  · rfl
  · rename_i d h
    rw [hd] at h
    contradiction

theorem finiteBinary_some {f : Format} {bits : BitVec f.width} {d : Decoded}
    (hd : (classify f bits).finite = some d) : finiteBinary f bits = some ⟨bits, d, hd⟩ := by
  unfold finiteBinary
  split
  · rename_i h
    rw [hd] at h
    contradiction
  · rename_i d' h
    rw [hd] at h
    cases Option.some.inj h
    rfl

structure ConversionStage where
  format : Format
  mode : BinaryRoundingMode
  deriving Repr, DecidableEq

def ConversionStage.convert (s : ConversionStage) (x : Rat) : Option (FiniteBinary s.format) := do
  finiteBinary s.format (← roundBinary s.format s.mode x)

structure ConversionEvent where
  stage : ConversionStage
  input : Rat
  output : FiniteBinary stage.format
  deriving Repr, DecidableEq

def ConversionEvent.loss (e : ConversionEvent) : Rat := e.input - e.output.value

structure ConversionRun where
  events : List ConversionEvent
  value : Rat
  deriving Repr, DecidableEq

def ConversionRun.loss (r : ConversionRun) : Rat := sumQ (r.events.map ConversionEvent.loss)

/-- Each following conversion receives the decoded encoding of its predecessor. -/
def runConversions : List ConversionStage → Rat → Option ConversionRun
  | [], x => some ⟨[], x⟩
  | s :: ss, x => do
    let d ← s.convert x
    let rest ← runConversions ss d.value
    return ⟨⟨s, x, d⟩ :: rest.events, rest.value⟩

theorem conversionStage_output {s : ConversionStage} {x : Rat} {d : FiniteBinary s.format}
    (h : s.convert x = some d) : roundBinary s.format s.mode x = some d.bits := by
  unfold ConversionStage.convert at h
  cases hr : roundBinary s.format s.mode x with
  | none => simp [hr] at h
  | some bits =>
    simp [hr] at h
    unfold finiteBinary at h
    split at h
    · simp at h
    · simp only [Option.some.injEq] at h
      subst d
      rfl

theorem conversionStage_range {s : ConversionStage} {x : Rat} {d : FiniteBinary s.format}
    (h : s.convert x = some d) : s.format.WellFormed ∧ absQ x ≤ s.format.maxFinite :=
  roundBinary_range (conversionStage_output h)

/-- Executed sequences telescope across actual encodings, with every loss retained. -/
theorem runConversions_recovery (ss : List ConversionStage) (x : Rat) (r : ConversionRun)
    (h : runConversions ss x = some r) : x = r.value + r.loss := by
  induction ss generalizing x r with
  | nil =>
    simp [runConversions] at h
    subst r
    simp [ConversionRun.loss, sumQ]
    grind
  | cons s ss ih =>
    cases hd : s.convert x with
    | none => simp [runConversions, hd] at h
    | some d =>
      cases hr : runConversions ss d.value with
      | none => simp [runConversions, hd, hr] at h
      | some rest =>
        simp [runConversions, hd, hr] at h
        subst r
        have hi := ih d.value rest hr
        simp only [ConversionRun.loss, List.map_cons, sumQ, ConversionEvent.loss] at *
        grind

/-- Every event is a successful conversion; the trace does not invent rounded boundaries. -/
theorem runConversions_events (ss : List ConversionStage) (x : Rat) (r : ConversionRun)
    (h : runConversions ss x = some r) :
    r.events.map ConversionEvent.stage = ss ∧
      ∀ e ∈ r.events, e.stage.convert e.input = some e.output := by
  induction ss generalizing x r with
  | nil => simp [runConversions] at h; subst r; simp
  | cons s ss ih =>
    cases hd : s.convert x with
    | none => simp [runConversions, hd] at h
    | some d =>
      cases hr : runConversions ss d.value with
      | none => simp [runConversions, hd, hr] at h
      | some rest =>
        simp [runConversions, hd, hr] at h
        subst r
        have hi := ih d.value rest hr
        constructor
        · simpa using hi.1
        · intro e he
          simp only [List.mem_cons] at he
          rcases he with he | he
          · subst e; exact hd
          · exact hi.2 e he

end TensorCore
