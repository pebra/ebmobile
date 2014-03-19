App.controller 'SearchController', ['$scope','Job', 'settings', '$location','tags', ($scope, Job, settings, $location, tags)->
  settings.bind($scope)

  $scope.result_pluralize =
    '0': 'kein Suchergebnis'
    '1': 'ein Suchergebnis'
    '2': '{} Suchergebnisse'

  $scope.result = {}

  $scope.executeSearch = ->
    $scope.loading = true
    params =
      q: $scope.query
    if $scope.coordinates
      params.lat = $scope.coordinates.lat
      params.lon = $scope.coordinates.lng
      params.radius = $scope.radius

    Job.search params, (r)->
      $scope.result =
        query: $scope.lastQuery
        current_page: r.current_page
        jobs: r.jobs
        length: r.length
        spellcheck: r.spellcheck
        total_pages: r.total_pages
        facets: r.facets
      $scope.loading = false

  if $location.search().q?
    $scope.query = $location.search().q
    $scope.lastQuery = $scope.query
    $scope.executeSearch()
  else if $scope.lastQuery
    $scope.query = $scope.lastQuery

    tags.get (data)->
      $scope.tags = data
]
App.controller 'IndexController', ($scope, settings, $location)->
  settings.bind($scope)
  $scope.autocomplete_result = ['Ruby','Java']
  $scope.autocomplete = (q)->
    # $scope.autocomplete_result = ['Ruby', 'Java']

App.controller 'JobController', ['$scope','Job', '$routeParams', '$sce', 'Company', 'merkliste', ($scope, Job, $routeParams, $sce, Company, merkliste)->
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

App.controller 'SettingsController', ['$scope', 'settings', 'geolocation', '$http', '$rootScope', ($scope, settings, geolocation, $http)->
  settings.bind($scope)

  $scope.geolocate = ->
    geolocation.getLocation().then (data)->
      $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}

  $scope.clear = ->
    localStorage.clear()
    $scope.cleared = true

  $scope.search = (term)->
    $http.jsonp('https://www.empfehlungsbund.de/api/v2/utilities/geocomplete.jsonp', {params: { q: term, callback: 'JSON_CALLBACK'}})
      .success (data)->
        $scope.search_result = data
        $scope.coordinates = { lat: data.lat, lng: data.lng}
      .error (data)->
        console.log data
]

