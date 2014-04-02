define ->
  _keyStates = {}
  _keyBindings = {}

  ###*
   * Keyboard input
  ###
  class Keyboard
    @states =
      'UP': 'UP'
      'DOWN': 'DOWN'

    ###*
     * Bindable keycodes
     *
     * @property KEY
     * @type Object
     * @static
    ###
    @key =
      'LEFT': 37
      'UP': 38
      'RIGHT': 39
      'DOWN': 40
      'ENTER': 13
      'TAB': 9
      'SHIFT': 16
      'CTRL': 17
      'ALT': 18
      'PAUSE': 19
      'SPACE': 32
      'BACKSPACE': 8
      'COMMA': 188
      'DELETE': 46
      'END': 35
      'ESCAPE': 27
      'HOME': 36
      'NUMPAD_ADD': 107
      'NUMPAD_DECIMAL': 110
      'NUMPAD_DIVIDE': 111
      'NUMPAD_ENTER': 108
      'NUMPAD_MULTIPLY': 106
      'NUMPAD_SUBTRACT': 109
      'PAGE_DOWN': 34
      'PAGE_UP': 33
      'PERIOD': 190
      'MINUS': 173
      'TILDE': 192
      'F1': 112
      'F2': 113
      'F3': 114
      'F4': 115
      'NUM0': 48
      'NUM1': 49
      'NUM2': 50
      'NUM3': 51
      'NUM4': 52
      'NUM5': 53
      'NUM6': 54
      'NUM7': 55
      'NUM8': 56
      'NUM9': 57
      'A': 65
      'B': 66
      'C': 67
      'D': 68
      'E': 69
      'F': 70
      'G': 71
      'H': 72
      'I': 73
      'J': 74
      'K': 75
      'L': 76
      'M': 77
      'N': 78
      'O': 79
      'P': 80
      'Q': 81
      'R': 82
      'S': 83
      'T': 84
      'U': 85
      'V': 86
      'W': 87
      'X': 88
      'Y': 89
      'Z': 90
      'win': 91

    ###*
     * The current sequence of keys that have been pressed
    ###
    sequence: []

    ###*
     * The amount of miliseconds it takes for the sequence to fade out
    ###
    sequenceTimeout = 500

    sequenceId = null

    constructor: (@container) ->
      window.addEventListener 'keydown', @onKeyDown
      window.addEventListener 'keyup', @onKeyUbind

    ###*
     * Called when a key is pressed down
     *
     * @method onKeyDown
     * @param event {DOMEvent}
     * @param code {Number} The keycode to use instead of checking event data
    ###
    onKeyDown: (e, code) =>
      keyCode = code or e.keyCode or e.which
      binding = @getBinding keyCode

      _keyStates[keyCode] = Keyboard.states.DOWN

      @sequence.push keyCode

      # send sequence event

      # set timeout to clear sequence
      clearTimeout @sequenceId if !!@sequenceId
      @sequenceId = setTimeout @clearSequence, @sequenceTimeout

      # dont bother with unhandled keys, NOOP
      return if not binding

      # action might be prevented by a locked key, NOOP
      return if !!binding.locked

      # check if we need to set locked state
      binding.locked = yes if !!binding.lockable

      binding.action.apply binding, e

  onKeyUp: (e, code) =>
    keyCode = code or e.keyCode or e.which
    binding = @getBinding keyCode

    _keyStates[keyCode] = Keyboard.states.UP

    # dont bother with unhandled keys, NOOP
    return if not binding

    binding.locked = no
    binding.action.apply binding, e

  isDown: (key) ->
    @getKeyState key is Keyboard.states.DOWN

  isUp: (key) ->
    @getKeyState key is Keyboard.states.UP

  getKeyState: (key) ->
    key = Keyboard.keys[key] if typeof key is 'string'
    _keyStates[key]

  ###*
   * Clears the current sequence so that a new one can start.
   *
   * @method clearSequence
  ###
  clearSequence: ->
    @sequence.length = 0

  getBinding: (keyCode) ->
    if not _keyBindings[keyCode]? then _keyBindings[keyCode] else null

  bind: (key, action, lockIt) ->
    _keyBindings[key] =
      locked: no
      lockable: !!lockIt
      action: action

  getCurrentKeyPressCode:  ->
    for code in _keyStates
      if _keyStates.hasOwnProperty code && _keyStates[code]?
        code

  unlock: (key) ->
    @getBinding(key).isCurrentlyLocking = no

  unbind: (key) ->
    delete bindings[key]