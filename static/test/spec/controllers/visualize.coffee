'use strict'

describe 'Controller: VisualizeCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  VisualizeCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    VisualizeCtrl = $controller 'VisualizeCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
