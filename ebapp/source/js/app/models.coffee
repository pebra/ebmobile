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
  $resource App.eb_push_url, null,
    addDeviceKey:
      method: 'JSONP'
      url: App.eb_push_url + '/devices/create.jsonp'
      params:
        callback: 'JSON_CALLBACK'
        api_key: App.eb_push_key
    allSearches:
      method: 'JSONP'
      url: App.eb_push_url + '/searches/index.jsonp'
      isArray: true
      params:
        callback: 'JSON_CALLBACK'
        api_key: App.eb_push_key
        key: PushService.getRegId()
    addSearch:
      method: 'JSONP'
      url: App.eb_push_url + '/searches/create.jsonp'
      params:
        callback: 'JSON_CALLBACK'
        api_key: App.eb_push_key
        key: PushService.getRegId()
    unsubscribeSearch:
      method: 'JSONP'
      url: App.eb_push_url + '/searches/delete.jsonp'
      params:
        callback: 'JSON_CALLBACK'
        api_key: App.eb_push_key
        key: PushService.getRegId()
      

]
