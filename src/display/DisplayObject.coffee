define [
  'porcupine/utils/Class'
  'porcupine/geometry/Point'
  'porcupine/display/FilterBlock'
], (Class, Point, FilterBlock) ->
  class DisplayObject
    ###*
     * The coordinate of the object relative to the local coordinates of the parent.
     *
     * @property position
     * @type Point
    ###
    position: new Point

    ###*
     * The scale factor of the object.
     *
     * @property scale
     * @type Point
    ###
    scale: new Point 1, 1

    ###*
     * The pivot point of the displayObject that it rotates around
     *
     * @property pivot
     * @type Point
    ###
    pivot: new Point 0, 0

    ###*
     * The rotation of the object in radians.
     *
     * @property rotation
     * @type Number
    ###
    rotation: 0

    ###*
     * The opacity of the object.
     *
     * @property alpha
     * @type Number
    ###
    alpha: 1

    ###*
     * The visibility of the object.
     *
     * @property visible
     * @type Boolean
    ###
    visible: yes

    ###*
     * This is the defined area that will pick up mouse / touch events. It is null by default.
     * Setting it is a neat way of optimising the hitTest function that the interactionManager will use (as it will not need to hit test all the children)
     *
     * @property hitArea
     * @type Rectangle|Circle|Ellipse|Polygon
    ###
    hitArea: null

    ###*
     * This is used to indicate if the displayObject should display a mouse hand cursor on rollover
     *
     * @property buttonMode
     * @type Boolean
    ###
    buttonMode: no

    ###*
     * Can this object be rendered
     *
     * @property renderable
     * @type Boolean
    ###
    renderable: no

    ###*
     * [read-only] The display object container that contains this display object.
     *
     * @property parent
     * @type DisplayObjectContainer
     * @readOnly
    ###
    parent: null

    ###*
     * [read-only] The stage the display object is connected to, or undefined if it is not connected to the stage.
     *
     * @property stage
     * @type Stage
     * @readOnly
    ###
    stage: null

    ###*
     * [read-only] The multiplied alpha of the displayobject
     *
     * @property worldAlpha
     * @type Number
     * @readOnly
    ###
    worldAlpha: 1

    ###*
     * [read-only] Whether or not the object is interactive, do not toggle directly! use the `interactive` property
     *
     * @property _interactive
     * @type Boolean
     * @readOnly
     * @private
    ###
    _interactive: no

    ###*
     * [read-only] Current transform of the object based on world (parent) factors
     *
     * @property worldTransform
     * @type Mat3
     * @readOnly
     * @private
    ###
    #worldTransform: PIXI.mat3.create()//mat3.identity(),

    ###*
     * [read-only] Current transform of the object locally
     *
     * @property localTransform
     * @type Mat3
     * @readOnly
     * @private
    ###
    #localTransform: PIXI.mat3.create()//mat3.identity(),

    ###*
     * [NYI] Unkown
     *
     * @property color
     * @type Array<>
     * @private
    ###
    color: []

    ###*
     * [read-only] A mask is an object that limits the visibility of an object to the shape of the mask applied to it
     *
     * @property _mask
     * @type Object
     * @readOnly
     * @private
    ###
    _mask: null

    ###*
     * [NYI] Holds whether or not this object is dynamic, for rendering optimization
     *
     * @property dynamic
     * @type Boolean
     * @private
    ###
    dynamic: yes

    setInteractive: (@interactive = yes)

    ###*
     * Adds a filter to this displayObject
     *
     * @method addFilter
     * @param mask {Graphics} the graphics object to use as a filter
     * @private
    ###
    addFilter: (mask) ->
      return if @filter?
      @filter = yes
        
      # insert a filter block..
      start = new FilterBlock mask
      end = new FilterBlock mask
      start.first = start.last = @
      end.first = end.last = @
      start.open = yes
        
      childFirst = start
      childLast = start
      previousObject = @first._iPrev
        
      if(previousObject)
        nextObject = previousObject._iNext
        childFirst._iPrev = previousObject
        previousObject._iNext = childFirst
      else
        nextObject = @
        
        if(nextObject)
          nextObject._iPrev = childLast
          childLast._iNext = nextObject

        # now insert the end filter block..
        childFirst = end
        childLast = end
        nextObject = null
        previousObject = null
                
        previousObject = @last
        nextObject = previousObject._iNext

        if(nextObject)
          nextObject._iPrev = childLast
          childLast._iNext = nextObject

        childFirst._iPrev = previousObject
        previousObject._iNext = childFirst

        updateLast = @
        prevLast = @last
        
        while(updateLast)
          if(updateLast.last == prevLast)
            updateLast.last = end
          
          updateLast = updateLast.parent
        
        @first = start
        
        # if webGL...
        if(@__renderGroup)
          @__renderGroup.addFilterBlocks start, end
        
        mask.renderable = false

    ###*
     * Removes the filter to this displayObject
     *
     * @method removeFilter
     * @private
    ###
    removeFilter: ->
      return unless @filter
      @filter = yes
      
      # modify the list..
      startBlock = @first
      nextObject = startBlock._iNext
      previousObject = startBlock._iPrev
              
      if nextObject?
        nextObject._iPrev = previousObject

      if previousObject?
        previousObject._iNext = nextObject
      
      @first = startBlock._iNext
      
      # remove the end filter
      lastBlock = @last
      nextObject = lastBlock._iNext
      previousObject = lastBlock._iPrev

      if (nextObject)
        nextObject._iPrev = previousObject
      
      previousObject._iNext = nextObject
      
      # this is always true too!
      tempLast =  lastBlock._iPrev
      # need to make sure the parents last is updated too
      updateLast = @
      while(updateLast.last == lastBlock)
        updateLast.last = tempLast
        updateLast = updateLast.parent
        break unless updateLast
      
      mask = startBlock.mask
      mask.renderable = yes
      
      # if webGL...
      if @__renderGroup
        @__renderGroup.removeFilterBlocks startBlock, lastBlock
  
  ###*
   * Updates the object transform for rendering
   *
   * @method updateTransform
   * @private
  ###
  updateTransform: ->
    if(@rotation not @rotationCache)
      @rotationCache = @rotation
      @_sr =  Math.sin @rotation
      @_cr =  Math.cos @rotation
        
    localTransform = @ocalTransform
    parentTransform = @parent.worldTransform
    worldTransform = @worldTransform
    localTransform[0] = @_cr * @scale.x
    localTransform[1] = -@_sr * @scale.y
    localTransform[3] = @_sr * @scale.x
    localTransform[4] = @_cr * @scale.y

    px = @pivot.x
    py = @pivot.y
             
    # Cache the matrix values (makes for huge speed increases!)
    a00 = localTransform[0]
    a01 = localTransform[1]
    a02 = @position.x - localTransform[0] * px - py * localTransform[1]
    a10 = localTransform[3]
    a11 = localTransform[4]
    a12 = @position.y - localTransform[4] * py - px * localTransform[3]
    b00 = parentTransform[0]
    b01 = parentTransform[1]
    b02 = parentTransform[2]
    b10 = parentTransform[3]
    b11 = parentTransform[4]
    b12 = parentTransform[5]
  
    localTransform[2] = a02
    localTransform[5] = a12
          
    worldTransform[0] = b00 * a00 + b01 * a10
    worldTransform[1] = b00 * a01 + b01 * a11
    worldTransform[2] = b00 * a02 + b01 * a12 + b02

    worldTransform[3] = b10 * a00 + b11 * a10
    worldTransform[4] = b10 * a01 + b11 * a11
    worldTransform[5] = b10 * a02 + b11 * a12 + b12
  
    # because we are using affine transformation, we can optimise the matrix concatenation process.. wooo!
    # mat3.multiply(this.localTransform, this.parent.worldTransform, this.worldTransform)
    @worldAlpha = @alpha * @parent.worldAlpha
    @vcount = PIXI.visibleCount

  ###*
   * Indicates if the sprite will have touch and mouse interactivity. It is false by default
   *
   * @property interactive
   * @type Boolean
   * @default false
  ###
  Object.defineProperty DisplayObject.prototype, 'interactive',
    get: ->
      @_interactive
    set: (value) ->
      @_interactive = value
      @stage.dirty = yes if @stage?
  
  ###*
   * Sets a mask for the displayObject.
   * A mask is an object that limits the visibility of an object to the shape of the mask applied to it.
   * To remove a mask, set this property to null.
   *
   * @property mask
   * @type Graphics
  ###
  Object.defineProperty DisplayObject.prototype, 'mask',
    get: ->
      @_mask
    set: (value) ->
      @_mask = value
          
      if value? then @addFilter value else @removeFilter()
  
    
  return DisplayObject