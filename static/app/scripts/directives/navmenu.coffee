'use strict'
controller = (root, scope)->

  scope.signout = ->
    Parse.User.logOut()
    delete root.user
    root.go '/'


angular.module('wordsApp')
  .directive 'navmenu', ->
    templateUrl: 'views/directives/nav.html'
    replace: yes
    restrict: 'E'
    scope: on
    controller: ['$rootScope', '$scope', controller]
