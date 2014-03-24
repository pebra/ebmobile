App.controller 'CompanyController', ['$scope', '$routeParams', 'Company', 'communities', ($scope, $routeParams,Company,communities) ->
    communities.all (c)->
      $scope.communities = c

    Company.get { id: $routeParams.CompanyId}, (r) ->
      $scope.company = r

      $scope.query_params = {
        user_name: r.user_name
      }
]
