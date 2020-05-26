AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "N. V. Smith. Optical constants of sodium and potassium from 0.5 to 4.0 eV by split-beam ellipsometry, <a href=\"https://doi.org/10.1103/PhysRev.183.634\"><i>Phs. Rev.</i> <b>183</b>, 634-644 (1969)</a>"


class AR.Chemistry.Materials.Elements.Sodium extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Sodium'

  @displayName: -> "sodium"
  @formula: -> 'Na'

  @initialize """
    0.312539 0.049195 1.006191
    0.334099 0.055220 1.131834
    0.364981 0.061078 1.326171
    0.386967 0.065120 1.474192
    0.404648 0.068960 1.537126
    0.420001 0.067744 1.631131
    0.439972 0.068302 1.756891
    0.469993 0.066149 1.882120
    0.505027 0.062846 2.068562
    0.545945 0.058647 2.233705
    0.599827 0.052637 2.479268
    0.661955 0.048526 2.761404
    0.750056 0.049548 3.219077
    0.859807 0.053026 3.724622
    1.009643 0.064101 4.352483
    1.175206 0.077963 5.111368
    1.344731 0.098586 5.822347
    1.530669 0.122821 6.668215
    1.689158 0.147176 7.419681
    1.839528 0.175119 8.094484
    1.980578 0.206644 8.800154
    2.119388 0.240865 9.451350
    2.237982 0.262406 9.967390
"""
