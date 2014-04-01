###*
 * This component provider always returns the same instance of the component. 
 * The instance is passed to the provider at initialisation.
###
define ->
  class Provider
    constructor: (@instance) ->

    getComponent: ->
      @instance

  Object.defineProperty Provider.prototype, 'identifier', 
    get: @getComponent
  
  return Provider;