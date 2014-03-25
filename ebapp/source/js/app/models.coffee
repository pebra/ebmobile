App.factory 'Job', ['$resource' , ($resource) ->
  $resource 'https://www.empfehlungsbund.de/api/v2/jobs/:id.jsonp', null,
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
      url: 'https://www.empfehlungsbund.de/api/v2/jobs/lists/newest.jsonp'
      params:
        callback: 'JSON_CALLBACK'
]


App.factory 'Company', ['$resource' , ($resource) ->
  $resource 'https://www.empfehlungsbund.de/api/v2/companies/:id.jsonp', null,
    get:
      method: 'JSONP'
      params:
        callback: 'JSON_CALLBACK'
]

App.factory 'Community', ['$resource', ($resource)->
  $resource 'https://www.empfehlungsbund.de/api/v2/domains.jsonp', null,
    getAll:
      method: 'JSONP'
      isArray: true
      params:
        callback: 'JSON_CALLBACK'
]
