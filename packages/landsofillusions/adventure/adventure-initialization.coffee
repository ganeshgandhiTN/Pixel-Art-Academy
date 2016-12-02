AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Adventure extends LOI.Adventure
  @register 'LandsOfIllusions.Adventure'

  constructor: ->
    super

    @scriptHelpers = new LOI.Adventure.Script.Helpers @

    console.log "Adventure constructed." if LOI.debug

  onCreated: ->
    super

    console.log "Adventure created." if LOI.debug

    # Game state depends on whether the user is signed in or not and returns
    # the game  state from database when signed in or from local storage otherwise.
    @_localGameState = new LOI.LocalGameState

    _gameStateUpdatedDependency = new Tracker.Dependency

    _gameStateUpdated = null

    @_gameState = new ComputedField =>
      userId = Meteor.userId()
      console.log "Game state provider is recomputing. User ID is", userId if LOI.debug

      # Subscribe to user's game state and store subscription 
      # handle so we can know when the game state should be ready.
      @gameStateSubsription = Meteor.subscribe LOI.GameState.forCurrentUser
      console.log "Subscribed to game state from the database. Subscription:", @gameStateSubsription, "Is it ready?", @gameStateSubsription.ready() if LOI.debug
        
      # Find the state from the database.
      console.log "We currently have these game state documents:", LOI.GameState.documents.find().fetch() if LOI.debug

      gameState = LOI.GameState.documents.findOne('user._id': userId)
      console.log "Did we find a game state for the current user? We got", gameState if LOI.debug

      # Here we decide which provided of the game state we'll use, the database or local storage. In general this is
      # determined by whether the user is logged in, but we also want to use local storage while user is registering.
      # In that case the user will already be logged in, but the game logic hasn't yet created the game state document,
      # so we want to continue using local storage for continuity. However, this logic needs to be written in a way that
      # this fallback isn't activated when we don't have the game state because we haven't even subscribed to receive
      # the documents. That happens when the user is logged in upon launching the site and we should simply wait (and
      # show the loading screen while doing it) until the game state is loaded and all the rest of initialization
      # (location, inventory) can happen relative to actual game state from the database (for example, whether the url
      # points to an object we have in our possession).
      if gameState
        state = gameState.state
        _gameStateUpdated = (options) =>
          gameState.updated options
          _gameStateUpdatedDependency.changed()

      else if userId and not @gameStateSubsription.ready()
        # Looks like we're loading the state from the database during initial setup, so just wait.
        console.log "Waiting for game state subscription to complete." if LOI.debug
        _gameStateUpdated = => # Dummy function.
        state = null

      else
        # Fallback to local storage.
        state = @_localGameState.state()
        _gameStateUpdated = (options) =>
          # Local game state does not need to be flushed.
          return if options?.flush

          @_localGameState.updated()
          _gameStateUpdatedDependency.changed()

      # Initialize state if needed.
      if state and not state.initialized
        # It's our first time playing Pixel Art Academy. Start with a wallet in the inventory.
        @initializeGameState state

        Tracker.nonreactive => _gameStateUpdated()

      # Flush updates in the previous state.
      Tracker.nonreactive =>
        @gameState?.updated flush: true

      # Set the new updated function.
      @gameState?.updated = _gameStateUpdated

      console.log "%cNew game state has been set.", 'background: SlateGrey; color: white', state if LOI.debug

      state

    # To deal with delayed updates of game state from the database (the document gets refreshed with a throttled
    # schedule) we create a game state variable that is changed every time the game state gets updated from the
    # database (new document from @_gameState) and when it was just updated locally.
    @gameState = new ComputedField =>
      _gameStateUpdatedDependency.depend()
      @_gameState()

    # Set the updated function for the first time.
    @gameState.updated = _gameStateUpdated

    # We store player's current location locally so that multiple people
    # can use the same user account and walk around independently.
    @currentLocationId = new ReactiveField null
    Artificial.Mummification.PersistentStorage.persist
      storageKey: "LandsOfIllusions.Adventure.currentLocationId"
      field: @currentLocationId
      tracker: @

    # If we don't have a locally stored location, start at the entrance.
    unless @currentLocationId()
      @currentLocationId Retronator.HQ.Locations.Entrance.id()

    # Instantiate current location. It depends only on the ID.
    # HACK: ComputedField triggers recomputation when called from events so we use ReactiveField + autorun manually.
    @currentLocation = new ReactiveField null
    @autorun (computation) =>
      # React to location ID changes.
      currentLocationId = @currentLocationId()

      Tracker.nonreactive =>
        @_currentLocation?.destroy()

        currentLocationClass = LOI.Adventure.Location.getClassForId currentLocationId

        console.log "Creating new location with ID", currentLocationClass.id() if LOI.debug

        # Create a non-reactive reference so we can refer to it later.
        @_currentLocation = new currentLocationClass adventure: @

        # Reactively provide the state to the location.
        Tracker.autorun (computation) =>
          return unless gameState = @gameState()

          state = gameState.locations[currentLocationId]
          console.log "Sending new state to location", currentLocationId, "game state:", gameState, "location state", state if LOI.debug

          # Initialize location state if this is first time at location or the location is at a new version.
          targetVersion = currentLocationClass.version()
          unless state?.version is targetVersion
            console.log "Preparing to initialize location to new version", targetVersion is LOI.debug
            console.log "Location ID is", currentLocationId, currentLocationClass

            existingState = state or {}
            console.log "Current state is", existingState

            state = _.merge @_currentLocation.initialState(), existingState, version: targetVersion

            gameState.locations[currentLocationId] = state

            console.log "Initialized location", currentLocationId, "with new state", state if LOI.debug

            Tracker.nonreactive => @gameState.updated()

          @_currentLocation.state state

        @currentLocation @_currentLocation

    # Similar to location, create the active item.
    @activeItemId = new ReactiveField null

    # HACK: ComputedField triggers recomputation when called from events so we use ReactiveField + autorun manually.
    @activeItem = new ReactiveField null
    @autorun (computation) =>
      # Wait until location is ready and all things at location have loaded.
      currentLocation = @currentLocation()
      return unless currentLocation?.ready()

      activeItemId = @activeItemId()

      # Did the item even change?
      return if activeItemId is @_activeItem?.constructor.id()

      console.log "Active item ID changed to", activeItemId if LOI.debug

      console.log "Do we have an active item to deactivate?", @_activeItem if LOI.debug
      # Active item is not the same, so deactivate the current one if we have one.
      @_activeItem?.deactivate()

      # Do we even have the new item or did we switch to no item?
      if activeItemId
        # We do have an item, so find it in the inventory or at the location.
        @_activeItem = (@inventory activeItemId) or (currentLocation.things activeItemId)

        console.log "Did we find the new active item?", @_activeItem if LOI.debug

        if @_activeItem
          @_activeItem.activate()

        else
          # We can't use an item we don't have or see. Return the URL to the location.
          @constructor.goToLocation @currentLocationId()

      else
        # No more object
        @_activeItem = null

      @activeItem @_activeItem

    # Create inventory.
    @inventory = new LOI.StateNode
      adventure: @

    # Reactively update inventory state.
    @autorun (computation) =>
      console.log "Setting updated inventory state to the inventory object.", @gameState()?.player.inventory if LOI.debug

      @inventory.updateState @gameState()?.player.inventory

    @interface = new LOI.Adventure.Interface.Text adventure: @
    @parser = new LOI.Adventure.Parser adventure: @

    # Handle url changes.
    @_handleUrlChanges()

    # Make sure we're at the right URL after initialization is done.
    Tracker.afterFlush =>
      @rewriteUrl()

    # Flush the state updates to the database when the page is about to unload.
    window.onbeforeunload = =>
      @gameState?.updated flush: true

  onRendered: ->
    super

    console.log "Adventure rendered." if LOI.debug

  onDestroyed: ->
    super

    console.log "Adventure destroyed." if LOI.debug

    $('html').removeClass('lands-of-illusions-style-adventure')
