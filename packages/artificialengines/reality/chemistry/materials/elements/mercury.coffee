AR = Artificial.Reality

# Adapted from refractiveindex.info database.
# Refractiveindex.info database is in the public domain.
# Copyright and related rights waived via CC0 1.0.
#
# REFERENCES: "T. Inagaki, E. T. Arakawa, and M. W. Williams. Optical properties of liquid mercury, <a href=\"https://doi.org/10.1103/PhysRevB.23.5246\"><i>Phys. Rev. B</i> <b>23</b>, 5246-5262 (1981)</a>"
# COMMENTS: "Liquid mercury at room temperature"

class AR.Chemistry.Materials.Elements.Mercury extends AR.Chemistry.Materials.TabulatedMaterial
  @id: -> 'Artificial.Reality.Chemistry.Materials.Elements.Mercury'

  @displayName: -> "mercury"
  @formula: -> 'Hg'

  @initialize """
    0.06358 1.20846 0.36385
    0.06525 1.20004 0.36620
    0.06702 1.19493 0.36722
    0.06888 1.19073 0.36721
    0.07085 1.18399 0.36584
    0.07293 1.17740 0.36644
    0.07514 1.16958 0.36731
    0.07749 1.15865 0.36806
    0.07999 1.14630 0.37416
    0.08266 1.13509 0.38266
    0.08551 1.12510 0.39352
    0.08856 1.11530 0.40361
    0.09184 1.10417 0.41615
    0.09537 1.09246 0.42949
    0.09919 1.07841 0.44505
    0.10332 1.06391 0.46691
    0.10781 1.05005 0.49093
    0.11271 1.03950 0.52333
    0.11480 1.03857 0.53631
    0.11697 1.04130 0.55027
    0.11922 1.04545 0.56148
    0.12155 1.05405 0.56923
    0.12398 1.06152 0.56711
    0.12651 1.06094 0.55658
    0.12915 1.04397 0.54072
    0.13190 1.00864 0.54777
    0.13477 0.98779 0.56844
    0.13776 0.97457 0.58846
    0.14089 0.96496 0.60676
    0.14417 0.95609 0.62442
    0.14760 0.95275 0.63815
    0.15120 0.95194 0.64552
    0.15498 0.94600 0.63900
    0.15895 0.92904 0.62323
    0.16314 0.89270 0.59650
    0.16755 0.81658 0.57385
    0.17220 0.71715 0.58405
    0.17712 0.58506 0.61668
    0.17969 0.50958 0.67614
    0.18233 0.45880 0.75545
    0.18505 0.43760 0.83582
    0.18785 0.43614 0.89823
    0.19074 0.42769 0.94927
    0.19373 0.41230 1.00194
    0.19680 0.39938 1.05826
    0.19997 0.38978 1.11845
    0.20664 0.38613 1.23211
    0.21377 0.38584 1.34122
    0.22140 0.38658 1.45377
    0.22960 0.39348 1.56934
    0.23843 0.40109 1.68667
    0.24797 0.41398 1.80565
    0.25830 0.43087 1.92864
    0.26953 0.45157 2.05838
    0.28178 0.47636 2.19475
    0.29520 0.50656 2.34128
    0.30996 0.54187 2.50152
    0.32627 0.58934 2.66483
    0.34440 0.64425 2.85991
    0.36466 0.71303 3.07350
    0.38745 0.79824 3.29351
    0.41328 0.89800 3.53785
    0.44280 1.02698 3.80193
    0.47686 1.18600 4.08981
    0.51660 1.38332 4.40608
    0.56356 1.62088 4.75050
    0.61992 1.90988 5.14953
    0.68880 2.28417 5.58189
    0.77490 2.74611 6.05402
    0.88560 3.32380 6.55726
    1.03320 4.05007 7.08259
    1.23984 4.96140 7.64300
    1.54980 6.08732 8.31237
    2.06640 7.57453 9.19529
    3.09960 9.74110 10.6456
    6.19921 13.9816 14.2652
"""