(function() {
  App.directive('srcFallback', function(fallbackSrc) {
    return {
      link: function(scope, elem, attrs) {
        return elem.bind('error', function() {
          return angular.element(this).attr("src", attrs.fallbackSrc);
        });
      }
    };
  });

}).call(this);
