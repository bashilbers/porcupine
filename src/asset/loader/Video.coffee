define [
  'porcupine/utils/Signal'
], (Signal) ->
  ###*
   *  VideoLoader constructor
  ###
  class VideoLoader
    onLoaded: new Signal

    onError: new Signal

    ###*
     * Loads given video Asset
     *
     * @param  {string}        url
    ###
    load: (url) ->
      video = window.document.createElement 'video'
      video.addEventListener 'canplaythrough', =>
        @onLoaded video

      audio.addEventListener 'error', @onError
      video.preload = 'auto'
      video.src = url