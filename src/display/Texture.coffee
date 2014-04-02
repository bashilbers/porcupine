define [] ->
  class Texture
    frame: null

    baseTexture: null

    constructor: (@baseTexture, @frame) ->
      if frame.x + frame.width > baseTexture.width or frame.y + frame.height > baseTexture.height
        throw new Error 'Texture Error: frame does not fit inside the base Texture dimensions '