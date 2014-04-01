define ->
  class Provider
    constructor: (@type) ->

    getComponent: ->
      new window[@type]

  Object.defineProperty Provider.prototype, 'identifier', 
    get: ->
      @type
  
  return Provider;