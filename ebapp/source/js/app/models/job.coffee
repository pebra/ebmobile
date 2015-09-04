App.factory 'Job', ['$resource', ($resource) ->
  $resource Config.api + 'jobs/:id.jsonp', null,
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
      url: Config.api + 'jobs/lists/newest.jsonp'
      params:
        callback: 'JSON_CALLBACK'
    insider:
      method: 'JSONP'
      url: Config.api + 'jobs/lists/insider.jsonp'
      params:
        callback: 'JSON_CALLBACK'
]
