import TensorCore.PaperSpec.GemmEquivalence
import TensorCore.Programs.GemmBounds

/-! Arithmetic projection of the pinned CUTLASS v3.5.1 single-stage Sm70 WMMA
configuration in kernels/cutlass/wmma_sm70.cu. The source map and SHA-256 checks
are in kernels/cutlass/pin.json. This is a reviewed C++-to-Lean transcription,
not a verified C++ frontend, memory implementation, CUDA compiler, or GPU proof.

A is row-major, B column-major, D row-major. CTAs are 64×64×16, with four
32×32×16 warps (four independent 16×16 WMMA fragments per warp), no split K and an identity epilogue. K is a positive multiple
of 16: the pinned iterator's residue-first schedule differs for partial K.
The numerical WMMA primitive is the existing V100 paper model. -/

namespace TensorCore.CutlassWmma

/-- Immutable upstream revision, also checked against the vendored source manifest. -/
def revision : String := "f7b19de32c5d1f3cedfc735c2849f12b537522ee"

def warpOf (i j : Nat) : Nat := i % 64 / 32 + 2 * (j % 64 / 32)
def outputRow (blockRow warp localRow : Nat) := blockRow * 64 + (warp % 2) * 32 + localRow
def outputCol (blockCol warp localCol : Nat) := blockCol * 64 + (warp / 2) * 32 + localCol

theorem warpOf_lt (i j : Nat) : warpOf i j < 4 := by unfold warpOf; omega

theorem output_coordinates (i j : Nat) :
    outputRow (i / 64) (warpOf i j) (i % 32) = i ∧
    outputCol (j / 64) (warpOf i j) (j % 32) = j := by
  unfold outputRow outputCol warpOf
  omega

/-- Element offsets (not byte offsets) in the three pinned global layouts. -/
def addressA (lda row k : Nat) := row * lda + k
def addressB (ldb k col : Nat) := col * ldb + k
def addressD (ldd row col : Nat) := row * ldd + col

theorem operand_addresses (lda ldb i j step r : Nat) :
    addressA lda (outputRow (i / 64) (warpOf i j) (i % 32)) (step * 16 + r) =
      i * lda + step * 16 + r ∧
    addressB ldb (step * 16 + r) (outputCol (j / 64) (warpOf i j) (j % 32)) =
      j * ldb + step * 16 + r := by
  rw [(output_coordinates i j).1, (output_coordinates i j).2]
  unfold addressA addressB
  omega

theorem store_address (ldd i j : Nat) :
    addressD ldd (outputRow (i / 64) (warpOf i j) (i % 32))
      (outputCol (j / 64) (warpOf i j) (j % 32)) = i * ldd + j := by
  rw [(output_coordinates i j).1, (output_coordinates i j).2]
  rfl

/-- One instruction per output entry per loop iteration; each warp visits
its four independent m/n fragments. The source decrements a remaining
count while the tile iterators advance by 16 along K. -/
def instructions (load : Nat → α) : Nat → Nat → List (List α)
  | _, 0 => []
  | start, count + 1 => (List.ofFn fun r : Fin 16 => load (start + r.val)) ::
      instructions load (start + 16) count

private theorem chunks_tabulate (load : Nat → α) (start count : Nat) :
    PaperSpec.matrixChunks 16 count (List.ofFn fun r : Fin (16 * count) => load (start + r.val)) =
      instructions load start count := by
  induction count generalizing start with
  | zero => rfl
  | succ count ih =>
    have he : 16 * (count + 1) = 16 + 16 * count := by omega
    have hs : (List.ofFn fun r : Fin (16 * (count + 1)) => load (start + r.val)) =
        (List.ofFn fun r : Fin 16 => load (start + r.val)) ++
        (List.ofFn fun r : Fin (16 * count) => load (start + 16 + r.val)) := by
      conv => lhs; rw [he]
      rw [List.ofFn_add]
      congr 1
      apply congrArg List.ofFn
      funext r
      congr 1
      simp [Fin.natAdd, Nat.add_assoc]
    rw [hs]
    have ht := List.take_append_length
      (l₁ := List.ofFn fun r : Fin 16 => load (start + r.val))
      (l₂ := List.ofFn fun r : Fin (16 * count) => load (start + 16 + r.val))
    have hd := List.drop_append_length
      (l₁ := List.ofFn fun r : Fin 16 => load (start + r.val))
      (l₂ := List.ofFn fun r : Fin (16 * count) => load (start + 16 + r.val))
    simp only [List.length_ofFn] at ht hd
    simp only [PaperSpec.matrixChunks, ht, hd, ih, instructions]

/-- Logical operand reads after the pinned CTA/warp mapping. Out-of-range output
cells are masked; the public projection below keeps only valid rows and columns. -/
def loads (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (i j l : Nat) : F16 × F16 :=
  (A.padded 0 (outputRow (i / 64) (warpOf i j) (i % 32)) l,
   B.padded 0 l (outputCol (j / 64) (warpOf i j) (j % 32)))

theorem instructions_eq_paper (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) (i : Fin m) (j : Fin n) :
    instructions (loads A B i.val j.val) 0 tiles =
      PaperSpec.matrixInstructions (PaperSpec.matrixPairs A B i j) := by
  rw [← chunks_tabulate]
  have hloads : (List.ofFn fun r : Fin (16 * tiles) => loads A B i.val j.val (0 + r.val)) =
      PaperSpec.matrixPairs A B i j := by
    apply congrArg List.ofFn
    funext r
    simp [loads, (output_coordinates i.val j.val).1, (output_coordinates i.val j.val).2,
      DenseMatrix.padded, i.isLt, j.isLt, r.isLt]
  rw [hloads]
  have hc : (16 * tiles + 15) / 16 = tiles := by omega
  simp [PaperSpec.matrixInstructions, PaperSpec.matrixPairs, hc]

/-- Identity epilogue: source C, alpha and beta are not used by ScaleType::Nothing.
Every intermediate WMMA group boundary remains observable in this projection. -/
noncomputable def project (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) : DenseMatrix (Option PaperSpec.MatrixCell) m n :=
  DenseMatrix.ofFn fun i j => do
    let ds ← PaperSpec.runMatrixInstructions .v100 0 (instructions (loads A B i.val j.val) 0 tiles)
    return ⟨0, ds⟩

/-- Unconditional finite-model equality for the audited arithmetic projection.
This supplies the arithmetic schedule bridge; physical WMMA conformance and
source-transcription correctness are the explicitly documented external boundary. -/
theorem project_eq_gemm (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) :
    project A B = (gemm .v100 A B (DenseMatrix.ofFn fun _ _ => 0)).map
      (fun row => row.map fun cell => cell.toOption.map PaperSpec.gemmCellObservation) := by
  rw [PaperSpec.gemm_eq_paper]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [project, PaperSpec.wmmaGemm, DenseMatrix.ofFn, Vector.getElem_ofFn]
  rw [instructions_eq_paper A B ⟨i, hi⟩ ⟨j, hj⟩]
  rfl

/-- The existing input-only certificate supplies a complete accuracy guarantee
for this projection, without requiring a successful run or output-error premise. -/
theorem project_check_sound (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) (cfg : GemmBoundConfig)
    (h : gemmCheck .v100 cfg A B (DenseMatrix.ofFn fun _ _ => 0) = true)
    (i : Fin m) (j : Fin n) :
    ∃ cell z, (project A B)[i.val][j.val] = some (PaperSpec.gemmCellObservation cell) ∧
      (gemmIdeal A B (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError .v100 cfg (16 * tiles) := by
  obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound .v100 cfg A B _ h i j
  refine ⟨cell, z, ?_, hi, he⟩
  rw [project_eq_gemm]
  simp only [Vector.getElem_map, hr]
  rfl

end TensorCore.CutlassWmma
