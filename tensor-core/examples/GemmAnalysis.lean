import TensorCore.Regression.GemmAnalysis

open TensorCore TensorCore.Regression

example : GemmAccurate .hopper gemmTinyA gemmTinyB gemmOne (1 / 100000) :=
  analysis_tolerance_certified .hopper

example (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) (cv M : Rat)
    (hc : value32 c = some cv)
    (hm : scheduleMass model.path.profile (gemmBlocks model pairs) = some M)
    (hr : absQ cv + M ≤ maxFinite32) : ∃ a, analyzeGemmCell model pairs c = some a :=
  analyzeGemmCell_complete model pairs c cv M hc hm hr
