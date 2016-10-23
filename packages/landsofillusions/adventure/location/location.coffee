AB = Artificial.Babel
AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Adventure.Location extends AM.Component
  template: -> 'LandsOfIllusions.Adventure.Location'

  # Static location properties and methods

  # Id string for this location used to identify the location in code.
  @id: -> throw new Meteor.Error 'unimplemented', "You must specify location's id."

  # The URL at which the location is accessed.
  @url: -> throw new Meteor.Error 'unimplemented', "You must specify location's url."

  # The semantic version at which the location's script is at. You
  # can use the -wip suffix to force constant reloads and re-compiles.
  @wipSuffix = 'wip'
  @version: ->
    "0.0.1-#{@wipSuffix}"

  @versionUrl: (url) ->
    version = @version()

    # If we're in WIP mode, add a random url version.
    version = Random.id() if _.endsWith @version(), @wipSuffix

    # Return the url with version added.
    "#{url}?#{version}"

  # Generates the parameters object that can be passed to the router to get to this location URL.
  @urlParameters: ->
    # Split URL into object with parameter properties.
    urlParameters = @url().split('/')

    parametersObject = {}

    for urlParameter, i in urlParameters
      parametersObject["parameter#{i + 1}"] = urlParameter

    parametersObject

  @translationKeys:
    fullName: 'fullName'
    shortName: 'shortName'
    description: 'description'

  # The long name is displayed to succinctly describe the location. Btw, we can't just use 'name'
  # instead of 'shortName' because name gets overriden by CoffeeScript with the class name.
  @fullName: -> throw new Meteor.Error 'unimplemented', "You must specify location's full name."
  fullName: -> @_getTranslation @constructor.translationKeys.fullName

  # The short name of the location which appears in possible exits. Default (null)
  # means a hidden location that can only be accessed by its url. 
  @shortName: -> null
  shortName: -> @_getTranslation @constructor.translationKeys.shortName

  # The description text displayed when you enter the location for the first time or specifically look around. Default
  # (null) means no description.
  @description: -> null
  description: -> @_getTranslation @constructor.translationKeys.description

  # The maximum height of location's illustration. By default there is no illustration (height 0).
  @illustrationHeight: -> 0
  illustrationHeight: -> @constructor.illustrationHeight()

  # A map of all location constructors separated into nested objects by their url path.
  @_locationClassesByUrlPath = {}
  @getClassForPath: (path) ->
    _.nestedProperty @_locationClassesByUrlPath, "#{path}._class"

  @_locationClassesByID = {}
  @getClassForID: (id) ->
    @_locationClassesByID[id]

  @initialize: ->
    # Store location class into locations broken down by its url.
    path = @url().replace(/\//g, '.')
    _.nestedProperty @_locationClassesByUrlPath, "#{path}._class", @

    # Do the same for the ID map.
    @_locationClassesByID[@id()] = @

    # On the server, create translations.
    if Meteor.isServer
      for translationKey of @translationKeys
        defaultText = @[translationKey]()
        @_createTranslation translationKey, defaultText if defaultText

    # On the server, compile the scripts.
    if Meteor.isServer and @scriptUrls
      for scriptUrl in @scriptUrls()
        [packageId, pathParts...] = scriptUrl.split '/'
        path = pathParts.join '/'
        text = LOI.packages[packageId].assets.getText path

        new LOI.Adventure.ScriptFile
          locationId: @id()
          text: text

  @_createTranslation: (key, defaultText) ->
    namespace = @id()
    AB.createTranslation namespace, key, defaultText

  _getTranslation: (key) ->
    translation = Artificial.Babel.translation @_translationSubscribtion, key
    return unless translation

    translation.translate Artificial.Babel.userLanguagePreference()

  # Location instance.

  constructor: ->
    super

    @exits = new ReactiveField {}

    @director = new LOI.Adventure.Director @
    @actors = new ReactiveField []

    @state = new ReactiveField {}
    @_initializeState()

    # Subscribe to this location's translations.
    translationNamespace = @constructor.id()
    @_translationSubscribtion = AB.subscribeNamespace translationNamespace

    # Also subscribe to translations of exit locations so we get their names.
    @exitsTranslationSubscribtions = {}
    @_exitsTranslationsAutorun = Tracker.autorun (computation) =>
      for directionKey, locationId of @exits()
        @exitsTranslationSubscribtions[locationId] = AB.subscribeNamespace locationId

    # Subscribe to this location's script translations.
    translationNamespace = @constructor.id()
    @_translationSubscribtionScript = AB.subscribeNamespace "#{translationNamespace}.Script"

    # Create the scripts.
    @scripts= {}

    if @constructor.scriptUrls
      scriptFiles = for scriptUrl in @constructor.scriptUrls()
        file = new LOI.Adventure.ScriptFile
          locationId: @constructor.id()
          url: @constructor.versionUrl "/packages/#{scriptUrl}"

        file.promise

      Promise.all(scriptFiles).then (scriptFiles) =>
        for scriptFile in scriptFiles
          # Add the loaded and translated script nodes to this location.
          _.extend @scripts, scriptFile.scripts

        @onScriptsLoaded()

  destroy: ->
    @_translationSubscribtion.stop()

    @_exitsTranslationsAutorun.stop()
    @exitsTranslationSubscribtions = null

    @_translationSubscribtionScript.stop()

  ready: ->
    @_translationSubscribtion.ready()

  onScriptsLoaded: -> # Override to create location's script logic. Use @scriptNodes to get access to script nodes.

  _initializeState: ->
    localStorageKey = "#{@constructor.id()}.state"

    # Load the current state from local storage.
    storedState = localStorage.getItem localStorageKey
    @state EJSON.parse storedState if storedState

    # Start listening for state changes.
    @_stateChangeAutorun = Tracker.autorun (computation) =>
      state = @state()

      # Store the new state into local storage.
      encodedValue = EJSON.stringify state
      localStorage.setItem localStorageKey, encodedValue

  addExit: (directionKey, locationId) ->
    exits = @exits()
    exits[directionKey] = locationId
    @exits exits

  addActor: (actor) ->
    actor.director @director
    @actors @actors().concat actor

    # Allow chaining syntax.
    actor
