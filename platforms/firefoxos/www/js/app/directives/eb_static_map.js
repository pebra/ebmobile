(function() {
  App.directive('ebStaticMap', function() {
    var map, osmUrl, radiusCircle;
    map = null;
    radiusCircle = null;
    osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    return {
      restrict: 'A',
      link: function(scope, element, attr) {
        var coords, fn, osm, radius, rerender;
        radius = function() {
          return parseInt(scope.$eval(attr.radius)) * 1000;
        };
        coords = function() {
          return [scope.$eval(attr.lat), scope.$eval(attr.lng)];
        };
        osm = new L.TileLayer(osmUrl, {
          attribution: 'Map data © OpenStreetMap contributors'
        });
        map = L.map(element[0], {
          zoomControl: false
        });
        map.scrollWheelZoom.disable();
        map.dragging.disable();
        map.touchZoom.disable();
        map.doubleClickZoom.disable();
        map.boxZoom.disable();
        map.keyboard.disable();
        radiusCircle = null;
        if (map.tap) {
          map.tap.disable();
        }
        map.addLayer(osm);
        rerender = function() {
          var c, r, zoom;
          r = radius();
          c = coords();
          if (!radiusCircle) {
            radiusCircle = L.circle(c, r, {
              color: 'blue',
              fillColor: '#22e',
              fillOpacity: 0.4
            }).addTo(map);
          } else {
            if (r > 0) {
              radiusCircle.setRadius(r);
            }
            radiusCircle.setLatLng(c);
          }
          zoom = (function() {
            switch (false) {
              case !(r < 10):
                return 10;
              case !(r < 50000):
                return 9;
              case !(r < 70000):
                return 8;
              case !(r < 150000):
                return 7;
              case !(r < 300000):
                return 6;
              case !(r <= 500000):
                return 5;
              case !(r >= 500000):
                return 4;
            }
          })();
          return map.setView(c, zoom);
        };
        fn = $.throttle(rerender, 300, null, true);
        scope.$watch(attr.radius, function(newVal, oldVal) {
          return fn();
        });
        return scope.$watch(attr.lat, function(newVal, oldVal) {
          return fn();
        });
      }
    };
  });

}).call(this);
