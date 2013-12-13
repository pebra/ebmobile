window.App = Ember.Application.create()
App.LSAdapter = DS.LSAdapter.extend(namespace: "ebund")
App.ApplicationAdapter = App.LSAdapter

#App.Store = DS.Store.extend({
#  revision: 12,
#  adapter: 'App.ApplicationAdapter'
#});
App.Search = DS.Model.extend(query: DS.attr())
App.Job = DS.Model.extend(
  job_id: DS.attr()
  firm: DS.attr()
  location: DS.attr()
  title: DS.attr()
  job_link: DS.attr()
  mobile_logo_url: DS.attr()
  favorite: DS.attr()
  description: DS.attr()
)
App.Favorite = DS.Model.extend(job_id: DS.attr())
App.get_api_url = (api_type) ->
  "http://www.empfehlungsbund.de/api/" + api_type + ".jsonp?callback=json_callback"

App.Router.map ->
  @resource "jobs", ->
    @route "job",
      path: ":job_id"


  @resource "search", ->

  @route "favorites"

App.IndexRoute = Ember.Route.extend(redirect: ->
  @transitionTo "search"
)
App.FavoritesRoute = Ember.Route.extend(model: ->
  self = this
  blub = Ember.A()
  found_favs = []
  @store.find("job",
    favorite: "true"
  ).then (favs) ->
    favs.forEach (fav) ->
      found_favs.push fav.id

    url = App.get_api_url("joblist") + "&ids=" + found_favs.toString()
    Ember.$.ajax
      url: url
      dataType: "jsonp"
      success: (jobs) ->
        jobs.map (job) ->
          self.store.find("job", job.id).then (result) ->
            result.set "mobile_logo_url", logo_url
            result.save()




)
App.JobsJobRoute = Ember.Route.extend(
  onList: false
  notification: ""
  model: (params) ->
    console.log "model hook triggered"
    self = this
    self.store.find("job", params.job_id).then (res) ->
      Ember.$.ajax
        url: App.get_api_url("job") + "&id=" + params.job_id
        dataType: "jsonp"
        success: (job) ->
          res.set "description", job.description
          res.save()

      res


  actions:
    addToFavorites: (job) ->
      @store.find("job", job.id).then (job_hit) ->
        job_hit.set "favorite", "true"
        job_hit.save()

      @get("controller").set "notification", "Diese Stelle befindet sich nun auf Ihrer Merkliste."
      @get("controller").set "onList", true
)
App.SearchRoute = Ember.Route.extend(
  query: ""
  actions:
    search: ->
      self = this
      @get("controller").set "jobsResults", ""
      jobs = Ember.A()
      q = @get("controller").get("query")
      url = App.get_api_url("search") + "&radius=100&fid[5]=5&fid[4]=4&q=" + q
      Ember.$.ajax
        url: url
        dataType: "jsonp"
        success: (jobsResults) ->
          jobsResults.forEach (data) ->
            job = self.store.createRecord("job", data)
            job.save()
            jobs.pushObject job

          self.get("controller").set "jobsResults", jobs

      jobs
)
App.SearchJobsRoute = Ember.Route.extend(
  query: ""
  model: ->
    @store.findAll "job"
)
