LOI = LandsOfIllusions
PAA = PixelArtAcademy
HQ = Retronator.HQ

class PAA.Season1.Episode0.Chapter2 extends LOI.Adventure.Chapter
  C2 = @

  @id: -> 'PixelArtAcademy.Season1.Episode0.Chapter2'
  template: -> @constructor.id()

  @fullName: -> "Retronator HQ"
  @number: -> 2

  @url: -> 'chapter2'

  @sections: -> [
    C2.Registration
    C2.Shopping
    C2.Immersion
  ]

  @initialize()

  constructor: ->
    super

    # Move the player to caltrain on start.
    @autorun (computation) =>
      return unless LOI.adventure.gameState()

      movedToCaltrain = @state 'movedToCaltrain'
      return if movedToCaltrain

      LOI.adventure.goToLocation SanFrancisco.Soma.Caltrain
      @state 'movedToCaltrain', true

    # Finish intro.
    @autorun (computation) =>
      return unless LOI.adventure.gameState()

      introDone = @state 'introDone'
      return if introDone

    # Listen for the goal condition.
    @autorun (computation) =>
      # Chapter 2 ends when you enter the construct.
      if LOI.Construct.Loading.state 'visited'
        computation.stop()

        PixelArtAcademy.Season1.Episode0.state 'currentChapter', PAA.Season1.Episode0.Chapter3.id()

  onRendered: ->
    unless @state 'introDone'
      # Run the intro script.
      @showChapterTitle
        onActivated: =>
          @state 'introDone', true

  fadeVisibleClass: ->
    'visible' unless @state 'introDone'

  inventory: ->
    items = []

    for itemClassName in ['ShoppingCart', 'Account', 'Prospectus', 'Receipt']
      hasItem = HQ.Items[itemClassName].state 'inInventory'
      items.push HQ.Items[itemClassName] if hasItem

    items
