'use strict'
controller = (scope)->

angular.module('wordsApp')
  .directive 'navmenu', ->
    templateUrl: 'views/nav.html'
    restrict: 'E'
    controller: ['$scope', controller]
