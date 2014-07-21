(function() {
  App.filter('encodeURIComponent', function() {
    return window.encodeURIComponent;
  });

  App.filter('reverse', function() {
    return function(items) {
      return items.slice().reverse();
    };
  });

  App.filter('dateFormat', function() {
    return function(date_string) {
      var parts;
      parts = date_string.split('-');
      return parts.reverse().join('.');
    };
  });

  App.filter('unsafe', function($sce) {
    return function(val) {
      return $sce.trustAsHtml(val);
    };
  });

  App.filter('objectLength', function() {
    return function(val) {
      var count, key;
      count = 0;
      for (key in val) {
        count += 1;
      }
      return count;
    };
  });

}).call(this);
