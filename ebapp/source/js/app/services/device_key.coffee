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

App.service 'DeviceKeyManager', (DeviceKey,PushApi)->
  {
    getKey: -> DeviceKey.get()
    updateKey: (newKey)->
      oldKey = DeviceKey.get()
      if oldKey? and oldKey != newKey
        alert 'KEY UPDATE'
        console.log 'KEY UPDATE'
        # TODO update
      DeviceKey.set(newKey)
  }
