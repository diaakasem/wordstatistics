controller = ($scope, service) ->

  onList = (data)->
    $scope.people = people
  
  service.list onList

angular.module('wordsApp')
  .controller 'MainCtrl',
    ['$scope', 'People', controller]
