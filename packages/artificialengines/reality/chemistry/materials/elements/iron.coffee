AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "P. B. Johnson and R. W. Christy. Optical constants of transition metals: Ti, V, Cr, Mn, Fe, Co, Ni, and Pd, <a href=\"https://doi.org/10.1103/PhysRevB.9.5056\"><i>Phys. Rev. B</i> <b>9</b>, 5056-5070 (1974)</a>"
# COMMENTS: "Room temperature"

class AR.Chemistry.Materials.Elements.Iron extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Iron'

  @displayName: -> "iron"
  @formula: -> 'Fe'

  @initialize """
    0.188 1.29 1.35
    0.192 1.35 1.37
    0.195 1.42 1.39
    0.199 1.45 1.40
    0.203 1.47 1.40
    0.207 1.49 1.41
    0.212 1.47 1.43
    0.216 1.47 1.44
    0.221 1.47 1.47
    0.226 1.47 1.49
    0.231 1.48 1.53
    0.237 1.48 1.57
    0.243 1.50 1.61
    0.249 1.51 1.66
    0.255 1.53 1.70
    0.262 1.56 1.75
    0.269 1.59 1.79
    0.276 1.62 1.84
    0.284 1.64 1.88
    0.292 1.65 1.94
    0.301 1.67 2.00
    0.311 1.69 2.06
    0.320 1.74 2.12
    0.332 1.78 2.19
    0.342 1.85 2.27
    0.354 1.93 2.35
    0.368 2.02 2.43
    0.381 2.12 2.50
    0.397 2.24 2.58
    0.413 2.35 2.65
    0.431 2.48 2.71
    0.451 2.59 2.77
    0.471 2.67 2.82
    0.496 2.74 2.88
    0.521 2.86 2.91
    0.549 2.95 2.93
    0.582 2.94 2.99
    0.617 2.88 3.05
    0.659 2.92 3.10
    0.704 2.86 3.19
    0.756 2.87 3.28
    0.821 2.94 3.39
    0.892 2.96 3.56
    0.984 2.92 3.79
    1.088 2.97 4.06
    1.216 3.03 4.39
    1.393 3.09 4.83
    1.610 3.11 5.39
    1.937 3.17 6.12
"""
