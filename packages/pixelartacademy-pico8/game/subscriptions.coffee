AE = Artificial.Everywhere
LOI = LandsOfIllusions
PAA = PixelArtAcademy

# Get journals for a certain character.
PAA.Pico8.Game.all.publish ->
  PAA.Pico8.Game.documents.find()

PAA.Pico8.Game.forSlug.publish (slug) ->
  check slug, String

  PAA.Pico8.Game.documents.find {slug}
