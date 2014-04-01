define [
  'porcupine/utils/Signal'
], (Signal) ->
  class ImageLoader
    onLoaded: new Signal

    onError: new Signal

    load: (url) ->
      image = new window.Image
      image.onload = =>
        @onLoaded null, image

      image.onerror = @onError

      image.src = url