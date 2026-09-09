-- Gemm Input for GEMM.

import TensorCore.Gemm.Defs
import TensorCore.Core.Conversion
import Lean

namespace TensorCore.Cli.GemmInput

open Lean

def words (width rows cols : ℕ) (xs : Array ℕ) :
    Except String (DenseMatrix (BitVec width) rows cols) :=
  if xs.size != rows * cols then .error "Matrix shape does not match its word count"
  else if xs.any (· ≥ 2 ^ width) then .error "Operand word exceeds its format width"
  else .ok (DenseMatrix.ofFn fun i j => BitVec.ofNat width xs[i.val * cols + j.val]!)

def scalar (input : Json) (key : String) : Except String F32 := do
  let n ← input.getObjValAs? ℕ key
  if n ≥ 2 ^ 32 then .error "Scalar word exceeds FP32 width" else .ok (BitVec.ofNat 32 n)

def mode : String → Except String BinaryRoundingMode
  | "rne" => .ok .nearestEven | "rtz" => .ok .towardZero
  | "rdn" => .ok .towardNegative | "rup" => .ok .towardPositive
  | _ => .error "Expected rounding mode rne, rtz, rdn, or rup"

def format : String → Except String TensorCore.Format
  | "fp16" => .ok fp16 | "fp32" => .ok fp32
  | "bf16" => .ok bf16 | "fp64" => .ok fp64
  | _ => .error "Expected format fp16, fp32, bf16, or fp64"

def model : String → Except String WmmaGemmModel
  | "v100" => .ok .v100 | "ampere" => .ok .ampere | "hopper" => .ok .hopper
  | _ => .error "Expected model v100, ampere, or hopper"


end TensorCore.Cli.GemmInput
