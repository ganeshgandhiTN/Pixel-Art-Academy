AE = Artificial.Everywhere
PAA = PixelArtAcademy

class PAA.PixelDailies.ThemeCalendarProvider extends PAA.Apps.Calendar.Provider
  constructor: ->
    super

  subscriptionName: ->
    'pixelDailiesThemes'

  # Returns all events for a specific day.
  getEvents: (dayDate) ->
    # Return all themes that were posted on that date.
    query =
      hashtag:
        $exists: true

    dateRange = new AE.DateRange
      year: dayDate.getFullYear()
      month: dayDate.getMonth()
      day: dayDate.getDate()

    query = dateRange.addToMongoQuery query, 'date'

    themes = PAA.PixelDailies.Theme.documents.find query,
      fields:
        tweetData: 0

    # Convert themes to text
    theme.hashtag for theme in themes.fetch()
