'use strict'

describe 'Controller: PasswordresetCtrl', ->

  # load the controller's module
  beforeEach module 'wordsApp'

  PasswordresetCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PasswordresetCtrl = $controller 'PasswordresetCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
