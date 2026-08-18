import R008.Numeric
import Mathlib.Tactic

set_option autoImplicit false

namespace R008

/-- Pure arithmetic core of the edge-count Delsarte argument.  The substantive
future theorem must derive `hLower` from Gegenbauer positive definiteness and
`hUpper` from the two sign intervals. -/
theorem edgeCount_lower_bound_of_sandwich
    {a0 pointCount diagonalValue edgeCount total : ℝ}
    (hLower : a0 * pointCount ^ 2 ≤ total)
    (hUpper : total ≤ pointCount * diagonalValue + 2 * edgeCount) :
    (a0 * pointCount ^ 2 - pointCount * diagonalValue) / 2 ≤ edgeCount := by
  linarith

/-- Integer-facing form: if the exact deficit exceeds `2(m-1)`, then an
integer edge count satisfying the analytic lower bound is at least `m`. -/
theorem natEdgeCount_ge_of_deficit
    {deficit : ℝ} {edgeCount m : ℕ}
    (hBound : deficit / 2 ≤ (edgeCount : ℝ))
    (hStrict : (2 : ℝ) * (m - 1 : ℕ) < deficit) :
    m ≤ edgeCount := by
  by_contra h
  have hlt : edgeCount < m := Nat.lt_of_not_ge h
  have hle : edgeCount ≤ m - 1 := Nat.le_pred_of_lt hlt
  have hcast : (edgeCount : ℝ) ≤ (m - 1 : ℕ) := by
    exact_mod_cast hle
  linarith

/-- Exact integer extraction for the strong R008 certificate. -/
theorem strongEdgeCount_ge_two_of_analytic_bound {edgeCount : ℕ}
    (hBound : ((strongDeficit : ℚ) : ℝ) / 2 ≤ (edgeCount : ℝ)) :
    2 ≤ edgeCount := by
  apply natEdgeCount_ge_of_deficit hBound
  norm_num [strongDeficit]

/-- Exact integer extraction for the moderate R008 certificate. -/
theorem moderateEdgeCount_ge_ten_of_analytic_bound {edgeCount : ℕ}
    (hBound : ((moderateDeficit : ℚ) : ℝ) / 2 ≤ (edgeCount : ℝ)) :
    10 ≤ edgeCount := by
  apply natEdgeCount_ge_of_deficit hBound
  norm_num [moderateDeficit]

/-- The local Delsarte objective is strictly below ten, so any natural
cardinality bounded above by it is at most nine. -/
theorem nat_le_nine_of_le_localObjective {cardinality : ℕ}
    (hBound : (cardinality : ℝ) ≤ ((localObjective : ℚ) : ℝ)) :
    cardinality ≤ 9 := by
  by_contra h
  have hTen : 10 ≤ cardinality := by omega
  have hCast : (10 : ℝ) ≤ cardinality := by exact_mod_cast hTen
  have hObj : ((localObjective : ℚ) : ℝ) < 10 := by
    norm_num [localObjective]
  linarith

end R008
