AE = Artificial.Everywhere
AM = Artificial.Mirage
AB = Artificial.Base
LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PixelArtAcademy.PixelBoy.Apps.Drawing.Portfolio extends AM.Component
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.Drawing.Portfolio'
  
  @Sections:
    Challenges: 'Challenges'
    Projects: 'Projects'
    Artworks: 'Artworks'
    Settings: 'Settings'

  constructor: (@drawing) ->
    super arguments...

    @sectionHeight = 21
    @initialGroupHeight = 17
    @inactiveGroupHeight = 3
    @activeGroupHeight = 150
    @settingsHeight = 118

  sectionActiveClass: ->
    section = @currentData()

    'active' if @activeSection() is section

  groupInSectionActiveClass: ->
    section = @currentData()

    'group-in-section-active' if @activeSection() is section and @activeGroup()

  sectionStyle: ->
    section = @currentData()
    groups = section.groups()
    active = @activeSection() is section
    sections = @sections()

    width = 292 - 4 * (sections.length - section.index)

    style =
      width: "#{width}rem"

    if active
      if @activeGroup()
        height = @sectionHeight + (groups.length - 1) * @inactiveGroupHeight + @activeGroupHeight

      else
        height = @sectionHeight + groups.length * @initialGroupHeight

      style.height = "#{height}rem"

    style

  groupStyle: ->
    group = @currentData()
    section = @parentDataWith 'groups'

    width: "#{270 - 3 * (section.groups().length - group.index - 1)}rem"

  groupActiveClass: ->
    group = @currentData()

    'active' if @activeGroup() is group

  briefStyle: ->
    assetData = @currentData()
    group = @parentDataWith 'assets'

    zIndex = group.assets().length - assetData.index

    zIndex: zIndex

  assetStyle: ->
    assetData = @currentData()
    group = @parentDataWith 'assets'

    zIndex = group.assets().length - assetData.index

    zIndex: zIndex
    width: "#{assetData.asset.width() *  assetData.scale() + 12}rem"

  spriteStyle: ->
    assetData = @currentData()
    scale = assetData.scale()

    style =
      width: "#{assetData.asset.width() * scale}rem"
      height: "#{assetData.asset.height() * scale}rem"

    if backgroundColor = assetData.asset.backgroundColor()
      style.backgroundColor = "##{backgroundColor.getHexString()}"
      style.borderColor = style.backgroundColor

    style

  _assetScale: (asset) ->
    # Scale the sprite as much as possible (up to 7) while remaining under 84px.
    scale = 1
    maxSize = Math.max asset.width(), asset.height()

    if maxSize > 84
      # Scale downwards while interpreting scale as the denominator.
      scale++ while maxSize / scale > 84
      return 1 / scale

    scale++ while scale < 6 and (scale + 1) * maxSize < 84

    scale

  spriteImage: ->
    assetData = @currentData()
    return unless spriteId = assetData.asset.spriteId()

    new LOI.Assets.Components.SpriteImage
      spriteId: => spriteId
      loadPalette: true

  coverStyle: ->
    sections = @sections()

    top = 14 + (sections.length + 1) * @sectionHeight

    if section = @activeSection()
      if groups = section.groups?()
        if @activeGroup()
          top += (groups.length - 1) * @inactiveGroupHeight + @activeGroupHeight

        else
          top += groups.length * @initialGroupHeight

      else
        top += @settingsHeight

    top: "#{top}rem"

  assetHoveredClass: ->
    assetData = @currentData()

    'hovered' if assetData is @hoveredAsset()

  assetActiveClass: ->
    assetData = @currentData()

    'active' if assetData is @activeAsset()

  selectedEditorClass: ->
    editor = @currentData()
    selectedEditorId = @drawing.state('editorId') or null

    'selected' if selectedEditorId is editor.id()

  selectedSoftwareClass: ->
    software = @currentData()
    selectedSoftware = @drawing.state('externalSoftware') or null

    'selected' if selectedSoftware is software.value

  events: ->
    super(arguments...).concat
      'click .section': @onClickSection
      'click .group-name': @onClickGroupName
      'click': @onClick
      'mouseenter .asset': @onMouseEnterAsset
      'mouseleave .asset': @onMouseLeaveAsset
      'click .brief': @onClickBrief
      'click .asset': @onClickAsset
      'click .pixel-boy .editor': @onClickPixelBoyEditor
      'click .external .editor': @onClickExternalEditor

  onClickSection: (event) ->
    section = @currentData()

    clickInsideContent = $(event.target).closest('.content').length > 0

    if section is @activeSection()
      @activeSection null unless clickInsideContent

    else
      @activeSection section

      # Reset group if we click on the name, but not one of the inner groups.
      # In that case the group handler will activate a new group in this new section.
      @activeGroup null unless clickInsideContent

  onClickGroupName: (event) ->
    group = @currentData()
    section = @parentDataWith 'groups'
    
    # Only open the group if we have an active section or if the group is the only one in the section.
    return unless @activeSection() is section or section.groups().length is 1

    if group is @activeGroup()
      @activeGroup null

    else
      @activeGroup group

  onClick: (event) ->
    # If we click outside the clipboard, close current asset.
    if @activeAsset() and not $(event.target).closest('.clipboard').length
      @activeAsset null
      return

    # If we click outside a group, close current group.
    if @activeGroup() and not $(event.target).closest('.group').length
      @activeGroup null

      # Don't let section close as well, if we were clicking inside the current section.
      event.stopPropagation() if @currentData() is @activeSection()
      return

    # If we click outside a section, close current section.
    @activeSection null if @activeSection() and not $(event.target).closest('.section').length

  onMouseEnterAsset: (event) ->
    assetData = @currentData()
    @hoveredAsset assetData

  onMouseLeaveAsset: (event) ->
    @hoveredAsset null

  onClickBrief: (event) ->
    @_goToClickedAsset()

  onClickAsset: (event) ->
    @_goToClickedAsset()

  _goToClickedAsset: ->
    assetData = @currentData()

    # Set active sprite ID.
    AB.Router.setParameter 'parameter3', assetData.asset.spriteId()

  onClickPixelBoyEditor: (event) ->
    editor = @currentData()
    @drawing.state 'editorId', editor.id()

  onClickExternalEditor: (event) ->
    program = @currentData()
    @drawing.state 'externalSoftware', program.value
