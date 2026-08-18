import R008.Generated.GegenbauerData
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Tactic

set_option autoImplicit false

namespace R008

open Polynomial

/-- Unnormalized Gegenbauer polynomial `C_k^λ`, with
`λ = (d-2)/2`, parameterized by the ambient dimension `d`.

The intended R008 instances are `d=5` for `S^4` and `d=4` for `S^3`.
The recurrence is

`(n+1) C_(n+1) = 2(n+λ) X C_n - (n+2λ-1) C_(n-1)`.
-/
noncomputable def rawGegenbauer (d : ℚ) : Nat → Polynomial ℚ
  | 0 => 1
  | 1 => C (d - 2) * X
  | n + 2 =>
      C ((2 * (n : ℚ) + d) / (n + 2 : ℚ)) * X * rawGegenbauer d (n + 1) -
      C (((n : ℚ) + d - 2) / (n + 2 : ℚ)) * rawGegenbauer d n

/-- Gegenbauer polynomial normalized to have value one at `X=1`. -/
noncomputable def normalizedGegenbauer (d : ℚ) (k : Nat) : Polynomial ℚ :=
  C ((rawGegenbauer d k).eval 1)⁻¹ * rawGegenbauer d k

@[simp] theorem rawGegenbauer_zero (d : ℚ) : rawGegenbauer d 0 = 1 := rfl

@[simp] theorem rawGegenbauer_one (d : ℚ) :
    rawGegenbauer d 1 = C (d - 2) * X := rfl

/-- Conditional normalization theorem. Nonvanishing at one will be proved
for the dimensions/degrees used by R008, then generalized if useful. -/
theorem normalizedGegenbauer_eval_one {d : ℚ} {k : Nat}
    (h : (rawGegenbauer d k).eval 1 ≠ 0) :
    (normalizedGegenbauer d k).eval 1 = 1 := by
  simp [normalizedGegenbauer, h]

/-- Finite linear combination in the normalized Gegenbauer basis. -/
noncomputable def gegenbauerCombination
    (d : ℚ) (coefficients : List (Nat × ℚ)) : Polynomial ℚ :=
  coefficients.foldl
    (fun accumulator term =>
      accumulator + C term.2 * normalizedGegenbauer d term.1)
    0

/-- Frozen strong-certificate Gegenbauer coefficients. -/
def strongGegenbauerCoefficients : List (Nat × ℚ) := [
  (0, (13939907 : ℚ) / 100000000),
  (1, (12103401 : ℚ) / 25000000),
  (2, (139479103 : ℚ) / 100000000),
  (3, (30090377 : ℚ) / 25000000),
  (4, (41787773 : ℚ) / 25000000),
  (9, (38538027 : ℚ) / 50000000)
]

/-- Frozen moderate-certificate Gegenbauer coefficients. -/
def moderateGegenbauerCoefficients : List (Nat × ℚ) := [
  (0, (6113963 : ℚ) / 50000000),
  (1, (3549967 : ℚ) / 10000000),
  (2, (59464043 : ℚ) / 50000000),
  (3, (11303433 : ℚ) / 12500000),
  (4, (17480877 : ℚ) / 12500000),
  (9, (29954461 : ℚ) / 50000000)
]

/-- Frozen local projected-code Gegenbauer coefficients. -/
def localGegenbauerCoefficients : List (Nat × ℚ) := [
  (0, (99999 : ℚ) / 100000),
  (1, (153764653 : ℚ) / 50000000),
  (2, (89219103 : ℚ) / 25000000),
  (3, (163063619 : ℚ) / 100000000),
  (6, (13716513 : ℚ) / 100000000)
]

noncomputable def strongCertificatePolynomial : Polynomial ℚ :=
  gegenbauerCombination 5 strongGegenbauerCoefficients

noncomputable def moderateCertificatePolynomial : Polynomial ℚ :=
  gegenbauerCombination 5 moderateGegenbauerCoefficients

noncomputable def localCertificatePolynomial : Polynomial ℚ :=
  gegenbauerCombination 4 localGegenbauerCoefficients

/-- Exact finite check that all frozen Gegenbauer coefficients are
nonnegative. This is only the coefficient premise; kernel positivity is a
separate theorem. -/
def coefficientsNonnegative (coefficients : List (Nat × ℚ)) : Bool :=
  coefficients.all fun term => decide (0 ≤ term.2)

@[simp] theorem strongGegenbauerCoefficients_nonnegative :
    coefficientsNonnegative strongGegenbauerCoefficients = true := by
  norm_num [coefficientsNonnegative, strongGegenbauerCoefficients]

@[simp] theorem moderateGegenbauerCoefficients_nonnegative :
    coefficientsNonnegative moderateGegenbauerCoefficients = true := by
  norm_num [coefficientsNonnegative, moderateGegenbauerCoefficients]

@[simp] theorem localGegenbauerCoefficients_nonnegative :
    coefficientsNonnegative localGegenbauerCoefficients = true := by
  norm_num [coefficientsNonnegative, localGegenbauerCoefficients]

end R008
