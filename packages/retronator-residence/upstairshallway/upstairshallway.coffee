LOI = LandsOfIllusions
HQ = Retronator.HQ

Vocabulary = LOI.Parser.Vocabulary

class HQ.Residence.UpstairsHallway extends LOI.Adventure.Location
  @id: -> 'Retronator.HQ.Residence.UpstairsHallway'
  @url: -> 'retronator/residence/upstairs-hallway'
  @region: -> HQ.Residence

  @version: -> '0.0.1'

  @fullName: -> "upstairs residence hallway"
  @shortName: -> "upstairs hallway"
  @nameAutoCorrectStyle: -> LOI.Avatar.NameAutoCorrectStyle.Name
  @description: ->
    "
      You're upstairs in the residence where the master bedroom is located.
      The hallway also leads to a terrace in the east.
    "
  
  @initialize()

  constructor: ->
    super arguments...

    # Elevator button
    @elevatorButton = new HQ.Items.ElevatorButton
      location: @
      floor: 6

  things: -> [
    @elevatorButton
  ]

  exits: ->
    HQ.Elevator.addElevatorExit
      floor: 6
    ,
      "#{Vocabulary.Keys.Directions.Down}": HQ.Residence.Kitchen
      "#{Vocabulary.Keys.Directions.Southeast}": HQ.Residence.Kitchen
      "#{Vocabulary.Keys.Directions.East}": HQ.Residence.Terrace
