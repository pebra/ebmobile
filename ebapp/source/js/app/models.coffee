App.factory 'Job', ['$resource', ($resource) ->
  $resource App.api + 'jobs/:id.jsonp', null,
    get:
      method: 'JSONP'
      params:
        callback: 'JSON_CALLBACK'
    search:
      method: 'JSONP'
      params:
        id: 'search'
        callback: 'JSON_CALLBACK'
    newest:
      method: 'JSONP'
      url: App.api + 'jobs/lists/newest.jsonp'
      params:
        callback: 'JSON_CALLBACK'
    insider:
      method: 'JSONP'
      url: App.api + 'jobs/lists/insider.jsonp'
      params:
        callback: 'JSON_CALLBACK'
]


App.factory 'Company', ['$resource' , ($resource) ->
  $resource App.api + 'companies/:id.jsonp', null,
    get:
      method: 'JSONP'
      params:
        callback: 'JSON_CALLBACK'
        api_key: App.eb_api_key
]

App.factory 'Community', ['$resource', ($resource)->
  $resource App.api + 'domains.jsonp', null,
    getAll:
      method: 'JSONP'
      isArray: true
      params:
        callback: 'JSON_CALLBACK'
]

App.factory "PushApi", ["$resource", "PushService", ($resource, PushService) ->
  api = $resource App.eb_push_url, null,
    addDeviceKey:
      method: 'POST'
      url: App.eb_push_url + '/devices.json'
      params:
        api_key: App.eb_push_key
    allSearches:
      method: 'GET'
      url: App.eb_push_url + '/searches.json'
      isArray: true
      params:
        api_key: App.eb_push_key
        key: -> PushService.getRegId()
    addSearch:
      method: 'POST'
      url: App.eb_push_url + '/searches.json'
      params:
        api_key: App.eb_push_key
        key: ->  PushService.getRegId()
    unsubscribeSearch:
      method: 'DELETE'
      url: App.eb_push_url + '/searches/:id.json'
      params:
        api_key: App.eb_push_key
        key: -> PushService.getRegId()

  api.findSearch = (searchId, callback)->
    api.allSearches (searches)->
      for search in searches
        if search.id == searchId
          if search.last_last_push
            search.params.since = search.last_last_push
          else
            search.params.since = search.last_push
          search.params.since = search.params.since.split('T')[0]
          callback(search)
  api

]
