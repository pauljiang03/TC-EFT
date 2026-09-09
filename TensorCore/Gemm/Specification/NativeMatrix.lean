-- Native Matrix for GEMM.

import TensorCore.Gemm.Specification.Matrix

namespace TensorCore.PaperSpec

noncomputable def nativeMatrixCell (p : Parameters) (inner : ℕ)
    (pairs : List (BitVec p.input.width × BitVec p.input.width)) (c : BitVec 32) :
    Option (List (BitVec 32)) := do
  let _ ← value32 c
  let padding := if pairs.length % inner = 0 then 0 else inner - pairs.length % inner
  let instructions := pairs.length / inner + if pairs.length % inner = 0 then 0 else 1
  runGroups p c (matrixChunks p.products (instructions * (inner / p.products))
    (pairs ++ List.replicate padding (0, 0)))

noncomputable def nativeMatrix (p : Parameters) (inner : ℕ)
    (A : Matrix (BitVec p.input.width) m k) (B : Matrix (BitVec p.input.width) k n)
    (C : Matrix (BitVec 32) m n) : Matrix (Option (List (BitVec 32))) m n :=
  Vector.ofFn fun i => Vector.ofFn fun j => nativeMatrixCell p inner
    (List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])) C[i.val][j.val]

end TensorCore.PaperSpec
