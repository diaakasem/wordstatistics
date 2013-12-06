'use strict'

describe 'Service: texts', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  texts = {}
  beforeEach inject (_texts_) ->
    texts = _texts_

  it 'should do something', () ->
    expect(!!texts).toBe true
