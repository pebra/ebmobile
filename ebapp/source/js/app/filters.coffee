App.filter('encodeURIComponent', -> return window.encodeURIComponent)
App.filter 'reverse', ->
    return (items)-> items.slice().reverse()
App.filter 'unsafe', ($sce)->
  (val)-> return $sce.trustAsHtml(val)
