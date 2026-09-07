import TensorCore.PaperSpec.NativeScaledMatrix
import TensorCore.PaperSpec.NativeGemmEquivalence
import TensorCore.PaperSpec.ScaledGemmEquivalence
import TensorCore.Programs.NativeScaledGemm

namespace TensorCore.PaperSpec

theorem matrixChunks_map (f : α → β) (width count : Nat) (xs : List α) :
    (matrixChunks width count xs).map (List.map f) = matrixChunks width count (xs.map f) := by
  induction count generalizing xs with
  | zero => rfl
  | succ count ih => simp [matrixChunks, List.map_take, List.map_drop, ih]

theorem nativeProductCell_eq_independent (model : NativeGemmModel p)
    (pairs : List (NativeWord p × NativeWord p)) :
    (nativeProductCell model pairs).map gemmCellObservation =
      nativeProductMatrixCell (parametersOf model.profile) p.inner pairs := by
  unfold nativeProductMatrixCell
  rw [← nativeGemmCell_eq_paper model pairs 0]
  cases hp : nativeGemmCell model pairs 0 with
  | none => unfold nativeProductCell; rw [hp]; rfl
  | some cell =>
    have hz : cell.initial.bits = 0 := by
      simp only [nativeGemmCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hp
      obtain ⟨initial, hi, ts, _, rfl⟩ := hp
      exact finite32_bits hi
    simp only [nativeProductCell, hp, Option.map_some, bind, pure, Option.bind_some, Option.some.injEq]
    simp only [gemmCellObservation, nativeProductTrace, chunks_eq_matrixChunks, matrixChunks_map, hz]
    rfl

theorem nativeScaledGemm_eq_independent (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) :
    (nativeScaledGemm model cfg alpha beta A B C).map (fun row => row.map fun cell =>
      cell.map scaledCellObservation) =
      nativeScaledMatrix (parametersOf model.profile) p.inner (epilogueOf cfg) alpha beta A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [nativeScaledGemm, nativeScaledMatrix, DenseMatrix.ofFn, Vector.getElem_map, Vector.getElem_ofFn]
  change ((nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).bind
    (gemmEpilogue cfg alpha beta C[i][j])).map scaledCellObservation =
    ((nativeProductMatrixCell (parametersOf model.profile) p.inner (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
  calc
    _ = ((nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).map gemmCellObservation).bind
        (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]) := by
      cases nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩) with
      | none => rfl
      | some product => exact (scalarEpilogue_eq cfg alpha beta C[i][j] product).symm
    _ = _ := congrArg (fun product : Option MatrixCell => product.bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
      (nativeProductCell_eq_independent model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩))

theorem convertMatrixToLayout_eq (source target : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) :
    convertMatrixToLayout (layoutOf source) (layoutOf target) (scalarModeOf mode) A =
      convertMatrixTo source target mode A := by
  classical
  unfold convertMatrixToLayout convertMatrixTo
  simp only [scalarConvertWord_eq]
  rfl

theorem nativeConvertedGemm_eq_independent (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (nativeConvertedGemm source mode model cfg alpha beta A B C).map
      (fun D => D.map fun row => row.map fun cell => cell.map scaledCellObservation) =
      nativeConvertedMatrix (layoutOf source) (scalarModeOf mode) (parametersOf model.profile)
        p.inner (epilogueOf cfg) alpha beta A B C := by
  simp only [nativeConvertedGemm, nativeConvertedMatrix, parametersOf, NativeGemmModel.profile, convertMatrixToLayout_eq]
  cases ha : convertMatrixTo source p.format mode A <;> cases hb : convertMatrixTo source p.format mode B <;>
    simp [bind, pure, nativeScaledGemm_eq_independent] <;> rfl

end TensorCore.PaperSpec
