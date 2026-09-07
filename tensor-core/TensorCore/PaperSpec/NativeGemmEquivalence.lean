import TensorCore.PaperSpec.NativeMatrix
import TensorCore.Programs.NativeGemm

namespace TensorCore.PaperSpec


theorem native_parameters (model : NativeGemmModel p) :
    parametersOf model.profile = (match p, model with
      | .bf16, .ampere => parameters .ampereBF16
      | .bf16, .hopper => parameters .hopperBF16
      | .tf32, .ampere => parameters .ampereTF32
      | .tf32, .hopper => parameters .hopperTF32Wmma
      | .tf32, .hopperMma => parameters .hopperTF32Mma) := by
  cases p <;> cases model <;> rfl

theorem nativeGemmCell_eq_paper (model : NativeGemmModel p)
    (pairs : List (NativeWord p × NativeWord p)) (c : F32) :
    (nativeGemmCell model pairs c).map (fun cell => cell.blocks.map fun t => t.output.bits) =
      nativeMatrixCell (parametersOf model.profile) p.inner pairs c := by
  have hg := runBlocks_eq_paper model.profile c (nativeBlocks model pairs)
  have hs : nativeBlocks model pairs = matrixChunks model.profile.products
      ((pairs.length / p.inner + if pairs.length % p.inner = 0 then 0 else 1) *
        (p.inner / model.products))
      (pairs ++ List.replicate (if pairs.length % p.inner = 0 then 0 else p.inner - pairs.length % p.inner) (0, 0)) := by
    simp only [nativeBlocks, nativePartition, partitionExact_inputs_chunks, chunks_eq_matrixChunks,
      nativePadded, groupCount, tailPadding]
  unfold nativeMatrixCell
  rw [matrix_value32_finite]
  cases hf : finite32 c with
  | none => simp [nativeGemmCell, hf]
  | some initial =>
    simp only [Option.map_some, bind, Option.bind_some]
    calc
      _ = runGroups (parametersOf model.profile) c (nativeBlocks model pairs) := by
        rw [← hg]
        cases hr : runBlocks model.profile c (nativeBlocks model pairs) <;>
          simp [nativeGemmCell, hf, hr, Except.toOption]
      _ = _ := congrArg (fun (gs : List (List (NativeWord p × NativeWord p))) =>
        runGroups (parametersOf model.profile) c gs) hs


theorem nativeGemm_eq_paper (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) :
    (nativeGemm model A B C).map (fun row => row.map fun cell =>
      cell.map fun t => t.blocks.map fun b => b.output.bits) =
      nativeMatrix (parametersOf model.profile) p.inner A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [nativeGemm, DenseMatrix.ofFn, nativeMatrix, Vector.getElem_map, Vector.getElem_ofFn]
  exact nativeGemmCell_eq_paper model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩) C[i][j]

end TensorCore.PaperSpec
