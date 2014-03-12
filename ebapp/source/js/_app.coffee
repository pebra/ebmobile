window.App = angular.module('ebmobile', ['ngRoute','ngResource'])


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

App.factory 'merkliste', ->
  liste = {}
  isMerked: (id)->
    !!liste[id]
  merk: (job)->
    liste[job.id] = job
  unmerk: (job) ->
    delete liste[job.id]



App.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
   $routeProvider
     .when '/',
       templateUrl: '/html/search.html'
       controller: 'SearchController'
     .when '/job/:jobId',
       templateUrl: '/html/job.html'
       controller: 'JobController'
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

