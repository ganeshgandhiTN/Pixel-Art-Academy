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
    C2.Intro
    C2.Registration
    C2.Shopping
    C2.Immersion
  ]

  @timelineId: -> PAA.TimelineIds.RealLife

  @initialize()

  constructor: ->
    super

    @inventory = new @constructor.Inventory parent: @
    @store = new @constructor.Store parent: @

    # Move the player to caltrain on start.
    @autorun (computation) =>
      return unless @active() and not @finished()

      movedToCaltrain = @state 'movedToCaltrain'

      return if movedToCaltrain

      # Force the move so that exit responses are not called.
      LOI.adventure.currentLocationId SanFrancisco.Soma.Caltrain.id()
      LOI.adventure.goToTimeline PAA.TimelineIds.RealLife
      @state 'movedToCaltrain', true

  onRendered: ->
    super

    # Finish intro.
    @autorun (computation) =>
      return unless @active() and not @finished()

      fadeOutDone = @state 'fadeOutDone'
      return if fadeOutDone

      Meteor.setTimeout =>
        @state 'fadeOutDone', true
      ,
        1000

  destroy: ->
    super

  fadeVisibleClass: ->
    'visible' unless @state 'fadeOutDone'

  finished: ->
    # Chapter 2 ends when you finish immersion.
    C2.Immersion.finished()

  scenes: -> [
    @inventory
    @store
  ]