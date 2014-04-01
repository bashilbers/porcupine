define ->
  class Rectangle

    constructor: (@x = 0, @y = 0, @width = 0, @height = 0) ->

    contains: (x, y) ->
      return no if @width <= 0 or @height <= 0

      if x >= @x and x <= (@x + @width)
        if y >= @y and y <= (@y + @height)
          true

    ###*
     * Checks if this rectangle overlaps another
     *
     * @method overlaps
     * @param rect {Rectangle} The rectangle to check if this overlaps
     * @return {Boolean} if the rectangle overlaps
    ###
    overlaps: (rect) ->
      @right > rect.x and @x < rect.right and @bottom > rect.y and @y < rect.bottom

  ###*
   * Returns the right most X coord
   *
   * @property right
   * @type Number
   * @readOnly
  ###
  Object.defineProperty Rectangle.prototype, 'right',
    get: ->
      @x + @width

  ###*
   * Returns the left most X coord
   *
   * @property left
   * @type Number
   * @readOnly
  ###
  Object.defineProperty Rectangle.prototype, 'left',
    get: ->
      @x

  ###*
   * Returns the top most Y coord
   *
   * @property top
   * @type Number
   * @readOnly
  ###
  Object.defineProperty Rectangle.prototype, 'top',
      get: ->
        @y
  
  ###*
   * Returns the bottom most Y coord
   *
   * @property bottom
   * @type Number
   * @readOnly
  ###
  Object.defineProperty Rectangle.prototype, 'bottom',
    get: ->
      @y + @height

  ###*
   * The perimeter of the rectangle
   *
   * @property perimeter
   * @type Number
   * @readOnly
  ###
  Object.defineProperty Rectangle.prototype, 'perimeter',
    get: ->
      2 * (@width + @height)

  ###*
   * The area of the rectangle
   *
   * @property area
   * @type Number
   * @readOnly
  ###
  Object.defineProperty Rectangle.prototype, 'area',
    get: ->
      @width * @height

  return Rectangle