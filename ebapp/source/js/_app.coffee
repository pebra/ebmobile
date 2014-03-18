window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation', 'autocomplete'])

window.p = console.log

App.directive 'searchForm', ($location, tags) ->
  autocomplete_tags = []
  tags.get (data)->
    for e in data
      autocomplete_tags.push {
        name: e
        matched: false
      }
  {
    restrict: 'E'
    templateUrl: 'html/search_form.html'
    link: (scope,element,attr)->
      scope.search =  ->
        scope.lastQuery = scope.query
        $location.path("/search").search('q', scope.query)

      scope.autocomplete_tags = autocomplete_tags
      scope.tag_match = (tag)-> tag.matched
      scope.select_autocomplete = (tag)->
        scope.query = tag.match_string
        for tag in scope.autocomplete_tags
          tag.matched = false


      scope.autocomplete = ->
        words = scope.query.split(' ')
        word = words[words.length - 1]
        before_words = words[0...words.length - 1]
        console.log before_words
        if word and word.length > 1
          for tag in scope.autocomplete_tags
            if tag.name.toLowerCase().indexOf(word.toLowerCase()) != -1
              tag.match_string = before_words.join(' ') + ' ' + tag.name
              tag.matched = true
            else
              tag.match_string = ''
              tag.matched = false
          scope.autocomplete_tags = scope.autocomplete_tags
  }

App.filter('encodeURIComponent', -> return window.encodeURIComponent)
App.filter 'reverse', ->
    return (items)-> items.slice().reverse()

App.factory 'merkliste', ->
  localStorage.merkliste = {} unless localStorage.liste
  isMerked: (id)->
    !!localStorage["merkliste-#{id}"]
  merk: (job)->
    localStorage["merkliste-#{job.id}"] = JSON.stringify(job)
  unmerk: (job) ->
    delete localStorage["merkliste-#{job.id}"]
  all: ->
    result = []
    $.each(localStorage, (a,b)->
      result.push(JSON.parse(b)) if /^merkliste-/.test(a))
    result

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

