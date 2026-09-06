import TensorCore.Meta.Certify

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

def lossyProgram : Program v100F16F32 := tc%{
  repeat (8) {
    block "small products" [(0x2bff, 0x2bff), (0x2bff, 0x2bff),
      (0x2bff, 0x2bff), (0x2bff, 0x2bff)];
  }
}

tc_certify lossyProgram_accurate : lossyProgram from 0x3f800000 scale 1 carry 3 within (1 / 2048)

theorem tight_tolerance_refused :
    lossyProgram.staticCertificate 1 3 0x3f800000 (1 / 1000000) = false := by decide +kernel

theorem insufficient_carry_refused :
    lossyProgram.staticCertificate 1 2 0x3f800000 1 = false := by decide +kernel

theorem empty_nonfinite_certificate_refused :
    (Program.skip : Program v100F16F32).staticCertificate 1 3 0x7fc00000 1 = false := by decide +kernel

theorem finite_empty_zero_tolerance :
    (Program.skip : Program v100F16F32).staticCertificate 1 3 0 0 = true := by decide +kernel

end TensorCore.Regression
