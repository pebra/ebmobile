window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation', 'angulartics', 'angulartics.google.analytics', 'angulartics.google.analytics.cordova']).config(
  ['$compileProvider', ($compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|file|mailto|tel|app|chrome-extension):/)
  ])

App.api = 'https://www.empfehlungsbund.de/api/v2/'
App.run  ($rootScope, $location, trackingId, PushApi) ->
  #TODO @peter
  $rootScope.cordova = true
  $rootScope.cordova_type = 'android'

  if $rootScope.regId?
    PushApi.allSearches (searches)->
      $rootScope.subscribedSearches = searches

  # $rootScope.$on '$viewContentLoaded', (event)->
  #   console.log $location.path()
  #   window._gaq.push ['_trackPageview', $location.path()]


App.constant('trackingId', 'UA-6810907-13')

