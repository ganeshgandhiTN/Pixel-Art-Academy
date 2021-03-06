AM = Artificial.Mirage
LOI = LandsOfIllusions

class LOI.Adventure extends LOI.Adventure
  @debugLocation = false
  
  _initializeLocation: ->
    # We store player's current location locally so that multiple people
    # can use the same user account and walk around independently.
    @playerLocationId = new ReactiveField null
    Artificial.Mummification.PersistentStorage.persist
      storageKey: 'LandsOfIllusions.Adventure.currentLocationId'
      field: @playerLocationId
      tracker: @
      consentField: LOI.settings.persistGameState.allowed

    # Start at the default player location.
    unless @playerLocationId()
      @playerLocationId @startingPoint()?.locationId

    @currentLocationId = new ComputedField =>
      console.log "Recomputing current location." if LOI.debug or LOI.Adventure.debugLocation

      # Memory provides its own location.
      if memory = @currentMemory()
        locationId = memory.locationId
        
      else
        if LOI.characterId() or not LOI.settings.persistGameState.allowed()
          # Character's location is always read from the state. Also used when saving game state is not allowed.
          locationId = @gameState()?.currentLocationId
  
        else
          # Local storage is allowed so load player's location from there.
          locationId = @playerLocationId()

      console.log "Current location ID is", locationId if LOI.debug or LOI.Adventure.debugLocation

      locationId
    ,
      true

    # Instantiate current location. It depends only on the ID.
    @currentLocation = new ComputedField =>
      # Wait until the timeline ID is ready.
      return unless currentTimelineId = @currentTimelineId()

      # Wait until initialization has finished, since location might ask to instantiate things.
      return unless LOI.adventureInitialized()

      # React to location ID changes.
      currentLocationId = @currentLocationId()

      Tracker.nonreactive =>
        @_currentLocation?.destroy()

        # Clear any running scripts (except paused which need to persist across location changes).
        LOI.adventure.director.stopAllScripts paused: false

        currentLocationClass = LOI.Adventure.Location.getClassForId currentLocationId

        # If the location is not found, see if we have one stored in the state.
        unless currentLocationClass
          stateLocationId = @gameState()?.currentLocationId
          currentLocationClass = LOI.Adventure.Location.getClassForId stateLocationId

          # If the location is still not found, start at the default location.
          unless currentLocationClass
            console.warn "Location class not found, moving back to start.", currentLocationId if currentLocationId
  
            switch currentTimelineId
              when PixelArtAcademy.TimelineIds.DareToDream
                currentLocationClass = Retropolis.Spaceport.AirportTerminal.Terrace
  
              when LOI.TimelineIds.RealLife
                currentLocationClass = Retronator.HQ.Cafe
  
              when LOI.TimelineIds.Construct
                currentLocationClass = LandsOfIllusions.Construct.Loading
  
              when LOI.TimelineIds.Present
                currentLocationClass = SanFrancisco.Apartment.Studio
                
              when LOI.TimelineIds.Memory
                # This is a stale memory (one where the location where it was made is not 
                # available anymore). Cancel the memory so the normal location returns.
                # TODO: We would probably want to give some indication to the player the memory didn't work.
                @exitMemory()
                return

          # Set the new location
          @setLocationId currentLocationClass.id()

        console.log "Creating new location with ID", currentLocationClass.id() if LOI.debug or LOI.Adventure.debugLocation

        # Create a non-reactive reference so we can refer to it later.
        @_currentLocation = new currentLocationClass
        
        @_currentLocation
    ,
      # Make sure to keep this computed field running.
      true

    @currentRegionId = new ComputedField =>
      @currentLocation()?.region()?.id()
    ,
      true

    @currentRegion = new ComputedField =>
      # Make sure the location actually matches the location ID (otherwise we might be in the middle of a change).
      # This function could hit first if player permissions are changing due to user/character change.
      return unless @currentLocation()?.id() is @currentLocationId()

      return unless currentRegionClass = LOI.Adventure.Region.getClassForId @currentRegionId()

      # Check that the player can be in this region.
      playerHasPermission = currentRegionClass.playerHasPermission()

      # If it returns undefined it means it can't yet determine it.
      return unless playerHasPermission?

      # If we don't have permission, redirect to region's exit location.
      unless playerHasPermission
        console.warn "Player does not have permission to be in the region", currentRegionClass
        @setLocationId currentRegionClass.exitLocation()
        return

      # Everything is OK, instantiate the region.
      Tracker.nonreactive =>
        # Do we even need to create a new region or is this just a recompute to determine new permissions?
        return @_currentRegion if @_currentRegion instanceof currentRegionClass

        @_currentRegion?.destroy()
        @_currentRegion = new currentRegionClass
        @_currentRegion
    ,
      true

    # Run logic on entering a new location.
    @locationOnEnterResponseResults = new ReactiveField null
    
    @autorun (computation) =>
      # Clear previous enter responses.
      Tracker.nonreactive => @locationOnEnterResponseResults null

      return unless LOI.adventureInitialized()
      return unless location = @currentLocation()
      return unless location.ready()
      currentLocationClass = location.constructor

      # Wait for listeners to get instantiated as well.
      Tracker.afterFlush => Tracker.nonreactive =>
        # Wait for listeners to be ready.
        @autorun (computation) =>
          return unless listeners = LOI.adventure.currentListeners()

          # Exclude the listeners that are part of scenes that don't happen on this location.
          listeners = _.filter listeners, (listener) =>
            listenerScene = listener.options.parent if listener.options.parent instanceof LOI.Adventure.Scene

            # We want to include scenes that are present on all locations.
            return true unless listenerLocationClass = listenerScene?.location()

            # If the location is specified, it must match with current location.
            listenerLocationClass is currentLocationClass

          # Wait for all listeners to be ready.
          for listener in listeners
            return unless listener.ready()

          computation.stop()

          Tracker.nonreactive =>
            # Query all the listeners if they need to perform any action on
            # enter and save the results for the interface to use as well.
            responseResults = for listener in listeners
              enterResponse = new LOI.Parser.EnterResponse {currentLocationClass}

              listener.onEnter enterResponse

              {enterResponse, listener}

            @locationOnEnterResponseResults responseResults

    # We also need to store the location the user logged into Construct from, so we can take them back there.
    @_immersionExitLocationId = new ReactiveField Retronator.HQ.LandsOfIllusions.Room.id()
    Artificial.Mummification.PersistentStorage.persist
      storageKey: 'LandsOfIllusions.Adventure.immersionExitLocationId'
      field: @_immersionExitLocationId
      tracker: @
      consentField: LOI.settings.persistGameState.allowed

    @immersionExitLocationId = new ComputedField =>
      if LOI.settings.persistGameState.allowed()
        @_immersionExitLocationId()
        
      else
        @gameState()?.immersionExitLocationId
        
  saveImmersionExitLocation: ->
    # Save current location to local storage.
    currentLocationId = @currentLocationId()
    @_immersionExitLocationId currentLocationId

    # Save immersion location to state.
    if state = @gameState()
      state.immersionExitLocationId = currentLocationId
      @gameState.updated()

  setLocationId: (locationClassOrId) ->
    locationId =  _.thingId locationClassOrId
    characterId = LOI.characterId()

    console.log "Setting location ID to", locationId if LOI.debug

    # Update locally stored player location if we're not synced to a character.
    @playerLocationId locationId unless characterId

    # Save current location to state.
    if state = @gameState()
      state.currentLocationId = locationId
      @gameState.updated()
      
    # Create a move action for characters.
    if characterId
      LOI.Memory.Action.do LOI.Memory.Actions.Move.type, characterId,
        timelineId: @currentTimelineId()
        locationId: locationId
      
  goToLocation: (locationClassOrId) ->
    # Don't allow location changes when in a memory (since it's defined by the memory document).
    return if @currentMemory()
    
    currentLocationClass = _.thingClass @currentLocationId()
    destinationLocationClass = _.thingClass locationClassOrId
    
    # Query all the listeners if they need to perform any action on exit.
    results = for listener in @currentListeners()
      exitResponse = new LOI.Parser.ExitResponse {currentLocationClass, destinationLocationClass}

      listener.onExitAttempt exitResponse

      {exitResponse, listener}

    # See if exit was prevented.
    for result in results
      return if result.exitResponse.wasExitPrevented()

    # Notify the listeners that exit will complete.
    for result in results
      result.listener.onExit result.exitResponse

    # Change location after interface is prepared for it.
    @interface.prepareForLocationChange destinationLocationClass, =>
      @setLocationId locationClassOrId
