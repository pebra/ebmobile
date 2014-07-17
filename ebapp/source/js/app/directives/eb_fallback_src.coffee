App.directive 'srcFallback', (fallbackSrc) ->
  {
    link: (scope, elem, attrs) ->
      elem.bind('error', ->
        angular.element(this).attr("src", attrs.fallbackSrc)
      )
  }
