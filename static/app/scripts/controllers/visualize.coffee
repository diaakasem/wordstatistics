'use strict'

controller = (scope, params, Service, timeout, http)->

  id = params.id
  scope.id = params.id

  scope.entity = {}

  Service.get id, (d)->
    scope.$apply ->
      scope.entity = d
      load(d)

angular.module('wordsApp')
  .controller 'VisualizeCtrl',
  ['$scope', '$routeParams', 'Texts', '$timeout', '$http', controller]
