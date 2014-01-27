'use strict'

describe 'Controller: UploadsUploadsCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  UploadsUploadsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    UploadsUploadsCtrl = $controller 'UploadsUploadsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
