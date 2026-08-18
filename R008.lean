import R008.Constants
import R008.Numeric
import R008.Bernstein
import R008.Generated.BernsteinData
import R008.Generated.BernsteinProofs
import R008.CertificateCheck
import R008.DelsarteArithmetic
import R008.Gegenbauer
import R008.GraphCombinatorics
import R008.Generated.GegenbauerData
import R008.SphericalCode
import R008.FormalizationBoundary
import R008.CertificateBridge
import R008.FeatureKernel
import R008.GegenbauerSOS

/-!
# R008 formalization entry point

This development is staged. The exact rational certificate data, generated
Bernstein interval proofs, bridge to the frozen Gegenbauer certificate
polynomials, generic finite-feature kernel positivity layer, and the first
nontrivial exact Gegenbauer SOS instance are included now. The remaining
Gegenbauer basis degrees and the final projection/graph/geometric closure are
the substantive formalization milestones; see the repository status notes.
-/
