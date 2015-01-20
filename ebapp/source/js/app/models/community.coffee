App.factory 'Community', ['$resource', ($resource)->
  $resource Config.api + 'domains.jsonp', null,
    getAll:
      method: 'JSONP'
      isArray: true
      params:
        callback: 'JSON_CALLBACK'
]

