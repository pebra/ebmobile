App.directive 'ebLocationForm', ($rootScope, $http, notification, geolocation) ->
  {
    restrict: 'E'
    templateUrl: 'html/location_form.html'
    link: ($scope,element,attr)->
      $scope.geolocationInProgress = false
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
          $http.jsonp(App.api + 'utilities/reverse_geocomplete.jsonp', {params: { lat: data.coords.latitude, lon: data.coords.longitude, callback: 'JSON_CALLBACK', api_key: App.eb_api_key}})
            .success (data)->
              $scope.coordinates.name = "#{data.city}, #{data.state}, #{data.country}"

  }
