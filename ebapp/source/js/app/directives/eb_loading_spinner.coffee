App.directive 'ebLoadingSpinner', ($rootScope)->
  {
    restrict: 'E'
    template: '<div class="spinner"></div>'
    replace: true
  }
