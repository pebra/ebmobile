App.controller 'GcmCtrl', ['$scope','Device','PushService', '$http','PushApi','SubscribedSearches', '$rootScope', 'settings', ($scope,Device,PushService,$http,PushApi,SubscribedSearches, $rootScope, settings) ->
  regId = PushService.getRegId()
  if regId == null
    notification.info "Es gab einen Fehler bei der Kommunikation mit Google, das abonnieren der Suchen ist daher deaktiviert"
  $scope.showSubscribeButton = ->
    # Device.isAndroid() &&
    $scope.query_params? && SubscribedSearches.is_subscribed($scope.query) && regId?
  settings.bind($scope)

  $scope.register = ->
    default_params = $scope.default_params()
    extra_params = $scope.$parent.query_params
    params = {}
    angular.extend(params, default_params, extra_params)
    if device?
      PushApi.addDeviceKey {key: regId, device: device.model}, (response)->
        PushApi.addSearch { search: params }, (response) ->
          SubscribedSearches.getAll()
    else
      PushApi.addSearch { search: params }, (response) ->
        SubscribedSearches.getAll()
]
