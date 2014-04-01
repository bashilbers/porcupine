define [
  'porcupine/display/DisplayObjectContainer'
  'porcupine/geometry/Rectangle'
  'porcupine/utils/Utils'
], (DisplayObjectContainer, Rectangle, utils) ->
  class Stage extends DisplayObjectContainer
    constructor: (backgroundColor, interactive) ->
      @interactive = interactive
      @setBackgroundColor backgroundColor

      #the stage is it's own stage
      stage = @

      #optimize hit detection a bit
      stage.hitArea = new Rectangle 0, 0, 100000, 100000

    ###*
     * [read-only] Current transform of the object based on world (parent) factors
     *
     * @property worldTransform
     * @type Mat3
     * @readOnly
     * @private
    ###
    worldTransform:
      scale:
        horizontal: 1
        vertical: 1
      skew:
        horizontal: 0
        vertical: 0
      move:
        horizontal: 0
        vertical: 0

    ###*
     * Whether or not the stage is interactive
     *
     * @property interactive
     * @type Boolean
    ###
    interactive: no

    ###*
     * The interaction manager for this stage, manages all interactive activity on the stage
     *
     * @property interactive
     * @type InteractionManager
    ###
    interactionManager: null

    ###*
     * Whether the stage is dirty and needs to have interactions updated
     *
     * @property dirty
     * @type Boolean
     * @private
    ###
    dirty: yes

    __childrenAdded: []
    __childrenRemoved: []
    worldVisible: yes
    stage: null

  setBackgroundColor: (backgroundColor) ->
    @backgroundColor = backgroundColor or 0x000000
    @backgroundColorSplit = utils.HEXtoRGB @backgroundColor

    hex = @backgroundColor.toString 16
    hex = "000000".substr(0, 6 - hex.length) + hex
    @backgroundColorString = "#" + hex