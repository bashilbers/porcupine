###*
 * @fileOverview An entity is a collection of components.
 * These components describe how an entity functions.
 * In terms of a game, an entity is a single instance
 * of an object that exists in your game.
 * So if you have two tanks of the same "type" in your game,
 * you have two entities.
 * Entities do not store contain logic, they only contain data (state).
 *
 * @module porcupine/ecs
 * @author Bas Hilbers
###
define ['porcupine/utils/Signal'], (Signal) ->
  class Entity
    @_id: 0

    @create: (components...) ->
      entity = new Entity
      for component in components
        entity.addComponent component

    id: Entity._id++

    ###*
     * Components are the basic building blocks for entities.
     * They store information specific to their existence.
     * For example, you might have a Renderable component
     * in your game which contains all of the necessary data
     * for the rendering system to display an entity on the screen.
     *
     * @type {Map}
    ###
    components: new Map
    
    ###*
     * @public
     * @readonly
     * @type {Signal}
    ###
    onComponentAdded: new Signal
    
    ###*
     * @public
     * @readonly
     * @type {Signal}
    ###
    onComponentRemoved: new Signal
 
    ###*
     *  @param  {object} component
     *  @param  {null|string}  key
     *  @return {Entity}
    ###
    addComponent: (component) ->
      @components.set component.constructor, component
      @onComponentAdded.emit @, component.constructor

    getComponent: (key) ->
      @components.get key
    
    hasComponent: (component) ->
      @components.has component

    removeComponent: (key) ->
      @onComponentRemoved.emit @, key
      @components.delete key
      
    serialize: ->
      serialized = {}

      @components.forEach (key, component) ->
        serialized.components[key] = component.serialize()
        
      JSON.stringify serialized