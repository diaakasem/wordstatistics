'use strict'

controller = (root, scope)->

  root.$watch 'alert', (alert)->
    if alert
      console.log alert
      scope.level = alert.level
      scope.msg = alert.msg


angular.module('wordsApp')
  .directive 'alert', ->
    templateUrl: 'views/directives/alert.html'
    replace: yes
    restrict: 'E'
    scope: on
    controller: ['$rootScope', '$scope', controller]
