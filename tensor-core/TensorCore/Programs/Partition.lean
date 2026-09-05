import TensorCore.Programs.DotProduct

namespace TensorCore

/-- Construct an ordered partition when the original length is exactly n groups. -/
def partitionExact (p : Profile) (n : Nat) (xs : List (p.Word × p.Word))
    (hlen : xs.length = n * p.products) : OrderedPartition p xs :=
  match n with
  | 0 => ⟨[], by
      have hx : xs = [] := List.length_eq_zero_iff.mp (by simpa using hlen)
      simp [hx]⟩
  | n + 1 =>
    let first : BlockOperands p := ⟨xs.take p.products, by
      have hle : p.products ≤ xs.length := by rw [Nat.add_mul] at hlen; omega
      simp [List.length_take, Nat.min_eq_left hle]⟩
    let rest := partitionExact p n (xs.drop p.products) (by
      simp only [List.length_drop]
      rw [Nat.add_mul] at hlen
      omega)
    ⟨first :: rest.groups, by
      simp only [List.map_cons, List.flatten_cons]
      rw [rest.covers]
      exact List.take_append_drop p.products xs⟩

theorem partitionExact_count (p : Profile) (n : Nat) (xs : List (p.Word × p.Word))
    (hlen : xs.length = n * p.products) : (partitionExact p n xs hlen).groups.length = n := by
  induction n generalizing xs with
  | zero => rfl
  | succ n ih => simp only [partitionExact, List.length_cons, ih]

/-- Zero pairs added to the final group. Exact multiples and empty inputs add none. -/
def tailPadding (K n : Nat) : Nat := if n % K = 0 then 0 else K - n % K

def groupCount (K n : Nat) : Nat := n / K + if n % K = 0 then 0 else 1

theorem padded_length (K n : Nat) (hK : 0 < K) :
    n + tailPadding K n = groupCount K n * K := by
  have hdiv := Nat.div_add_mod n K
  have hmod := Nat.mod_lt n hK
  unfold tailPadding groupCount
  split <;> simp only [Nat.add_mul, Nat.one_mul, Nat.add_zero]
  all_goals rw [Nat.mul_comm (n / K) K]; omega

theorem tailPadding_lt (K n : Nat) (hK : 0 < K) : tailPadding K n < K := by
  have hmod := Nat.mod_lt n hK
  unfold tailPadding
  split <;> omega

def padFp16Pairs (K : Nat) (xs : List (F16 × F16)) : List (F16 × F16) :=
  xs ++ List.replicate (tailPadding K xs.length) (0, 0)

/-- Group an arbitrary FP16 pair list in order, adding fewer than K zero pairs
only at the end. These zero operands are distinct from fractional alignment bits. -/
def canonicalPartition (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) : OrderedPartition (fp16Fp32Profile K extra floor) (padFp16Pairs K xs) :=
  partitionExact (fp16Fp32Profile K extra floor) (groupCount K xs.length) (padFp16Pairs K xs)
    (by simpa [padFp16Pairs, fp16Fp32Profile] using padded_length K xs.length hK)

theorem canonicalPartition_count (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) :
    (canonicalPartition K extra floor hK xs).groups.length = groupCount K xs.length :=
  partitionExact_count _ _ _ _

private theorem ideal_zero_pairs (K extra : Nat) (floor : Option Int) (n : Nat) :
    idealProducts (fp16Fp32Profile K extra floor) (List.replicate n (0, 0)) = some 0 := by
  have hz : (fp16Fp32Profile K extra floor).decode (BitVec.ofNat _ 0) = some ⟨0, 0, 0⟩ := by
    change decode16 0 = some ⟨0, 0, 0⟩
    decide +kernel
  have hprep : prepareProducts (fp16Fp32Profile K extra floor) (List.replicate n (0, 0)) =
      some (List.replicate n (Decoded.mk 0 0 0, Decoded.mk 0 0 0)) := by
    induction n with
    | zero => rfl
    | succ n ih =>
      simp [prepareProducts] at ih
      simp [prepareProducts, List.replicate_succ, List.mapM_cons, hz, ih]
  simp only [idealProducts, hprep, Option.map_some]
  congr 1
  clear hprep
  induction n with
  | zero => rfl
  | succ n ih =>
    simp [Decoded.value] at ih
    simp [List.replicate_succ, sumQ, ih, Decoded.value]
    grind

theorem idealProducts_padFp16Pairs (K extra : Nat) (floor : Option Int) (xs : List (F16 × F16)) :
    idealProducts (fp16Fp32Profile K extra floor) (padFp16Pairs K xs) =
      idealProducts (fp16Fp32Profile K extra floor) xs := by
  rw [padFp16Pairs, idealProducts_append, ideal_zero_pairs]
  cases h : idealProducts (fp16Fp32Profile K extra floor) xs <;> simp <;> grind

theorem canonicalPartition_ideal (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) :
    idealContributions (fp16Fp32Profile K extra floor) (canonicalPartition K extra floor hK xs).inputs =
      idealProducts (fp16Fp32Profile K extra floor) xs := by
  rw [OrderedPartition.ideal, idealProducts_padFp16Pairs]

def runCanonicalDot (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) : Except ModelError (List BlockTrace) :=
  (canonicalPartition K extra floor hK xs).run c

theorem runCanonicalDot_count (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) (ts : List BlockTrace)
    (h : runCanonicalDot K extra floor hK xs c = .ok ts) :
    ts.length = groupCount K xs.length := by
  have hl := runBlocks_length (fp16Fp32Profile K extra floor) c
    (canonicalPartition K extra floor hK xs).inputs ts h
  simpa [OrderedPartition.inputs, canonicalPartition_count] using hl

/-- The constructed schedule's error is relative to the unpadded original operands.
Zero padding changes shape but contributes no mathematical products. -/
theorem runCanonicalDot_uncorrected_error (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) (initial : Finite32) (ts : List BlockTrace) (products : Rat)
    (h : runCanonicalDot K extra floor hK xs initial.bits = .ok ts)
    (hi : idealProducts (fp16Fp32Profile K extra floor) xs = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) :=
  (runBlocks_uncorrected_error (fp16Fp32Profile K extra floor) initial
    (canonicalPartition K extra floor hK xs).inputs ts products h
    (by rw [canonicalPartition_ideal, hi])).1

theorem runCanonicalDot_uncorrected_error_strict (K extra : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) (hxs : xs ≠ []) (initial : Finite32) (ts : List BlockTrace)
    (products : Rat) (h : runCanonicalDot K extra floor hK xs initial.bits = .ok ts)
    (hi : idealProducts (fp16Fp32Profile K extra floor) xs = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) <
      sumQ (ts.map BlockTrace.errorBudget) := by
  have hb := (runBlocks_uncorrected_error (fp16Fp32Profile K extra floor) initial
    (canonicalPartition K extra floor hK xs).inputs ts products h
    (by rw [canonicalPartition_ideal, hi])).2
  apply hb
  intro hempty
  have hlen := congrArg List.length hempty
  simp only [OrderedPartition.inputs, List.length_map, List.length_nil,
    canonicalPartition_count] at hlen
  have hpad := padded_length K xs.length hK
  have hx : xs.length ≠ 0 := by intro hz; exact hxs (List.length_eq_zero_iff.mp hz)
  rw [hlen] at hpad
  simp only [Nat.zero_mul] at hpad
  omega

theorem runCanonicalDot_machine_eq (K extra carryBits w : Nat) (floor : Option Int) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) (hc : K + 1 ≤ 2 ^ carryBits)
    (hw : 26 + extra + carryBits ≤ w) :
    runBlocksMachine w (fp16Fp32Profile K extra floor) c
      (canonicalPartition K extra floor hK xs).inputs = runCanonicalDot K extra floor hK xs c :=
  fp16Fp32_schedule_machine_eq K extra carryBits w floor hc hw c
    (canonicalPartition K extra floor hK xs).inputs

end TensorCore
