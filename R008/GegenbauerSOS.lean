import R008.CertificateBridge
import R008.FeatureKernel
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open scoped BigOperators InnerProductSpace

namespace R008

abbrev Euclidean5 := EuclideanSpace ℝ (Fin 5)

/-- Fourteen rational quadratic features giving a Gram decomposition of the
normalized degree-two Gegenbauer kernel on `S⁴`. -/
def gegenbauer5Degree2Feature : Fin 14 → Euclidean5 → ℝ := fun r x =>
  (![x 4 ^ 2 - (x 3 ^ 2 + x 2 ^ 2 + x 1 ^ 2 + x 0 ^ 2) / 4,
     x 3 ^ 2 - (x 2 ^ 2 + x 1 ^ 2 + x 0 ^ 2) / 3,
     x 2 ^ 2 - (x 1 ^ 2 + x 0 ^ 2) / 2,
     x 1 ^ 2 - x 0 ^ 2,
     x 3 * x 4,
     x 2 * x 4,
     x 2 * x 3,
     x 1 * x 4,
     x 1 * x 3,
     x 1 * x 2,
     x 0 * x 4,
     x 0 * x 3,
     x 0 * x 2,
     x 0 * x 1] : Fin 14 → ℝ) r

/-- Nonnegative rational weights for `gegenbauer5Degree2Feature`. -/
def gegenbauer5Degree2Weight : Fin 14 → ℝ :=
  (![1, 15 / 16, 5 / 6, 5 / 8,
     5 / 2, 5 / 2, 5 / 2, 5 / 2, 5 / 2,
     5 / 2, 5 / 2, 5 / 2, 5 / 2, 5 / 2] : Fin 14 → ℝ)

/-- Exact homogeneous Gram identity behind the degree-two normalized
Gegenbauer polynomial in ambient dimension five. -/
theorem gegenbauer5Degree2_featureIdentity (x y : Euclidean5) :
    (∑ r, gegenbauer5Degree2Weight r *
      gegenbauer5Degree2Feature r x * gegenbauer5Degree2Feature r y) =
      (5 / 4 : ℝ) * (∑ i, x i * y i) ^ 2 -
        (1 / 4 : ℝ) * (∑ i, x i ^ 2) * (∑ i, y i ^ 2) := by
  norm_num [gegenbauer5Degree2Weight, gegenbauer5Degree2Feature,
    Fin.sum_univ_succ]
  ring

/-- Closed form of the exact normalized degree-two Gegenbauer polynomial for
ambient dimension five. -/
theorem normalizedGegenbauer5Degree2_eval (t : ℝ) :
    evalRatPolynomial (normalizedGegenbauer 5 2) t =
      ((5 : ℝ) * t ^ 2 - 1) / 4 := by
  norm_num [evalRatPolynomial, normalizedGegenbauer, rawGegenbauer]
  ring_nf

/-- On unit vectors, the exact feature kernel is the normalized Gegenbauer
kernel. -/
theorem normalizedGegenbauer5Degree2_kernelEq
    (x y : Euclidean5) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    evalRatPolynomial (normalizedGegenbauer 5 2) ⟪x, y⟫_ℝ =
      ∑ r, gegenbauer5Degree2Weight r *
        gegenbauer5Degree2Feature r x * gegenbauer5Degree2Feature r y := by
  have hInner : ⟪x, y⟫_ℝ = ∑ i, x i * y i := by
    rw [PiLp.inner_apply]
    simp
  have hxSq : (∑ i, x i ^ 2) = (1 : ℝ) := by
    rw [← EuclideanSpace.real_norm_sq_eq]
    rw [hx]
    norm_num
  have hySq : (∑ i, y i ^ 2) = (1 : ℝ) := by
    rw [← EuclideanSpace.real_norm_sq_eq]
    rw [hy]
    norm_num
  rw [normalizedGegenbauer5Degree2_eval, hInner,
    gegenbauer5Degree2_featureIdentity, hxSq, hySq]
  ring

/-- The first nontrivial Schoenberg/Gegenbauer positivity instance needed by
R008, proved by a finite exact sum-of-squares decomposition. -/
theorem normalizedGegenbauer5Degree2_positive {ι : Type*} [Fintype ι]
    (C : SphericalCode ι Euclidean5) :
    GegenbauerPositiveOn C
      (evalRatPolynomial (normalizedGegenbauer 5 2)) := by
  change KernelPositiveOn C
    (fun x y => evalRatPolynomial (normalizedGegenbauer 5 2) ⟪x, y⟫_ℝ)
  have hFeatures : KernelPositiveOn C
      (fun x y => ∑ r, gegenbauer5Degree2Weight r *
        gegenbauer5Degree2Feature r x * gegenbauer5Degree2Feature r y) := by
    apply kernelPositiveOn_finsetFeatureSum C
      gegenbauer5Degree2Feature gegenbauer5Degree2Weight Finset.univ
    intro r hr
    fin_cases r <;> norm_num [gegenbauer5Degree2Weight]
  apply kernelPositiveOn_congr_points C hFeatures
  intro i j
  exact (normalizedGegenbauer5Degree2_kernelEq
    (C.point i) (C.point j) (C.unit_norm i) (C.unit_norm j)).symm

end R008
