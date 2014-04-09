
App.controller 'JobController', ['$scope','Job', '$routeParams', '$sce', 'Company', 'merkliste','communities', ($scope, Job, $routeParams, $sce, Company, merkliste, communities)->
  $scope.job = null
  $scope.company = null
  Job.get { id: $routeParams.jobId }, (r)->
    $scope.job = r
    communities.all (d)->
      $scope.domain = d[r.domain_name]


  $scope.share = ->
    alert 'share now via old plugin'
    cordova.plugins.SocialShare.share(null, null, { dialogTitle : 'Share', url: 'http://google.com', text: 'wow much amaze'} )
    cordova.plugins.socialsharing.share(null, null, null, 'http://www.stefanwienert.de')

  $scope.html_safe = (string)-> $sce.trustAsHtml(string)
  $scope.on_merkliste = merkliste.isMerked($routeParams.jobId)

  $scope.merk   = (job)->
    merkliste.merk($scope.job)
    $scope.on_merkliste = true
  $scope.unmerk = (job)->
    merkliste.unmerk($scope.job)
    $scope.on_merkliste = false
]
