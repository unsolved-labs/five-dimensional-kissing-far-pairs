import Mathlib.Tactic

set_option autoImplicit false

namespace R008

/-- Two ordered representatives of undirected edges share an endpoint. -/
def EdgesIntersect {α : Type*} (a b c d : α) : Prop :=
  a = c ∨ a = d ∨ b = c ∨ b = d

/-- A symmetric triangle-free relation whose edges are pairwise intersecting
is a star, provided at least one edge exists.

This is the graph-theoretic core used in R008: if a triangle-free graph has no
matching of size two, then every edge contains one common vertex. -/
theorem star_of_pairwise_intersecting_triangleFree
    {α : Type*} (R : α → α → Prop)
    (hSymm : Std.Symm R)
    (hTriangle : ∀ ⦃a b c : α⦄, R a b → R b c → R c a → False)
    {a b : α} (hab : R a b)
    (hPairwise : ∀ ⦃u v x y : α⦄,
      R u v → R x y → EdgesIntersect u v x y) :
    ∃ center : α, ∀ ⦃u v : α⦄, R u v → u = center ∨ v = center := by
  classical
  by_cases hStarA : ∀ ⦃u v : α⦄, R u v → u = a ∨ v = a
  · exact ⟨a, hStarA⟩
  · push Not at hStarA
    obtain ⟨c, d, hcd, hca, hda⟩ := hStarA
    have hcb_or_hdb : c = b ∨ d = b := by
      rcases hPairwise hcd hab with hca' | hcb | hda' | hdb
      · exact False.elim (hca hca')
      · exact Or.inl hcb
      · exact False.elim (hda hda')
      · exact Or.inr hdb
    have starAtB {z : α} (hbz : R b z) (hza : z ≠ a) :
        ∀ ⦃u v : α⦄, R u v → u = b ∨ v = b := by
      intro u v huv
      by_cases hub : u = b
      · exact Or.inl hub
      by_cases hvb : v = b
      · exact Or.inr hvb
      exfalso
      have haEndpoint : u = a ∨ v = a := by
        rcases hPairwise huv hab with hua | hub' | hva | hvb'
        · exact Or.inl hua
        · exact False.elim (hub hub')
        · exact Or.inr hva
        · exact False.elim (hvb hvb')
      have hzEndpoint : u = z ∨ v = z := by
        rcases hPairwise huv hbz with hub' | huz | hvb' | hvz
        · exact False.elim (hub hub')
        · exact Or.inl huz
        · exact False.elim (hvb hvb')
        · exact Or.inr hvz
      rcases haEndpoint with hua | hva <;>
        rcases hzEndpoint with huz | hvz
      · exact hza (huz.symm.trans hua)
      · have haz : R a z := by simpa [hua, hvz] using huv
        exact hTriangle hab hbz (hSymm.symm _ _ haz)
      · have hzaEdge : R z a := by simpa [huz, hva] using huv
        exact hTriangle hab hbz hzaEdge
      · exact hza (hvz.symm.trans hva)
    rcases hcb_or_hdb with hcb | hdb
    · have hbD : R b d := by simpa [hcb] using hcd
      exact ⟨b, starAtB hbD hda⟩
    · have hcB : R c b := by simpa [hdb] using hcd
      exact ⟨b, starAtB (hSymm.symm _ _ hcB) hca⟩

/-- If a symmetric triangle-free relation has an edge but is not a star, then
it contains two endpoint-disjoint edges. -/
theorem exists_disjoint_edges_of_not_star
    {α : Type*} (R : α → α → Prop)
    (hSymm : Std.Symm R)
    (hTriangle : ∀ ⦃a b c : α⦄, R a b → R b c → R c a → False)
    {a b : α} (hab : R a b)
    (hNotStar : ¬ ∃ center : α,
      ∀ ⦃u v : α⦄, R u v → u = center ∨ v = center) :
    ∃ u v x y : α,
      R u v ∧ R x y ∧ ¬ EdgesIntersect u v x y := by
  classical
  by_contra hNoDisjoint
  have hPairwise : ∀ ⦃u v x y : α⦄,
      R u v → R x y → EdgesIntersect u v x y := by
    intro u v x y huv hxy
    by_contra hNotIntersect
    exact hNoDisjoint ⟨u, v, x, y, huv, hxy, hNotIntersect⟩
  exact hNotStar
    (star_of_pairwise_intersecting_triangleFree R hSymm hTriangle hab hPairwise)

end R008
