controller = ($scope, service) ->

  onList = (data)->
    $scope.api = data
  
  service.list onList

angular.module('wordsApp')
  .controller 'MainCtrl',
    ['$scope', 'People', controller]
