# Statement audit

This table maps every load-bearing public R008 statement to its paper proof and
machine evidence. “Machine evidence” is deliberately narrow: it does not
claim that a script proves a mathematical implication that is only written in
the proof.

| Public statement | Mathematical source | Primary exact evidence | Independent exact evidence | Remaining trust |
|---|---|---|---|---|
| 41-point code in $S^4$, pairwise inner products $\le 1/2$ | Manuscript Theorem 1 / `THEOREM.md` theorem | hard-coded theorem parameters | independently hard-coded theorem parameters | statement identity |
| at least 2 pairs below $-442/625$ | Delsarte edge-count lemma + strong certificate | `verifier.py`: strong sign intervals and exact deficit | `independent_verifier.py`: independent Gegenbauer/Sturm replay | Delsarte positivity lemma |
| at least 10 pairs below $-133/200$ | Delsarte edge-count lemma + moderate certificate | moderate sign intervals and deficit | independent Gegenbauer/Sturm replay | Delsarte positivity lemma |
| moderate far graph has $\Delta\le9$ | neighbor projection + local $S^3$ Delsarte bound | exact projected cap, local sign interval, objective $<10$ | independent recurrence/Sturm/objective replay | projection inequality + ordinary Delsarte theorem |
| moderate far graph is triangle-free | norm-square contradiction | exact check $3-6(133/200)<0$ | same arithmetic checked independently | elementary vector identity |
| a moderate matching of size 2 exists | triangle-free intersecting-edge graph is a star; combine $|E|\ge10$ and $\Delta\le9$ | numerical premises checked | numerical premises checked | elementary graph lemma |
| a strong edge disjoint from a moderate edge exists | Section 5 case argument using $\ge2$ strong edges and the moderate matching | edge-count premises checked | edge-count premises checked | elementary graph case argument |
| difference axes satisfy $|e\cdot f|<779/1000$ | vector decomposition + cross-anchor inequalities | exact norm identities and radical comparison | independent exact radical comparison | geometric reduction |
| at least 7 moderate-edge endpoints | Mantel: triangle-free graph on 6 vertices has at most 9 edges | $10>9$ checked | $10>9$ checked | Mantel's theorem |
| incident endpoints span dimension $\ge3$ | a circle code with minimum angle $60^\circ$ has at most 6 points | no additional numerical certificate | no additional numerical certificate | elementary circle-code bound |

## Scope identity

The repository must not convert these statements into any of the following:

- $\tau_5=40$;
- a new global upper bound below 44;
- optimality of the three rational thresholds;
- a claim that certificate search was formally verified;
- a claim of independent specialist review while `externalReview` is
  `pending`.

The authoritative machine-readable scope is `claim.json`. The public README,
manuscript theorem, `THEOREM.md`, and release page should remain semantically
identical to it.
