App.service 'DeviceKey', ($rootScope, storage)->
  storage.bind($rootScope,'regId')
  if Config.test_device_id? and (!$rootScope.regId? or $rootScope.regId == "")
    $rootScope.regId = Config.test_device_id
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
          SubscribedSearches.getAll()
        )
      else
        console.log 'Key unchanged'
        console.log newKey
        DeviceKey.set(newKey)
        SubscribedSearches.getAll()
  }
