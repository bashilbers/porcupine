define ->
  class Player
    ###*
     * The duration for the audio to play
    ###
    duration: 0

    ###*
     *
    ###
    _volume: 1

    autoplay: no

    loop: no

    pos3d: [0, 0, -0.5]

    onEnd: new Signal

    onPause: new Signal

    onPlay: new Signal

    constructor: (@sound, settings) ->
      @autoplay = settings.autoplay or no
      @loop = settings.loop or no
      @pos3d = settings.pos3d or [0, 0, -0.5]

    play: ->

    pause: ->

    stop: ->

    seek: ->

    setPosition: (x = 0, y = 0, z = 0.5) ->
      if not @_webAudio
        throw new Error 'You try to set 3dpos of audio player when webAudio is not enabled!'

      @pos3d[0] = x
      @pos3d[1] = y
      @pos3d[2] = z
      @activeNode.panner.setPosition x, y, z

    fade: (from, to, length, cb) ->
      diff = Math.abs(from - to)
      dir = from > to ? 'down' : 'up'
      stepSize = 0.01
      steps = diff / stepSize
      stepTime = length / steps

      # set the volume to the start
      @volume = from

      for i in [0..steps]
        change = @volume + (dir is 'up' ? stepSize : -stepSize) * i
        volume = Math.round(1000 * change) / 1000

      setTimeout =>
        @volume = volume
        cb() if volume is to
      , stepTime * i

    getVolume: ->
      @_volume

    setVolume: (volume) ->
      #make sure volume is a number
      volume = parseFloat volume
      @_volume = volume

    ###*
     * Volume property definition
    Object.defineProperty(p, 'volume', {
        get: this.getVolume.bind(this),
        set: this.setVolume.bind(this)
    });
    ###

    unmute: ->
      @setMuted no

    mute: ->
      @setMuted yes

    setMuted: (m) ->