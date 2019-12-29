AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "P. B. Johnson and R. W. Christy. Optical constants of transition metals: Ti, V, Cr, Mn, Fe, Co, Ni, and Pd, <a href=\"https://doi.org/10.1103/PhysRevB.9.5056\"><i>Phys. Rev. B</i> <b>9</b>, 5056-5070 (1974)</a>"
# COMMENTS: "Room temperature"

class AR.Chemistry.Materials.Elements.Chromium extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Chromium'

  @displayName: -> "chromium"
  @formula: -> 'Cr'

  @initialize """
    0.188 1.28 1.64
    0.192 1.31 1.65
    0.195 1.35 1.68
    0.199 1.39 1.70
    0.203 1.43 1.70
    0.207 1.46 1.71
    0.212 1.46 1.72
    0.216 1.47 1.72
    0.221 1.45 1.73
    0.226 1.43 1.74
    0.231 1.40 1.77
    0.237 1.38 1.80
    0.243 1.36 1.85
    0.249 1.36 1.91
    0.255 1.37 1.97
    0.262 1.38 2.03
    0.269 1.39 2.08
    0.276 1.43 2.15
    0.284 1.45 2.21
    0.292 1.48 2.28
    0.301 1.53 2.34
    0.311 1.58 2.40
    0.320 1.65 2.47
    0.332 1.69 2.53
    0.342 1.76 2.58
    0.354 1.84 2.64
    0.368 1.87 2.69
    0.381 1.92 2.74
    0.397 2.00 2.83
    0.413 2.08 2.93
    0.431 2.19 3.04
    0.451 2.33 3.14
    0.471 2.51 3.24
    0.496 2.75 3.30
    0.521 2.94 3.33
    0.549 3.18 3.33
    0.582 3.22 3.30
    0.617 3.17 3.30
    0.659 3.09 3.34
    0.704 3.05 3.39
    0.756 3.08 3.42
    0.821 3.20 3.48
    0.892 3.30 3.52
    0.984 3.41 3.57
    1.088 3.58 3.58
    1.216 3.67 3.60
    1.393 3.69 3.84
    1.610 3.66 4.31
    1.937 3.71 5.04
"""
