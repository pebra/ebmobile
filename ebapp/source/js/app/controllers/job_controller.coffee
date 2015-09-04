App.controller 'JobController', ['$scope','Job', '$routeParams', '$sce', 'Company', 'merkliste','communities','sharing', ($scope, Job, $routeParams, $sce, Company, merkliste, communities,sharing)->
  $scope.job_id = $routeParams.jobId
  $scope.job = null
  $scope.company = null
  Job.get { id: $routeParams.jobId }, (r)->
    $scope.job = r
    communities.all (d)->
      $scope.domain = d[r.domain_name]
  .$promise.catch (r)->
    if r.status == 404
      $scope.error = 'Die Stellen ist leider nicht mehr verfügbar.'
    else
      $scope.error = 'Leider ist ein Fehler beim Abruf der Stelle aufgetreten'


  $scope.share = ->
    sharing.shareUrl($scope.job.url, $scope.job.title)

  $scope.html_safe = (string)-> $sce.trustAsHtml(string)
  $scope.on_merkliste = merkliste.isMerked($routeParams.jobId)

  $scope.merk   = (job)->
    merkliste.merk($scope.job)
    $scope.on_merkliste = true
  $scope.unmerk = (job)->
    merkliste.unmerk({ id: $scope.job_id})
    $scope.on_merkliste = false
]
