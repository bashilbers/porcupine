define (require) ->
  audioTypes =
    ogg:  'audio/ogg codecs="vorbis"'
    opus: 'audio/ogg codecs="opus"'
    mp3:  'audio/mpeg'
    m4a:  'audio/x-m4a'
    mp4:  'audio/mp4 codecs="mp4a.40.5"'
    wav:  'audio/wav codecs="1"'
    webm: 'audio/webm codecs="vorbis"'
  
  videoTypes =
    ogg:  'video/ogg codecs="theora, vorbis"'
    mp4:  'video/mp4 codecs="avc1.4D401E, mp4a.40.2"'
    webm: 'video/webm codecs="vp8.0, vorbis"'

  ###*
   * Holds the results of the feature detection run on
   * the browser, to make it simple to see which features
   * the library can use.
   *
   * @class Device
   * @extends Object
   ###
  class Device
    ###*
     * Whether or not memory profiling is supported
     *
     * @property hasMemoryProfiling
     * @type Boolean
    ###
    hasMemoryProfiling: !!window.performance.memory

    ###*
     * Whether or not the crypto API is supported
     *
     * @property hasCrypto
     * @type Boolean
    ###
    hasCrypto: !!window.crypto and !!window.crypto.getRandomValues
    
    ###*
     * Whether or not web workers are supported
     *
     * @property hasWorkers
     * @type Boolean
    ###
    hasWorkers: !!window.Worker
    
    ###*
     * Whether or not Blob URLs are supported
     *
     * @property hasBlobUrls
     * @type Boolean
    ####
    hasBlobUrls: !!window.Blob and !!window.URL and !!window.URL.createObjectURL
    
    ###*
     * Whether or not typed arrays are supported
     *
     * @property hasTypedArrays
     * @type Boolean
    ####
    hasTypedArrays: !!window.ArrayBuffer
    
    ###*
     * Whether or not the filesystem API is supported
     *
     * @property hasFileApi
     * @type Boolean
    ####
    hasFileApi: !!window.File and
      !!window.FileReader and
      !!window.FileList and
      !!window.Blob

    ###*
     * Whether or not the Web Audio API is supported
     *
     * @property hasWebAudio
     * @type Boolean
    ####
    hasWebAudio: !!window.AudioContext or
      !!window.webkitAudioContext or
      !!window.mozAudioContext

    ###*
     * Whether html Audio is supported in this browser
     *
     * @property hasHtmlAudio
     * @type Boolean
    ####
    hasHtmlAudio: !!document.createElement('audio').canPlayType and
      !!window.Audio

    ###*
     * Whether or not touch is supported
     *
     * @property hasGestures
     * @type Boolean
    ####
    hasGestures: ('createTouch' in window.document) or
      ('ontouchstart' in window) or
      window.navigator.isCocoonJS or
      (window.navigator.maxTouchPoints > 0)
    
    ###*
     * Whether or not the gamepad API is supported
     *
     * @property hasGamepadApi
     * @type Boolean
    ####
    hasGamepadApi: !!navigator.webkitGetGamepads or
      !!navigator.webkitGamepads or
      (navigator.userAgent.indexOf 'Firefox/' isnt -1)
    
    ###*
     * The current user agent string
     *
     * @property userAgent
     * @type String
    ####
    userAgent: if window.navigator then window.navigator.userAgent else 'nodejs'
            
    ###*
     * Whether or not the visitor is viewing from a mobile device
     *
     * @property isMobile
     * @type Boolean
    ####
    isMobile: @userAgent.match /Android|iPhone|iPad|iPod|BlackBerry|Windows Phone|Mobi/i

    ###*
     * Whether or not canvas is supported
     *
     * @property hasCanvas
     * @type Boolean
    ####
    hasCanvas: do ->
      try
        !!window.CanvasRenderingContext2D and
        !!document.createElement('canvas').getContext '2d'
      catch
        false

    ###*
     * Whether or not webgl is supported
     *
     * @property hasWebgl
     * @type Boolean
    ####
    hasWebgl: do ->
      try
        c = document.createElement 'canvas'
        !!window.WebGLRenderingContext and
          c.getContext 'webgl' or
          c.getContext 'experimental-webgl'
      catch
        false

    ###*
     * Whether or not accelerometer is supported
     *
     * @property hasAccelerometer
     * @type Boolean
    ####
    hasAccelerometer: (typeof (window.DeviceMotionEvent) isnt 'undefined') or
      ((typeof (window.Windows) isnt 'undefined') and
        (typeof (window.Windows.Devices.Sensors.Accelerometer) is 'function'))
    
    ###*
     * Whether or not orientation is supported
     *
     * @property hasDeviceOrientation
     * @type Boolean
    ####
    hasDeviceOrientation: if window.DeviceOrientationEvent then true else false

    ###*
     * Whether or not local storage is supported
     *
     * @property hasLocalStorage
     * @type Boolean
    ####
    hasLocalStorage: !!window.localStorage
    
    pixelRatio: window.devicePixelRatio or 1
    isIphone: navigator.userAgent.toLowerCase().indexOf 'iphone' != -1
    isIpod: navigator.userAgent.toLowerCase().indexOf 'ipod' != -1
    isIphone4: @pixelRatio is 2 and @isiPhone
    isIpad: navigator.userAgent.toLowerCase().indexOf 'ipad' != -1
    isAndroid: navigator.userAgent.toLowerCase().indexOf 'android' != -1
    isFirefox: navigator.userAgent.toLowerCase().indexOf 'firefox' != -1
    isChrome: navigator.userAgent.toLowerCase().indexOf 'chrome' != -1
    isOpera: navigator.userAgent.toLowerCase().indexOf 'opera' != -1
    isTouch: window.ontouchstart isnt 'undefined'
    isiOS: @isiPhone or @isiPod
    isIE: false

    constructor: ->
      if /MSIE (\d+\.\d+)/.test navigator.userAgent
        @ieVersion = new Number RegExp.$1
        @isIE = true

    getUsedHeap: ->
      if @hasMemoryProfiling
        window.performance.memory.usedJSHeapSize
      else 0
  
    getTotalHeap: ->
      if @hasMemoryProfiling
        window.performance.memory.totalJSHeapSize
      else 0

    audio: do ->
      audioTest = new Audio()

      supports: (format) ->
        !!audioTest.canPlayType(audioTypes.format).replace /^no$/, ''

    video: do ->
      videoTest = document.createElement 'video'
      
      supports: (format) ->
        !!videoTest.canPlayType(videoTypes.format).replace /^no$/, ''
  
    getPreferredRenderingType: ->
      useWebgl = if @hasWebgl
        navigator.userAgent.toLowerCase().indexOf 'msie' isnt -1
      else false

      if useWebgl then 'webgl' else 'canvas'

    # todo
    getPreferredAudioFormat: ->

    # todo
    getPreferredVideoFormat: ->

  # single instance..
  new Device