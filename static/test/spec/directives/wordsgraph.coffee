'use strict'

describe 'Directive: wordsgraph', () ->

  # load the directive's module
  beforeEach module 'wordsApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<wordsgraph></wordsgraph>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the wordsgraph directive'
