import TensorCore.Core.Defs
import Init.Data.Vector.OfFn

-- Dense matrices and zero-padded indexing.

namespace TensorCore

/-- Dense row-major storage with dimensions checked by Lean's type system. -/
abbrev DenseMatrix (α : Type) (rows cols : ℕ) := Vector (Vector α cols) rows

namespace DenseMatrix

def ofFn (f : Fin rows → Fin cols → α) : DenseMatrix α rows cols :=
  Vector.ofFn fun i => Vector.ofFn (f i)

/-- Zero padding for logical tile loads at matrix boundaries. -/
def padded (a : DenseMatrix α rows cols) (zero : α) (i j : ℕ) : α :=
  if hi : i < rows then if hj : j < cols then a[i][j] else zero else zero

@[simp] theorem padded_in_bounds (a : DenseMatrix α rows cols) (zero : α)
    (i : Fin rows) (j : Fin cols) : a.padded zero i j = a[i.val][j.val] := by
  simp [padded, i.isLt, j.isLt]

end DenseMatrix

end TensorCore
