App.controller 'MerklisteController', ['$scope', 'Job', 'merkliste', 'sharing', ($scope, Job, merkliste, sharing)->
  $scope.jobs = merkliste.all()
  $scope.share = ->
    text = "Merkliste: \n\n"
    for job in $scope.jobs
      text += """
      #{job.title}
      #{job.company_name}
      #{job.url}
      
      
      """
    text += "\n"

    sharing.share
      text: text
      subject: "Ihre Merkliste aus der Empfehlungsbund-App (#{$scope.jobs.length} Jobs)"
]
