import TensorCore.Regression.GemmSpecification

/-! Check with: lake env lean examples/GemmSpecification.lean
The imported kernel regressions include padding, rejected and empty entries,
instruction order, signed zero, and the accepted scaled-source certificate. -/

open TensorCore TensorCore.PaperSpec

/-- All logical matrix entries and all encoded instruction/group boundaries. -/
example (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemm model A B C).map (fun row => row.map fun cell =>
      cell.toOption.map gemmCellObservation) = wmmaGemm (wmmaModel model) A B C :=
  gemm_eq_paper model A B C

/-- Final output bits, including a matching rejection at each failed entry. -/
example (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    (gemmBits model A B C).map (fun row => row.map Except.toOption) =
      wmmaGemmBits (wmmaModel model) A B C :=
  gemmBits_eq_paper model A B C

/-- The combined input-conversion, source-error, independent product trace, and
scalar-stage contract is demonstrated in Regression.paper_source_certificate. -/
example : (wmmaGemmBits .v100 Regression.gemmA Regression.gemmB Regression.gemmC)[0][0] =
    some 0x41800000 := by
  rw [Regression.paper_gemm_rectangular]
  rfl
