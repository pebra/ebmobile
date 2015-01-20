
App.directive 'ebJobResults', (settings, Job, merkliste)->
  {
    restrict: 'E',
    templateUrl: 'html/job_results.html'
    scope: {
      title: '@title'
      queryFunction: '@queryFunction'
      queryParams: '=queryParams'
      paginationEnabled: '@paginationEnabled'
      result: '=result'
    }
    link: ($scope,element,attr)->
      attr.$observe('title', -> $scope.title = attr.title)
      settings.bind($scope)

      $scope.merk = (job)->
        merkliste.merk(job)
      $scope.unmerk = (job)->
        merkliste.unmerk(job)
      $scope.on_merkliste = (job)->
        merkliste.isMerked(job.id)

      default_params = $scope.default_params()
      func = Job[$scope.queryFunction]

      $scope.search =  (params) ->
        $scope.loading = true
        $scope.error = null
        extra_params = $scope.queryParams

        angular.extend(params, default_params, extra_params)
        func params, (response)->
          $scope.loading = false
          jobs = ($scope.jobs || {}).jobs || []
          $scope.jobs =
            jobs: jobs.concat(response.jobs)
            length: response.length
            query: params.q
            total_pages: response.total_pages
            current_page: response.current_page
            next_page: if response.current_page < response.total_pages then response.current_page + 1 else null
          $scope.$parent.$parent[attr.result] =  $scope.jobs
        , (error)->
          $scope.loading = false
          $scope.error = error

      $scope.$watch 'queryParams', ->
        $scope.search({})
      $scope.tryAgain = ->
        $scope.search({})

      $scope.showMore = ->
        $scope.search({ page:  $scope.jobs.next_page })

  }
