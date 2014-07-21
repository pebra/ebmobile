(function() {
  App.controller('CompanyController', [
    '$scope', '$routeParams', 'Company', 'communities', 'sharing', function($scope, $routeParams, Company, communities, sharing) {
      communities.all(function(c) {
        return $scope.communities = c;
      });
      return Company.get({
        id: $routeParams.CompanyId
      }, function(r) {
        $scope.company = r;
        return $scope.query_params = {
          user_name: r.user_name
        };
      });
    }
  ]);

}).call(this);
