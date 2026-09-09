-- Native Scaled Matrix for GEMM.

import TensorCore.Gemm.Specification.NativeMatrix
import TensorCore.Gemm.Specification.Scalar

namespace TensorCore.PaperSpec

noncomputable def nativeProductMatrixCell (p : Parameters) (inner : ℕ)
    (pairs : List (BitVec p.input.width × BitVec p.input.width)) : Option MatrixCell := do
  let groups ← nativeMatrixCell p inner pairs 0
  return ⟨0, matrixChunks (inner / p.products)
    (pairs.length / inner + if pairs.length % inner = 0 then 0 else 1) groups⟩

noncomputable def nativeScaledMatrix (p : Parameters) (inner : ℕ) (cfg : ScalarEpilogue)
    (alpha beta : BitVec 32) (A : Matrix (BitVec p.input.width) m k)
    (B : Matrix (BitVec p.input.width) k n) (C : Matrix (BitVec 32) m n) :
    Matrix (Option (ScaledMatrixCell cfg.output.format)) m n :=
  Vector.ofFn fun i => Vector.ofFn fun j => do
    let product ← nativeProductMatrixCell p inner (List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val]))
    scalarEpilogue cfg alpha beta C[i.val][j.val] product

noncomputable def convertMatrixToLayout (source target : Layout) (mode : ScalarMode)
    (A : Matrix (BitVec source.width) m n) : Option (Matrix (BitVec target.width) m n) := by
  classical
  exact if ∀ i : Fin m, ∀ j : Fin n, (scalarConvertWord source target mode A[i.val][j.val]).isSome then
    some (Vector.ofFn fun i => Vector.ofFn fun j =>
      (scalarConvertWord source target mode A[i.val][j.val]).getD 0)
  else none

noncomputable def nativeConvertedMatrix (source : Layout) (mode : ScalarMode)
    (p : Parameters) (inner : ℕ) (cfg : ScalarEpilogue) (alpha beta : BitVec 32)
    (A : Matrix (BitVec source.width) m k) (B : Matrix (BitVec source.width) k n)
    (C : Matrix (BitVec 32) m n) : Option (Matrix (Option (ScaledMatrixCell cfg.output.format)) m n) := do
  let a ← convertMatrixToLayout source p.input mode A
  let b ← convertMatrixToLayout source p.input mode B
  return nativeScaledMatrix p inner cfg alpha beta a b C

end TensorCore.PaperSpec
