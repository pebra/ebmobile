(function() {
  App.directive('ebJobResults', function(settings, Job, merkliste) {
    return {
      restrict: 'E',
      templateUrl: 'html/job_results.html',
      scope: {
        title: '@title',
        queryFunction: '@queryFunction',
        queryParams: '=queryParams',
        paginationEnabled: '@paginationEnabled',
        result: '=result'
      },
      link: function($scope, element, attr) {
        var default_params, func;
        attr.$observe('title', function() {
          return $scope.title = attr.title;
        });
        settings.bind($scope);
        $scope.merk = function(job) {
          return merkliste.merk(job);
        };
        $scope.unmerk = function(job) {
          return merkliste.unmerk(job);
        };
        $scope.on_merkliste = function(job) {
          return merkliste.isMerked(job.id);
        };
        default_params = $scope.default_params();
        func = Job[$scope.queryFunction];
        $scope.search = function(params) {
          var extra_params;
          $scope.loading = true;
          extra_params = $scope.queryParams;
          angular.extend(params, default_params, extra_params);
          return func(params, function(response) {
            var jobs;
            $scope.loading = false;
            jobs = ($scope.jobs || {}).jobs || [];
            $scope.jobs = {
              jobs: jobs.concat(response.jobs),
              length: response.length,
              query: params.q,
              total_pages: response.total_pages,
              current_page: response.current_page,
              next_page: response.current_page < response.total_pages ? response.current_page + 1 : null
            };
            return $scope.$parent.$parent[attr.result] = $scope.jobs;
          });
        };
        $scope.$watch('queryParams', function() {
          return $scope.search({});
        });
        return $scope.showMore = function() {
          return $scope.search({
            page: $scope.jobs.next_page
          });
        };
      }
    };
  });

}).call(this);
