###*
 * Systems have their own set of logic specific
 * to the components that they correspond to.
 * You may have a RenderSystem to store all entities with
 * Renderable components and display them when necessary in your game loop.
 * You could also have a PhysicsSystem, AnimationSystem, and so on.
###
define ->
  class System
    ###*
     * The main game engine
     * @type Engine
    ###
    engine: null

    isStarted: no

    entities: []

    # these components need to be matched for this
    # system to be active on an entity
    requiredComponents: []

    ###*
     * Called when this system is plugged into the engine
     *
     * @param   Engine  engine
     * @return System
    ###
    addToEngine: (@engine) ->

    # system startup
    start: ->
      @entities = @engine.entityManager.findBy @requiredComponents
      @isStarted = yes

    ###*
     * This method is called every frame by the SystemManager
     * until the system is removed from the engine.
     * Override this method to add your own functionality.
     *
     * @param time The duration, in seconds, of the frame
    ###
    run: (time) ->
      throw new Error 'Implement run in a derived subsystem!'

    ###*
     * Called when this system is being removed from the engine context.
    ###
    stop: ->
      # throw 'Implement stop in a derived subsystem!'; @note: NOOP
