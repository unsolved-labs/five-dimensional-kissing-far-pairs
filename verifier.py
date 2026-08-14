#!/usr/bin/env python3
"""
Exact certificates for a two-scale disjoint-far-pair theorem in the
five-dimensional kissing-number problem.

Verified theorem:
Every 41-point spherical code C subset S^4 with
    <x,y> <= 1/2  for x != y
contains vertex-disjoint pairs {x_+,x_-}, {y_+,y_-} such that
    <x_+,x_-> < -442/625,
    <y_+,y_-> < -133/200.

The program also verifies:
* at least two pairs lie below -442/625;
* at least ten pairs lie below -133/200;
* the graph at threshold -133/200 is triangle-free and has maximum degree 9;
* the normalized difference axes of the two selected pairs have
  absolute inner product < 779/1000;
* at least seven vertices are incident with moderate far pairs.

All polynomial sign assertions use exact rational arithmetic and
Sturm root counting.
"""

from __future__ import annotations

import math
import sympy as sp

t = sp.Symbol("t")
N = 41

A_STRONG = sp.Rational(442, 625)
A_MODERATE = sp.Rational(133, 200)
STRONG_THRESHOLD = -A_STRONG
MODERATE_THRESHOLD = -A_MODERATE


def normalized_gegenbauer(k: int, ambient_dimension: int) -> sp.Expr:
    """Normalized Gegenbauer polynomial for S^(d-1), with P_k(1)=1."""
    lam = sp.Rational(ambient_dimension - 2, 2)
    raw = sp.gegenbauer(k, lam, t)
    return sp.expand(raw / raw.subs(t, 1))


def polynomial_from_coefficients(
    coefficients: dict[int, sp.Rational], ambient_dimension: int
) -> sp.Expr:
    return sp.expand(
        sum(
            value * normalized_gegenbauer(k, ambient_dimension)
            for k, value in coefficients.items()
        )
    )


def certify_no_roots(poly: sp.Expr, left: sp.Rational, right: sp.Rational) -> None:
    assert sp.count_roots(sp.Poly(poly, t, domain=sp.QQ), left, right) == 0


def rational_ceiling(x: sp.Rational) -> int:
    return int(sp.ceiling(x))


strong_coefficients = {
    0: sp.Rational(13939907, 100000000),
    1: sp.Rational(12103401, 25000000),
    2: sp.Rational(139479103, 100000000),
    3: sp.Rational(30090377, 25000000),
    4: sp.Rational(41787773, 25000000),
    9: sp.Rational(38538027, 50000000),
}

moderate_coefficients = {
    0: sp.Rational(6113963, 50000000),
    1: sp.Rational(3549967, 10000000),
    2: sp.Rational(59464043, 50000000),
    3: sp.Rational(11303433, 12500000),
    4: sp.Rational(17480877, 12500000),
    9: sp.Rational(29954461, 50000000),
}

local_coefficients = {
    0: sp.Rational(99999, 100000),
    1: sp.Rational(153764653, 50000000),
    2: sp.Rational(89219103, 25000000),
    3: sp.Rational(163063619, 100000000),
    6: sp.Rational(13716513, 100000000),
}

f_strong = polynomial_from_coefficients(strong_coefficients, 5)
f_moderate = polynomial_from_coefficients(moderate_coefficients, 5)
g_local = polynomial_from_coefficients(local_coefficients, 4)

assert all(value > 0 for value in strong_coefficients.values())
assert all(value > 0 for value in moderate_coefficients.values())
assert all(value > 0 for value in local_coefficients.values())

certify_no_roots(f_strong, STRONG_THRESHOLD, sp.Rational(1, 2))
assert f_strong.subs(t, 0) == sp.Rational(-143929, 400000000) < 0
assert f_strong.subs(t, STRONG_THRESHOLD) < 0
assert f_strong.subs(t, sp.Rational(1, 2)) < 0

certify_no_roots(1 - f_strong, -1, STRONG_THRESHOLD)
assert (1 - f_strong).subs(t, -1) == sp.Rational(3160133, 12500000) > 0
assert (1 - f_strong).subs(t, STRONG_THRESHOLD) > 0

certify_no_roots(f_moderate, MODERATE_THRESHOLD, sp.Rational(1, 2))
assert f_moderate.subs(t, 0) == sp.Rational(-46437, 200000000) < 0
assert f_moderate.subs(t, MODERATE_THRESHOLD) < 0
assert f_moderate.subs(t, sp.Rational(1, 2)) < 0

certify_no_roots(1 - f_moderate, -1, MODERATE_THRESHOLD)
assert (1 - f_moderate).subs(t, -1) == sp.Rational(3708257, 25000000) > 0
assert (1 - f_moderate).subs(t, MODERATE_THRESHOLD) > 0

strong_deficit = sp.factor(
    N * N * strong_coefficients[0] - N * f_strong.subs(t, 1)
)
moderate_deficit = sp.factor(
    N * N * moderate_coefficients[0] - N * f_moderate.subs(t, 1)
)
strong_edge_lower_bound = rational_ceiling(strong_deficit / 2)
moderate_edge_lower_bound = rational_ceiling(moderate_deficit / 2)

assert strong_deficit == sp.Rational(209711679, 100000000)
assert moderate_deficit == sp.Rational(912370581, 50000000)
assert strong_edge_lower_bound == 2
assert moderate_edge_lower_bound == 10

local_cap = sp.factor(
    (sp.Rational(1, 2) - A_MODERATE**2) / (1 - A_MODERATE**2)
)
assert local_cap == sp.Rational(2311, 22311)

certify_no_roots(g_local, -1, local_cap)
assert g_local.subs(t, 0) == sp.Rational(-146435141, 700000000) < 0
assert g_local.subs(t, -1) < 0
assert g_local.subs(t, local_cap) < 0

local_objective = sp.factor(g_local.subs(t, 1) / local_coefficients[0])
assert local_objective == sp.Rational(18823697, 1999980)
assert local_objective < 10
local_degree_upper_bound = 9

assert 3 - 6 * A_MODERATE < 0
assert 3 - 6 * A_STRONG < 0
assert A_STRONG > A_MODERATE

u = sp.factor((1 - A_STRONG) * (1 - A_MODERATE))
v = sp.factor((1 + A_STRONG) * (1 + A_MODERATE))
axis_rational_target = sp.Rational(779, 1000)

w = sp.factor(axis_rational_target**2 * v - 1 - u)
assert w > 0
assert sp.factor(w**2 - 4 * u) > 0

axis_bound = (1 + sp.sqrt(u)) / sp.sqrt(v)
axis_bound_decimal = sp.N(axis_bound, 40)
assert axis_bound_decimal < sp.N(axis_rational_target, 40)

assert sp.factor((1 - A_STRONG) / 2) == sp.Rational(183, 1250)
assert sp.factor((1 + A_STRONG) / 2) == sp.Rational(1067, 1250)
assert sp.factor((1 - A_MODERATE) / 2) == sp.Rational(67, 400)
assert sp.factor((1 + A_MODERATE) / 2) == sp.Rational(333, 400)

assert (6 * 6) // 4 == 9 < moderate_edge_lower_bound

print("ALL TWO-SCALE FAR-PAIR CERTIFICATES VERIFIED")
print()
print("Strong threshold:", STRONG_THRESHOLD)
print("  Gegenbauer deficit:", strong_deficit)
print("  unordered edges forced:", strong_edge_lower_bound)
print()
print("Moderate threshold:", MODERATE_THRESHOLD)
print("  Gegenbauer deficit:", moderate_deficit)
print("  unordered edges forced:", moderate_edge_lower_bound)
print("  local projected cap:", local_cap)
print("  local Delsarte objective:", local_objective)
print("  maximum graph degree:", local_degree_upper_bound)
print()
print("Combinatorial consequence:")
print("  The moderate graph is triangle-free, has >=10 edges and Delta<=9,")
print("  so it contains a matching of size two.")
print("  Together with the >=2 strong edges, one obtains a strong edge")
print("  disjoint from a moderate edge.")
print()
print("Difference-axis bound:")
print("  exact radical expression:", axis_bound)
print("  decimal:", axis_bound_decimal)
print("  certified rational bound: < 779/1000")
print(
    "  unoriented angular separation: >",
    f"{math.degrees(math.acos(0.779)):.12f} degrees",
)
print()
print("Endpoint consequence:")
print("  At least seven vertices are incident with moderate far pairs,")
print("  and those endpoints span at least a three-dimensional subspace.")
