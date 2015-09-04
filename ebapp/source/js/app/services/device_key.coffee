App.service 'DeviceKey', ($rootScope, storage)->
  storage.bind($rootScope,'regId')
  noRegId = (!$rootScope.regId? or $rootScope.regId == "")
  if !noRegId
    console.log "Reg-ID bereits im Local-Storage vorhanden"
    console.log $rootScope.regId

  if Config.test_device_id? #and (Config.force_device_key or noRegId)
    console.log 'Setting deviceID to TestID'
    $rootScope.regId = Config.test_device_id
    console.log $rootScope.regId

  {
    set: (key)-> $rootScope.regId = key
    get: ->
      if $rootScope.regId? and $rootScope.regId != ""
        $rootScope.regId
  }

App.service 'DeviceKeyManager', (DeviceKey,PushApi,SubscribedSearches,notification)->
  {
    getKey: -> DeviceKey.get()
    updateKey: (newKey)->
      oldKey = DeviceKey.get()
      if oldKey? and oldKey != newKey
        console.log 'Key changed'
        console.log newKey
        console.log 'updating key'
        PushApi.updateKey({old_key: oldKey, new_key: newKey}, ->
          notification.info("Abonnierte Suchen werden wiederhergestellt")
          console.log 'update finished'
          DeviceKey.set(newKey)
          console.log "Neuer key: #{newKey}"
          console.log DeviceKey.get()
          SubscribedSearches.getAll()
        , (error)->
          if error.status == 404
            console.log "Ignorable Error"
            console.log "Neuer key: #{newKey}"
            DeviceKey.set(newKey)
            SubscribedSearches.getAll()
          else
            console.log '[DeviceKeyManager] Fehler beim benachrichten der API'
            console.log error.code
            console.log error.status
        )
      else
        console.log 'Key unchanged'
        DeviceKey.set(newKey)
  }
