import TensorCore.Meta.Syntax

open TensorCore

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000

/-- Each block has four FP16 pairs. The incoming/outgoing accumulator is FP32. -/
def correctedDot : Program v100F16F32 := tc%{
  block "first four products" [(0x3e00, 0x3d00), (0x3e00, 0x3d00),
    (0x3e00, 0x3d00), (0x3e00, 0x3d00)];
  block "cancel 8.5" [(0xc000, 0x4400), (0xb800, 0x3c00), (0, 0), (0, 0)];
}

-- Prints the theorem type and its dependencies after the kernel checks the proof.
tc_verify correctedDot_correct : correctedDot from 0x3f7fffff

-- Prints the AST, profile, source locations, output sequence, exact ledger, and correction.
tc_inspect correctedDot from 0x3f7fffff

def threeAdds : Program v100F16F32 := tc%{
  repeat (3) {
    block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}

tc_verify threeAdds_correct : threeAdds from 0
