define [
  'porcupine/utils/Signal'
], (Signal) ->
  class SoundLoader
    onLoaded: new Signal

    onError: new Signal

    load: (url) ->
      audio = new window.document.createElement 'audio'

      audio.addEventListener 'canplaythrough', ->
        @onLoaded null, audio

      audio.addEventListener 'error', @onError

      audio.preload = 'auto'
      audio.src = url