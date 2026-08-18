import Mathlib.Tactic

set_option autoImplicit false

namespace R008

/-- Affine coordinate sending `[left,right]` to `[0,1]`. -/
noncomputable def unitCoordinate (left right t : ℝ) : ℝ :=
  (t - left) / (right - left)

theorem unitCoordinate_mem {left right t : ℝ}
    (hInterval : left < right) (hLeft : left ≤ t) (hRight : t ≤ right) :
    unitCoordinate left right t ∈ Set.Icc (0 : ℝ) 1 := by
  constructor
  · exact div_nonneg (sub_nonneg.mpr hLeft) (sub_nonneg.mpr (le_of_lt hInterval))
  · rw [unitCoordinate, div_le_one (sub_pos.mpr hInterval)]
    linarith

theorem affine_unitCoordinate {left right t : ℝ}
    (hInterval : left < right) :
    left + (right - left) * unitCoordinate left right t = t := by
  rw [unitCoordinate]
  field_simp [ne_of_gt (sub_pos.mpr hInterval)]
  ring

end R008
