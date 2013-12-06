'use strict'

describe 'Controller: DocumentCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  DocumentCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DocumentCtrl = $controller 'DocumentCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
