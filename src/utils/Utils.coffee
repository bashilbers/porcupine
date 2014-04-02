define ->
  utils =
    # no-operation function
    noop: ->

    getGUID: ->
      guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = c == 'x' ? r : (r & 0x3 | 0x8)
        v.toString(16)

    ajax: (settings) ->
      # default settings
      settings = settings or {}
      settings.method = settings.method or 'GET'
      settings.dataType = settings.dataType or 'text'

      if not settings.url
        throw message: 'Undefined URL passed to ajax'

      # callbacks
      settings.progress = settings.progress or utils.noop
      settings.load = settings.load or utils.noop
      settings.error = settings.error or utils.noop
      settings.abort = settings.abort or utils.noop
      settings.complete = settings.complete or utils.noop

      xhr = utils.createAjaxRequest()
      protocol = utils.getAbsoluteUrl(settings.url).split('/')[0]

      xhr.onreadystatechange = ->
        if xhr.readyState is 4
          res = xhr.response or xhr.responseText
          err = null

          # The 'file:' protocol doesn't give response codes
          if protocol isnt 'file:' and xhr.status isnt 200
            err = 'Non-200 status code returned: ' + xhr.status

          if not err and typeof res is 'string'
            if settings.dataType is 'json'
              try
                res = JSON.parse(res)
              catch e
                err = e
            else if settings.dataType is 'xml'
              try
                res = utils.parseXML res
              catch e
                err = e

          if err
            if settings.error then settings.error.call xhr, err
          else
            if settings.load then settings.load.call xhr, res

      # chrome doesn't support json responseType, some browsers choke on XML type
      if settings.dataType isnt 'json' and settings.dataType isnt 'xml'
        xhr.responseType = settings.dataType
      else
        xhr.responseType = 'text'

      xhr.open settings.method, settings.url, settings.async or true
      xhr.send()

    ###*
     * Wraps XMLHttpRequest in a cross-browser way.
     *
     * @method AjaxRequest
     * @return {XMLHttpRequest|ActiveXObject}
    ###
    createAjaxRequest: ->
      # activeX versions to check for in IE
      #activexmodes = ['Msxml2.XMLHTTP', 'Microsoft.XMLHTTP']

      # Test for support for ActiveXObject in IE first (as XMLHttpRequest in IE7 is broken)
      ###
      if window.ActiveXObject
        for(i = 0 i < activexmodes.length i++)
          try
            return new window.ActiveXObject activexmodes[i]
          catch e
            # suppress error
      ###

      return new window.XMLHTTP if window.XMLHttpRequest else false

    ###*
     * Converts a hex color number to an [R, G, B] array
     *
     * @method HEXtoRGB
     * @param hex {Number}
    ###
    HEXtoRGB: (hex) ->
      [(hex >> 16 & 0xFF) / 255, (hex >> 8 & 0xFF) / 255, (hex & 0xFF) / 255]

    ###*
     * Convert degrees to radians
     *
     * @param  {Number} degrees
     * @return {Number} A value in radians
    ###
    degreesToRadians: (degrees) ->
      degrees * (Math.PI / 180.0)

    ###*
     * Convert radians to degrees
     *
     * @param   {Number} radians
     * @return  {Number} A value in degrees
    ###
    radiansToDegrees: (radians) ->
      radians * (180.0 / Math.PI)

    ###*
     * Degrees a point is offset from a center point
     *
     * @param   {Object} center Object with an x and y value
     * @param   {Object} point Object with an x and y value
     * @return  {Number} A value in degrees
    ###
    degreesFromCenter: (center, pt) ->
      utils.radiansToDegrees utils.radiansFromCenter center, pt

    ###*
     * Radians a point is offset from a center point
     *
     * @param   {Object} center Object with an x and y value
     * @param   {Object} point Object with an x and y value
     * @return  {Number} A value in radians
    ###
    radiansFromCenter: (center, pt) ->
      # if null or zero is passed in for center, we'll use the origin
      center = center or x: 0.0, y: 0.0

      # same point
      if (center.x is pt.x) and (center.y is pt.y)
        return 0
      else if center.x is pt.x
        if center.y > pt.y
          return 0
        else
          return Math.PI
      else if center.y is pt.y
        if center.x > pt.x
          return 1.5 * Math.PI
        else
          return Math.PI / 2
      else if (center.x < pt.x) and (center.y > pt.y)
        # quadrant 1
        return Math.atan (pt.x - center.x) / (center.y - pt.y)
      else if (center.x < pt.x) and (center.y < pt.y)
        # quadrant 2
        return Math.PI / 2 + Math.atan (pt.y - center.y) / (pt.x - center.x)
      else if (center.x > pt.x) and (center.y < pt.y)
        #quadrant 3
        return Math.PI + Math.atan (center.x - pt.x) / (pt.y - center.y)
      else
        #quadrant 4
        return 1.5 * Math.PI + Math.atan (center.y - pt.y) / (center.x - pt.x)

    normalizePath: (baseDir, path) ->
      if baseDir
        joinedPath = [baseDir, path].join '/'

      joinedPath.replace /\/{2,}/g, '/'

    ###*
     * Gets the absolute url from a relative one
     *
     * @method getAbsoluteUrl
     * @param url {String} The relative url to translate into absolute
     * @return {String} The absolute url (fully qualified)
    ###
    getAbsoluteUrl: (url) ->
      a = document.createElement 'a'
      a.href = url

    ###*
     * Check if object has all the properties/methods which
     * are found in the given constructor
     *
     * @param  Object object
     * @param  Object constructor
     * @return Boolean
    ###
    inherits: (object, constructor) ->
      return yes if object instanceof constructor

      k = b = true
      po = object.constructor.prototype
      pc = constructor.prototype

      for prop of pc
        b = b && prop in po

      return !!k and b