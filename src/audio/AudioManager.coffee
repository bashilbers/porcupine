define ->
  class AudioManager
    muted: no

    volume: 1

    #var vendorContext = window.AudioContext || window.webkitAudioContext || window.mozAudioContext;
    ###
    this.context = device.hasWebAudio ? new vendorContext : null;

      // if we are using web audio, we need a master gain node
      if(device.hasWebAudio) {
          this.masterGain = this.context.createGain ? this.context.createGain() : this.context.createGainNode();
          this.masterGain.gain.value = 1;
      }
    ###

    # map of players to play audio with
    players: {}

    # map of sounds
    sounds: {}

    ###*
     * Attaches an AudioPlayer to this manager, if using webAudio this means
     * that the sound will connect to this masterGain node and inherit anything
     * that happens to it (such as muting).
     *
     * @todo Check naming collision
     * @method attach
     * @param sound {AudioPlayer} The player to attach to this manager
    ###
    attachPlayer: (player) ->
      @players[player.key] = player

      ###
      if(device.hasWebAudio) {
          for(var i = 0; i < player.nodes.length; i += 1) {
              player.nodes[i].disconnect();
              player.nodes[i].connect(this.masterGain);
          }
      }
      ###

    removePlayer: (key) ->
      player = @players[key]

      player.stop() if player?
      delete @players[key]

    mute: ->
      @setMuted yes

    unmute: ->
      @setMuted no

    setMuted: (m) ->
      @muted = m = !!m

      ###
        if(device.hasWebAudio) {
          this.masterGain.gain.value = m ? 0 : this.volume;
      ###

      # go through each audio element and mute/unmute them
      for key in @players
        player = @players[key]
        # loop through the audio nodes
        player.nodes[i].muted = m for i in player.nodes

  ###*
   * Returns the volume
   *
   * @property left
   * @type Number
   * @readOnly
  ###
  Object.defineProperty AudioManager.prototype, 'volume',
    get: ->
      @volume

    set: (volume) ->
      @volume = volume

      for key in @players
        player = @players[key]
        player.nodes[i].volume = volume for i in player.nodes

  return AudioManager