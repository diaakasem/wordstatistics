'use strict'

describe 'Controller: UploadCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  UploadCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    UploadCtrl = $controller 'UploadCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
