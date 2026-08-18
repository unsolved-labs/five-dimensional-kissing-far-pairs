import Mathlib.Analysis.SpecialFunctions.Bernstein
import Mathlib.Tactic

set_option autoImplicit false

open scoped BigOperators

namespace R008

/-- A finite Bernstein-basis expansion on the real unit interval. -/
noncomputable def weightedBernstein {n : ℕ}
    (β : Fin (n + 1) → ℝ) (x : Set.Icc (0 : ℝ) 1) : ℝ :=
  ∑ k : Fin (n + 1), β k * (bernstein n (k : ℕ)) x

/-- If every Bernstein coefficient is at most `c`, the represented function
is at most `c` throughout `[0,1]`. -/
theorem weightedBernstein_le {n : ℕ}
    (β : Fin (n + 1) → ℝ) (c : ℝ) (x : Set.Icc (0 : ℝ) 1)
    (hβ : ∀ k, β k ≤ c) :
    weightedBernstein β x ≤ c := by
  unfold weightedBernstein
  calc
    (∑ k : Fin (n + 1), β k * (bernstein n (k : ℕ)) x)
        ≤ ∑ k : Fin (n + 1), c * (bernstein n (k : ℕ)) x := by
          apply Finset.sum_le_sum
          intro k hk
          exact mul_le_mul_of_nonneg_right (hβ k) bernstein_nonneg
    _ = c * ∑ k : Fin (n + 1), (bernstein n (k : ℕ)) x := by
          rw [Finset.mul_sum]
    _ = c := by
          rw [bernstein.probability]
          ring

/-- If every Bernstein coefficient is at least `c`, the represented function
is at least `c` throughout `[0,1]`. -/
theorem weightedBernstein_ge {n : ℕ}
    (β : Fin (n + 1) → ℝ) (c : ℝ) (x : Set.Icc (0 : ℝ) 1)
    (hβ : ∀ k, c ≤ β k) :
    c ≤ weightedBernstein β x := by
  unfold weightedBernstein
  calc
    c = c * ∑ k : Fin (n + 1), (bernstein n (k : ℕ)) x := by
          rw [bernstein.probability]
          ring
    _ = ∑ k : Fin (n + 1), c * (bernstein n (k : ℕ)) x := by
          rw [Finset.mul_sum]
    _ ≤ ∑ k : Fin (n + 1), β k * (bernstein n (k : ℕ)) x := by
          apply Finset.sum_le_sum
          intro k hk
          exact mul_le_mul_of_nonneg_right (hβ k) bernstein_nonneg

/-- A common strictly negative upper bound on all Bernstein coefficients
certifies strict negativity on the closed interval. -/
theorem weightedBernstein_strictly_negative {n : ℕ}
    (β : Fin (n + 1) → ℝ) (c : ℝ) (x : Set.Icc (0 : ℝ) 1)
    (hβ : ∀ k, β k ≤ c) (hc : c < 0) :
    weightedBernstein β x < 0 :=
  lt_of_le_of_lt (weightedBernstein_le β c x hβ) hc

/-- A common strictly positive lower bound on all Bernstein coefficients
certifies strict positivity on the closed interval. -/
theorem weightedBernstein_strictly_positive {n : ℕ}
    (β : Fin (n + 1) → ℝ) (c : ℝ) (x : Set.Icc (0 : ℝ) 1)
    (hβ : ∀ k, c ≤ β k) (hc : 0 < c) :
    0 < weightedBernstein β x :=
  lt_of_lt_of_le hc (weightedBernstein_ge β c x hβ)

end R008
