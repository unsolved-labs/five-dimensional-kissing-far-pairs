import Mathlib.Tactic

set_option autoImplicit false

namespace R008

/-- Absolute value of the strong far-pair threshold. -/
def strongA : ℚ := (442 : ℚ) / 625

/-- Absolute value of the moderate far-pair threshold. -/
def moderateA : ℚ := (133 : ℚ) / 200

/-- Projected local-code cap used in the degree-nine certificate. -/
def localCap : ℚ := (2311 : ℚ) / 22311

/-- Strict target for the normalized difference-axis inner product. -/
def axisTarget : ℚ := (779 : ℚ) / 1000

/-- Exact strong Delsarte deficit `41² a₀ - 41 f_s(1)`. -/
def strongDeficit : ℚ := (209711679 : ℚ) / 100000000

/-- Exact moderate Delsarte deficit `41² a₀ - 41 f_m(1)`. -/
def moderateDeficit : ℚ := (912370581 : ℚ) / 50000000

/-- Exact local Delsarte objective `g(1) / b₀`. -/
def localObjective : ℚ := (18823697 : ℚ) / 1999980

@[simp] theorem strongA_pos : 0 < strongA := by
  norm_num [strongA]

@[simp] theorem strongA_lt_one : strongA < 1 := by
  norm_num [strongA]

@[simp] theorem moderateA_pos : 0 < moderateA := by
  norm_num [moderateA]

@[simp] theorem moderateA_lt_one : moderateA < 1 := by
  norm_num [moderateA]

@[simp] theorem localCap_eq_projection :
    localCap = ((1 / 2 : ℚ) - moderateA ^ 2) / (1 - moderateA ^ 2) := by
  norm_num [localCap, moderateA]

end R008
