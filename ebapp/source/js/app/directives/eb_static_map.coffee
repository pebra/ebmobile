

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
