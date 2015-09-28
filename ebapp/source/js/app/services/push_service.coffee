App.factory 'PushService', ($rootScope, $http, $location, notification, DeviceKeyManager) ->
  $rootScope.pushMessages = []
  last_success_callback = null
  {
    getMessages: -> $rootScope.pushMessages
    getRegId: -> $rootScope.regId
    register: (success_callback)->
      successHandler = (r)->
        true
      errorHandler = (r)->
        console.log 'ERROR beim PUSH'
        console.log r
        notification.info("Es gab einen Fehler beim registrieren, Suchen können daher im Moment nicht abonniert werden")
      last_success_callback = success_callback
      pushNotification = window.plugins.pushNotification
      if device.platform == "android" || device.platform == "Android"
        console.log 'GCM: Register now'
        pushNotification.register(successHandler, errorHandler, {
          senderID: Config.gcm_api_key,
          ecb: "onNotificationGCM"
        })
    onNotification: (e)->
      console.log "GCM event: #{e.event}"
      window.last_event = e
      switch e.event
        when "registered"
          if e.regid.length > 0
            DeviceKeyManager.updateKey(e.regid)
            last_success_callback(e.regid)
        when "message"
          if e.foreground
            notification.info e.message
          else
            if e.coldstart
              $location.path("/")
              notification.info e.message
            else
              window.location = "#/"
              notification.info e.message
        else
          notification.info "Es gab einen Fehler beim verarbeiten der Nachricht"
          $rootScope.pushMessages.push "Event Unknown: #{e.event} - #{e.msg}"
  }
