
define ->
  class LocalStorage
    get: (key) ->
      window.localStorage.getItem key

    set: (key, value) ->
      window.localStorage.setItem key, value
    
    delete: (key) ->
      window.localStorage.removeItem key
    
    clear: ->
      window.localStorage.clear()
    
    @isSupported: ->
      window.localStorage?