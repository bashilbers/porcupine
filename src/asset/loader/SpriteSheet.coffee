define [
  'require'
  'porcupine/utils/Signal'
  'porcupine/asset/loader/Image'
  'porcupine/geometry/Rectangle'
  'porcupine/display/Texture'
], (require, Signal, ImageLoader, Rectangle, Texture) ->
  class SpriteSheet
    textureCacheStore: null

    onLoaded: new Signal

    onError: new Signal

    constructor: (@textureCacheStore) ->

    load: (url) ->
      require ['json!' + url], (data) ->

        textureUrl = data.meta.image

        imageLoader = new ImageLoader

        imageLoader.onLoaded (image) =>
          @textureCacheStore.add new Texture(image, new Rectangle(
            frame.x, frame.y,frame.width, frame.height
          )) for frame in data.frames

          @onLoaded null, data: data, store: @textureCacheStore

        imageLoader.load textureUrl