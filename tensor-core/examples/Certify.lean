import TensorCore.Meta.Certify

open TensorCore
set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

def dot : Program v100F16F32 := tc%{
  repeat (8) {
    block "small row-column terms" [(0x2bff, 0x2bff), (0x2bff, 0x2bff),
      (0x2bff, 0x2bff), (0x2bff, 0x2bff)];
  }
}

-- This concrete path computes exact ideal prefixes, then checks an input-derived bound.
-- The emitted theorem concerns the raw output; no exact correction is executed.
tc_certify dot_accurate : dot from 0x3f800000 scale 1 carry 3 within (1 / 2048)
tc_certificate dot from 0x3f800000 scale 1 carry 3 within (1 / 2048)
tc_certificate dot from 0x3f800000 scale 1 carry 3 within (1 / 1000000)
