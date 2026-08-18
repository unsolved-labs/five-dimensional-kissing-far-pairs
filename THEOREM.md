# Two-scale disjoint far-pair theorem in dimension five

This file is the GitHub-readable proof companion to the
[research manuscript](manuscript/r008_far_pair_constraints.pdf). The
machine-checked obligations are mapped in
[`STATEMENT_AUDIT.md`](STATEMENT_AUDIT.md).

## Theorem

Let $C\subset S^4$ be a spherical code satisfying

$$
x\cdot y\leq \frac12 \qquad (x\neq y),
$$

and suppose $|C|=41$. Then there are four distinct points
$x_+,x_-,y_+,y_-\in C$ such that

$$
x_+\cdot x_-<-\frac{442}{625}
\qquad\text{and}\qquad
y_+\cdot y_-<-\frac{133}{200}.
$$

Moreover:

1. at least two unordered pairs have inner product below $-442/625$;
2. at least ten unordered pairs have inner product below $-133/200$;
3. the graph formed by the latter pairs is triangle-free and has maximum
   degree at most nine;
4. at least seven code points are incident with such moderate far pairs, and
   these endpoints span a subspace of dimension at least three;
5. the normalized difference axes of suitable vertex-disjoint strong and
   moderate pairs have absolute inner product below $779/1000$.

This is a structural theorem about every hypothetical 41-point kissing code
in five dimensions. It does **not** prove $\tau_5=40$.

## 1. Edge-count form of the Delsarte argument

Let $P_k^{(5)}$ be the normalized Gegenbauer polynomials for $S^4$, with
$P_k^{(5)}(1)=1$. Suppose

$$
f(t)=\sum_{k\geq0}a_kP_k^{(5)}(t),\qquad a_k\geq0,
$$

satisfies

$$
f(t)\leq0\quad(-a\leq t\leq1/2)
$$

and

$$
f(t)\leq1\quad(-1\leq t<-a).
$$

Let $E_a(C)$ denote the number of unordered pairs with inner product below
$-a$. Gegenbauer positivity gives

$$
a_0|C|^2\leq\sum_{x,y\in C}f(x\cdot y).
$$

The diagonal contributes $|C|f(1)$, each far unordered pair contributes at
most two, and every other off-diagonal pair contributes at most zero. Hence

$$
E_a(C)\geq
\left\lceil
\frac{a_0|C|^2-|C|f(1)}2
\right\rceil.
\tag{1}
$$

## 2. Strong-edge certificate

Use the nonzero Gegenbauer coefficients

| $k$ | 0 | 1 | 2 | 3 | 4 | 9 |
|---|---:|---:|---:|---:|---:|---:|
| $a_k$ | $\frac{13939907}{10^8}$ | $\frac{12103401}{25000000}$ | $\frac{139479103}{10^8}$ | $\frac{30090377}{25000000}$ | $\frac{41787773}{25000000}$ | $\frac{38538027}{50000000}$ |

Call the resulting polynomial $f_s$. Both exact verifiers establish

$$
f_s(t)<0\quad\text{on}\quad
\left[-\frac{442}{625},\frac12\right]
$$

and

$$
f_s(t)<1\quad\text{on}\quad
\left[-1,-\frac{442}{625}\right].
$$

For $N=41$,

$$
N^2a_0-Nf_s(1)
=
\frac{209711679}{10^8}
=2.09711679.
$$

Equation (1) therefore yields

$$
\boxed{E_{442/625}(C)\geq2}.
\tag{2}
$$

## 3. Moderate-edge certificate

Use the nonzero coefficients

| $k$ | 0 | 1 | 2 | 3 | 4 | 9 |
|---|---:|---:|---:|---:|---:|---:|
| $a_k$ | $\frac{6113963}{50000000}$ | $\frac{3549967}{10^7}$ | $\frac{59464043}{50000000}$ | $\frac{11303433}{12500000}$ | $\frac{17480877}{12500000}$ | $\frac{29954461}{50000000}$ |

For the resulting polynomial $f_m$, exact Sturm counts give

$$
f_m(t)<0\quad\text{on}\quad
\left[-\frac{133}{200},\frac12\right],
$$

and

$$
f_m(t)<1\quad\text{on}\quad
\left[-1,-\frac{133}{200}\right].
$$

The exact deficit is

$$
N^2a_0-Nf_m(1)
=
\frac{912370581}{50000000}
=18.24741162.
$$

Hence

$$
\boxed{E_{133/200}(C)\geq10}.
\tag{3}
$$

## 4. Maximum degree nine

Let $G_m$ be the graph whose edges satisfy

$$
x\cdot y<-\frac{133}{200}.
$$

Fix $x$, and write its neighbors as

$$
y_i=-p_i x+\sqrt{1-p_i^2}\,u_i,
\qquad p_i>\frac{133}{200},
\qquad u_i\in S^3.
$$

For distinct neighbors,

$$
u_i\cdot u_j
\leq
\frac{\frac12-p_ip_j}
{\sqrt{(1-p_i^2)(1-p_j^2)}}.
\tag{4}
$$

For $p_i,p_j>1/2$, the right-hand side is decreasing in either variable:
the partial derivative with respect to $p$ has the sign of $p/2-q$.
Therefore (4) is at most

$$
c=
\frac{\frac12-(133/200)^2}{1-(133/200)^2}
=
\frac{2311}{22311}.
$$

For $S^3$, use normalized Gegenbauer polynomials $P_k^{(4)}$ and

| $k$ | 0 | 1 | 2 | 3 | 6 |
|---|---:|---:|---:|---:|---:|
| $b_k$ | $\frac{99999}{100000}$ | $\frac{153764653}{50000000}$ | $\frac{89219103}{25000000}$ | $\frac{163063619}{10^8}$ | $\frac{13716513}{10^8}$ |

The resulting polynomial $g$ is negative on $[-1,2311/22311]$, while

$$
\frac{g(1)}{b_0}
=
\frac{18823697}{1999980}
=
9.4119426\ldots<10.
$$

Therefore the ordinary Delsarte bound on the projected $S^3$ code gives

$$
\boxed{\Delta(G_m)\leq9}.
\tag{5}
$$

The graph is triangle-free: if three unit vectors were pairwise adjacent, then

$$
\|x+y+z\|^2
<
3-6\left(\frac{133}{200}\right)
<0,
$$

which is impossible.

## 5. A matching and a disjoint strong edge

A triangle-free graph in which every two edges intersect must be a star.
Indeed, if $xy$ and $xz$ are edges, any edge avoiding $x$ would have to be
$yz$, forming a triangle.

If $G_m$ had no matching of size two, it would therefore be a star. Equations
(3) and (5) would imply simultaneously

$$
|E(G_m)|\geq10
\qquad\text{and}\qquad
|E(G_m)|\leq9,
$$

a contradiction. Hence $G_m$ has two vertex-disjoint edges.

Let $G_s\subset G_m$ be the graph at threshold $-442/625$. It has at least two
edges by (2). If two strong edges are disjoint, the theorem follows
immediately. Otherwise take two strong edges $xy,xz$, and take a two-edge
matching in $G_m$. If one matching edge avoids $xy$, use it. If both matching
edges meet $xy$, disjointness forces one through $x$ and one through $y$; the
latter cannot contain $z$, because $yz$ would complete a triangle. It is
therefore disjoint from $xz$. Thus a strong edge and a moderate edge can
always be chosen vertex-disjoint.

## 6. Difference-axis separation

Write the selected pairs as

$$
x_\pm=m\pm p,
\qquad
y_\pm=n\pm q.
$$

Then $m\perp p$, $n\perp q$, and the pair inequalities give

$$
\begin{aligned}
\|m\|^2&<\frac{183}{1250},&
\|p\|^2&>\frac{1067}{1250},\\
\|n\|^2&<\frac{67}{400},&
\|q\|^2&>\frac{333}{400}.
\end{aligned}
\tag{6}
$$

Adding appropriate cross-anchor inequalities gives

$$
m\cdot n+p\cdot q\leq\frac12,
\qquad
m\cdot n-p\cdot q\leq\frac12.
$$

Hence

$$
|p\cdot q|
\leq
\frac12-m\cdot n
\leq
\frac12+\|m\|\,\|n\|.
$$

For normalized difference axes $e=p/\|p\|$ and $f=q/\|q\|$,

$$
|e\cdot f|
<
\frac{1+\sqrt{(1-442/625)(1-133/200)}}
{\sqrt{(1+442/625)(1+133/200)}}
=
0.7788938227\ldots
<
\frac{779}{1000}.
\tag{7}
$$

The final strict rational comparison is certified without trusting the
displayed decimal: both verifiers reduce it to exact rational inequalities.

## 7. At least seven far-edge endpoints span dimension three

Let $W$ be the set of vertices incident with edges of $G_m$. The induced graph
on $W$ is triangle-free and has at least ten edges. By Mantel's theorem, a
triangle-free graph on six vertices has at most

$$
\left\lfloor\frac{6^2}{4}\right\rfloor=9
$$

edges, so

$$
|W|\geq7.
\tag{8}
$$

If $W$ lay in a subspace of dimension at most two, its unit vectors would form
a circle code with angular separation at least $60^\circ$, and such a circle
code has at most six points. Therefore

$$
\boxed{\dim\operatorname{span}(W)\geq3}.
\tag{9}
$$

This completes the proof.

## Verification boundary

The exact polynomial and radical certificates are replayed twice:

- `verifier.py` uses exact SymPy arithmetic and SymPy Sturm counting;
- `independent_verifier.py` uses only Python's standard library and implements
  the Gegenbauer recurrence, polynomial arithmetic, and Sturm theorem replay
  independently.

The graph-theoretic deductions in Sections 5 and 7 and the symbolic geometric
reduction in Sections 4 and 6 are human-readable mathematical implications of
the exact certificate outputs. They are not currently Lean-formalized.
`VERIFICATION.md` records this boundary explicitly.

No floating-point optimization output or certificate-search output is trusted.

## Public baseline and novelty boundary

See [`SOURCE_AUDIT.md`](SOURCE_AUDIT.md). The baseline is pinned to Henry Cohn
and Isaac Rajagopal, *Variations on five-dimensional sphere packings*,
arXiv:2412.00937v3 (4 March 2026), together with the established
linear/semidefinite programming literature for spherical codes.

A targeted public-source search refreshed on 18 August 2026 did not locate a
prior source stating the exact R008 thresholds and structural consequences.
This is a scoped source audit, not a substitute for independent specialist
review.
