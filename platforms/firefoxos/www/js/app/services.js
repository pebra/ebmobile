(function() {
  App.factory('merkliste', function(storage, $rootScope) {
    storage.bind($rootScope, 'merkliste', {
      defaultValue: {}
    });
    return {
      bind: function($scope) {
        return false;
      },
      all: function() {
        var k, v, _ref, _results;
        _ref = $rootScope.merkliste;
        _results = [];
        for (k in _ref) {
          v = _ref[k];
          _results.push(v);
        }
        return _results;
      },
      isMerked: function(id) {
        return !!$rootScope.merkliste[id];
      },
      merk: function(job) {
        return $rootScope.merkliste[job.id] = job;
      },
      unmerk: function(job) {
        return delete $rootScope.merkliste[job.id];
      }
    };
  });

  App.factory('communities', function($rootScope, Community) {
    return {
      all: function(callback) {
        if ($rootScope.communities) {
          return callback($rootScope.communities);
        } else {
          return Community.getAll(function(data) {
            var c, comm, _i, _len;
            c = {};
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              comm = data[_i];
              c[comm.name] = comm;
            }
            $rootScope.communities = c;
            return callback($rootScope.communities);
          });
        }
      }
    };
  });

  App.factory('settings', function(storage, Community) {
    return {
      bind: function($scope) {
        storage.bind($scope, 'radius', {
          defaultValue: 50
        });
        storage.bind($scope, 'coordinates');
        storage.bind($scope, 'lastQuery');
        storage.bind($scope, 'lastUsage');
        storage.bind($scope, 'filter_fid', {
          defaultValue: {
            '4': true,
            '5': true
          }
        });
        storage.bind($scope, 'portal_types', {
          defaultValue: {
            'it': true,
            'office': true,
            'mint': true
          }
        });
        storage.bind($scope, 'lastQueries', {
          defaultValue: []
        });
        return $scope.default_params = function() {
          var add, default_params, true_vals;
          default_params = {
            lat: $scope.coordinates.lat,
            lon: $scope.coordinates.lng,
            radius: $scope.radius
          };
          true_vals = function(ar) {
            var bool, value, values;
            values = [];
            for (value in ar) {
              bool = ar[value];
              if (bool) {
                values.push(value);
              }
            }
            return values;
          };
          add = function(key, array) {
            var values;
            values = true_vals(array);
            if (values.length > 0) {
              return default_params[key] = values.join(',');
            }
          };
          add('fid', $scope.filter_fid);
          add('portal_types', $scope.portal_types);
          return default_params;
        };
      },
      storage: storage,
      addQuery: function(newVal, oldVal, scope) {
        var found, i, q, today, _i, _len, _ref;
        if (newVal == null) {
          return;
        }
        if (newVal === '') {
          return;
        }
        found = false;
        _ref = scope.lastQueries;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          q = _ref[i];
          if (q.q === newVal) {
            scope.lastQueries[i].date = window.today();
            found = true;
          }
        }
        if (!found) {
          today = window.today();
          scope.lastQueries.push({
            q: newVal,
            date: today
          });
        }
        return scope.lastQueries = scope.lastQueries.slice(-20);
      },
      clear: function() {
        return storage.clearAll();
      }
    };
  });

  App.factory('tags', function($http) {
    return {
      get: function(callback) {
        return $http({
          url: 'tags.json',
          method: 'GET',
          cache: true
        }).success(function(data) {
          return callback(data);
        });
      }
    };
  });

  App.factory('sharing', function() {
    return {
      share: function(message) {
        return window.socialmessage.send(message);
      },
      shareUrl: function(url, title) {
        var message;
        message = {
          subject: title,
          url: url
        };
        return window.socialmessage.send(message);
      }
    };
  });

  App.factory('notification', function() {
    return {
      info: function(msg) {
        var _ref;
        if ((_ref = window.plugins) != null ? _ref.toast : void 0) {
          return window.plugins.toast.showShortBottom(msg);
        } else {
          return console.log(msg);
        }
      }
    };
  });

}).call(this);
