AE = Artificial.Everywhere
AM = Artificial.Mummification
LOI = LandsOfIllusions
RA = Retronator.Accounts

class LOI.Assets.VisualAsset extends LOI.Assets.Asset
  @id: -> 'LandsOfIllusions.Assets.VisualAsset'
  # palette: the color palette that this sprite uses (or null if only direct colors are used)
  #   _id
  #   name
  # customPalette: optional embedded palette object with the same structure as a palette document
  # materials: map of named colors
  #   (materialIndex):
  #     name: what the color represents
  #     ramp: index of the ramp within the palette
  #     shade: index of the shade in the ramp
  #     dither: amount of dither used from 0 to 1
  # landmarks: array of named locations
  #   name: name of the landmark
  #   x, y, z: floating point location of the landmark
  # authors: array of characters that are allowed to edit this asset or null if this is a system asset
  #   _id
  #   avatar
  #     fullName
  # references: array of images used as references
  #   image: image document
  #     _id
  #     url
  #   displayed: boolean if the reference is currently displayed
  #   position: data for where to display the reference
  #     x, y: floating point position values
  #   scale: data for how big to display the reference
  #   order: integer value for sorting references
  @Meta
    abstract: true
    fields: =>
      palette: @ReferenceField LOI.Assets.Palette, ['name'], false
      authors: [@ReferenceField LOI.Character, ['avatar.fullName']]
      references: [
        image: @ReferenceField LOI.Assets.Image, ['url']
      ]

  # Methods

  @updatePalette: @method 'updatePalette'
  @updateMaterial: @method 'updateMaterial'
  @updateLandmark: @method 'updateLandmark'

  @addReferenceByUrl: @method 'addReferenceByUrl'
  @updateReferenceScale: @method 'updateReferenceScale'
  @updateReferencePosition: @method 'updateReferencePosition'
  @updateReferenceDisplayed: @method 'updateReferenceDisplayed'
  @reorderReferenceToTop: @method 'reorderReferenceToTop'
  
  # Helper methods

  constructor: ->
    super

    # Add computed properties to bounds.
    if @bounds
      @bounds.x = @bounds.left
      @bounds.y = @bounds.top
      @bounds.width = @bounds.right - @bounds.left + 1
      @bounds.height = @bounds.bottom - @bounds.top + 1

  getLandmarkForName: (name) ->
    _.find @landmarks, (landmark) -> landmark.name is name
