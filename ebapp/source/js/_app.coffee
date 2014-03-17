window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation'])


App.controller 'SearchController', ['$scope','Job', 'storage', ($scope, Job, storage)->
  storage.bind($scope,'radius', defaultValue: 50)
  storage.bind($scope,'coordinates')
  storage.bind($scope,'lastQuery')

  $scope.result_pluralize =
    '0': 'kein Suchergebnis'
    '1': 'ein Suchergebnis'
    '2': '{} Suchergebnisse'

  $scope.result = {}
  if $scope.lastQuery
    $scope.query = $scope.lastQuery

  $scope.search = ->
    $scope.lastQuery = $scope.query
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

App.controller 'SettingsController', ['$scope', 'storage', 'geolocation', '$http', '$rootScope', ($scope, storage, geolocation, $http)->
  api_key = '31b5f3bb8c82493ca2445018f20a3d59'
  storage.bind($scope,'radius', defaultValue: 50)
  storage.bind($scope,'coordinates')

  $scope.geolocate = ->
    geolocation.getLocation().then (data)->
      $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}

  $scope.search = (term)->
    $http.jsonp('https://www.empfehlungsbund.de/api/v2/utilities/geocomplete.jsonp', {params: { q: term, callback: 'JSON_CALLBACK'}})
      .success (data)->
        $scope.search_result = data
        $scope.coordinates = { lat: data.lat, lng: data.lng}
      .error (data)->
        console.log data
  $scope.updateMap = ->
    if $scope.coordinates?.lat?
      if !$scope.map
        osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
        osm = new L.TileLayer(osmUrl, { attribution: 'Map data © OpenStreetMap contributors' })
        map = L.map('map')
        $scope.radiusCircle = L.circle([$scope.coordinates.lat,$scope.coordinates.lng], 10000, {
          color: 'blue',
          fillColor: '#22e',
          fillOpacity: 0.4
        }).addTo(map)
        map.addLayer(osm)
        $scope.map = map
      radius = parseInt($scope.radius) * 1000
      zoom = switch
        when radius < 10 then 10
        when radius < 50000 then 9
        when radius < 100000 then 8
        when radius < 200000 then 7
        when radius < 500000 then 6
        when radius >= 500000 then 4
      $scope.map.setView([$scope.coordinates.lat, $scope.coordinates.lng], zoom)

      if radius > 0
        $scope.radiusCircle.setRadius radius
      $scope.radiusCircle.setLatLng([$scope.coordinates.lat, $scope.coordinates.lng])


  $scope.updateMap()
  $scope.$watch('radius', $scope.updateMap)
  $scope.$watch('coordinates', $scope.updateMap)
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

