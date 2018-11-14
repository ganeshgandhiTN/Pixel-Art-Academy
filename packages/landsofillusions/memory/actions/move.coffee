LOI = LandsOfIllusions
AM = Artificial.Mummification

class LOI.Memory.Actions.Move extends LOI.Memory.Action
  # content:
  #   landmark: the named point that can be looked up to get its coordinates
  #   coordinates: direct location coordinates, if landmark is not specified
  #     x, y, z
  @type: 'LandsOfIllusions.Memory.Actions.Move'
  @register @type, @

  @registerContentPattern @type, Match.OptionalOrNull
    landmark: Match.Optional String
    coordinates: Match.Optional
      x: Number
      y: Number
      z: Number

  @retainDuration: -> 60 # seconds

  @startDescription: ->
    "_person_ enters."

  createStartScript: (person, nextNode, nodeOptions = {}) ->
    callbackNode = new Nodes.Callback
      next: nextNode
      callback: (complete) =>
        complete()

        personObject = person.avatar.getRenderObject()

        if content.coordinates
          personObject.position.copy content.coordinates

    # Return the starting callback node.
    callbackNode

