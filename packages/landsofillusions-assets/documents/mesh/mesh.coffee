AE = Artificial.Everywhere
AM = Artificial.Mummification
LOI = LandsOfIllusions

# A 3D model asset.
class LOI.Assets.Mesh extends LOI.Assets.VisualAsset
  @id: -> 'LandsOfIllusions.Assets.Mesh'
  # cameraAngles: array of scene viewpoints
  #   name: text identifier
  #   picturePlaneDistance: the distance in pixels the camera is away from the picture plane or null for ortographic
  #   picturePlaneOffset: offset of the center of the picture plane in pixels
  #     x, y
  #   pixelSize: the size of a camera pixel in world units
  #   position: location of the camera in world space
  #     x, y, z
  #   target: location of where the camera is pointing
  #     x, y, z
  #   up: up direction of the camera
  #     x, y, z
  #   customMatrix: array of 16 matrix elements
  # objects: array of scene objects
  #   name: name of the object
  #   visible: boolean if the object is rendered
  #   solver: name of the solver used to construct the mesh from the pictures, with possible values:
  #     polyhedron (default, object with only flat surfaces)
  #     organic (object with a continuously curved surface)
  #     plane (all clusters are positioned in one plane)
  #     rope (deformable lines)
  #     cloth (deformable surface)
  #   lastClusterId: the last unique integer used to create a cluster
  #   layers: array of
  #     name: name of the layer
  #     visible: boolean if this layer should be drawn
  #     order: floating point order of the layer
  #     pictures: array of images that describe the object, indexed by cameraAngle index
  #       bounds: dimensions of the bitmap
  #         x, y: top-left corner relative to the camera origin (z-axis)
  #         width, height: size of the bitmap
  #       maps: object of texture maps that hold information for this picture
  #         {type}: what information is contained in this map, with possible values:
  #             flags (1 byte per pixel: which of the maps are valid at each pixel)
  #             clusterId (2 bytes per pixel: which cluster this pixel belongs to)
  #             materialIndex (flag value 1, 1 byte per pixel: index)
  #             paletteColor (flag value 2, 2 bytes per pixel: ramp, shade)
  #             directColor (flag value 4, 3 bytes per pixel: r, g, b)
  #             alpha (flag value 8, 1 byte per pixel: a)
  #             normal (flag value 16, 3 bytes per pixel: x, y, z as signed bytes (-1 to 1 float mapped to -127 to 127))
  #           data: array buffer holding the pixels, not sent to the server
  #           compressedData: binary object with compressed version of data, sent to the server
  #       clusters: map of auto-generated clusters detected in the picture
  #         {id}: unique integer identifying this cluster in the layer
  #           sourceCoordinates: absolute coordinates in the picture where this cluster's map information is taken from
  #             x, y
  #     clusters: map of auto-generated clusters in world space
  #       {id}: unique integer identifying this cluster in the layer
  #         properties: user-defined properties set on the cluster
  #           name: unique name by which the cluster can be referenced in code
  #           navigable: boolean if the cluster is navigable for pathfinding purposes
  #           coplanarPoint: forces the cluster to use this point for its plane
  #             x, y, z
  #         plane: the world plane for flat clusters
  #           point: a point in the plane
  #             x, y, z
  #           normal: the normal of the plane
  #             x, y, z
  #         material: subset of properties of the picture cluster (relevant map values at source coordinates)
  #           materialIndex, paletteColor, directColor, alpha, normal
  #         geometry:
  #           vertices: Float32Array with vertices of the cluster, not sent to the server
  #           compressedVertices: binary object with compressed version of vertices, sent to the server
  #           normals: Float32Array with normals of the cluster, not sent to the server
  #           compressedNormals: binary object with compressed version of normals, sent to the server
  #           indices: UInt32Array with indices of the cluster, not sent to the server
  #           compressedIndices: binary object with compressed version of indices, sent to the server
  # materials: array of shaders used to draw objects
  #   name: what the materials represents
  #   type: ID of the shader
  #   ramp: index of the ramp within the palette
  #   shade: index of the shade in the ramp
  #   dither: amount of dither used from 0 to 1
  # landmarks: array of named locations, as defined for visual asset
  #   ...
  #   object: integer index of the object this landmark is on
  #   layer: integer index of the object layer this landmarks is on
  #   cameraAngle: integer index of the camera layer this landmark's (x,y) location is defined from
  @Meta
    name: @id()

  # Store the class name of the visual asset by which we can reach the class by querying LOI.Assets. We can't simply
  # use the name parameter, because in production the name field has a minimized value.
  @className: 'Mesh'

  # Methods

  @load: @method 'load'
  @save: @method 'save'

  @landmarkPattern =
    name: Match.OptionalOrNull String
    object: Match.Optional Number
    layer: Match.Optional Number
    cameraAngle: Match.Optional Number
    x: Match.Optional Number
    y: Match.Optional Number

  initialize: ->
    # Track whether we need to save the mesh.
    @dirty = new ReactiveField false
    @_updatedDependency = new Tracker.Dependency

    # Initialize array fields
    @cameraAngles = new @constructor.ArrayField @, 'cameraAngles', @cameraAngles, @constructor.CameraAngle
    @objects = new @constructor.ArrayField @, 'objects', @objects, @constructor.Object
    @materials = new @constructor.ArrayField @, 'materials', @materials, @constructor.Material

    # After mesh is initialized, mark to be in saved state.
    @dirty false

    @_initialized = true
    
  depend: ->
    @_updatedDependency.depend()

  contentUpdated: ->
    @dirty true
    @_updatedDependency.changed()

  save: ->
    saveData = @getManuallySavedData()

    # Send the mesh to server.
    LOI.Assets.Mesh.save @_id, saveData, (error) =>
      if error
        console.error "Error saving mesh", saveData, error

    # Mark the state clean.
    @dirty false

  getManuallySavedData: ->
    saveData = {}

    # Save array fields.
    @cameraAngles.save saveData
    @objects.save saveData
    @materials.save saveData

    saveData

  getLandmarkByName: (landmarkName) ->
    _.find @landmarks, (landmark) -> landmark.name is landmarkName

  getClusterByName: (clusterName) ->
    for object in @objects.getAll()
      for layer in object.layers.getAll()
        if cluster = layer.getClusterByName clusterName
          return cluster
          
    null

  getLandmarkPositionVector: (landmarkOrIndexOrName) ->
    if _.isString landmarkOrIndexOrName
      landmark = @getLandmarkByName landmarkOrIndexOrName

      unless landmark
        console.warn "Couldn't find landmark", landmarkOrIndexOrName
        return

    else if _.isNumber landmarkOrIndexOrName
      landmark = @landmarks[landmarkOrIndexOrName]

      unless landmark
        console.warn "Couldn't find landmark index", landmarkOrIndexOrName
        return

    else
      return unless landmark = landmarkOrIndexOrName

    return unless layer = @objects.get(landmark.object)?.layers.get(landmark.layer)
    return unless picture = layer.getPictureForCameraAngleIndex landmark.cameraAngle
    
    clusterId = picture.getClusterIdForPixel Math.round(landmark.x), Math.round(landmark.y)
    return unless clusterPlaneData = layer.clusters.get(clusterId).plane()
    return unless cameraAngle = @cameraAngles.get landmark.cameraAngle

    planeNormal = THREE.Vector3.fromObject clusterPlaneData.normal
    planePoint = THREE.Vector3.fromObject clusterPlaneData.point
    plane = new THREE.Plane().setFromNormalAndCoplanarPoint planeNormal, planePoint

    points = [
      x: landmark.x
      y: landmark.y
    ]

    cameraAngle.projectPoints(points, plane)[0]

  getSpriteBoundsAndLayersForCameraAngle: (cameraAngleIndex) ->
    spriteLayers = []
    spriteBounds = null

    # Rebuild layers from objects for camera angle.
    for object in @objects.getAll()
      {bounds, layers} = object.getSpriteBoundsAndLayersForCameraAngle cameraAngleIndex

      continue unless bounds

      boundsRectangle = AE.Rectangle.fromDimensions bounds

      if spriteBounds
        spriteBounds = spriteBounds.union boundsRectangle

      else
        spriteBounds = boundsRectangle

      spriteLayers.push layers...

    bounds: spriteBounds?.toObject()
    layers: spriteLayers

  getPreviewSprite: (cameraAngleIndex) ->
    @initialize() unless @_initialized

    cameraAngleIndex ?= @cameraAngles.getFirstIndex()
    {bounds, layers} = @getSpriteBoundsAndLayersForCameraAngle cameraAngleIndex

    # The sprite expects materials as a map instead of an array.
    materials = @materials.getAllAsIndexedMap()

    new LOI.Assets.Sprite
      palette: _.pick @palette, ['_id']
      layers: layers
      materials: materials
      bounds: bounds

  # Database content

  getSaveData: ->
    saveData = super arguments...

    _.extend saveData, _.pick @, ['cameraAngles', 'objects']

    if @_initialized
      saveData = _.omit saveData, ['cameraAngles', 'objects', 'materials']
      _.extend saveData, @getManuallySavedData()

    else
      # We refetch the mesh instead of simply send the @ reference because this
      # instance might get initialized later to generate the preview image.
      LOI.Assets.Mesh.documents.findOne @_id

  getPreviewImage: ->
    engineSprite = new LOI.Assets.Engine.Sprite
      spriteData: => @getPreviewSprite()

    engineSprite.getCanvas
      lightDirection: new THREE.Vector3 0, 0, -1
