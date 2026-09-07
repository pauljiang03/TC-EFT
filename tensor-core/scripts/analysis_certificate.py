"""Canonical data and kernel proofs for GEMM analysis certificates."""

from fractions import Fraction
import json


HEADER = "-- tc-certificate-v2: "
FORMATS = {"fp16": 16, "bf16": 16, "fp32": 32, "fp64": 64}
MODES = {"rne": "nearestEven", "rtz": "towardZero", "rdn": "towardNegative", "rup": "towardPositive"}
SCALED_FIELDS = {"input_format", "output_format", "input_mode", "multiply_mode", "add_mode", "output_mode", "alpha", "beta"}
BASE_FIELDS = {"model", "m", "n", "k", "tolerance", "witness"}


def natural(value, label, limit=None):
    if type(value) is not int or value < 0 or (limit is not None and value >= limit):
        raise ValueError(f"Invalid {label}")
    return value


def integer(value):
    if type(value) is not int:
        raise ValueError("Expected an integer witness")
    return str(value)


def rational(value):
    if type(value) is not str:
        raise ValueError("Expected a rational string")
    q = Fraction(value)
    if q < 0:
        raise ValueError("Expected a nonnegative rational")
    return f"({q.numerator} / {q.denominator})"


def vector(values):
    return "#v[" + ", ".join(values) + "]"


def matrix(values, rows, cols, width):
    if type(values) is not list or len(values) != rows * cols:
        raise ValueError("Certificate matrix shape mismatch")
    words = [str(natural(x, "encoded word", 2 ** width)) for x in values]
    return vector([vector(words[i * cols:(i + 1) * cols]) for i in range(rows)])


def group_witness(groups):
    if type(groups) is not list:
        raise ValueError("Invalid group witness")
    result = []
    for group in groups:
        if type(group) is not dict or set(group) != {"scale", "output_scale"}:
            raise ValueError("Invalid group witness")
        result.append(f"⟨{integer(group['scale'])}, {integer(group['output_scale'])}⟩")
    return "[" + ", ".join(result) + "]"


def scaled_witness(cell):
    if type(cell) is not dict or set(cell) != {"groups", "alpha_scale", "beta_scale", "sum_scale", "output_scale"}:
        raise ValueError("Invalid scaled witness")
    scales = ", ".join(integer(cell[key]) for key in ("alpha_scale", "beta_scale", "sum_scale", "output_scale"))
    return "⟨" + group_witness(cell["groups"]) + ", ⟨" + scales + "⟩⟩"


def witness_matrix(witness, m, n, render):
    if type(witness) is not list or len(witness) != m:
        raise ValueError("Certificate witness shape mismatch")
    rows = []
    for row in witness:
        if type(row) is not list or len(row) != n:
            raise ValueError("Certificate witness shape mismatch")
        rows.append(vector([render(cell) for cell in row]))
    return vector(rows)


def family_witness(w):
    if type(w) is not dict or set(w) != {"accumulator_scale", "product_scale", "carry_bits", "initial_bound"}:
        raise ValueError("Invalid family witness")
    return (f"⟨{integer(w['accumulator_scale'])}, {integer(w['product_scale'])}, "
            f"{natural(w['carry_bits'], 'carry bits')}, {rational(w['initial_bound'])}⟩")


def certificate_text(manifest):
    if type(manifest) is not dict or set(manifest) != {"theory_sha256", "cases"} or type(manifest["cases"]) is not list:
        raise ValueError("Invalid certificate manifest")
    if not manifest["cases"]:
        raise ValueError("A certificate must contain at least one request")
    lines = [HEADER + json.dumps(manifest, sort_keys=True, separators=(",", ":")),
             "import TensorCore.Programs.ConvertedGemmAnalysis", "import TensorCore.Programs.GemmFamily",
             "import TensorCore.Programs.GemmSelection", "",
             "namespace TensorCore.Certificate", "", "set_option maxRecDepth 32768",
             "set_option maxHeartbeats 64000000", ""]
    for index, case in enumerate(manifest["cases"]):
        if type(case) is not dict:
            raise ValueError("Invalid certificate case")
        kind = case.get("kind", "raw")
        if kind == "selection":
            from selection_certificate import render_selection
            lines += render_selection(case, index)
            continue
        expected = BASE_FIELDS | ({"a", "b", "c"} if kind != "family" else {"kind", "a_bound", "b_bound", "c_bound"})
        if kind == "scaled":
            expected |= SCALED_FIELDS | {"kind"}
        if kind not in {"raw", "scaled", "family"} or set(case) != expected:
            raise ValueError("Invalid certificate case")
        model = case["model"]
        if model not in {"v100", "ampere", "hopper"}:
            raise ValueError("Invalid certificate model")
        m, n, k = [natural(case[x], x) for x in ("m", "n", "k")]
        lines += [f"def tolerance{index} : Rat := {rational(case['tolerance'])}"]
        if kind == "family":
            bounds = ", ".join(rational(case[key]) for key in ("a_bound", "b_bound", "c_bound"))
            lines += [f"def family{index} : GemmFamily := ⟨{bounds}⟩",
                      f"def w{index} : GemmBoundConfig := {family_witness(case['witness'])}", "",
                      f"theorem checked{index} : familyCheck .{model} {k} family{index} w{index} tolerance{index} = true := by decide +kernel", "",
                      f"theorem accuracy{index} : GemmFamilyAccurate .{model} family{index} {m} {n} {k} tolerance{index} :=",
                      f"  familyCheck_sound .{model} family{index} w{index} {m} {n} {k} tolerance{index} checked{index}", ""]
            continue
        if kind == "raw":
            word_type, width, witness_type = "F16", 16, "List GroupWitness"
            witness = witness_matrix(case["witness"], m, n, group_witness)
        else:
            source, target = case["input_format"], case["output_format"]
            if source not in FORMATS or target not in FORMATS:
                raise ValueError("Invalid certificate format")
            modes = [case[key] for key in ("input_mode", "multiply_mode", "add_mode", "output_mode")]
            if any(mode not in MODES for mode in modes):
                raise ValueError("Invalid certificate rounding mode")
            im, mm, am, om = [MODES[mode] for mode in modes]
            lines += [f"def cfg{index} : GemmEpilogue := ⟨.{mm}, .{am}, ⟨{target}, .{om}⟩⟩",
                      f"def alpha{index} : F32 := {natural(case['alpha'], 'alpha', 2 ** 32)}",
                      f"def beta{index} : F32 := {natural(case['beta'], 'beta', 2 ** 32)}"]
            word_type, width, witness_type = f"(BitVec {source}.width)", FORMATS[source], "ScaledWitness"
            witness = witness_matrix(case["witness"], m, n, scaled_witness)
        lines += [f"def a{index} : DenseMatrix {word_type} {m} {k} := {matrix(case['a'], m, k, width)}",
                  f"def b{index} : DenseMatrix {word_type} {k} {n} := {matrix(case['b'], k, n, width)}",
                  f"def c{index} : DenseMatrix F32 {m} {n} := {matrix(case['c'], m, n, 32)}",
                  f"def w{index} : DenseMatrix ({witness_type}) {m} {n} := {witness}", ""]
        if kind == "raw":
            args = f".{model} a{index} b{index} c{index}"
            checker, contract, proof = "gemmAnalysisCheck", "GemmAccurate", "gemmAnalysisCheck_sound"
        else:
            args = f"{source} .{im} .{model} cfg{index} alpha{index} beta{index} a{index} b{index} c{index}"
            checker, contract, proof = "convertedAnalysisCheck", "ConvertedGemmAccurate", "convertedAnalysisCheck_sound"
        lines += [f"theorem checked{index} : {checker} {args}",
                  f"    w{index} tolerance{index} = true := by decide +kernel", "",
                  f"theorem accuracy{index} : {contract} {args} tolerance{index} :=",
                  f"  {proof} {args} w{index} tolerance{index} checked{index}", ""]
    return "\n".join(lines + ["end TensorCore.Certificate", ""])
