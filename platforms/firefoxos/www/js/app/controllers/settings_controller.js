(function() {
  App.controller('SettingsController', [
    '$scope', 'settings', '$http', '$rootScope', 'notification', function($scope, settings, $http, $rootScope, notification) {
      settings.bind($scope);
      $scope.clear = function() {
        $scope.coordinates = {};
        $scope.radius = 50;
        $scope.filter_fid = {
          4: true,
          5: true
        };
        $scope.portal_types = {
          it: true,
          office: true,
          mint: true
        };
        settings.clear();
        localStorage.clear();
        $rootScope.merkliste = {};
        return notification.info("Einstellungen gelöscht!");
      };
      $scope.active = function(what) {
        return $scope.filter_fid[what];
      };
      $scope.activePortalType = function(what) {
        return $scope.portal_types[what];
      };
      $scope.toggleFid = function(what) {
        return $scope.filter_fid[what] = !$scope.filter_fid[what];
      };
      $scope.togglePt = function(what) {
        return $scope.portal_types[what] = !$scope.portal_types[what];
      };
      $scope.geoButtonText = "Ort automatisch ermitteln";
      $scope.portal_type_list = [
        {
          title: 'IT - Softwareentwickler und ITler',
          key: 'it'
        }, {
          title: ' MINT - Ingenieure und Techniker',
          key: 'mint'
        }, {
          title: 'OFFICE - Kaufmännische und betriebswirtschaftliche Berufe',
          key: 'office'
        }
      ];
      return $scope.search = function(term) {
        var el;
        el = document.getElementsByTagName('input')[0];
        el.focus();
        el.blur();
        return $http.jsonp(App.api + 'utilities/geocomplete.jsonp', {
          params: {
            q: term,
            callback: 'JSON_CALLBACK',
            api_key: App.eb_api_key
          }
        }).success(function(data) {
          $scope.coordinates = {
            lat: data.lat,
            lng: data.lng
          };
          return $scope.coordinates.name = data.name;
        }).error(function(data) {
          return notification.info("" + term + " wurde nicht gefunden. Bitte prüfen Sie Ihre Eingabe.");
        });
      };
    }
  ]);

}).call(this);
