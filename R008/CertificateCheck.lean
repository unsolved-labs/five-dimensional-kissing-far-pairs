import R008.Generated.BernsteinData
import Mathlib.Data.List.Basic
import Mathlib.Tactic

set_option autoImplicit false

namespace R008.CertificateCheck

open R008.Generated

/-- Read a power-basis coefficient, returning zero outside the list. -/
def coeff (p : List ℚ) (i : Nat) : ℚ := p.getD i 0

def zeros (n : Nat) : List ℚ := List.replicate n 0

def one (n : Nat) : List ℚ :=
  match n with
  | 0 => []
  | m + 1 => 1 :: List.replicate m 0

def polyAddN (n : Nat) (p q : List ℚ) : List ℚ :=
  (List.range n).map fun i => coeff p i + coeff q i

def polyScaleN (n : Nat) (c : ℚ) (p : List ℚ) : List ℚ :=
  (List.range n).map fun i => c * coeff p i

def polyMulN (n : Nat) (p q : List ℚ) : List ℚ :=
  (List.range n).map fun k =>
    ((List.range (k + 1)).map fun i => coeff p i * coeff q (k - i)).sum

/-- Exact coefficient computation for `p(left + (right-left) X)`, truncated
at the supplied fixed coefficient count. All generated R008 polynomials use
`n = degree + 1`, so no nonzero term is truncated. -/
def affineSubstituteN (n : Nat) (p : List ℚ) (left right : ℚ) : List ℚ :=
  let affine : List ℚ := [left, right - left]
  let initial : List ℚ × List ℚ := (one n, zeros n)
  let final := p.foldl
    (fun state c =>
      let power := state.1
      let accumulator := state.2
      (polyMulN n power affine,
        polyAddN n accumulator (polyScaleN n c power)))
    initial
  final.2

def chooseRat (n k : Nat) : ℚ := (Nat.choose n k : ℚ)

/-- Power-to-Bernstein conversion in fixed degree `degree`:
`β_k = Σ_{i≤k} c_i * choose(k,i)/choose(degree,i)`. -/
def powerToBernstein (degree : Nat) (p : List ℚ) : List ℚ :=
  (List.range (degree + 1)).map fun k =>
    ((List.range (k + 1)).map fun i =>
      coeff p i * chooseRat k i / chooseRat degree i).sum

def strictSignOK (wantsNegative : Bool) (xs : List ℚ) : Bool :=
  if wantsNegative then
    xs.all fun x => decide (x < 0)
  else
    xs.all fun x => decide (0 < x)

def validPiece (certificate : BernsteinCertificate)
    (piece : BernsteinPiece) : Bool :=
  let n := certificate.degree + 1
  decide (piece.left < piece.right) &&
    (piece.affinePower.length == n) &&
    (piece.bernstein.length == n) &&
    (piece.affinePower ==
      affineSubstituteN n certificate.originalPower piece.left piece.right) &&
    (piece.bernstein == powerToBernstein certificate.degree piece.affinePower) &&
    strictSignOK certificate.wantsNegative piece.bernstein

def validChain (certificate : BernsteinCertificate) :
    ℚ → List BernsteinPiece → Bool
  | current, [] => decide (current = certificate.originalRight)
  | current, piece :: rest =>
      decide (piece.left = current) &&
        validPiece certificate piece &&
        validChain certificate piece.right rest

def validCertificate (certificate : BernsteinCertificate) : Bool :=
  decide (certificate.originalLeft < certificate.originalRight) &&
    (certificate.originalPower.length == certificate.degree + 1) &&
    validChain certificate certificate.originalLeft certificate.pieces

/-- Structural sanity check for the generated bundle. The stronger proof of
all 48 affine identities and strict coefficient signs is generated in
`R008.Generated.BernsteinProofs` and checked by the Lean kernel. Keeping this
small theorem avoids replacing those explicit proof terms with one opaque,
resource-heavy reduction. -/
theorem generatedCertificateCount :
    R008.Generated.allCertificates.length = 5 := by
  rfl

end R008.CertificateCheck
