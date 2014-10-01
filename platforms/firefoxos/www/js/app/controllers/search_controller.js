(function() {
  App.controller('SearchController', [
    '$scope', 'Job', 'settings', '$location', 'tags', function($scope, Job, settings, $location, tags) {
      settings.bind($scope);
      $scope.result_pluralize = {
        '0': 'kein Suchergebnis',
        '1': 'ein Suchergebnis',
        '2': '{} Suchergebnisse'
      };
      $scope.result = {};
      $scope.executeSearch = function() {
        $scope.query_params = {
          q: $scope.query
        };
        $scope.lastQuery = $scope.query;
        return settings.addQuery($scope.query, null, $scope);
      };
      if ($location.search().q != null) {
        $scope.query = $location.search().q;
        return $scope.executeSearch();
      } else if ($scope.lastQuery) {
        $scope.query = $scope.lastQuery;
        return tags.get(function(data) {
          return $scope.tags = data;
        });
      }
    }
  ]);

}).call(this);
