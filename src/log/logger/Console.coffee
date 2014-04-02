define ->
  class ConsoleLogger
    warn: (message) ->
      console.warn message

    debug: (message) ->
      console.debug message

    error: (message) ->
      console.error message

    info: (message) ->
      console.info message

    log: (message) ->
      console.log message