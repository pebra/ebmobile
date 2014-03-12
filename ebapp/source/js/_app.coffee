window.App = angular.module('ebmobile', ['ngRoute'])

App.controller 'SearchController', ['$scope', ($scope)->
  if $scope.lastQuery
    $scope.query = $scope.lastQuery

  $scope.search = ->
    $scope.lastQuery = $scope.query
    console.log $scope.query
]


App.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
   $routeProvider
     .when '/',
       templateUrl: '/html/search.html'
       controller: 'SearchController'
     .otherwise( redirectTo: '/')


]
