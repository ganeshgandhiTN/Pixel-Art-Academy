LOI = LandsOfIllusions

class LOI.Character.Avatar.Renderers.Shape extends LOI.Character.Avatar.Renderers.Renderer
  @liveEditing = false

  constructor: (@options, initialize) ->
    super arguments...

    # Prepare renderer only when it has been asked to initialize.
    return unless initialize

    # Shape renderer prepares all sprite directions and draws the one needed by the engine.
    @spriteData = {}
    @sprite = {}

    for side of LOI.Engine.RenderingSides.angles
      do (side) =>
        # Sprites in flipped renderers need to come from the other side.
        sourceSide = if @options.flippedHorizontal then LOI.Engine.RenderingSides.mirrorSides[side] else side

        @spriteData[side] = new ComputedField =>
          spriteId = @options["#{sourceSide}SpriteId"]()

          # If we didn't find a sprite for this side, we assume we should mirror the other side.
          unless spriteId
            mirrorSide = LOI.Engine.RenderingSides.mirrorSides[sourceSide]
            spriteId = @options["#{mirrorSide}SpriteId"]()

          return unless spriteId

          if @constructor.liveEditing
            LOI.Assets.Asset.forId.subscribe 'Sprite', spriteId
            LOI.Assets.Sprite.documents.findOne spriteId

          else
            LOI.Assets.Sprite.getFromCache spriteId

        @sprite[side] = new LOI.Assets.Engine.Sprite
          side: sourceSide
          spriteData: @spriteData[side]
          materialsData: @options.materialsData
          flippedHorizontal: new ComputedField =>
            if @options["#{sourceSide}SpriteId"]()
              @options.flippedHorizontal

            else
              not @options.flippedHorizontal

    # By default we read the viewing angle from options, but we also support sending it late from the draw call.
    defaultViewingAngle = =>
      @options.viewingAngle?() or 0

    @viewingAngleGetter = new ReactiveField defaultViewingAngle, (a, b) => a is b

    @activeSide = new ComputedField => LOI.Engine.RenderingSides.getSideForAngle @viewingAngleGetter()()

    @activeSprite = new ComputedField =>
      @sprite[@activeSide()]

    @activeSpriteFlipped = new ComputedField =>
      sprite = @activeSprite()
      not @options["#{sprite.options.side}SpriteId"]()

    @translation = new ComputedField =>
      sprite = @activeSprite()
      spriteData = sprite.options.spriteData()

      source = x: 0, y: 0
      target = x: 0, y: 0

      if origin = @options.origin
        source = (spriteData?.getLandmarkForName origin.landmark, @activeSpriteFlipped()) or source

        target.x = origin.x or 0
        target.y = origin.y or 0

      x: target.x - source.x
      y: target.y - source.y

    @_ready = new ComputedField =>
      # If we have no data, in this part, there's nothing to do.
      return true unless @options.part.options.dataLocation()
      
      # Shape is ready when the sprite is ready.
      @activeSprite().ready()

  ready: ->
    @_ready()
    
  landmarks: ->
    # Provide active sprite's landmarks, but translate them to the origin.
    return unless spriteData = @activeSprite().options.spriteData()

    # If there are no landmarks, there's nothing to do.
    return unless spriteData.landmarks

    translation = @translation()
    activeSpriteFlipped = @activeSpriteFlipped()

    landmarks = {}

    for landmark in spriteData.landmarks
      # Get potentially flipped landmark data.
      landmark = spriteData.getLandmarkForName landmark.name, activeSpriteFlipped
      
      landmarks[landmark.name] = _.extend {}, landmark,
        x: landmark.x + translation.x
        y: landmark.y + translation.y

    landmarks

  drawToContext: (context, options = {}) ->
    # Update viewing angle.
    @viewingAngleGetter options.viewingAngle if options.viewingAngle

    sprite = @activeSprite()

    context.save()

    translation = @translation()
    context.translate translation.x, translation.y

    if @activeSpriteFlipped()
      context.translate 1, 0
      context.scale -1, 1

    sprite.drawToContext context, options
    context.restore()
