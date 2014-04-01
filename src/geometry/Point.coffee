define ->
  class Point
    constructor: (@x = 0, @y = 0) ->

    equals: (p) ->
      @x is p.x and @y is p.y

    clone: ->
      new Point @x, @y

    fromAngle: (angle) ->
      @x = Math.cos angle
      @y = Math.sin angle

    toAngle: ->
      angle = Math.atan2 @y, @x
      angle = angle < 0 ? (2 * Math.PI) + angle : angle

    dot: (p) ->
      @x * p.x + @y * p.y

    lengthSqr: ->
      @x * @x + @y * @y

    length: ->
      Math.sqrt @x * @x + @y * @y

    normalize: ->

    plus: (p) ->
      new Point @x + p.x, @y + p.y

    minus: (p) ->
      new Point @x - p.x, @y - p.y

    getDistance: (point) ->
      xs = point.x - @x
      xs = xs * xs

      ys = point.y - @y
      ys = ys * ys

      Math.sqrt xs + ys

    times: (p) ->

    dividedBy: (a) ->

    neg: ->

    add: (p) ->

    subtract: (p) ->

    multiply: (a) ->

    negate: ->

    floor: ->