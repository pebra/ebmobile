(function() {
  App.directive('ebLoadingSpinner', function($rootScope) {
    return {
      restrict: 'E',
      template: '<div class="spinner"></div>',
      replace: true
    };
  });

}).call(this);
