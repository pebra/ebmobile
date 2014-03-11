window.App = Ember.Application.create()
App.LSAdapter = DS.LSAdapter.extend(namespace: "ebund")
App.ApplicationAdapter = App.LSAdapter

#App.Store = DS.Store.extend({
#  revision: 12,
#  adapter: 'App.ApplicationAdapter'
#});
App.Search = DS.Model.extend(query: DS.attr())
App.Job = DS.Model.extend(
  job_id:           DS.attr()
  firm:             DS.attr()
  location:         DS.attr()
  title:            DS.attr()
  job_link:         DS.attr()
  mobile_logo_url:  DS.attr()
  favorite:         DS.attr()
  description:      DS.attr()
  firm_id:          DS.attr()

  getCompany: (callback)->
    maybe_company = this.store.getById('company', this.get('firm_id'))
    if maybe_company?
      callback maybe_company
    else
      Ember.$.ajax
        url: App.get_api_url("firm")
        data:
          id: this.get('firm_id')
        dataType: "jsonp"
        success: (data)=>
          company = this.store.createRecord("company", data)
          company.save()
          callback company

)

App.Company = DS.Model.extend(
  company_id:         DS.attr()
  name:               DS.attr()
  username:           DS.attr()
  'firm-logo-url':    DS.attr()
  description:        DS.attr()
  statement:          DS.attr()
  contact:            DS.attr()
  contact_image_url:  DS.attr()
)

App.Settings = DS.Model.extend(
  radius: DS.attr()
  city: DS.attr()
  internships: DS.attr()
  jobs: DS.attr()
)
App.Favorite = DS.Model.extend(job_id: DS.attr())
App.get_api_url = (api_type) ->
  "https://www.empfehlungsbund.de/api/" + api_type + ".jsonp?callback=json_callback"

App.Router.map ->
  @resource "jobs", ->
    @route "job", path: ":job_id"
  @resource "settings", ->
  @resource "search", ->

  @route "favorites"

App.IndexRoute = Ember.Route.extend(redirect: ->
  @transitionTo "search"
)

App.SettingsRoute = Ember.Route.extend(
  model: ->
    @store.find("settings")
  actions:
    submitSettings: (model) ->
      console.log(model.get("radius"))
)

App.FavoritesRoute = Ember.Route.extend(
  model: ->
    self = this
    found_favs = []
    @store.find("job",
      favorite: true
    ).then (favs) ->
      favs.forEach (fav) ->
        found_favs.push fav.id

      url = App.get_api_url("joblist") + "&ids=" + found_favs.toString()
      spinnerplugin.show()
      Ember.$.ajax
        url: url
        dataType: "jsonp"
        success: (jobs) ->
          spinnerplugin.hide()
          jobs.map (job) ->
            self.store.find("job", job.id).then (result) ->
              result.set "mobile_logo_url", logo_url
              result.save()
)
App.JobsJobRoute = Ember.Route.extend
  onList: false
  company: null
  model: (params) ->
    console.log "model hook triggered"
    self = this
    self.store.find("job", params.job_id).then (res) ->
      if !res.get('description')?
        spinnerplugin.show()
        Ember.$.ajax
          url: App.get_api_url("job") + "&id=" + params.job_id
          dataType: "jsonp"
          success: (job) ->
            spinnerplugin.hide()
            res.set "description", job.description
            res.set "firm_id", job.firm_id
            res.save()
      res.getCompany (company)->
        self.get('controller').set('company', company)
        console.log company
      res
  actions:
    addToFavorites: (job) ->
      @store.find("job", job.id).then (job_hit) ->
        job_hit.set "favorite", true
        job_hit.save()
    removeFromFavorites: (job) ->
      console.log job
      job.set "favorite", false
      job.save()

App.SearchRoute = Ember.Route.extend
  query: ""
  actions:
    search: ->
      self = this
      @get("controller").set "jobsResults", ""
      jobs = Ember.A()
      q = @get("controller").get("query")
      Ember.$.ajax
        url: App.get_api_url("search")
        dataType: "jsonp"
        data:
          q: q
          radius: 100
          "fid[4]": 4
          "fid[5]": 5

        success: (jobsResults) ->
          jobsResults.forEach (data) ->
            maybe_job = self.store.getById('Job', data.id)
            if maybe_job
              console.log "Alter Job gefunden: #{data.id}"
              job = maybe_job
              self.store.update('Job', data)
              jobs.pushObject job
            else
              console.log "Neuer Job gefunden: #{data.id}"
              job = self.store.creaeRecord("job", data)
              job.save()
              jobs.pushObject job

          self.get("controller").set "jobsResults", jobs
      jobs

App.SearchJobsRoute = Ember.Route.extend(
  query: ""
  model: ->
    @store.findAll "job"
)

App.SearchField = Ember.TextField.extend(
  classNames: ["input-text"]
  insertNewline: (query) ->
    this.triggerAction()
)

Ember.Handlebars.helper 'truncate', (str, len) ->
  if (str.length > len)
    return str.substring(0, len - 3) + '...'
  else
    return str
