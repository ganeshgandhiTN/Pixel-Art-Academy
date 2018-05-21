AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PAA.PixelBoy.App extends LOI.Adventure.Item
  @_appClassesByUrl = {}

  @getClassForUrl: (url) ->
    @_appClassesByUrl[url]

  @initialize: ->
    super

    url = @url()
    @_appClassesByUrl[url] = @ if url?
        
  iconUrl: ->
    @versionedUrl "/pixelartacademy/pixelboy/apps/#{@url()}/icon.png"

  constructor: (@os) ->
    super

    # Does this app lets the device resize?
    @resizable = new ReactiveField true

    # The minimum size the device should be let to resize.
    @minWidth = new ReactiveField null
    @minHeight = new ReactiveField null

    # The maximum size the device should be let to resize.
    @maxWidth = new ReactiveField null
    @maxHeight = new ReactiveField null

  onRendered: ->
    super
    
    $appWrapper = $('.app-wrapper')
    $appWrapper.velocity 'transition.slideUpIn', complete: ->
      $appWrapper.css('transform', '')

  setDefaultPixelBoySize: ->
    @setMaximumPixelBoySize()

    @minWidth 310
    @minHeight 230

    @resizable true
    
  setFixedPixelBoySize: (width, height) ->
    @minWidth width
    @minHeight height

    @maxWidth width
    @maxHeight height

    @resizable false

  setMaximumPixelBoySize: (options = {}) ->
    display = LOI.adventure.interface.display

    viewport = display.viewport()
    scale = display.scale()

    maxOverlayHeight = display.safeAreaHeight() * 1.5

    width = viewport.viewportBounds.width() / scale
    height = Math.min maxOverlayHeight, viewport.viewportBounds.height() / scale

    unless options.fullscreen
      # Add gaps for the back button and top border
      width -= 100
      height -= 20

    @setFixedPixelBoySize width, height
