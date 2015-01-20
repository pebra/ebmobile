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

