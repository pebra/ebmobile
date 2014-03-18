App.controller 'SearchController', ['$scope','Job', 'settings', '$location','tags', ($scope, Job, settings, $location, tags)->
  settings.bind($scope)

  $scope.result_pluralize =
    '0': 'kein Suchergebnis'
    '1': 'ein Suchergebnis'
    '2': '{} Suchergebnisse'

  $scope.result = {}

  $scope.executeSearch = ->
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
