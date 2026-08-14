# Five-dimensional kissing-code far-pair constraints

Canonical research artifact for **Unsolved Labs R008**.

## Result

Let \(C\subset S^4\) be a spherical code with \(|C|=41\) and

\[
x\cdot y\leq\frac12\qquad(x\neq y).
\]

Then there are four distinct points \(x_+,x_-,y_+,y_-\in C\) such that

\[
x_+\cdot x_-<-\frac{442}{625},
\qquad
y_+\cdot y_-<-\frac{133}{200}.
\]

The two pairs can be chosen vertex-disjoint. More precisely, every such code has at least two unordered pairs below \(-442/625\) and at least ten below \(-133/200\). The graph at the latter threshold is triangle-free with maximum degree at most nine; at least seven vertices are incident with its edges and span dimension at least three. Suitable disjoint strong and moderate pairs have normalized difference axes with absolute inner product below \(779/1000\).

The complete proof is in [`THEOREM.md`](THEOREM.md). The exact frozen claim is also recorded in [`claim.json`](claim.json).

## Reproduce

Python 3.12 is used in CI.

```bash
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
python verifier.py
```

A successful replay begins with:

```text
ALL TWO-SCALE FAR-PAIR CERTIFICATES VERIFIED
```

The verifier uses exact rational arithmetic and exact Sturm root counting in SymPy. It reconstructs the Gegenbauer certificates, verifies all required interval signs, reproduces the two far-pair count bounds, checks the local degree certificate, and verifies the exact radical inequality behind the difference-axis bound.

GitHub Actions reruns the same verifier on every pull request and push to `main`.

## Files

- [`THEOREM.md`](THEOREM.md) — statement and complete proof.
- [`verifier.py`](verifier.py) — exact certificate replay.
- [`claim.json`](claim.json) — machine-readable frozen claim and scope.
- [`requirements.txt`](requirements.txt) — pinned verifier dependency.
- [`.github/workflows/verify.yml`](.github/workflows/verify.yml) — CI replay.

## Public baseline

The five-dimensional kissing number is not known exactly. Cohn and Rajagopal state that it appears to be 40 while the best proved upper bound is 44, and they record four nonisometric 40-point configurations:

- Henry Cohn and Isaac Rajagopal, *Variations on five-dimensional sphere packings*, arXiv:2412.00937v3 (2026): https://arxiv.org/abs/2412.00937

The positive-definite linear/semidefinite programming framework for spherical codes is established prior work; for example:

- Christine Bachoc and Frank Vallentin, *New upper bounds for kissing numbers from semidefinite programming*, arXiv:math/0608426: https://arxiv.org/abs/math/0608426

A targeted literature audit through August 14, 2026 found no prior source stating the exact thresholds and structural consequences released here. Independent specialist review remains pending.

## Scope

This release gives exact structural constraints on any hypothetical 41-point five-dimensional kissing configuration. It **does not prove** \(\tau_5=40\), does not improve the public upper bound 44, and makes no optimality claim for the numerical thresholds \(442/625\) or \(133/200\).
