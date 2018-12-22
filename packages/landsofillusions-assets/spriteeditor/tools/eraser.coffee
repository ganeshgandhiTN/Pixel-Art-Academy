AC = Artificial.Control
FM = FataMorgana
LOI = LandsOfIllusions

class LOI.Assets.SpriteEditor.Tools.Eraser extends LOI.Assets.SpriteEditor.Tools.Tool
  @id: -> 'LandsOfIllusions.Assets.SpriteEditor.Tools.Eraser'

  constructor: ->
    super arguments...

    @name = "Eraser"
    @shortcut = key: AC.Keys.e
    @icon = '/landsofillusions/assets/editor/icons/eraser.png'

  onMouseDown: (event) ->
    super arguments...

    @applyEraser()

  onMouseMove: (event) ->
    super arguments...

    @applyEraser()

  applyEraser: ->
    return unless @mouseState.leftButton

    # Do we even need to remove this pixel? See if it is even there.
    spriteData = @options.editor().spriteData()

    xCoordinates = [@mouseState.x]

    symmetryXOrigin = @options.editor().symmetryXOrigin?()

    if symmetryXOrigin?
      mirroredX = -@mouseState.x + 2 * symmetryXOrigin
      xCoordinates.push mirroredX

    for xCoordinate in xCoordinates
      pixel =
        x: xCoordinate
        y: @mouseState.y

      existing = LOI.Assets.Sprite.documents.findOne
        _id: spriteData._id
        "layers.#{0}.pixels":
          $elemMatch: pixel

      return unless existing

      LOI.Assets.Sprite.removePixel spriteData._id, 0, pixel
