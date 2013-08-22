'use strict'

describe 'Service: crud', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  crud = {}
  beforeEach inject (_crud_) ->
    crud = _crud_

  it 'should do something', () ->
    expect(!!crud).toBe true;
