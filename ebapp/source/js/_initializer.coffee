console.log '======= STARTING APP ======'

App.run ($rootScope,  $location, SubscribedSearches, PushService, Analytics) ->
  document.addEventListener "deviceready", ->
    console.log 'device-ready'
    PushService.register( (regid)->
      console.log 'registered'
      SubscribedSearches.getAll()
    )
    Analytics.init()
  , false

  $rootScope.$on "$routeChangeStart", (event, next, current)->
    console.log "Tracking: #{$location.path()}"
    Analytics.trackView($location.path())

App.service 'Analytics', ->
  {
    init: ->
      if window.analytics
        window.analytics.startTrackerWithId('UA-6810907-16')
        window.analytics.trackView('Start')
    trackView: (view) ->
      if window.analytics
        window.analytics.trackView(view)
  }

window.onNotificationGCM = (e)->
  console.log 'onNotificationGCM'
  injector = angular.element('#main').injector()
  injector.invoke  ["PushService", (PushService) ->
    PushService.onNotification(e)
  ]


