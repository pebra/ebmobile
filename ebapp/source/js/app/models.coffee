App.factory 'Job', ['$resource' , ($resource) ->
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
