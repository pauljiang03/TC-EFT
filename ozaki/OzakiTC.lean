import OzakiTC.Exactness
import OzakiTC.Engine
import OzakiTC.Profiles
import OzakiTC.Rounding
import OzakiTC.Split32
import OzakiTC.Schemes
import OzakiTC.Limits
import OzakiTC.Int8
import OzakiTC.ADP
import OzakiTC.Success
import OzakiTC.Scaling
import OzakiTC.Checks
import OzakiTC.Correct
import OzakiTC.Native
import OzakiTC.LongDot
import OzakiTC.TwoPass

/-! # The Ozaki schemes on the NVIDIA Tensor Core model

The engine of the `Ozaki` library built from the block model of `TensorCore`, its exactness on
every supported GPU path, the binary32 σ-trick, Ozaki-I and Ozaki-II with binary32
recombination, and Ozaki-I on an INT8 engine modelled by the fixed-width register (ADP). -/
