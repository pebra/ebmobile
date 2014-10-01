(function() {
  App.controller('JobController', [
    '$scope', 'Job', '$routeParams', '$sce', 'Company', 'merkliste', 'communities', 'sharing', function($scope, Job, $routeParams, $sce, Company, merkliste, communities, sharing) {
      $scope.job_id = $routeParams.jobId;
      $scope.job = null;
      $scope.company = null;
      Job.get({
        id: $routeParams.jobId
      }, function(r) {
        $scope.job = r;
        return communities.all(function(d) {
          return $scope.domain = d[r.domain_name];
        });
      }).$promise["catch"](function(r) {
        if (r.status === 404) {
          return $scope.error = 'Die Stellen ist leider nicht mehr verfügbar.';
        } else {
          return $scope.error = 'Leider ist ein Fehler beim Abruf der Stelle aufgetreten';
        }
      });
      $scope.share = function() {
        return sharing.shareUrl($scope.job.url, $scope.job.title);
      };
      $scope.html_safe = function(string) {
        return $sce.trustAsHtml(string);
      };
      $scope.on_merkliste = merkliste.isMerked($routeParams.jobId);
      $scope.merk = function(job) {
        merkliste.merk($scope.job);
        return $scope.on_merkliste = true;
      };
      return $scope.unmerk = function(job) {
        merkliste.unmerk({
          id: $scope.job_id
        });
        return $scope.on_merkliste = false;
      };
    }
  ]);

}).call(this);
