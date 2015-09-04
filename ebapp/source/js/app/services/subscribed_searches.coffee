App.factory 'SubscribedSearches', (DeviceKey, PushApi, $rootScope, notification)->
  {
    getAll: (cb)->
      regid = DeviceKey.get()
      if regid?
        PushApi.allSearches (searches)->
          $rootScope.subscribedSearches = searches
          cb(searches) if cb?
        , (error)->
          notification.info("Fehler beim Abrufen der abonnierten Suchen")
          console.log 'error'
          console.log error
          console.log error.status
          console.log error.code
          console.log error.body
          false
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
