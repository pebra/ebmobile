
App.directive 'ebStaticMap', ->
  map = null
  radiusCircle = null
  osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  {
    restrict: 'A'
    link: (scope, element, attr) ->
      radius = -> parseInt(scope.$eval(attr.radius)) * 1000
      coords = -> [ scope.$eval(attr.lat), scope.$eval(attr.lng) ]

      osm = new L.TileLayer(osmUrl, { attribution: 'Map data © OpenStreetMap contributors' })
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
          when r < 50000 then 9 # 50km
          when r < 70000 then 8
          when r < 150000 then 7
          when r < 300000 then 6
          when r <= 500000 then 5
          when r >= 500000 then 4
        map.setView(c, zoom)

      fn = $.throttle(rerender, 300, null, true) #[timeout], [callback], [delayed], [trailing]);
      scope.$watch attr.radius, (newVal,oldVal)-> fn()
      scope.$watch attr.lat, (newVal,oldVal)-> fn()
  }

App.directive 'ebLoadingSpinner', ($rootScope)->
  {
    restrict: 'E'
    template: '<div class="spinner"></div>'
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
      scope.has_match = false
      scope.search =  ->
        if scope.query? and scope.query != ''
          scope.lastQuery = scope.query
        else
          scope.query = ''
        target = attr.target || '/search'
        $location.path(target).search('q', scope.query)

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

App.directive 'ebJobResults', (settings, Job, merkliste)->
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

      $scope.merk = (job)->
        merkliste.merk(job)
      $scope.unmerk = (job)->
        merkliste.unmerk(job)
      $scope.on_merkliste = (job)->
        merkliste.isMerked(job.id)

      default_params = $scope.default_params()
      func = Job[$scope.queryFunction]

      $scope.search =  (params) ->
        $scope.loading = true
        extra_params = $scope.queryParams

        angular.extend(params, default_params, extra_params)
        func params, (response)->
          $scope.loading = false
          jobs = ($scope.jobs || {}).jobs || []
          $scope.jobs =
            jobs: jobs.concat(response.jobs)
            length: response.length
            query: params.q
            total_pages: response.total_pages
            current_page: response.current_page
            next_page: if response.current_page < response.total_pages then response.current_page + 1 else null
          $scope.$parent.$parent[attr.result] =  $scope.jobs

      $scope.$watch 'queryParams', ->
        $scope.search({})

      $scope.showMore = ->
        $scope.search({ page:  $scope.jobs.next_page })

  }

App.run  ($rootScope) ->
  #TODO @peter
  $rootScope.cordova = true
  $rootScope.cordova_type = 'android'

