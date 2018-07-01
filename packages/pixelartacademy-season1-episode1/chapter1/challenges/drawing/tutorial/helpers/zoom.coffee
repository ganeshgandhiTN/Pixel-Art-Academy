LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PixelArtAcademy.Season1.Episode1.Chapter1

class C1.Challenges.Drawing.Tutorial.Helpers.Zoom extends PAA.Practice.Challenges.Drawing.TutorialSprite
  @id: -> 'PixelArtAcademy.Season1.Episode1.Chapter1.Challenges.Drawing.Tutorial.Helpers.Zoom'

  @displayName: -> "Zoom"

  @description: -> """
      Use the plus and minus signs on the calculator to zoom in and out to make drawing easier.

      Shortcuts: + and -
    """

  @fixedDimensions: -> width: 64, height: 40
  @restrictedPaletteName: -> LOI.Assets.Palette.SystemPaletteNames.black

  @bitmapString: -> """
      |                    0000
      |                   000 000 0 000000000000000000
      |                 000 00 0000000000000    00000000
      |      00000     00000000 0     00  0    0 0    000    00000
      |     0    00   0 000000 00  0      0    0  0    0 0  00    0
      |     0    00000 0 000000 0  00000000 0     0     0 0000    0
      |      0000000 000 000 0 00        0 0    0 0     0000000000
      |             00    000000         0 0    0  0     0 0
      |             00    000000         00  0  00 0     00 0
      |            00      0 00           0  0  000       00 0
      |           0000 0000000000000       000000        000000
      |         00  0 0 0000000000  00 0 00 0000 00  000000 0 000
      |       00     0  00000000000  00 0  0    0  00 0 0      0 0
      |    000    0 0000             00000000000000000 0 0    0 0 0
      |  00    0 0 0000 0 0 0 0 0 0 0 0 0 0 0 0 000000  0 0        00
      | 0   0 0 0 0000000000000000000000000000000000000  0 0 0 0     0
      |0       0 0                                                    0
      |0  0 0 0 0 0   0 0     0               0 0 0   0 0 0 0 0 0 0 0 0
      |0 0 0 0 0 0 0 0 0 0 0 0                 0 0 0 0 0 0 0 0 0 0 0000
      |000000000000000000000000               000000000000000000000000
      |  0 0 0 0    00000000000               000000000000    0 0 0 000
      |  00 0 00    00000000000               000000000000    00 0 0 00
      | 00000000000000000000000               0000000000000000000000000
      | 00 0 0 0 0 000000000000               0000000000000 0 0 0 0 0 0
      | 00000000000000000000000               0000000000000000000000000
      |0                     0                                       00
      |0    0 0 0 0 0 0 0 0 0 0               0 0 0 0 0 0 0 0 0 0 0 0 0
      |0 0           0 0 0 0 00               00 0 0 0 0 0 0 0 0 0 0 00
      |00 0 0 0 0 0   0   0 0 0               0 0 0     0     0 0 0 0 0
      |0       0 0 0000 0000000               000000 0000 00 0000000000
      |00 0 0 0 0  000000000000               000000000000000 0 0 0 0 0
      | 0  0 0 0 00000000000000               0000000000000000000000000
      | 0 0 0 0 0 00000000000000000000000000000000000000000 0 0 0 0 00
      | 00 0 000000000000000000000000000000000000000000000000000000000
      | 00000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 000000
      | 00000000000000000000000000000000000000000000000000000000000000
      | 00 00000000000000000000000000000000000000000000000000000000000
      | 0 00000000000  00000000000000000000000000000000 00000000000000
      | 00 0 00000000                                   00000000000000
      |  00000000000                                     000000000000
    """

  @goalBitmapString: -> """
      |                    0000
      |                   000 000 0 000000000000000000
      |                 000 00 0000000000000    00000000
      |      00000     00000000 0     00  0    0 0    000    00000
      |     0    00   0 000000 00  0      0    0  0    0 0  00    0
      |     0    00000 0 000000 0  00000000 0     0     0 0000    0
      |      0000000 000 000 0 00        0 0    0 0     0000000000
      |             00    000000         0 0    0  0     0 0
      |             00    000000         00  0  00 0     00 0
      |            00      0 00           0  0  000       00 0
      |           0000 0000000000000       000000        000000
      |         00  0 0 0000000000  00 0 00 0000 00  000000 0 000
      |       00     0  00000000000  00 0  0    0  00 0 0      0 0
      |    000    0 0000             00000000000000000 0 0    0 0 0
      |  00    0 0 0000 0 0 0 0 0 0 0 0 0 0 0 0 000000  0 0        00
      | 0   0 0 0 0000000000000000000000000000000000000  0 0 0 0     0
      |0       0 0                                                    0
      |0  0 0 0 0 0   0 0     0   0 0 0 0 0 0 0 0 0   0 0 0 0 0 0 0 0 0
      |0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 000 0 0 0 0 0 0 0 0 0 0 0 0 0 0000
      |000000000000000000000000000000  0000000000000000000000000000000
      |  0 0 0 0    0000000000000000 0  000000000000000000    0 0 0 000
      |  00 0 00    000000000000000000 0000000000000000000    00 0 0 00
      | 0000000000000000000000000000    0 00000000000000000000000000000
      | 00 0 0 0 0 00000000000000000 0   000000000000000000 0 0 0 0 0 0
      | 00000000000000000000000000000 0 0000000000000000000000000000000
      |0                     0   0   0 000   0                       00
      |0    0 0 0 0 0 0 0 0 0 00000000000000000 0 0 0 0 0 0 0 0 0 0 0 0
      |0 0           0 0 0 0 00  0  0  0 0    00 0 0 0 0 0 0 0 0 0 0 00
      |00 0 0 0 0 0   0   0 0 0    0    0 0   0 0 0     0     0 0 0 0 0
      |0       0 0 0000 0000000  0      0     000000 0000 00 0000000000
      |00 0 0 0 0  000000000000   0 00  0 0   000000000000000 0 0 0 0 0
      | 0  0 0 0 00000000000000               0000000000000000000000000
      | 0 0 0 0 0 00000000000000000000000000000000000000000 0 0 0 0 00
      | 00 0 000000000000000000000000000000000000000000000000000000000
      | 00000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 000000
      | 00000000000000000000000000000000000000000000000000000000000000
      | 00 00000000000000000000000000000000000000000000000000000000000
      | 0 00000000000  00000000000000000000000000000000 00000000000000
      | 00 0 00000000                                   00000000000000
      |  00000000000                                     000000000000
    """

  @spriteInfo: -> "Artwork from Out Run (ZX Spectrum), Probe Software, 1987"

  availableToolKeys: -> [
    PAA.Practice.Software.Tools.ToolKeys.Pencil
    PAA.Practice.Software.Tools.ToolKeys.Eraser
    PAA.Practice.Software.Tools.ToolKeys.ColorFill
    PAA.Practice.Software.Tools.ToolKeys.Zoom
  ]

  @initialize()