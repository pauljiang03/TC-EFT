import TensorCore.Gemm.Matrix
import TensorCore.TC.Instruction
import TensorCore.TC.Program.Partition
import Init.Data.Vector.OfFn

/-! Executable FP16 × FP16 → FP32 matrix multiply-accumulate, A*B+C.

The instruction interface is PTX `wmma.mma.sync.aligned.row.col.m16n16k16.f32.f32`.
PTX supplies the logical tile shape; the existing Accurate Models instruction paths
supply its numerical behavior. Each output cell executes increasing-k instructions,
padding the last k tile to 16 pairs. Output tiles are independent 16×16 tiles.
This is matrix-level instruction semantics, without lane/register allocation, memory
transactions, or a claim about a compiled CUDA kernel. No correction is applied.
-/

namespace TensorCore

/-- Select a sourced FP16 WMMA m16n16k16 arithmetic path. -/
inductive WmmaGemmModel where
  | v100 | ampere | hopper
  deriving Repr, DecidableEq

def WmmaGemmModel.path : WmmaGemmModel → InstructionPath
  | .v100 => v100Wmma16
  | .ampere => ampereWmma16
  | .hopper => hopperWmma16

@[simp] theorem WmmaGemmModel.k (model : WmmaGemmModel) : model.path.k = 16 := by
  cases model <;> rfl

/-- The original ordered operands for output (i,j), without padding or decoding. -/
def gemmPairs (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (i : Fin m) (j : Fin n) : List (F16 × F16) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])

@[simp] theorem gemmPairs_length (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (i : Fin m) (j : Fin n) : (gemmPairs A B i j).length = k := by simp [gemmPairs]

/-- Each original k index selects exactly its intended row/column operands. -/
theorem gemmPairs_get (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (i : Fin m) (j : Fin n) (l : Fin k) :
    (gemmPairs A B i j)[l.val]'(by simp) = (A[i.val][l.val], B[l.val][j.val]) := by
  simp [gemmPairs]

/-- One full k=16 operand slice per WMMA instruction, including zero tail pairs. -/
def gemmInstructions (pairs : List (F16 × F16)) : List (List (F16 × F16)) :=
  (canonicalPartition 16 0 none (by decide) pairs).inputs

theorem gemmInstructions_flatten (pairs : List (F16 × F16)) :
    (gemmInstructions pairs).flatten = padFp16Pairs 16 pairs :=
  (canonicalPartition 16 0 none (by decide) pairs).covers

theorem gemmInstructions_shape (pairs : List (F16 × F16))
    (instruction : List (F16 × F16)) (h : instruction ∈ gemmInstructions pairs) :
    instruction.length = 16 := by
  obtain ⟨group, _, rfl⟩ := List.mem_map.mp h
  exact group.shape

/-- Execute one output cell's instruction chain; every boundary carries encoded FP32. -/
def runGemmInstructions (p : InstructionPath) :
    Finite32 → List (List (F16 × F16)) → Except ModelError (List (List BlockTrace))
  | _, [] => .ok []
  | initial, pairs :: rest =>
    match p.run initial.bits pairs with
    | .error e => .error e
    | .ok ts => match runGemmInstructions p (lastOutput initial ts) rest with
      | .error e => .error e
      | .ok tail => .ok (ts :: tail)

theorem runGemmInstructions_blocks (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (traces : List (List BlockTrace))
    (h : runGemmInstructions p initial inputs = .ok traces) :
    runBlocks p.profile initial.bits (inputs.flatMap p.schedule) = .ok traces.flatten := by
  induction inputs generalizing initial traces with
  | nil => simp [runGemmInstructions] at h; subst traces; rfl
  | cons pairs rest ih =>
    cases ht : p.run initial.bits pairs with
    | error e => simp [runGemmInstructions, ht] at h
    | ok ts =>
      cases hr : runGemmInstructions p (lastOutput initial ts) rest with
      | error e => simp [runGemmInstructions, ht, hr] at h
      | ok tail =>
        simp [runGemmInstructions, ht, hr] at h
        subst traces
        exact runBlocks_append p.profile initial _ _ _ _ (p.run_blocks _ _ _ ht) (ih _ _ hr)

theorem runGemmInstructions_coverage (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (traces : List (List BlockTrace))
    (h : runGemmInstructions p initial inputs = .ok traces) :
    (inputs.flatMap p.schedule).flatten = inputs.flatten := by
  induction inputs generalizing initial traces with
  | nil => rfl
  | cons pairs rest ih =>
    cases ht : p.run initial.bits pairs with
    | error e => simp [runGemmInstructions, ht] at h
    | ok ts =>
      cases hr : runGemmInstructions p (lastOutput initial ts) rest with
      | error e => simp [runGemmInstructions, ht, hr] at h
      | ok tail =>
        simp only [List.flatMap_cons, List.flatten_append, List.flatten_cons]
        rw [p.schedule_flatten pairs (p.run_length _ _ _ ht), ih _ _ hr]

theorem runGemmInstructions_count (p : InstructionPath) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (traces : List (List BlockTrace))
    (h : runGemmInstructions p initial inputs = .ok traces) : traces.length = inputs.length := by
  induction inputs generalizing initial traces with
  | nil => simp [runGemmInstructions] at h; subst traces; rfl
  | cons pairs rest ih =>
    cases ht : p.run initial.bits pairs with
    | error e => simp [runGemmInstructions, ht] at h
    | ok ts =>
      cases hr : runGemmInstructions p (lastOutput initial ts) rest with
      | error e => simp [runGemmInstructions, ht, hr] at h
      | ok tail =>
        simp [runGemmInstructions, ht, hr] at h
        subst traces
        simpa using ih _ _ hr

structure GemmCell where
  initial : Finite32
  instructions : List (List BlockTrace)
  deriving Repr, DecidableEq

def GemmCell.blocks (cell : GemmCell) : List BlockTrace := cell.instructions.flatten
def GemmCell.output (cell : GemmCell) : Finite32 := lastOutput cell.initial cell.blocks
def GemmCell.errorBudget (cell : GemmCell) : ℚ := sumQ (cell.blocks.map BlockTrace.errorBudget)

/-- K=0 performs no instructions and preserves finite C, including signed zero. -/
def simulateGemmCell (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) :
    Except ModelError GemmCell :=
  match finite32 c with
  | none => .error .nonfiniteInput
  | some initial => match runGemmInstructions model.path initial (gemmInstructions pairs) with
    | .error e => .error e
    | .ok traces => .ok ⟨initial, traces⟩

theorem simulateGemmCell_spec (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cell : GemmCell) (h : simulateGemmCell model pairs c = .ok cell) :
    finite32 c = some cell.initial ∧
      runGemmInstructions model.path cell.initial (gemmInstructions pairs) = .ok cell.instructions := by
  cases hi : finite32 c with
  | none => simp [simulateGemmCell, hi] at h
  | some initial =>
    cases hr : runGemmInstructions model.path initial (gemmInstructions pairs) with
    | error e => simp [simulateGemmCell, hi, hr] at h
    | ok ts =>
      simp [simulateGemmCell, hi, hr] at h
      subst cell
      exact ⟨rfl, hr⟩

theorem simulateGemmCell_count (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cell : GemmCell) (h : simulateGemmCell model pairs c = .ok cell) :
    cell.instructions.length = groupCount 16 pairs.length := by
  have hc := runGemmInstructions_count _ _ _ _ (simulateGemmCell_spec _ _ _ _ h).2
  simpa [gemmInstructions, OrderedPartition.inputs, canonicalPartition_count] using hc

private theorem gemm_ideal_profile (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    idealProducts model.path.profile pairs = idealProducts v100F16F32 pairs := by
  cases model <;> rfl

/-- Successful simulation inherits the existing local-error composition theorem.
The reference products are decoded directly from the original unpadded input words. -/
theorem simulateGemmCell_error (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cell : GemmCell) (products : ℚ)
    (h : simulateGemmCell model pairs c = .ok cell)
    (hi : idealProducts v100F16F32 pairs = some products) :
    absQ (cell.initial.value + products - cell.output.value) ≤ cell.errorBudget := by
  have hr := (simulateGemmCell_spec _ _ _ _ h).2
  have hblocks := runGemmInstructions_blocks _ _ _ _ hr
  have hideal : idealContributions model.path.profile
      ((gemmInstructions pairs).flatMap model.path.schedule) = some products := by
    rw [idealContributions_flatten, runGemmInstructions_coverage _ _ _ _ hr,
      gemmInstructions_flatten, gemm_ideal_profile]
    change idealProducts (fp16Fp32Profile 16 0 none) (padFp16Pairs 16 pairs) = some products
    rw [idealProducts_padFp16Pairs]
    exact hi
  exact (runBlocks_uncorrected_error _ _ _ _ _ hblocks hideal).1

/-- Simulate every cell of one 16×16 output tile, including padded edge cells.
The per-cell projections share the same increasing-k WMMA instruction sequence. -/
def simulateGemmTile (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (rowTile colTile : ℕ) :
    DenseMatrix (Except ModelError GemmCell) 16 16 :=
  DenseMatrix.ofFn fun i j =>
    let row := 16 * rowTile + i.val
    let col := 16 * colTile + j.val
    simulateGemmCell model
      (List.ofFn fun l : Fin k => (A.padded 0 row l.val, B.padded 0 l.val col))
      (C.padded 0 row col)

/-- Execute each output tile once. C is loaded before the k loop; no scalar epilogue. -/
def gemmTiles (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    DenseMatrix (DenseMatrix (Except ModelError GemmCell) 16 16)
      (groupCount 16 m) (groupCount 16 n) :=
  DenseMatrix.ofFn fun i j => simulateGemmTile model A B C i.val j.val

private theorem gemm_tileIndex_lt (i : Fin m) : i.val / 16 < groupCount 16 m := by
  have hp := padded_length 16 m (by decide)
  apply (Nat.div_lt_iff_lt_mul (by decide : 0 < 16)).2
  omega

/-- A*B+C, cropping the executed WMMA tiles back to the original output dimensions.
Each entry retains either its trace or its finite-model error. Errors cannot shift
or remove rows/columns. -/
def gemm (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Except ModelError GemmCell) m n :=
  let tiles := gemmTiles model A B C
  DenseMatrix.ofFn fun i j =>
    let tile := (tiles[i.val / 16]'(gemm_tileIndex_lt i))[j.val / 16]'(gemm_tileIndex_lt j)
    (tile[i.val % 16]'(Nat.mod_lt _ (by decide)))[j.val % 16]'(Nat.mod_lt _ (by decide))

def gemmBits (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Except ModelError F32) m n :=
  (gemm model A B C).map fun row => row.map fun cell => cell.map fun t => t.output.bits

/-- Independently decoded mathematical target, without model execution or padding. -/
def gemmIdeal (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => do
    let c ← value32 C[i.val][j.val]
    let products ← idealProducts v100F16F32 (gemmPairs A B i j)
    return c + products

@[simp] theorem gemm_entry (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) :
    (gemm model A B C)[i.val][j.val] =
      simulateGemmCell model (gemmPairs A B i j) C[i.val][j.val] := by
  have hi : 16 * (i.val / 16) + i.val % 16 = i.val := by omega
  have hj : 16 * (j.val / 16) + j.val % 16 = j.val := by omega
  simp [gemm, gemmTiles, simulateGemmTile, DenseMatrix.ofFn, hi, hj,
    DenseMatrix.padded, i.isLt, j.isLt, gemmPairs]

theorem gemm_entry_count (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n)
    (cell : GemmCell) (h : (gemm model A B C)[i.val][j.val] = .ok cell) :
    cell.instructions.length = groupCount 16 k := by
  rw [gemm_entry] at h
  simpa using simulateGemmCell_count _ _ _ _ h

/-- Entrywise matrix accuracy against A*B+C, with each exact ideal independent of execution. -/
theorem gemm_entry_error (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n)
    (cell : GemmCell) (z : ℚ) (h : (gemm model A B C)[i.val][j.val] = .ok cell)
    (hi : (gemmIdeal A B C)[i.val][j.val] = some z) :
    absQ (z - cell.output.value) ≤ cell.errorBudget := by
  rw [gemm_entry] at h
  have hc := finite32_bits (simulateGemmCell_spec _ _ _ _ h).1
  have hv : value32 C[i.val][j.val] = some cell.initial.value := by
    rw [← hc]
    simp [value32, cell.initial.valid, Finite32.value]
  simp only [gemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, hv] at hi
  cases hp : idealProducts v100F16F32 (gemmPairs A B i j) with
  | none => simp [hp] at hi
  | some products =>
    simp [hp] at hi
    rw [← hi]
    exact simulateGemmCell_error _ _ _ _ _ h hp

/-- Logical tile loads for a 16×16×16 WMMA. Out-of-bounds operands are +0. -/
def gemmTileOperands (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (rowTile colTile kTile : ℕ) : DenseMatrix F16 16 16 × DenseMatrix F16 16 16 :=
  (DenseMatrix.ofFn fun i l => A.padded 0 (16 * rowTile + i.val) (16 * kTile + l.val),
   DenseMatrix.ofFn fun l j => B.padded 0 (16 * kTile + l.val) (16 * colTile + j.val))

/-- The chosen instruction schedule, expressed as output-tile and k-tile indices.
This counts planned whole warp instructions, not per-cell scalar projections. -/
def gemmTileSchedule (m n k : ℕ) : List (ℕ × ℕ × ℕ) :=
  (List.range (groupCount 16 m)).flatMap fun i =>
    (List.range (groupCount 16 n)).flatMap fun j =>
      (List.range (groupCount 16 k)).map fun l => (i, j, l)

end TensorCore
