App.directive 'ebLocationForm', ($rootScope, $http, notification, geolocation, $timeout) ->
  {
    restrict: 'E'
    templateUrl: 'html/location_form.html'
    link: ($scope,element,attr) ->
      $scope.geolocationInProgress = false
      $scope.switchToLocationSettings = ->
        suc = err = -> true
        diagnostic.switchToLocationSettings suc, err

      $rootScope.$on 'error', (a,b,c)->
        $scope.geolocationInProgress = false
        $scope.geolocationError = true
        $scope.geoButtonText = "Ort automatisch ermitteln"
        notification.info('Position konnte nicht ermittelt werden.')

      $scope.geolocate = ->
        notification.info 'Position wird ermittelt...'
        return if $scope.geolocationInProgress
        $scope.geolocationInProgress = true
        $scope.geoButtonText = "bitte warten"
        $timeout ->
          if $scope.geolocationInProgress
            $scope.geolocationInProgress = false
            $scope.geolocationError = true
            notification.info 'Position konnte nicht ermittelt werden'
            $scope.geoButtonText = "Ort automatisch ermitteln"
        , 10000

        geolocation.getLocation().then (data)->
          $scope.geoButtonText = "Ort automatisch ermitteln"
          $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}

          $scope.geolocationInProgress = false
          $scope.geolocationError = false
          $http.jsonp(App.api + 'utilities/reverse_geocomplete.jsonp', {params: { lat: data.coords.latitude, lon: data.coords.longitude, callback: 'JSON_CALLBACK', api_key: App.eb_api_key}})
            .success (data)->
              $scope.coordinates.name = "#{data.city}, #{data.state}, #{data.country}"
              notification.info "Position wurde ermittelt: #{$scope.coordinates.name}"
  }
