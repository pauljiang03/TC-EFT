import TensorCore.Programs.Gemm
import TensorCore.Theory.ProgramBounds.Scales

/-! Input-derived GEMM acceptance and error certificates. The checker decodes
operands and checks scales, counts, and accumulator headroom. It never executes
the tensor-core model or computes exact dot products or ideal prefixes. -/

namespace TensorCore

private theorem runBlocks_split (p : Profile) (initial : Finite32)
    (xs ys : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p initial.bits (xs ++ ys) = .ok ts) :
    ∃ us vs, runBlocks p initial.bits xs = .ok us ∧
      runBlocks p (lastOutput initial us).bits ys = .ok vs ∧ ts = us ++ vs := by
  induction xs generalizing initial ts with
  | nil => exact ⟨[], ts, rfl, h, rfl⟩
  | cons g xs ih =>
    cases hg : evalBlock (⟨g, initial.bits⟩ : BlockInput p) with
    | error e => simp [runBlocks, hg] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits (xs ++ ys) with
      | error e => simp [runBlocks, hg, hr] at h
      | ok rest =>
        obtain ⟨us, vs, hu, hv, he⟩ := ih t.output rest hr
        refine ⟨t :: us, vs, ?_, hv, ?_⟩
        · simp [runBlocks, hg, hu]
        · simpa [runBlocks, hg, hr, he] using h.symm

/-- Acceptance of the flattened arithmetic schedule implies acceptance of the
instruction chain, with the same encoded boundaries. -/
theorem runGemmInstructions_complete (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (ts : List BlockTrace)
    (hs : ∀ g ∈ inputs, g.length = p.k)
    (h : runBlocks p.profile initial.bits (inputs.flatMap p.schedule) = .ok ts) :
    ∃ traces, runGemmInstructions p initial inputs = .ok traces ∧ traces.flatten = ts := by
  induction inputs generalizing initial ts with
  | nil =>
    simp [runBlocks] at h
    subst ts
    exact ⟨[], rfl, rfl⟩
  | cons g rest ih =>
    obtain ⟨us, vs, hu, hv, he⟩ := runBlocks_split p.profile initial _ _ ts h
    have hp : p.run initial.bits g = .ok us := by
      simp [InstructionPath.run, hs g (by simp), hu]
    obtain ⟨tail, ht, hf⟩ := ih (lastOutput initial us) vs
      (fun g hg => hs g (by simp [hg])) hv
    refine ⟨us :: tail, ?_, ?_⟩
    · simp [runGemmInstructions, hp, ht]
    · simp [hf, he]

private theorem chunks_shape (n count : Nat) (xs : List α)
    (hx : xs.length = count * n) :
    (chunks n count xs).length = count ∧ ∀ g ∈ chunks n count xs, g.length = n := by
  induction count generalizing xs with
  | zero => simp [chunks]
  | succ count ih =>
    have hd : (xs.drop n).length = count * n := by
      simp only [List.length_drop]
      rw [Nat.succ_mul] at hx
      omega
    obtain ⟨hl, hs⟩ := ih (xs.drop n) hd
    constructor
    · simp [chunks, hl]
    · intro g hg
      simp only [chunks, List.mem_cons] at hg
      rcases hg with rfl | hg
      · simp only [List.length_take]
        rw [Nat.succ_mul] at hx
        omega
      · exact hs g hg

def gemmBlocks (model : WmmaGemmModel) (pairs : List (F16 × F16)) :=
  (gemmInstructions pairs).flatMap model.path.schedule

def gemmBlockCount (model : WmmaGemmModel) (k : Nat) : Nat :=
  groupCount 16 k * model.path.groups

theorem gemmBlocks_shape (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    ∀ g ∈ gemmBlocks model pairs, g.length = model.path.products := by
  intro g hg
  obtain ⟨instruction, hi, hg⟩ := List.mem_flatMap.mp hg
  apply (chunks_shape model.path.products model.path.groups instruction ?_).2 g hg
  rw [gemmInstructions_shape pairs instruction hi]
  exact (WmmaGemmModel.k model).symm.trans (Nat.div_mul_cancel model.path.kDiv).symm

theorem gemmBlocks_count (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    (gemmBlocks model pairs).length = gemmBlockCount model pairs.length := by
  have hc : ∀ instruction ∈ gemmInstructions pairs,
      (model.path.schedule instruction).length = model.path.groups := by
    intro instruction hi
    apply (chunks_shape model.path.products model.path.groups instruction ?_).1
    rw [gemmInstructions_shape pairs instruction hi]
    exact (WmmaGemmModel.k model).symm.trans (Nat.div_mul_cancel model.path.kDiv).symm
  have count : ∀ xs : List (List (F16 × F16)),
      (∀ x ∈ xs, (model.path.schedule x).length = model.path.groups) →
      (xs.flatMap model.path.schedule).length = xs.length * model.path.groups := by
    intro xs h
    induction xs with
    | nil => simp
    | cons x xs ih =>
      simp only [List.flatMap_cons, List.length_append, List.length_cons]
      rw [h x (by simp), ih (fun y hy => h y (by simp [hy])), Nat.succ_mul]
      omega
  rw [gemmBlocks, count _ hc]
  congr 1
  simpa [gemmInstructions, OrderedPartition.inputs] using
    canonicalPartition_count 16 0 none (by decide) pairs

theorem gemmBlocks_ideal (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    idealContributions model.path.profile (gemmBlocks model pairs) =
      idealProducts v100F16F32 pairs := by
  have hf : (gemmBlocks model pairs).flatten = (gemmInstructions pairs).flatten := by
    have aux : ∀ xs : List (List (F16 × F16)),
        (∀ g ∈ xs, g.length = model.path.k) →
        (xs.flatMap model.path.schedule).flatten = xs.flatten := by
      intro xs hs
      induction xs with
      | nil => rfl
      | cons g xs ih =>
        simp only [List.flatMap_cons, List.flatten_append, List.flatten_cons]
        rw [model.path.schedule_flatten g (hs g (by simp)),
          ih (fun x hx => hs x (by simp [hx]))]
    exact aux _ (fun g hg =>
      (gemmInstructions_shape pairs g hg).trans (WmmaGemmModel.k model).symm)
  rw [idealContributions_flatten, hf, gemmInstructions_flatten]
  change idealProducts (fp16Fp32Profile 16 0 none) (padFp16Pairs 16 pairs) =
    idealProducts (fp16Fp32Profile 16 0 none) pairs
  exact idealProducts_padFp16Pairs 16 0 none pairs

/-- E bounds the changing accumulator scale; P bounds raw product scales.
L supplies carry headroom, and initialBound bounds every initial accumulator. -/
structure GemmBoundConfig where
  accumulatorScale : Int
  productScale : Int
  carryBits : Nat
  initialBound : Rat
  deriving Repr, DecidableEq

def gemmStaticError (model : WmmaGemmModel) (cfg : GemmBoundConfig) (k : Nat) : Rat :=
  (gemmBlockCount model k : Rat) * staticBudget (model.path.products + 1)
    model.path.profile.alignFraction cfg.accumulatorScale cfg.carryBits

def gemmCellCheck (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (pairs : List (F16 × F16)) (c : F32) : Bool :=
  let p := model.path.profile
  let E := cfg.accumulatorScale
  let P := cfg.productScale
  let L := cfg.carryBits
  decide (-126 ≤ E ∧ P ≤ E ∧ (∀ f ∈ p.alignFloor, f ≤ E) ∧
    p.products + 1 ≤ 2 ^ L ∧ E + 2 + L ≤ 127) &&
  (gemmBlocks model pairs).all (groupScaleCheck p P) &&
  match value32 c with
  | none => false
  | some cv => decide (absQ cv ≤ cfg.initialBound ∧
      cfg.initialBound + (gemmBlockCount model pairs.length : Rat) *
        ((p.products : Rat) * (4 * pow2 P) +
          staticBudget (p.products + 1) p.alignFraction E L) < pow2 (E + 1))

theorem gemmCellCheck_sound (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (pairs : List (F16 × F16)) (c : F32) (h : gemmCellCheck model cfg pairs c = true) :
    ∃ cell products, simulateGemmCell model pairs c = .ok cell ∧
      idealProducts v100F16F32 pairs = some products ∧
      value32 c = some cell.initial.value ∧
      absQ (cell.initial.value + products - cell.output.value) ≤
        gemmStaticError model cfg pairs.length := by
  simp only [gemmCellCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨hE, hPE, hfl, hL, hrange⟩, hs⟩, hc⟩ := h
  cases hv : value32 c with
  | none => simp [hv] at hc
  | some cv =>
    simp only [hv, decide_eq_true_eq] at hc
    obtain ⟨initial, hi, hb, hval⟩ := finite32_of_value32 c cv hv
    obtain ⟨ts, products, hr, hp, he⟩ := runBlocks_of_scale_bound
      model.path.profile cfg.accumulatorScale cfg.productScale cfg.carryBits
      hE hPE hfl hL hrange (gemmBlocks model pairs) (gemmBlocks_shape model pairs)
      (fun g hg => groupScaleCheck_sound _ _ _ (List.all_eq_true.mp hs g hg))
      initial cfg.initialBound (by simpa [hval] using hc.1)
      (by simpa [gemmBlocks_count] using hc.2)
    obtain ⟨traces, ht, hf⟩ := runGemmInstructions_complete model.path initial
      (gemmInstructions pairs) ts
      (fun g hg => (gemmInstructions_shape pairs g hg).trans (WmmaGemmModel.k model).symm) hr
    refine ⟨⟨initial, traces⟩, products, ?_, ?_, ?_, ?_⟩
    · simp [simulateGemmCell, hi, ht]
    · rwa [gemmBlocks_ideal] at hp
    · simp [hval]
    · rw [gemmBlocks_count] at he
      simpa [GemmCell.output, GemmCell.blocks, hf, gemmStaticError,
        InstructionPath.profile, fp16Fp32Profile] using he

/-- All checks depend only on original operands, dimensions, and the supplied bounds. -/
def gemmCheck (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Bool :=
  decide (∀ i : Fin m, ∀ j : Fin n,
    gemmCellCheck model cfg (gemmPairs A B i j) C[i.val][j.val] = true)

/-- A successful certificate guarantees every logical output exists and meets a
uniform error bound. Neither model acceptance nor a trace is a premise. -/
theorem gemmCheck_sound (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : gemmCheck model cfg A B C = true) (i : Fin m) (j : Fin n) :
    ∃ cell z, (gemm model A B C)[i.val][j.val] = .ok cell ∧
      (gemmIdeal A B C)[i.val][j.val] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError model cfg k := by
  have hc := of_decide_eq_true h i j
  obtain ⟨cell, products, hr, hp, hv, he⟩ := gemmCellCheck_sound model cfg _ _ hc
  refine ⟨cell, cell.initial.value + products, ?_, ?_, ?_⟩
  · rwa [gemm_entry]
  · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]
  · simpa using he

/-- Sum of absolute entries, the entrywise 1-norm (not the induced column norm). -/
def matrixAbsSum (A : DenseMatrix Rat m n) : Rat :=
  sumQ (List.ofFn fun i : Fin m => sumQ (List.ofFn fun j : Fin n => absQ A[i.val][j.val]))

theorem matrixAbsSum_bound (A : DenseMatrix Rat m n) (E : Rat)
    (h : ∀ i : Fin m, ∀ j : Fin n, absQ A[i.val][j.val] ≤ E) :
    matrixAbsSum A ≤ (m : Rat) * (n : Rat) * E := by
  have row : ∀ i : Fin m, sumQ (List.ofFn fun j : Fin n => absQ A[i.val][j.val]) ≤ (n : Rat) * E := by
    intro i
    have hb := sumQ_map_le (List.finRange n) (fun j => absQ A[i.val][j.val]) E
      (fun j _ => h i j)
    simpa [List.finRange, List.map_ofFn, Function.comp_def] using hb
  have hb := sumQ_map_le (List.finRange m)
    (fun i => sumQ (List.ofFn fun j : Fin n => absQ A[i.val][j.val])) ((n : Rat) * E)
    (fun i _ => row i)
  simpa [matrixAbsSum, List.finRange, List.map_ofFn, Function.comp_def, Rat.mul_assoc] using hb

/-- Any matrix of the actual output values differs from the exact original-input
ideal by at most m*n times the input-derived entry bound in entrywise 1-norm. -/
theorem gemmCheck_matrix_error (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : gemmCheck model cfg A B C = true) (D Z : DenseMatrix Rat m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : Rat) * (n : Rat) * gemmStaticError model cfg k := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound model cfg A B C h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he

end TensorCore
