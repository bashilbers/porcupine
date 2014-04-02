define (require) ->
  loggers = []
  Timer   = require 'porcupine/utils/Timer'
  _timer  = new Timer

  class Log
    addLogger: (logger) ->
      loggers.push logger

    _log: (type = 'log', message) ->
      logger[type].call null, message, _timer.now() for logger in loggers

    warn: (message) ->
      @_log Log.level.WARN, message

    debug: (message) ->
      @_log Log.level.DEBUG, message

    error: (message) ->
      @_log Log.level.ERROR, message

    info: (message) ->
      @_log Log.level.INFO, message

    log: (message) ->
      @_log Log.level.LOG, message

    @level:
      WARN: 'warn'
      DEBUG: 'debug'
      ERROR: 'error'
      INFO: 'info'
      LOG: 'log'