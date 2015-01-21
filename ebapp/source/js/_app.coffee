window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation'])

App.config ($compileProvider) ->
  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|file|mailto|tel|app|chrome-extension):/)

App.run ($rootScope,  $location, trackingId, SubscribedSearches, PushService) ->
  document.addEventListener "deviceready", ->
    console.log 'device-ready'
    PushService.register( (regid)->
      console.log 'registered'
      SubscribedSearches.getAll()
    )
  , false
  if Config.test_device_id?
    SubscribedSearches.getAll()



App.constant('trackingId', 'UA-6810907-13')


window.onNotificationGCM = (e)->
  console.log 'onNotificationGCM'
  injector = angular.element(document.body).injector()
  injector.invoke  ["PushService", (PushService) ->
    PushService.onNotification(e)
  ]
