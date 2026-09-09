-- TC-EFT extraction, consolidation, and bounded execution.

import TensorCore.EFT.Algorithm1
import TensorCore.EFT.Bounded
import TensorCore.EFT.Defs
import TensorCore.EFT.Encoded
import TensorCore.EFT.Extraction
import TensorCore.EFT.ExtractionGrid
import TensorCore.EFT.Machine.BitScan
import TensorCore.EFT.Machine.BitScanDefs
import TensorCore.EFT.Machine.Correctness
import TensorCore.EFT.Machine.Cost
import TensorCore.EFT.Machine.Decode
import TensorCore.EFT.Machine.DecodeDefs
import TensorCore.EFT.Machine.Dyadic
import TensorCore.EFT.Machine.Extraction
import TensorCore.EFT.Machine.Grid
import TensorCore.EFT.Machine.Preparation
import TensorCore.EFT.Machine.Refinement
import TensorCore.EFT.Machine.Round
import TensorCore.EFT.Machine.Scalar
import TensorCore.EFT.Machine.Split
import TensorCore.EFT.Machine.SplitDefs
import TensorCore.EFT.Machine.Success
import TensorCore.EFT.Machine.Word
import TensorCore.EFT.Machine.WordDefs
import TensorCore.EFT.Native
import TensorCore.EFT.Scalar
