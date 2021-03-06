AC = Artificial.Control
AE = Artificial.Everywhere
AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PAA.PixelBoy.Apps.Drawing extends PAA.PixelBoy.App
  # editorId: which editor component to use for editing sprites in the app
  # externalSoftware: which external software the player is using to edit sprites
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.Drawing'
  @url: -> 'drawing'

  @version: -> '0.1.0'

  @register @id()
  template: -> @constructor.id()

  @fullName: -> "Drawing"
  @description: ->
    "
      It's the app for drawing pixel art.
    "
    
  @initialize()

  constructor: ->
    super arguments...

    @portfolio = new ReactiveField null
    @clipboard = new ReactiveField null
    @editor = new ReactiveField null

  onCreated: ->
    super arguments...

    # Initialize components.
    @portfolio new @constructor.Portfolio @
    @clipboard new @constructor.Clipboard @
    @editor new @constructor.Editor.Desktop @

    @autorun (computation) =>
      portfolio = @portfolio()
      editor = @editor()

      if portfolio.isCreated() and portfolio.activeAsset()
        if editor.active()
          @setMaximumPixelBoySize fullscreen: true

        else
          @setFixedPixelBoySize 200, 260

      else
        @setFixedPixelBoySize 332, 241

  onDestroyed: ->
    @editor().destroy()

  onBackButton: ->
    # Relay to editor.
    editor = @editor()
    editorResult = editor.onBackButton?()
    return editorResult if editorResult?

    # Close second page of the clipboard
    clipboard = @clipboard()

    if clipboard.secondPageActive()
      clipboard.closeSecondPage()

      # Inform that we've handled the back button.
      return true

    portfolio = @portfolio()

    # We only need to handle closing groups when not on an asset.
    return unless portfolio.activeGroup() and not portfolio.activeAsset()

    # Close the group.
    portfolio.activeGroup null

    # Inform that we've handled the back button.
    true

  activeAssetClass: ->
    portfolio = @portfolio()

    'active-asset' if portfolio.isCreated() and portfolio.activeAsset()

  editorActiveClass: ->
    'editor-active' if @editor().active()

  editorFocusedModeClass: ->
    'editor-focused-mode' if @editor().focusedMode?()

  editorClass: ->
    @editor()?.constructor.styleClass()
