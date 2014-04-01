define (require) ->
  SystemManager    = require 'porcupine/ecs/SystemManager'
  EntityManager    = require 'porcupine/ecs/EntityManager'
  RAFTickProvider  = require 'porcupine/tick/RAFTickProvider'
  
  class Engine
    constructor: (@settings = {}) ->
      # the tickProvider keeps our game loop spinning
      @tickProvider = settings.tickProvider or new RAFTickProvider @update
      
      # these "managers" are the beating ECS heart of this engine
      @systemManager = settings.systemManager or new SystemManager @
      @entityManager = settings.entityManager or new EntityManager @

    ###*
      * Flag game as running and start ticker.
      *
      * @return {Engine}
    ###
    start: ->
      @tickProvider.start()

    ###*
     * Flag game as stopped and stop ticker.
     *
     * @return {Engine}
    ###
    stop: ->
      @tickProvider.stop()

    ###*
     * This is the default implementation of the update loop runner.
     * You can easily overwrite it by changing the tickProvider
     * or its tick() method
    ###
    update: (delta) =>
      @systemManager.update delta