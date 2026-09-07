#!/usr/bin/env python3
"""Build the independent probe against the freshly built repository modules."""
from pathlib import Path
import shlex
import subprocess

here = Path(__file__).resolve().parent
project = here.parents[1] / "tensor-core"
subprocess.run(["lake", "build"], cwd=project, check=True)
subprocess.run(["lake", "env", "lean", "-R", str(here), "-c", str(here / "Probe.c"),
                str(here / "Probe.lean")], cwd=project, check=True)
arguments = shlex.split((project / ".lake/build/bin/tc_gemm.rsp").read_text())
arguments = [a for a in arguments if not a.endswith("/GemmMain.c.o.export")]
subprocess.run(["lake", "env", "leanc", "-O2", "-o", str(here / "probe"),
                str(here / "Probe.c"), *arguments], cwd=project, check=True)
