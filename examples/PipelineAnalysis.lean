-- Pipeline Analysis for the executable examples.

import TensorCore.Gemm.Regression.PipelineAnalysis
import TensorCore.Gemm.Regression.GemmFamily

namespace TensorCore.Examples

open Regression

example : ConvertedGemmAccurate fp32 .towardNegative .hopper (analysisEpilogue .towardNegative)
    0x3f800000 0 sourceAnalysisA sourceAnalysisB sourceAnalysisC (1 / 100) :=
  scaled_analysis_source_accuracy .hopper .towardNegative

example (A : DenseMatrix F16 2 17) (B : DenseMatrix F16 17 3) (C : DenseMatrix F32 2 3)
    (h : unitFamily.Contains A B C) : GemmAccurate .ampere A B C (1 / 100) :=
  unit_family_accuracy .ampere A B C h

end TensorCore.Examples
