import R008.FormalizationBoundary
import R008.Generated.BernsteinProofs
import Mathlib.Algebra.Algebra.Rat
import Mathlib.RingTheory.Polynomial.Eval.Defs
import Mathlib.Tactic

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

namespace R008

open Polynomial

/-- Evaluate an exact rational certificate polynomial as a real-valued
function. The coefficient map is the canonical embedding `ℚ → ℝ`. -/
noncomputable def evalRatPolynomial (p : Polynomial ℚ) (t : ℝ) : ℝ :=
  p.eval₂ (algebraMap ℚ ℝ) t

/-- The frozen strong Gegenbauer combination is exactly the power-basis
polynomial whose nonfar sign is certified by the generated Bernstein proof. -/
theorem strongCertificate_eval_eq_generated (t : ℝ) :
    evalRatPolynomial strongCertificatePolynomial t =
      GeneratedProofs.strongNonfarNegativePolynomial t := by
  norm_num [evalRatPolynomial, strongCertificatePolynomial,
    gegenbauerCombination, strongGegenbauerCoefficients,
    normalizedGegenbauer, rawGegenbauer,
    GeneratedProofs.strongNonfarNegativePolynomial]
  ring_nf

/-- The strong far certificate is exactly the positive gap `1 - f_s`. -/
theorem strongCertificate_gap_eq_generated (t : ℝ) :
    1 - evalRatPolynomial strongCertificatePolynomial t =
      GeneratedProofs.strongFarBelowOnePolynomial t := by
  rw [strongCertificate_eval_eq_generated]
  norm_num [GeneratedProofs.strongNonfarNegativePolynomial,
    GeneratedProofs.strongFarBelowOnePolynomial]
  ring_nf

/-- The frozen moderate Gegenbauer combination is exactly the power-basis
polynomial whose nonfar sign is certified by the generated Bernstein proof. -/
theorem moderateCertificate_eval_eq_generated (t : ℝ) :
    evalRatPolynomial moderateCertificatePolynomial t =
      GeneratedProofs.moderateNonfarNegativePolynomial t := by
  norm_num [evalRatPolynomial, moderateCertificatePolynomial,
    gegenbauerCombination, moderateGegenbauerCoefficients,
    normalizedGegenbauer, rawGegenbauer,
    GeneratedProofs.moderateNonfarNegativePolynomial]
  ring_nf

/-- The moderate far certificate is exactly the positive gap `1 - f_m`. -/
theorem moderateCertificate_gap_eq_generated (t : ℝ) :
    1 - evalRatPolynomial moderateCertificatePolynomial t =
      GeneratedProofs.moderateFarBelowOnePolynomial t := by
  rw [moderateCertificate_eval_eq_generated]
  norm_num [GeneratedProofs.moderateNonfarNegativePolynomial,
    GeneratedProofs.moderateFarBelowOnePolynomial]
  ring_nf

/-- The frozen local `S³` Gegenbauer combination is exactly the power-basis
polynomial certified on the projected-code interval. -/
theorem localCertificate_eval_eq_generated (t : ℝ) :
    evalRatPolynomial localCertificatePolynomial t =
      GeneratedProofs.localNegativePolynomial t := by
  norm_num [evalRatPolynomial, localCertificatePolynomial,
    gegenbauerCombination, localGegenbauerCoefficients,
    normalizedGegenbauer, rawGegenbauer,
    GeneratedProofs.localNegativePolynomial]
  ring_nf

/-- Kernel-checked interval signs for the actual three frozen Gegenbauer
certificate polynomials. This discharges the temporary interval-certificate
interface in `FormalizationBoundary`; no analytic positivity hypothesis is
used here. -/
theorem frozenCertificateSignFacts :
    CertificateSignFacts
      (evalRatPolynomial strongCertificatePolynomial)
      (evalRatPolynomial moderateCertificatePolynomial)
      (evalRatPolynomial localCertificatePolynomial) := by
  refine {
    strong_nonfar := ?_,
    strong_far := ?_,
    moderate_nonfar := ?_,
    moderate_far := ?_,
    local_negative := ?_
  }
  · intro t hLeft hRight
    rw [strongCertificate_eval_eq_generated]
    exact GeneratedProofs.strongNonfarNegativeCertified t hLeft hRight
  · intro t hLeft hRight
    have hGap : 0 < 1 - evalRatPolynomial strongCertificatePolynomial t := by
      rw [strongCertificate_gap_eq_generated]
      exact GeneratedProofs.strongFarBelowOneCertified t hLeft hRight
    linarith
  · intro t hLeft hRight
    rw [moderateCertificate_eval_eq_generated]
    exact GeneratedProofs.moderateNonfarNegativeCertified t hLeft hRight
  · intro t hLeft hRight
    have hGap : 0 < 1 - evalRatPolynomial moderateCertificatePolynomial t := by
      rw [moderateCertificate_gap_eq_generated]
      exact GeneratedProofs.moderateFarBelowOneCertified t hLeft hRight
    linarith
  · intro t hLeft hRight
    rw [localCertificate_eval_eq_generated]
    exact GeneratedProofs.localNegativeCertified t hLeft hRight

end R008
