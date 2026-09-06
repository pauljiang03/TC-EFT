import TensorCore.Theory.ProgramBounds.Loops
import TensorCore.Programs.Partition

namespace TensorCore

/-- Build an inspectable AST from an ordered list of typed groups. -/
def Program.ofGroups {p : Profile} : List (BlockOperands p) → Program p
  | [] => .skip
  | g :: rest => .seq (.block ⟨{label := "ordered dot group"}, g⟩) (.ofGroups rest)

theorem Program.inputs_ofGroups {p : Profile} (gs : List (BlockOperands p)) :
    (Program.ofGroups gs).inputs = gs.map BlockOperands.values := by
  induction gs with
  | nil => rfl
  | cons g gs ih => simpa [Program.ofGroups, Program.inputs, Program.blocks] using congrArg (g.values :: ·) ih

/-- One row-column contribution: ordered groups of four, with zero padding only at the tail. -/
def boundedDot (xs : List (F16 × F16)) : Program v100F16F32 :=
  Program.ofGroups (canonicalPartition 4 0 none (by decide) xs).groups

theorem boundedDot_inputs (xs : List (F16 × F16)) :
    (boundedDot xs).inputs = (canonicalPartition 4 0 none (by decide) xs).inputs :=
  Program.inputs_ofGroups _

theorem boundedDot_count (xs : List (F16 × F16)) :
    (boundedDot xs).inputs.length = groupCount 4 xs.length := by
  rw [boundedDot_inputs]
  exact (List.length_map _).trans (canonicalPartition_count 4 0 none (by decide) xs)

theorem boundedDot_ideal (xs : List (F16 × F16)) (c : F32) :
    (boundedDot xs).ideal c = (do return (← value32 c) + (← idealProducts v100F16F32 xs)) := by
  unfold Program.ideal
  rw [boundedDot_inputs]
  have hi := canonicalPartition_ideal 4 0 none (by decide) xs
  change idealContributions v100F16F32 _ = idealProducts v100F16F32 xs at hi
  rw [hi]

theorem boundedDot_run (xs : List (F16 × F16)) (initial : Finite32) :
    (boundedDot xs).run initial.bits = runCanonicalDot 4 0 none (by decide) xs initial.bits := by
  rw [runCanonicalDot_finite]
  simp only [Program.run, OrderedPartition.run, boundedDot_inputs]
  rfl

/-- Executable input bound: finite, and zero or decoded raw exponent at most -5.
Both signs and subnormals are allowed; every accepted magnitude is below 1/16. -/
def small16 (x : F16) : Bool :=
  match decode16 x with
  | none => false
  | some d => decide (d.significand = 0 ∨ d.rawScale ≤ -5)

/-- A simple encoded interval implies the semantic bound, for either sign. -/
theorem small16_of_bits (x : F16) (h : x.toNat % 32768 < 11264) : small16 x = true := by
  have he : x.toNat / 1024 % 32 ≤ 10 := by omega
  simp only [small16, decode16, classify, classifyNat, fp16, Classification.finite]
  simp only [Nat.reducePow, Nat.reduceAdd, Nat.reduceSub]
  have hx : x.toNat / 1024 % 32 ≠ 31 := by omega
  by_cases hz : x.toNat / 1024 % 32 = 0
  · by_cases hf : x.toNat % 1024 = 0 <;> simp [hz, hf]
  · simp only [hx, hz, ↓reduceIte, decide_eq_true_eq]
    right
    omega

theorem small16_spec (x : F16) (h : small16 x = true) :
    ∃ d, decode16 x = some d ∧ (d.significand = 0 ∨ d.rawScale ≤ -5) := by
  unfold small16 at h
  split at h
  · contradiction
  · exact ⟨_, ‹decode16 x = _›, of_decide_eq_true h⟩

theorem small16_value (x : F16) (h : small16 x = true) :
    ∃ d, decode16 x = some d ∧ absQ d.value < 1 / 16 := by
  obtain ⟨d, hd, hz | hs⟩ := small16_spec x h
  · refine ⟨d, hd, ?_⟩
    simp [Decoded.value, hz, absQ]
    decide +kernel
  · refine ⟨d, hd, ?_⟩
    have hb := classifyNat_bounded fp16 x.toNat d hd
    have hp := pow2_le_of_le hs
    have he : 2 * pow2 (-5) = (1 / 16 : Rat) := by decide +kernel
    change absQ d.value < 2 * pow2 d.rawScale at hb
    rw [← he]
    grind

theorem small16_group (g : List (F16 × F16))
    (h : ∀ pair ∈ g, small16 pair.1 = true ∧ small16 pair.2 = true) :
    GroupScaleBounded v100F16F32 g (-10) := by
  intro pair hp
  obtain ⟨da, ha, hsa⟩ := small16_spec pair.1 (h pair hp).1
  obtain ⟨db, hb, hsb⟩ := small16_spec pair.2 (h pair hp).2
  refine ⟨da, db, ha, hb, ?_⟩
  intro hnz
  change da.significand * db.significand ≠ 0 at hnz
  change da.rawScale + db.rawScale ≤ -10
  rcases hsa with hz | hs
  · simp [hz] at hnz
  rcases hsb with hz | ht
  · simp [hz] at hnz
  omega

theorem boundedDot_scales (xs : List (F16 × F16))
    (hs : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true) :
    ∀ g ∈ (boundedDot xs).inputs, GroupScaleBounded v100F16F32 g (-10) := by
  intro g hg
  apply small16_group
  intro pair hp
  rw [boundedDot_inputs] at hg
  have hm : pair ∈ (padFp16Pairs 4 xs) := by
    rw [← (canonicalPartition 4 0 none (by decide) xs).covers]
    exact List.mem_flatten.mpr ⟨g, hg, hp⟩
  simp only [padFp16Pairs, List.mem_append] at hm
  rcases hm with hx | hz
  · exact hs pair hx
  · have := (List.mem_replicate.mp hz).2
    subst pair
    decide +kernel

theorem boundedDot_group_limit (xs : List (F16 × F16)) (hlen : xs.length ≤ 256) :
    (boundedDot xs).inputs.length ≤ 64 := by
  rw [boundedDot_count]
  unfold groupCount
  split <;> omega

theorem boundedDot_budget : staticBudget 5 23 1 3 = (21 / 4194304 : Rat) := by
  decide +kernel

private theorem small_schedule_room (m : Nat) (hm : m ≤ 64) :
    (1 : Rat) + (m : Rat) * (4 * (4 * pow2 (-10)) + staticBudget 5 23 1 3) < pow2 (1 + 1) := by
  have hmq : (m : Rat) ≤ 64 := Rat.natCast_le_natCast.mpr hm
  have hp : 4 * (4 * pow2 (-10)) + staticBudget 5 23 1 3 = (65557 / 4194304 : Rat) := by decide +kernel
  rw [hp]
  change _ < (4 : Rat)
  grind

private theorem small_schedule_tolerance (m : Nat) (hm : m ≤ 64) :
    (m : Rat) * staticBudget 5 23 1 3 ≤ (1 / 2048 : Rat) := by
  have hmq : (m : Rat) ≤ 64 := Rat.natCast_le_natCast.mpr hm
  rw [boundedDot_budget]
  grind

/-- For up to 256 arbitrary signed small operand pairs and |c| ≤ 1, the actual
ordered FP32 result exists and differs from the original-input ideal by at most 2^-11.
No execution result, exact prefix, or final error is assumed. -/
theorem boundedDot_accurate (xs : List (F16 × F16)) (initial : Finite32)
    (hlen : xs.length ≤ 256)
    (hs : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true)
    (hc : absQ initial.value ≤ 1) :
    (boundedDot xs).Accurate initial.bits (1 / 2048) := by
  apply Program.accurate_of_scales (boundedDot xs) 1 (-10) 3
    (by decide) (by decide) (by simp [v100F16F32]) (by decide) (by decide)
    (boundedDot_scales xs hs) initial 1 _ hc
  · exact small_schedule_room _ (boundedDot_group_limit xs hlen)
  · exact small_schedule_tolerance _ (boundedDot_group_limit xs hlen)

theorem boundedDot_accurate_of_bits (xs : List (F16 × F16)) (initial : Finite32)
    (hlen : xs.length ≤ 256)
    (hs : ∀ pair ∈ xs, pair.1.toNat % 32768 < 11264 ∧ pair.2.toNat % 32768 < 11264)
    (hc : absQ initial.value ≤ 1) : (boundedDot xs).Accurate initial.bits (1 / 2048) :=
  boundedDot_accurate xs initial hlen
    (fun pair hp => ⟨small16_of_bits _ (hs pair hp).1, small16_of_bits _ (hs pair hp).2⟩) hc

/-- Family membership check: decode each input once, without a model run or ideal prefixes. -/
def boundedDotCheck (xs : List (F16 × F16)) (c : F32) : Bool :=
  decide (xs.length ≤ 256) && xs.all (fun (a, b) => small16 a && small16 b) &&
    match value32 c with
    | none => false
    | some v => decide (absQ v ≤ 1)

theorem boundedDotCheck_sound (xs : List (F16 × F16)) (c : F32)
    (h : boundedDotCheck xs c = true) : (boundedDot xs).Accurate c (1 / 2048) := by
  simp only [boundedDotCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨hlen, hs⟩, hc⟩ := h
  cases hv : value32 c with
  | none => simp [hv] at hc
  | some v =>
    obtain ⟨initial, _, hb, hi⟩ := finite32_of_value32 c v hv
    have hs' : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true := by
      intro pair hp
      simpa only [Bool.and_eq_true] using List.all_eq_true.mp hs pair hp
    have hcv : absQ initial.value ≤ 1 := by simpa [hv, hi] using hc
    simpa [hb] using boundedDot_accurate xs initial hlen hs' hcv

/-- A symbolic number of changing-state iterations. The body may contain arbitrary
small operands; the total invocation count, not a fixed point, controls accumulated error. -/
theorem small_repeat_accurate (body : Program v100F16F32) (n : Nat) (initial : Finite32)
    (hcount : n * body.inputs.length ≤ 64)
    (hs : ∀ g ∈ body.inputs, ∀ pair ∈ g, small16 pair.1 = true ∧ small16 pair.2 = true)
    (hc : absQ initial.value ≤ 1) :
    (Program.repeat n body).Accurate initial.bits (1 / 2048) := by
  apply Program.repeat_accurate_of_scales body n 1 (-10) 3
    (by decide) (by decide) (by simp [v100F16F32]) (by decide) (by decide)
    (fun g hg => small16_group g (hs g hg)) initial 1 _ hc
  · exact small_schedule_room _ hcount
  · exact small_schedule_tolerance _ hcount

end TensorCore
