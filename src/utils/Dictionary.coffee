define ->
  map: {}

  class Dictionary
    getAll: ->
      map

    get: (key) ->
      return map if not key or key is null

      value = map[key]

      return null if not value?

      value

    set: (key, value) ->
      map[key] = value

    remove: (key) ->
      delete map[key]

    has: (key) ->
      Boolean map[key] not undefined

    clear: ->
      map = {}

    keys: ->
      Object.keys map

    each: (cb) ->
      cb(key, value) for key, value in map