LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PixelArtAcademy.Season1.Episode1.Chapter1
HQ = Retronator.HQ
SF = SanFrancisco

Vocabulary = LOI.Parser.Vocabulary

class C1.PersonConversation extends LOI.Adventure.Scene
  @id: -> 'PixelArtAcademy.Season1.Episode1.Chapter1.PersonConversation'

  @location: ->
    # Applies to all locations.
    null

  @initialize()

  @defaultScriptUrl: -> 'retronator_pixelartacademy-season1-episode1/chapter1/scenes/personconversation.script'
    
  # Script

  initializeScript: ->
    @setCallbacks
      HangOut: (complete) =>
        # Add person we're talking to as a member to the SF friends group.
        memberId = @ephemeralState 'personId'
        
        LOI.Character.Group.addMember LOI.characterId(), C1.Groups.SanFranciscoFriends.id(), memberId

        complete()

  # Listener

  onCommand: (commandResponse) ->
    people = _.filter LOI.adventure.currentLocationThings(), (thing) => thing instanceof LOI.Character.Person
    characterId = LOI.characterId()

    for person in people when person._id isnt characterId
      do (person) =>
        commandResponse.onPhrase
          form: [Vocabulary.Keys.Verbs.TalkTo, person.avatar]
          action: =>
            # Replace the person with target character.
            @script.setThings {person}

            @script.ephemeralState 'personId', person._id
            @script.ephemeralState 'personInGroup', C1.Groups.SanFranciscoFriends.isCharacterMember person._id

            @startScript()
