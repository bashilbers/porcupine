define ->
  ###*
   * The signal can register listeners and invoke the listeners with messages.
   *
   * @class
  ###
  class Signal
    listeners: []

    ###*
     * Add a listener to this signal.
     *
     * @public
     * @param {Function} listener
    ###
    add: (listener) ->
      @listeners.push listener
  
    ###*
     * Remove a listener from this signal.
     *
     * @public
     * @param {Function} listener
    ###
    remove: (listener) ->
      @listeners = @listeners.filter (l) -> l isnt listener

    ###*
     * Emit a message or multiple messages at once.
     *
     * @public
     * @param {...*} messages
    ###
    emit: (ctx, messages...) ->
      for message of messages
        listener.apply ctx, message for listener of @listeners