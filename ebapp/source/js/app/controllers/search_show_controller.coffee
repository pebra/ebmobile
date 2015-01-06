App.controller 'SearchShowController', ['$scope','Job', 'settings', '$location', '$routeParams', 'PushApi', ($scope, Job, settings, $location, $routeParams, PushApi )->
  settings.bind($scope)
  id = parseInt $routeParams.id

  # TODO Fake Reg raus
  fakeRegID = 'APA91bFiDLIUcWdEB7nZiNuCI7cryD1b-l1_UbnhIVF93ls4wFhJXjv8m4pDKZ1WDmpZnaNhzqBz9OVd2OmmTvlmWsHfDx2odulnqxfrT1AtxOJr1ojZAaZAIL3zbyebiPvKPaPfr12mxrEiVijH8rIveRleYH5NyhYQZR2T9s3eBY7iwL1Grq4'
  # PushApi.allSearches { key: fakeRegID }, (searches)->
  PushApi.allSearches (searches)->

    for search in searches
      if search.id == id
        $scope.search = found[0]
        return

    # TODO redirect Startseite, Toast
    true

]
