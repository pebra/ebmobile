App.controller 'GcmCtrl', ['$scope','Device','PushService', '$http','PushApi','SubscribedSearches', '$rootScope', 'settings', ($scope,Device,PushService,$http,PushApi,SubscribedSearches, $rootScope, settings) ->

  regId = PushService.getRegId()
  # TODO regId leer -> Fehler?

  $scope.showSubscribeButton = ->
    Device.isAndroid() && $scope.query_params? && SubscribedSearches.is_subscribed($scope.query) && regId?

  settings.bind($scope)

  $scope.register = ->
    default_params = $scope.default_params()
    extra_params = $scope.$parent.query_params
    params = {}
    angular.extend(params, default_params, extra_params)
    PushApi.addDeviceKey {key: regId}, (response)->
      console.log "Device key angelegt"
      PushApi.addSearch { search: params }, (response) ->
        console.log "Suche angelegt"
        SubscribedSearches.getAll()

]

App.factory "Device", ($rootScope)->
  {
    isAndroid:  ->
      device? and ( device.platform == "android" || device.platform == "Android")
  }


# Managed alle abonnierten Suchen
App.factory 'SubscribedSearches', (PushService,PushApi, $rootScope)->
  {
    getAll: (cb)->
      regid = PushService.getRegId()
      if regid?
        PushApi.allSearches (searches)->
          $rootScope.subscribedSearches = searches
          cb(searches) if cb?

    unsubscribe: (search, cb)->
      that = this
      PushApi.unsubscribeSearch { id: search.id}, (result)->
        that.getAll(cb)
    is_subscribed: (search, cb)->
     index = 0
     if $rootScope.subscribedSearches
       while index < $rootScope.subscribedSearches.length
         return false if $rootScope.subscribedSearches[index].params.q is search
         index++
       true
     else
       true
  }



# Managed Key Austausch mit Android GCM
App.factory 'PushService', ($rootScope, $http, $location) ->
  $rootScope.pushMessages = []
  last_success_callback = null

  {
    getMessages: -> $rootScope.pushMessages
    getRegId: -> $rootScope.regId

    register: (success_callback)->
      successHandler = (r)-> true
      errorHandler = (r)->
        # TODO notification
        console.log 'ERROR HANDLER CALLED'
        console.log r

      last_success_callback = success_callback
      pushNotification = window.plugins.pushNotification
      if device.platform == "android" || device.platform == "Android"
        pushNotification.register(successHandler, errorHandler, {
          senderID: App.gcm_api_key,
          ecb: "onNotificationGCM"
        })

    onNotification: (e)->
      window.last_event = e
      switch e.event
        when "registered"
          if e.regid.length > 0
            $rootScope.regId = e.regid
            last_success_callback(e.regid)
        when "message"
          search_id = e.payload.search_id
          $location.path('/searches/show').search('id', search_id)

        else
          # TODO? Notification?
          $rootScope.pushMessages.push "Event Unknown: #{e.event} - #{e.msg}"
  }
