-- Matrix Conversion for GEMM.

import TensorCore.Gemm.TightInputBounds

namespace TensorCore

def convertMatrixTo (source target : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) : Option (DenseMatrix (BitVec target.width) m n) :=
  if ∀ i : Fin m, ∀ j : Fin n, (convertGemmWord source target mode A[i.val][j.val]).isSome then
    some (DenseMatrix.ofFn fun i j => (convertGemmWord source target mode A[i.val][j.val]).getD 0)
  else none

theorem convertMatrixTo_entry (source target : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix (BitVec target.width) m n)
    (h : convertMatrixTo source target mode A = some B) (i : Fin m) (j : Fin n) :
    convertGemmWord source target mode A[i.val][j.val] = some B[i.val][j.val] := by
  unfold convertMatrixTo at h
  split at h
  · rename_i hs
    cases Option.some.inj h
    have hi := hs i j
    cases hv : convertGemmWord source target mode A[i.val][j.val] with
    | none => simp [hv] at hi
    | some v => simp [DenseMatrix.ofFn, hv]
  · contradiction

def inputDatumTo (source target : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) : Option GemmInputDatum := do
  let x ← binaryValue source bits
  let y ← (ConversionStage.mk target mode).convert x
  return ⟨x, y.value⟩

theorem inputDatumTo_of_conversion (source target : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (output : BitVec target.width)
    (h : convertGemmWord source target mode input = some output) :
    ∃ d, inputDatumTo source target mode input = some d ∧
      binaryValue source input = some d.value ∧ binaryValue target output = some d.converted := by
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, hx, y, hy, he⟩ := h
  cases Option.some.inj he
  refine ⟨⟨x, y.value⟩, by simp [inputDatumTo, hx, hy], hx, ?_⟩
  simp [binaryValue, y.valid, FiniteBinary.value]

def inputProductErrorTo (source target : Format) (mode : BinaryRoundingMode) :
    List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← inputDatumTo source target mode a
    let bv ← inputDatumTo source target mode b
    let tail ← inputProductErrorTo source target mode rest
    return gemmInputPairTightError av bv + tail

theorem inputProductErrorTo_bound (source target : Format) (mode : BinaryRoundingMode)
    (xs : List ι) (input : ι → BitVec source.width × BitVec source.width)
    (output : ι → BitVec target.width × BitVec target.width)
    (h : ∀ x ∈ xs,
      convertGemmWord source target mode (input x).1 = some (output x).1 ∧
      convertGemmWord source target mode (input x).2 = some (output x).2) :
    ∃ s p e, sourceGemmProducts source (xs.map input) = some s ∧
      sourceGemmProducts target (xs.map output) = some p ∧
      inputProductErrorTo source target mode (xs.map input) = some e ∧ absQ (s - p) ≤ e := by
  induction xs with
  | nil => exact ⟨0, 0, 0, rfl, rfl, rfl, by decide +kernel⟩
  | cons x xs ih =>
    obtain ⟨ha, hb⟩ := h x (by simp)
    obtain ⟨a, had, hav, hac⟩ := inputDatumTo_of_conversion source target mode _ _ ha
    obtain ⟨b, hbd, hbv, hbc⟩ := inputDatumTo_of_conversion source target mode _ _ hb
    obtain ⟨s, p, e, hs, hp, he, hbnd⟩ := ih (by intro y hy; exact h y (by simp [hy]))
    refine ⟨a.value * b.value + s, a.converted * b.converted + p,
      gemmInputPairTightError a b + e, ?_, ?_, ?_, ?_⟩
    · simp [sourceGemmProducts, hav, hbv, hs]
    · simp [sourceGemmProducts, hac, hbc, hp]
    · simp [inputProductErrorTo, had, hbd, he]
    · have ht := absQ_add_le (a.value * b.value - a.converted * b.converted) (s - p)
      have hx := gemmInputPairTightError_bound a b
      grind

end TensorCore
