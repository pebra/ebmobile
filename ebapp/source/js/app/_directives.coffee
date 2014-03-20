App.directive 'ebStaticMap', ->
  map = null
  radiusCircle = null
  osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  osm = new L.TileLayer(osmUrl, { attribution: 'Map data © OpenStreetMap contributors' })
  {
    restrict: 'A'
    link: (scope, element, attr) ->
      radius = -> parseInt(scope.$eval(attr.radius)) * 1000
      coords = -> [ scope.$eval(attr.lat), scope.$eval(attr.lng) ]
      el = element.find('div')
      map = L.map(element[0], {zoomControl:false})
      map.scrollWheelZoom.disable()
      map.dragging.disable()
      map.touchZoom.disable()
      map.doubleClickZoom.disable()
      map.boxZoom.disable()
      map.keyboard.disable()
      radiusCircle = null
      if map.tap
        map.tap.disable()
      map.addLayer(osm)

      rerender = ->
        r = radius()
        c = coords()
        if !radiusCircle
          radiusCircle = L.circle(c, r, {
            color: 'blue',
            fillColor: '#22e',
            fillOpacity: 0.4
          }).addTo(map)
        else
          radiusCircle.setRadius(r) if r > 0
          radiusCircle.setLatLng(c)
        zoom = switch
          when r < 10 then 10
          when r < 50000 then 9
          when r < 100000 then 8
          when r < 200000 then 7
          when r < 500000 then 6
          when r >= 500000 then 4
        map.setView(c, zoom)

      scope.$watch attr.radius, (newVal,oldVal)-> rerender()
      scope.$watch attr.lat, (newVal,oldVal)-> rerender()
  }

App.directive 'ebLoadingSpinner', ($rootScope)->
  {
    restrict: 'E'
    template: '<div class="loading"><div class="outer"></div><div class="inner"></div></div>'
    replace: true
  }
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

App.directive 'ebJobResults', (settings, Job)->
  {
    restrict: 'E',
    templateUrl: 'html/job_results.html'
    scope: {
      title: '@title'
      queryFunction: '@queryFunction'
      queryParams: '=queryParams'
      paginationEnabled: '@paginationEnabled'
      result: '=result'
    }
    link: ($scope,element,attr)->
      attr.$observe('title', -> $scope.title = attr.title)
      settings.bind($scope)

      default_params = { lat: $scope.coordinates.lat, lon: $scope.coordinates.lng, radius: $scope.radius}
      func = Job[$scope.queryFunction]
      $scope.$watch 'queryParams', ->
        $scope.loading = true
        extra_params = $scope.queryParams
        params = {}
        angular.extend(params, default_params, extra_params)
        func params, (response)->
          $scope.loading = false
          $scope.jobs =
            jobs: response.jobs
            length: response.length
            query: params.q
            total_pages: response.total_pages
            current_page: response.current_page
            next_page: if response.current_page < response.total_pages then response.current_page + 1 else null
          $scope.$parent.$parent[attr.result] =  $scope.jobs

      $scope.showMore = ->
        $scope.loading = true
        extra_params = $scope.queryParams
        params = {}
        angular.extend(params, default_params, extra_params)
        params.page = $scope.jobs.next_page
        func params, (response)->
          $scope.loading = false
          $scope.jobs =
            jobs: Array.concat($scope.jobs, response.jobs)
            length: response.length
            query: params.q
            total_pages: response.total_pages
            current_page: response.current_page
            next_page: if response.current_page < response.total_pages then response.current_page + 1 else null
          $scope.$parent.$parent[attr.result] =  $scope.jobs

  }
