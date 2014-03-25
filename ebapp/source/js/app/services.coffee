App.factory 'merkliste', (storage, $rootScope)->
  storage.bind($rootScope, 'merkliste', defaultValue: {})
  {
    bind: ($scope)-> false
    all: ->
      for k,v of $rootScope.merkliste
        v
    isMerked: (id)->
      !!$rootScope.merkliste[id]
    merk: (job)->
      $rootScope.merkliste[job.id] = job
    unmerk: (job)->
      delete $rootScope.merkliste[job.id]
  }

App.factory 'communities', ($rootScope, Community) ->
  {
    all: (callback)->
      if $rootScope.communities
        callback($rootScope.communities)
      else
        Community.getAll (data)->
          c = {}
          for comm in data
            c[comm.name] = comm
          $rootScope.communities = c
          callback($rootScope.communities)
  }

App.factory 'settings', (storage, Community)->
  {
    bind: ($scope)->
      storage.bind($scope,'radius', defaultValue: 50)
      storage.bind($scope,'coordinates')
      storage.bind($scope,'lastQuery')
      storage.bind($scope,'filter_fid', defaultValue: { '4': true, '5':true})
      storage.bind($scope,'lastQueries', defaultValue: [])
      $scope.$watch('lastQuery', this.addQuery)
    storage: storage
    addQuery: (newVal,oldVal,scope)->
      return unless newVal?
      return if newVal == ''
      if scope.lastQueries.indexOf(newVal) == -1
        scope.lastQueries.push newVal
      scope.lastQueries = scope.lastQueries[-20..]
    clear: ->
      storage.clearAll()
  }

App.factory 'tags', ($http)->
  {
    get: (callback) ->
      $http({url: 'tags.json', method: 'GET', cache: true}).success (data)-> callback(data)
  }
