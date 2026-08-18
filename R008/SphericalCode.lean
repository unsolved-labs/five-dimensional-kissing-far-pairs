import Mathlib.Analysis.InnerProductSpace.EuclideanDist
import Mathlib.Analysis.InnerProductSpace.GramMatrix

set_option autoImplicit false

namespace R008

/-- Finite spherical-code data in a real inner-product space.  This definition
is intentionally independent of dimension; the final R008 theorem will add a
five-dimensionality hypothesis. -/
structure SphericalCode (ι E : Type*) [Fintype ι]
    [NormedAddCommGroup E] [InnerProductSpace ℝ E] where
  point : ι → E
  unit_norm : ∀ i, ‖point i‖ = 1
  inner_le_half : ∀ ⦃i j⦄, i ≠ j →
    ⟪point i, point j⟫_ℝ ≤ (1 : ℝ) / 2

/-- The threshold-`a` far-pair relation.  It is irreflexive by definition and
will be shown symmetric from real-inner-product symmetry. -/
def SphericalCode.Far {ι E : Type*} [Fintype ι]
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (C : SphericalCode ι E) (a : ℝ) (i j : ι) : Prop :=
  i ≠ j ∧ ⟪C.point i, C.point j⟫_ℝ < -a

end R008
