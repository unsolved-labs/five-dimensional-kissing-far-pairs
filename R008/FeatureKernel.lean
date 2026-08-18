import R008.FormalizationBoundary
import Mathlib.Tactic

set_option autoImplicit false

open scoped BigOperators InnerProductSpace

namespace R008

variable {ι E : Type*} [Fintype ι]
  [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- The zero kernel is positive on every finite spherical code. -/
theorem kernelPositiveOn_zero (C : SphericalCode ι E) :
    KernelPositiveOn C (fun _ _ => 0) := by
  intro weights
  simp

/-- Pointwise sums of positive kernels remain positive. -/
theorem kernelPositiveOn_add (C : SphericalCode ι E)
    {K L : E → E → ℝ}
    (hK : KernelPositiveOn C K) (hL : KernelPositiveOn C L) :
    KernelPositiveOn C (fun x y => K x y + L x y) := by
  intro weights
  have h := add_nonneg (hK weights) (hL weights)
  simpa only [mul_add, Finset.sum_add_distrib] using h

/-- A nonnegative multiple of a rank-one feature kernel is positive. This is
the algebraic core used by the generated Gegenbauer sum-of-squares layer. -/
theorem kernelPositiveOn_rankOne (C : SphericalCode ι E)
    (feature : E → ℝ) {coefficient : ℝ} (hCoefficient : 0 ≤ coefficient) :
    KernelPositiveOn C
      (fun x y => coefficient * feature x * feature y) := by
  intro weights
  let s : ℝ := ∑ i, weights i * feature (C.point i)
  have hIdentity :
      (∑ i, ∑ j,
        weights i * weights j *
          (coefficient * feature (C.point i) * feature (C.point j))) =
        coefficient * s ^ 2 := by
    calc
      (∑ i, ∑ j,
          weights i * weights j *
            (coefficient * feature (C.point i) * feature (C.point j))) =
          ∑ i, ∑ j,
            (coefficient * (weights i * feature (C.point i))) *
              (weights j * feature (C.point j)) := by
            apply Finset.sum_congr rfl
            intro i hi
            apply Finset.sum_congr rfl
            intro j hj
            ring
      _ = ∑ i,
          (coefficient * (weights i * feature (C.point i))) *
            (∑ j, weights j * feature (C.point j)) := by
            apply Finset.sum_congr rfl
            intro i hi
            rw [Finset.mul_sum]
      _ = (∑ i, coefficient * (weights i * feature (C.point i))) *
          (∑ j, weights j * feature (C.point j)) := by
            rw [Finset.sum_mul]
      _ = (coefficient * (∑ i, weights i * feature (C.point i))) *
          (∑ j, weights j * feature (C.point j)) := by
            have hFactor :
                (∑ i, coefficient * (weights i * feature (C.point i))) =
                  coefficient * (∑ i, weights i * feature (C.point i)) := by
              rw [Finset.mul_sum]
            rw [hFactor]
      _ = coefficient * s ^ 2 := by
            dsimp [s]
            ring
  rw [hIdentity]
  exact mul_nonneg hCoefficient (sq_nonneg s)

/-- A finite sum of nonnegative weighted rank-one feature kernels is positive. -/
theorem kernelPositiveOn_finsetFeatureSum {ρ : Type*}
    (C : SphericalCode ι E) (features : ρ → E → ℝ)
    (coefficients : ρ → ℝ) (s : Finset ρ) :
    (∀ r ∈ s, 0 ≤ coefficients r) →
      KernelPositiveOn C
        (fun x y => ∑ r ∈ s,
          coefficients r * features r x * features r y) := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      intro h
      simpa using kernelPositiveOn_zero C
  | @insert a s ha ih =>
      intro h
      have hA : 0 ≤ coefficients a := h a (Finset.mem_insert_self a s)
      have hS : ∀ r ∈ s, 0 ≤ coefficients r := by
        intro r hr
        exact h r (Finset.mem_insert_of_mem hr)
      have hHead := kernelPositiveOn_rankOne C (features a) hA
      have hTail := ih hS
      simpa [Finset.sum_insert, ha] using kernelPositiveOn_add C hHead hTail

/-- Kernel positivity is invariant under pointwise equality of kernels. -/
theorem kernelPositiveOn_congr (C : SphericalCode ι E)
    {K L : E → E → ℝ} (hK : KernelPositiveOn C K)
    (hEq : ∀ x y, K x y = L x y) : KernelPositiveOn C L := by
  intro weights
  simpa [hEq] using hK weights

end R008
