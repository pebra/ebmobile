
App.controller 'JobController', ['$scope','Job', '$routeParams', '$sce', 'Company', 'merkliste', ($scope, Job, $routeParams, $sce, Company, merkliste)->
  $scope.job = null
  $scope.company = null
  Job.get { id: $routeParams.jobId }, (r)->
    $scope.job = r
    p r


  $scope.html_safe = (string)-> $sce.trustAsHtml(string)
  $scope.on_merkliste = merkliste.isMerked($routeParams.jobId)

  $scope.merk   = (job)->
    merkliste.merk($scope.job)
    $scope.on_merkliste = true
  $scope.unmerk = (job)->
    merkliste.unmerk($scope.job)
    $scope.on_mekliste = false
]