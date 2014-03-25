App.controller 'SearchController', ['$scope','Job', 'settings', '$location','tags', ($scope, Job, settings, $location, tags)->
  settings.bind($scope)

  $scope.result_pluralize =
    '0': 'kein Suchergebnis'
    '1': 'ein Suchergebnis'
    '2': '{} Suchergebnisse'
  $scope.result = {}

  $scope.executeSearch = ->
    $scope.query_params = { q: $scope.query }
    $scope.lastQuery = $scope.query

  if $location.search().q?
    $scope.query = $location.search().q
    $scope.lastQuery = $scope.query
    $scope.executeSearch()
  else if $scope.lastQuery
    $scope.query = $scope.lastQuery

    tags.get (data)->
      $scope.tags = data
]
