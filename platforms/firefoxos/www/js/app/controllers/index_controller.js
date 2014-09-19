(function() {
  App.controller('IndexController', function($scope, settings, $location, Job, $q) {
    var _ref;
    $scope.newest_query = {
      per: 10
    };
    settings.bind($scope);
    $scope.new_user = ((_ref = $scope.coordinates) != null ? _ref.lat : void 0) == null;
    if ($scope.new_user) {
      $location.path('/assistent');
      return;
    }
    $scope.lastUsage = today;
    $scope.today = window.today();
    $scope.searchCounts = {};
    return angular.forEach($scope.lastQueries, function(q) {
      var params;
      if (q.date < today) {
        params = {};
        angular.extend(params, $scope.default_params(), {
          q: q.q,
          since: q.date,
          per: 1
        });
        return Job.newest(params).$promise.then(function(response) {
          if (response.length > 0) {
            return $scope.searchCounts[q.q] = response.length;
          }
        });
      }
    });
  });

  window.today = function() {
    return (new Date).toISOString().split('T')[0];
  };

}).call(this);
