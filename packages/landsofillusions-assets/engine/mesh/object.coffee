LOI = LandsOfIllusions

class LOI.Assets.Engine.Mesh.Object extends THREE.Object3D
  constructor: (@mesh, objectData) ->
    super arguments...
    
    # Note: We can't call these layers, since that's an Object3D rendering system.
    @engineLayers = new ComputedField =>
      return unless layersData = objectData.layers.getAllWithoutUpdates()
      
      for layerData in layersData
        new @constructor.Layer @, layerData

    @ready = new ComputedField =>
      return unless layers = @engineLayers()

      for layer in layers
        return unless layer.ready()

      true

    # Update object children.
    Tracker.autorun (computation) =>
      # Clean up previous children.
      @remove @children[0] while @children.length

      layers = @engineLayers()
      return unless layers?.length

      # Add new children.
      @add layer for layer in layers

      if @mesh.options.debug?()
        currentCluster = @mesh.options.currentCluster?()

        # Add edge lines.
        for edge in objectData.solver.edges

          # Do not draw edges of unselected clusters in debug mode.
          continue if currentCluster and currentCluster not in [edge.clusterA.layerCluster, edge.clusterB.layerCluster]

          lineSegments = edge.getLineSegments objectData.mesh.cameraAngles.get 0
          lineSegments.layers.set 2
          @add lineSegments
      
      @mesh.options.sceneManager.addedSceneObjects()

    # Update visibility.
    Tracker.autorun (computation) =>
      # See if mesh object visibility is controlled externally.
      @visible = @mesh.options.objectVisibility? objectData.name()

      # Default to object's visibility in the mesh file.
      @visible ?= objectData.visible()

      @mesh.options.sceneManager.scene.updated()