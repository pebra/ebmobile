App.controller 'GcmCtrl', ['$scope','Device','PushService', '$http','PushApi','settings', ($scope,Device,PushService,$http,PushApi,settings) ->
  $scope.showSubscribeButton = Device.isAndroid()
  settings.bind($scope)

  $scope.register = ->
    PushService.register( (regId)->
      console.log "STARTING API PUSH"
      $scope.test() # TODO
    )
  $scope.test = ->
    default_params = $scope.default_params()
    extra_params = $scope.$parent.query_params
    params = {}
    angular.extend(params, default_params, extra_params)

    PushApi.addDeviceKey {key: PushService.getRegId()}, (response)->
      console.log "Device key angelegt"
      PushApi.addSearch { search: params }, (response) ->
        console.log "Suche angelegt"


  $scope.unregister = ->
    true
]

App.factory "Device", ($rootScope)->
  {
    isAndroid:  ->
      device? and ( device.platform == "android" || device.platform == "Android")
  }



window.onNotificationGCM = (e)->
  injector = angular.element(document.body).injector()
  console.log "Receiving GCM notification, dispatching to service"
  injector.invoke  ["PushService", (PushService) ->
    PushService.onNotification(e)
  ]


App.factory 'PushService', ($rootScope, $http) ->
  $rootScope.pushMessages = []
  $rootScope.regId = 'APA91bFiDLIUcWdEB7nZiNuCI7cryD1b-l1_UbnhIVF93ls4wFhJXjv8m4pDKZ1WDmpZnaNhzqBz9OVd2OmmTvlmWsHfDx2odulnqxfrT1AtxOJr1ojZAaZAIL3zbyebiPvKPaPfr12mxrEiVijH8rIveRleYH5NyhYQZR2T9s3eBY7iwL1Grq4'
  # TODO
  last_success_callback = null

  {
    getMessages: -> $rootScope.pushMessages
    getRegId: -> $rootScope.regId

    register: (success_callback)->
      successHandler = (r)->
        console.log 'SUCCESS HANDLER CALLED'
        console.log r
      errorHandler = (r)->
        console.log 'ERROR HANDLER CALLED'
        console.log r
      last_success_callback = success_callback
      # $("#app-status-ul").append("<li>deviceready event received</li>");
      pushNotification = window.plugins.pushNotification
      if device.platform == "android" || device.platform == "Android"
        pushNotification.register(successHandler, errorHandler, {
          senderID: App.gcm_api_key,
          ecb: "onNotificationGCM"
        })

    onNotification: (e)->
      $rootScope.pushMessages.push "EVENT -> RECEIVED: #{e.event}"
      switch e.event
        when "registered"
          if e.regid.length > 0
            $rootScope.pushMessages.push "REGISTERED -> REGID: #{e.regid}"
            $rootScope.regId = e.regid
            last_success_callback(e.regid)
        else
          $rootScope.pushMessages.push "Event Unknown: #{e.event} - #{e.msg}"
  }
