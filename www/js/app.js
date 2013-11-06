App = Ember.Application.create();


App.LSAdapter = DS.LSAdapter.extend({
  namespace: 'ebund'
});

App.ApplicationAdapter = App.LSAdapter;
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
  favorite: DS.attr(),
  description: DS.attr()
});

App.Favorite = DS.Model.extend({
  job_id: DS.attr()
});


App.Router.map(function() {
  this.resource('jobs', function() {
    this.route('job', { path: ':job_id' }) });
  this.resource('search', function() {
  });
  this.route('favorites');
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('search');
  }
});

App.FavoritesRoute = Ember.Route.extend({
  model: function() {
    var self = this;
    var blub = Ember.A();
    var found_favs = [];
    this.store.find('job', {'favorite': 'true'}).then(function(favs) { 
      favs.forEach(function(fav) { 
        found_favs.push(fav.id);
      });

    var url = "http://www.empfehlungsbund.de/api/joblist.jsonp?callback=json_callback&ids=" + found_favs.toString();

    return Ember.$.ajax({
      url: url,
      dataType: 'jsonp',
      success: function(jobs) {
        jobs.map(function(job) {
          self.store.find('job', job.id).then(function(result) {
            var logo_url = "http://" + result.get('mobile_logo_url');
            result.set('mobile_logo_url', logo_url); 
            result.save();
          });
        });
      }
    });
    });
  }
});

App.JobsJobRoute = Ember.Route.extend({
  onList: false,
  notification: '',
  model: function(params) {
    var store = this.store;
    return store.find('job', params.job_id).then(function(res) {
      return Ember.$.ajax({
        url: "http://www.empfehlungsbund.de/api/job.jsonp?callback=json_callback&id=" + params.job_id,
        dataType: 'jsonp',
        success: function(job) {
          res.set('description', job.description);
          res.save();
        }
      });
      return res;
    });
  },

  actions: {
    addToFavorites: function(job) {
      this.store.find('job', job.id).then(function(job_hit) {
        job_hit.set('favorite', 'true');
        job_hit.save();
      });
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
        }
      });
      return jobs;
    }
  }
});

App.SearchJobsRoute = Ember.Route.extend({
  query: '',
  model: function(){
      return this.store.findAll('job');
    }
});

