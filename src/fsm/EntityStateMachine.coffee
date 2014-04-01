###*
 * This is a state machine for an entity.
 * The state machine manages a set of states,
 * each of which has a set of component providers.
 * When the state machine changes the state, it removes
 * components associated with the previous state and
 * adds components associated with the new state.
###
define ['./EntityState'], (EntityState) ->
  class EntityStateMachine
    constructor: (@entity) ->
      @states = new Map
      @currentState = null

    addState: (name, state) ->
      @states.set name state
    
    createState: (name) ->
      @states.set name, new EntityState
      return state
  
    hasState: (name) ->
      @states.has name
  
    changeState: (name) ->
      throw { message: 'State ' + name + ' does not exist' } unless @hasState name

      newState = @states.get name
      toAdd = {}
    
      return if newState is @currentState
      
      if(!!newState)
        newStateProviders = newState.getProviders()
        Object.keys(newStateProviders).forEach (type) ->
          toAdd[type] = newStateProviders[type]
      
      if (!!this.currentState)
        currentStateProviders = @currentState.getProviders()
        Object.keys(currentStateProviders).forEach (type) =>
          other = toAdd[type]
          provider = currentStateProviders[key]

          if (other? and other.identifier is @currentState.getProvider(type).identifier)
            delete toAdd[type]
          else
            @entity.removeComponent provider.getComponent
      else
        toAdd = newState.getProviders()

    Object.keys(toAdd).forEach (type) =>
      @entity.addComponent toAdd[type].getComponent()

    @currentState = newState