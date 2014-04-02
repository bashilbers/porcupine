define ->
  # private variables

  ###*
   * Hash of event names and arrays of handler functions. Each handler
   * is called whenever that event is emitted.
   *
   * Example:
   * 'ui.channel.toggle': [
   *   function,
   *   function
   * ]
   *
   * @type {Object}
  ###
  events = {}

  class EventEmitter
    ###*
     * Triggers an event and sends it to all listeners of that event
     * If data is not an array, it will be wrapped in an array.
     *
     * @param  {String} eventName
     * @param  {Array}  data
     * @param  {Object} context Will be available as `this` in callback
     * @return {EventEmitter}
    ###
    emit: (event, context, data) ->
      listeners = events[event]
      context   = context or {}

      # cast data to array if needed
      data = (data instanceof Array) ? data : [data]

      # no listeners found for this event, do not bother
      return false if not listeners

      # send message to each listener
      listener.callback.apply context, data for listener of listeners

    ###*
     * Add a single listener callback for given event
     * or add a hash for multiple events.
     *
     * Example using hash: {
     *   'ui.channel.toggle': function,
     *   'ui.channel.close': function
     * }, 10
     *
     * Example using single: 'ui.channel.toggle', function, 10
     *
     * @param   {String}|{Object}   event
     * @param   {Function}          callback
     * @param   {Number}            priority
     * @return  {EventEmitter}
    ###
    on: (event, callback, priority) ->
      if (typeof event is 'object')
        event.every (name, cb) =>
          @on name, cb, callback # callback is priority here... I know -_-

      listeners = events[event]

      # create a new entry for this event if we don't know it yet
      listeners = events[event] = [] if not listeners

      priority = parseInt priority or 0, 10
      listeners.push callback: callback, priority: priority

      # re-sort subscribers so highest priority is first
      listeners = listeners.sort (a, b) ->
        b.priority - a.priority

    ###*
     * Removes listener from given event
     *
     * @param   {String}   event
     * @param   {Function} listener
     * @return  {EventEmitter}
    ###
    removeListener: (event, listener) ->
      listeners = events[event]

      # NOOP
      return if not listeners

      index = listeners.indexOf listener

      # not found among existing listeners, don't even worry about removing
      return if index is -1

      # remove from listeners
      listeners.splice index, 1

      # allow chaining