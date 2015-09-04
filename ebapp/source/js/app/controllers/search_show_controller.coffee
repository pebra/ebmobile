App.controller 'SearchShowController', ['$scope','Job', 'settings', '$location', '$routeParams', 'PushApi', 'SubscribedSearches', 'notification', ($scope, Job, settings, $location, $routeParams, PushApi, SubscribedSearches, notification )->

  settings.bind($scope)
  id = parseInt($routeParams.id)

  $scope.active = (what)-> $scope.filter_fid[what]

  $scope.run_search = ->
    window.location = '#/search?q=' + encodeURIComponent($scope.search.params.q)
  $scope.change_search = -> $location.path("/searches/#{$scope.search.id}/edit")
  $scope.remove_search = (search)->
    SubscribedSearches.unsubscribe search, ->
      $location.path('/')
      notification.info "Suche gelöscht"

  $scope.tryAgain = ->
    $scope.error = null
    PushApi.findSearch id, (search)->
      $scope.search = search
    , (error) ->
      $scope.error = true
  $scope.tryAgain()
]
