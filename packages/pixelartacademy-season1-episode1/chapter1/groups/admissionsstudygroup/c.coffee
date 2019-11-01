LOI = LandsOfIllusions
PAA = PixelArtAcademy
C1 = PAA.Season1.Episode1.Chapter1
HQ = Retronator.HQ

class C1.Groups.AdmissionsStudyGroup.C extends C1.Groups.AdmissionsStudyGroup
  @id: -> 'PixelArtAcademy.Season1.Episode1.Chapter1.Groups.AdmissionsStudyGroup.C'
  @location: -> HQ.Coworking

  # Note: We use the coworking class of Reuben so that removing him from other scenes works.
  @coordinator: -> HQ.Coworking.Reuben
  @npcMembers: -> [
    PAA.Actors.Mae
    PAA.Actors.Jaxx
  ]

  @initialize()