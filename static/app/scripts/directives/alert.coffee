'use strict'

controller = (root, scope, sce)->

  root.$watch 'alert', (alert)->
    if alert
      console.log alert
      scope.level = alert.level
      scope.msg = sce.trustAsHtml(alert.msg)    #we'd want to be able to insert html in the msg...

angular.module('wordsApp')
  .directive 'alert', ->
    templateUrl: 'views/directives/alert.html'
    replace: yes
    restrict: 'E'
    scope: on
    controller: ['$rootScope', '$scope', '$sce', controller]
