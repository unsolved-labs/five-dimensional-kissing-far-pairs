#!/usr/bin/env python3
"""Full public release-integrity check for R008."""

from __future__ import annotations
import hashlib
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent

REQUIRED = [
    "README.md", "THEOREM.md", "claim.json", "STATEMENT_AUDIT.md",
    "VERIFICATION.md", "SOURCE_AUDIT.md", "verifier.py",
    "independent_verifier.py", "requirements.txt", "CITATION.cff",
    "release-manifest.json", "manuscript/r008_far_pair_constraints.tex",
    "manuscript/references.bib", "manuscript/build-metadata.json",
]

def sha256(path: Path) -> str:
    h=hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda:f.read(1<<20),b""):
            h.update(chunk)
    return h.hexdigest()

def git_blob_sha(path: Path) -> str:
    data=path.read_bytes()
    header=f"blob {len(data)}\0".encode("ascii")
    return hashlib.sha1(header+data).hexdigest()

def run(script: str) -> None:
    result=subprocess.run(
        [sys.executable, script], cwd=ROOT, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    )
    print(result.stdout, end="")
    if result.returncode != 0:
        raise SystemExit(f"{script} failed with exit code {result.returncode}")

def main() -> None:
    for rel in REQUIRED:
        path=ROOT/rel
        assert path.exists(), f"missing required release artifact: {rel}"

    claim=json.loads((ROOT/"claim.json").read_text())
    assert claim["release"]=="R008"
    assert claim["cardinality"]==41
    assert claim["claims"]["strongPairThreshold"]=="-442/625"
    assert claim["claims"]["strongPairCountLowerBound"]==2
    assert claim["claims"]["moderatePairThreshold"]=="-133/200"
    assert claim["claims"]["moderatePairCountLowerBound"]==10
    assert claim["claims"]["moderateFarGraphMaximumDegreeUpperBound"]==9
    assert claim["claims"]["moderateFarGraphIncidentVerticesLowerBound"]==7
    assert claim["claims"]["incidentVertexSpanDimensionLowerBound"]==3
    assert claim["claims"]["vertexDisjointStrongAndModeratePairExists"] is True
    assert claim["claims"]["differenceAxisAbsoluteInnerProductUpperBoundStrict"]=="779/1000"
    assert claim["externalReview"]=="pending"

    markdown_files=[
        "README.md","THEOREM.md","STATEMENT_AUDIT.md",
        "VERIFICATION.md","SOURCE_AUDIT.md"
    ]
    for rel in markdown_files:
        text=(ROOT/rel).read_text()
        for legacy in (r"\(",r"\)",r"\[",r"\]"):
            assert legacy not in text, f"{rel} contains legacy math delimiter {legacy}"

    manifest=json.loads((ROOT/"release-manifest.json").read_text())
    for rel, expected in manifest["sha256"].items():
        actual=sha256(ROOT/rel)
        assert actual==expected, f"hash mismatch for {rel}: {actual} != {expected}"

    buildmeta=json.loads((ROOT/"manuscript/build-metadata.json").read_text())
    for rel, expected in buildmeta["sourceGitBlobSha"].items():
        actual=git_blob_sha(ROOT/"manuscript"/rel)
        assert actual==expected, f"manuscript Git blob mismatch for {rel}: {actual} != {expected}"

    run("verifier.py")
    run("independent_verifier.py")
    print("R008 RELEASE VERIFICATION PASSED")

if __name__=="__main__":
    main()
