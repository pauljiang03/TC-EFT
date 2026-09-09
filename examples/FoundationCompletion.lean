import TensorCore.Regression.FoundationCompletion

/-! Reviewer entry point: lake env lean examples/FoundationCompletion.lean.
Imported regressions are kernel checked. The CLI in GemmExtensions.lean exposes
both original and tighter bounds on the same editable JSONL inputs. -/

open TensorCore TensorCore.PaperSpec

#check extraction_coefficient_bound
#check ExtractionGrid.eq20_exact_sum
#check ExtractionGrid.eq20_scalarPredicate
#check ExtractionGrid.scalarCorrected_correct
#check defaultExtraction_scalar
#check scalarRound_eq
#check scaledGemm_eq_independent
#check convertedGemm_eq_independent
#check scaledGemmCheck_tight_sound
#check convertedGemmTightSourceCertificate_sound
#check convertedGemmTightSourceCertificate_matrix_error

example (t : BlockTrace) (f : TensorCore.Format) :
    t.defaultExtraction.scalarCorrected f t.supportExponent = t.scalarCorrectedIn f :=
  (defaultExtraction_scalar t f).2
