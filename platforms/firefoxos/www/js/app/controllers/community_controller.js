(function() {
  App.controller('CommunityController', [
    '$scope', 'communities', '$routeParams', '$location', function($scope, communities, $routeParams, $location) {
      $scope.executeSearch = function() {
        return $scope.query_params = {
          q: $scope.query,
          domain_id: $scope.community.id
        };
      };
      return communities.all(function(d) {
        $scope.community = d[$routeParams.communityName];
        if ($location.search().q != null) {
          $scope.query = $location.search().q;
          $scope.lastQuery = $scope.query;
          return $scope.executeSearch();
        }
      });
    }
  ]);

}).call(this);
