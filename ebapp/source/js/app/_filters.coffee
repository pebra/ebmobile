App.filter('encodeURIComponent', ->  window.encodeURIComponent)
App.filter 'reverse', ->
    return (items)-> items.slice().reverse()
App.filter 'unsafe', ($sce)->
  (val)-> return $sce.trustAsHtml(val)
App.filter 'objectLength', ->
  (val)->
    count = 0
    for key of val
      count +=1
    count
