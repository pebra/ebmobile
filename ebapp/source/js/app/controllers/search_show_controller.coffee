App.controller 'SearchShowController', ['$scope','Job', 'settings', '$location', '$routeParams', 'PushApi', 'SubscribedSearches', 'notification', ($scope, Job, settings, $location, $routeParams, PushApi, SubscribedSearches, notification )->
  settings.bind($scope)
  id = parseInt $routeParams.id

  $scope.remove_search = (search)->
    SubscribedSearches.unsubscribe search, ->
      $location.path('/')
      notification.info "Suche gelöscht"
  $scope.active = (what)-> $scope.filter_fid[what]

  PushApi.allSearches (searches)->

    for search in searches
      if search.id == id
        $scope.search = search #found[0]
        return

    true

]
