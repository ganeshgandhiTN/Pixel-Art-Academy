AE = Artificial.Everywhere
LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PixelArtAcademy.Season1.Episode1.Chapter1

class C1.Challenges.Drawing.PixelArtSoftware.CopyReference extends PAA.Practice.Challenges.Drawing.TutorialSprite
  @displayName: -> "Copy the reference"

  @description: -> """
      Use the editor or software of your choice to recreate the provided reference.
    """

  @bitmap: -> "" # Empty sprite

  @goalImageUrl: -> "/pixelartacademy/season1/episode1/chapter1/challenges/drawing/pixelartsoftware/#{@imageName()}.png"

  @imageName: -> throw new AE.NotImplementedException "You must provide the image name for the asset."

  @references: -> [
    image:
      url: "/pixelartacademy/season1/episode1/chapter1/challenges/drawing/pixelartsoftware/#{@imageName()}-reference.png"
    displayOptions:
      imageOnly: true
  ]

  @customPaletteImageUrl: ->
    return null if @restrictedPaletteName()

    "/pixelartacademy/season1/episode1/chapter1/challenges/drawing/pixelartsoftware/#{@imageName()}-template.png"

  @briefComponentClass: ->
    # Note: We need to fully qualify the name instead of using @constructor
    # since we're overriding with a class with the same name.
    C1.Challenges.Drawing.PixelArtSoftware.CopyReference.BriefComponent

  @initialize()
  
  constructor: ->
    super

    # We override the component that shows the goal state with a custom one that only shows drawn errors.
    @engineComponent = new @constructor.ErrorEngineComponent
      userSpriteData: =>
        return unless spriteId = @spriteId()
        LOI.Assets.Sprite.documents.findOne spriteId

      spriteData: =>
        return unless goalPixels = @goalPixels()
        return unless spriteId = @spriteId()

        # Take same overall sprite data (bounds, palette) as sprite used for drawing, but exclude the pixels.
        spriteData = LOI.Assets.Sprite.documents.findOne spriteId,
          fields:
            'layers': false

        return unless spriteData

        # Replace pixels with the goal state.
        spriteData.layers = [pixels: goalPixels]

        spriteData

  editorOptions: ->
    references:
      upload:
        enabled: false
      storage:
        enabled: false
