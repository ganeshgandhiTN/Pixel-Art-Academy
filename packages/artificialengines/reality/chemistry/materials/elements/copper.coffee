AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "P. B. Johnson and R. W. Christy. Optical constants of the noble metals, <a href=\"https://doi.org/10.1103/PhysRevB.6.4370\"><i>Phys. Rev. B</i> <b>6</b>, 4370-4379 (1972)</a>"
# COMMENTS: "Room temperature"

class AR.Chemistry.Materials.Elements.Copper extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Copper'

  @displayName: -> "copper"
  @formula: -> 'Cu'

  @initialize """
    0.1879 0.94 1.337
    0.1916 0.95 1.388
    0.1953 0.97 1.440
    0.1993 0.98 1.493
    0.2033 0.99 1.550
    0.2073 1.01 1.599
    0.2119 1.04 1.651
    0.2164 1.08 1.699
    0.2214 1.13 1.737
    0.2262 1.18 1.768
    0.2313 1.23 1.792
    0.2371 1.28 1.802
    0.2426 1.34 1.799
    0.2490 1.37 1.783
    0.2551 1.41 1.741
    0.2616 1.41 1.691
    0.2689 1.45 1.668
    0.2761 1.46 1.646
    0.2844 1.45 1.633
    0.2924 1.42 1.633
    0.3009 1.40 1.679
    0.3107 1.38 1.729
    0.3204 1.38 1.783
    0.3315 1.34 1.821
    0.3425 1.36 1.864
    0.3542 1.37 1.916
    0.3679 1.36 1.975
    0.3815 1.33 2.045
    0.3974 1.32 2.116
    0.4133 1.28 2.207
    0.4305 1.25 2.305
    0.4509 1.24 2.397
    0.4714 1.25 2.483
    0.4959 1.22 2.564
    0.5209 1.18 2.608
    0.5486 1.02 2.577
    0.5821 0.70 2.704
    0.6168 0.30 3.205
    0.6595 0.22 3.747
    0.7045 0.21 4.205
    0.7560 0.24 4.665
    0.8211 0.26 5.180
    0.8920 0.30 5.768
    0.9840 0.32 6.421
    1.0880 0.36 7.217
    1.2160 0.48 8.245
    1.3930 0.60 9.439
    1.6100 0.76 11.12
    1.9370 1.09 13.43
"""
