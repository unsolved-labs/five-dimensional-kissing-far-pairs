# Source and novelty audit

**Audit refreshed:** 18 August 2026

This file records the public comparison sources used by R008. It is a scoped
source audit, not an exhaustive priority determination and not a substitute
for independent specialist review.

## Five-dimensional kissing baseline

### Cohn–Rajagopal

Henry Cohn and Isaac Rajagopal, *Variations on five-dimensional sphere
packings*.

- arXiv identifier: `2412.00937v3`
- v3 date: 4 March 2026
- arXiv: https://arxiv.org/abs/2412.00937v3
- related journal DOI recorded by arXiv:
  https://doi.org/10.1007/s00454-026-00841-x

The paper states that the five-dimensional kissing number appears to be 40
while the best proved upper bound is 44, and it proves that at least four
nonisometric 40-point kissing configurations are known.

R008 uses this only as context and as a public baseline. It does not claim to
improve the upper bound 44.

### Upper bound 44

Hans D. Mittelmann and Frank Vallentin, *High accuracy semidefinite
programming bounds for kissing numbers*.

- arXiv: https://arxiv.org/abs/0902.1105

This is the source cited by Cohn–Rajagopal for the proved upper bound 44 in
dimension five.

## Delsarte / semidefinite-programming framework

Christine Bachoc and Frank Vallentin, *New upper bounds for kissing numbers
from semidefinite programming*.

- arXiv: https://arxiv.org/abs/math/0608426

R008 does not claim the positive-definite Gegenbauer/Delsarte machinery as a
new method. The new release-specific content is the particular pair of
two-scale certificates and the structural deductions drawn from them.

## Scoped novelty search

A targeted public search was refreshed on 18 August 2026 for combinations of:

- five-dimensional / dimension-five kissing number;
- 41-point spherical codes in $S^4$;
- the exact thresholds `442/625` and `133/200`;
- the exact axis bound `779/1000`;
- far-pair counts and structural constraints.

No prior public source was located that states the exact R008 theorem:
simultaneously forcing at least two pairs below $-442/625$, at least ten below
$-133/200$, and the released disjoint-pair/axis/end-point consequences for
every hypothetical 41-point code.

This search result is evidence for a scoped public-source comparison only.
The repository therefore uses restrained language (“targeted search did not
locate”) rather than claiming exhaustive novelty or priority.

## Version discipline

If any baseline source is updated, `SOURCE_AUDIT.md`, the manuscript,
`claim.json`, and the public release page should be rechecked together.
Comparisons should cite immutable arXiv revisions or DOI versions where
possible.
