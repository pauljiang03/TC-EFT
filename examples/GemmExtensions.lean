-- Gemm Extensions for the executable examples.

import TensorCore.Gemm.Regression.GemmInputConversion
import TensorCore.Gemm.Cli.Gemm

open TensorCore Lean TensorCore.Cli.Gemm

def main (args : List String) : IO Unit := do
  match args with
  | [] =>
    for architecture in [WmmaGemmModel.v100, .ampere, .hopper] do
      IO.println s!"{repr architecture}: tiny GEMM input certificate = {gemmCheck architecture
        Regression.smallGemmBounds Regression.gemmTinyA Regression.gemmTinyB Regression.gemmOne}"
      IO.println s!"entry bound = {gemmStaticError architecture Regression.smallGemmBounds 17}"
      IO.println s!"complete scaled GEMM certificate = {scaledGemmCheck architecture {}
        Regression.smallScaledGemmBounds 0x40000000 0xbf000000
        Regression.gemmTinyA Regression.gemmTinyB Regression.gemmOne}"
    IO.println "2*A*B - 0.5*C, separate FP32 nearest-even multiplies and add:"
    IO.println (matrixJson (scaledGemm .ampere {} 0x40000000 0xbf000000
      Regression.gemmA Regression.gemmB Regression.gemmC) scaledCellJson).compress
  | [path] =>
    for line in (← IO.FS.readFile path).splitOn "\n" do
      unless line.isEmpty do
        match Json.parse line >>= evaluate with
        | .error e => throw (IO.userError e)
        | .ok result => IO.println result.compress
  | _ => throw (IO.userError "Usage: lean --run examples/GemmExtensions.lean [cases.jsonl]")

/-- Source-relative entry and matrix bounds come from the same acceptance check. -/
example (source : TensorCore.Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (bounds : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemmSourceCertificate source mode model cfg bounds alpha beta A B C).isSome =
      convertedGemmCheck source mode model cfg bounds alpha beta A B C :=
  convertedGemmSourceCertificate_acceptance source mode model cfg bounds alpha beta A B C
