'use strict'

describe 'Controller: UploadWordsCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  UploadWordsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    UploadWordsCtrl = $controller 'UploadWordsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
