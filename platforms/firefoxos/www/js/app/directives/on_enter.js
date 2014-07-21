(function() {
  App.directive("onEnter", function() {
    return {
      link: function(scope, element, attrs) {
        return element.bind("keypress", function(event) {
          if (event.which === 13) {
            scope.$apply(function() {
              return scope.$eval(attrs.onEnter);
            });
            return event.preventDefault();
          }
        });
      }
    };
  });

}).call(this);
