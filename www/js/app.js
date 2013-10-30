App = Ember.Application.create();
App.ApplicationAdapter = DS.LSAdapter.extend({
  namespace: 'ebmobile'
});

App.Store = DS.Store.extend({
  revision: 12,
  adapter: 'DS.LSAdapter'
});

App.Search = DS.Model.extend({
  query: DS.attr()
});


App.Job = DS.Model.extend({
  job_id: DS.attr(),
  firm: DS.attr(),
  location: DS.attr(),
  title: DS.attr(),
  mobile_logo_url: DS.attr()
});

App.Router.map(function() {
  this.resource('search', function() {
    this.route('jobs');
  });
});

App.IndexRoute = Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('search');
  }
});


App.SearchRoute = Ember.Route.extend({
  query: '',
  actions: {
    search: function(){
      var self = this;
      var jobs = Ember.A();
      var q = this.get('controller').get('query');
      Ember.$.ajax({
        url: "http://www.empfehlungsbund.de/api/search.jsonp?callback=json_callback&o=&radius=100&fid[5]=5&fid[4]=4&q=" +q,
        dataType: 'jsonp',
        success: function(jobsResults) {
          var san = jobsResults.map(function(set) { set.job_id = set.id; set.mobile_logo_url = "http://" + set.mobile_logo_url; return set; });
          san.forEach(function(data) {
            jobs.pushObject(self.store.createRecord('job', data));
          });
          self.get('controller').set('jobsResults', self.store.findAll('job'));
          return jobs;
        }
      });
    }
  }
});

App.SearchJobsRoute = Ember.Route.extend({
  query: '',
  model: function(){
      return this.store.findAll('job');
    }
});
