import R008.Constants
import Mathlib.Tactic

set_option autoImplicit false

namespace R008

/-- The strong deficit lies strictly above `2` and at most `4`, hence the
edge-count lemma yields a ceiling of two after division by two. -/
theorem strongDeficit_window :
    (2 : ℚ) < strongDeficit ∧ strongDeficit ≤ 4 := by
  norm_num [strongDeficit]

/-- The moderate deficit lies strictly above `18` and at most `20`, hence the
edge-count lemma yields a ceiling of ten after division by two. -/
theorem moderateDeficit_window :
    (18 : ℚ) < moderateDeficit ∧ moderateDeficit ≤ 20 := by
  norm_num [moderateDeficit]

@[simp] theorem localObjective_lt_ten : localObjective < 10 := by
  norm_num [localObjective]

@[simp] theorem strong_midpoint_norm_sq :
    (1 - strongA) / 2 = (183 : ℚ) / 1250 := by
  norm_num [strongA]

@[simp] theorem strong_difference_norm_sq :
    (1 + strongA) / 2 = (1067 : ℚ) / 1250 := by
  norm_num [strongA]

@[simp] theorem moderate_midpoint_norm_sq :
    (1 - moderateA) / 2 = (67 : ℚ) / 400 := by
  norm_num [moderateA]

@[simp] theorem moderate_difference_norm_sq :
    (1 + moderateA) / 2 = (333 : ℚ) / 400 := by
  norm_num [moderateA]

/-- Auxiliary exact quantities that eliminate square roots from the final
`779/1000` comparison. -/
def axisU : ℚ := (1 - strongA) * (1 - moderateA)
def axisV : ℚ := (1 + strongA) * (1 + moderateA)
def axisW : ℚ := axisTarget ^ 2 * axisV - 1 - axisU

theorem axisU_exact : axisU = (12261 : ℚ) / 125000 := by
  norm_num [axisU, strongA, moderateA]

theorem axisV_exact : axisV = (355311 : ℚ) / 125000 := by
  norm_num [axisV, strongA, moderateA]

theorem axisW_exact : axisW = (78356282551 : ℚ) / 125000000000 := by
  norm_num [axisW, axisU, axisV, axisTarget, strongA, moderateA]

@[simp] theorem axisW_pos : 0 < axisW := by
  rw [axisW_exact]
  norm_num

/-- Squared form of the strict radical comparison.  Together with
`axisW_pos`, this is the exact arithmetic certificate used to prove the
normalized difference-axis bound. -/
theorem axis_discriminant_exact :
    axisW ^ 2 - 4 * axisU =
      (9207015212147067601 : ℚ) / 15625000000000000000000 := by
  norm_num [axisW, axisU, axisV, axisTarget, strongA, moderateA]

@[simp] theorem axis_discriminant_pos : 0 < axisW ^ 2 - 4 * axisU := by
  rw [axis_discriminant_exact]
  norm_num

end R008
