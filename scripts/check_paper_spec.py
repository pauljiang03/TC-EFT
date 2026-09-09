#!/usr/bin/env python3
"""Build the independent paper specification, universal proofs, and negative controls.

The compiled dependency audit checks every declaration in the independent modules.
The deliberately contaminated proposition tests the audit's transitive rejection,
including dependencies in propositions rather than just executable return values.
"""
from pathlib import Path
import hashlib
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def run(args, source=None):
    return subprocess.run(args, cwd=ROOT, input=source, text=True, capture_output=True)


def main():
    build = run(['lake', 'build', 'TensorCore.Regression.Specification.Audit'])
    if build.returncode:
        raise RuntimeError(build.stdout + build.stderr)
    audit = run(['lake', 'env', 'lean', 'scripts/lean/PaperSpecAudit.lean'])
    if audit.returncode:
        raise RuntimeError(audit.stdout + audit.stderr)
    declarations = re.search(r'paper_spec_audit: (\d+) specification declarations', audit.stdout)
    roots = re.search(r'paper_proof_audit: (\d+) theorem roots', audit.stdout)
    assert declarations and roots, audit.stdout
    contaminated = '''import TensorCore.Regression.Specification.Audit
def hiddenImplementationCall (x : Rat) := TensorCore.round32 .towardZero x
def contaminatedProposition (x : Rat) (b : BitVec 32) : Prop :=
  hiddenImplementationCall x = some b
run_cmd TensorCore.PaperSpec.Audit.check ``contaminatedProposition
'''
    negative = run(['lake', 'env', 'lean', '--stdin'], contaminated)
    failure = negative.stdout + negative.stderr
    assert negative.returncode != 0, 'Contaminated specification was accepted'
    assert 'Paper specification has forbidden dependencies' in failure, failure
    assert 'TensorCore.round32' in failure, failure
    contaminated_matrix = '''import TensorCore.Regression.Specification.Audit
def hiddenMatrixSchedule := TensorCore.gemmInstructions
def contaminatedMatrixSchedule := hiddenMatrixSchedule
run_cmd TensorCore.PaperSpec.Audit.check ``contaminatedMatrixSchedule
'''
    negative_matrix = run(['lake', 'env', 'lean', '--stdin'], contaminated_matrix)
    failure_matrix = negative_matrix.stdout + negative_matrix.stderr
    assert negative_matrix.returncode != 0, 'Implementation-dependent matrix schedule was accepted'
    assert 'Paper specification has forbidden dependencies' in failure_matrix, failure_matrix
    assert 'TensorCore.gemmInstructions' in failure_matrix, failure_matrix
    contaminated_scalar = """import TensorCore.Regression.Specification.Audit
def hiddenScalarStage := TensorCore.ConversionStage.convert
def contaminatedScalar := hiddenScalarStage
run_cmd TensorCore.PaperSpec.Audit.check ``contaminatedScalar
"""
    negative_scalar = run(['lake', 'env', 'lean', '--stdin'], contaminated_scalar)
    failure_scalar = negative_scalar.stdout + negative_scalar.stderr
    assert negative_scalar.returncode != 0, 'Implementation-dependent scalar stage was accepted'
    assert 'Paper specification has forbidden dependencies' in failure_scalar, failure_scalar
    assert 'TensorCore.ConversionStage.convert' in failure_scalar, failure_scalar
    sources = sorted((ROOT / 'TensorCore/TC/Specification').glob('*.lean')) + sorted((ROOT / 'TensorCore/Gemm/Specification').glob('*.lean')) + sorted((ROOT / 'TensorCore/Regression/Specification').glob('*.lean')) + [ROOT / 'scripts/lean/PaperSpecAudit.lean',
        ROOT / 'TensorCore/Gemm/Regression/GemmSpecification.lean', ROOT / 'examples/GemmSpecification.lean',
        ROOT / 'TensorCore/Regression/FoundationCompletion.lean', ROOT / 'examples/FoundationCompletion.lean',
        Path(__file__)]
    for source in sources:
        if source.suffix != '.lean':
            continue
        assert not re.search(r'\b(sorry|admit|axiom|native_decide|ofReduceBool|skipKernelTC)\b',
                             source.read_text()), source
    report = dict(
        status='passed',
        theorem='TensorCore.PaperSpec.supported_eq_paper',
        generic_theorem='TensorCore.PaperSpec.implementation_eq_paper',
        supported_paths=8,
        scope='FP16/BF16/packed-TF32 inputs; FP32 c/output; finite reference domain; one group and ordered group lists',
        all_encoded_inputs_including_rejections=True,
        independent_validity_success_proved=True,
        signed_zero_bit_uniqueness_proved=True,
        padded_tf32_register_bridge=True,
        adequate_machine_accumulator_bridge=True,
        all_intermediate_schedule_bits_proved=True,
        matrix_theorem='TensorCore.PaperSpec.gemm_eq_paper',
        matrix_bits_theorem='TensorCore.PaperSpec.gemmBits_eq_paper',
        scaled_pipeline_contract='TensorCore.PaperSpec.convertedGemmCheck_paper_sound',
        independent_scalar_theorem='TensorCore.PaperSpec.scalarRound_eq',
        complete_scaled_theorem='TensorCore.PaperSpec.scaledGemm_eq_independent',
        complete_converted_theorem='TensorCore.PaperSpec.convertedGemm_eq_independent',
        native_scaled_theorem='TensorCore.PaperSpec.nativeScaledGemm_eq_independent',
        native_converted_theorem='TensorCore.PaperSpec.nativeConvertedGemm_eq_independent',
        native_schedules=5,
        independent_scalar_specification=True,
        complete_pipeline_success_and_rejection_equivalence=True,
        scalar_dependency_negative_control_rejected=True,
        matrix_scope='Arbitrary dimensions; three FP16 WMMA profiles; direct row/column reference; zero-padded k=16 instructions; every group/instruction output; rejection as none',
        independent_matrix_schedule=True,
        matrix_rejection_equivalence=True,
        scaled_pipeline_input_conversion_and_four_scalar_contracts=True,
        scalar_contract_range_and_sign=True,
        specification_declarations_audited=int(declarations.group(1)),
        theorem_roots_audited=int(roots.group(1)),
        dependency_negative_control_rejected=True,
        matrix_dependency_negative_control_rejected=True,
        semantic_negative_controls=['premature_product_normalization', 'per_term_ieee_rtz_alignment',
                                    'ampere_bf16_floor_removal', 'hopper_bf16_floor_removal', 'group_reversal'],
        boundary_controls=['negative_underflow_signed_zero', 'all_zero_plus_zero', 'nonfinite_rejection'],
        matrix_controls=['rectangular_original_indexing', 'all_three_instruction_group_counts',
                         'empty_k_signed_zero_and_nonfinite_c', 'empty_output_dimensions',
                         'instruction_order_changes_bits', 'both_output_tile_boundaries',
                         'accepted_original_source_certificate'],
        axioms_allowed=['propext', 'Classical.choice', 'Quot.sound'],
        source_sha256={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
        limitations=['Paper-to-formula correspondence remains a human review obligation',
                     'Specification output selection is mathematical/noncomputable',
                     'No physical GPU conformance or full encoded hardware pipeline theorem',
                     'No FP16-output stage-order resolution or independent FP8 path',
                     'The independently specified scalar sequence is the project pipeline, not an additional hardware rule attributed to the papers',
                     'Rejections agree as none; implementation-specific error tags are not part of the independent specification'],
    )
    (ROOT / 'data/regressions/paper-spec-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
