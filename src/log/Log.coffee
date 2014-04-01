define (require) ->
  loggers = []
  Timer   = require 'porcupine/utils/Timer'
  _timer  = new Timer

  class Log
    addLogger: (logger) ->
      loggers.push logger
  
    log: (type, message) ->
      logger[type].call null, message, _timer.now() for logger in loggers
  
    warn: (message) ->
      @log Log.level.WARN, message
  
    debug: (message) ->
      @log Log.level.DEBUG, message
  
    error: (message) ->
      @log Log.level.ERROR, message
  
    info: (message) ->
      @log Log.level.INFO, message
  
    @level:
      WARN:'warn'
      DEBUG:'debug'
      ERROR:'error'
      INFO:'info'