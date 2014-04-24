window.App = angular.module('ebmobile', ['ngRoute','ngResource','angularLocalStorage','ngCookies', 'geolocation'])

window.p = console.log
window.App.eb_api_key = 'ea1cd4b1e0e0fb9051be08909722744aad35fd82db1b159d58bec144'
App.api = 'https://www.empfehlungsbund.de/api/v2/'
App.run  ($rootScope) ->
  #TODO @peter
  $rootScope.cordova = true
  $rootScope.cordova_type = 'android'


