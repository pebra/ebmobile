App.directive "onEnter", ->
  link: (scope, element, attrs) ->
    element.bind "keypress", (event) ->
      if event.which is 13
        scope.$apply ->
          scope.$eval attrs.onEnter
        event.preventDefault()

