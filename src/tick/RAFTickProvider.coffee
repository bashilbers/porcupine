define [
  'porcupine/utils/Signal'
  'porcupine/utils/Timer'
], (Signal, Timer) ->
  class RAFTickProvider
    ticked: new Signal

    constructor: (cb) ->
      @add cb if typeof cb is 'function'
      @timer = new Timer

    ###*
     * Start the ticking by using window.requestAnimationFrame
    ###
    start: ->
      @requestId = requestAnimationFrame @tick

    ###*
     * This method is called every frame.
     *
     * @param time The duration, in seconds, of the frame
     * @return RAFTickProvider
    ###
    tick: (time) =>
      if @timer.isRunning
        delta = 0
        @timer.start()
      else
        @timer.registerTime()
        delta = @timer.elapsedTime
      
      @ticked.emit delta
      @requestId = requestAnimFrame @tick
      
    ###*
     * Adds a callback to the tick method
    ###
    add: (listener, context) ->
      @ticked.add listener, context
            
    ###*
     * Removes a callback from the tick method
    ###
    remove: (listener, context) ->
      @ticked.remove listener, context

    ###*
     * Stop ticking
     *
     * @return RAFTickProvider
    ###
    stop: ->
      cancelRequestAnimFrame @requestId
      @timer.stop()