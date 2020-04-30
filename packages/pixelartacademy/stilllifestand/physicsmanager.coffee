AE = Artificial.Everywhere
AR = Artificial.Reality
LOI = LandsOfIllusions
PAA = PixelArtAcademy

_transform = new Ammo.btTransform

class PAA.StillLifeStand.PhysicsManager
  constructor: (@stillLifeStand) ->
    @collisionConfiguration = new Ammo.btDefaultCollisionConfiguration
    @dispatcher = new Ammo.btCollisionDispatcher @collisionConfiguration
    @overlappingPairCache = new Ammo.btDbvtBroadphase
    @solver = new Ammo.btSequentialImpulseConstraintSolver
    @dynamicsWorld = new Ammo.btDiscreteDynamicsWorld @dispatcher, @overlappingPairCache, @solver, @collisionConfiguration
    @dynamicsWorld.setGravity new Ammo.btVector3 0, -9.81, 0

    @simulationTimestep = 1 / 300
    @maxSimulationStepsPerFrame = 0.1 / @simulationTimestep

    # We use minimal damping for improved stability.
    @linearDamping = 0.0001
    @angularDamping = 0.0001

    @surroundingGasDensity = 1.225 # Kg / m³

    @minSpeedSquaredToApplyDrag = 1e-3

    @_previousCursorPosition = new THREE.Vector3

    # Add ground of wooden material.
    @ground = new Ammo.btRigidBody new Ammo.btRigidBodyConstructionInfo 0,
      new Ammo.btDefaultMotionState new Ammo.btTransform Ammo.btQuaternion.identity, new Ammo.btVector3(0, -0.5, 0)
    ,
      new Ammo.btBoxShape new Ammo.btVector3(500, 0.5, 500), 0

    @ground.setRestitution 0.6
    @ground.setFriction 0.7
    @ground.setRollingFriction 0.05

    @dynamicsWorld.addRigidBody @ground

    # Add scene items.
    @items = new AE.ReactiveArray =>
      @stillLifeStand.sceneManager()?.items()
    ,
      added: (item) =>
        # Set default damping on the item.
        item.physicsObject.body.setDamping @linearDamping, @angularDamping

        # Add the item to the simulation.
        @dynamicsWorld.addRigidBody item.physicsObject.body

      removed: (item) =>
        @dynamicsWorld.removeRigidBody item.physicsObject.body

  destroy: ->
    @items.stop()

    Ammo.destroy @dynamicsWorld
    Ammo.destroy @solver
    Ammo.destroy @overlappingPairCache
    Ammo.destroy @dispatcher
    Ammo.destroy @collisionConfiguration

  startMovingItem: (item, cursorPosition) ->
    @_clearCursorConstraint()

    # Calculate cursor position in item space.
    item.renderObject.updateMatrixWorld true
    worldToMovingItem = new THREE.Matrix4().getInverse item.renderObject.matrixWorld
    cursorPositionInItemSpace = cursorPosition.clone().applyMatrix4 worldToMovingItem

    # Add a constraint to the cursor.
    @_movingBody = item.physicsObject.body
    @_cursorConstraint = new Ammo.btPoint2PointConstraint @_movingBody, cursorPositionInItemSpace.toBulletVector3()
    @_cursorConstraint.m_setting.m_tau = 0.001

    @dynamicsWorld.addConstraint @_cursorConstraint

    # Disable deactivation for the object.
    @_movingBody.setActivationState Ammo.btCollisionObject.ActivationStates.DisableDeactivation

    @_previousCursorPosition.copy cursorPosition

  moveItem: (cursorPosition) ->
    return unless @_cursorConstraint

    @_cursorConstraint.setPivotB cursorPosition.toBulletVector3()

    # Set damping relative to how much the cursor moved.
    distanceFactor = Math.min 0.01, cursorPosition.clone().sub(@_previousCursorPosition).length()

    linearDamping = Math.max @_movingBody.getLinearDamping(), distanceFactor * 100
    angularDamping = Math.max @_movingBody.getAngularDamping(), distanceFactor * 100
    @_movingBody.setDamping linearDamping, angularDamping

    @_previousCursorPosition.copy cursorPosition

  endMovingItem: ->
    @_clearCursorConstraint()

  _clearCursorConstraint: ->
    return unless @_cursorConstraint

    @dynamicsWorld.removeConstraint @_cursorConstraint
    @_cursorConstraint = null

    # Re-enable deactivation.
    @_movingBody.setActivationState Ammo.btCollisionObject.ActivationStates.ActiveTag

    # Reset damping.
    @_movingBody.setDamping @linearDamping, @angularDamping

  update: (appTime) ->
    return unless appTime.elapsedAppTime

    if @_cursorConstraint
      # Relax damping of moving body.
      linearDamping = Math.max @_movingBody.getLinearDamping() - appTime.elapsedAppTime, @linearDamping
      angularDamping = Math.max @_movingBody.getAngularDamping() - appTime.elapsedAppTime, @angularDamping
      @_movingBody.setDamping linearDamping, angularDamping

    @applyDrag()

    @dynamicsWorld.stepSimulation appTime.elapsedAppTime, @maxSimulationStepsPerFrame, @simulationTimestep

    @_updateItem item for item in @items()

  _updateItem: (item) ->
    # Transfer transforms from physics to render objects.
    item.physicsObject.motionState.getWorldTransform _transform

    item.renderObject.position.setFromBulletVector3 _transform.getOrigin()
    item.renderObject.quaternion.setFromBulletQuaternion _transform.getRotation()
