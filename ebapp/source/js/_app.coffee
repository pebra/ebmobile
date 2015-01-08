window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation', 'angulartics', 'angulartics.google.analytics', 'angulartics.google.analytics.cordova', 'btford.phonegap.ready'])

App.config(
  ['$compileProvider', ($compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|file|mailto|tel|app|chrome-extension):/)
  ])

App.api = 'https://www.empfehlungsbund.de/api/v2/'
App.run  ($rootScope,  $location, trackingId, SubscribedSearches, PushService, phonegapReady) ->
  console.log "App.run called"
  $rootScope.cordova = true # TODO ???
  #$rootScope.cordova_type = 'android' # TODO ???

  document.addEventListener "deviceready", ->
    PushService.register( (regid)->
      SubscribedSearches.getAll()
      console.log "Push registered with #{regid}"
    )
  , false


App.constant('trackingId', 'UA-6810907-13')


window.onNotificationGCM = (e)->
  injector = angular.element(document.body).injector()
  console.log "Receiving GCM notification, dispatching to service, Payload:"
  console.log e
  injector.invoke  ["PushService", (PushService) ->
    PushService.onNotification(e)
  ]
