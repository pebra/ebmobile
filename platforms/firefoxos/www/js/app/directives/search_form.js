(function() {
  App.directive('searchForm', function($location, tags) {
    var autocomplete_tags;
    autocomplete_tags = [];
    tags.get(function(data) {
      var e, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        e = data[_i];
        _results.push(autocomplete_tags.push({
          name: e,
          matched: false
        }));
      }
      return _results;
    });
    return {
      restrict: 'E',
      templateUrl: 'html/search_form.html',
      link: function(scope, element, attr) {
        scope.has_match = false;
        scope.search = function() {
          var target;
          if ((scope.query != null) && scope.query !== '') {
            scope.lastQuery = scope.query;
          } else {
            scope.query = '';
          }
          target = attr.target || '/search';
          return $location.path(target).search('q', scope.query);
        };
        scope.title = attr.title || "Suchbegriff";
        scope.autocomplete_tags = autocomplete_tags;
        scope.tag_match = function(tag) {
          return tag.matched;
        };
        scope.select_autocomplete = function(tag) {
          var _i, _len, _ref;
          scope.query = tag.match_string.replace(/^ *| *$/g, '');
          _ref = scope.autocomplete_tags;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tag = _ref[_i];
            tag.matched = false;
          }
          return false;
        };
        return scope.autocomplete = function() {
          var before_words, tag, word, words, _i, _len, _ref;
          words = scope.query.split(' ');
          word = words[words.length - 1];
          before_words = words.slice(0, words.length - 1);
          scope.has_match = false;
          _ref = scope.autocomplete_tags;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tag = _ref[_i];
            if (word && word.length > 0) {
              if (tag.name.toLowerCase().indexOf(word.toLowerCase()) !== -1) {
                tag.match_string = before_words.join(' ') + ' ' + tag.name;
                tag.display = before_words.join(' ') + ' ' + tag.name.replace(word.toLowerCase(), "<strong>" + word + "</strong>");
                tag.matched = true;
                scope.has_match = true;
              } else {
                tag.match_string = '';
                tag.matched = false;
              }
            } else {
              tag.match_string = '';
              tag.matched = false;
            }
          }
          return scope.autocomplete_tags = scope.autocomplete_tags;
        };
      }
    };
  });

}).call(this);
