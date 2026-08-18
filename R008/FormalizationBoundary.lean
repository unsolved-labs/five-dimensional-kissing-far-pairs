import R008.Constants
import R008.Gegenbauer
import R008.SphericalCode
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

set_option autoImplicit false

open scoped BigOperators InnerProductSpace

namespace R008

/-- Exact interval-sign facts expected from the Bernstein certificate layer.
This structure is a temporary interface: the final development should produce
it from `Generated.allCertificates` and the generic Bernstein bridge. -/
structure CertificateSignFacts
    (strongPolynomial moderatePolynomial localPolynomial : ℝ → ℝ) : Prop where
  strong_nonfar : ∀ t, -(442 : ℝ) / 625 ≤ t → t ≤ 1 / 2 →
    strongPolynomial t < 0
  strong_far : ∀ t, -1 ≤ t → t ≤ -(442 : ℝ) / 625 →
    strongPolynomial t < 1
  moderate_nonfar : ∀ t, -(133 : ℝ) / 200 ≤ t → t ≤ 1 / 2 →
    moderatePolynomial t < 0
  moderate_far : ∀ t, -1 ≤ t → t ≤ -(133 : ℝ) / 200 →
    moderatePolynomial t < 1
  local_negative : ∀ t, -1 ≤ t → t ≤ (2311 : ℝ) / 22311 →
    localPolynomial t < 0

/-- Positive definiteness of a kernel on one finite spherical code. This is a
legitimate reusable interface, not a postulated R008 theorem. -/
def KernelPositiveOn {ι E : Type*} [Fintype ι]
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (C : SphericalCode ι E) (K : E → E → ℝ) : Prop :=
  ∀ weights : ι → ℝ,
    0 ≤ ∑ i, ∑ j,
      weights i * weights j * K (C.point i) (C.point j)

/-- The precise shape of the missing Gegenbauer theorem: instantiate
`KernelPositiveOn` with a normalized Gegenbauer polynomial evaluated at inner
products. The final proof must construct this fact; no axiom is introduced
here. -/
def GegenbauerPositiveOn {ι E : Type*} [Fintype ι]
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (C : SphericalCode ι E) (P : ℝ → ℝ) : Prop :=
  KernelPositiveOn C (fun x y => P ⟪x, y⟫_ℝ)

/-- Public machine-readable marker. It remains false until the actual
Gegenbauer, Delsarte, projection, graph, and geometry chain exports the final
R008 theorem. -/
def fullR008LeanVerificationAvailable : Bool := false

end R008
