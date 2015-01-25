console.log '======= STARTING APP ======'

App.run ($rootScope,  $location, trackingId, SubscribedSearches, PushService) ->
  document.addEventListener "deviceready", ->
    console.log 'device-ready'
    PushService.register( (regid)->
      console.log 'registered'
      SubscribedSearches.getAll()
    )
  , false


App.constant('trackingId', 'UA-6810907-13')

window.onNotificationGCM = (e)->
  console.log 'onNotificationGCM'
  injector = angular.element('#main').injector()
  injector.invoke  ["PushService", (PushService) ->
    PushService.onNotification(e)
  ]
