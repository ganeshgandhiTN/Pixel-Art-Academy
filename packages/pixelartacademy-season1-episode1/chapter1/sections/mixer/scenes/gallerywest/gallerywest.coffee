LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PAA.Season1.Episode1.Chapter1
HQ = Retronator.HQ

Vocabulary = LOI.Parser.Vocabulary

class C1.Mixer.GalleryWest extends LOI.Adventure.Scene
  @id: -> 'PixelArtAcademy.Season1.Episode1.Chapter1.Mixer.GalleryWest'

  @location: ->
    HQ.GalleryWest

  @intro: -> """
    You enter a big gallery space that is holding a gathering.
    You recognize some people from the HQ, others seem to be visitors like yourself.
  """

  @defaultScriptUrl: -> 'retronator_pixelartacademy-season1-episode1/chapter1/sections/mixer/scenes/gallerywest/gallerywest.script'

  # Note: Initialized is called in the extended class.

  @actorClasses = [
    PAA.Actors.Ace
    PAA.Actors.Ty
    PAA.Actors.Saanvi
    PAA.Actors.Mae
    PAA.Actors.Lisa
    PAA.Actors.Jaxx
  ]

  things: -> _.flatten [
    HQ.Actors.Shelley
    @constructor.Retro
    HQ.Actors.Alexandra
    HQ.Actors.Reuben
    @constructor.actorClasses
    C1.Mixer.Table
    C1.Mixer.Marker
    C1.Mixer.Stickers
  ]

  _animateActorsOnQuestion: (question) ->
    for actorClass in @constructor.actorClasses
      actor = LOI.adventure.getCurrentThing actorClass

      # Find which answer the actor chose.
      action = actor.getActions(
        type: C1.Mixer.IceBreakers.AnswerAction.type
        question: question
      )[0]

      # Go to the landmark that corresponds to the answer.
      @_movePersonToAnswerLandmark actor, action.answer

  _movePersonToAnswerLandmark: (person, answer) ->
    answerLandmarks = [
      'MixerLeft'
      'MixerMiddle'
      'MixerRight'
    ]

    @_movePersonToLandmark person, answerLandmarks[answer]

  _movePersonToLandmark: (person, landmark) ->
    renderObject = person.avatar.getRenderObject()
    renderObject.setAnimation 'Walk'

    LOI.adventure.world.navigator().moveAvatar
      avatar: person.avatar
      target: landmark
      speed: 1.25
      onCompleted: =>
        renderObject.setAnimation 'Idle'
        renderObject.facePosition 'InFrontOfProjector'

  _doAnswerAction: (question, answer) ->
    type = C1.Mixer.IceBreakers.AnswerAction.type
    situation = LOI.adventure.currentSituationParameters()
    character = LOI.character()
    LOI.Memory.Action.do type, character._id, situation, {question, answer}

    # Move the character to the landmark.
    @_movePersonToAnswerLandmark character, answer

  # Script

  initializeScript: ->
    scene = @options.parent

    @setCurrentThings
      retro: HQ.Actors.Retro
      alexandra: HQ.Actors.Alexandra
      shelley: HQ.Actors.Shelley
      reuben: HQ.Actors.Reuben

    # TODO: Animate characters in callbacks.
    @setCallbacks
      IceBreakersStart: (complete) =>
        # Animate characters to the middle.
        characters = _.flatten [
          LOI.character()
          LOI.adventure.getCurrentThing actorClass for actorClass in scene.constructor.actorClasses
        ]

        for character in characters
          scene._movePersonToLandmark character, 'MixerMiddle'

        complete()

      HobbyProfessionStart: (complete) =>
        scene._animateActorsOnQuestion C1.Mixer.IceBreakers.Questions.HobbyProfession
        complete()

      HobbyProfessionEnd: (complete) =>
        answers = @state 'answers'
        console.log "Animating character to location", answers[0]
        console.log "Animating any remaining characters based on hobby/profession."
        scene._doAnswerAction C1.Mixer.IceBreakers.Questions.HobbyProfession, answers[0]
        complete()

      PixelArtOtherStylesStart: (complete) =>
        scene._animateActorsOnQuestion C1.Mixer.IceBreakers.Questions.PixelArtOtherStyles
        complete()

      PixelArtOtherStylesEnd: (complete) =>
        answers = @state 'answers'
        scene._doAnswerAction C1.Mixer.IceBreakers.Questions.PixelArtOtherStyles, answers[1]
        complete()

      ExtrovertIntrovertStart: (complete) =>
        scene._animateActorsOnQuestion C1.Mixer.IceBreakers.Questions.ExtrovertIntrovert
        complete()

      ExtrovertIntrovertEnd: (complete) =>
        answers = @state 'answers'

        personalityChanged = scene._changePersonality 1, 1 - answers[2]
        @ephemeralState 'factor1Changed', personalityChanged

        scene._doAnswerAction C1.Mixer.IceBreakers.Questions.ExtrovertIntrovert, answers[2]
        complete()

      IndividualTeamStart: (complete) =>
        scene._animateActorsOnQuestion C1.Mixer.IceBreakers.Questions.IndividualTeam
        complete()

      IndividualTeamEnd: (complete) =>
        answers = @state 'answers'

        personalityChanged = scene._changePersonality 2, answers[3] - 1
        @ephemeralState 'factor2Changed', personalityChanged

        scene._doAnswerAction C1.Mixer.IceBreakers.Questions.IndividualTeam, answers[3]
        complete()

  # Listener

  onEnter: (enterResponse) ->
    scene = @options.parent

    @_positionActorsAutorun = @autorun (computation) =>
      # Wait until the location mesh has loaded, so that we have landmark positions.
      return unless LOI.adventure.world.sceneManager().currentLocationMeshData()
      computation.stop()

      startingPositions =
        "#{HQ.Actors.Shelley.id()}": 'InFrontOfProjector'
        "#{HQ.Actors.Reuben.id()}": 'MixerSideReuben'
        "#{HQ.Actors.Alexandra.id()}": 'MixerSideAlexandra'
        "#{HQ.Actors.Retro.id()}": 'MixerTable'

      for actorClass in scene.constructor.actorClasses
        startingPositions[actorClass.id()] = 'GalleryFloor'

      LOI.adventure.director.setPosition startingPositions

      LOI.adventure.director.facePosition
        "#{HQ.Actors.Reuben.id()}": 'MixerMiddle'
        "#{HQ.Actors.Alexandra.id()}": 'MixerMiddle'

      # Make actors face random directions.
      for actorClass in scene.constructor.actorClasses
        actor = LOI.adventure.getCurrentThing actorClass

        direction = new THREE.Vector3 Math.random() * 2 - 1, 0, Math.random() * 2 - 1
        direction.normalize()
        actor.avatar.getRenderObject().faceDirection direction

    # Retro should talk when at location.
    @_retroTalksAutorun = @autorun (computation) =>
      return unless @scriptsReady()
      return unless retro = LOI.adventure.getCurrentThing HQ.Actors.Retro
      return unless retro.ready()
      computation.stop()

      @script.setThings {retro}

      @startScript label: 'RetroIntro'

    # Player should be in the mixer context when they have a name tag.
    @_enterContextAutorun = @autorun (computation) =>
      return if LOI.adventure.currentContext() instanceof C1.Mixer.Context
      return unless LOI.adventure.getCurrentInventoryThing C1.Mixer.NameTag
      return unless shelley = LOI.adventure.getCurrentThing HQ.Actors.Shelley
      return unless shelley.ready()

      LOI.adventure.enterContext C1.Mixer.Context

      unless @script.state 'IceBreakersDone'
        # Start the mixer script at the latest checkpoint.
        checkpoints = [
          'MixerStart'
          'IceBreakersStart'
          'HobbyProfessionWriteStart'
          'PixelArtOtherStylesStart'
          'ExtrovertIntrovertStart'
          'IndividualTeamStart'
        ]

        for checkpoint, index in checkpoints
          # Start at this checkpoint if we haven't reached the next one yet.
          nextCheckpoint = checkpoints[index + 1]

          unless nextCheckpoint and @script.state nextCheckpoint
            @startScript label: checkpoint
            return

  cleanup: ->
    @_positionActorsAutorun?.stop()
    @_retroTalksAutorun?.stop()
    @_enterContextAutorun?.stop()

  onCommand: (commandResponse) ->
    return unless alexandra = LOI.adventure.getCurrentThing HQ.Actors.Alexandra
    return unless retro = LOI.adventure.getCurrentThing HQ.Actors.Retro
    return unless shelley = LOI.adventure.getCurrentThing HQ.Actors.Shelley
    return unless reuben = LOI.adventure.getCurrentThing HQ.Actors.Reuben

    return unless marker = LOI.adventure.getCurrentThing C1.Mixer.Marker
    return unless stickers = LOI.adventure.getCurrentThing C1.Mixer.Stickers

    commandResponse.onPhrase
      form: [Vocabulary.Keys.Verbs.TalkTo, alexandra]
      action: => @startScript label: 'TalkToAlexandra'

    commandResponse.onPhrase
      form: [Vocabulary.Keys.Verbs.TalkTo, retro]
      action: => @startScript label: 'TalkToRetro'

    commandResponse.onPhrase
      form: [Vocabulary.Keys.Verbs.TalkTo, shelley]
      action: => @startScript label: 'TalkToShelley'

    commandResponse.onPhrase
      form: [Vocabulary.Keys.Verbs.TalkTo, reuben]
      action: => @startScript label: 'TalkToReuben'

    commandResponse.onPhrase
      form: [Vocabulary.Keys.Verbs.Get, marker]
      action: =>
        marker.state 'inInventory', true
        true

    commandResponse.onPhrase
      form: [Vocabulary.Keys.Verbs.Get, stickers]
      action: =>
        stickers.state 'inInventory', true
        true
