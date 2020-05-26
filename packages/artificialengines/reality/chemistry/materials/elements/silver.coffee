AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "P. B. Johnson and R. W. Christy. Optical constants of the noble metals, <a href=\"https://doi.org/10.1103/PhysRevB.6.4370\"><i>Phys. Rev. B</i> <b>6</b>, 4370-4379 (1972)</a>"
# COMMENTS: "Room temperature"

class AR.Chemistry.Materials.Elements.Silver extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Silver'

  @displayName: -> "silver"
  @formula: -> 'Ag'

  @initialize """
    0.1879 1.07 1.212
    0.1916 1.10 1.232
    0.1953 1.12 1.255
    0.1993 1.14 1.277
    0.2033 1.15 1.296
    0.2073 1.18 1.312
    0.2119 1.20 1.325
    0.2164 1.22 1.336
    0.2214 1.25 1.342
    0.2262 1.26 1.344
    0.2313 1.28 1.357
    0.2371 1.28 1.367
    0.2426 1.30 1.378
    0.2490 1.31 1.389
    0.2551 1.33 1.393
    0.2616 1.35 1.387
    0.2689 1.38 1.372
    0.2761 1.41 1.331
    0.2844 1.41 1.264
    0.2924 1.39 1.161
    0.3009 1.34 0.964
    0.3107 1.13 0.616
    0.3204 0.81 0.392
    0.3315 0.17 0.829
    0.3425 0.14 1.142
    0.3542 0.10 1.419
    0.3679 0.07 1.657
    0.3815 0.05 1.864
    0.3974 0.05 2.070
    0.4133 0.05 2.275
    0.4305 0.04 2.462
    0.4509 0.04 2.657
    0.4714 0.05 2.869
    0.4959 0.05 3.093
    0.5209 0.05 3.324
    0.5486 0.06 3.586
    0.5821 0.05 3.858
    0.6168 0.06 4.152
    0.6595 0.05 4.483
    0.7045 0.04 4.838
    0.7560 0.03 5.242
    0.8211 0.04 5.727
    0.8920 0.04 6.312
    0.9840 0.04 6.992
    1.0880 0.04 7.795
    1.2160 0.09 8.828
    1.3930 0.13 10.10
    1.6100 0.15 11.85
    1.9370 0.24 14.08
"""
