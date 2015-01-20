App.factory "PushApi", ["$resource", "PushService", ($resource, PushService) ->
  api = $resource Config.eb_push_url, null,
    addDeviceKey:
      method: 'POST'
      url: Config.eb_push_url + '/devices.json'
      params:
        api_key: Config.eb_push_key
    allSearches:
      method: 'GET'
      url: Config.eb_push_url + '/searches.json'
      isArray: true
      params:
        api_key: Config.eb_push_key
        key: -> PushService.getRegId()
    addSearch:
      method: 'POST'
      url: Config.eb_push_url + '/searches.json'
      params:
        api_key: Config.eb_push_key
        key: ->  PushService.getRegId()
    unsubscribeSearch:
      method: 'DELETE'
      url: Config.eb_push_url + '/searches/:id.json'
      params:
        api_key: Config.eb_push_key
        key: -> PushService.getRegId()

  api.findSearch = (searchId, callback,error)->
    api.allSearches (searches)->
      for search in searches
        if search.id == searchId
          if search.last_last_push
            search.params.since = search.last_last_push
          else
            search.params.since = search.last_push
          search.params.since = search.params.since.split('T')[0]
          callback(search)
    , error
  api

]
