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

/-!
# R008 formalization entry point

This development is staged. The exact rational certificate data, generated
Bernstein interval proofs, bridge to the frozen Gegenbauer certificate
polynomials, and generic finite-feature kernel positivity layer are included
now. The generated Gegenbauer sum-of-squares instances and the final
projection/graph/geometric closure are the remaining substantive formalization
milestones; see `FORMALIZATION_STATUS.md`.
-/
