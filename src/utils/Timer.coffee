define ->
  _timer = if window.performance then window.performance else Date

  ###*
   * The Timer uses the best possible timing API for starting,
   * stopping and registering the interleaved time.
   *
   * @class
  ###
  class Timer
    startTime: 0
    elapsedTime: 0
    isRunning: no

    ###*
     * Starts timing.
    ###
    start: ->
      @startTime = @now()
      @isRunning = yes

    ###*
     * Stops timing.
    ###
    stop: ->
      @registerTime()
      @reset()

    ###*
     * Registers a timer `click` so the interleaved time can be calculated.
     *
     * @param {number}  time
    ###
    registerTime: (time) ->
      if @isRunning
        newTime = time or @now()
        diff = 0.001 * (newTime - @startTime)
        @startTime = newTime
        @elapsedTime += diff

    ###*
     * Sets the starttime to 0 and flags as not running
    ###
    reset: ->
      @startTime = 0
      @isRunning = no

    ###*
     * Current time!
    ###
    now: ->
      _timer.now()