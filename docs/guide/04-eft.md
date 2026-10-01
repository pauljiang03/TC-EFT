# TC-EFT: extraction and correction

EFT extraction takes encoded operands and any finite supplied FP32 word D. It reconstructs the exact input sum and corrects D without rerunning the TC model or assuming that D is the model's output.

## Follow the overlap identity

For exact terms Tᵢ, choose the extraction grid as the coarser of the alignment grid and D's FP32 grid. Split each term into a coarse part hᵢ and a low part εᵢ. Let H be the sum of coarse parts and εₒ = D - H. Then:

```text
S = D - εₒ + Σ εᵢ = H + Σ εᵢ
```

[Extraction.lean](../../TensorCore/EFT/Extraction.lean) proves this identity and the guarded scalar procedure. [ExtractionGrid.lean](../../TensorCore/EFT/ExtractionGrid.lean) gives the chosen-grid and input-budget results.

The scalar procedure sequentially adds the low parts in FP32, computes D - εₒ in FP32, and performs one final nearest-even addition. Its sufficient predicate checks that the support-grid exponent lies between -149 and 104, residual coefficients are exact integers with total absolute sum below `2^24`, D/εₒ/H are representable in FP32, and the final sum is within finite FP32 range. These premises justify exact intermediate operations. A failed predicate makes the scalar helper return `none`.

The deterministic support-grid choice is conservative. The chosen-grid theorems permit other valid common grids; source identifiers containing `eq20` denote the manuscript's input-budget inequality numbered (17).

## Execute a correction

```lean
import TensorCore.EFT.Encoded

open TensorCore

def tiny : BlockInput v100F16F32 :=
  ⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f800000⟩

#eval (algorithm1Encoded tiny 0x3f800000).map fun r => r.bits.map BitVec.toNat

example : algorithm1Encoded tiny 0x3f800000 =
    .ok (.consolidated (.scalar 0x3f800002)) := by decide +kernel
```

The supplied D is the FP32 word for one. Each exact product is `2^-24`, so the exact input sum is `1 + 2^-22`. The calculation prints `Except.ok (some 1065353218)`, whose output word is `0x3f800002`. The proof checks both that word and the scalar branch tag.

## Reference and bounded execution

| Layer | Entry point | Consolidation |
| --- | --- | --- |
| Reference | `algorithm1Encoded` | Guarded FP32 scalar branch, otherwise exact-rational consolidation and one RNE conversion |
| Bounded | `EFMachine.algorithm1` | Fixed 576-bit workspace, guarded FP32 scalar branch, otherwise bounded exact consolidation |
| Native scalar refinement | `EFMachine.algorithm1WithLean` | Same bounded algorithm with Lean native FP32 scalar additions |
| Independent FloatLib | `TCFloat.Paper.eftChecked` | FloatLib scalar operations and reference exact fallback |

`EFMachine.algorithm1_agrees` preserves the returned bits of the reference algorithm under its premises. The bounded and reference fallback branch names may differ. `algorithm1WithLean_eq` preserves the entire bounded result, including tags and errors. FloatLib's `paper_one_to_one` preserves the complete checked reference TC/EFT observations for every encoded input in its profile family.

```lean
import TensorCore.EFT
import TensorCore.Kernels.EFT

open TensorCore

#check overlap_recovery
#check scalarCorrected_correct
#check ExtractionGrid.eq20_scalarPredicate
#check algorithm1Encoded_correct
#check EFMachine.algorithm1_success
#check EFMachine.algorithm1_range_iff
#check EFMachine.algorithm1_agrees
#check EFMachine.algorithm1WithLean_eq
```

[BoundedEFT.lean](../../examples/BoundedEFT.lean) runs a BF16 cancellation case with a supplied D unrelated to the exact ideal, then applies the universal success contract. [ScalarEFT.lean](../../examples/ScalarEFT.lean) shows correction with FP64 intermediates and a final FP32 output.

Next: [how the executable tests work](05-executable-tests.md).
