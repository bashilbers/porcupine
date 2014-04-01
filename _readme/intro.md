This game engine is my personal playground regarding to game development. The main goal of this project is to provide
a simple, yet powerful API that enables me to create amazing html5 games easily and backed by a good, solid structure.

Key features:
 - Entity/Component/(sub)System game design
 - Some basic loaders provided:
     - image loader
     - sound loader
     - sprite loader
     - video loader     
 - Source split up in asynchronous modules (AMD)
 - Asset preloading
 - Simple device feature detection
 - EntityManager (manages the entities on the engine)
 - SystemManager (stores all of the systems, allowing them to be retrieved individually by type if necessary (for instance, the RenderSystem may need to communicate with the CameraSystem))
 - Infinite state machine
 - Naive geometry implementation
     - Points
     - Rectangles
 - Various handy utility classes/functions:
     - Timer.js (wrapper for window.performance)
     - EventEmitter.js (emits events)
     - Class.js (provides class inheritance)
     - Dictionary.js (ES6 Map shim)
     - LinkedList.js
     - Queue.js 
     - Log.js (composes loggers, i.e. ConsoleLogger.js which is just a wrapper for the window.console)
  - Browser polyfills
     - RequestAnimationFrame
     - Function.bind
  - Abstract storage (LocalStorage, inMemory etc)

 Planned:
 - Adchievements
 - Saves
 - Debugger
 - Audio sprites
 - Pphysics
 - Audio managing
 - WebGL rendering with canvas fallback
 - Mouse/touch/pen input handling with PointerEvents 
 - Gamepad support