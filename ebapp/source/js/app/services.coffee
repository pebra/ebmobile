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
      storage.bind($scope,'lastUsage')
      storage.bind($scope,'filter_fid', defaultValue: { '4': true, '5':true})
      storage.bind($scope,'portal_types', defaultValue: { 'it': true, 'office':true, 'mint':true})
      storage.bind($scope,'lastQueries', defaultValue: [])
      # $scope.$watch('lastQuery', this.addQuery)
      $scope.default_params = ->
        default_params =
          lat: $scope.coordinates.lat
          lon: $scope.coordinates.lng
          radius: $scope.radius

        true_vals = (ar)->
          values = []
          for value,bool of ar
            values.push(value) if bool
          values
        add = (key,array)->
          values = true_vals(array)
          if values.length > 0
            default_params[key] = values.join(',')

        add('fid', $scope.filter_fid)
        add('portal_types', $scope.portal_types)
        default_params

    storage: storage
    addQuery: (newVal,oldVal,scope)->
      return unless newVal?
      return if newVal == ''
      found = false
      for q,i in scope.lastQueries
        if q.q == newVal
          scope.lastQueries[i].date = window.today()
          found = true

      if !found
        today = window.today()
        scope.lastQueries.push { q: newVal, date: today }

      scope.lastQueries = scope.lastQueries[-20..]

    clear: -> storage.clearAll()
  }

App.factory 'tags', ($http)->
  {
    get: (callback) ->
      $http({url: 'tags.json', method: 'GET', cache: true}).success (data)-> callback(data)
  }

App.factory 'sharing', ->
  {
    # message = {
    #   subject: "Test Subject",
    #   text: "This is a test message",
    #   url: "http://ilee.co.uk"
    # }
    share: (message)->
      window.socialmessage.send(message)

    shareUrl: (url, title)->
      message = {
        subject: title
        url: url
      }
      window.socialmessage.send(message)

  }
App.factory 'notification', ->
  {
    info: (msg)->
      if window.plugins?.toast
        window.plugins.toast.showShortBottom(msg)
      else
        console.log(msg)
  }
