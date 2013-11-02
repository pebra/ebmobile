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
  job_link: DS.attr(),
  mobile_logo_url: DS.attr(),
  favorite: DS.attr()
});

App.Favorite = DS.Model.extend({
  job_id: DS.attr()
});


App.Router.map(function() {
  this.resource('jobs', function() {
    this.route('job', { path: ':job_id' }) });
  this.resource('search', function() {
    this.route('jobs');
  });
  this.route('favorites');
});

App.IndexRoute = Ember.Route.extend({
  beforeModel: function() {
    this.transitionTo('search');
  }
});

App.FavoritesRoute = Ember.Route.extend({
  model: function() {
    App.store = this.store;
    var self = this;
    App.favs = Ember.A();

    App.favids = this.store.findAll('favorite');//.map(function(fav) { return fav.get('job_id')});
    var url = "http://www.empfehlungsbund.de/api/joblist.jsonp?callback=json_callback&ids="
    Ember.$.ajax({
      url: url,
      dataType: 'jsonp',
      success: function(jobs) {
        console.log(jobs);
        jobs.map(function(job) {
          job.job_id = job.id;
          job.mobile_log_url = "http://" + job.mobile_logo_url;
          console.log("JAB" + job.id);
          App.favs.pushObject(App.store.createRecord('job', job));
          console.log(url);
        });
        return jobs; 
      }
    });
    return App.favs;
  }
});

App.JobsJobRoute = Ember.Route.extend({
  onList: false,
  notification: '',
  model: function(params) {
    var store = this.store;
    var id = params.job_id;
    var foundJob = '';
    return Ember.$.ajax({
      url: "http://www.empfehlungsbund.de/api/job.jsonp?callback=json_callback&id=" +id,
      dataType: 'jsonp',
      success: function(job) {
        foundJob = store.find('job', { job_id: job.id});
      }
    });
  },

  actions: {
    addToFavorites: function(job_id) {
      this.store.find('job', {job_id: job_id}).set('favorite', true);
      this.get('controller').set('notification', 'Diese Stelle befindet sich nun auf Ihrer Merkliste.');
      this.get('controller').set('onList', true);
    }
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
            var job = self.store.createRecord('job', data);
            job.save();
            jobs.pushObject(job);
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

