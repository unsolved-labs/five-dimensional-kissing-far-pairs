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

noncomputable section

private abbrev e5i0 : Fin 5 := 0
private abbrev e5i1 : Fin 5 := Fin.succ (0 : Fin 4)
private abbrev e5i2 : Fin 5 := Fin.succ (Fin.succ (0 : Fin 3))
private abbrev e5i3 : Fin 5 := Fin.succ (Fin.succ (Fin.succ (0 : Fin 2)))
private abbrev e5i4 : Fin 5 :=
  Fin.succ (Fin.succ (Fin.succ (Fin.succ (0 : Fin 1))))

/-- Fourteen rational quadratic features giving a Gram decomposition of the
normalized degree-two Gegenbauer kernel on `S⁴`. -/
def gegenbauer5Degree2Feature : Fin 14 → Euclidean5 → ℝ := fun r x =>
  (![x e5i4 ^ 2 - (x e5i3 ^ 2 + x e5i2 ^ 2 + x e5i1 ^ 2 + x e5i0 ^ 2) / 4,
     x e5i3 ^ 2 - (x e5i2 ^ 2 + x e5i1 ^ 2 + x e5i0 ^ 2) / 3,
     x e5i2 ^ 2 - (x e5i1 ^ 2 + x e5i0 ^ 2) / 2,
     x e5i1 ^ 2 - x e5i0 ^ 2,
     x e5i3 * x e5i4,
     x e5i2 * x e5i4,
     x e5i2 * x e5i3,
     x e5i1 * x e5i4,
     x e5i1 * x e5i3,
     x e5i1 * x e5i2,
     x e5i0 * x e5i4,
     x e5i0 * x e5i3,
     x e5i0 * x e5i2,
     x e5i0 * x e5i1] : Fin 14 → ℝ) r

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
    e5i0, e5i1, e5i2, e5i3, e5i4, Fin.sum_univ_succ]
  ring_nf

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
    apply Finset.sum_congr rfl
    intro i hi
    simp
    ring
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

end

end R008
