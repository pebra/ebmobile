App.controller 'CommunityController', [ '$scope','communities','$routeParams', '$location', ($scope,communities,$routeParams,$location) ->
  $scope.executeSearch = ->
    $scope.query_params = { q: $scope.query, domain_id: $scope.community.id }
  communities.all (d)->
    $scope.community = d[$routeParams.communityName]

    if $location.search().q?
      $scope.query = $location.search().q
      $scope.lastQuery = $scope.query
      $scope.executeSearch()

]

