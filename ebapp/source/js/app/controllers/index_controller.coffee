
App.controller 'IndexController', ($scope, settings, $location, Job, $q)->
  $scope.newest_query = { per: 10 }
  settings.bind($scope)
  $scope.new_user = !$scope.coordinates?.lat?
  if $scope.new_user
    $location.path('/assistent')
    return

  $scope.lastUsage = today
  $scope.today = window.today()

  $scope.searchCounts = {}
  angular.forEach $scope.lastQueries, (q) ->
    if q.date < today
      params={}
      angular.extend(params, $scope.default_params(), { q: q.q, since: q.date, per: 1})
      Job.newest(params).$promise.then (response)->
        if response.length > 0
          $scope.searchCounts[q.q] = response.length

window.today = -> (new Date).toISOString().split('T')[0]
