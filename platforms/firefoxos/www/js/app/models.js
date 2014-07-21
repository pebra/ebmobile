(function() {
  App.factory('Job', [
    '$resource', function($resource) {
      return $resource(App.api + 'jobs/:id.jsonp', null, {
        get: {
          method: 'JSONP',
          params: {
            callback: 'JSON_CALLBACK'
          }
        },
        search: {
          method: 'JSONP',
          params: {
            id: 'search',
            callback: 'JSON_CALLBACK'
          }
        },
        newest: {
          method: 'JSONP',
          url: App.api + 'jobs/lists/newest.jsonp',
          params: {
            callback: 'JSON_CALLBACK'
          }
        }
      });
    }
  ]);

  App.factory('Company', [
    '$resource', function($resource) {
      return $resource(App.api + 'companies/:id.jsonp', null, {
        get: {
          method: 'JSONP',
          params: {
            callback: 'JSON_CALLBACK',
            api_key: App.eb_api_key
          }
        }
      });
    }
  ]);

  App.factory('Community', [
    '$resource', function($resource) {
      return $resource(App.api + 'domains.jsonp', null, {
        getAll: {
          method: 'JSONP',
          isArray: true,
          params: {
            callback: 'JSON_CALLBACK'
          }
        }
      });
    }
  ]);

}).call(this);
