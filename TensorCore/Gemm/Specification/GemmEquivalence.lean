import TensorCore.Gemm.Specification.Matrix
import TensorCore.TC.Specification.Composition
import TensorCore.Gemm.Defs

/-! Bridge from executable output-tile simulation to the independent matrix
specification. No success, accuracy, or specification-conformance premise is used.
All encoded group outputs and instruction boundaries agree; errors map to none. -/

namespace TensorCore.PaperSpec

abbrev wmmaModel : WmmaGemmModel → WmmaModel
  | .v100 => .v100 | .ampere => .ampere | .hopper => .hopper

theorem wmma_parameters (model : WmmaGemmModel) :
    parametersOf model.path.profile = (wmmaModel model).parameters := by
  cases model <;> rfl

theorem chunks_eq_matrixChunks (width count : ℕ) (xs : List α) :
    chunks width count xs = matrixChunks width count xs := by
  induction count generalizing xs with
  | zero => rfl
  | succ n ih => simp [chunks, matrixChunks, ih]

theorem partitionExact_inputs_chunks (p : Profile) (count : ℕ)
    (xs : List (p.Word × p.Word)) (h : xs.length = count * p.products) :
    (partitionExact p count xs h).inputs = chunks p.products count xs := by
  induction count generalizing xs with
  | zero => rfl
  | succ n ih =>
    simp only [partitionExact, OrderedPartition.inputs, List.map_cons, chunks]
    exact congrArg (List.cons (xs.take p.products)) (ih _ _)

theorem gemmInstructions_eq_paper (pairs : List (F16 × F16)) :
    gemmInstructions pairs = matrixInstructions pairs := by
  have hc : groupCount 16 pairs.length = (pairs.length + 15) / 16 := by
    unfold groupCount
    split <;> omega
  have hp : tailPadding 16 pairs.length = (16 - pairs.length % 16) % 16 := by
    have := Nat.mod_lt pairs.length (by decide : 0 < 16)
    unfold tailPadding
    split <;> omega
  simp only [gemmInstructions, canonicalPartition, partitionExact_inputs_chunks,
    chunks_eq_matrixChunks, padFp16Pairs, hc, hp, matrixInstructions]
  rfl

theorem instructionGroups_eq_paper (model : WmmaGemmModel) (pairs : List (F16 × F16)) :
    model.path.schedule pairs = instructionGroups (wmmaModel model) pairs := by
  cases model <;> exact chunks_eq_matrixChunks _ _ _

theorem mapped_lastOutput (initial : Finite32) (ts : List BlockTrace) :
    (ts.map fun t => t.output.bits).getLast?.getD initial.bits = (lastOutput initial ts).bits := by
  rw [List.getLast?_map]
  exact lastOutput_bits initial ts

theorem runGemmInstructions_eq_paper (model : WmmaGemmModel) (initial : Finite32)
    (inputs : List (List (F16 × F16))) (hshape : ∀ xs ∈ inputs, xs.length = 16) :
    (runGemmInstructions model.path initial inputs).toOption.map
      (fun ts => ts.map fun gs => gs.map fun t => t.output.bits) =
      runMatrixInstructions (wmmaModel model) initial.bits inputs := by
  induction inputs generalizing initial with
  | nil => rfl
  | cons pairs rest ih =>
    have hb : (runBlocks model.path.profile initial.bits (model.path.schedule pairs)).toOption.map
        (fun ts => ts.map fun t => t.output.bits) =
        runGroups (wmmaModel model).parameters initial.bits (instructionGroups (wmmaModel model) pairs) := by
      rw [← instructionGroups_eq_paper]
      cases model <;> exact runBlocks_eq_paper _ _ _
    have hr : model.path.run initial.bits pairs =
        runBlocks model.path.profile initial.bits (model.path.schedule pairs) := by
      simp [InstructionPath.run, hshape pairs (by simp)]
    rw [← hr] at hb
    simp only [runMatrixInstructions, ← hb]
    cases hg : model.path.run initial.bits pairs with
    | error e => simp [runGemmInstructions, hg, Except.toOption]
    | ok gs =>
      have tail := ih (lastOutput initial gs) (by intro xs hx; exact hshape xs (by simp [hx]))
      cases hd : runGemmInstructions model.path (lastOutput initial gs) rest with
      | error e => simp [runGemmInstructions, hg, hd, Except.toOption, lastOutput_bits] at tail ⊢; rw [← tail]; rfl
      | ok ds => simp [runGemmInstructions, hg, hd, Except.toOption, lastOutput_bits] at tail ⊢; rw [← tail]; rfl

def gemmCellObservation (cell : GemmCell) : MatrixCell :=
  ⟨cell.initial.bits, cell.instructions.map fun gs => gs.map fun t => t.output.bits⟩

theorem gemmCellObservation_output (cell : GemmCell) :
    (gemmCellObservation cell).output = cell.output.bits := by
  simp only [gemmCellObservation, MatrixCell.output]
  rw [← List.map_flatten]
  exact mapped_lastOutput cell.initial cell.instructions.flatten

theorem matrix_value32_eq (c : F32) : value32 c = TensorCore.value32 c := by
  change (decode (layoutOf fp32) c.toNat).map Term.value = _
  rw [decode_eq]
  simp [TensorCore.value32, decode32_eq, Option.map_map, termOf, Function.comp_def]

theorem matrix_value32_finite (c : F32) : value32 c = (finite32 c).map Finite32.value := by
  rw [matrix_value32_eq]
  unfold finite32
  split <;> simp_all [TensorCore.value32, Finite32.value]

theorem simulateGemmCell_eq_paper (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) :
    (simulateGemmCell model pairs c).toOption.map gemmCellObservation =
      matrixCell (wmmaModel model) pairs c := by
  unfold simulateGemmCell matrixCell
  rw [matrix_value32_finite]
  cases hf : finite32 c with
  | none => rfl
  | some initial =>
    have hb := finite32_bits hf
    have hr := runGemmInstructions_eq_paper model initial (gemmInstructions pairs)
      (gemmInstructions_shape pairs)
    rw [gemmInstructions_eq_paper, hb] at hr
    simp only [Option.map_some]
    rw [← hr]
    rw [← gemmInstructions_eq_paper]
    cases he : runGemmInstructions model.path initial (gemmInstructions pairs) with
    | error e => rfl
    | ok ts => simp [Except.toOption, gemmCellObservation, hb]

/-- Universal matrix equality, including dimensions, output cropping, tail padding,
initial C, every encoded group/instruction boundary, and rejection as none. -/
theorem gemm_eq_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemm model A B C).map (fun row => row.map fun cell =>
      cell.toOption.map gemmCellObservation) = wmmaGemm (wmmaModel model) A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [Vector.getElem_map, wmmaGemm, Vector.getElem_ofFn]
  rw [gemm_entry model A B C ⟨i, hi⟩ ⟨j, hj⟩]
  exact simulateGemmCell_eq_paper model (gemmPairs A B ⟨i, hi⟩ ⟨j, hj⟩) C[i][j]

/-- Equality of final encoded outputs for every matrix; no execution premise. -/
theorem gemmBits_eq_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemmBits model A B C).map (fun row => row.map Except.toOption) =
      wmmaGemmBits (wmmaModel model) A B C := by
  rw [wmmaGemmBits, ← gemm_eq_paper]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [gemmBits, Vector.getElem_map]
  cases he : (gemm model A B C)[i][j] with
  | error e => rfl
  | ok cell => simp [Except.toOption, Except.map, gemmCellObservation_output]

/-- Paper-side success yields an executable trace, and conversely. The nested
trace retains every encoded boundary, rather than just the final value. -/
theorem gemm_entry_eq_paper_iff (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) (d : MatrixCell) :
    (wmmaGemm (wmmaModel model) A B C)[i.val][j.val] = some d ↔
      ∃ cell, (gemm model A B C)[i.val][j.val] = .ok cell ∧ gemmCellObservation cell = d := by
  rw [← gemm_eq_paper]
  simp only [Vector.getElem_map]
  cases he : (gemm model A B C)[i.val][j.val] <;> simp [Except.toOption]

theorem gemm_rejected_iff_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) :
    (wmmaGemm (wmmaModel model) A B C)[i.val][j.val] = none ↔
      ∃ e, (gemm model A B C)[i.val][j.val] = .error e := by
  rw [← gemm_eq_paper]
  simp only [Vector.getElem_map]
  cases he : (gemm model A B C)[i.val][j.val] <;> simp [Except.toOption]

end TensorCore.PaperSpec
