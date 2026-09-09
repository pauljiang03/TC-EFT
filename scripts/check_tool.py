#!/usr/bin/env python3
"""Check the public launcher, JSONL protocol, and legacy output compatibility."""

import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT
TOOL = REPO / "tc"
BINARY = ROOT / ".lake/build/bin/tc_gemm"


def run(command, *, text=None, cwd=ROOT, code=0):
    result = subprocess.run([str(x) for x in command], input=text, cwd=cwd,
                            text=True, capture_output=True)
    assert result.returncode == code, (command, result.returncode, result.stdout, result.stderr)
    return result


def main():
    (ROOT / "data/regressions/tool-report.json").write_text('{"status":"running"}\n')
    run(["lake", "build", "tc_gemm", "tc_bounded_eft"])
    help_text = run([TOOL, "--help"]).stdout
    assert all(name in help_text for name in ["doctor", "build", "review", "audit", "check", "gemm", "schema", "trace", "eft"])
    run([TOOL, "gemm", "--help"])
    assert "0.1.0" in run([TOOL, "--version"]).stdout
    doctor = json.loads(run([TOOL, "doctor", "--json"]).stdout)
    assert doctor["ready"] and not doctor["cuda_required"]
    schema = json.loads(run([TOOL, "schema"]).stdout)
    assert schema == json.loads((ROOT / "data/schemas/gemm.schema.json").read_text())

    cases_file = ROOT / "data/examples/gemm.jsonl"
    cases = cases_file.read_text()
    legacy = run(["lake", "env", "lean", "--run", "examples/GemmExtensions.lean", cases_file]).stdout
    assert run([BINARY, cases_file]).stdout == legacy
    assert run([BINARY, "-"], text="\n  \n" + cases).stdout == legacy
    assert run([BINARY, "-"], text="\n \t\n").stdout == ""
    with tempfile.TemporaryDirectory(prefix="tc public cli ") as directory:
        path = Path(directory) / "cases with spaces.jsonl"
        path.write_text(cases)
        assert run([TOOL, "gemm", path.name], cwd=directory).stdout == legacy
        assert run([TOOL, "gemm", "-"], text=cases, cwd=directory).stdout == legacy
        missing = run([TOOL, "gemm", "missing.jsonl"], cwd=directory, code=2)
        assert not missing.stdout and "Input file does not exist" in missing.stderr
        raw = ROOT / "data/examples/gemm.raw.jsonl"
        old_raw = run(["lake", "env", "lean", "--run", "examples/Gemm.lean", raw]).stdout
        assert run([BINARY, raw]).stdout == old_raw
        raw_output = json.loads(old_raw)
        assert raw_output["rows"][0][0]["bits"] == 1073741824

    valid = next(request for request in map(json.loads, cases.splitlines()) if request["k"] > 0)
    mutations = [{"model": "unknown"}, {"a": []}, {"a": [2**64]},
                 {"input_mode": "invalid"}, {"m": -1}, {"operation": "invalid"}]
    for change in mutations:
        request = {**valid, **change}
        result = run([BINARY, "-"], text=json.dumps(request) + "\n", code=2)
        error = json.loads(result.stderr)
        assert not result.stdout and error["error"] == "invalid_request" and error["line"] == 1
    result = run([BINARY, "-"], text=cases.splitlines()[0] + "\n{bad json}\n", code=2)
    assert len(result.stdout.splitlines()) == 1
    assert json.loads(result.stderr)["line"] == 2
    missing = run([BINARY, "/nonexistent/tc-cases.jsonl"], code=2)
    assert not missing.stdout and json.loads(missing.stderr)["error"] == "io_error"

    eft = json.loads(run([TOOL, "eft", ROOT / "data/examples/eft.txt"]).stdout)
    assert eft["bits"] == 1073741824, eft
    readme = (REPO / "README.md").read_text()
    assert "\u2014" not in readme
    for link in re.findall(r'\]\(([^)]+)\)', readme):
        if "://" not in link and not link.startswith("#"):
            assert (REPO / link.split("#", 1)[0]).exists(), link
    assert readme.count("<details>") == readme.count("</details>")
    sources = [TOOL, REPO / "README.md", ROOT / "Main/Gemm.lean",
               ROOT / "TensorCore/Gemm/Cli/Gemm.lean", ROOT / "lakefile.toml",
               ROOT / "data/schemas/gemm.schema.json", ROOT / "data/examples/gemm.raw.jsonl",
               ROOT / "data/examples/eft.txt", Path(__file__).resolve()]
    report = {"status": "passed", "legacy_scaled_cases": len(cases.splitlines()),
              "legacy_raw_agreement": True, "stdin_file_agreement": True,
              "paths_with_spaces": True, "parse_error_controls": len(mutations) + 1,
              "io_error_controls": 2, "exact_raw_and_eft_example": True,
              "stdout_json_only": True, "readme_local_links": True,
              "source_sha256": {str(p.relative_to(REPO)): hashlib.sha256(p.read_bytes()).hexdigest()
                                for p in sources}}
    (ROOT / "data/regressions/tool-report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
