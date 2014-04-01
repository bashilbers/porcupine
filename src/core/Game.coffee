define (require) ->
  # essential polyfills for any porcupine game
  require 'porcupine/utils/polyfills/RequestAnimationFrame'
  require 'porcupine/utils/polyfills/CancelAnimationFrame'
  require 'porcupine/utils/polyfills/Function.bind'
  require 'porcupine/utils/polyfills/Map'

  constants        = require 'porcupine/Constants'
  Engine           = require 'porcupine/core/Engine'
  CanvasRenderer   = require 'porcupine/renderer/Canvas'
  device           = require 'porcupine/utils/device'
  RAFTickProvider  = require 'porcupine/tick/RAFTickProvider'
  Keyboard         = require 'porcupine/input/Keyboard'
  AssetLoader      = require 'porcupine/asset/AssetLoader'
  Log              = require 'porcupine/log/Log'
  ConsoleLogger    = require 'porcupine/log/Console'

  class Game
    constructor: (container, settings) ->
      # setup default settings
      settings ?= {}
      settings.width ?= 800
      settings.height ?= 600
      settings.renderer ?= constants.AUTO_DETECT_RENDERER

      # settings object is persisted
      @settings = settings

      # the engine which is holding ECS systems and allows for game start / stop
      @engine = settings.engine || new Engine settings

      # the canvas we are drawing on
      # passing null to renderer will let the renderer make one
      @canvas = settings.canvas || null

      # The domElement that we are injecting the view into (the container)
      @container = document.getElementById container if typeof container is 'string' else document.body

      # initialize the input source
      @keyboard = new Keyboard @container

      # concrete renderer class
      @renderer = @getRenderer()

      if settings.loader?
        @loader = settings.loader
      else
        @loader = new AssetLoader
        @loader.addLoader new ImageLoader, 'png', 'jpg', 'jpeg', 'gif'
        @loader.addLoader new SoundLoader, 'mp3', 'ogg', 'wav'

      if settings.logger?
        @logger = settings.logger
      else
        @log = new Log
        @log.addLogger new ConsoleLogger

    getRenderer: ->
      return @renderer if @renderer

      if @settings.renderer is constants.AUTO_DETECT_RENDERER
        switch device.getPreferredRenderingType()
          when 'canvas' then @renderer = new CanvasRenderer
          else throw new Error 'Unable to select renderer'
      else
        @renderer = @settings.renderer

      # append the renderer view only if the user didn't pass their own
      if !@canvas
        @container.appendChild renderer.view
        @canvas = renderer.view

      return @renderer