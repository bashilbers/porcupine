define ->
  lastOrientation: {}

  constructor: ->
    window.addEventListener 'deviceorientation', @onDeviceOrientation

  onDeviceOrientation: (event) =>
    @lastOrientation = event