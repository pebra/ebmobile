(function() {
  App.directive('ebNavbar', function($rootScope) {
    return {
      restrict: 'E',
      templateUrl: 'html/navbar.html',
      replace: true
    };
  });

}).call(this);
