controller = ($scope) ->
  $scope.apis = [
  ]
angular.module('wordsApp')
  .controller 'MainCtrl',
    ['$scope', controller]
