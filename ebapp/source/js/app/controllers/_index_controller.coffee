
App.controller 'IndexController', ($scope, settings, $location, Job)->
  $scope.newest_query = { per: 10 }
  settings.bind($scope)

