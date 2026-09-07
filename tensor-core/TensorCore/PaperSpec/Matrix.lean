import TensorCore.PaperSpec.Profiles
import TensorCore.PaperSpec.Schedule
import Init.Data.Vector.OfFn

/-! Independent logical FP16 WMMA matrix schedule. Only the standard library and
independent paper definitions are imported. Each row/column reduction consumes
increasing groups inside increasing k=16 instructions; the final instruction is
zero-padded. Logical output dimensions crop away unused output-tile cells.
This specifies the selected matrix schedule, not a CUDA kernel or lane mapping.
Failures are observed as none, without implementation-specific error tags. -/

namespace TensorCore.PaperSpec

abbrev Matrix (α : Type) (m n : Nat) := Vector (Vector α n) m

inductive WmmaModel where
  | v100 | ampere | hopper
  deriving Repr, DecidableEq

def WmmaModel.parameters (model : WmmaModel) : Parameters :=
  ⟨⟨10, 5, 15⟩,
    (match model with | .v100 => 4 | .ampere => 8 | .hopper => 16),
    (match model with | .v100 => 23 | .ampere => 24 | .hopper => 25),
    (match model with | .v100 => none | .ampere => some (-132) | .hopper => some (-133))⟩

/-- Contiguous, ordered groups; no arithmetic or implementation partition call. -/
def matrixChunks (width : Nat) : Nat → List α → List (List α)
  | 0, _ => []
  | count + 1, xs => xs.take width :: matrixChunks width count (xs.drop width)

def matrixPairs (A : Matrix (BitVec 16) m k) (B : Matrix (BitVec 16) k n)
    (i : Fin m) (j : Fin n) : List (BitVec 16 × BitVec 16) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])

/-- Exactly ceil(k/16) complete slices. Empty and exact-multiple inputs add no padding. -/
def matrixInstructions (pairs : List (BitVec 16 × BitVec 16)) :=
  matrixChunks 16 ((pairs.length + 15) / 16)
    (pairs ++ List.replicate ((16 - pairs.length % 16) % 16) (0, 0))

def instructionGroups (model : WmmaModel) (pairs : List (BitVec 16 × BitVec 16)) :=
  matrixChunks model.parameters.products (16 / model.parameters.products) pairs

/-- Preserve every normalization-group output, nested by instruction boundary. -/
noncomputable def runMatrixInstructions (model : WmmaModel) : BitVec 32 →
    List (List (BitVec 16 × BitVec 16)) → Option (List (List (BitVec 32)))
  | _, [] => some []
  | c, pairs :: rest => do
    let ds ← runGroups model.parameters c (instructionGroups model pairs)
    let tail ← runMatrixInstructions model (ds.getLast?.getD c) rest
    return ds :: tail

structure MatrixCell where
  initial : BitVec 32
  instructions : List (List (BitVec 32))
  deriving Repr, DecidableEq

def MatrixCell.output (cell : MatrixCell) : BitVec 32 :=
  cell.instructions.flatten.getLast?.getD cell.initial

/-- The public matrix domain checks finite C even when k=0. Empty k preserves
finite C bit-for-bit, including -0; a nonempty all-zero instruction may change it. -/
noncomputable def matrixCell (model : WmmaModel) (pairs : List (BitVec 16 × BitVec 16))
    (c : BitVec 32) : Option MatrixCell := do
  let _ ← value32 c
  let ds ← runMatrixInstructions model c (matrixInstructions pairs)
  return ⟨c, ds⟩

/-- Original dimensions and direct row/column indexing, independent of output tiling. -/
noncomputable def wmmaGemm (model : WmmaModel) (A : Matrix (BitVec 16) m k)
    (B : Matrix (BitVec 16) k n) (C : Matrix (BitVec 32) m n) :
    Matrix (Option MatrixCell) m n :=
  Vector.ofFn fun i => Vector.ofFn fun j => matrixCell model (matrixPairs A B i j) C[i.val][j.val]

noncomputable def wmmaGemmBits (model : WmmaModel) (A : Matrix (BitVec 16) m k)
    (B : Matrix (BitVec 16) k n) (C : Matrix (BitVec 32) m n) :
    Matrix (Option (BitVec 32)) m n :=
  (wmmaGemm model A B C).map fun row => row.map fun cell => cell.map MatrixCell.output

end TensorCore.PaperSpec
