App = Ember.Application.create();

App.ApplicationAdapter = DS.LSAdapter.extend({
  namespace: 'ebund'
});

//App.Store = DS.Store.extend({
//  revision: 12,
//  adapter: 'App.ApplicationAdapter'
//});

App.Search = DS.Model.extend({
  query: DS.attr()
});


App.Job = DS.Model.extend({
  job_id: DS.attr(),
  firm: DS.attr(),
  location: DS.attr(),
  title: DS.attr(),
  link: DS.attr(),
  mobile_logo_url: DS.attr()
});

App.Router.map(function() {
  this.resource('jobs', function() {
    this.route('job', { path: ':job_id' }) });
  this.resource('search', function() {
    this.route('jobs');
  });
});

App.IndexRoute = Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('search');
  }
});

App.JobsJobRoute = Ember.Route.extend({
  model: function(params) {
    var store = this.store;
    //http://www.empfehlungsbund.de/api/job.jsonp?callback=json_callback&id
    var id = params.job_id;
    return Ember.$.ajax({
      url: "http://www.empfehlungsbund.de/api/job.jsonp?callback=json_callback&id=" +id,
      dataType: 'jsonp',
      success: function(job) {
        console.log(job);
        job.job_id = job.id;
        job.mobile_log_url = "http://" + job.mobile_logo_url;
        return job
      }
    });
  }
});


App.SearchRoute = Ember.Route.extend({
  query: '',
  actions: {
    search: function(){
      var self = this;
      this.get('controller').set('jobsResults','');
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
          self.get('controller').set('jobsResults', jobs);
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

