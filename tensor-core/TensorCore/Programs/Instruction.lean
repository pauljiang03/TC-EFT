import TensorCore.Theory.RoundTrip
import TensorCore.Theory.CanonicalFloor
import TensorCore.Programs.DotProduct
import TensorCore.Programs.ErrorBounds
import TensorCore.Programs.Loops

/-! Instruction paths. An instruction with inner dimension `k` is modeled as an ordered
partition of its `k` operand pairs into groups of `N_FMA` products, executed in increasing k
with each group's encoded FP32 output feeding the next group (the MATLAB v0.5 `GEMM.m` rule).
Hardware conformance is an explicit premise, `Conforms`, never an unproved assumption. -/

namespace TensorCore

/-- `m` consecutive groups of `n` elements. -/
def chunks (n : Nat) : Nat → List α → List (List α)
  | 0, _ => []
  | m + 1, xs => xs.take n :: chunks n m (xs.drop n)

theorem chunks_flatten (n m : Nat) (xs : List α) (h : xs.length = m * n) :
    (chunks n m xs).flatten = xs := by
  induction m generalizing xs with
  | zero =>
    have hx : xs = [] := List.length_eq_zero_iff.mp (by simpa using h)
    subst hx
    rfl
  | succ m ih =>
    simp only [chunks, List.flatten_cons]
    rw [Nat.succ_mul] at h
    rw [ih (xs.drop n) (by simp only [List.length_drop]; omega)]
    exact List.take_append_drop n xs

theorem chunks_first_group (n m : Nat) (g rest : List α) (hg : g.length = n) :
    chunks n (m + 1) (g ++ rest) = g :: chunks n m rest := by
  simp only [chunks]
  rw [← hg, List.take_left, List.drop_left]

theorem chunks_replicate (n m : Nat) (a : α) :
    chunks n m (List.replicate (m * n) a) = List.replicate m (List.replicate n a) := by
  induction m with
  | zero => rfl
  | succ m ih =>
    simp only [chunks, List.take_replicate, List.drop_replicate, List.replicate_succ]
    rw [Nat.succ_mul]
    have h1 : min n (m * n + n) = n := by omega
    have h2 : m * n + n - n = m * n := by omega
    rw [h1, h2, ih]

theorem lastOutput_bits (initial : Finite32) (ts : List BlockTrace) :
    ((ts.getLast?.map fun t => t.output.bits).getD initial.bits) =
      (lastOutput initial ts).bits := by
  induction ts generalizing initial with
  | nil => rfl
  | cons t ts ih =>
    cases ts with
    | nil => rfl
    | cons u us => exact ih t.output

theorem getD_of_cons (f : α → β) (u : α) (us : List α) (d₁ d₂ : β) :
    (((u :: us).getLast?).map f).getD d₁ = (((u :: us).getLast?).map f).getD d₂ := by
  induction us generalizing u with
  | nil => rfl
  | cons v vs ih =>
    simp only [List.getLast?_cons_cons]
    exact ih v

theorem finite32_self (f : Finite32) : finite32 f.bits = some f := by
  unfold finite32
  split
  · rename_i h; rw [f.valid] at h; contradiction
  · rename_i d h; rw [f.valid] at h; cases Option.some.inj h; rfl

/-- The bits of a finite encoding of value zero, other than `−0`, are `0`. -/
theorem zero_value_bits (c : F32) (d : Decoded) (hd : decode32 c = some d)
    (hz : d.significand = 0) (hneg : c ≠ 0x80000000) : c = 0 := by
  have hlt := c.isLt
  rcases decode32_fields c d hd with ⟨hE, hm, rfl⟩ | ⟨_, hm, rfl⟩ | ⟨_, _, rfl⟩
  · apply BitVec.eq_of_toNat_eq
    have hq : c.toNat / 2147483648 = 0 ∨ c.toNat / 2147483648 = 1 := by omega
    rcases hq with hq | hq
    · show c.toNat = 0
      omega
    · exfalso
      apply hneg
      apply BitVec.eq_of_toNat_eq
      show c.toNat = 2147483648
      omega
  · exfalso
    try dsimp only at hz
    split at hz <;> omega
  · exfalso
    try dsimp only at hz
    split at hz <;> omega

theorem Decoded.value_ne_zero (d : Decoded) (h : d.significand ≠ 0) : d.value ≠ 0 := by
  intro h0
  unfold Decoded.value at h0
  have hq := pow2_pos (d.rawScale - d.fractionalBits)
  have hne := Rat.ne_of_gt hq
  have h1 : (d.significand : Rat) = ((0 : Int) : Rat) := by
    rw [Rat.intCast_zero]
    calc (d.significand : Rat) = (d.significand : Rat) * pow2 (d.rawScale - d.fractionalBits) /
          pow2 (d.rawScale - d.fractionalBits) := (Rat.mul_div_cancel hne).symm
      _ = 0 / pow2 (d.rawScale - d.fractionalBits) := by rw [h0]
      _ = 0 := by rw [Rat.div_def, Rat.zero_mul]
  exact h (Rat.intCast_inj.mp h1)

/-- With only zero products, the alignment exponent is the accumulator input's raw scale,
whenever the floor is at most `−126`. -/
theorem zero_products_eta (K extra : Nat) (floor : Option Int) (hfl : ∀ f ∈ floor, f ≤ -126)
    (c : Decoded) (hc : c.significand ≠ 0) (hlow : -126 ≤ c.rawScale) :
    (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).eta = some c.rawScale := by
  have hterms : (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).terms =
      ⟨c.significand, c.rawScale, c.fractionalBits⟩ :: List.replicate K ⟨0, 0, 0⟩ := by
    simp [PreparedBlock.terms, List.map_replicate, rawMul]
  have hmem : (⟨c.significand, c.rawScale, c.fractionalBits⟩ : RawProduct) ∈
      (PreparedBlock.mk (fp16Fp32Profile K extra floor)
        (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).terms := by
    rw [hterms]; simp
  obtain ⟨e, he, hle⟩ := alignmentScale_term _ _ hmem hc
  have hle' : c.rawScale ≤ e := hle
  have hup := alignmentScale_upper (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).terms c.rawScale (by
        intro t ht hnz
        rw [hterms] at ht
        simp only [List.mem_cons, List.mem_replicate] at ht
        rcases ht with rfl | ⟨_, rfl⟩
        · exact Int.le_refl _
        · exact absurd rfl hnz) e (by rw [he]; simp)
  have heq : e = c.rawScale := by omega
  subst heq
  unfold PreparedBlock.eta
  rw [he]
  unfold Profile.applyFloor
  have hfloor : (fp16Fp32Profile K extra floor).alignFloor = floor := rfl
  simp only [hfloor]
  cases hf : floor with
  | none => rfl
  | some f =>
    have := hfl f (by rw [hf]; simp)
    simp [Int.max_eq_left (by omega : f ≤ c.rawScale)]

/-- A group whose products are all zero pairs returns its accumulator input unchanged, for
every finite input other than `−0`. Floors at or below `−126` are inactive on FP16 paths. -/
theorem zero_products_passthrough (K extra : Nat) (floor : Option Int)
    (hfl : ∀ f ∈ floor, f ≤ -126) (c : F32) (f : Finite32) (hf : finite32 c = some f)
    (hneg : c ≠ 0x80000000) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (0, 0), c⟩ : BlockInput (fp16Fp32Profile K extra floor)) =
        .ok t ∧ t.output.bits = c := by
  have hbits := finite32_bits hf
  have hc : decode32 c = some f.decoded := by rw [← hbits]; exact f.valid
  have hz : (fp16Fp32Profile K extra floor).decode 0 = some ⟨0, 0, 0⟩ := by
    show (classify fp16 0).finite = some _
    decide +kernel
  have hps := prepareProducts_replicate (fp16Fp32Profile K extra floor) 0 0 ⟨0, 0, 0⟩ ⟨0, 0, 0⟩
    K hz hz
  have hlen : ¬ ((List.replicate K ((0 : F16), (0 : F16))).length !=
      (fp16Fp32Profile K extra floor).products) = true := by simp [fp16Fp32Profile]
  have hcoef := construction_coefficients (fp16Fp32Profile K extra floor) K ⟨0, 0, 0⟩ ⟨0, 0, 0⟩
    f.decoded
  have hprod : ∀ q : Int, truncCoeff (rawMul ⟨0, 0, 0⟩ ⟨0, 0, 0⟩).value q = 0 := by
    intro q
    simp [rawMul, RawProduct.value, truncCoeff, Rat.div_def]
    all_goals decide +kernel
  have hacc : (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded).accumulator = f.value := by
    by_cases hsig : f.decoded.significand = 0
    · have hv : f.decoded.value = 0 := by simp [Decoded.value, hsig]
      have hcz : ∀ q : Int, truncCoeff f.decoded.value q = 0 := by
        intro q; rw [hv]; simp [truncCoeff, Rat.div_def]
        all_goals decide +kernel
      unfold PreparedBlock.accumulator
      rw [hcoef]
      simp only [sumZ, hcz, hprod, sumZ_replicate, Int.mul_zero, Int.add_zero]
      unfold Finite32.value
      rw [hv]
      simp
    · obtain ⟨hfrac, hlow⟩ : f.decoded.fractionalBits = 23 ∧ -126 ≤ f.decoded.rawScale := by
        rcases decode32_fields c f.decoded hc with ⟨_, _, h0⟩ | ⟨_, _, h0⟩ | ⟨hE1, _, h0⟩
        · rw [h0] at hsig; exact absurd rfl hsig
        · rw [h0]; exact ⟨rfl, Int.le_refl _⟩
        · rw [h0]; exact ⟨rfl, by simp; omega⟩
      have heta := zero_products_eta K extra floor hfl f.decoded hsig hlow
      have hq : (PreparedBlock.mk (fp16Fp32Profile K extra floor)
          (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded).quantumExponent =
          f.decoded.rawScale - ((23 + extra : Nat) : Int) := by
        unfold PreparedBlock.quantumExponent
        rw [heta]
        rfl
      rw [hq] at hcoef
      have hcval : f.decoded.value =
          ((f.decoded.significand * ((2 ^ extra : Nat) : Int) : Int) : Rat) *
            pow2 (f.decoded.rawScale - ((23 + extra : Nat) : Int)) := by
        unfold Decoded.value
        rw [hfrac, Rat.intCast_mul, Rat.intCast_natCast, ← pow2_natCast, Rat.mul_assoc, ← pow2_add]
        congr 2
        omega
      have hcc : truncCoeff f.decoded.value (f.decoded.rawScale - ((23 + extra : Nat) : Int)) =
          f.decoded.significand * ((2 ^ extra : Nat) : Int) := by
        rw [hcval, truncCoeff_of_grid]
      unfold PreparedBlock.accumulator
      rw [hcoef, hq]
      simp only [sumZ, hcc, hprod, sumZ_replicate, Int.mul_zero, Int.add_zero]
      rw [← hcval]
      rfl
  have hrun : evalPrepared (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded) =
      .ok ⟨PreparedBlock.mk (fp16Fp32Profile K extra floor)
        (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded, f⟩ := by
    by_cases hsig : f.decoded.significand = 0
    · have hc0 : c = 0 := zero_value_bits c f.decoded hc hsig hneg
      have hv : f.value = 0 := by simp [Finite32.value, Decoded.value, hsig]
      have hr : round32 .towardZero 0 = some (0 : F32) := by decide +kernel
      have hf0 : finite32 (0 : F32) = some f := by rw [← hc0]; exact hf
      simp only [evalPrepared, hacc, hv, hr, hf0]
    · have hv : f.value ≠ 0 := Decoded.value_ne_zero f.decoded hsig
      have hval32 : value32 c = some f.value := by
        unfold value32; rw [hc]; rfl
      have hr := value32_round32 .towardZero c f.value hval32 hv
      simp only [evalPrepared, hacc, hr, hf]
  refine ⟨⟨PreparedBlock.mk (fp16Fp32Profile K extra floor)
    (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded, f⟩, ?_, hbits⟩
  unfold evalBlock
  rw [if_neg hlen]
  simp only [prepare, hc, hps]
  exact hrun

/-- Zero groups pass a finite accumulator, other than `−0`, through unchanged. -/
theorem runBlocks_zero_groups (K extra : Nat) (floor : Option Int)
    (hfl : ∀ f ∈ floor, f ≤ -126) (m : Nat) (c : F32) (f : Finite32) (hf : finite32 c = some f)
    (hneg : c ≠ 0x80000000) :
    ∃ ts : List BlockTrace,
      runBlocks (fp16Fp32Profile K extra floor) c
        (List.replicate m (List.replicate K (0, 0))) = .ok ts ∧
      ((ts.getLast?.map fun t => t.output.bits).getD c) = c := by
  induction m generalizing c f with
  | zero => exact ⟨[], rfl, rfl⟩
  | succ m ih =>
    obtain ⟨t, ht, hbits⟩ := zero_products_passthrough K extra floor hfl c f hf hneg
    have hf' : finite32 t.output.bits = some t.output := finite32_self t.output
    obtain ⟨ts, hts, hlast⟩ := ih t.output.bits t.output hf' (by rw [hbits]; exact hneg)
    refine ⟨t :: ts, ?_, ?_⟩
    · simp only [List.replicate_succ, runBlocks, ht, hts]
    · cases ts with
      | nil => simpa using hbits
      | cons u us =>
        simp only [List.getLast?_cons_cons] at hlast ⊢
        rw [hbits] at hlast
        exact hlast

/-- A pinned instruction path: inner dimension `k`, products per group, extra alignment bits,
floor, and the source of these parameters. The grouping is contiguous in increasing k. -/
structure InstructionPath where
  name : String
  k : Nat
  products : Nat
  extraBits : Nat
  floor : Option Int
  evidence : String
  productsPos : 0 < products
  kDiv : products ∣ k

abbrev InstructionPath.profile (p : InstructionPath) : Profile :=
  fp16Fp32Profile p.products p.extraBits p.floor

def InstructionPath.groups (p : InstructionPath) : Nat := p.k / p.products

/-- The schedule of one instruction: `k / N_FMA` contiguous groups in increasing k. -/
def InstructionPath.schedule (p : InstructionPath) (pairs : List (F16 × F16)) :
    List (List (p.profile.Word × p.profile.Word)) :=
  chunks p.products p.groups pairs

/-- Execute the instruction. Inputs that are not exactly `k` pairs are rejected; nothing is
padded or discarded. -/
def InstructionPath.run (p : InstructionPath) (c : F32) (pairs : List (F16 × F16)) :
    Except ModelError (List BlockTrace) :=
  if pairs.length != p.k then .error .wrongProductCount
  else runBlocks p.profile c (p.schedule pairs)

/-- The instruction's FP32 result: the last group's output, or the accumulator input when
there are no groups. `none` when a group is rejected by the finite model. -/
def InstructionPath.output (p : InstructionPath) (c : F32) (pairs : List (F16 × F16)) :
    Option F32 :=
  match p.run c pairs with
  | .ok ts => some ((ts.getLast?.map fun t => t.output.bits).getD c)
  | .error _ => none

def InstructionPath.describe (p : InstructionPath) : String :=
  s!"{p.name}: k = {p.k}, N_FMA = {p.products}, extra alignment bits = {p.extraBits}, " ++
  s!"floor = {repr p.floor}, groups per instruction = {p.groups}; evidence: {p.evidence}"

theorem InstructionPath.schedule_flatten (p : InstructionPath) (pairs : List (F16 × F16))
    (h : pairs.length = p.k) : (p.schedule pairs).flatten = pairs := by
  apply chunks_flatten
  rw [h]
  exact (Nat.div_mul_cancel p.kDiv).symm

/-- Conformance of a device function to the modeled path on the model's accepted domain:
whenever the model produces an output, the device produces the same bits. Inputs the finite
model rejects (wrong width, nonfinite operands, out-of-range accumulators) are outside the
modeled domain and leave the device unconstrained. This is the hardware premise; no theorem
below asserts it for any device. -/
def Conforms (p : InstructionPath) (device : F32 → List (F16 × F16) → Option F32) : Prop :=
  ∀ c pairs out, p.output c pairs = some out → device c pairs = some out

theorem InstructionPath.run_length (p : InstructionPath) (c : F32) (pairs : List (F16 × F16))
    (ts : List BlockTrace) (h : p.run c pairs = .ok ts) : pairs.length = p.k := by
  unfold InstructionPath.run at h
  split at h
  · contradiction
  · rename_i hne
    simpa using hne

theorem InstructionPath.run_blocks (p : InstructionPath) (c : F32) (pairs : List (F16 × F16))
    (ts : List BlockTrace) (h : p.run c pairs = .ok ts) :
    runBlocks p.profile c (p.schedule pairs) = .ok ts := by
  unfold InstructionPath.run at h
  split at h
  · contradiction
  · exact h

/-- Under conformance, a device result is the model's last group output and satisfies the
composed uncorrected error bound against the original-input ideal. -/
theorem conforms_uncorrected_error (p : InstructionPath)
    (device : F32 → List (F16 × F16) → Option F32) (h : Conforms p device) (initial : Finite32)
    (pairs : List (F16 × F16)) (ts : List BlockTrace)
    (hrun : p.run initial.bits pairs = .ok ts) (products : Rat)
    (hi : idealProducts p.profile pairs = some products) :
    device initial.bits pairs = some (lastOutput initial ts).bits ∧
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) := by
  have hlen := p.run_length _ _ _ hrun
  have hblocks := p.run_blocks _ _ _ hrun
  constructor
  · apply h
    unfold InstructionPath.output
    rw [hrun]
    show some ((ts.getLast?.map fun t => t.output.bits).getD initial.bits) = _
    rw [lastOutput_bits]
  · have hi' : idealContributions p.profile (p.schedule pairs) = some products := by
      rw [idealContributions_flatten, p.schedule_flatten pairs hlen, hi]
    exact (runBlocks_uncorrected_error p.profile initial (p.schedule pairs) ts products hblocks
      hi').1

/-- A `k`-wide input whose products beyond the first group are zero pairs returns the first
group's output: every later group passes the accumulator through. Published single-group
vectors therefore test the instruction path under the increasing-k rule. -/
theorem single_group_output (p : InstructionPath) (hfl : ∀ f ∈ p.floor, f ≤ -126)
    (hk : p.products ≤ p.k) (c : F32) (g : List (F16 × F16)) (hg : g.length = p.products)
    (t : BlockTrace) (h1 : evalBlock (⟨g, c⟩ : BlockInput p.profile) = .ok t)
    (hneg : t.output.bits ≠ 0x80000000) :
    p.output c (g ++ List.replicate (p.k - p.products) (0, 0)) = some t.output.bits := by
  have hgroups : p.groups = (p.groups - 1) + 1 := by
    have : 1 ≤ p.groups := by
      unfold InstructionPath.groups
      exact (Nat.le_div_iff_mul_le p.productsPos).mpr (by omega)
    omega
  have hrest : p.k - p.products = (p.groups - 1) * p.products := by
    have hkm := Nat.div_mul_cancel p.kDiv
    unfold InstructionPath.groups at hgroups ⊢
    have : p.k = (p.k / p.products - 1 + 1) * p.products := by rw [← hgroups]; exact hkm.symm
    rw [Nat.succ_mul] at this
    omega
  have hsched : p.schedule (g ++ List.replicate (p.k - p.products) (0, 0)) =
      g :: List.replicate (p.groups - 1) (List.replicate p.products (0, 0)) := by
    unfold InstructionPath.schedule
    rw [hgroups, chunks_first_group _ _ _ _ hg, hrest, chunks_replicate]
    simp only [Nat.add_sub_cancel]
  obtain ⟨ts, hts, hlast⟩ := runBlocks_zero_groups p.products p.extraBits p.floor hfl
    (p.groups - 1) t.output.bits t.output (finite32_self t.output) hneg
  have hlenpad : (g ++ List.replicate (p.k - p.products) (0, 0)).length = p.k := by
    simp only [List.length_append, List.length_replicate, hg]
    omega
  unfold InstructionPath.output InstructionPath.run
  rw [if_neg (by rw [hlenpad]; simp), hsched]
  simp only [runBlocks, h1, hts]
  cases ts with
  | nil => rfl
  | cons u us =>
    simp only [List.getLast?_cons_cons]
    rw [getD_of_cons _ u us c t.output.bits, hlast]

/-- V100: WMMA m16n16k16 FP16 → FP32 lowers to HMMA.844; four groups of four products. -/
def v100Wmma16 : InstructionPath :=
  ⟨"V100 WMMA m16n16k16 FP16->FP32 (HMMA.844)", 16, 4, 0, none,
    "Accurate Models v4 §4.1.1 and Tables 3-4; MATLAB v0.5 GEMM.m increasing-k rule; " ++
    "Jia et al. arXiv:1804.06826 (four sets of four HMMA.884 steps)", by decide, by decide⟩

/-- A100/A2/A30/L40S/Ada: WMMA m16n16k16 FP16 → FP32 lowers to HMMA.1688; two groups of
eight, validated by the paper on k = 16 inputs. -/
def ampereWmma16 : InstructionPath :=
  ⟨"Ampere/Ada WMMA m16n16k16 FP16->FP32 (HMMA.1688)", 16, 8, 1, some (-132),
    "Accurate Models v4 §4.1.2, §4.2 (k = 16 with N_FMA = 8, 10^7-vector validation), Tables 3-4",
    by decide, by decide⟩

/-- H100/H200/B200: WMMA m16n16k16 FP16 → FP32 lowers to HMMA.16816; one group of sixteen. -/
def hopperWmma16 : InstructionPath :=
  ⟨"Hopper/Blackwell WMMA m16n16k16 FP16->FP32 (HMMA.16816)", 16, 16, 2, some (-133),
    "Accurate Models v4 §4.1.6 and Tables 3-4", by decide, by decide⟩

end TensorCore
