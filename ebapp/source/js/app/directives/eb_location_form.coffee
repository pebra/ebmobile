App.directive 'ebLocationForm', ($rootScope, $http, notification, geolocation) ->
  {
    restrict: 'E'
    templateUrl: 'html/location_form.html'
    link: ($scope,element,attr)->
      $scope.geolocationInProgress = false
      $scope.switchToLocationSettings = ->
        suc = err = -> true
        diagnostic.switchToLocationSettings suc, err

      $rootScope.$on 'error', (a,b,c)->
        $scope.geolocationInProgress = false
        $scope.geolocationError = true
        notification.info('Position konnte nicht ermittelt werden.')

      $scope.geolocate = ->
        # e.blur()
        notification.info 'Position wird ermittelt...'
        return if $scope.geolocationInProgress
        $scope.geolocationInProgress = true
        setTimeout ->
          if $scope.geolocationInProgress
            $scope.geolocationInProgress = false
            $scope.geolocationError = true
            notification.info 'Position konnte nicht ermittelt werden'
        , 10000
        geolocation.getLocation().then (data)->
          notification.info 'Position wurde ermittelt.'
          $scope.coordinates = {lat: data.coords.latitude, lng: data.coords.longitude}

          $scope.geolocationInProgress = false
          $scope.geolocationError = false
          $http.jsonp(App.api + 'utilities/reverse_geocomplete.jsonp', {params: { lat: data.coords.latitude, lon: data.coords.longitude, callback: 'JSON_CALLBACK', api_key: App.eb_api_key}})
            .success (data)->
              $scope.coordinates.name = "#{data.city}, #{data.state}, #{data.country}"

  }
