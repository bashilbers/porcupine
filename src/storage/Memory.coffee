define ->
  class Memory
    get: (key) ->
      @data[key]

    set: (key, value) ->
      @data[key] = value