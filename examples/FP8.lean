-- FP8 for the executable examples.

import TensorCore.TC.Regression.FP8

open TensorCore

/-- Both readings have a proved original-input loss ledger. -/
example (f : FP8Format) (reading : FP8Reading)
    (pairs : List (f.encoding.Word × f.encoding.Word)) (c : F32)
    (t : L40SFP8Trace f reading) (h : runL40SFP8 f reading pairs c = .ok t) :
    l40sFP8Ideal f pairs c = some (t.second.output.value + t.first.residual + t.second.residual) :=
  runL40SFP8_recovery h

/-- The first L40S E4M3 archive row distinguishes normalized output precision. -/
example :
    l40sFP8Bits .e4m3 .source13 Regression.l40sE4M3Row 0x3e93ca5a = some 0x40827800 ∧
    l40sFP8Bits .e4m3 .paper Regression.l40sE4M3Row 0x3e93ca5a = some 0x40827b00 :=
  Regression.l40s_e4m3_published_row
