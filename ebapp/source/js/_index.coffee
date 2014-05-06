window.cordova_app =

  # Update DOM on a Received Event
  receivedEvent: (id) ->
    parentElement = document.getElementById(id)
    listeningElement = parentElement.querySelector(".listening")
    receivedElement = parentElement.querySelector(".received")
    listeningElement.setAttribute "style", "display:none;"
    receivedElement.setAttribute "style", "display:block;"
    console.log "Received Event: " + id


  # deviceready Event Handler
  #
  # The scope of 'this' is the event. In order to call the 'receivedEvent'
  # function, we must explicity call 'app.receivedEvent(...);'
  onDeviceReady: ->
    cordova_app.receivedEvent "deviceready"
    alert "YOLO DEVICE READY"
    fn = -> true
    window.plugins.gaPlugin.init(fn, fn,'UA-6810907-13', 10)

  # Bind Event Listeners
  #
  # Bind any events that are required on startup. Common events are:
  # 'load', 'deviceready', 'offline', and 'online'.
  bindEvents: ->
    document.addEventListener "deviceready", @onDeviceReady, false

  # Application Constructor
  initialize: ->
    @bindEvents()

if window.cordova
  cordova_app.initialize()


window.onDeviceReady = ->

document.addEventListener "deviceready", ->
  fn = -> true
  window.plugins.gaPlugin.init(fn, fn,'UA-6810907-13', 10)

, false

