
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
      scope.has_match = false
      scope.search =  ->
        if scope.query? and scope.query != ''
          scope.lastQuery = scope.query
        else
          scope.query = ''
        target = attr.target || '/search'
        $location.path(target).search('q', scope.query)

      scope.title = attr.title || "Suchbegriff"

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
        scope.has_match = false
        for tag in scope.autocomplete_tags
          if word and word.length > 0
            if tag.name.toLowerCase().indexOf(word.toLowerCase()) != -1
              tag.match_string = before_words.join(' ') + ' ' + tag.name
              tag.display = before_words.join(' ') + ' ' + tag.name.replace(word.toLowerCase(), "<strong>#{word}</strong>")
              tag.matched = true
              scope.has_match = true
            else
              tag.match_string = ''
              tag.matched = false
          else
            tag.match_string = ''
            tag.matched = false
        scope.autocomplete_tags = scope.autocomplete_tags
  }
