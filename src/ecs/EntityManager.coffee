define [
  'porcupine/ecs/Entity'
  'porcupine/utils/Signal'
], (Entity, Signal) ->
  prepareSelector = (selector) ->
    if typeof selector is 'string'
      selector.split ' '

    if typeof selector isnt 'object'
      null

  class EntityManager
    onEntityAdded: new Signal

    onEntityRemoved: new Signal

    entitities: []

    constructor: (@engine) ->

    ###*
     * Adds an entity to the internal storage.
     *
     * @param  {Object}    Entity
     * @return
    ###
    add: (entity) ->
      @entities.push entity
      @onEntityAdded @, entity: entity

    remove: (entity) ->
      @entities = @entities.filter (x) -> x isnt entity
      @onEntityRemoved @, entity: entity

    ###*
     * Return entities that contain at least all the specified components.
     *
     * @param selector, a list or a string of components.
     * @return An array of Entity objects, or
     *         null if no result was found.
    ###
    findBy = (selector) ->
      selector = prepareSelector selector

      if selector is null or selector.length is 0
        return []

      for entity in @entities
        valid = yes
        for requirement in selector
          break if not valid
          valid = no if not entity.hasComponent requirement

        if valid then results.push entity