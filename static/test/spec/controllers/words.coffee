'use strict'

describe 'Controller: WordsCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  WordsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    WordsCtrl = $controller 'WordsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
