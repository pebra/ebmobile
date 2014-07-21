(function() {
  App.directive('ebLocationForm', function($rootScope, $http, notification, geolocation, $timeout) {
    return {
      restrict: 'E',
      templateUrl: 'html/location_form.html',
      link: function($scope, element, attr) {
        $scope.geolocationInProgress = false;
        $scope.switchToLocationSettings = function() {
          var err, suc;
          suc = err = function() {
            return true;
          };
          return diagnostic.switchToLocationSettings(suc, err);
        };
        $rootScope.$on('error', function(a, b, c) {
          $scope.geolocationInProgress = false;
          $scope.geolocationError = true;
          $scope.geoButtonText = "Ort automatisch ermitteln";
          return notification.info('Position konnte nicht ermittelt werden.');
        });
        return $scope.geolocate = function() {
          notification.info('Position wird ermittelt...');
          if ($scope.geolocationInProgress) {
            return;
          }
          $scope.geolocationInProgress = true;
          $scope.geoButtonText = "bitte warten";
          $timeout(function() {
            if ($scope.geolocationInProgress) {
              $scope.geolocationInProgress = false;
              $scope.geolocationError = true;
              notification.info('Position konnte nicht ermittelt werden');
              return $scope.geoButtonText = "Ort automatisch ermitteln";
            }
          }, 10000);
          return geolocation.getLocation().then(function(data) {
            $scope.geoButtonText = "Ort automatisch ermitteln";
            $scope.coordinates = {
              lat: data.coords.latitude,
              lng: data.coords.longitude
            };
            $scope.geolocationInProgress = false;
            $scope.geolocationError = false;
            return $http.jsonp(App.api + 'utilities/reverse_geocomplete.jsonp', {
              params: {
                lat: data.coords.latitude,
                lon: data.coords.longitude,
                callback: 'JSON_CALLBACK',
                api_key: App.eb_api_key
              }
            }).success(function(data) {
              $scope.coordinates.name = "" + data.city + ", " + data.state + ", " + data.country;
              return notification.info("Position wurde ermittelt: " + $scope.coordinates.name);
            });
          });
        };
      }
    };
  });

}).call(this);
