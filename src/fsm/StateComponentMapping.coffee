define ['./ComponentInstanceProvider'], (ComponentInstanceProvider) ->
  class Mapping
    constructor: (@creatingState, @type) ->

    withInstance: (instance) ->
      @setProvider new ComponentInstanceProvider(instance)

    setProvider: (provider) ->
      @provider = provider
      @creatingState.setProvider @type, provider
      return @creatingState