App.controller 'SettingsController', ['$scope', 'settings', 'geolocation', '$http', '$rootScope', 'notification', ($scope, settings, geolocation, $http, $rootScope, notification)->

  $scope.geolocationInProgress = false
  settings.bind($scope)

  $rootScope.$on 'error', (a,b,c)->
    $scope.geolocationInProgress = false
    notification.info('Position konnte nicht ermittelt werden.')

  $scope.geolocate = ->
    notification.info 'Position wird ermittelt...'
    return if $scope.geolocationInProgress
    $scope.geolocationInProgress = true
    setTimeout ->
      if $scope.geolocationInProgress
        $scope.geolocationInProgress = false
        notification.info 'Position konnte nicht ermittelt werden'
    , 5000
    geolocation.getLocation().then (data)->
      notification.info 'Position wurde ermittelt.'
      $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}
      $scope.geolocationInProgress = false
      $http.jsonp('https://www.empfehlungsbund.de/api/v2/utilities/reverse_geocomplete.jsonp', {params: { lat: data.coords.latitude, lon: data.coords.longitude, callback: 'JSON_CALLBACK', api_key: App.eb_api_key}})
        .success (data)->
          $scope.search_result = { name: "#{data.city}, #{data.state}, #{data.country}" }

  $scope.clear = ->
    $scope.coordinates = {}
    $scope.radius = 50
    $scope.filter_fid = { 4: true, 5: true}
    settings.clear()
    localStorage.clear()
    $rootScope.merkliste = {}
    notification.info "Einstellungen gelöscht!"

  $scope.active = (what)-> $scope.filter_fid[what]
  $scope.toggleFid = (what)->
    $scope.filter_fid[what] = !$scope.filter_fid[what]

  $scope.search = (term)->
    $http.jsonp('https://www.empfehlungsbund.de/api/v2/utilities/geocomplete.jsonp', {params: { q: term, callback: 'JSON_CALLBACK', api_key: App.eb_api_key}})
      .success (data)->
        $scope.search_result = data
        $scope.coordinates = { lat: data.lat, lng: data.lng}
      .error (data)->
        notification.info "#{term} wurde nicht gefunden. Bitte prüfen Sie Ihre Eingabe."
]
