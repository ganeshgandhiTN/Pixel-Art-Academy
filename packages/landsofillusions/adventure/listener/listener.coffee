AB = Artificial.Babel
LOI = LandsOfIllusions

class LOI.Adventure.Listener
  # Namespace for listener scripts.
  @Scripts: {}

  @scriptUrls: -> [] # Override to provide a list of script URLs to load.

  @avatars: -> {} # Override with a map of shorthands and thing classes for the things the listener needs to respond to.

  @initialize: ->
    # On the server, compile the scripts.
    if Meteor.isServer
      for scriptUrl in @scriptUrls()
        [packageId, pathParts...] = scriptUrl.split '/'
        path = pathParts.join '/'
        text = LOI.packages[packageId].assets.getText path

        new LOI.Adventure.ScriptFile
          text: text

  constructor: (@options = {}) ->
    # Subscribe to this listener's script translations.
    translationNamespace = @id() or @options.parent?.id()

    if translationNamespace
      @_scriptTranslationSubscription = AB.subscribeNamespace "#{translationNamespace}.Script"

    else
      console.warn "Listener", @, "doesn't have a translation namespace." if LOI.debug

    # Handles for custom autorun routines.
    @_autorunHandles = []

    # Create avatars prior to creating scripts, since some script initializations might need them.
    @avatars = {}
    for key, thingClass of @constructor.avatars()
      @avatars[key] = new LOI.Adventure.Thing.Avatar thingClass

    # Create the scripts.
    @scripts = {}
    @scriptsReady = new ReactiveField false

    scriptUrls = @constructor.scriptUrls()

    if scriptUrls.length
      scriptFilePromises = for scriptUrl in scriptUrls
        url = "/packages/#{scriptUrl}"

        if @options.parent.versionedUrl
          url = @options.parent.versionedUrl url

        else
          console.warn "Scripts are being used without versioning. Url:", url

        scriptFile = new LOI.Adventure.ScriptFile
          url: url
          listener: @

        # Return the generated script file promise.
        scriptFile.promise

      Promise.all(scriptFilePromises).then (scriptFiles) =>
        # Make sure listener was not already destroyed while we were loading files.
        return if @_destroyed

        for scriptFile in scriptFiles
          # Add the loaded and translated script nodes to this location.
          _.extend @scripts, scriptFile.scripts

        @onScriptsLoaded()

        @scriptsReady true

    else
      @scriptsReady true

  destroy: ->
    @_scriptTranslationSubscription.stop()

    handle.stop() for handle in @_autorunHandles

    for key, avatar of @avatars
      avatar.destroy()

    @avatars = null

    @cleanup()

    @_destroyed = true

  id: -> @constructor.id?()

  autorun: (handler) ->
    handle = Tracker.autorun handler
    @_autorunHandles.push handle

    handle

  ready: ->
    for key, avatar of @avatars
      return false unless avatar.ready()

    @scriptsReady()

  onScriptsLoaded: -> # Override to start reactive logic. Use @scripts to get access to script objects.

  onCommand: (commandResponse) -> # Override to listen to commands.

  onCommandExecuted: (likelyAction) -> # Override to react to a command being executed.

  onScriptNodeHandled: (node) -> # Override to react to a script node being handled.

  onChoicePlaceholder: (choicePlaceholderResponse) -> # Override to insert choice nodes at the placeholder.

  onEnter: (enterResponse) -> # Override to react to entering a location.

  onExitAttempt: (exitResponse) -> # Override to react to location change attempts, potentially preventing the exit.

  onExit: (exitResponse) ->
    # Override to react to leaving a location.

    @cleanup()

  cleanup: ->
    handle.stop() for handle in @_autorunHandles
    
    # Override to clean any timers or other autoruns that need to be cleaned when listener exits or is destroyed.
