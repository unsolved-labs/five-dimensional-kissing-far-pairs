# Verification

R008 is a hybrid mathematical/computer-assisted proof. This file records what
is checked by machine, what is proved symbolically in the manuscript, and what
is **not** claimed.

## Clean-checkout replay

Python 3.12 is the CI reference environment.

```bash
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
python verify_release.py
```

The final line should be:

```text
R008 RELEASE VERIFICATION PASSED
```

`verify_release.py` performs all release-integrity checks and runs both exact
certificate replayers.

## Exact verification route A: SymPy

```bash
python verifier.py
```

`verifier.py` constructs the normalized Gegenbauer polynomials exactly over
$\mathbb Q$, verifies positivity of every Gegenbauer coefficient, uses exact
Sturm root counting for the strong/moderate/local sign intervals, recomputes
the two Delsarte deficits and local $S^3$ objective, and verifies the exact
rational inequalities behind the difference-axis bound.

Dependency: `sympy==1.14.0`, pinned in `requirements.txt`.

## Exact verification route B: independent standard-library replay

```bash
python independent_verifier.py
```

This checker intentionally does **not** import SymPy or the primary verifier.
It independently implements rational polynomial arithmetic with
`fractions.Fraction`, the Gegenbauer three-term recurrence, polynomial
Euclidean division, Sturm sequences/root counts, and all deficit/local/radical
comparisons.

The two verifiers share only the published mathematical certificate data
(coefficients and rational thresholds), also printed in the manuscript and
`THEOREM.md`.

## What the exact checkers establish

They establish the numerical/certificate premises used by the proof:

- $E_{442/625}(C)\ge2$ from the strong polynomial;
- $E_{133/200}(C)\ge10$ from the moderate polynomial;
- the projected Delsarte objective is $<10$, hence $\Delta(G_m)\le9$;
- exact arithmetic behind triangle-freeness and the endpoint count;
- the strict normalized difference-axis bound $<779/1000$.

## What remains a mathematical proof obligation

The following short deductions are presently human-readable rather than
proof-assistant formalized:

- the edge-count Delsarte positivity argument;
- the neighbor projection inequality and its monotonicity;
- the graph lemma producing a two-edge matching;
- the case argument producing a strong edge disjoint from a moderate edge;
- the difference-axis vector decomposition and cross-anchor inequalities;
- the Mantel/circle-code argument for seven endpoints spanning dimension at
  least three.

These deductions are written in full in `THEOREM.md` and the manuscript.

## Why no Lean formalization is claimed in this revision

A useful Lean formalization would need to cover spherical-code Gegenbauer
positivity/Delsarte machinery, exact polynomial sign certificates, and the
geometric reductions—not merely encode the final rational arithmetic. This
repository does not currently contain that supporting formal library, and
adding untested placeholder Lean would weaken rather than strengthen the
assurance story.

Accordingly, the current trust boundary is two independent exact Sturm
implementations plus a complete human-readable proof. A future proof-assistant
formalization should target the Delsarte edge-count lemma, graph deductions,
and certificate-soundness interface. Until that exists, the repository does
not describe R008 as Lean-verified.

## Search/generation boundary

The process that discovered the three polynomials is **not** part of the final
correctness oracle. Only the frozen rational coefficients and exact replay are
trusted. Re-running an optimizer is unnecessary for theorem verification.

## Manuscript integrity

The committed PDF is built from the public LaTeX source in `manuscript/`.
`manuscript/build-metadata.json` records the source and PDF hashes. CI rebuilds
the manuscript from source and checks the deterministic PDF hash.
`release-manifest.json` freezes hashes of the critical public artifacts.

## Review status

Independent specialist review remains `pending`. Exact computer replay is not
described as peer review or external specialist validation.
