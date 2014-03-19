window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation', 'autocomplete'])

window.p = console.log

App.factory 'merkliste', (storage, $rootScope)->
  storage.bind($rootScope, 'merkliste', defaultValue: {})
  {
    bind: ($scope)->
      storage.bind($scope, 'merkliste', defaultValue: {})
    all: ->
      for k,v of $rootScope.merkliste
        v
    isMerked: (id)->
      !!$rootScope.merkliste[id]
    merk: (job)->
      $rootScope.merkliste[job.id] = job
    unmerk: (job)->
      delete $rootScope.merkliste[job.id]

  }

App.factory 'settings', (storage)->
  {
    bind: ($scope)->
      storage.bind($scope,'radius', defaultValue: 50)
      storage.bind($scope,'coordinates')
      storage.bind($scope,'lastQuery')
      storage.bind($scope,'lastQueries', defaultValue: [])
      $scope.$watch('lastQuery', this.addQuery)
    addQuery: (newVal,oldVal,scope)->
      if scope.lastQueries.indexOf(newVal) == -1
        scope.lastQueries.push newVal
      scope.lastQueries = scope.lastQueries[-20..]
  }

App.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
   $routeProvider
     .when '/',
       templateUrl: 'html/index.html'
       controller: 'IndexController'
     .when '/search',
       templateUrl: 'html/search.html'
       controller: 'SearchController'
     .when '/job/:jobId',
       templateUrl: 'html/job.html'
       controller: 'JobController'
     .when '/company/:CompanyId',
       templateUrl: 'html/company.html'
       controller: 'CompanyController'
     .when '/merkliste',
       templateUrl: 'html/merkliste.html'
       controller: 'MerklisteController'
     .when '/settings',
       templateUrl: 'html/settings.html'
       controller: 'SettingsController'
     # .otherwise( redirectTo: '/')
]
App.factory 'tags', ($http)->
  {
    get: (callback) ->
      $http({url: 'tags.json', method: 'GET', cache: true}).success (data)-> callback(data)
  }

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
]

App.factory 'Company', ['$resource' , ($resource) ->
  $resource 'https://www.empfehlungsbund.de/api/v2/companies/:id.jsonp', null,
    get:
      method: 'JSONP'
      params:
        callback: 'JSON_CALLBACK'
]

