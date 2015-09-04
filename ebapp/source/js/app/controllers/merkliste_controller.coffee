App.controller 'MerklisteController', ['$scope', 'Job', 'merkliste', 'sharing', ($scope, Job, merkliste, sharing)->
  $scope.jobs = merkliste.all()

  $scope.share = ->
    text = "Folgende Stellenanzeigen habe ich in der Empfehlungsbund-App gefunden: \n\n"
    for job in $scope.jobs
      text += """
      #{job.title}
      #{job.company_name}
      #{job.url}


      """
    text += "\n\nGepostet von der Empfehlungsbund-App (https://play.google.com/store/apps/details?id=de.pludoni.empfehlungsbundmobile)"

    sharing.share
      text: text
      subject: "Ihre Merkliste aus der Empfehlungsbund-App (#{$scope.jobs.length} Jobs)"
]
