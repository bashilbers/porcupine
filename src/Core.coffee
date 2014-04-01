# this bag holds the Porcupine namespace
define (require) ->
  # basic stuff
  Engine: require './core/Engine'
  Game: require './core/Game'

  # entity-component-system
  ComponentManager: require './ecs/ComponentManager'
  Entity: require './ecs/Entity'
  EntityManager: require './ecs/EntityManager'
  SystemManager: require './ecs/SystemManager'

  # audio
  AudioManager: require './audio/AudioManager'
  AudioPlayer: require './audio/Player'

  # input
  InputManager: require './input/InputManager'
  Input:
    Keyboard: require './input/Keyboard'
    Pointer: ''
    Gamepad: ''

  # assets
  Loader: require './asset/AssetLoader'
  AssetLoader:
    Image: require './asset/loader/Image'

  # infite state machine
  EntityState: require './fsm/EntityState'
  EntityStateMachine: require './fsm/EntityStateMachine'

  # geometry
  Geometry:
    Point: require './geometry/Point'
    Rectangle: require './geometry/Rectangle'
    Circle: ''
    Ellipse: ''
    Polygon: ''

  # rendering
  Renderer:
    Canvas: require './renderer/Canvas'

  # Helpers/utilities
  Log: require './log/Log'
  Logger:
    Console: require './log/logger/Console'
  Constants: require './Constants'
  LinkedList: require './utils/LinkedList'