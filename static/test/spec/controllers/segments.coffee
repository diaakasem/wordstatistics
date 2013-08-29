'use strict'

describe 'Controller: SegmentsCtrl', () ->

  # load the controller's module
  beforeEach module 'wordsApp'

  SegmentsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SegmentsCtrl = $controller 'SegmentsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
