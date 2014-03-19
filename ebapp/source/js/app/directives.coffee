App.directive 'ebNavbar', ($rootScope)->
  {
    restrict: 'E'
    templateUrl: 'html/navbar.html'
    replace: true
  }
App.directive 'searchForm', ($location, tags) ->
  autocomplete_tags = []
  tags.get (data)->
    for e in data
      autocomplete_tags.push {
        name: e
        matched: false
      }
  {
    restrict: 'E'
    templateUrl: 'html/search_form.html'
    link: (scope,element,attr)->
      scope.search =  ->
        scope.lastQuery = scope.query
        $location.path("/search").search('q', scope.query)

      scope.autocomplete_tags = autocomplete_tags
      scope.tag_match = (tag)-> tag.matched

      scope.select_autocomplete = (tag)->
        scope.query = tag.match_string.replace(/^ *| *$/g, '')
        for tag in scope.autocomplete_tags
          tag.matched = false
        false


      scope.autocomplete = ->
        words = scope.query.split(' ')
        word = words[words.length - 1]
        before_words = words[0...words.length - 1]
        if word and word.length > 0
          for tag in scope.autocomplete_tags
            if tag.name.toLowerCase().indexOf(word.toLowerCase()) != -1
              tag.match_string = before_words.join(' ') + ' ' + tag.name
              tag.display = before_words.join(' ') + ' ' + tag.name.replace(word.toLowerCase(), "<strong>#{word}</strong>")
              tag.matched = true
            else
              tag.match_string = ''
              tag.matched = false
          scope.autocomplete_tags = scope.autocomplete_tags
  }

