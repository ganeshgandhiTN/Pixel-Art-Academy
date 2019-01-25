AC = Artificial.Control
FM = FataMorgana
LOI = LandsOfIllusions

bresenhamLine = require('bresenham-zingl').line

class LOI.Assets.SpriteEditor.Tools.Pencil extends LOI.Assets.SpriteEditor.Tools.Tool
  # paintNormals: boolean whether only normals are being painted
  # cleanLine: boolean whether to maintain a clean line with consistent width
  # drawPreview: boolean whether to always draw preview of the pixels to be applied
  # fractionalPerfectLines: boolean whether to allow 3:2 and 5:2 lines
  @id: -> 'LandsOfIllusions.Assets.SpriteEditor.Tools.Pencil'
  @displayName: -> "Pencil"

  @initialize()

  constructor: ->
    super arguments...

    @paintHelper = @interface.getHelper LOI.Assets.SpriteEditor.Helpers.Paint

    @drawLine = new ReactiveField false
    @drawStraight = new ReactiveField false
    
    @lastPixelCoordinates = new ReactiveField null
    @currentPixelCoordinates = new ReactiveField null
    @lastStrokeCoordinates = new ReactiveField null
    @lockedCoordinate = new ReactiveField null

    @perfectLineRatio = new ReactiveField null

    # Calculate which pixels the tool would fill.
    @pixels = new ComputedField =>
      return [] unless currentPixelCoordinates = @currentPixelCoordinates()
      lastPixelCoordinates = @lastPixelCoordinates() or currentPixelCoordinates
      lastStrokeCoordinates = @lastStrokeCoordinates() or currentPixelCoordinates

      keyboardState = AC.Keyboard.getState()
      pixels = []

      if @drawLine()
        if keyboardState.isMetaDown()
          # Draw perfect pixel art line.
          pixels = @_perfectLine lastPixelCoordinates, currentPixelCoordinates

        else
          @perfectLineRatio null

          # Draw bresenham line from last coordinates (persist after end of stroke).
          bresenhamLine lastPixelCoordinates.x, lastPixelCoordinates.y, currentPixelCoordinates.x, currentPixelCoordinates.y, (x, y) => pixels.push {x, y}

      else
        # Apply locked coordinate.
        if @drawStraight()
          currentPixelCoordinates = _.extend {}, currentPixelCoordinates, @lockedCoordinate()

        # Draw bresenham line from last stroke coordinates (reset after end of stroke).
        bresenhamLine lastStrokeCoordinates.x, lastStrokeCoordinates.y, currentPixelCoordinates.x, currentPixelCoordinates.y, (x, y) => pixels.push {x, y}

      # Apply paint to all pixels.
      @_applyPaintToPixel pixel for pixel in pixels

      # Make sure there was any paint at all.
      return [] unless pixels[0].paletteColor or pixels[0].materialIndex?

      # TODO: Apply symmetry.
      # symmetryXOrigin = @options.editor().symmetryXOrigin?()
      #if symmetryXOrigin?
      #  mirroredX = -@mouseState.x + 2 * symmetryXOrigin
      #  xCoordinates.push [mirroredX, -1]

      pixels
    ,
      true

    @_previewActive = false

    @autorun (computation) =>
      # Show preview when we're drawing a line and mouse is on the canvas.
      preview = @isActive() and (@data.get('drawPreview') or @drawLine()) and @editor()?.mouse().pixelCoordinate()

      if preview
        # Update preview pixels.
        @editor().operationPreview().pixels @pixels()

      else if @_previewActive
        # Remove pixels, since we were the ones providing them.
        @editor().operationPreview().pixels []

      @_previewActive = preview

  destroy: ->
    @pixels.stop()

  infoText: ->
    return unless @drawLine()
    return unless ratio = @perfectLineRatio()

    "#{ratio[0]}:#{ratio[1]}"

  _perfectLine: (start, end) ->
    dx = end.x - start.x
    dy = end.y - start.y

    width = Math.abs(dx) + 1
    height = Math.abs(dy) + 1

    if width > height
      ratio = width / height

    else
      ratio = height / width
      vertical = true

    if ratio < 3 and @data.get 'fractionalPerfectLines'
      doubleRatio = Math.round ratio * 2
      segmentLengths = [Math.ceil(doubleRatio / 2), Math.floor(doubleRatio / 2)]

      if segmentLengths[0] is segmentLengths[1]
        denominator = 1
        numerator = segmentLengths[0]

      else
        denominator = 2
        numerator = segmentLengths[0] + segmentLengths[1]

    else
      numerator = Math.round ratio
      denominator = 1
      segmentLengths = [numerator]

    if width > 1 and height > 1
      if vertical
        @perfectLineRatio [denominator, numerator]

      else
        @perfectLineRatio [numerator, denominator]

    else
      # Don't write the ratio for straight lines.
      @perfectLineRatio null

    sx = Math.sign dx
    sy = Math.sign dy

    lengthLeft = Math.max width, height
    sideLeft = Math.min width, height

    currentPixel = _.pick start, ['x', 'y']
    pixels = []
    segmentLengthIndex = 0
    segmentLeft = segmentLengths[segmentLengthIndex]

    while lengthLeft and sideLeft
      pixels.push currentPixel

      # Mark progress along segment and length.
      segmentLeft--
      lengthLeft--

      # Move ahead along length.
      currentPixel = _.clone currentPixel

      if vertical
        currentPixel.y += sy

      else
        currentPixel.x += sx

      continue if segmentLeft

      # Step sideways.
      if vertical
        currentPixel.x += sx

      else
        currentPixel.y += sy

      sideLeft--
      segmentLengthIndex = (segmentLengthIndex + 1) % segmentLengths.length
      segmentLeft = segmentLengths[segmentLengthIndex]

    pixels

  onActivated: ->
    @currentPixelCoordinates
      x: @mouseState.x
      y: @mouseState.y

  onKeyDown: (event) ->
    super arguments...

    if event.which is AC.Keys.shift
      if @mouseState.leftButton
        @lockedCoordinate null
        @drawStraight true
        
      else
        @drawLine true

  onKeyUp: (event) ->
    super arguments...

    if event.which is AC.Keys.shift
      @drawStraight false
      @drawLine false

  onMouseDown: (event) ->
    super arguments...

    @applyPencil()

  onMouseMove: (event) ->
    super arguments...

    currentPixelCoordinates = @currentPixelCoordinates()

    newPixelCoordinates =
      x: @mouseState.x
      y: @mouseState.y

    return if EJSON.equals currentPixelCoordinates, newPixelCoordinates

    @currentPixelCoordinates newPixelCoordinates

    @applyPencil()

  onMouseUp: (event) ->
    super arguments...

    # End stroke.
    @lastStrokeCoordinates null

    @drawStraight false

  applyPencil: ->
    return unless @mouseState.leftButton

    spriteData = @editor().spriteData()

    layerIndex = @paintHelper.layerIndex()
    layer = spriteData.layers?[layerIndex]

    layerOrigin =
      x: layer?.origin?.x or 0
      y: layer?.origin?.y or 0

    pixels = @pixels()
    drawStraight = @drawStraight()

    if drawStraight
      lastPixelCoordinates = @lastPixelCoordinates()
      lastNewPixel = _.last pixels

      unless lockedCoordinate = @lockedCoordinate()
        # Calculate which direction to lock to.
        if lastNewPixel.x is lastPixelCoordinates.x
          # Lock to vertical straight lines.
          lockedCoordinate = x: lastPixelCoordinates.x

        else
          lockedCoordinate = y: lastPixelCoordinates.y

        @lockedCoordinate lockedCoordinate

    for absolutePixel in @pixels()
      absoluteCoordinates = _.pick absolutePixel, ['x', 'y']
      @lastPixelCoordinates absoluteCoordinates
      @lastStrokeCoordinates absoluteCoordinates

      pixel = _.clone absolutePixel
      _.extend pixel, lockedCoordinate if drawStraight

      # Pixel must be in relative coordinates.
      pixel.x -= layerOrigin.x
      pixel.y -= layerOrigin.y
        
      # If we have fixed bounds, make sure we're inside.
      if spriteData.bounds?.fixed
        continue unless spriteData.bounds.left <= pixel.x <= spriteData.bounds.right and spriteData.bounds.top <= pixel.y <= spriteData.bounds.bottom

      # See if we're painting a normal.
      paintNormals = @data.get 'paintNormals'

      existingPixel = _.find spriteData.layers?[layerIndex]?.pixels, (searchPixel) -> pixel.x is searchPixel.x and pixel.y is searchPixel.y
  
      if paintNormals and existingPixel
        # Get the color from the existing pixel.
        for property in ['materialIndex', 'paletteColor']
          pixel[property] = existingPixel[property] if existingPixel[property]?
  
      # Do we even need to add this pixel? See if one just like it is already there.
      exactMatch = LOI.Assets.Sprite.documents.findOne
        _id: spriteData._id
        "layers.#{layerIndex}.pixels": pixel

      continue if exactMatch
      
      @_callMethod spriteData._id, layerIndex, pixel

  _applyPaintToPixel: (pixel) ->
    if normal = @paintHelper.normal().clone()
      pixel.normal = normal

    # See if we're setting a palette color.
    if paletteColor = @paintHelper.paletteColor()
      pixel.paletteColor = paletteColor

    # See if we're setting a named color.
    materialIndex = @paintHelper.materialIndex()
    if materialIndex?
      pixel.materialIndex = materialIndex

  # Override to call another method.
  _callMethod: (spriteId, layer, pixel) ->
    LOI.Assets.Sprite.addPixel spriteId, layer, pixel
