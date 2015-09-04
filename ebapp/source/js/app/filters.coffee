App.filter('encodeURIComponent', ->  window.encodeURIComponent)
App.filter 'reverse', ->
    return (items)-> items.slice().reverse()
App.filter 'dateFormat', ->
    return (date_string) ->
      parts = date_string.split('-')
      parts.reverse().join('.')
App.filter 'unsafe', ($sce)->
  (val)-> return $sce.trustAsHtml(val)

App.filter 'searchTitle', ->
  (search)->
    params = search.params
    t = "\"#{params.q}\""
    if params.location
      t += " im Umkreis #{params.radius}km um #{params.location}"
    t

App.filter 'objectLength', ->
  (val)->
    count = 0
    for key of val
      count +=1
    count
