
App.controller 'JobController', ['$scope','Job', '$routeParams', '$sce', 'Company', 'merkliste','communities','sharing', ($scope, Job, $routeParams, $sce, Company, merkliste, communities,sharing)->
  $scope.job = null
  $scope.company = null
  Job.get { id: $routeParams.jobId }, (r)->
    $scope.job = r
    communities.all (d)->
      $scope.domain = d[r.domain_name]


  $scope.share = ->
    sharing.shareUrl($scope.job.url, $scope.job.title)

  $scope.html_safe = (string)-> $sce.trustAsHtml(string)
  $scope.on_merkliste = merkliste.isMerked($routeParams.jobId)

  $scope.merk   = (job)->
    merkliste.merk($scope.job)
    $scope.on_merkliste = true
  $scope.unmerk = (job)->
    merkliste.unmerk($scope.job)
    $scope.on_merkliste = false
]
