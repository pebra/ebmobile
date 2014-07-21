(function() {
  App.controller('MerklisteController', [
    '$scope', 'Job', 'merkliste', 'sharing', function($scope, Job, merkliste, sharing) {
      $scope.jobs = merkliste.all();
      return $scope.share = function() {
        var job, text, _i, _len, _ref;
        text = "Folgende Stellenanzeigen haben haben Sie in der Empfehlungsbund-App gefunden: \n\n";
        _ref = $scope.jobs;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          job = _ref[_i];
          text += "" + job.title + "\n" + job.company_name + "\n" + job.url + "\n\n";
        }
        text += "\n\nGepostet von der Empfehlungsbund-App (https://play.google.com/store/apps/details?id=de.pludoni.empfehlungsbundmobile)";
        console.log(text);
        return sharing.share({
          text: text,
          subject: "Ihre Merkliste aus der Empfehlungsbund-App (" + $scope.jobs.length + " Jobs)"
        });
      };
    }
  ]);

}).call(this);
