'use strict';

angular.module('wordsApp')
  .directive('wordsgraph', () ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the wordsgraph directive'
  )
