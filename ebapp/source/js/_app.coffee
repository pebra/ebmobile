window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation', 'angulartics', 'angulartics.google.analytics', 'angulartics.google.analytics.cordova'])

App.config(
  ['$compileProvider', ($compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|file|mailto|tel|app|chrome-extension):/)
  ])

App.run  ($rootScope,  $location, trackingId, SubscribedSearches, PushService) ->
  document.addEventListener "deviceready", ->
    PushService.register( (regid)->
      SubscribedSearches.getAll()
    )
  , false
  if Config.test_device_id?
    SubscribedSearches.getAll()



App.constant('trackingId', 'UA-6810907-13')


window.onNotificationGCM = (e)->
  injector = angular.element(document.body).injector()
  injector.invoke  ["PushService", (PushService) ->
    PushService.onNotification(e)
  ]
