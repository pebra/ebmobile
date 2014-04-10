App.controller 'CompanyController', ['$scope', '$routeParams', 'Company', 'communities', 'sharing', ($scope, $routeParams, Company, communities, sharing) ->
    communities.all (c)->
      $scope.communities = c

    Company.get { id: $routeParams.CompanyId}, (r) ->
      $scope.company = r

      $scope.query_params = {
        user_name: r.user_name
      }
    # $scope.share = ->
    #   p $scope.company
    #   sharing.shareUrl($scope.job.url, $scope.job.title)
]
