define ->
  class LinkedNode
    constructor: (opt) ->
      @opt = opt or {}
      @obj = opt.obj or null
      @nextLinked = opt.next or null
      @prevLinked = opt.prev or null

    next: ->
      @nextLinked

    object: ->
      @obj

    prev: ->
      @prevLinked