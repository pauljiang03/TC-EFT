-- Gemm Selection for the executable examples.

import TensorCore.Gemm.Selection

open TensorCore

set_option maxRecDepth 32768
set_option maxHeartbeats 64000000

def workload : GemmProblem 1 1 17 :=
  .raw #v[Vector.replicate 17 0x0c00] (Vector.replicate 17 #v[0x0c00]) #v[#v[0x3f800000]]

def candidates : List GemmCandidate := [{model := .v100}, {model := .ampere}, {model := .hopper}]

theorem choice : selectGemm workload candidates (1 / 1000000) = some 1 := by decide +kernel

example : workload.Accurate {model := .ampere} (1 / 1000000) :=
  selectGemm_accuracy workload candidates (1 / 1000000) 1 {model := .ampere} choice (by decide +kernel)

example : ∃ hi : 1 < candidates.length, workload.Accurate candidates[1] (1 / 1000000) ∧
    ∀ j (hj : j < 1), candidateCertified workload (1 / 1000000) candidates[j] = false :=
  selectGemm_sound workload candidates (1 / 1000000) 1 choice
