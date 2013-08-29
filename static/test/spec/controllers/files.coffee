'use strict'

describe 'Controller: FilesCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  FilesCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    FilesCtrl = $controller 'FilesCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
