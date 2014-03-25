App.controller 'SettingsController', ['$scope', 'settings', 'geolocation', '$http', '$rootScope', ($scope, settings, geolocation, $http, $rootScope)->

  settings.bind($scope)

  $scope.geolocate = ->
    geolocation.getLocation().then (data)->
      $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}



  $scope.clear = ->
    $scope.coordinates = {}
    $scope.radius = 50
    $scope.filter_fid_intern = true
    $scope.filter_fid_jobs = true
    settings.clear()
    localStorage.clear()
    $scope.cleared = true
    $rootScope.merkliste = {}

  $scope.search = (term)->
    $http.jsonp('https://www.empfehlungsbund.de/api/v2/utilities/geocomplete.jsonp', {params: { q: term, callback: 'JSON_CALLBACK'}})
      .success (data)->
        $scope.search_result = data
        $scope.coordinates = { lat: data.lat, lng: data.lng}
      .error (data)->
        console.log data
]
