import TensorCore.Programs.GemmAnalysis

namespace TensorCore

inductive NativePrecision where
  | bf16 | tf32
  deriving Repr, DecidableEq

@[implicit_reducible] def NativePrecision.format : NativePrecision → Format
  | .bf16 => TensorCore.bf16 | .tf32 => tf19

inductive NativeGemmModel : NativePrecision → Type where
  | ampere : NativeGemmModel p
  | hopper : NativeGemmModel p
  | hopperMma : NativeGemmModel .tf32
  deriving Repr, DecidableEq

def NativeGemmModel.products : NativeGemmModel p → Nat
  | .ampere => match p with | .bf16 => 8 | .tf32 => 4
  | .hopper => match p with | .bf16 => 16 | .tf32 => 4
  | .hopperMma => 8

@[implicit_reducible] def NativeGemmModel.profile (model : NativeGemmModel p) : Profile :=
  ⟨p.format, model.products,
    (match model with | .ampere => 24 | _ => 25),
    some (match model with | .ampere => -132 | _ => -133)⟩

def NativePrecision.inner : NativePrecision → Nat
  | .bf16 => 16 | .tf32 => 8

def NativeGemmModel.columns : NativeGemmModel p → Nat
  | .hopperMma => 8 | _ => 16

abbrev NativeWord (p : NativePrecision) := BitVec p.format.width

theorem native_shape (model : NativeGemmModel p) :
    0 < p.inner ∧ p.inner / model.products * model.products = p.inner := by
  cases p <;> cases model <;> decide +kernel

def nativePairs (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (i : Fin m) (j : Fin n) : List (NativeWord p × NativeWord p) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])

def nativePadded (p : NativePrecision) (xs : List (NativeWord p × NativeWord p)) :=
  xs ++ List.replicate (tailPadding p.inner xs.length) (0, 0)

def nativePartition (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :
    OrderedPartition model.profile (nativePadded p xs) :=
  partitionExact model.profile (groupCount p.inner xs.length * (p.inner / model.products))
    (nativePadded p xs) (by
      simp only [nativePadded, List.length_append, List.length_replicate]
      change xs.length + tailPadding p.inner xs.length =
        groupCount p.inner xs.length * (p.inner / model.products) * model.products
      rw [padded_length _ _ (native_shape model).1, Nat.mul_assoc, (native_shape model).2])

def nativeBlocks (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :=
  (nativePartition model xs).inputs

theorem nativeBlocks_shape (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :
    ∀ g ∈ nativeBlocks model xs, g.length = model.profile.products := by
  intro g hg
  obtain ⟨block, _, rfl⟩ := List.mem_map.mp hg
  exact block.shape

theorem native_zero_products (model : NativeGemmModel p) (n : Nat) :
    idealProducts model.profile (List.replicate n (0, 0)) = some 0 := by
  have hz : model.profile.decode (BitVec.ofNat _ 0) = some ⟨0, 0, 0⟩ := by
    cases p <;> cases model <;> decide +kernel
  have hp : prepareProducts model.profile (List.replicate n (0, 0)) =
      some (List.replicate n (Decoded.mk 0 0 0, Decoded.mk 0 0 0)) := by
    induction n with
    | zero => rfl
    | succ n ih =>
      simp [prepareProducts] at ih
      simp [prepareProducts, List.replicate_succ, List.mapM_cons, hz, ih]
  simp only [idealProducts, hp, Option.map_some]
  congr 1
  clear hp
  induction n with
  | zero => rfl
  | succ n ih =>
    simp [Decoded.value] at ih
    simp [List.replicate_succ, sumQ, ih, Decoded.value]
    grind

theorem nativeBlocks_ideal (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) :
    idealContributions model.profile (nativeBlocks model xs) = idealProducts model.profile xs := by
  rw [nativeBlocks, OrderedPartition.ideal, nativePadded, idealProducts_append, native_zero_products]
  cases idealProducts model.profile xs <;> simp [Rat.add_zero]

structure NativeGemmCell where
  initial : Finite32
  blocks : List BlockTrace
  deriving Repr, DecidableEq

def NativeGemmCell.output (c : NativeGemmCell) : Finite32 := lastOutput c.initial c.blocks

def nativeGemmCell (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) (c : F32) :
    Option NativeGemmCell := do
  let initial ← finite32 c
  let ts ← (runBlocks model.profile c (nativeBlocks model xs)).toOption
  return ⟨initial, ts⟩

theorem nativeGemmCell_blocks_length (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (cell : NativeGemmCell)
    (h : nativeGemmCell model xs c = some cell) :
    cell.blocks.length = groupCount p.inner xs.length * (p.inner / model.products) := by
  cases hf : finite32 c with
  | none => simp [nativeGemmCell, hf] at h
  | some initial =>
    cases hr : runBlocks model.profile c (nativeBlocks model xs) with
    | error e => simp [nativeGemmCell, hf, hr, Except.toOption] at h
    | ok ts =>
      have he : cell = ⟨initial, ts⟩ := by simpa [nativeGemmCell, hf, hr, Except.toOption] using h.symm
      rw [he]
      have hl := runBlocks_length model.profile c (nativeBlocks model xs) ts hr
      simpa [nativeBlocks, OrderedPartition.inputs, nativePartition, partitionExact_count] using hl

theorem native_instruction_trace_covers (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (cell : NativeGemmCell)
    (h : nativeGemmCell model xs c = some cell) :
    (chunks (p.inner / model.products) (groupCount p.inner xs.length) cell.blocks).flatten = cell.blocks :=
  chunks_flatten _ _ _ (nativeGemmCell_blocks_length model xs c cell h)


def nativeGemm (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) :
    DenseMatrix (Option NativeGemmCell) m n :=
  DenseMatrix.ofFn fun i j => nativeGemmCell model (nativePairs A B i j) C[i.val][j.val]

def nativeGemmIdeal (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) : DenseMatrix (Option Rat) m n :=
  DenseMatrix.ofFn fun i j => do
    let c ← value32 C[i.val][j.val]
    let products ← idealProducts model.profile (nativePairs A B i j)
    return c + products

def checkNativeCell (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p))
    (c : F32) (ws : List GroupWitness) : Option AnalysisBound := do
  let cv ← value32 c
  checkGroups model.profile (nativeBlocks model xs) (absQ cv) ws

theorem checkNativeCell_sound (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p))
    (c : F32) (ws : List GroupWitness) (b : AnalysisBound) (h : checkNativeCell model xs c ws = some b) :
    ∃ cell products, nativeGemmCell model xs c = some cell ∧
      idealProducts model.profile xs = some products ∧ value32 c = some cell.initial.value ∧
      absQ cell.output.value ≤ b.magnitude ∧
      absQ (cell.initial.value + products - cell.output.value) ≤ b.error := by
  simp only [checkNativeCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨cv, hv, hc⟩ := h
  obtain ⟨initial, hi, hb, hval⟩ := finite32_of_value32 c cv hv
  obtain ⟨ts, products, hr, hp, hm, he⟩ := checkGroups_sound model.profile
    (nativeBlocks model xs) (absQ cv) ws b hc initial (by rw [hval]; exact Rat.le_refl)
  rw [hb] at hr
  exact ⟨⟨initial, ts⟩, products, by simp [nativeGemmCell, hi, hr, Except.toOption],
    by rwa [nativeBlocks_ideal] at hp, by simpa [hval] using hv, hm, he⟩

def analyzeNativeCell (model : NativeGemmModel p) (xs : List (NativeWord p × NativeWord p)) (c : F32) :
    Option CellAnalysis := do
  let cv ← value32 c
  let ws ← inferGroups model.profile (nativeBlocks model xs) (absQ cv)
  let b ← checkNativeCell model xs c ws
  return ⟨ws, b⟩

theorem analyzeNativeCell_checked (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (a : CellAnalysis)
    (h : analyzeNativeCell model xs c = some a) : checkNativeCell model xs c a.witness = some a.bound := by
  simp only [analyzeNativeCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨_, _, _, _, _, hb, rfl⟩ := h
  exact hb

theorem analyzeNativeCell_complete (model : NativeGemmModel p)
    (xs : List (NativeWord p × NativeWord p)) (c : F32) (cv M : Rat)
    (hc : value32 c = some cv) (hm : scheduleMass model.profile (nativeBlocks model xs) = some M)
    (hr : absQ cv + M ≤ maxFinite32) : ∃ a, analyzeNativeCell model xs c = some a := by
  obtain ⟨ws, hw⟩ := inferGroups_complete model.profile (nativeBlocks model xs) (absQ cv) M
    (nativeBlocks_shape model xs) (absQ_nonneg cv) hm hr
  obtain ⟨b, hb⟩ := inferGroups_checked model.profile (nativeBlocks model xs) (absQ cv) ws hw
  exact ⟨⟨ws, b⟩, by simp [analyzeNativeCell, checkNativeCell, hc, hw, hb]⟩


def analyzeNativeGemm (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) :=
  DenseMatrix.ofFn fun i j => analyzeNativeCell model (nativePairs A B i j) C[i.val][j.val]

def nativeAnalysisCheck (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n)
    (ws : DenseMatrix (List GroupWitness) m n) (tol : Rat) : Bool :=
  decide (0 ≤ tol) && decide (∀ i : Fin m, ∀ j : Fin n,
    ((checkNativeCell model (nativePairs A B i j) C[i.val][j.val] ws[i.val][j.val]).map
      fun b => decide (b.error ≤ tol)).getD false = true)

def NativeGemmAccurate (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) (tol : Rat) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ cell z,
    (nativeGemm model A B C)[i.val][j.val] = some cell ∧
    (nativeGemmIdeal model A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tol

theorem nativeAnalysisCheck_sound (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n)
    (ws : DenseMatrix (List GroupWitness) m n) (tol : Rat)
    (h : nativeAnalysisCheck model A B C ws tol = true) : NativeGemmAccurate model A B C tol := by
  simp only [nativeAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro i j
  have hc := h.2 i j
  cases hb : checkNativeCell model (nativePairs A B i j) C[i.val][j.val] ws[i.val][j.val] with
  | none => simp [hb] at hc
  | some b =>
    simp only [hb, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
    obtain ⟨cell, products, hr, hp, hv, _, he⟩ := checkNativeCell_sound model _ _ _ b hb
    exact ⟨cell, cell.initial.value + products, by simpa [nativeGemm, DenseMatrix.ofFn] using hr,
      by simp [nativeGemmIdeal, DenseMatrix.ofFn, hv, hp], Rat.le_trans he hc⟩

theorem analyzeNativeGemm_entry_sound (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n) (a : CellAnalysis)
    (h : (analyzeNativeGemm model A B C)[i.val][j.val] = some a) :
    ∃ cell z, (nativeGemm model A B C)[i.val][j.val] = some cell ∧
      (nativeGemmIdeal model A B C)[i.val][j.val] = some z ∧
      absQ cell.output.value ≤ a.bound.magnitude ∧ absQ (z - cell.output.value) ≤ a.bound.error := by
  have hc := analyzeNativeCell_checked model (nativePairs A B i j) C[i.val][j.val] a (by simpa [analyzeNativeGemm, DenseMatrix.ofFn] using h)
  obtain ⟨cell, products, hr, hp, hv, hm, he⟩ := checkNativeCell_sound model _ _ _ _ hc
  exact ⟨cell, cell.initial.value + products, by simpa [nativeGemm, DenseMatrix.ofFn] using hr,
    by simp [nativeGemmIdeal, DenseMatrix.ofFn, hv, hp], hm, he⟩

theorem analyzeNativeGemm_matrix_error (model : NativeGemmModel p)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n)
    (h : ∀ i : Fin m, ∀ j : Fin n, ∃ a, (analyzeNativeGemm model A B C)[i.val][j.val] = some a)
    (D Z : DenseMatrix Rat m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (nativeGemm model A B C)[i.val][j.val] = some cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (nativeGemmIdeal model A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (analysisEntryBounds (analyzeNativeGemm model A B C)) := by
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨a, ha⟩ := h i j
  obtain ⟨cell, z, hr, hi, _, he⟩ := analyzeNativeGemm_entry_sound model A B C i j a ha
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, analysisEntryBounds, ha, hd i j cell hr] using he

end TensorCore
