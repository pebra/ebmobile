App.controller 'SettingsController', ['$scope', 'settings', '$http', '$rootScope', 'notification', 'SubscribedSearches', ($scope, settings, $http, $rootScope, notification, SubscribedSearches)->
  settings.bind($scope)

  $scope.clear = ->
    $scope.coordinates = {}
    $scope.radius = 50
    $scope.filter_fid = { 4: true, 5: true}
    $scope.portal_types = { it: true, office: true, mint: true}
    settings.clear()
    localStorage.clear()
    $rootScope.merkliste = {}
    notification.info "Einstellungen gelöscht!"

  $scope.activePortalType = (what)->
    $scope.portal_types[what]

  $scope.activeFid = (what)->
    $scope.filter_fid[what]

  $scope.toggleFid = (what)->
    $scope.filter_fid[what] = !$scope.filter_fid[what]

  $scope.togglePt = (what)->
    $scope.portal_types[what] = !$scope.portal_types[what]

  $scope.geoButtonText = "Ort automatisch ermitteln"
  $scope.portal_type_list = [
    {
      title: 'IT - Softwareentwickler und ITler'
      key: 'it'
    }, {
      title: ' MINT - Ingenieure und Techniker',
      key: 'mint'
    }, {
      title: 'OFFICE - Kaufmännische und betriebswirtschaftliche Berufe',
      key: 'office'
    }
  ]
  $scope.search = (term)->
    el = document.getElementsByTagName('input')[0]
    el.focus()
    el.blur()
    $http.jsonp(Config.api + 'utilities/geocomplete.jsonp', {params: { q: term, callback: 'JSON_CALLBACK', api_key: Config.eb_api_key}})
      .success (data)->
        $scope.coordinates = { lat: data.lat, lng: data.lng}
        $scope.coordinates.name = data.name
      .error (data)->
        notification.info "#{term} wurde nicht gefunden. Bitte prüfen Sie Ihre Eingabe."
]
