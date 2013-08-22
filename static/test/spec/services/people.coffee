'use strict'

describe 'Service: people', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  people = {}
  beforeEach inject (_people_) ->
    people = _people_

  it 'should do something', () ->
    expect(!!people).toBe true;
