App.factory 'PushService', ($rootScope, $http, $location, notification, storage) ->
  $rootScope.pushMessages = []
  last_success_callback = null
  if Config.test_device_id? and !$rootScope.regId?
    $rootScope.regId = Config.test_device_id
  {
    getMessages: -> $rootScope.pushMessages
    getRegId: -> $rootScope.regId
    register: (success_callback)->
      successHandler = (r)-> true
      errorHandler = (r)->
        notification.info("Es gab einen Fehler beim registrieren, Suchen können daher im Moment nicht abonniert werden")
        # console.log 'ERROR HANDLER CALLED'
      last_success_callback = success_callback
      pushNotification = window.plugins.pushNotification
      if device.platform == "android" || device.platform == "Android"
        pushNotification.register(successHandler, errorHandler, {
          senderID: Config.gcm_api_key,
          ecb: "onNotificationGCM"
        })
    onNotification: (e)->
      window.last_event = e
      switch e.event
        when "registered"
          if e.regid.length > 0
            storage.bind($rootScope,'regId')
            if $rootScope.regId and $rootScope.regId != e.regId
              true
              # TODO
            $rootScope.regId = e.regid
            last_success_callback(e.regid)
        when "message"
          if e.foreground
            notification.info e.message
          else
            if e.coldstart
              search_id = e.payload.search_id
              $location.path("/searches/#{search_id}")
              notification.info e.message
            else
              search_id = e.payload.search_id
              window.location = "#/searches/#{search_id}"
              notification.info e.message
        else
          notification.info "Es gab einen Fehler beim verarbeiten der Nachricht"
          $rootScope.pushMessages.push "Event Unknown: #{e.event} - #{e.msg}"
  }
