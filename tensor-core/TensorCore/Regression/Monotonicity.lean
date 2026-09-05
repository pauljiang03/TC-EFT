import TensorCore.Theory.Monotonicity
import TensorCore.Regression.Cases

/-! TC-EFT Theorem III.4 on the three source FP16 paths, and the Table III witnesses. -/

namespace TensorCore

def halfDecoded (e : Int) : Decoded := ⟨1024, e, 10⟩

/-- V100 family: any `K < 2^24` products `2^-12 · 2^-12`. Non-monotone exactly when `K ≥ 3`. -/
theorem nonmonotone_v100_family (K : Nat) (hK : K < 2 ^ 24) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0c00), 0x3f800000⟩ :
        BlockInput (fp16Fp32Profile K 0 none)) = .ok t ∧
      evalBlock (⟨List.replicate K (0x0c00, 0x0c00), 0x3f7fffff⟩ :
        BlockInput (fp16Fp32Profile K 0 none)) = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ 0 ≤ K) :=
  nonmonotone_encoded K 0 none (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-12))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK

/-- Ampere family: one extra alignment bit, floor `−132`, products `2^-12 · 2^-13`.
Non-monotone exactly when `K ≥ 6`. -/
theorem nonmonotone_ampere_family (K : Nat) (hK : K < 2 ^ 25) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0800), 0x3f800000⟩ :
        BlockInput (fp16Fp32Profile K 1 (some (-132)))) = .ok t ∧
      evalBlock (⟨List.replicate K (0x0c00, 0x0800), 0x3f7fffff⟩ :
        BlockInput (fp16Fp32Profile K 1 (some (-132)))) = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ 1 ≤ K) :=
  nonmonotone_encoded K 1 (some (-132)) (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-13))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0800).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK

/-- Hopper family: two extra alignment bits, floor `−133`, products `2^-12 · 2^-14`.
Non-monotone exactly when `K ≥ 12`. -/
theorem nonmonotone_hopper_family (K : Nat) (hK : K < 2 ^ 26) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0400), 0x3f800000⟩ :
        BlockInput (fp16Fp32Profile K 2 (some (-133)))) = .ok t ∧
      evalBlock (⟨List.replicate K (0x0c00, 0x0400), 0x3f7fffff⟩ :
        BlockInput (fp16Fp32Profile K 2 (some (-133)))) = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ 2 ≤ K) :=
  nonmonotone_encoded K 2 (some (-133)) (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-14))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0400).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK

namespace Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

/-- TC-EFT Table III: the source block widths `K = 4, 8, 16` all exceed `3·2^p`, and
decreasing the accumulator from `3f800000` to `3f7fffff` raises the output to `3f800001`. -/
theorem table_iii_witnesses :
    outputBits (⟨List.replicate 8 (0x0c00, 0x0800), 0x3f800000⟩ : BlockInput ampereF16F32) =
      .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 8 (0x0c00, 0x0800), 0x3f7fffff⟩ : BlockInput ampereF16F32) =
      .ok 0x3f800001 ∧
    outputBits (⟨List.replicate 16 (0x0c00, 0x0400), 0x3f800000⟩ : BlockInput hopperF16F32) =
      .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 16 (0x0c00, 0x0400), 0x3f7fffff⟩ : BlockInput hopperF16F32) =
      .ok 0x3f800001 := by decide +kernel

/-- Below the threshold the perturbation is monotone: two V100 products (`K = 2 < 3`)
leave the output at `1`, and eleven Hopper products (`K = 11 < 12`) do too. -/
theorem below_threshold_monotone :
    outputBits (⟨List.replicate 2 (0x0c00, 0x0c00), 0x3f7fffff⟩ :
      BlockInput (fp16Fp32Profile 2 0 none)) = .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 11 (0x0c00, 0x0400), 0x3f7fffff⟩ :
      BlockInput (fp16Fp32Profile 11 2 (some (-133)))) = .ok 0x3f800000 := by decide +kernel

end Regression

end TensorCore
