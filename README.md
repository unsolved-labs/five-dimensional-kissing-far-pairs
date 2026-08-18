# Five-dimensional kissing-code far-pair constraints

Canonical research artifact for **Unsolved Labs R008**.

> **Status.** Exact computer-assisted verification is reproducible from this
> repository. Independent specialist review remains pending. The research
> artifact was generated with frontier AI and is published by Unsolved Labs;
> no conventional human authorship is implied.

## Result

Let $C\subset S^4$ be a spherical code with $|C|=41$ and

$$
x\cdot y\leq\frac12 \qquad (x\neq y).
$$

Then there are four distinct points $x_+,x_-,y_+,y_-\in C$ such that

$$
x_+\cdot x_-<-\frac{442}{625},
\qquad
y_+\cdot y_-<-\frac{133}{200}.
$$

More precisely, every such code has:

- at least **two** unordered pairs below $-442/625$;
- at least **ten** unordered pairs below $-133/200$;
- a moderate far-pair graph that is triangle-free with maximum degree at most
  **nine**;
- at least **seven** vertices incident with moderate far pairs, spanning a
  subspace of dimension at least **three**;
- a vertex-disjoint strong/moderate pair whose normalized difference axes have
  absolute inner product below $779/1000$.

The theorem is structural: it constrains every hypothetical 41-point
five-dimensional kissing configuration. It **does not prove** $\tau_5=40$ and
does not improve the proved upper bound $44$.

## Why this matters

The five-dimensional kissing number is conjectured to be $40$, while the
best proved upper bound remains $44$. A hypothetical counterexample to
$\tau_5=40$ must therefore contain at least 41 points. R008 shows that any
41-point candidate would already be forced to contain a substantial,
geometrically separated system of unusually far-apart pairs.

The exact theorem and proof are available in two forms:

- [research manuscript source](manuscript/r008_far_pair_constraints.tex), with a
  reproducible PDF built by CI and `make manuscript`;
- [GitHub-rendered theorem and proof](THEOREM.md).

## Verification

The load-bearing numerical claims are exact rational certificates, not
floating-point optimization output.

Two independent replay paths are provided:

1. [`verifier.py`](verifier.py) — SymPy exact rational arithmetic and SymPy's
   exact Sturm root counting;
2. [`independent_verifier.py`](independent_verifier.py) — dependency-free
   `fractions.Fraction` arithmetic, an independently implemented Gegenbauer
   recurrence, polynomial Euclidean division, and Sturm root counting.

Run the complete release check:

```bash
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
python verify_release.py
```

A successful replay ends with:

```text
R008 RELEASE VERIFICATION PASSED
```

See [`VERIFICATION.md`](VERIFICATION.md) for the precise trust boundary and
[`STATEMENT_AUDIT.md`](STATEMENT_AUDIT.md) for the public-claim-to-proof map.

## Repository structure

- [`manuscript/`](manuscript/) — LaTeX source, references, build instructions,
  and reference-build metadata; CI publishes the compiled PDF as an artifact.
- [`THEOREM.md`](THEOREM.md) — complete GitHub-readable theorem and proof.
- [`claim.json`](claim.json) — machine-readable frozen claim and scope.
- [`STATEMENT_AUDIT.md`](STATEMENT_AUDIT.md) — claim-to-proof/checker mapping.
- [`VERIFICATION.md`](VERIFICATION.md) — clean-checkout verification and trust
  boundary.
- [`SOURCE_AUDIT.md`](SOURCE_AUDIT.md) — pinned public baseline and scoped
  novelty audit.
- [`verifier.py`](verifier.py) — primary exact certificate replay.
- [`independent_verifier.py`](independent_verifier.py) — independent,
  dependency-free exact replay.
- [`verify_release.py`](verify_release.py) — full release-integrity check.
- [`release-manifest.json`](release-manifest.json) — frozen hashes of critical
  release artifacts.
- [`CITATION.cff`](CITATION.cff) — citation metadata.
- [`.github/workflows/verify.yml`](.github/workflows/verify.yml) — CI replay.

## Public baseline

The baseline is pinned in [`SOURCE_AUDIT.md`](SOURCE_AUDIT.md). In particular,
Cohn and Rajagopal's arXiv:2412.00937v3 (4 March 2026) records four
nonisometric 40-point five-dimensional kissing configurations and states that
the best proved upper bound is $44$.

A targeted public-source search was refreshed on 18 August 2026. It did not
locate a prior source stating the exact R008 thresholds and structural
consequences. This is a scoped source audit, not a claim of exhaustive
literature coverage or independent specialist validation.

## Scope

R008 does **not**:

- prove $\tau_5=40$;
- improve the public upper bound $44$;
- claim optimality of the thresholds $442/625$, $133/200$, or $779/1000$;
- treat the certificate-search procedure as part of the final correctness
  oracle.

Independent specialist review remains **pending**.
