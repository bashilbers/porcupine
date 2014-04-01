define [
  'porcupine/utils/Signal'
], (Signal) ->
  class SystemManager
    onSystemAdded: new Signal

    onSystemRemoved: new Signal

    onSystemStarted: new Signal

    systems: []

    constructor: (@engine) ->

    add: (system, priority = 0) ->
      system.addToEngine @engine
      @systems.push system
      @sort()
      @onSystemAdded.emit @

    update: (delta) ->
      for system in @systems
        if not system.isStarted
          system.start()
          @onSystemStarted @
        system.run delta
    
    remove: (system) ->
      @systems = @systems.filter (x) -> x isnt system
      @onSystemRemoved @, system: system

    sort: ->
      @systems.sort (a, b) ->
        n = a.priority - b.priority
        if n isnt 0
          return n