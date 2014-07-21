(function() {
  App.controller('IndexController', function($scope, settings, $location, Job) {
    var params, q, _i, _len, _ref, _ref1, _results;
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
    _ref1 = $scope.lastQueries;
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      q = _ref1[_i];
      if (q.date < today) {
        params = {};
        angular.extend(params, $scope.default_params(), {
          q: q.q,
          since: q.date,
          per: 1
        });
        _results.push(Job.newest(params, function(response) {
          if (response.length > 0) {
            return $scope.searchCounts[q.q] = response.length;
          }
        }));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  });

  window.today = function() {
    return (new Date).toISOString().split('T')[0];
  };

}).call(this);
