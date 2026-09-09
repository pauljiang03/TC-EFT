import TensorCore.TC.Profiles

/-! Native L40S/Ada FP8, Accurate Models v4 Table 3 and Figure 4.
Section 4.1.4 (p.10) specifies 13 alignment fraction bits. Figure 4 (p.11)
labels a 20-bit sum and FP32 Norm/Trunc; Table 3 (p.14) counts carry bits in
that 20-bit sum. None explicitly specifies a normalized 13-fraction-bit result.
MATLAB v0.5 GEMM.m:80-96 reduces NoManBitsOut from 23 to 13; the slice in
Generic_BFMA_TC.m:290-293 applies it *after* norm_helper (:570-589).
The paper's stated probes do not distinguish these operations. The extra
normalized truncation is therefore an unresolved source-only interpretation,
not a consequence of the alignment width. See README's evidence review.
The two readings remain separate: archive replay distinguishes them.
Neither descriptor asserts device conformance. E4M3 uses finite-top-NaN decoding.
-/

namespace TensorCore

inductive FP8Format where
  | e4m3 | e5m2
  deriving Repr, DecidableEq

@[implicit_reducible] def FP8Format.encoding : FP8Format → OperandEncoding
  | .e4m3 => packedE4M3
  | .e5m2 => packedIEEE TensorCore.e5m2

inductive FP8Reading where
  /-- Direct FP32 interpretation of Table 3 / Figure 4; a specification candidate,
  not a claim that the paper unambiguously settles normalized precision. -/
  | paper
  /-- `GEMM.m` reduces `NoManBitsOut` by ten before `Generic_BFMA_TC`. -/
  | source13
  deriving Repr, DecidableEq

/-- An internal precision with FP32 exponent range and 13 stored fraction bits.
Its encodings are intermediate values, not a new device output format. -/
@[implicit_reducible] def fp32With13FractionBits : Format := ⟨13, 8, 127⟩

@[implicit_reducible] def l40sFP8Invocation (f : FP8Format) (reading : FP8Reading) :
    InvocationSpec :=
  ⟨f.encoding, fp32, 16, .aligned 13 none .inGroup,
    match reading with
    | .paper => []
    | .source13 => [⟨fp32With13FractionBits, .towardZero⟩],
    ⟨fp32, .towardZero⟩⟩

/-- Ada RTX 1000 shares these numerical parameters (paper Section 4.1.5).
The vendored measurements are L40S rows, not a separate Ada measurement set. -/
abbrev adaFP8Invocation := l40sFP8Invocation

end TensorCore
