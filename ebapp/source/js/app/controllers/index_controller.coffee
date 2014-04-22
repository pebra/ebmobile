
App.controller 'IndexController', ($scope, settings, $location, Job)->
  $scope.newest_query = { per: 10 }
  settings.bind($scope)
  $scope.new_user = !$scope.coordinates?.lat?
  if $scope.new_user
    $location.path('/assistent')


