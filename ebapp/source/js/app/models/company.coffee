App.factory 'Company', ['$resource' , ($resource) ->
  $resource Config.api + 'companies/:id.jsonp', null,
    get:
      method: 'JSONP'
      params:
        callback: 'JSON_CALLBACK'
        api_key: Config.eb_api_key
]
