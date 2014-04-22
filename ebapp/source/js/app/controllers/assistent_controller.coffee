App.controller 'AssistentController', ($scope, settings, $location, Job)->
  settings.bind($scope)

  $scope.active = (what)-> $scope.filter_fid[what]
  $scope.toggleFid = (what)->
    $scope.filter_fid[what] = !$scope.filter_fid[what]



