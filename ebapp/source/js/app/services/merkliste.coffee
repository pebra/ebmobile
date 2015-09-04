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

