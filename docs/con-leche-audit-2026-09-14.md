# Con-leche audit of Tensor Core Arithmetic

Date: 14 September 2026. Audited source commit: [`9b42a432389faf169720e1ff6e38b16e35b3af8b`](https://github.com/pauljiang03/tensor-core-arithmetic/tree/9b42a432389faf169720e1ff6e38b16e35b3af8b).

Subsequent scope change: FP16-output tensor-core candidates and all FP8 work were
moved to [`wip/`](../wip/README.md). The counts and evidence below describe the
pinned revision above, which included that work. They do not claim a new audit of
the reorganized tree.

**Confirmed: the actual con-leche executable ran locally and accepted the project's exported proofs in verified mode. A second run from a fresh export also passed.** Both exports were byte-for-byte identical.

This is strong additional evidence that the checked proof terms are valid under the supported logic and its assumptions. It is not an unconditional guarantee that the repository has no mistakes. The audit does not establish that the formal specifications accurately describe physical tensor cores.

Prepared by Codex from local command execution, saved logs, source inspection, and hash comparisons. The independent component is the external proof checker. This report is not an independent human review.

## 1. Evidence that the tool actually ran

The checker was built from the official con-leche repository. Its build completed successfully with 142 Lake build jobs. The executable then read a 102,976,871-byte Lean export and returned process exit code `0`.

The original command was:

```sh
/private/tmp/tc-con-leche-audit/con-leche/.lake/build/bin/con-leche \
  --verified --jobs=4 --progress=2000 \
  /private/tmp/tc-con-leche-audit/tensorcore-theorems.ndjson
```

The original log ends with:

```text
con-leche: check done: 13320/13320 t=29.8s (check 28.0s)
con-leche: done: parse 0.2s, install 1.5s, check 28.0s, 4 workers t=29.8s
con-leche: accepted 13603 declarations (--verified)
```

| Evidence | Original run | Confirmation run |
| --- | --- | --- |
| Mode | `--verified` | `--verified` |
| Worker threads | 4 | 4 |
| Process exit code | 0 | 0 |
| Accepted input declaration records | 13,603 | 13,603 |
| Completed deferred checks | 13,320 of 13,320 | 13,320 of 13,320 |
| Time reported by the checker | 29.8 seconds | 29.1 seconds |
| Selected project theorem roots | 5,619 | 5,619 |
| Export content | Original | Identical to original |

The original Python wrapper measured 29.861 seconds for the checker process. Its export step took 6.137 seconds. These measurements exclude building the checker and the project.

Before confirmation, the saved hashes were checked against the current export, checker binary, exporter binary, and all 219 recorded library and build files. The confirmation rebuilt the library through Lake, collected the roots again, exported them again, and ran the checker again. The root list and export matched the originals exactly. See the [original log](../reviews/2026-09-14-con-leche/check-original.log), [confirmation log](../reviews/2026-09-14-con-leche/check-confirmation.log), and [confirmation metadata](../reviews/2026-09-14-con-leche/confirmation.json).

## 2. What con-leche does

Lean turns a proof into a structured mathematical expression called a proof term. A theorem has a declared proposition, and its proof term must have that proposition as its type. Tactics such as `simp`, `omega`, and `grind` generate these terms. Checking the terms does not require trusting each tactic's reasoning.

Con-leche checks exported declarations using its own checker implementation and term representation. It reads the theorem statements, proof bodies, definitions, types, and dependencies from a Lean export. It does not simply read an earlier Lean success message. The [upstream implementation description](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/README.md#design-of-the-checker-implementation) describes this separation.

The main stages are:

1. **Parse the export.** Read names, expressions, universe levels, and declarations into the checker's representation.
2. **Install and validate declarations.** Reconstruct the environment, check foundational declarations and inductive structures, and record checks for definition and theorem bodies.
3. **Check the recorded bodies.** Check their types against their declarations, including dependencies, binding, universe information, and the reductions and equalities used during checking.
4. **Return a verdict.** A successful verified-mode result requires all scheduled checks to complete successfully. Unsupported features, invalid declarations, and internal failures have different failure outcomes.

Some inductive types require an internally generated model. In this export, the checker generated 30 records for `Lean.Syntax` and checked those records too. This accounts for most of the difference between input and prepared record counts. The [driver source](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/Main.lean) defines these stages and verdicts.

This checks mathematical proof terms. It does not sample numerical inputs or search the repository for contradictions. A checked universal theorem retains its stated scope over all inputs satisfying its hypotheses. A checked regression theorem about one concrete example still concerns that example.

## 3. Exactly what was checked

### Root selection

The [collector](../reviews/2026-09-14-con-leche/CollectTheorems.lean) imported `TensorCore.All`. The repository's module-layout check confirmed that this import reaches all 216 library modules.

It selected every compiled theorem whose declaring module is `TensorCore` or a module below `TensorCore`. Selection used the declaration's owning module, so it also included project-owned theorems outside the `TensorCore` namespace. It did not exclude private names or compiler-generated proof declarations.

This produced **5,619 theorem roots**, including the **2,354 public TensorCore roots** counted by the existing axiom audit. The larger number includes private and generated proofs. It should not be read as 5,619 separately authored mathematical claims.

The exporter included these roots and their transitive dependencies. A separate parse of the export found **zero missing selected roots**. The [complete root list](../reviews/2026-09-14-con-leche/theorem-roots.txt), [module list](../reviews/2026-09-14-con-leche/modules.txt), and [coverage summary](../reviews/2026-09-14-con-leche/coverage.json) are committed with this report.

### Coverage by module family

| Module family | Imported modules | Selected theorem roots | Public TensorCore roots |
| --- | ---: | ---: | ---: |
| Core arithmetic, encodings, and rounding | 32 | 1,028 | 357 |
| Tensor-core operations and contracts | 71 | 1,600 | 740 |
| EFT and bounded execution | 34 | 852 | 377 |
| GEMM and certificates | 54 | 1,240 | 549 |
| IEEE scalar arithmetic and native bridges | 15 | 844 | 313 |
| Shared regression and specification modules | 3 | 55 | 18 |
| Aggregate imports, CLI, and metaprogramming modules | 7 | 0 | 0 |
| **Total** | **216** | **5,619** | **2,354** |

Each family includes its own regression modules. Imported modules with no theorem roots are included in the module census; that does not mean all their executable code was checked. Definitions were included when reached from selected theorem statements or proof bodies. See the [module-family census](../reviews/2026-09-14-con-leche/scope.json).

### Exported records

| Record kind | Count |
| --- | ---: |
| Theorems, including dependency theorems | 9,154 |
| Definitions | 4,151 |
| Inductive groups | 289 |
| Quotient records | 4 |
| Opaque declarations | 2 |
| Axioms | 3 |
| **Total input declaration records** | **13,603** |

The additional theorem records are dependencies outside the selected project roots. Inductive groups can contain several types, constructors, and recursors, so these figures count export records rather than every individual named constant.

The checker prepared 13,634 records: the 13,603 input records, 30 generated model records, and one synthesized prelude record. It completed installation and all 13,320 deferred checks. Some declaration checks occur during installation, which explains why the deferred-check count is smaller than the prepared-record count.

### Axioms and proof shortcuts

The export contained exactly these axioms:

| Axiom | Meaning |
| --- | --- |
| `propext` | Logically equivalent propositions are equal. |
| `Classical.choice` | An element can be selected from a type known to be nonempty. |
| `Quot.sound` | Related representatives are equal in the corresponding quotient. |

No `sorryAx`, custom axiom, or compiled-reflection axiom appeared in the export. The export inspection found no unsafe or partial definition records. These observations concern the checked export. They do not assert that every runtime dependency or metaprogram in the repository was exported.

The existing `python3 scripts/check_axioms.py` audit also passed. It reported 2,354 public theorem roots, only the standard axioms, and no prohibited proof shortcuts in the source files it scans. Its [saved output](../reviews/2026-09-14-con-leche/axiom-audit.log) and the [module-layout result](../reviews/2026-09-14-con-leche/layout-audit.json) are included. That audit and con-leche answer different questions: the axiom audit inventories assumptions; con-leche also checks the exported proof terms.

## 4. Examples of what the result means for this project

These are examples from the checked root list. They illustrate coverage; they are not a separate sample used in place of checking all roots.

| Checked theorem | What its checked statement establishes |
| --- | --- |
| `TensorCore.decode_encodeBinaryRep` and `TensorCore.encode_decodeBinaryRep` | The encoding and decoding round trips hold for the specified representations and well-formed formats. [Source](../TensorCore/Core/Binary/Bijection.lean) |
| `TensorCore.algorithm1_correct` | If Algorithm 1 returns an encoding, it represents the nearest-even rounding of the modeled exact dot product. The successful-result premise remains part of the theorem. [Source](../TensorCore/EFT/Algorithm1.lean) |
| `TensorCore.EFMachine.algorithm1WithLean_eq` | The native EFT path preserves the full result of the reference bounded algorithm for its typed inputs, including result branches and errors. [Source](../TensorCore/EFT/Native.lean) |
| `TensorCore.IEEE.addWithLean_eq` | The native-aware addition wrapper equals the reference addition result for the implemented formats and contexts, including its fallback paths. [Source](../TensorCore/IEEE/NativeOperations.lean) |
| `TensorCore.selectGemm_accuracy` | A successfully selected candidate has the formal accuracy property at the requested tolerance under the theorem's selection premises. [Source](../TensorCore/Gemm/Selection.lean) |

The check adds evidence that these conclusions follow from their exact formal statements and dependencies. It does not remove their hypotheses or expand their domains.

For example, proving `hypotheses -> correct_result` does not show that the hypotheses hold on a particular GPU. It also does not establish that the hypotheses can be satisfied. Inconsistent premises can make an implication vacuously true. Checking useful domains and agreement with the intended problem requires separate work.

## 5. What confidence the result supports

| Question | Assessment |
| --- | --- |
| Did the real checker execute? | **Confirmed.** Two local verified-mode runs returned exit code 0, with saved logs and matching export hashes. |
| Were all selected project theorem roots included? | **Confirmed for this export.** All 5,619 names were found in the exported theorem records. |
| Did the exported terms pass an additional implementation of proof checking? | **Yes.** Con-leche accepted the full export in verified mode. |
| Are the checked statements logically justified? | **Strong additional evidence, conditional on the stated foundations and trusted components.** |
| Does this validate theorem usefulness, specifications, or hardware fidelity? | **No new validation of those questions.** |
| Does this establish a numerical probability of correctness or absolute certainty? | **No.** The run provides no defensible percentage estimate. |

The practical gain is reduced dependence on the official kernel's implementation. An invalid proof accepted because of a kernel implementation defect has another opportunity to be rejected by a separately implemented checker. Acceptance by both systems is useful corroboration.

That independence has limits. Con-leche is implemented in Lean and shares parts of the compiler and runtime infrastructure with the ecosystem it checks. Two successful runs of the same checker confirm repeatability for this input; they are not two independent checker implementations.

### The consistency theorem is conditional

At the pinned revision, con-leche's `model_exists` theorem states that an environment accepted by its verified declaration checker has a model in a supplied set theory. Its `Model` relation assigns meanings to declarations, interprets `False` as the empty set, and interprets equality as set equality. This supplies the mathematical basis for the consistency claim. See the [main theorem](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/ConLeche/MainTheorem.lean) and [model definition](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/ConLeche/Denotes.lean).

The supplied `SetTheory` includes basic set-theory principles and a countably infinite increasing chain of Grothendieck universes. The existence of such a foundation is an assumption of the interpretation. Running the checker does not prove that assumption. These are assumptions of the checker metatheory, distinct from the three axioms listed in this project's export. The exact interface is in [SetTheory/Core.lean](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/ConLeche/SetTheory/Core.lean).

The accompanying `no_False_declaration` corollary connects rejection to a specified JSON template containing a theorem of type `False`. Its formal hypothesis describes that template, not every possible byte encoding of a contradictory declaration. The broader `model_exists` theorem concerns accepted parsed environments. This distinction matters when interpreting the proof's precise scope. See the [input predicate](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/ConLeche/Accepts.lean).

### Remaining trusted components

Confidence still depends on faithful source loading and export, the executable matching the checked implementation, and correct compiler, runtime, and machine behavior. Con-leche's use of Lean's natural-number runtime is one explicit shared dependency. Hashes establish artifact identity; they do not prove exporter or compiler correctness. The [upstream runtime discussion](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/README.md#nat-operations) describes this limitation.

This audit built the checker executable target. It did not independently rebuild the complete con-leche consistency-proof development or its set-theory bridge, run its entire test suite, or check con-leche itself with a third checker. Project builds used Lake's normal cache and dependency checks. The audit did not perform a clean-room rebuild from an empty toolchain and cache.

## 6. What was outside the audit

- Agreement between the Lean definitions and the paper, informal documentation, or intended mathematical problem.
- Physical GPU behavior, compiler lowering to GPU instructions, device measurements, and performance.
- Correct execution of native floating-point operations by the host hardware or runtime. The checked native-bridge theorems concern their logical models and formal wrappers.
- Full IEEE 754 conformance beyond the project's actual formalized operations and contracts.
- Repository-wide executable testing, CLI behavior, standalone examples, scripts, vendored implementations, and non-library files.
- Definitions outside the selected theorems' transitive dependency closure.
- Future source changes. This report applies to the recorded source revision and fingerprints.

The full `./tc check` regression suite was not run as part of this con-leche audit. Its separate numerical, specification, certificate, and archived device checks remain complementary evidence. The pre-existing untracked `proposals/` directory was outside the audit and left untouched.

## 7. Tool versions and reproduction

| Component | Exact version |
| --- | --- |
| Project source | `9b42a432389faf169720e1ff6e38b16e35b3af8b` |
| Project and exporter build toolchain | `leanprover/lean4:v4.33.1` |
| Con-leche source | `c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0` |
| Con-leche build toolchain | `leanprover/lean4:v4.33.0` |
| lean4export source | `15f6055e299ad5b89345e533cc2192f4cc00f659` |
| Export format | NDJSON 3.1.0 |
| Local checker platform | macOS, Apple Silicon |

Neither tool's source was modified. The exporter was built with an explicit Lean 4.33.1 override to match the project's compiled environment. Con-leche's committed pin documentation says its 4.33.0 pin variant accepts 4.33.1 exports. This run confirmed compatibility for this export. See the [pin documentation](https://github.com/leanprover/con-leche/blob/c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0/pins/README.md).

Export SHA-256:

```text
c5aaa21afb5d1ecfe39a3ed619d595eb320351f4ec0cba2832ebe79b154b2125
```

The [run metadata](../reviews/2026-09-14-con-leche/run.json) also records the original binary hashes. Binary hashes can differ when rebuilt on another platform. The [source manifest](../reviews/2026-09-14-con-leche/source-sha256.json) identifies the 216 library source files and three build files used in the audit.

To reproduce, use this report's repository revision while the recorded proof sources remain unchanged, or a separate checkout of the audited source commit with the collector copied into it. Install Lean 4.33.0 and 4.33.1 through elan and use a working native build toolchain. From the repository root, build the pinned tools in temporary directories:

```sh
mkdir -p tmp
git clone https://github.com/leanprover/con-leche.git tmp/con-leche-tool
git -C tmp/con-leche-tool checkout c431b1ca1b7a93486dd3e0440d3ee82abe90ccd0
(cd tmp/con-leche-tool && lake build con-leche)

git clone https://github.com/leanprover/lean4export.git tmp/lean4export-tool
git -C tmp/lean4export-tool checkout 15f6055e299ad5b89345e533cc2192f4cc00f659
(cd tmp/lean4export-tool && lake +leanprover/lean4:v4.33.1 build)

python3 scripts/check_axioms.py
python3 scripts/check_layout.py
```

Then collect and export the roots using the project's Lake environment:

```sh
mkdir -p tmp/con-leche-reproduction
lake env lean --run reviews/2026-09-14-con-leche/CollectTheorems.lean \
  > tmp/con-leche-reproduction/theorem-roots.txt
cmp reviews/2026-09-14-con-leche/theorem-roots.txt \
  tmp/con-leche-reproduction/theorem-roots.txt

python3 - <<'PY'
from pathlib import Path
import subprocess

out = Path('tmp/con-leche-reproduction')
roots = (out / 'theorem-roots.txt').read_text().splitlines()
exporter = Path('tmp/lean4export-tool/.lake/build/bin/lean4export').resolve()
with (out / 'export.ndjson').open('w') as stream:
    subprocess.run(['lake', 'env', str(exporter), 'TensorCore.All', '--', *roots],
                   stdout=stream, check=True)
PY

tmp/con-leche-tool/.lake/build/bin/con-leche \
  --verified --jobs=4 --progress=2000 \
  tmp/con-leche-reproduction/export.ndjson
```

Require successful exit codes, the expected root list, and the final verified acceptance verdict. Compare source fingerprints and the export hash when claiming an exact reproduction. A different revision or export requires its own coverage check and result record.

## 8. Published evidence

The [evidence directory](../reviews/2026-09-14-con-leche/) contains the original and confirmation checker logs, checker build log, exact root collector and root list, imported module list, declaration counts, source hashes, and run metadata.

The 98.2 MiB export and compiled tools remain in local ignored temporary directories. They are not committed to Git. The export hash, exact tool commits, source manifest, and reproduction steps identify the checked artifact and allow it to be regenerated.
