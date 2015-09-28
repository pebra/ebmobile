App.factory 'settings', (storage, Community)->
  {
    bind: ($scope) ->
      storage.bind($scope,'radius', defaultValue: 50)
      storage.bind($scope,'coordinates')
      storage.bind($scope,'lastQuery')
      storage.bind($scope,'lastUsage')
      storage.bind($scope,'filter_fid', defaultValue: { '4': true, '5':true})
      storage.bind($scope,'portal_types', defaultValue: { 'it': true, 'office':true, 'mint':true})
      storage.bind($scope,'min_score', default_value: 3.0)
      storage.bind($scope,'lastQueries', defaultValue: [])
      # $scope.$watch('lastQuery', this.addQuery)
      $scope.default_params = ->
        default_params =
          lat: $scope.coordinates.lat
          lon: $scope.coordinates.lng
          radius: $scope.radius
          min_score: 3.0

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
        add('min_score', $scope.min_score)
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
        scope.lastQueries.unshift { q: newVal, date: today }
      scope.lastQueries = scope.lastQueries[-20..]

    clear: -> storage.clearAll()
  }
