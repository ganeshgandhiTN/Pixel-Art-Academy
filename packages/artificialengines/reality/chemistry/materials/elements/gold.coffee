AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "P. B. Johnson and R. W. Christy. Optical constants of the noble metals, <a href=\"https://doi.org/10.1103/PhysRevB.6.4370\"><i>Phys. Rev. B</i> <b>6</b>, 4370-4379 (1972)</a>"
# COMMENTS: "Room temperature"

class AR.Chemistry.Materials.Elements.Gold extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Gold'

  @displayName: -> "gold"
  @formula: -> 'Au'

  @initialize """
    0.1879 1.28 1.188
    0.1916 1.32 1.203
    0.1953 1.34 1.226
    0.1993 1.33 1.251
    0.2033 1.33 1.277
    0.2073 1.30 1.304
    0.2119 1.30 1.350
    0.2164 1.30 1.387
    0.2214 1.30 1.427
    0.2262 1.31 1.460
    0.2313 1.30 1.497
    0.2371 1.32 1.536
    0.2426 1.32 1.577
    0.2490 1.33 1.631
    0.2551 1.33 1.688
    0.2616 1.35 1.749
    0.2689 1.38 1.803
    0.2761 1.43 1.847
    0.2844 1.47 1.869
    0.2924 1.49 1.878
    0.3009 1.53 1.889
    0.3107 1.53 1.893
    0.3204 1.54 1.898
    0.3315 1.48 1.883
    0.3425 1.48 1.871
    0.3542 1.50 1.866
    0.3679 1.48 1.895
    0.3815 1.46 1.933
    0.3974 1.47 1.952
    0.4133 1.46 1.958
    0.4305 1.45 1.948
    0.4509 1.38 1.914
    0.4714 1.31 1.849
    0.4959 1.04 1.833
    0.5209 0.62 2.081
    0.5486 0.43 2.455
    0.5821 0.29 2.863
    0.6168 0.21 3.272
    0.6595 0.14 3.697
    0.7045 0.13 4.103
    0.7560 0.14 4.542
    0.8211 0.16 5.083
    0.8920 0.17 5.663
    0.9840 0.22 6.350
    1.0880 0.27 7.150
    1.2160 0.35 8.145
    1.3930 0.43 9.519
    1.6100 0.56 11.21
    1.9370 0.92 13.78
"""
