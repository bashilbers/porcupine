define [
  'porcupine/utils/Queue'
  'porcupine/utils/Signal'
  'porcupine/utils/Device'
  'porcupine/storage/LocalStorage'
  'porcupine/storage/Memory'
], (Queue, Signal, device, LocalStorage, InMemoryStorage) ->
  class AssetLoader
    loaders: {}
    queue: new Queue
    onProgress: new Signal
    onComplete: new Signal
    cache: null

    constructor: (urls) ->
      @add(urls) if urls?
      @cache = if device.hasLocalStorage then new LocalStorage else new InMemoryStorage

    add: (urls...) ->
      @queue.enqueue(url) for url in urls

    addLoader: (loader, extensions...) ->
      @loaders[ext] = loader for ext in extensions

    getLoader: (url) ->
      extension = url.split('.').pop().toLowerCase()
      @loaders[extension]

    load: (url) ->
      while !@queue.isEmpty()
        url = @queue.dequeue()
        loader = @getLoader url
        loader.onLoaded (asset) =>
          @cache.set url, asset

          if @queue.getLength is 0
            @onComplete.emit @
          else
            @onProgress.emit @, { url: url, asset: asset }

        loader.load url