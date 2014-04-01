###*
 * Represents a state for an EntityStateMachine.
 * The state contains any number of ComponentProviders which are
 * used to add components to the entity when this state is entered.
###
define [
  'porcupine/fsm/StateComponentMapping'
], (StateComponentMapping) ->
  class State
    addMapping: (type) ->
      new StateComponentMapping @, type

    getProviders: ->
      @providers

    getProvider: (type) ->
      @providers[type]

    setProvider: (type, provider) ->
      @providers[type] = provider

    hasProvider: (type) ->
      !!@providers[type]