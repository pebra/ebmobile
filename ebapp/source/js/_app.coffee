window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation'])


App.controller 'SearchController', ['$scope','Job', ($scope, Job)->
  $scope.result_pluralize =
    '0': 'kein Suchergebnis'
    '1': 'ein Suchergebnis'
    '2': '{} Suchergebnisse'

  $scope.result = {}
  if $scope.lastQuery
    $scope.query = $scope.lastQuery

  $scope.search = ->
    lastQuery = $scope.query
    params =
      q: $scope.query

    Job.search params, (r)->
      $scope.result =
        query: lastQuery
        current_page: r.current_page
        jobs: r.jobs
        length: r.length
        spellcheck: r.spellcheck
        total_pages: r.total_pages
        facets: r.facets
]

App.controller 'JobController', ['$scope','Job', '$routeParams', '$sce', 'Company', 'merkliste',($scope, Job, $routeParams, $sce, Company, merkliste)->
  $scope.job = null
  $scope.company = null
  Job.get { id: $routeParams.jobId }, (r)->
    $scope.job = r
    Company.get { id: r.company_id, domain_name: r.domain_name }, (r) ->
      $scope.company = r

  $scope.html_safe = (string)-> $sce.trustAsHtml(string)
  $scope.on_merkliste = merkliste.isMerked($routeParams.jobId)

  $scope.merk   = (job)->
    merkliste.merk($scope.job)
    $scope.on_merkliste = true
  $scope.unmerk = (job)->
    merkliste.unmerk($scope.job)
    $scope.on_merkliste = false
]

App.controller 'MerklisteController', ['$scope', 'Job', 'merkliste', ($scope, Job, merkliste)->
  $scope.jobs = merkliste.all()
]

App.controller 'SettingsController', ['$scope', 'storage', 'geolocation', '$sce', ($scope, storage, geolocation, $sce)->
  storage.bind($scope,'radius', defaultValue: 50)
  storage.bind($scope,'coordinates')

  $scope.google_maps_url = ->
    "https://www.google.com/maps/embed?pb=!1m17!1m12!1m3!1d20066.224925335442!2d13.7874678!3d#{$scope.coordinates.lat}!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f#{$scope.coordinates.lng}!3m2!1m1!1s0x0%3A0x0!5e0!3m2!1sde!2sde!4v1394668848740"


  $scope.url_safe = (string)-> $sce.trustAsUrl(string)
  $scope.geolocate = ->
    geolocation.getLocation().then (data)->
      $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}

]

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


App.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
   $routeProvider
     .when '/',
       templateUrl: '/html/search.html'
       controller: 'SearchController'
     .when '/job/:jobId',
       templateUrl: '/html/job.html'
       controller: 'JobController'
     .when '/merkliste',
       templateUrl: '/html/merkliste.html'
       controller: 'MerklisteController'
     .when '/settings',
       templateUrl: '/html/settings.html'
       controller: 'SettingsController'
     .otherwise( redirectTo: '/')
]

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

